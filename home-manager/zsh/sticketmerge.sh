#!/bin/bash
# sticketmerge - Merge multiple SNCF tickets into a single PDF, removing the
# bottom half of every ticket, which contains ads and wastes space.
# Copyright (C) 2025 tarneo <tarneo@tarneo.fr>

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# Dependencies: ghostscript, poppler-utils, pdftk

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Needs at least one argument"
    exit 1
fi

dir=$(mktemp -d)

# File names.
fn() {
    printf "$dir-%s.pdf" "$1"
}

# Get dimensions
read -r p w h <<<"$(pdfinfo "$1" | awk '/^Pages:/{print $2}/^Page size/{print $3, $5}' | tr "\n" " ")"
# pixel dimensions
((pix_w = w * 10))
((pix_h = h * 10))

printf "Size %dx%d pts of %d pages\n" "$w" "$h" "$p"

offs=50 # %

((offs = h * offs / 100))
((pix_crop_h = pix_h - offs * 10))

echo $pix_crop_h $offs

first=true
for file in "$@"; do
    gs \
        -o "$(fn cropped)" \
        -sDEVICE=pdfwrite \
        -g${pix_w}x$pix_crop_h \
        -c "<</PageOffset [0 -$offs]>> setpagedevice" \
        -f "$file"
    # shellcheck disable=SC2046
    pdfunite $($first || fn out) "$(fn cropped)" "$(fn tmp)"
    mv "$(fn tmp)" "$(fn out)"
    first=false
done

# Combine 2 pages to one.
pdfjam "$(fn out)" --nup 1x2 --outfile merged-tickets.pdf
