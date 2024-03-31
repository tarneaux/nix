#!/usr/bin/env bash

nix flake update
home-manager switch --flake .

# See which of doas or sudo is installed
if command -v doas &> /dev/null; then
    PRIVESC=doas
elif command -v sudo &> /dev/null; then
    PRIVESC=sudo
else
  echo "Neither doas nor sudo is installed"
  exit 1
fi

$PRIVESC nixos-rebuild switch --flake .
