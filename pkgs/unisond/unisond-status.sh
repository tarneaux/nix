state_dir="/var/run/user/$UID/unisond"

if [ "$#" -ne 1 ]; then
    echo "Unison profile wasn't specified, exiting."
    exit 1
fi

unison_profile=$1
pdir="$state_dir/$unison_profile"

pdir_exists() {
    [ -d "$pdir" ] &&
        [ -f "$pdir/daemon.pid" ] &&
        [ -f "$pdir/counter" ]
    # Do NOT check for unison.pid as it is not created immediately.
}
daemon_running() { [ -d "/proc/$(<"$pdir/daemon.pid")" ]; }
unison_running() {
    # Errors may occur because we do not check for unison.pid presence earlier.
    pid=$(cat "$pdir/unison.pid" 2>/dev/null) || return 1
    [ -d "/proc/$pid" ]
}
waiter_running() {
    # Errors may occur because we do not check for waiter.pid presence earlier.
    pid=$(cat "$pdir/waiter.pid" 2>/dev/null) || return 1
    [ -d "/proc/$pid" ]
}

if ! pdir_exists || ! daemon_running; then
    echo "DOWN"
elif ! unison_running; then
    if waiter_running; then
        echo "DEAD"
    else
        echo "???"
    fi
else
    errs="$(<"$pdir/counter")"
    if [[ $errs == 0 ]]; then
        echo "UP"
    else
        echo "FAILING ($errs)"
    fi
fi
