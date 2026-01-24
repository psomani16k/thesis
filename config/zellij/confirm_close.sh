#!/bin/bash

# Get the current pane's PID (Zellij passes ZELLIJ_PANE_ID and others as env vars)
pane_pid=$(ps --ppid $$ -o pid= | head -n1)

# Check if any background jobs are running (customize as needed)
if ps -o stat= -p $pane_pid | grep -q 'R'; then
    echo "A process is running in this pane."
    read -p "Are you sure you want to close it? [y/N] " ans
    if [[ "$ans" != "y" ]]; then
        exit 1  # Prevent close
    fi
fi

exit 0  # Allow close
