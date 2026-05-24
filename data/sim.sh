#!/bin/bash
# Run a simulation with a specific scheduler.
# Usage: ./sim.sh <scheduler> [label]
# Schedulers: default, weighted_delay, roundrobin
# If label is provided, results are backed up after the run.
#
# Examples:
#   ./sim.sh default
#   ./sim.sh weighted_delay my_experiment
#   ./sim.sh all my_experiment    # runs default + weighted_delay, backs up both

WORKDIR="/workspace/bake/source/ns-3-dce"

if [ -z "$1" ]; then
  echo "Usage: ./sim.sh <scheduler|all> [label]"
  echo "Schedulers: default, weighted_delay, roundrobin, all"
  exit 1
fi

run_sim() {
  local sch="$1"
  local label="$2"
  echo "Running scheduler: $sch"
  docker exec -it mptcp_simulation bash -c "cd $WORKDIR && ./waf --run \"mptcp --sch=$sch\""
  if [ -n "$label" ]; then
    docker exec -it mptcp_simulation bash -c "cd $WORKDIR && ./backup.sh \"${sch}_${label}\""
  fi
}

if [ "$1" = "all" ]; then
  run_sim "default" "$2"
  run_sim "weighted_delay" "$2"
else
  run_sim "$1" "$2"
fi
