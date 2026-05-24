#!/bin/bash
# Run a waf command inside the container in the ns-3-dce directory.
# Usage: ./run.sh '<waf command>'
# Examples:
#   ./run.sh './waf --run "mptcp --sch=default"'
#   ./run.sh './waf build'

if [ -z "$1" ]; then
  echo "Usage: ./run.sh '<command>'"
  echo "Command runs in /workspace/bake/source/ns-3-dce inside the container."
  exit 1
fi

docker exec -it mptcp_simulation bash -c "cd /workspace/bake/source/ns-3-dce && $1"
