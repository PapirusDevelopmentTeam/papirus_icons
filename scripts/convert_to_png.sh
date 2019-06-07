#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

: "${DEST_DIR:="$SCRIPT_DIR"/../app/src/main/res/drawable-nodpi}"
: "${SRC_DIR:="$SCRIPT_DIR"/../src}"
: "${ICON_SIZE:=192}"

mkdir -p "$DEST_DIR"

# Delete PNG files from the destination directory
find "$DEST_DIR" -name '*.png' -delete

# Convert to bitmap images
find "$SRC_DIR" -maxdepth 1 -name '*.svg' | while read -r file; do
	bitmap_file="${DEST_DIR}/$(basename -- "$file" .svg).png"
	printf 'Converting "%s" -> "%s"\n' "$file" "$bitmap_file" >&2
	inkscape -z "$file" -w "$ICON_SIZE" -h "$ICON_SIZE" -e "$bitmap_file"
done
