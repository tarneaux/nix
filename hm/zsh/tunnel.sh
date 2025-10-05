#!/usr/bin/env bash

# Put wireguard in its own network namespace for selective use. Based on [1].
# Used in conjunction with wgx to access the namespace from userspace.
#
# [1]: https://www.procustodibus.com/blog/2023/04/wireguard-netns-for-specific-apps/

set -e

if [ "$1" = "check" ]; then
    ip netns show wg0 | grep -q wg0 || {
        echo "starting tunnel"
        exec doas "$0" up
    }
    exit 0
fi

if [ $EUID -ne 0 ]; then
    echo "Please run this script as root. Exiting."
    exit 1
fi

NAMESPACE=wg0
INTERFACE=wg0

case $1 in
up)
    ip netns add $NAMESPACE         # Create namespace
    ip -n $NAMESPACE link set lo up # Start loopback

    ip link add $INTERFACE type wireguard   # Create empty interface
    ip link set $INTERFACE netns $NAMESPACE # Move into namespace

    # Configure the interface
    ip netns exec $NAMESPACE wg setconf $INTERFACE /etc/wireguard/wg0.conf

    # Set the interface address (matches address in config file)
    ip -n $NAMESPACE address add 10.9.0.2/32 dev $INTERFACE

    ip -n $NAMESPACE link set $INTERFACE up # Start interface

    # Set wg as default route for the namespace
    ip -n $NAMESPACE route add default dev $INTERFACE
    ;;

down)
    ip netns pids $NAMESPACE | xargs -r kill # Kill wireguard
    ip netns delete $NAMESPACE               # Remove namespace
    ;;
esac
