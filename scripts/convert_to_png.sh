#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

: "${DEST_DIR:="$SCRIPT_DIR"/../app/src/main/res/drawable-nodpi}"
: "${SRC_DIR:="$SCRIPT_DIR"/../src}"
: "${ICON_SIZE:=192}"
: "${THREADS:=$(nproc)}"

do_convert_to_png() {
	local file="$1"
	local bitmap_file

	bitmap_file="${DEST_DIR}/$(basename -- "$file" .svg).png"
	printf 'Converting "%s" -> "%s"\n' "$file" "$bitmap_file" >&2
	inkscape -z "$file" -w "$ICON_SIZE" -h "$ICON_SIZE" -e "$bitmap_file" >/dev/null
}

mkdir -p "$DEST_DIR"

# Delete PNG files from the destination directory
find "$DEST_DIR" -name '*.png' -delete

export DEST_DIR ICON_SIZE
export -f do_convert_to_png

# Convert to bitmap images
find "$SRC_DIR" -maxdepth 1 -name '*.svg' -print0 |
	xargs -0 -I {} -P "$THREADS" bash -c 'do_convert_to_png "$@"' _ {}
