# Explicitly authorized one-shot network trial. No QR, login or message APIs.
param([switch]$TutorialRetry)
$ErrorActionPreference = 'Stop'
$trialPrefix = if ($TutorialRetry) { 'tutorial-native-trial' } else { 'network-trial' }
$clientMode = if ($TutorialRetry) { '--tutorial-native-trial' } else { '--network-trial' }
$pocRoot = Split-Path $PSScriptRoot -Parent
$localRoot = Join-Path $pocRoot '.local/pad-legacy-861'
$runtimeRoot = Join-Path $localRoot 'runtime'
$exe = Join-Path $runtimeRoot 'wechatpadpro-windows-amd64-vios18.61-861.exe'
$expected = '5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9'
if ((Get-FileHash -LiteralPath $exe -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expected) { throw 'Unexpected executable hash' }
if (Test-Path -LiteralPath (Join-Path $localRoot "device-$trialPrefix-intent.json")) { throw 'Network generation already attempted; refusing automatic retry' }
if (-not (Get-Command Start-Process).Parameters.ContainsKey('Environment')) { throw 'Start-Process Environment support required' }
$rules = @{}
foreach ($direction in @('Inbound', 'Outbound')) {
    $rule = @(Get-NetFirewallRule -DisplayName "Codex-Pad861-Offline-$direction")
    if ($rule.Count -ne 1) { throw 'Expected exactly one matching rule per direction' }
    $program = ($rule[0] | Get-NetFirewallApplicationFilter).Program
    if ($rule[0].Enabled -ne 'True' -or $rule[0].Action -ne 'Block' -or $rule[0].Direction -ne $direction -or $program -ne $exe) { throw 'Required existing firewall rule not verified' }
    $rules[$direction] = $rule[0].Name
}
$existing = @(Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -in @(1238,8098) })
if ($existing.Count) { throw 'Gateway ports occupied; refusing to touch existing processes' }
if (@(Get-Process -Name 'wechatpadpro-windows-amd64-vios18.61-861' -ErrorAction SilentlyContinue).Count) { throw 'Gateway process already exists' }
if (-not (Get-NetTCPConnection -State Listen -LocalPort 17891 -ErrorAction SilentlyContinue)) { throw 'Previously tested local proxy not listening' }
$configHash = (Get-FileHash -LiteralPath (Join-Path $runtimeRoot '.env')).Hash
$gateway = $null
$client = $null
$probeExit = 2
$timer = [Diagnostics.Stopwatch]::StartNew()
try {
    Disable-NetFirewallRule -Name $rules.Outbound | Out-Null
    $gateway = Start-Process -FilePath $exe -WorkingDirectory $runtimeRoot -WindowStyle Hidden -PassThru -Environment @{ADMIN_KEY_SERVICE_URL='https://adminkeyservice.knowhub.cloud'; HTTP_PROXY='http://127.0.0.1:17891'; HTTPS_PROXY='http://127.0.0.1:17891'; ALL_PROXY=''; NO_PROXY='127.0.0.1,localhost'} -RedirectStandardOutput (Join-Path $localRoot "$trialPrefix.stdout.private.log") -RedirectStandardError (Join-Path $localRoot "$trialPrefix.stderr.private.log")
    $ready = $false
    while ($timer.Elapsed.TotalSeconds -lt 8) {
        if ($gateway.HasExited) { throw 'Gateway exited before readiness' }
        $ports = @(Get-NetTCPConnection -State Listen -OwningProcess $gateway.Id -ErrorAction SilentlyContinue)
        if (1238 -in $ports.LocalPort -and 8098 -in $ports.LocalPort) { $ready = $true; break }
        Start-Sleep -Milliseconds 200
    }
    if (-not $ready) { throw 'Gateway readiness deadline' }
    $clientScript = Join-Path $PSScriptRoot 'prepare_pad_861_device.py'
    $resultPath = Join-Path $localRoot "device-$trialPrefix-result.json"
    $client = Start-Process -FilePath (Join-Path $pocRoot '.venv/Scripts/python.exe') -WorkingDirectory $pocRoot -WindowStyle Hidden -PassThru -ArgumentList @('-X','utf8',"`"$clientScript`"",$clientMode,'--output',"`"$resultPath`"") -RedirectStandardOutput (Join-Path $localRoot "$trialPrefix-client.stdout.json") -RedirectStandardError (Join-Path $localRoot "$trialPrefix-client.stderr.log")
    $remainingMs = [Math]::Max(1, [int](28000 - $timer.Elapsed.TotalMilliseconds))
    if (-not $client.WaitForExit($remainingMs)) { throw 'Network trial deadline; submission outcome may be unknown' }
    $client.Refresh()
    $probeExit = $client.ExitCode
    if (Test-Path -LiteralPath $resultPath) { Get-Content -LiteralPath $resultPath }
} finally {
    try {
        foreach ($process in @($client, $gateway)) {
            if ($null -ne $process -and -not $process.HasExited) {
                Stop-Process -Id $process.Id -Force -ErrorAction Continue
                $process.WaitForExit(1500) | Out-Null
            }
        }
    } finally {
        Enable-NetFirewallRule -Name $rules.Outbound | Out-Null
    }
    $timer.Stop()
    $inbound = Get-NetFirewallRule -Name $rules.Inbound
    $outbound = Get-NetFirewallRule -Name $rules.Outbound
    $listeners = @(Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -in @(1238,8098) })
    $cleanup = @{timestamp=(Get-Date -Format o); elapsed_seconds=[Math]::Round($timer.Elapsed.TotalSeconds,2); gateway_stopped=($null -eq $gateway -or $gateway.HasExited); remaining_listeners=$listeners.Count; config_unchanged=((Get-FileHash -LiteralPath (Join-Path $runtimeRoot '.env')).Hash -eq $configHash); inbound_block_enabled=($inbound.Enabled -eq 'True' -and $inbound.Action -eq 'Block'); outbound_block_restored=($outbound.Enabled -eq 'True' -and $outbound.Action -eq 'Block')}
    $cleanup | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $localRoot "$trialPrefix-cleanup-result.json") -Encoding utf8
    $cleanup | ConvertTo-Json
    if (-not $cleanup.outbound_block_restored -or -not $cleanup.gateway_stopped -or $listeners.Count) { throw 'Cleanup verification failed' }
}
exit $probeExit
