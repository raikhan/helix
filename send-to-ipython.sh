#!/bin/bash

# Function to find iPython pane
find_ipython_pane() {
    # List all panes and their running processes
    tmux list-panes -a -F '#{pane_id}' | while read -r pane_id; do
        # Check if command contains 'ipython'
        if tmux capture-pane -p -t "$pane_id" | grep -q "In \[[0-9]*\]:"; then
            echo "$pane_id"  # Return the full pane id including %
            return 0
        fi
    done
}

# Get the iPython pane
IPYTHON_PANE=$(find_ipython_pane)

if [ -z "$IPYTHON_PANE" ]; then
    echo "No iPython pane found"
    exit 1
fi

text=$(cat)

# Copy to clipboard based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "$text" | pbcopy

else
    # On headless Linux, we have no clipboard

    # Create temp file
    tmpfile="/tmp/ipython_input.py"
    echo "$text" > "$tmpfile"
    
    # Send commands to read from the temp file
    tmux send-keys -t "$IPYTHON_PANE" "!batcat --paging=never $tmpfile" Enter 
    tmux send-keys -t "$IPYTHON_PANE" "%run -i $tmpfile" Enter    
fi
