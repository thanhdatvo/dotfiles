#!/bin/bash

# Get the current pane path from tmux
current_path=$(tmux display-message -p '#{pane_current_path}')

# Replace home directory with ~
echo "${current_path/#$HOME/~}"
