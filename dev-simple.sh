#!/bin/bash

# @arg inputs* Positional params: path to workdir to open and (optional) name of new window

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
 
tmuxinator start dev_simple workspace="$argc_path" name="$argc_name"
 
