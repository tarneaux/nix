usage() {
    echo "$0 <profile> <action>"
    echo "Actions: wake,kill,stop"
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
    sendsig "waiter.pid" SIGUSR1 "cannot wake, unisond is currently not dead (i.e. up or down)"
    ;;
kill)
    sendsig "unison.pid" TERM "cannot kill, unisond is currently not up (i.e. dead or down)."
    ;;
stop)
    sendsig "daemon.pid" TERM "cannot stop, unisond is already down."
    ;;
*)
    usage
    exit 1
    ;;
esac
