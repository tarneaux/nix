#!/usr/bin/env bash

usage() {
    cat <<EOF
tmw - Create and switch to tmux windows with fzf
usage: tmw [query]
If query matches only one window, it will be selected automatically.
Leading plus signs in queries are removed, which allows creating new windows
even if the query has matches. This also works in the fzf menu.
Using '.' as the query (only in the command line) will open a session in the
current working directory.
EOF
}

if [ $# -gt 2 ]; then
    echo "No more than two arguments are allowed."
    usage
    exit 1
fi

get_win_by_dir() {
    tmux list-sessions -F '#S:#{session_path}' |
        grep ":$1$" |
        cut -d: -f1
}

case "$1" in
--help)
    usage
    exit 0
    ;;
.)
    window=$(get_win_by_dir "$(pwd)")

    if [ -z "$window" ]; then
        tmux new-session -s "$(basename "$(pwd)")" -d
        window=$(get_win_by_dir "$(pwd)")
    fi
    ;;
*)
    windows=$(tmux list-windows -aF '#S:#{session_path}' |
        sort |
        uniq |
        sed "s|^\([^=]*\):$HOME|\1:~|g")

    fzf_output=$(fzf \
        ${1+-1} -0 -e --print-query \
        --border-label=" Tmux sessions " \
        --tmux 40%,70% --border sharp --reverse \
        -q "$1" <<<"$windows")

    case $? in
    0)
        # Window line is in the second line of output (because of
        # --print-query) before the colon
        window=$(sed -n 2p <<<"$fzf_output" | cut -d: -f1)
        ;;
    1)
        # Remove a hypothetical leading plus sign, to allow forcing the
        # creation of a new window.
        zoxide_dir="$(sed -s 's/^\+//g' <<<"$fzf_output")"

        # Get the directory name with zoxide
        directory=$(zoxide query "$zoxide_dir")

        if [ -z "$directory" ]; then
            echo "Couldn't query this directory's location with zoxide."
            exit 1
        fi

        # Open a new session in the directory, with the directory name as the
        # session name
        dirname=$(basename "$directory")

        tmux new-session -c "$directory" -s "$dirname" -d "${2:-$SHELL}"

        # (needed if there are special characters in the name, which are mapped
        # by tmux)
        window=$(get_win_by_dir "$directory")
        ;;
    130) exit 1 ;; # The user escaped the fzf window
    *)
        echo "Unhandled fzf exit code."
        exit 1
        ;;
    esac
    ;;
esac

if [[ -n $TMUX ]]; then
    tmux switch-client -t "$window"
else
    tmux attach -t "$window"
fi
