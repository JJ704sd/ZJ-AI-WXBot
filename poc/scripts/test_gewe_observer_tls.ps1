# Local TLS synthetic check. Does not call GeWe or M3 and does not trust a cert globally.
# Uses the project-local Caddy portable binary. Does not install a service or change PATH.
# Exits 2 when the local Caddy binary is missing; that is G2b skipped, not a false HTTPS pass.
$ErrorActionPreference = "Stop"
$poc = Split-Path -Parent $PSScriptRoot
$caddy = Join-Path $poc ".local\tools\caddy\caddy.exe"
if (-not (Test-Path $caddy)) {
    Write-Output "G2b_SKIPPED: local Caddy portable is missing at poc/.local/tools/caddy/caddy.exe; HTTPS reverse-proxy chain was not executed."
    exit 2
}
$python = Join-Path $poc ".venv\Scripts\python.exe"
if (-not (Test-Path $python)) {
    Write-Error "poc/.venv is missing"
}
$env:G2B_CADDY_EXE = $caddy
Set-Location $poc
& $python -m pytest tests/test_g2b_https.py -q --tb=short
exit $LASTEXITCODE
