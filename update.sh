#!/usr/bin/env bash

REBUILD_OPTS=""

if [ "$(hostname)" = chorizo ]; then
    REBUILD_OPTS+="-j 1"
fi

nix flake update
home-manager switch --flake . $REBUILD_OPTS

# See which of doas or sudo is installed
if command -v doas &>/dev/null; then
    PRIVESC=doas
elif command -v sudo &>/dev/null; then
    PRIVESC=sudo
else
    echo "Neither doas nor sudo is installed"
    exit 1
fi

$PRIVESC nixos-rebuild switch --flake . $REBUILD_OPTS
