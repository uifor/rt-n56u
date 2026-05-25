#!/bin/sh

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CURRENT_WWW="$ROOT_DIR/trunk/user/www/n56u_ribbon_fixed"
MERLIN_WWW="${MERLIN_WWW:-/Volumes/rt-n56u-work/asuswrt-merlin.ng-main/release/src/router/www}"
OUT_DIR="$ROOT_DIR/docs/webui-merlin-inventory"

if [ ! -d "$MERLIN_WWW" ]; then
	echo "Merlin web UI directory not found: $MERLIN_WWW" >&2
	exit 1
fi

mkdir -p "$OUT_DIR"

find "$CURRENT_WWW" -maxdepth 1 -type f -name '*.asp' -exec basename {} \; | sort > "$OUT_DIR/current-asp.txt"
find "$MERLIN_WWW" -maxdepth 1 -type f -name '*.asp' -exec basename {} \; | sort > "$OUT_DIR/merlin-asp.txt"

comm -12 "$OUT_DIR/current-asp.txt" "$OUT_DIR/merlin-asp.txt" > "$OUT_DIR/common-asp.txt"
comm -23 "$OUT_DIR/current-asp.txt" "$OUT_DIR/merlin-asp.txt" > "$OUT_DIR/current-only-asp.txt"
comm -13 "$OUT_DIR/current-asp.txt" "$OUT_DIR/merlin-asp.txt" > "$OUT_DIR/merlin-only-asp.txt"

{
	echo "# Web UI Merlin Inventory"
	echo
	echo "Generated from:"
	echo
	echo "- Current: \`$CURRENT_WWW\`"
	echo "- Merlin: \`$MERLIN_WWW\`"
	echo
	echo "| Set | Count |"
	echo "| --- | ---: |"
	echo "| Current ASP | $(wc -l < "$OUT_DIR/current-asp.txt" | tr -d ' ') |"
	echo "| Merlin ASP | $(wc -l < "$OUT_DIR/merlin-asp.txt" | tr -d ' ') |"
	echo "| Common ASP | $(wc -l < "$OUT_DIR/common-asp.txt" | tr -d ' ') |"
	echo "| Current-only ASP | $(wc -l < "$OUT_DIR/current-only-asp.txt" | tr -d ' ') |"
	echo "| Merlin-only ASP | $(wc -l < "$OUT_DIR/merlin-only-asp.txt" | tr -d ' ') |"
	echo
	echo "## Common ASP"
	echo
	sed 's/^/- `/' "$OUT_DIR/common-asp.txt" | sed 's/$/`/'
	echo
	echo "## Current-Only ASP"
	echo
	sed 's/^/- `/' "$OUT_DIR/current-only-asp.txt" | sed 's/$/`/'
} > "$OUT_DIR/summary.md"

echo "Wrote $OUT_DIR"
