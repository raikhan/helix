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
elif command -v xclip >/dev/null 2>&1; then
    echo "$text" | xclip -selection clipboard
elif command -v xsel >/dev/null 2>&1; then
    echo "$text" | xsel --clipboard --input
else
    echo "No clipboard command found. Please install xclip or xsel."
    exit 1
fi

# Send the %paste command, using the full pane id
tmux send-keys -t "$IPYTHON_PANE" "%paste" Enter
