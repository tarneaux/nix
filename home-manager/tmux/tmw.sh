#!/usr/bin/env bash

if [[ -n $TMUX ]]; then
  ATTACH_CMD="switch-client"
else
  ATTACH_CMD="attach"
fi

windows=$(tmux list-windows -aF '#S:#{session_path}' | sort | uniq | grep -v "^fzf-window:" | sed "s|^\([^=]*\):$HOME|\1:~|g")

case $# in
    0)
        fzf_output=$(fzf --prompt="Switch to window: " --reverse --print-query --exact <<< "$windows")

        case $? in
            0)
                CREATE=false
                # Get the second line of output before colon (the window name)
                WINDOW=$(sed -n 2p <<< "$fzf_output" | cut -d: -f1)
                ;;
            1)
                CREATE=true
                ZOXIDE_DIR="$fzf_output"
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
        ;;
    1)
        grep_output=$(grep -F "$1" <<< "$windows")
        case $? in
            0)
                case $(wc -l <<< "$grep_output") in
                    1)
                        CREATE=false
                        WINDOW=$(cut -d: -f1 <<< "$grep_output")
                        ;;
                    *)
                        exec $0
                        ;;
                esac
                ;;
            1)
                CREATE=true
                ZOXIDE_DIR="$1"
                ;;
            *)
                echo "Unhandled grep exit code."
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Unhandled arg count."
        exit 1
        ;;
esac


if [ "$CREATE" = true ]; then
    # Remove a hypothetical leading plus sign, to allow forcing the
    # creation of a new window.
    dir=$(sed -s 's/^\+//g' <<< "$ZOXIDE_DIR")
    # Get the directory name with zoxide
    directory=$(zoxide query "$dir")

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
else
    tmux "$ATTACH_CMD" -t "$WINDOW"
fi
