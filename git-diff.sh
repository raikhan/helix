#!/bin/zsh

# Check if the directory is a git repository
check_git_repo() {
    if ! git -C "$WATCH_DIR" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "The directory '$WATCH_DIR' is not a git repository. Exiting."
        exit 1
    fi
}

# Directory to watch
WATCH_DIR="."

clear_screen_completely() {
    # ANSI escape sequences to clear screen and scrollback
    printf '\033[2J\033[3J\033[H'
    echo 'Clearing screen'
}
# Function to show git diff
show_git_diff() {
    # Clear the screen completely before running git diff
    clear_screen_completely    
    if git diff --quiet; then
        echo "No changes in the working directory. Showing diff between last two commits:"
        git -c "delta.paging=never" diff HEAD~1 HEAD
    else
        echo "Changes detected in the working directory:"
        git -c "delta.paging=never" diff
    fi
}

# Check if the directory is a git repository
check_git_repo
show_git_diff

# Watch for changes and show git diff (excluding hidden files/dirs)
# NOTE limited the events that trigger to avoid too many triggers on Linux
fswatch -1 -o -E --event Created --event Updated --event Removed -e "/\.[^/]*$" "$WATCH_DIR" | while read change; do
    show_git_diff
done


