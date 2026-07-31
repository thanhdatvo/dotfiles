#!/usr/bin/env bash

set -euo pipefail

current="$(tmux display-message -p '#{pane_id}')"

if [[ "$(tmux display-message -p '#{pane_marked_set}')" != "1" ]]; then
  tmux select-pane -m -t "$current"
  tmux display-message \
    "Marked current pane; switch elsewhere, then press Prefix+l"
  exit 0
fi

marked="$(
  tmux display-message -p -t '{marked}' '#{pane_id}'
)"

# Avoid toggling when the marked pane is already current.
if [[ "$current" == "$marked" ]]; then
  tmux display-message "Current pane is already marked"
  exit 0
fi

tmux switch-client -t "$marked"
tmux select-pane -m -t "$current"
