#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-v0.1.0}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$ROOT_DIR/dist"
PKG_DIR="$OUT_DIR/nanokvm-edid-tool-$VERSION"
ARCHIVE="$OUT_DIR/nanokvm-edid-tool-$VERSION.tar.gz"

rm -rf "$PKG_DIR"
mkdir -p "$PKG_DIR"
mkdir -p "$OUT_DIR"

cp -r "$ROOT_DIR/bin" "$PKG_DIR/"
cp -r "$ROOT_DIR/profiles" "$PKG_DIR/"
cp "$ROOT_DIR/install.sh" "$PKG_DIR/"
cp "$ROOT_DIR/README.md" "$PKG_DIR/"

tar -czf "$ARCHIVE" -C "$OUT_DIR" "nanokvm-edid-tool-$VERSION"
echo "Built: $ARCHIVE"
