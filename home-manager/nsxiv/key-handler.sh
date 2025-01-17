#!/usr/bin/env bash

while read -r file; do
case "$1" in
  "y")
    # Copy the absolute path to the clipboard.
    # Will select the last one if multiple are selected.
    # This has the side-effect of adding a dot in the middle of the
    # path, but it's not a big deal since it evaluates to the same path.
    echo -n "$PWD/$file" | xclip -selection clipboard ;;
  "Y")
    # Copy the image ITSELF to the clipboard.
    # Will select the last one if multiple are selected.
    xclip -selection clipboard -t image/png -i "$file" ;;
  "p")
    echo "$file" ;;
  "r")
    convert -rotate 90 "$file" "$file" ;;
  "R")
    convert -rotate -90 "$file" "$file" ;;
  esac
done
