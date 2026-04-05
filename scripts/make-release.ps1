param(
  [string]$Version = "v0.1.0"
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$OutDir = Join-Path $Root "dist"
$PkgName = "nanokvm-edid-tool-$Version"
$PkgDir = Join-Path $OutDir $PkgName
$Archive = Join-Path $OutDir "$PkgName.tar.gz"

if (Test-Path $PkgDir) { Remove-Item -Recurse -Force $PkgDir }
New-Item -ItemType Directory -Force -Path $PkgDir | Out-Null
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

Copy-Item -Recurse -Force (Join-Path $Root "bin") (Join-Path $PkgDir "bin")
Copy-Item -Recurse -Force (Join-Path $Root "profiles") (Join-Path $PkgDir "profiles")
Copy-Item -Force (Join-Path $Root "install.sh") (Join-Path $PkgDir "install.sh")
Copy-Item -Force (Join-Path $Root "README.md") (Join-Path $PkgDir "README.md")

if (Test-Path $Archive) { Remove-Item -Force $Archive }
tar -czf $Archive -C $OutDir $PkgName
Write-Host "Built: $Archive"
