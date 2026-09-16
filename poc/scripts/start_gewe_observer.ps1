# Foreground GeWe observer start. Does not install autostart or change the system trust store.
param(
    [Parameter(Mandatory = $true)]
    [string]$ObserverConfig,
    [Parameter(Mandatory = $true)]
    [string]$DeploymentConfig
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path (Join-Path $root "poc"))) {
    $root = Split-Path -Parent $PSScriptRoot
}
Set-Location (Join-Path $root "poc")
$python = Join-Path (Get-Location) ".venv\Scripts\python.exe"
if (-not (Test-Path $python)) {
    Write-Error "poc/.venv is missing"
}
if (-not $env:WECHAT_CALLBACK_SECRET -or -not $env:WECHAT_CALLBACK_BRIDGE_TOKEN) {
    Write-Error "callback secrets must be set in the environment, not on the command line"
}

& $python -m wechat_agent_poc.api_cli --observer-config $ObserverConfig api-observe start --serve --deployment-config $DeploymentConfig
exit $LASTEXITCODE
