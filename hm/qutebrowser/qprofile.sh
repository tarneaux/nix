#!/usr/bin/env bash

CREATE="no"

while [[ $# -gt 0 ]]; do
    case $1 in
    -c | --create)
        CREATE=YES
        shift
        ;;
    *)
        PROFILE=("$1") # save positional arg
        shift          # past argument
        break
        ;;
    esac
done

if ! [ "${PROFILE+set}" ]; then
    echo "Missing profile name."
    exit 1
fi

if [[ $PROFILE == "tmp" ]]; then
    BDIR="$(mktemp -d)"
else
    BDIR=~/.config/qb-profiles/"$PROFILE"
fi

if [[ $PROFILE == "tmp" ]] || [[ $CREATE == "YES" ]]; then
    mkdir -p "$BDIR"/config/
    mkdir -p "$BDIR"/data/
fi

ln -sf ~/.config/qutebrowser/config.py "$BDIR"/config/config.py
ln -sf ~/.config/qutebrowser/greasemonkey "$BDIR"/config/
ln -sf ~/.local/share/qutebrowser/blocked-hosts "$BDIR"/data/blocked-hosts

if [[ ! -d $BDIR ]]; then
    echo "Base directory not found, specify --create to create it"
    exit 1
fi

qutebrowser --basedir "$BDIR" :adblock-update "$@"

if [[ $PROFILE == "tmp" ]]; then
    rm -rf "$BDIR"
fi
