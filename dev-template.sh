#!/bin/bash

# @arg inputs* Positional params: path to workdir to open and (optional) name of new window
# @flag -K --kill Kill the window from which this script was run

eval "$(argc --argc-eval "$0" "$@")"

if [[ -n "${argc_inputs[0]}" ]]; then
  argc_path=${argc_inputs[0]}
else
  argc_path="$(pwd)"
fi

# Set name from second input or default
if [[ -n "${argc_inputs[1]}" ]]; then
  argc_name=${argc_inputs[1]}
else
  argc_name="dev"
fi
    
echo path: "$argc_path"
echo name: "$argc_name"
echo kill: "$argc_kill"
 
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

if [ -n "$argc_kill" ]; then
  # Kill the window from which the script was run
  tmux kill-window -t !
fi  
