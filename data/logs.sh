#!/bin/bash
# Print simulation logs from inside the container.
# Usage: ./logs.sh [log_file]
# Example: ./logs.sh stderr

docker exec -it mptcp_simulation bash -c "cd /workspace/bake/source/ns-3-dce && ./print.sh $1"
