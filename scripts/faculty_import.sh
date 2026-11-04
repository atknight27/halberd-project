#!/usr/bin/env bash
set -Eeuo pipefail
export LC_ALL=C

cd "$(dirname "$0")/.."
mkdir -p data

if [[ -z "${FACULTY_URL:-}" ]]; then
    echo "ERROR: FACULTY_URL is not set." >&2
    exit 1
fi

html=$(mktemp)
cleaned=$(mktemp)
names=$(mktemp)
trap 'rm -f "$html" "$cleaned" "$names"' EXIT

echo "Downloading faculty page..."

if ! curl -fLsS --max-time 30 \
    "$FACULTY_URL" -o "$html"; then
    echo "ERROR: Could not download page." >&2
    exit 1
fi

tr '\r\n' '  ' < "$html" \
    | sed -E 's/<h4/\n&/g; s/<\/h4>/&\n/g' \
    | { grep -E '^<h4[^>]*>[[:space:]]*<strong' || true; } \
    | sed -E \
        -e 's/<[^>]+>//g' \
        -e 's/&nbsp;|\xC2\xA0/ /g' \
        -e 's/,.*//' \
        -e 's/[[:space:]]+Ph\.?[[:space:]]*D\.?[[:space:]]*$//I' \
        -e 's/^[[:space:]]*((Dr|Prof|Professor|Mr|Mrs|Ms)\.?[[:space:]]+)+//I' \
        -e 's/^[[:space:]]+|[[:space:]]+$//g' \
        -e 's/[[:space:]]+/ /g' \
        -e 's/^([^ ]+) (.* )?([^ ]+)$/\1\t\3/' \
    > "$cleaned"

valid=$'^[A-Za-z][A-Za-z\'-]*\t[A-Za-z][A-Za-z\'-]*$'

{ grep -vE "$valid" "$cleaned" || true; } \
    | sed 's/.*/WARNING: Skipping unusable name: [&]/' >&2

{ grep -E "$valid" "$cleaned" || true; } | sort -u > "$names"

if [[ ! -s "$names" ]]; then
    echo "ERROR: No faculty names extracted." >&2
    exit 1
fi

mv "$names" data/faculty_names.txt
echo "Imported $(wc -l < data/faculty_names.txt) names."
