#! /usr/bin/env bash

# Based on: https://git.zx2c4.com/password-store/tree/contrib/dmenu/passmenu

shopt -s nullglob globstar

usage() {
    echo "Usage: $(basename "$0") [action]"
    echo "Possible actions: print copy type"
    echo "Default: print"
}

ACTION="print"
if [[ $# -eq 1 ]]; then
    case $1 in
    t | type)
        ACTION="type"
        ;;
    c | copy)
        ACTION="copy"
        ;;
    p | print)
        ACTION="print"
        ;;
    *)
        usage
        exit 1
        ;;
    esac
elif [[ $# -gt 2 ]]; then
    usage
    exit 1
fi

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=("$prefix"/**/*.gpg)
password_files=("${password_files[@]#"$prefix"/}")
password_files=("${password_files[@]%.gpg}")

ignorefile=${PASS_IGNORE_PATH-~/.passignore}
password=$(printf '%s\n' "${password_files[@]}" |
    grep -vxF -f "$ignorefile" |
    rofi -dmenu -p "Select password to $ACTION")

[[ -n $password ]] || exit

if [[ $ACTION = "print" ]]; then
    pass show "$password" 2>/dev/null
elif [[ $ACTION = "copy" ]]; then
    pass show -c "$password" 2>/dev/null
else
    pass show "$password" |
        {
            IFS= read -r pass
            printf %s "$pass"
        } |
        xdotool type --clearmodifiers --file -
fi
