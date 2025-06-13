if [[ $# -ne 1 ]]; then
    echo "Usage: $(basename "$0") <profile>"
fi

if [[ $1 == "rust" ]]; then
    tmux split-window -h -l 120
    tmux send-keys 'bacon -j clippy' Enter

    tmux split-window -v -l 40%
    tmux send-keys 'bacon -j test' Enter

    tmux select-pane -L
    tmux send-keys 'nvim src/' Enter
else
    echo "No such profile: $1"
fi
