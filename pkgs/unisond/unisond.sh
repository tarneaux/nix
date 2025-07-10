state_dir="/var/run/user/$UID/unisond"

if [ "$#" -ne 1 ]; then
    echo "Unison profile wasn't specified, exiting."
    exit 1
fi

unison_profile=$1
if [ "$(unisond-status "$unison_profile")" = "UP" ]; then
    echo "Unisond is already running for this profile."
    exit 1
fi
pdir="$state_dir/$unison_profile"
mkdir -p "$pdir"
echo $$ >"$pdir/daemon.pid"

run_unison() {
    unison -repeat watch+3600 -color false -auto -terse "$unison_profile" 2>&1 &
    echo "$!" >"$pdir/unison.pid"
    wait
}

write_counter() { echo $counter >"$pdir/counter"; }
set_counter() {
    counter=$(($1))
    write_counter
}
inc_counter() { set_counter ++counter; }

set_counter 0

wait_for_signal() {
    trap 'return' SIGUSR1
    { while :; do sleep infinity; done; } &
    echo "$!" >"$pdir/waiter.pid"
    wait
}

while true; do
    coproc run_unison

    echo -e "\e[33mBackground Unison process started.\e[0m"
    echo -e "\e[33mNow showing (terse) Unison output.\e[0m"

    while read -r line; do
        echo "$line"
        if [[ $line == "Synchronization incomplete"* ]]; then
            inc_counter
        elif [[ $line == "Synchronization complete"* ]]; then
            set_counter 0
        fi
    done <&"${COPROC[0]}"

    rm "$pdir/unison.pid"

    echo -e "\e[33mUnison exited; waiting for SIGUSR1...\e[0m"

    wait_for_signal

    rm "$pdir/waiter.pid"
done
