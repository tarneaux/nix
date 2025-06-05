#!/usr/bin/env bash

CREATE="no"

while [[ $# -gt 0 ]]; do
  case $1 in
    -c|--create)
      CREATE=YES
      shift
      ;;
    http://*|https://*|about:*|*\.html|*\.xml|qute://*)
      if [ "${URL+set}" ]; then
        echo "Only one URL argument is allowed."
        exit 1
      fi
      URL="$1"
      shift
      ;;
    -*) # includes --*
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      if [ "${PROFILE+set}" ]; then
        echo "Only one profile (positional arg) is allowed."
        exit 1
      fi
      PROFILE=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

if ! [ "${PROFILE+set}" ]; then
    echo "Missing profile name."
    exit 1
fi

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

qutebrowser --basedir "$BDIR" "${URL:-}"

if [[ "$PROFILE" = "tmp" ]]; then
    rm -rf "$BDIR"
fi
