JOURNAL_PATH="$HOME/space/journal/"

BUILD_DIR="$(mktemp -d)"

rg --multiline '.\n\!\[' "$JOURNAL_PATH" && {
    echo "ERROR: There are images without enough newlines before them in some files. They are listed above."
}

tee "$BUILD_DIR"/tmp.md >/dev/null <<EOF
---
mainfont: DejaVuSans
geometry: margin=2cm
---
EOF

find "$JOURNAL_PATH" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' |
    while read -r dir; do
        date="$(LANG=fr_FR.UTF-8 date -d "$dir" '+%A %d %B %Y')"
        echo "# $date"
        printf '\n'
        find "$JOURNAL_PATH/$dir" -mindepth 1 -maxdepth 1 -type f -iname '*.md' -printf '%f\n' |
            while read -r note; do
                time=$(echo "$note" | sed -E -e 's/\.md$//g' -e 's/-[0-9]{2}$//g' -e 's/-/:/g')
                echo "## $time"
                printf '\n'
                sed 's/$/\n/g' <"$JOURNAL_PATH/$dir/$note"
                printf '\n'
                printf '\n'
            done
    done \
        >>"$BUILD_DIR"/tmp.md

find "$JOURNAL_PATH" -mindepth 1 -type f \( -iname '*.jpeg' -or -iname '*.jpg' -or -iname '*.png' -or -iname '*.JPEG' -or -iname '*.JPG' -or -iname '*.PNG' \) -exec cp '{}' "$BUILD_DIR"/ \;

echo "If you get a cryptic error about a missing file, see:"
echo "https://tex.stackexchange.com/questions/416183/setmainfont-error-on-path-2-levels-deep"

cd "$BUILD_DIR" || exit 1
pandoc tmp.md -o ~/journal.pdf --pdf-engine=lualatex -f markdown-implicit_figures
cd - || exit 1

echo "Successfully exported to ~/journal.pdf."
