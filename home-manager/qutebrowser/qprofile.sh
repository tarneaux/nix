#!/usr/bin/env bash

POSITIONAL_ARGS=()

CREATE="no"

while [[ $# -gt 0 ]]; do
  case $1 in
    -c|--create)
      CREATE=YES
      shift
      ;;
    -*) # includes --*
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [[ $# -ne 1 ]]; then
    echo "Exactly one positional argument is required."
    exit 1
fi

PROFILE="$1"

if [[ "$PROFILE" = "tmp" ]]; then
    BDIR="$(mktemp -d)"
else
    BDIR=~/.config/qb-profiles/"$PROFILE"
fi

if [[ "$PROFILE" = "tmp" ]] || [[ "$CREATE" = "YES" ]]; then
    mkdir -p "$BDIR"/config/
    mkdir -p "$BDIR"/data/
fi

cp -f ~/.config/qutebrowser/config.py "$BDIR"/config/config.py
ln -sf ~/.config/qutebrowser/greasemonkey "$BDIR"/config/
cp -f ~/.local/share/qutebrowser/blocked-hosts "$BDIR"/data/blocked-hosts

if [[ ! -d "$BDIR" ]]; then
    echo "Base directory not found, specify --create to create it"
    exit 1
fi

qutebrowser --basedir "$BDIR"

if [[ "$PROFILE" = "tmp" ]]; then
    rm -rf "$BDIR"
fi
