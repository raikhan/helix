#!/bin/bash

# Default values
project_path=$(pwd)
window_name='dev'

# Parse options
while getopts "p:w:" opt; do
  case $opt in
    p) project_path="$OPTARG" ;;
    w) window_name="$OPTARG" ;;
    *) echo "Invalid option"; exit 1 ;;
  esac
done

# Create new window
tmux new-window -n "$window_name"

# Split panes and run commands
tmux split-window -v -p 33
tmux select-pane -t 1
tmux split-window -h -p 50
tmux select-pane -t 3
tmux split-window -h -p 50

# Run your commands in specific panes
tmux send-keys -t 1 "cd $project_path" Enter
tmux send-keys -t 1 'hx .' Enter

tmux send-keys -t 2 "cd $project_path" Enter
tmux send-keys -t 2 'aider --watch-files' Enter

tmux send-keys -t 3 "cd $project_path" Enter

tmux send-keys -t 4 "cd $project_path" Enter
tmux send-keys -t 4 '~/.config/helix/git-diff.sh' Enter

tmux select-pane -t 1
