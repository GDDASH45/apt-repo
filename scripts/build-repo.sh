#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT="${ROOT}/public"
TMP_CONF="$(mktemp -d)"

trap 'rm -rf "$TMP_CONF"' EXIT

: "${APT_GPG_KEY_ID:?APT_GPG_KEY_ID is not set}"

command -v reprepro >/dev/null
command -v gpg >/dev/null

mkdir -p "$OUTPUT"

sed "s/^SignWith:.*/SignWith: ${APT_GPG_KEY_ID}/" \
    "$ROOT/conf/distributions" > "$TMP_CONF/distributions"

reprepro -b "$OUTPUT" --confdir "$TMP_CONF" export stable

shopt -s nullglob
packages=("$ROOT"/packages/*.deb)

for package in "${packages[@]}"; do
    echo "Including ${package##*/}"
    reprepro -b "$OUTPUT" --confdir "$TMP_CONF" \
        -C main -A amd64 includedeb stable "$package"
done

echo "Repository generated in $OUTPUT"
