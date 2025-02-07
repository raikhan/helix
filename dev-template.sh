#!/bin/bash

# @option --path  Work directory path
# @option --name  Name for the new tab

eval "$(argc --argc-eval "$0" "$@")"

if [ -z "$argc_path" ]; then
  argc_path="$(pwd)"
fi
if [ -z "$argc_name" ]; then
  argc_name="dev"
fi
    
echo path: "$argc_path"
echo name: "$argc_name"
 
# Create new window
tmux new-window -n "$argc_name"

# Split panes and run commands
tmux split-window -v -p 33
tmux select-pane -t 1
tmux split-window -h -p 50
tmux select-pane -t 3
tmux split-window -h -p 50

# Run your commands in specific panes
tmux send-keys -t 1 "cd $argc_path" Enter
tmux send-keys -t 1 'hx .' Enter

tmux send-keys -t 2 "cd $argc_path" Enter
tmux send-keys -t 2 'aider --watch-files' Enter

tmux send-keys -t 3 "cd $argc_path" Enter

tmux send-keys -t 4 "cd $argc_path" Enter
tmux send-keys -t 4 "$HOME/.config/helix/git-diff.sh" Enter

tmux select-pane -t 1
