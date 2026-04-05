#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-/usr/local}"
BIN_DIR="$PREFIX/bin"
DATA_DIR="${DATA_DIR:-/opt/nanokvm-edid/profiles}"
NANOKVM_EDID_REPO="${NANOKVM_EDID_REPO:-vadlike/NanoKVM-Pro-EDID}"
NANOKVM_EDID_REF="${NANOKVM_EDID_REF:-main}"

SCRIPT_SOURCE="${BASH_SOURCE[0]:-$0}"
if [[ -n "${SCRIPT_SOURCE:-}" && -f "$SCRIPT_SOURCE" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" && pwd)"
else
  SCRIPT_DIR="$(pwd)"
fi

TMP_DIR=""
cleanup() {
  if [[ -n "${TMP_DIR:-}" && -d "$TMP_DIR" ]]; then
    rm -rf "$TMP_DIR"
  fi
}
trap cleanup EXIT

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

install_permanently() {
  install -d "$BIN_DIR"
  install -d "$DATA_DIR"
  install -m 0755 "$SRC_BIN" "$BIN_DIR/nanokvm-edid"
  install -m 0644 "$SRC_PROFILE" "$DATA_DIR/e18-2560x1600.bin"
  echo "Installed:"
  echo "  $BIN_DIR/nanokvm-edid"
  echo "  $DATA_DIR/e18-2560x1600.bin"
}

fetch_from_github() {
  local ref_path="$NANOKVM_EDID_REF"
  if [[ "$ref_path" == "main" ]]; then
    ref_path="refs/heads/main"
  fi
  local raw_base="https://raw.githubusercontent.com/$NANOKVM_EDID_REPO/$ref_path"
  local cache_bust
  cache_bust="$(date +%s)"
  TMP_DIR="$(mktemp -d)"

  require_cmd curl
  curl -fsSL "$raw_base/bin/nanokvm-edid?nocache=$cache_bust" -o "$TMP_DIR/nanokvm-edid"
  curl -fsSL "$raw_base/profiles/e18-2560x1600.bin?nocache=$cache_bust" -o "$TMP_DIR/e18-2560x1600.bin"
  chmod +x "$TMP_DIR/nanokvm-edid"

  SRC_BIN="$TMP_DIR/nanokvm-edid"
  SRC_PROFILE="$TMP_DIR/e18-2560x1600.bin"
  echo "Source: github $NANOKVM_EDID_REPO@$NANOKVM_EDID_REF"
}

SRC_BIN="$SCRIPT_DIR/bin/nanokvm-edid"
SRC_PROFILE="$SCRIPT_DIR/profiles/e18-2560x1600.bin"
if [[ ! -f "$SRC_BIN" || ! -f "$SRC_PROFILE" ]]; then
  fetch_from_github
else
  echo "Source: local files"
fi

install_permanently

if exec 3<>/dev/tty 2>/dev/null; then
  echo "Opening preset menu..." >&3
  NANOKVM_EDID_CUSTOM_DIR="$DATA_DIR" "$BIN_DIR/nanokvm-edid" menu <&3 >&3 2>&3 || true
  exec 3>&-
else
  echo
  echo "Run:"
  echo "  nanokvm-edid"
fi
