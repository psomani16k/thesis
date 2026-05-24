# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **data directory** for a thesis research project investigating MPTCP (Multipath TCP) subflow scheduling under asymmetric network conditions. The research question: does a scheduler using one-way forward delay instead of RTT make better subflow selections when reverse paths are congested?

The simulation stack runs inside a Docker container (`mptcp_simulation`). Files here are volume-mounted to `/workspace` in the container.

## Architecture

- **`bake/`** — The [bake](https://gitlab.com/nsnam/bake) build system that manages fetching and building all simulation components. Key subdirectories:
  - `bake/source/ns-3-dce/` — Direct Code Execution framework; runs real Linux kernel MPTCP code inside ns-3 simulations. **Custom simulation scripts live in `myscripts/mptcp/`**.
  - `bake/source/ns-3.35/` — The ns-3 network simulator (v3.35)
  - `bake/source/net-next-nuse-mptcp/` — Linux kernel with MPTCP compiled as a userspace library (`liblinux.so`). MPTCP protocol code is in `net/mptcp/`.
  - `bake/source/linux/` — Library OS (LKL/NUSE) support for running the kernel in userspace
- **`patch/`** — Patches applied during setup: `bakeconf.xml` (bake module config), `compiler-gcc.h`, `Makefile`
- **`setup.sh`** — Initial environment setup script (clones bake, applies patches, configures/downloads/builds)

## Build & Run Commands

The simulation requires Ubuntu 20.04 and runs inside a Docker container (`mptcp_simulation`). Host-side wrapper scripts in this directory execute commands inside the container, so you don't need to manually `docker exec` in.

### Host-side wrapper scripts

| Script | Usage | Description |
|--------|-------|-------------|
| `./build.sh` | `./build.sh` | Build ns-3-dce simulation (after editing scripts) |
| `./build.sh --full` | `./build.sh --full -v` | Full rebuild via bake (after kernel/MPTCP changes). Flags: `-v`, `-vvv` |
| `./sim.sh <sch> [label]` | `./sim.sh default exp1` | Run simulation with a scheduler, optionally backup results |
| `./sim.sh all [label]` | `./sim.sh all exp1` | Run default + weighted_delay, backup both |
| `./run.sh '<cmd>'` | `./run.sh './waf --run "mptcp --sch=roundrobin"'` | Run an arbitrary command in the ns-3-dce directory |
| `./logs.sh [file]` | `./logs.sh stderr` | Print simulation logs from all 26 node directories |
| `./shell.sh` | `./shell.sh` | Open interactive shell inside the container |

### Schedulers
```
default          — minRTT scheduler
weighted_delay   — forward-delay scheduler (custom, under study)
roundrobin       — round-robin scheduler
```

### Raw container commands (if needed)
```bash
docker exec -it mptcp_simulation bash
cd /workspace/bake/source/ns-3-dce
./waf --run "mptcp --sch=default"
```

## Key Files to Edit

### Simulation scripts (`bake/source/ns-3-dce/myscripts/mptcp/`)
- **`dce-fw-dly-test.cc`** — Active simulation: 3-path asymmetric topology with 26 nodes
- `dce-iperf-mptcp.cc` / `dce-iperf-multi.cc` — Alternative simulation variants
- **`wscript`** — Controls which `.cc` file is compiled (change the `source=[...]` line)

### MPTCP kernel code (`bake/source/net-next-nuse-mptcp/net/mptcp/`)
- **`mptcp_wt_dly.c`** — Custom weighted delay scheduler (uses `tp->sfw_dly_us` forward delay)
- `mptcp_sched.c` — Default minRTT scheduler
- `mptcp_rr.c` — Round-robin scheduler
- `mptcp_output.c` — Send-side scheduling integration
- `mptcp_input.c` — Receive-side processing, ACK handling

## Important Notes

- **Do not build components outside bake context** — use `bake.py build` for kernel changes
- **Only ns-3-dce script changes** need a simple `./waf build`; kernel changes require a full `bake.py build`
- The detailed ns-3-dce project guide is in `bake/source/ns-3-dce/CLAUDE.md`
