#!/usr/bin/env bash

FONT_SIZE_LARGE=14
FONT_SIZE_SMALL=8
ZOOM_LARGE=120
ZOOM_SMALL=70
BAR_HEIGHT_LARGE=30
BAR_HEIGHT_SMALL=18
USELESS_GAP_LARGE=10
USELESS_GAP_SMALL=5

if [ "$1" = "large" ] || [ "$AUTORANDR_CURRENT_PROFILE" = "default" ]; then
    echo "Making things large"

    font_size_from=$FONT_SIZE_SMALL
    font_size_to=$FONT_SIZE_LARGE
    zoom_from=$ZOOM_SMALL
    zoom_to=$ZOOM_LARGE
    bar_height_from=$BAR_HEIGHT_SMALL
    bar_height_to=$BAR_HEIGHT_LARGE
    useless_gap_from=$USELESS_GAP_SMALL
    useless_gap_to=$USELESS_GAP_LARGE
elif [ "$1" = "small" ] || [ "$AUTORANDR_CURRENT_PROFILE" = "home" ] \
    || [ "$AUTORANDR_CURRENT_PROFILE" = "home-lid-closed" ]; then
    echo "Making things small"

    font_size_from=$FONT_SIZE_LARGE
    font_size_to=$FONT_SIZE_SMALL
    zoom_from=$ZOOM_LARGE
    zoom_to=$ZOOM_SMALL
    bar_height_from=$BAR_HEIGHT_LARGE
    bar_height_to=$BAR_HEIGHT_SMALL
    useless_gap_from=$USELESS_GAP_LARGE
    useless_gap_to=$USELESS_GAP_SMALL
else
    echo "Usage: manage-outputs [large|small]"
    echo "Couldn't detect autorandr profile. AUTORANDR_CURRENT_PROFILE=$AUTORANDR_CURRENT_PROFILE"
    exit 1
fi

# Some functions to make the sed commands more readable.
# Every one of these takes a single argument, which is the value to replace the
# placeholder with.
qutebrowser_font_size() {
    echo "c.fonts.default_size = \"${1}pt\""
}
qutebrowser_zoom() {
    echo "c.zoom.default = \"${1}%\"" 
}
awesome_font_size() {
    echo "theme.font          = \"FantasqueSansM Nerd Font ${1}\"" 
}
awesome_bar_height() {
    echo "theme.bar_height    = ${1}" 
}
awesome_useless_gap() {
    echo "theme.useless_gap = ${1}" 
}

# For each application, check if the config file contains any of the from values.
# If it does:
# - Replace it with the to value
# If it doesn't:
# - Check if the config file contains the to value. If it does, do nothing
# - Otherwise, send a notification to the user so they can fix the config file

# Qutebrowser (do everything at once to avoid reloading twice)
qutebrowser_config=~/.config/qutebrowser/dynamic.py
if grep -q "^$(qutebrowser_font_size "$font_size_from")$" $qutebrowser_config \
        && grep -q "^$(qutebrowser_zoom "$zoom_from")$" $qutebrowser_config; then
    sed -i "s/^$(qutebrowser_font_size "$font_size_from")$/$(qutebrowser_font_size "$font_size_to")/" $qutebrowser_config
    sed -i "s/^$(qutebrowser_zoom "$zoom_from")$/$(qutebrowser_zoom "$zoom_to")/" $qutebrowser_config
    pgrep qutebrowser && qutebrowser :config-source
elif ! grep -q "^$(qutebrowser_font_size "$font_size_to")$" $qutebrowser_config \
        || ! grep -q "^$(qutebrowser_zoom "$zoom_to")$" $qutebrowser_config; then
    notify-send "Couldn't set font size for qutebrowser while handling outputs" \
        "Please set the font size to $font_size_to and the zoom to $zoom_to in $qutebrowser_config"
fi

# Awesomewm
awesomewm_theme_file=~/.config/awesome/theme/theme.lua
if grep -q "^$(awesome_font_size "$font_size_from")$" $awesomewm_theme_file \
        && grep -q "^$(awesome_bar_height "$bar_height_from")$" $awesomewm_theme_file \
        && grep -q "^$(awesome_useless_gap "$useless_gap_from")$" $awesomewm_theme_file; then
    sed -i "s/^$(awesome_font_size "$font_size_from")$/$(awesome_font_size "$font_size_to")/" $awesomewm_theme_file
    sed -i "s/^$(awesome_bar_height "$bar_height_from")$/$(awesome_bar_height "$bar_height_to")/" $awesomewm_theme_file
    sed -i "s/^$(awesome_useless_gap "$useless_gap_from")$/$(awesome_useless_gap "$useless_gap_to")/" $awesomewm_theme_file
    awesome-client "awesome.restart()"
elif ! grep -q "^$(awesome_font_size "$font_size_to")$" $awesomewm_theme_file \
        || ! grep -q "^$(awesome_bar_height "$bar_height_to")$" $awesomewm_theme_file \
        || ! grep -q "^$(awesome_useless_gap "$useless_gap_to")$" $awesomewm_theme_file; then
    notify-send "Couldn't set font size for awesomewm while handling outputs" \
        "Please set the font size to $font_size_to, the bar height to $bar_height_to and the useless gap to $useless_gap_to in $awesomewm_theme_file"
fi
