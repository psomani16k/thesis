#!/bin/bash
# Build inside the container.
# Without args: runs ./waf build in ns-3-dce (for simulation script changes).
# With --full: runs bake.py build (for kernel/MPTCP changes).
# Flags: -v, -vvv for verbose output.

VERBOSE=""
FULL=false

for arg in "$@"; do
  case "$arg" in
    --full) FULL=true ;;
    -v|-vvv) VERBOSE="$arg" ;;
  esac
done

if [ "$FULL" = true ]; then
  echo "Full rebuild via bake (kernel + all components)..."
  docker exec -it mptcp_simulation bash -c "cd /workspace/bake && ./bake.py build $VERBOSE"
else
  echo "Building ns-3-dce simulation..."
  docker exec -it mptcp_simulation bash -c "cd /workspace/bake/source/ns-3-dce && ./waf build"
fi
