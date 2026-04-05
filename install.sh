#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-/usr/local}"
BIN_DIR="$PREFIX/bin"
DATA_DIR="${DATA_DIR:-/opt/nanokvm-edid/profiles}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run as root: sudo bash install.sh" >&2
  exit 1
fi

install -d "$BIN_DIR"
install -d "$DATA_DIR"
install -m 0755 "$SCRIPT_DIR/bin/nanokvm-edid" "$BIN_DIR/nanokvm-edid"
install -m 0644 "$SCRIPT_DIR/profiles/e18-2560x1600.bin" "$DATA_DIR/e18-2560x1600.bin"

echo "Installed:"
echo "  $BIN_DIR/nanokvm-edid"
echo "  $DATA_DIR/e18-2560x1600.bin"
echo
echo "Try:"
echo "  nanokvm-edid list"
echo "  nanokvm-edid apply 2560x1600"
