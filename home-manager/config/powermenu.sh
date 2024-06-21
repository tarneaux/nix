#!/bin/sh -e

action=$(printf 'suspend\nhibernate\nreboot\nshutdown' | dmenu)

case $action in
    suspend)
        systemctl suspend
        ;;
    hibernate)
        systemctl hibernate
        ;;
    reboot)
        reboot
        ;;
    shutdown)
        shutdown now
        ;;
esac
