#!/bin/bash

# Exit if not in tmux
if [ -z "$TMUX" ]; then
    echo "Not running in tmux"
    exit 1
fi


# Get current window index
current_window=$(tmux display-message -p '#{window_index}')

# Check if helix is running in any pane in the current window
helix_pane=$(tmux list-panes -F "#{pane_index} #{pane_current_command}" -t :"$current_window" | \
             awk '/hx/ {print $1}' | head -n1)

if [ -z "$helix_pane" ]; then
    echo "No helix instance found in current window, exiting"
    exit 1
fi

# Build the command with all files, properly escaped
command=":o"
for file in "$@"; do
    # Get full path and escape special characters
    full_path=$(realpath "$file")
    # Escape spaces and other special characters for macOS
    escaped_path=$(printf %q "$full_path")
    command="$command $escaped_path"
done

# Send the :o command to helix with the file path
tmux send-keys -t "$current_window.$helix_pane" "$command" Enter

# Switch the focus on helix pane
tmux select-pane -t "$helix_pane"

