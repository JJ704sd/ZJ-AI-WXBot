param(
    [Parameter(Mandatory = $true)][string]$Action,
    [string]$Text = "",
    [string]$Expect = ""
)

$OutputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = $OutputEncoding

Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class NativeFocus {
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
}
"@

function Normalize-Title([string]$name) {
    if ([string]::IsNullOrWhiteSpace($name)) { return "" }
    return [regex]::Replace($name.Trim(), '\s*\(\d+\)\s*$', '')
}

function Get-WeixinName {
    return ([char]0x5FAE).ToString() + ([char]0x4FE1)
}

function Get-WeixinWindow {
    $want = Get-WeixinName
    $root = [System.Windows.Automation.AutomationElement]::RootElement
    $walker = [System.Windows.Automation.TreeWalker]::ControlViewWalker
    $child = $walker.GetFirstChild($root)
    $fallback = $null
    while ($null -ne $child) {
        $n = $child.Current.Name
        if ($n -eq $want) { return $child }
        if (-not $fallback -and $n -eq 'Weixin') { $fallback = $child }
        $child = $walker.GetNextSibling($child)
    }
    return $fallback
}

function Get-SelectedTitle($win) {
    $patternId = [System.Windows.Automation.SelectionItemPattern]::Pattern
    $cond = New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::IsSelectionItemPatternAvailableProperty, $true)
    $items = $win.FindAll([System.Windows.Automation.TreeScope]::Descendants, $cond)
    foreach ($item in $items) {
        try {
            $pattern = $item.GetCurrentPattern($patternId)
            if ($pattern.Current.IsSelected) {
                $n = $item.Current.Name
                if ($n) { return $n }
            }
        } catch {}
    }
    return ""
}

function Get-ComposeBox($win) {
    $editCond = New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
        [System.Windows.Automation.ControlType]::Edit)
    $edits = $win.FindAll([System.Windows.Automation.TreeScope]::Descendants, $editCond)
    $last = $null
    foreach ($item in $edits) {
        if ($item.Current.IsEnabled -and -not $item.Current.IsOffscreen) {
            $last = $item
        }
    }
    if ($last) { return $last }
    $docCond = New-Object System.Windows.Automation.PropertyCondition(
        [System.Windows.Automation.AutomationElement]::ControlTypeProperty,
        [System.Windows.Automation.ControlType]::Document)
    $docs = $win.FindAll([System.Windows.Automation.TreeScope]::Descendants, $docCond)
    foreach ($item in $docs) {
        if ($item.Current.IsEnabled -and -not $item.Current.IsOffscreen) {
            $last = $item
        }
    }
    return $last
}

function Write-Json($obj) {
    Write-Output ($obj | ConvertTo-Json -Compress)
}

$win = Get-WeixinWindow
if (-not $win) {
    Write-Json @{ status = 'not_sent'; message = 'weixin window not found'; selected = '' }
    exit 2
}

$selected = Get-SelectedTitle $win
$normSelected = Normalize-Title $selected
$normExpect = Normalize-Title $Expect

if ($Action -eq 'observe') {
    Write-Json @{ selected = $selected; status = 'observed' }
    exit 0
}

if ($Action -ne 'send') {
    Write-Json @{ status = 'not_sent'; message = 'unsupported action'; selected = '' }
    exit 2
}

if (-not $normExpect -or $normSelected -ne $normExpect) {
    Write-Json @{ status = 'not_sent'; message = 'selected chat is not the expected group'; selected = $selected }
    exit 2
}

if ([string]::IsNullOrEmpty($Text)) {
    Write-Json @{ status = 'not_sent'; message = 'empty text'; selected = '' }
    exit 2
}

$hwnd = [IntPtr]$win.Current.NativeWindowHandle
[void][NativeFocus]::SetForegroundWindow($hwnd)
Start-Sleep -Milliseconds 200
if ([NativeFocus]::GetForegroundWindow() -ne $hwnd) {
    Write-Json @{ status = 'not_sent'; message = 'weixin window is not foreground'; selected = $selected }
    exit 2
}

$selected2 = Normalize-Title (Get-SelectedTitle $win)
if ($selected2 -ne $normExpect) {
    Write-Json @{ status = 'not_sent'; message = 'selected chat changed before submit'; selected = $selected2 }
    exit 2
}

$compose = Get-ComposeBox $win
if ($compose) {
    try { $null = $compose.SetFocus() } catch {}
}

$previous = $null
try { $previous = [System.Windows.Forms.Clipboard]::GetText() } catch {}
try {
    [System.Windows.Forms.Clipboard]::SetText($Text)
    [System.Windows.Forms.SendKeys]::SendWait('^a')
    Start-Sleep -Milliseconds 50
    [System.Windows.Forms.SendKeys]::SendWait('^v')
    Start-Sleep -Milliseconds 80
    if ((Normalize-Title (Get-SelectedTitle $win)) -ne $normExpect) {
        Write-Json @{ status = 'not_sent'; message = 'selected chat changed before enter'; selected = (Get-SelectedTitle $win) }
        exit 2
    }
    if ([NativeFocus]::GetForegroundWindow() -ne $hwnd) {
        Write-Json @{ status = 'not_sent'; message = 'weixin lost foreground before enter'; selected = (Get-SelectedTitle $win) }
        exit 2
    }
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
} catch {
    Write-Json @{ status = 'unknown'; message = $_.Exception.Message; selected = (Get-SelectedTitle $win) }
    exit 3
} finally {
    try {
        if ($previous) { [System.Windows.Forms.Clipboard]::SetText($previous) }
        else { [System.Windows.Forms.Clipboard]::Clear() }
    } catch {}
}

$after = Normalize-Title (Get-SelectedTitle $win)
if ($after -ne $normExpect) {
    Write-Json @{ status = 'unknown'; message = 'selected chat changed after submit'; selected = $after }
    exit 3
}

Write-Json @{ status = 'submitted'; selected = $selected; message = 'sendkeys submitted' }
exit 0
