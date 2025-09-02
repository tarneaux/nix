#!/bin/sh -e

# Get the current state of the internal keyboard (if it's disabled or not)
# We will use this to restore the state of the keyboard after unlocking
INITIAL_KEYBOARD_STATE=$(xinput list-props "AT Translated Set 2 keyboard" |
    grep "Device Enabled" |
    grep -o "[01]$")

# Enable the internal keyboard to prevent locking us out from the system in
# case we have no other keyboard available
xinput set-prop "AT Translated Set 2 keyboard" "Device Enabled" "1"

SCREEN_SIZE=$(xrandr |
    grep -oP 'connected( primary)? \d+x\d+' |
    grep -oP '\d+x\d+' |
    tail -n1)

if [ -z "$SCREEN_SIZE" ]; then
    echo "Could not get screen size, falling back to 1920x1080"
    SCREEN_SIZE="1920x1080"
fi

WALLPAPER_PATH=$(awesome-client "return require('beautiful').lockwall" |
    sed "s/^\s*string \"//" | sed "s/\"$//")

I3LOCK_CMD="i3lock --nofork"

if [ -z "$WALLPAPER_PATH" ]; then
    echo "Could not get wallpaper path, falling back to solid background"
    eval "$I3LOCK_CMD --color=e9967a"
else
    magick "$WALLPAPER_PATH" \
        -gravity west -resize "${SCREEN_SIZE}^" -extent "$SCREEN_SIZE" \
        RGB:- |
        eval "$I3LOCK_CMD --raw $SCREEN_SIZE:rgb --image /dev/stdin"
fi

# Restore the state of the internal keyboard
xinput set-prop "AT Translated Set 2 keyboard" \
    "Device Enabled" "$INITIAL_KEYBOARD_STATE"
