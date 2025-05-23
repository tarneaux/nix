#!/usr/bin/env bash

if [[ -n $TMUX ]]; then
  ATTACH_CMD="switch-client"
else
  ATTACH_CMD="attach"
fi

windows=$(tmux list-windows -aF '#W (#S:#I)' | grep -v "fzf-window (fzf-window:0)")
fzf_output=$(echo "$windows" \
    | fzf --prompt="Switch to window: " --reverse --print-query)

fzf_exit_code=$?

if [ $fzf_exit_code -eq 130 ]; then
    # The user escaped the fzf window
    exit 1
fi

if [ $fzf_exit_code -eq 0 ]; then
    # The user selected a window

    # Get the second line of the output (the window name)
    fzf_output=$(echo "$fzf_output" | sed -n 2p)

    # Get the window name from the output (in the parentheses)
    window=$(echo "$fzf_output" | grep -oP '(?<=\().*(?=\))')

    tmux "$ATTACH_CMD" -t "$window"
fi

if [ $fzf_exit_code -eq 1 ]; then
    # The user entered a window name that doesn't exist.
    # We can interpret it as the project directory name.
    
    # Let's first remove the leading plus sign if there one; this allows us to
    # force the creation of a new session if results are found when searching
    # for the directory name.
    fzf_output=$(echo "$fzf_output" | sed -s 's/^\+//g')

    # Get the directory name with zoxide
    directory=$(zoxide query "$fzf_output")

    if [ -z "$directory" ]; then
        echo "Couldn't query this directory's location with zoxide."
        exit 1
    fi

    # Open a new session in the directory, with the directory name as the
    # session name
    dirname=$(basename "$directory")

    tmux new-session -c "$directory" -s "$dirname" -d

    # Find the session id of the new session (needed if there are special
    # characters in the name)
    session_id=$(tmux list-sessions -F '#S:#{session_path}' \
        | grep ":$directory$" \
        | cut -d: -f1)

    tmux "$ATTACH_CMD" -t "$session_id"
fi
