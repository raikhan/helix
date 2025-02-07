# My Helix editor setup

This setup combines the [helix](https://helix-editor.com/) editor, running in a Tmux window manager, with a few shell scripts into a dedicated dev environment for my Python (and other) code projects. The two TOML files are the standard Helix settings and the sh files are the supporting shell scripts with different purposes:

- [send-to-ipython.sh](./send-to-ipython.sh): script to paste code from Helix (keybinding set in [config.toml](./config.toml)) to an open iPython terminal. Assumes that there is only one iPython pane in the current Tmux window
- [git-diff.sh](./git-diff.sh): uses fswatch to check if any files have changed and reruns the git diff to show the differences (using [git delta](https://github.com/dandavison/delta) for pretty printing). If the repo is clean, the script shows the diff between the last two commits
- [dev-template.sh](./dev-template.sh): shell script starts a new window in the selected folder, splits it in 4 panes and runs helix, [aider](https://aider.chat/) and git-diff.sh in 3 of them, while the last one is left as a terminal. I use [oh-my-zsh](https://ohmyz.sh/) to manage my terminal tools and have 
[autoswitch_virtualenv](https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv) added which loads the right Python virtualenv when terminal goes to the project dir. This helps make sure all the tools are running in the correct environment.

## Required Homebrew packages

- helix (editor)
- lazygit (git CLI tool)
- bat (fancy cat tool)
- git-delta (fancy git diff tool)
- marksman (LSP for markdown)
- argc (tools for cleaner bash script arguments)
