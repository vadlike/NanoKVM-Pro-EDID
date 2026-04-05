#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-/usr/local}"
BIN_DIR="$PREFIX/bin"
DATA_DIR="${DATA_DIR:-/opt/nanokvm-edid/profiles}"
NANOKVM_EDID_REPO="${NANOKVM_EDID_REPO:-vadlike/NanoKVM-Pro-EDID}"
NANOKVM_EDID_REF="${NANOKVM_EDID_REF:-main}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run as root: sudo bash install.sh" >&2
  exit 1
fi

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

fetch_from_github() {
  local raw_base="https://raw.githubusercontent.com/$NANOKVM_EDID_REPO/$NANOKVM_EDID_REF"
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT

  require_cmd curl
  curl -fsSL "$raw_base/bin/nanokvm-edid" -o "$tmp_dir/nanokvm-edid"
  curl -fsSL "$raw_base/profiles/e18-2560x1600.bin" -o "$tmp_dir/e18-2560x1600.bin"

  SRC_BIN="$tmp_dir/nanokvm-edid"
  SRC_PROFILE="$tmp_dir/e18-2560x1600.bin"
  echo "Source: github $NANOKVM_EDID_REPO@$NANOKVM_EDID_REF"
}

SRC_BIN="$SCRIPT_DIR/bin/nanokvm-edid"
SRC_PROFILE="$SCRIPT_DIR/profiles/e18-2560x1600.bin"
if [[ ! -f "$SRC_BIN" || ! -f "$SRC_PROFILE" ]]; then
  fetch_from_github
else
  echo "Source: local files"
fi

install -d "$BIN_DIR"
install -d "$DATA_DIR"
install -m 0755 "$SRC_BIN" "$BIN_DIR/nanokvm-edid"
install -m 0644 "$SRC_PROFILE" "$DATA_DIR/e18-2560x1600.bin"

echo "Installed:"
echo "  $BIN_DIR/nanokvm-edid"
echo "  $DATA_DIR/e18-2560x1600.bin"
echo
echo "Try:"
echo "  nanokvm-edid list"
echo "  nanokvm-edid apply 2560x1600"
