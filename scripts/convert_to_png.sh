#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
INKSCAPE_VERSION=$(inkscape --version 2>/dev/null | awk '/Inkscape[ ]/ {print $2; exit}')

: "${DEST_DIR:="$SCRIPT_DIR"/../app/src/main/res/drawable-nodpi}"
: "${SRC_DIR:="$SCRIPT_DIR"/../src}"
: "${ICON_SIZE:=192}"
: "${THREADS:=$(nproc)}"

do_convert_to_png() {
	local file="$1"
	local bitmap_file svg_mtime png_mtime

	bitmap_file="${DEST_DIR}/$(basename -- "$file" .svg).png"

	if [ -f "$bitmap_file" ]; then
		svg_mtime="$(stat -c '%Y' "$file")"
		png_mtime="$(stat -c '%Y' "$bitmap_file")"

		if (( png_mtime > svg_mtime )); then
			# exit when PNG file exists and the modification time is
			# newer than on SVG file
			return 0
		fi
	fi

	printf 'Converting "%s" -> "%s"\n' "$file" "$bitmap_file" >&2

	if [ "${INKSCAPE_VERSION%%.*}" -eq 0 ]; then
		inkscape -z -w "$ICON_SIZE" -h "$ICON_SIZE" -e "$bitmap_file" "$file" >/dev/null
	else
		inkscape -w "$ICON_SIZE" -h "$ICON_SIZE" -o "$bitmap_file" "$file" >/dev/null
	fi
}

mkdir -p "$DEST_DIR"

export DEST_DIR ICON_SIZE
export -f do_convert_to_png

# Convert to bitmap images
find "$SRC_DIR" -maxdepth 1 -name '*.svg' -print0 |
	xargs -0 -I {} -P "$THREADS" bash -c 'do_convert_to_png "$@"' _ {}
