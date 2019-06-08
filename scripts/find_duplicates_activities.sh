#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

: "${DB_FILE:="$SCRIPT_DIR"/../data.json}"

if ! command -v jq >/dev/null; then
	cat <<- EOF >&2
	$(basename "${BASH_SOURCE[0]}") requires jq command.
	Please install it to continue:

	$ sudo apt install jq
	EOF
	exit 1
fi

# Get duplicates and then show them with line numbers
while read -r activity; do
	GREP_COLOR='33' grep --color=auto -n "$activity" "$DB_FILE"
	EXIT_CODE=1
done < <(jq -r '.[][]' "$DB_FILE" | sort | uniq -D | uniq)

exit "${EXIT_CODE:-0}"
