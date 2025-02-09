#!/bin/bash

# Helper function that determines is a file is a text file, to be opened with Helix
is_text_file() {
    if file --mime-type "$file" | grep -q "text/"; then
        return 0
    fi

    return 1
}

# Helper function to open non-text files (uses MacOS open by default)
handle_non_text_file() {
    local file="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open "$file"
    else
        xdg-open "$file"
    fi
}

# Exit if not in tmux
if [ -z "$TMUX" ]; then
    echo "Not running in tmux"
    exit 1
fi

# Sort files into text and non-text
declare -a text_files
declare -a non_text_files

for file in "$@"; do
    if is_text_file "$file"; then
        text_files+=("$file")
    else
        non_text_files+=("$file")
    fi
done

echo "${text_files[@]}"
echo "${non_text_files[@]}"

if [ ${#text_files[@]} -gt 0 ]; then

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
    for file in "${text_files[@]}"; do
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
fi

# Handle non-text files with system default
for file in "${non_text_files[@]}"; do
    handle_non_text_file "$file" &
done
