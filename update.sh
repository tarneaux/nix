#!/usr/bin/env bash

nix flake update
home-manager switch --flake .
sudo nixos-rebuild switch --flake .
