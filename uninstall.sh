#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-/usr/local}"
BIN_DIR="$PREFIX/bin"
DATA_DIR="${DATA_DIR:-/opt/nanokvm-edid/profiles}"

BIN_PATH="$BIN_DIR/nanokvm-edid"
PROFILE_PATH="$DATA_DIR/e18-2560x1600.bin"

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Run as root: sudo bash uninstall.sh" >&2
  exit 1
fi

removed_any="no"

if [[ -f "$BIN_PATH" ]]; then
  rm -f "$BIN_PATH"
  echo "Removed: $BIN_PATH"
  removed_any="yes"
else
  echo "Not found: $BIN_PATH"
fi

if [[ -f "$PROFILE_PATH" ]]; then
  rm -f "$PROFILE_PATH"
  echo "Removed: $PROFILE_PATH"
  removed_any="yes"
else
  echo "Not found: $PROFILE_PATH"
fi

if [[ -d "$DATA_DIR" ]] && [[ -z "$(ls -A "$DATA_DIR" 2>/dev/null)" ]]; then
  rmdir "$DATA_DIR" || true
  parent_dir="$(dirname "$DATA_DIR")"
  if [[ -d "$parent_dir" ]] && [[ -z "$(ls -A "$parent_dir" 2>/dev/null)" ]]; then
    rmdir "$parent_dir" || true
  fi
fi

if [[ "$removed_any" == "yes" ]]; then
  echo "Uninstall completed."
else
  echo "Nothing to remove."
fi
