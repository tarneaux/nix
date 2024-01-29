# Get the current working directory name
session_name=$(basename "$PWD")

nix develop -c tmux new -s "$session_name" -d

tmux send-keys "nvim ." Enter
tmux new-window -n "dev" 'nix run .#dev'
tmux new-window -n "shell"

tmux a
