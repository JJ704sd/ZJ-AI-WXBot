#requires -Version 5.1
[CmdletBinding()]
param(
    [ValidateSet('Database', 'Demo', 'Live')][string]$Mode = 'Database',
    [string]$RuntimeDir = ''
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$rootDir = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$serverPath = Join-Path $rootDir 'web_mvp\server.py'

try {
    if (-not $RuntimeDir) {
        $folder = if ($Mode -eq 'Database') { '.runtime\web_mvp-database' } elseif ($Mode -eq 'Demo') { '.runtime\web_mvp-demo' } else { '.runtime\web_mvp' }
        $RuntimeDir = Join-Path $rootDir $folder
    } elseif (-not [IO.Path]::IsPathRooted($RuntimeDir)) {
        $RuntimeDir = Join-Path $rootDir $RuntimeDir
    }
    $RuntimeDir = [IO.Path]::GetFullPath($RuntimeDir)
    $pidFile = Join-Path $RuntimeDir 'server.pid'
    if (-not (Test-Path -LiteralPath $pidFile -PathType Leaf)) {
        Write-Host 'No PID file found. No process was stopped.'
        exit 0
    }
    $serverPid = 0
    if (-not [int]::TryParse((Get-Content -LiteralPath $pidFile -Raw).Trim(), [ref]$serverPid) -or $serverPid -le 0) {
        throw 'Invalid PID file. No process was stopped.'
    }
    $processInfo = Get-Process -Id $serverPid -ErrorAction SilentlyContinue
    if (-not $processInfo) {
        Write-Host 'The recorded server process has already stopped. No process was stopped.'
        exit 0
    }
    $ownershipPath = Join-Path $RuntimeDir 'launcher-process.json'
    if (-not (Test-Path -LiteralPath $ownershipPath -PathType Leaf)) {
        throw 'This process has no Windows launcher ownership record. Stop it in its original terminal. No process was stopped.'
    }
    $ownership = Get-Content -LiteralPath $ownershipPath -Raw | ConvertFrom-Json
    if ($ownership.processId -ne $serverPid -or
        $ownership.startTimeUtcTicks -ne $processInfo.StartTime.ToUniversalTime().Ticks.ToString() -or
        $ownership.executable -ne $processInfo.Path -or
        $ownership.server -ne $serverPath -or
        $ownership.runtimeDirectory -ne $RuntimeDir -or
        $ownership.mode -ne $Mode.ToLowerInvariant()) {
        throw 'The PID, process start time, or project ownership does not match. No process was stopped.'
    }
    $ownership | Add-Member -NotePropertyName stopRequested -NotePropertyValue $true -Force
    $ownership | ConvertTo-Json | Set-Content -LiteralPath $ownershipPath -Encoding UTF8
    Stop-Process -Id $serverPid -ErrorAction Stop
    Write-Host 'Stopped the web workbench. The Docker container and WeChat client were not stopped.'
} catch {
    Write-Host ('ERROR: ' + $_.Exception.Message) -ForegroundColor Red
    exit 1
}
