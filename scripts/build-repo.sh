#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT="${ROOT}/public"
REPO_DIR="$(mktemp -d)"
TMP_CONF="$(mktemp -d)"

trap 'rm -rf "$REPO_DIR" "$TMP_CONF"' EXIT

: "${APT_GPG_KEY_ID:?APT_GPG_KEY_ID is not set}"

command -v reprepro >/dev/null
command -v gpg >/dev/null

if [[ ! -f "$ROOT/repo.gpg" ]]; then
    echo "error: repo.gpg is missing" >&2
    exit 1
fi

sed "s/^SignWith:.*/SignWith: ${APT_GPG_KEY_ID}/" \
    "$ROOT/conf/distributions" > "$TMP_CONF/distributions"

reprepro -b "$REPO_DIR" --confdir "$TMP_CONF" export stable

shopt -s nullglob
packages=("$ROOT"/packages/*.deb)

for package in "${packages[@]}"; do
    echo "Including ${package##*/}"
    reprepro -b "$REPO_DIR" --confdir "$TMP_CONF" \
        -C main -A amd64 includedeb stable "$package"
done

rm -rf "$OUTPUT"
mkdir -p "$OUTPUT"

cp -a "$REPO_DIR/dists" "$OUTPUT/"
cp -a "$REPO_DIR/pool" "$OUTPUT/"
cp "$ROOT/repo.gpg" "$OUTPUT/repo.gpg"

echo "Repository generated in $OUTPUT"