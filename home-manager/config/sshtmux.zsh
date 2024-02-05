#!/usr/bin/env bash
set -euo pipefail
# This script will open a tmux session with tmux sessions of multiple remote
# hosts.
# Arguments:
# -a: Attach to the session after making sure it exists and creating it if not.

USAGE="Usage: $0 [-a]"

# Get arguments
ATTACH=false
while getopts "a" opt; do
    case "$opt" in
        a) ATTACH=true ;;
        *) echo "$USAGE" >&2; exit 1 ;;
    esac
done

HOSTS=(
  "risitas@cocinero"
  "risitas@issou"
  "risitas@plancha"
  "debian@chorizo"
  "tarneo@cocinero"
  "weechat"
)

SESSION_NAME="ssh"

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    tmux new-session -d -s "$SESSION_NAME"
fi

for HOST in "${HOSTS[@]}"; do
    if tmux has-session -t "$SESSION_NAME:$HOST" 2>/dev/null; then continue; fi
    if [[ "$HOST" == "weechat" ]]; then
        VARIABLES="HOST=\"tarneo@cocinero\" REMOTE_COMMAND=\"tmux a -t weechat\""
    else
        VARIABLES="HOST=\"$HOST\""
    fi
    tmux new-window -t "$SESSION_NAME" -n "$HOST" "$VARIABLES __sshtmux_session; sleep 20"
    # tmux new-window -t "$SESSION_NAME" -n "$HOST" "HOST=$HOST __sshtmux_session"
done

if $ATTACH; then
    tmux attach-session -t "$SESSION_NAME"
fi
