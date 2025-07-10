usage() {
    cat <<EOF
$(basename "$0") <profile> <action>
Actions:
- wake: wake a dead unisond, so that unison is run again.
- gfsd: gracefully shutdown unison by letting the current synchronization finish
     before stopping it. Simply sends a SIGUSR2 signal to unison, see unison
     -doc running.
- kill: kills the unison process, which allows it to stop gracefully without
        finishing the current sync.
- stop: kills the daemon process, killing unison.
EOF
}

if [ "$#" -ne 2 ]; then
    usage
    exit 1
fi

pdir="/var/run/user/$(id -u)/unisond/$1"

sendsig() {
    # usage: sendsig <filename.pid> <signal> <error message>
    pid=$(cat "$pdir/$1" 2>/dev/null) || {
        echo "$3"
        exit 1
    }
    kill -"$2" "$pid"
}

case "$2" in
wake)
    sendsig "waiter.pid" SIGUSR1 \
        "Cannot wake unisond because it is not dead."
    ;;
gfsd)
    sendsig "unison.pid" SIGUSR2 \
        "Cannot gracefully shutdown unison as it is not running."
    ;;
kill)
    sendsig "unison.pid" SIGTERM \
        "Cannot gracefully stop unison as it is not running."
    ;;
stop)
    sendsig "daemon.pid" SIGTERM \
        "Cannot stop unisond as it is already down."
    ;;
*)
    usage
    exit 1
    ;;
esac
