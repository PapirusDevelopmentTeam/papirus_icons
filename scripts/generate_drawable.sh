#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

: "${DRAWABLE_FILE:="$SCRIPT_DIR"/../app/src/main/res/xml/drawable.xml}"
: "${DRAWABLE_DIR:="$SCRIPT_DIR"/../app/src/main/res/drawable-nodpi}"

rm -f "$DRAWABLE_FILE"
mkdir -p "$DRAWABLE_DIR"

get_icons_from_category() {
	local category="${1,,}"
	local icon_name icon_path

	for icon_path in "$DRAWABLE_DIR"/"$category"_*; do
		[ -f "$icon_path" ] || continue
		icon_name="$(basename -- "$icon_path" .png)"
		printf '    <item drawable="%s" />\n' "$icon_name"
	done
}

cat > "$DRAWABLE_FILE" << EOF
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <version>1</version>

    <!--
    <category title="Newly Added" />
    <item drawable="email" />
    <item drawable="camera" />
    <item drawable="keyboard" />
    -->

    <category title="Apps" />
$(get_icons_from_category "Apps")

    <category title="Games" />
$(get_icons_from_category "Games")

    <category title="System" />
$(get_icons_from_category "System")

    <category title="Google" />
$(get_icons_from_category "Google")

    <category title="Yandex" />
$(get_icons_from_category "Yandex")
</resources>
EOF
