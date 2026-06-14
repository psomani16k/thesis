# Implementation Plan: Receive Buffer Pre-division (RBP) for MPTCP

## Context

The paper "Receive Buffer Pre-division Based Flow Control for MPTCP" (Han et al., 2018) proposes a sender-side flow control mechanism that divides the shared receive buffer among subflows proportionally to estimated buffer occupancy, then applies per-subflow flow control. This reduces out-of-order buffering and improves throughput under asymmetric path conditions — directly relevant to the thesis on forward-delay-aware scheduling.

Currently, all MPTCP subflows share a single `meta_tp->rcv_wnd`. Subflows compete for buffer space, and a slow subflow can cause head-of-line blocking that wastes buffer and hurts throughput. RBP addresses this by giving each subflow its own `rwnd_i` budget.

---

## Approach: New Scheduler Module with Two Variants

Implement RBP as a new scheduler module `mptcp_rbp.c`, following the existing pattern of `mptcp_wt_dly.c` and `mptcp_rr.c`. The scheduler's `next_segment()` callback enforces per-subflow send limits via the `*limit` output parameter — no changes to `mptcp_output.c` needed.

**Two scheduler variants** will be registered:
- `--sch=rbp` — RBP flow control + **min-RTT** subflow selection (matches the paper)
- `--sch=rbp_fwd` — RBP flow control + **weighted forward-delay** subflow selection (combines RBP with the thesis's forward-delay work)

Both share the same buffer division logic; only the subflow selection metric differs.

**`unordered_i` estimation**: Sender-side approximation using `write_seq - snd_una` (all in-flight data on the subflow). Conservative overestimate, no receiver-side changes needed.

---

## Files to Change

All paths relative to `bake/source/net-next-nuse-mptcp/`.

| File | Change | Details |
|------|--------|---------|
| `net/mptcp/mptcp_rbp.c` | **NEW** (~400-450 lines) | RBP scheduler module with both variants |
| `include/net/mptcp.h` | 1 line changed | `MPTCP_SCHED_SIZE` from 4 → 24 (line 189) |
| `net/mptcp/Kconfig` | ~15 lines added | `MPTCP_RBP` config entry + default choices |
| `net/mptcp/Makefile` | 1 line added | `obj-$(CONFIG_MPTCP_RBP) += mptcp_rbp.o` (after line 19) |
| `.config` | 1 line added | `CONFIG_MPTCP_RBP=y` (after line 155) |

**No changes to**: `mptcp_output.c`, `mptcp_input.c`, `mptcp_ofo_queue.c`, `dce-fw-dly-test.cc`.

The `--sch=rbp` and `--sch=rbp_fwd` arguments work automatically via the existing sysctl plumbing in `dce-fw-dly-test.cc` (line 530: `SysctlSet(..., ".net.mptcp.mptcp_scheduler", scheduler)`).

---

## Implementation Steps

### Step 1: Increase per-subflow scheduler storage

**File**: `include/net/mptcp.h`, line 189

```c
#define MPTCP_SCHED_SIZE 24   // was 4
```

RBP per-subflow private data (20 bytes):

```c
struct rbp_subflow_priv {
    u32 acwnd;           // EWMA of congestion window (packets), Eq. 1
    u32 alloc;           // Allocated buffer share B_i (bytes), Eq. 3
    u32 rwnd;            // Per-subflow receive window (bytes), Eq. 4
    u32 unordered;       // Estimated unordered bytes from this subflow
    u32 last_rbuf_opti;  // Receive buffer optimization timestamp
};
```

### Step 2: Kconfig, Makefile, .config

**Kconfig** — after `MPTCP_WEIGHTED_DELAY` block (line 93):
```kconfig
config MPTCP_RBP
    tristate "MPTCP Receive Buffer Pre-division (RBP)"
    depends on (MPTCP=y)
    ---help---
      RBP flow control: divides receive buffer among subflows proportionally
      to estimated buffer occupancy. Registers two schedulers: "rbp" (min-RTT
      selection) and "rbp_fwd" (forward-delay selection).
```

After line 116, add two default choices:
```kconfig
  config DEFAULT_RBP
    bool "RBP (min-RTT)" if MPTCP_RBP=y
  config DEFAULT_RBP_FWD
    bool "RBP (forward-delay)" if MPTCP_RBP=y
```

After line 126, add default strings:
```kconfig
  default "rbp" if DEFAULT_RBP
  default "rbp_fwd" if DEFAULT_RBP_FWD
```

**Makefile** — after line 19:
```makefile
obj-$(CONFIG_MPTCP_RBP) += mptcp_rbp.o
```

**.config** — after line 155:
```
CONFIG_MPTCP_RBP=y
```

### Step 3: Create `net/mptcp/mptcp_rbp.c`

#### 3a. Per-subflow state access

```c
static struct rbp_subflow_priv *rbp_get_priv(const struct tcp_sock *tp)
{
    return (struct rbp_subflow_priv *)&tp->mptcp->mptcp_sched[0];
}
```

#### 3b. `rbp_init(sk)` — Per-subflow initialization

Set `acwnd = tp->snd_cwnd`, zero other fields. Called when a subflow joins the connection.

#### 3c. `rbp_update_acwnd(tp)` — EWMA update (Eq. 1)

```
acwnd = acwnd - acwnd/16 + cwnd/16    (β = 1/16, fixed-point)
```

Clamp to minimum 1.

#### 3d. `rbp_compute_buf_occupancy(mpcb, tp)` — Buffer occupancy estimate (Eq. 2)

```
Buf_i = acwnd_i * (ceil(max_{j≠i}(RTT_j) / (2 * RTT_i)) + 1)
```

- Iterate subflows via `mptcp_for_each_tp()` to find `max_{j≠i}(RTT_j)` using `tp->srtt_us >> 3`
- Integer ceil: `(a + b - 1) / b`
- Paper's `+1/2 + 1/2` simplifies to `+1`

#### 3e. `rbp_divide_buffer(meta_sk)` — Core RBP algorithm (Algorithm 1)

Four phases iterating subflows:

1. **Update `acwnd_i`** and compute `Buf_i` for each subflow (Eqs. 1-2)
2. **Allocate buffer**: `B_i = sk_rcvbuf * Buf_i / sum(Buf_j)` (Eq. 3)
   - Use `u64` intermediate: `(u64)recv_buffer * alloc / total`
3. **Estimate `unordered_i`**: `tp->write_seq - tp->snd_una` (sender-side)
4. **Divide rwnd** (Eq. 4):
   - If `B_i <= unordered_i` → `rwnd_i = 0`
   - Else → `rwnd_i = meta_rwnd * (B_i - unordered_i) / sum_positive`

Guard all divisions against zero.

#### 3f. Helper functions (copied from `mptcp_sched.c`)

These are `static` in each scheduler and must be duplicated:
- `mptcp_is_def_unavailable()`
- `mptcp_is_temp_unavailable()`
- `mptcp_is_available()`
- `mptcp_dont_reinject_skb()`
- `subflow_is_backup()` / `subflow_is_active()`
- `mptcp_rcv_buf_optimization()`
- `__mptcp_next_segment()` (renamed to `__rbp_next_segment()`)

#### 3g. Subflow selection — two variants

**`rbp_get_subflow_rtt()`** — min-RTT selection (for `rbp` scheduler):
- Same as default `get_subflow_from_selectors()` from `mptcp_sched.c`
- **Added**: skip subflows where `priv->rwnd == 0`

**`rbp_get_subflow_fwd()`** — weighted forward-delay selection (for `rbp_fwd` scheduler):
- Same as `get_subflow_from_selectors()` from `mptcp_wt_dly.c`
- Uses `wt_dly = tp->sfw_dly_us` instead of `tp->srtt_us`
- **Added**: skip subflows where `priv->rwnd == 0`

Both call `rbp_divide_buffer(meta_sk)` before selecting.

#### 3h. `rbp_next_segment()` / `rbp_fwd_next_segment()` — The `next_segment` callbacks

Follow the structure of `mptcp_next_segment()` from `mptcp_sched.c`:
1. Get next skb from `__rbp_next_segment()`
2. Select subflow via the appropriate variant
3. Compute `*limit` from cwnd and subflow window (standard)
4. **RBP enforcement**: further constrain `*limit` by `priv->rwnd`:
   ```c
   if (priv->rwnd > 0 && *limit > priv->rwnd)
       *limit = priv->rwnd;
   ```

#### 3i. Module registration — two schedulers from one module

```c
static struct mptcp_sched_ops mptcp_sched_rbp = {
    .get_subflow  = rbp_get_available_subflow_rtt,
    .next_segment = rbp_next_segment,
    .init         = rbp_init,
    .name         = "rbp",
    .owner        = THIS_MODULE,
};

static struct mptcp_sched_ops mptcp_sched_rbp_fwd = {
    .get_subflow  = rbp_get_available_subflow_fwd,
    .next_segment = rbp_fwd_next_segment,
    .init         = rbp_init,
    .name         = "rbp_fwd",
    .owner        = THIS_MODULE,
};

static int __init mptcp_rbp_register(void)
{
    BUILD_BUG_ON(sizeof(struct rbp_subflow_priv) > MPTCP_SCHED_SIZE);
    if (mptcp_register_scheduler(&mptcp_sched_rbp))
        return -1;
    return mptcp_register_scheduler(&mptcp_sched_rbp_fwd);
}
```

### Step 4: Build and test

```bash
# From host:
./build.sh --full -v          # Full rebuild (kernel changed)
./sim.sh rbp experiment1      # Run with RBP + min-RTT
./sim.sh rbp_fwd experiment1  # Run with RBP + forward-delay

# Or run all schedulers for comparison:
./run.sh './waf --run "mptcp --sch=default"'
./run.sh './waf --run "mptcp --sch=weighted_delay"'
./run.sh './waf --run "mptcp --sch=rbp"'
./run.sh './waf --run "mptcp --sch=rbp_fwd"'
```

---

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Standalone scheduler module | Cleanest integration; `*limit` in `next_segment()` is the natural enforcement point |
| Two variants in one module | One `--sch` flag controls both selection metric + flow control. Clean for experiments |
| Sender-side `unordered_i` | No receiver changes. `write_seq - snd_una` is conservative but directionally correct |
| `MPTCP_SCHED_SIZE` = 24 | Research kernel, no ABI concerns. Simpler than dynamic allocation |
| Recompute buffer division per `next_segment()` | Correct per paper. Optimization can come later |

---

## Verification

1. **Build**: `./build.sh --full -v` completes without errors
2. **Basic run**: `./sim.sh rbp` and `./sim.sh rbp_fwd` complete without crash
3. **Log inspection**: `./logs.sh stderr` — no kernel panics
4. **Correctness** (add temporary `printk` in `rbp_divide_buffer()`):
   - Subflow with highest RTT gets smaller buffer share
   - `sum(B_i) ≈ sk_rcvbuf`
   - `sum(rwnd_i) ≈ meta_rwnd` when no subflow throttled
   - Subflows with high outstanding data get `rwnd_i = 0`
5. **Comparison**: Run all 4 schedulers (default, weighted_delay, rbp, rbp_fwd) on the 3-path asymmetric topology. Compare throughput and OFO counts.

---

## Reference: Key Source Files

| File | Purpose |
|------|---------|
| `net/mptcp/mptcp_wt_dly.c` | Template for new scheduler (copy structure from here) |
| `net/mptcp/mptcp_sched.c` | Default scheduler; helper functions to copy |
| `net/mptcp/mptcp_output.c` | Send path; `mptcp_write_xmit()` calls `next_segment()` (line 648), `*limit` enforced (line 714) |
| `include/net/mptcp.h` | `mptcp_sched_ops` (line 243), `mptcp_tcp_sock` (line 157), `mptcp_cb` (line 259) |
| `include/linux/tcp.h` | `tcp_sock`: `snd_cwnd` (292), `srtt_us` (259), `sfw_dly_us` (266), `snd_wnd` (235) |
| `net/mptcp/mptcp_input.c` | `mptcp_init_buffer_space()` (line 2363) — buffer initialization reference |
