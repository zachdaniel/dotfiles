#!/usr/bin/env bash
set -euo pipefail

input="$1"

# --- Parse file:line ---
file="$input"
line=""

if [[ "$input" =~ ^(.+):([0-9]+)$ ]]; then
  file="${BASH_REMATCH[1]}"
  line="${BASH_REMATCH[2]}"
fi

# --- Find most recently interacted with session ---
session=$(
  tmux list-sessions -F '#{session_name} #{session_activity}' \
    | sort -k2 -nr \
    | head -n1 \
    | awk '{print $1}'
)

if [[ -z "$session" ]]; then
  echo "No tmux session found" >&2
  exit 1
fi

# --- Look for a running nvim pane in that session ---
nvim_pane=$(
  tmux list-panes -t "$session" -F '#{pane_id} #{pane_current_command}' \
    | awk '$2=="nvim"{print $1; exit}'
)

if [[ -n "$nvim_pane" ]]; then
  # Send commands into running nvim
  tmux send-keys -t "$nvim_pane" Escape ":e $file" Enter
  [[ -n "$line" ]] && tmux send-keys -t "$nvim_pane" ":$line" Enter
else
  # Start a detached nvim pane in that session
  if [[ -n "$line" ]]; then
    tmux split-window -t "$session" -d "nvim '$file' +$line"
  else
    tmux split-window -t "$session" -d "nvim '$file'"
  fi
fi
