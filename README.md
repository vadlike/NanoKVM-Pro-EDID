# nanokvm-edid-tool

CLI for fast EDID/profile switching on NanoKVM Pro from terminal.

## Features
- One command to switch EDID presets.
- Custom preset `2560x1600` (based on stable `E18` profile).
- Automatic EDID backup before every apply.
- HDMI retrain helper.

## Install On NanoKVM
1. Copy release files to NanoKVM (`scp` or `rsync`).
2. Run:

```bash
sudo bash install.sh
```

## Install Via Curl
```bash
curl -fsSL https://raw.githubusercontent.com/vadlike/NanoKVM-Pro-EDID/main/install.sh | sudo bash
```

Install from a specific tag:

```bash
curl -fsSL https://raw.githubusercontent.com/vadlike/NanoKVM-Pro-EDID/main/install.sh | sudo NANOKVM_EDID_REF=v0.1.0 bash
```

## Quick Usage
```bash
nanokvm-edid list
nanokvm-edid status
nanokvm-edid apply 2560x1600
nanokvm-edid apply e18
nanokvm-edid restore
```

## Presets
- `e18` -> `/kvmcomm/edid/E18-4K30FPS.bin`
- `e48` -> `/kvmcomm/edid/E48-4K39FPS.bin`
- `e54` -> `/kvmcomm/edid/E54-1080P60FPS.bin`
- `e56` -> `/kvmcomm/edid/E56-2K60FPS.bin`
- `e58` -> `/kvmcomm/edid/E58-4K16-10.bin`
- `e63` -> `/kvmcomm/edid/E63-Ultrawide.bin`
- `2560x1600` -> `/opt/nanokvm-edid/profiles/e18-2560x1600.bin`

## Build Release Archive
```bash
bash scripts/make-release.sh v0.1.0
```

Archive will be created in `dist/`.

Windows PowerShell alternative:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/make-release.ps1 -Version v0.1.0
```

## GitHub Release Flow
1. Create repo and push:

```bash
git init
git add .
git commit -m "Initial nanokvm-edid-tool"
git branch -M main
git remote add origin <YOUR_REPO_URL>
git push -u origin main
```

2. Create tag and release:

```bash
git tag v0.1.0
git push origin v0.1.0
```

3. Upload `dist/nanokvm-edid-tool-v0.1.0.tar.gz` to GitHub Release assets.

## Notes
- `2560x1600@120` is not supported by NanoKVM Pro capture path.
- `2560x1600` in this tool is `~60Hz`.
