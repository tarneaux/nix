set -euo pipefail

if [[ -z "$HOST" ]]; then
    echo "HOST is not set" >&2
    exit 1
fi

if [[ ! -v REMOTE_COMMAND ]]; then
    if [[ "$HOST" = "risitas@cocinero" ]]; then
        REMOTE_COMMAND="./start-tmux"
    else
        REMOTE_COMMAND="tmux new -A -s main"
    fi
fi

echo "Press enter to connect to $HOST and run '$REMOTE_COMMAND'"
while true; do
    read -r
    clear

    ssh -t "$HOST" "$REMOTE_COMMAND"
    echo "Press enter to reconnect to $HOST and run '$REMOTE_COMMAND'"
done
