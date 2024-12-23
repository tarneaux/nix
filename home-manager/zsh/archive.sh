#!/usr/bin/env bash

if [[ -z "$ARCHIVE_DIR" ]]; then
    echo "\$ARCHIVE_DIR is unset, refusing to continue."
    exit 1
fi

ARCHIVE_DIR="${ARCHIVE_DIR/#\~/$HOME}"

FILES=()
CMD="mv -i"

usage() {
    echo "archive [options] <file> ..."
    echo "Options:"
    echo "  -k, --keep          Keep the archived file (copy, not move)"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -k|--keep) CMD="rsync -a --info=progress2" ;;
        -*)
            usage
            exit 1
            ;;
        *) FILES+=("$1") ;;
    esac
    shift
done


DATE=$(date --iso-8601)

to_dest() {
    echo "$ARCHIVE_DIR/$DATE-$(basename "$1")"
}

for file in "${FILES[@]}"; do
    if [[ ! -e "$file" ]]; then
        echo "$file doesn't exist, aborting."
        exit 1
    fi
    dst=$(to_dest "$file")
    if [[ -e "$dst" ]]; then
        echo "$dst already exists, aborting."
        exit 1
    fi
done

for file in "${FILES[@]}"; do
    dst=$(to_dest "$file")
    $CMD "$file" "$dst"
    trash -f "$dst/.direnv" "$dst/.devenv" "$dst/.venv" "$dst/venv"
done
