#! zsh

[[ -z $1 ]] && echo "Usage: $0 <host-to-build-config-for>" && exit 0

sudo nixos-rebuild switch --flake .#$1
