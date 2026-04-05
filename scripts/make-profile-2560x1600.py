#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BASE = ROOT / "E18-4K30FPS.bin"
OUT = ROOT / "profiles/e18-2560x1600.bin"

data = bytearray(BASE.read_bytes())
if len(data) != 256:
    raise SystemExit(f"Expected 256 bytes in {BASE}, got {len(data)}")

# Preferred timing DTD: 2560x1600@60.
data[54:72] = bytes.fromhex("C0 72 00 A0 A0 40 C8 60 30 20 36 00 59 D7 10 00 00 1A")

# Change IDs so Windows treats it as a new display entry.
data[10:16] = bytes.fromhex("57 26 11 22 33 44")

# EDID checksums.
data[127] = (-sum(data[:127])) & 0xFF
data[255] = (-sum(data[128:255])) & 0xFF

OUT.parent.mkdir(parents=True, exist_ok=True)
OUT.write_bytes(data)
print(f"Wrote {OUT} ({len(data)} bytes)")
