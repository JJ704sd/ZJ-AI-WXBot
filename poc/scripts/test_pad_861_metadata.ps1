param([switch]$HttpAuthOnly, [switch]$PrepareDevice)
$ErrorActionPreference = 'Stop'
$pocRoot = Split-Path $PSScriptRoot -Parent
$localRoot = Join-Path $pocRoot '.local/pad-legacy-861'
$runtimeRoot = Join-Path $localRoot 'runtime'
$exe = Join-Path $runtimeRoot 'wechatpadpro-windows-amd64-vios18.61-861.exe'
$expected = '5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9'
if ((Get-FileHash -LiteralPath $exe -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expected) { throw 'Unexpected executable hash' }
foreach ($direction in @('Inbound', 'Outbound')) {
    $rule = Get-NetFirewallRule -DisplayName "Codex-Pad861-Offline-$direction"
    $program = ($rule | Get-NetFirewallApplicationFilter).Program
    if ($rule.Enabled -ne 'True' -or $rule.Action -ne 'Block' -or $program -ne $exe) { throw 'Required existing firewall rule not verified' }
}
$existing = @(Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -in @(1238,8098) })
if ($existing.Count) { throw 'Probe ports are already in use; refusing to touch existing processes' }
$configHash = (Get-FileHash -LiteralPath (Join-Path $runtimeRoot '.env')).Hash
$gateway = $null
$probeExit = 2
try {
    $gateway = Start-Process -FilePath $exe -WorkingDirectory $runtimeRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $localRoot 'metadata.stdout.log') -RedirectStandardError (Join-Path $localRoot 'metadata.stderr.log')
    $ready = $false
    for ($attempt = 0; $attempt -lt 20; $attempt++) {
        if ($gateway.HasExited) { throw 'Gateway exited before readiness' }
        $ports = @(Get-NetTCPConnection -State Listen -OwningProcess $gateway.Id -ErrorAction SilentlyContinue)
        if (1238 -in $ports.LocalPort -and 8098 -in $ports.LocalPort) { $ready = $true; break }
        Start-Sleep -Milliseconds 250
    }
    if (-not $ready) { throw 'Gateway readiness deadline' }
    if ($HttpAuthOnly -and $PrepareDevice) { throw 'Choose one probe mode' }
    if ($PrepareDevice) {
        & (Join-Path $pocRoot '.venv/Scripts/python.exe') -X utf8 (Join-Path $PSScriptRoot 'prepare_pad_861_device.py') --output (Join-Path $localRoot 'device-preparation-result.json')
    } elseif ($HttpAuthOnly) {
        & (Join-Path $pocRoot '.venv/Scripts/python.exe') -X utf8 (Join-Path $PSScriptRoot 'probe_pad_861_http_auth.py') --output (Join-Path $localRoot 'http-auth-probe-result.json')
    } else {
        & (Join-Path $pocRoot '.venv/Scripts/python.exe') -X utf8 (Join-Path $PSScriptRoot 'probe_pad_861_metadata.py') --output (Join-Path $localRoot 'metadata-probe-result.json')
    }
    $probeExit = $LASTEXITCODE
} finally {
    if ($null -ne $gateway -and -not $gateway.HasExited) {
        Stop-Process -Id $gateway.Id -Force
        $gateway.WaitForExit(5000) | Out-Null
    }
    $remaining = @(Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -in @(1238,8098) })
    $cleanup = @{gateway_stopped = ($null -eq $gateway -or $gateway.HasExited); remaining_listeners = $remaining.Count; config_unchanged = ((Get-FileHash -LiteralPath (Join-Path $runtimeRoot '.env')).Hash -eq $configHash); timestamp = (Get-Date -Format o)}
    $cleanup | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $localRoot 'metadata-cleanup-result.json') -Encoding utf8
    $cleanup | ConvertTo-Json
}
exit $probeExit
