#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

DB_ICONS="$(mktemp -u)"
SRC_ICONS="$(mktemp -u)"

MISSING_DB="$(mktemp -u)"
MISSING_SRC="$(mktemp -u)"

: "${DB_FILE:="$SCRIPT_DIR"/../data.json}"
: "${SRC_DIR:="$SCRIPT_DIR"/../src}"

cleanup() {
	rm -f "$DB_ICONS" "$SRC_ICONS" "$MISSING_DB" "$MISSING_SRC"
}

trap cleanup SIGINT ERR EXIT

pretty_output() {
	local msg="$1"
	local file="$2"

	if [ -z "$NO_COLOR" ]; then
		printf '\e[33m%s\e[0m\n' "$msg" >&2

		while read -r line; do
			printf ' \e[2;37m* %s\e[0m\n' "$line" >&2
		done < "$file"

		printf '\n'
	else
		printf '## %s' "$msg"
		cat "$file"
	fi
}

if ! command -v jq >/dev/null; then
	cat <<- EOF >&2
	$(basename "${BASH_SOURCE[0]}") requires jq command.
	Please install it to continue:

	$ sudo apt install jq
	EOF
	exit 1
fi

jq -r 'keys | .[]' "$DB_FILE" |
	sort -u > "$DB_ICONS"

find "$SRC_DIR" -maxdepth 1 -name '*.svg' -printf '%P\n' |
	sed 's/.svg$//g' |
	sort -u > "$SRC_ICONS"

comm -23 "$DB_ICONS" "$SRC_ICONS" > "$MISSING_SRC"
comm -23 "$SRC_ICONS" "$DB_ICONS" > "$MISSING_DB"

if [ -s "$MISSING_SRC" ]; then
	pretty_output \
		"The following icons provided in '$DB_FILE' but missing in '$SRC_DIR':" \
		"$MISSING_SRC"
	EXIT_CODE=1
fi

if [ -s "$MISSING_DB" ]; then
	pretty_output \
		"The following icons provided in '$SRC_DIR' but missing in '$DB_FILE':" \
		"$MISSING_DB"
	EXIT_CODE=1
fi

exit "${EXIT_CODE:-0}"
