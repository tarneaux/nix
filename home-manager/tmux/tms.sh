#!/usr/bin/env bash

if [[ -n $TMUX ]]; then
    echo "Please exit tmux first."
fi

hosts_arr=(issou issou-lan chorizo)

hosts="$(printf '%s\n' "${hosts_arr[@]}")"

if [ $# -gt 1 ]; then
    echo "Only one argument is allowed."
fi

fzf_output=$(fzf \
    ${1+-1} -0 -e --print-query \
    --border-label=" SSH hosts " \
    --border sharp --reverse \
    -q "$1" <<<"$hosts")

case $? in
0 | 1)
    # Get the last line, which is either the selected item or the unmet
    # query. Also remove a leading plus sign, used to prevent matches.
    host=$(sed -n '$p' <<<"$fzf_output" | sed -s 's/^\+//g')
    ssh -t "$host" 'tmw || $SHELL'
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
