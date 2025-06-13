#!/usr/bin/env bash

windows=$(tmux list-windows -aF '#S:#{session_path}' | sort | uniq | sed "s|^\([^=]*\):$HOME|\1:~|g")

if [ $# -gt 1 ]; then
    echo "Only one argument is allowed."
fi

fzf_output=$(fzf \
    ${1+-1} -0 -e --print-query \
    --border-label=" Tmux sessions " \
    --tmux 40%,70% --border sharp --reverse \
    -q "$1" <<< "$windows")

case $? in
    0)
        # Window line is in the second line of output (because of
        # --print-query) before the colon
        window=$(sed -n 2p <<< "$fzf_output" | cut -d: -f1)
        ;;
    1)
        # Remove a hypothetical leading plus sign, to allow forcing the
        # creation of a new window.
        zoxide_dir="$(sed -s 's/^\+//g' <<< "$fzf_output")"

        # Get the directory name with zoxide
        directory=$(zoxide query "$zoxide_dir")

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
        window=$(tmux list-sessions -F '#S:#{session_path}' \
            | grep ":$directory$" \
            | cut -d: -f1)
        ;;
    130)
        # The user escaped the fzf window
        exit 1
        ;;
    *)
        echo "Unhandled fzf exit code."
        exit 1
        ;;
esac

if [[ -n $TMUX ]]; then
    tmux switch-client -t "$window"
else
    tmux attach -t "$window"
fi
