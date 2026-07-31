#!/usr/bin/env bash

# tmux fuzzy session/window/pane manager
#
# Enter  : switch to selected pane
# Ctrl-n : create a new session
# Ctrl-w : create a new window in the selected session
# Ctrl-r : rename the selected window
# Ctrl-s : rename the selected session
# Ctrl-d : delete the selected window
# Esc    : close

set -euo pipefail

pause_with_message() {
  local message="$1"

  printf '\n%s\nPress Enter to continue.' "$message" >/dev/tty
  IFS= read -r _ </dev/tty
}

prompt_value() {
  local prompt="$1"
  local default_value="${2:-}"
  local value=""

  if [[ -n "$default_value" ]]; then
    printf '\n%s [%s]: ' "$prompt" "$default_value" >/dev/tty
  else
    printf '\n%s: ' "$prompt" >/dev/tty
  fi

  IFS= read -r value </dev/tty

  printf '%s' "${value:-$default_value}"
}

session_exists() {
  local session_name="$1"

  tmux has-session -t "=${session_name}" 2>/dev/null
}

create_session() {
  local session_name
  local start_directory

  session_name="$(prompt_value 'New session name')"

  [[ -n "$session_name" ]] || return 0

  if session_exists "$session_name"; then
    pause_with_message "Session \"$session_name\" already exists."
    return 0
  fi

  start_directory="$(prompt_value 'Starting directory' "$HOME")"

  if [[ ! -d "$start_directory" ]]; then
    pause_with_message "Directory does not exist: $start_directory"
    return 0
  fi

  tmux new-session \
    -d \
    -s "$session_name" \
    -c "$start_directory"

  tmux switch-client -t "=${session_name}"
  exit 0
}

create_window() {
  local session_id="$1"
  local pane_id="$2"

  local current_directory
  local window_name
  local start_directory
  local new_pane_id
  local -a command

  current_directory="$(
    tmux display-message \
      -p \
      -t "$pane_id" \
      '#{pane_current_path}'
  )"

  window_name="$(prompt_value 'New window name')"
  start_directory="$(
    prompt_value 'Starting directory' "$current_directory"
  )"

  if [[ ! -d "$start_directory" ]]; then
    pause_with_message "Directory does not exist: $start_directory"
    return 0
  fi

  command=(
    tmux new-window
    -d
    -P
    -F '#{pane_id}'
    -t "$session_id"
    -c "$start_directory"
  )

  if [[ -n "$window_name" ]]; then
    command+=(-n "$window_name")
  fi

  new_pane_id="$("${command[@]}")"

  tmux switch-client -t "$new_pane_id"
  exit 0
}

rename_window() {
  local window_id="$1"
  local current_name
  local new_name

  current_name="$(
    tmux display-message \
      -p \
      -t "$window_id" \
      '#{window_name}'
  )"

  new_name="$(prompt_value 'Rename window' "$current_name")"

  if [[ -n "$new_name" && "$new_name" != "$current_name" ]]; then
    tmux rename-window -t "$window_id" "$new_name"

    # Keep tmux from replacing the manually assigned name.
    tmux set-option \
      -w \
      -t "$window_id" \
      automatic-rename off
  fi
}

rename_session() {
  local session_id="$1"
  local current_name
  local new_name

  current_name="$(
    tmux display-message \
      -p \
      -t "$session_id" \
      '#{session_name}'
  )"

  new_name="$(prompt_value 'Rename session' "$current_name")"

  [[ -n "$new_name" ]] || return 0
  [[ "$new_name" != "$current_name" ]] || return 0

  if session_exists "$new_name"; then
    pause_with_message "Session \"$new_name\" already exists."
    return 0
  fi

  tmux rename-session -t "$session_id" "$new_name"
}

delete_window() {
  local window_id="$1"
  local window_name
  local confirmation

  window_name="$(
    tmux display-message \
      -p \
      -t "$window_id" \
      '#{window_name}'
  )"

  confirmation="$(
    prompt_value "Delete window \"$window_name\"? Type y to confirm" 'n'
  )"

  case "$confirmation" in
  y | Y | yes | YES)
    ;;
  *)
    return 0
    ;;
  esac

  # Killing the final window may terminate the tmux server immediately.
  tmux kill-window -t "$window_id" 2>/dev/null || true

  if ! tmux list-windows -a >/dev/null 2>&1; then
    tmux kill-server 2>/dev/null || true
    exit 0
  fi
}
shorten_path() {
  local path="$1"
  local prefix=""
  local relative_path
  local -a parts
  local result=""
  local count
  local index
  local part

  # Replace the home directory with ~.
  if [[ "$path" == "$HOME" ]]; then
    printf '~'
    return
  elif [[ "$path" == "$HOME/"* ]]; then
    prefix="~"
    relative_path="${path#"$HOME"/}"
  elif [[ "$path" == /* ]]; then
    prefix="/"
    relative_path="${path#/}"
  else
    relative_path="$path"
  fi

  IFS='/' read -r -a parts <<<"$relative_path"
  count="${#parts[@]}"

  for ((index = 0; index < count; index++)); do
    part="${parts[index]}"

    [[ -n "$part" ]] || continue

    # Keep the last two folder names complete.
    if ((index >= count - 2)); then
      shortened_part="$part"
    else
      shortened_part="${part:0:1}"
    fi

    if [[ -z "$result" ]]; then
      result="$shortened_part"
    else
      result+="/$shortened_part"
    fi
  done

  case "$prefix" in
  "~")
    printf '~/%s' "$result"
    ;;
  "/")
    printf '/%s' "$result"
    ;;
  *)
    printf '%s' "$result"
    ;;
  esac
}

build_tmux_tree() {
  local session_id
  local session_name
  local window_id
  local window_index
  local window_name
  local pane_id
  local pane_index
  local pane_command
  local pane_path
  local first_pane
  local first_window

  while IFS=$'\t' read -r session_id session_name; do
    first_window=1

    while IFS=$'\t' read -r window_id window_index window_name; do
      first_pane=1

      while IFS=$'\t' read -r pane_id pane_index pane_command pane_path; do

        short_path="$(shorten_path "$pane_path")"
        if ((first_window == 1 && first_pane == 1)); then
          #         visible_text="󰆍 ${session_name}
          # └─ 󰖲 ${window_index}: ${window_name}
          #      └─ 󰆍 pane ${pane_index}: ${pane_command}  ${pane_path}"

          visible_text="󰆍 ${session_name}
  └─ 󰖲 ${window_name}
       └─ 󰆍 ${pane_command}  ${short_path}"
        elif ((first_pane == 1)); then
          #    visible_text="  └─ 󰖲 ${window_index}: ${window_name}
          # └─ 󰆍 pane ${pane_index}: ${pane_command}  ${pane_path}"

          visible_text="  └─ 󰖲 ${window_name}
       └─ 󰆍 ${pane_command}  ${short_path}"
        else
          # visible_text="       └─ 󰆍 pane ${pane_index}: ${pane_command}  ${pane_path}"
          visible_text="       └─ 󰆍 ${pane_command}  ${short_path}"
        fi

        # One complete multiline fzf item, separated by NUL.
        printf '%s\t%s\t%s\t%s\t%s\0' \
          "$session_id" \
          "$window_id" \
          "$pane_id" \
          "$pane_path" \
          "$visible_text"

        first_pane=0
        first_window=0
      done < <(
        tmux list-panes \
          -t "$window_id" \
          -F '#{pane_id}	#{pane_index}	#{pane_current_command}	#{pane_current_path}'
      )
    done < <(
      tmux list-windows \
        -t "$session_id" \
        -F '#{window_id}	#{window_index}	#{window_name}'
    )
  done < <(
    tmux list-sessions \
      -F '#{session_id}	#{session_name}'
  )
}
#-F '#{session_id}	#{window_id}	#{pane_id}	#{session_name} › #{window_name} › pane #{pane_index}	#{pane_current_command}	#{pane_current_path}' |
while tmux list-windows -a >/dev/null 2>&1; do

  result="$(
    build_tmux_tree |
      fzf \
        --read0 \
        --expect=enter,ctrl-d,ctrl-r,ctrl-s,ctrl-n,ctrl-w \
        --delimiter=$'\t' \
        --with-nth=5 \
        --prompt='tmux ❯ ' \
        --header='Enter: switch │ Ctrl-n: new session │ Ctrl-w: new window │ Ctrl-r: rename window │ Ctrl-s: rename session │ Ctrl-d: delete window' \
        --border \
        --color='border:0,preview-border:0' \
        --reverse \
        --height=100% \
        --preview='tmux capture-pane -ep -t {3} -S -200' \
        --preview-window='right,60%,wrap'
  )" || exit 0
  key="$(printf '%s\n' "$result" | sed -n '1p')"
  selection="$(printf '%s\n' "$result" | sed -n '2p')"

  # Creating a session does not require a selected row.
  if [[ "$key" == "ctrl-n" ]]; then
    create_session
    continue
  fi

  # All other actions require a selected row.
  [[ -n "$selection" ]] || continue

  session_id="$(printf '%s' "$selection" | cut -f1)"
  window_id="$(printf '%s' "$selection" | cut -f2)"
  pane_id="$(printf '%s' "$selection" | cut -f3)"

  case "$key" in
  ctrl-w)
    create_window "$session_id" "$pane_id"
    ;;

  ctrl-d)
    delete_window "$window_id"
    ;;

  ctrl-r)
    rename_window "$window_id"
    ;;

  ctrl-s)
    rename_session "$session_id"
    ;;

  enter | "")
    tmux switch-client -t "$pane_id"
    exit 0
    ;;
  esac
done

tmux kill-server 2>/dev/null || true
