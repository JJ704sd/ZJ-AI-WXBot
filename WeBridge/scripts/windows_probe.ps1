#requires -Version 5.1
# Read-only Win32 metadata and bounded UI Automation text. Never sends input.
[CmdletBinding()]
param(
    [ValidateSet('status', 'preview', 'inspect', 'capture')][string]$Mode = 'status',
    [int]$ProcessId = 0,
    [long]$WindowHandle = 0
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = New-Object Text.UTF8Encoding($false)
$OutputEncoding = [Console]::OutputEncoding

function Write-ProbeResult($Result) {
    $Result.source = if ($Mode -eq 'inspect') { 'windows-uia-inspect' } elseif ($Mode -eq 'capture') { 'windows-window-capture' } else { 'windows-uia' }
    $Result.identityVerified = $false
    $Result.canSend = $false
    $Result.readOnly = $true
    $Result | ConvertTo-Json -Depth 8 -Compress
}

try {
    Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
public static class WeBridgeWindowProbe {
    public class WindowInfo {
        public long Hwnd;
        public uint Pid;
        public string Title;
        public bool Visible;
        public bool Minimized;
        public bool TopLevel;
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
        public uint Dpi;
    }
    [StructLayout(LayoutKind.Sequential)] private struct Rect { public int Left, Top, Right, Bottom; }
    private delegate bool EnumWindowsProc(IntPtr window, IntPtr parameter);
    [DllImport("user32.dll")] private static extern bool EnumWindows(EnumWindowsProc callback, IntPtr parameter);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr window);
    [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr window);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr window, out uint processId);
    [DllImport("user32.dll")] private static extern bool GetWindowRect(IntPtr window, out Rect rectangle);
    [DllImport("user32.dll")] private static extern IntPtr GetAncestor(IntPtr window, uint flags);
    [DllImport("user32.dll")] private static extern int GetSystemMetrics(int index);
    [DllImport("user32.dll")] private static extern uint GetDpiForWindow(IntPtr window);
    [DllImport("user32.dll")] public static extern IntPtr SetThreadDpiAwarenessContext(IntPtr context);
    [DllImport("dwmapi.dll")] private static extern int DwmGetWindowAttribute(IntPtr window, uint attribute, out uint value, int size);
    [DllImport("dwmapi.dll", EntryPoint="DwmGetWindowAttribute")] private static extern int DwmGetFrameBounds(IntPtr window, uint attribute, out Rect value, int size);
    [DllImport("user32.dll")] private static extern IntPtr OpenInputDesktop(uint flags, bool inherit, uint access);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)] private static extern bool GetUserObjectInformation(IntPtr handle, int index, StringBuilder value, uint length, out uint needed);
    [DllImport("user32.dll")] private static extern bool CloseDesktop(IntPtr desktop);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)] private static extern int GetWindowText(IntPtr window, StringBuilder text, int maximum);
    public static WindowInfo Inspect(long handle) {
        IntPtr window = new IntPtr(handle);
        uint pid;
        GetWindowThreadProcessId(window, out pid);
        StringBuilder text = new StringBuilder(513);
        GetWindowText(window, text, text.Capacity);
        Rect box;
        GetWindowRect(window, out box);
        return new WindowInfo { Hwnd=handle, Pid=pid, Title=text.ToString(),
            Visible=IsWindowVisible(window), Minimized=IsIconic(window), TopLevel=GetAncestor(window, 2)==window,
            Left=box.Left, Top=box.Top, Right=box.Right, Bottom=box.Bottom, Dpi=GetDpiForWindow(window) };
    }
    public static bool SameWindow(WindowInfo a, WindowInfo b) {
        return a.Hwnd==b.Hwnd && a.Pid==b.Pid && a.Title==b.Title && b.Visible && !b.Minimized && b.TopLevel
            && a.Left==b.Left && a.Top==b.Top && a.Right==b.Right && a.Bottom==b.Bottom && a.Dpi==b.Dpi;
    }
    // GetWindowRect includes invisible resize borders. DWM attribute 9 returns
    // visible physical-pixel bounds, matching the capture worker's PMA DPI mode.
    // https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowrect
    public static WindowInfo CaptureInspect(long handle) {
        var result=Inspect(handle);
        Rect visible;
        if (DwmGetFrameBounds(new IntPtr(handle), 9, out visible, Marshal.SizeOf(typeof(Rect)))!=0
            || visible.Right<=visible.Left || visible.Bottom<=visible.Top)
            throw new InvalidOperationException("visible_frame_unavailable");
        result.Left=visible.Left; result.Top=visible.Top; result.Right=visible.Right; result.Bottom=visible.Bottom;
        return result;
    }
    public static string GeometryIssue(WindowInfo target, int x, int y, int desktopWidth, int desktopHeight, WindowInfo[] upper) {
        long width=(long)target.Right-target.Left, height=(long)target.Bottom-target.Top;
        if (width<=0 || height<=0) return "window_changed";
        if (width>5000 || height>5000) return "capture_too_large";
        if (target.Left<x || target.Top<y || target.Right>(long)x+desktopWidth || target.Bottom>(long)y+desktopHeight) return "window_outside_desktop";
        foreach (var box in upper) {
            if (Math.Max(box.Left,target.Left)<Math.Min(box.Right,target.Right) && Math.Max(box.Top,target.Top)<Math.Min(box.Bottom,target.Bottom))
                return "window_occluded";
        }
        return "";
    }
    private static bool InputDesktopAvailable() {
        IntPtr desktop=OpenInputDesktop(0, false, 1);
        if (desktop==IntPtr.Zero) return false;
        try {
            uint needed;
            var name=new StringBuilder(256);
            return GetUserObjectInformation(desktop, 2, name, 512, out needed) && name.ToString().Equals("Default", StringComparison.OrdinalIgnoreCase);
        } finally { CloseDesktop(desktop); }
    }
    private static bool Cloaked(IntPtr window) {
        uint value;
        return DwmGetWindowAttribute(window, 14, out value, sizeof(uint))==0 && value!=0;
    }
    public static string CaptureIssue(long handle) {
        if (!InputDesktopAvailable()) return "input_desktop_unavailable";
        var target=CaptureInspect(handle);
        var targetHandle=new IntPtr(handle);
        if (!target.TopLevel || !target.Visible || target.Minimized || target.Pid==0 || Cloaked(targetHandle)) return "window_changed";
        bool found=false;
        bool unknown=false;
        int count=0;
        var upper=new List<WindowInfo>();
        EnumWindows((window, parameter) => {
            if (++count>4096) return false;
            if (window==targetHandle) { found=true; return false; }
            if (!IsWindowVisible(window) || IsIconic(window) || Cloaked(window)) return true;
            try {
                upper.Add(CaptureInspect(window.ToInt64()));
            } catch {
                // A visible upper window with unknown visible bounds cannot be
                // safely dismissed as non-overlapping. Do not copy screen pixels.
                unknown=true; return false;
            }
            return true;
        }, IntPtr.Zero);
        if (unknown) return "capture_unavailable";
        if (!found) return "window_changed";
        return GeometryIssue(target, GetSystemMetrics(76), GetSystemMetrics(77), GetSystemMetrics(78), GetSystemMetrics(79), upper.ToArray());
    }
    public static List<WindowInfo> Windows(int[] processIds) {
        var ids = new HashSet<int>(processIds);
        var result = new List<WindowInfo>();
        EnumWindows((window, parameter) => {
            uint pid;
            GetWindowThreadProcessId(window, out pid);
            if (ids.Contains((int)pid) && result.Count < 128) result.Add(Inspect(window.ToInt64()));
            return result.Count < 128;
        }, IntPtr.Zero);
        return result;
    }
}
'@
    if ($Mode -eq 'capture') {
        if ([WeBridgeWindowProbe]::SetThreadDpiAwarenessContext([IntPtr](-4)) -eq [IntPtr]::Zero) {
            Write-ProbeResult @{ ok = $false; supported = $true; available = $false; issueCode = 'capture_unavailable' }
            exit 0
        }
    }
    $wechatProcesses = @([Diagnostics.Process]::GetProcessesByName('Weixin')) + @([Diagnostics.Process]::GetProcessesByName('WeChat'))
    $processes = @()
    foreach ($process in $wechatProcesses) {
        $version = ''
        try { $version = $process.MainModule.FileVersionInfo.FileVersion } catch { }
        $processes += @{ pid = $process.Id; name = $process.ProcessName; version = $version }
    }
    if ($Mode -eq 'status') {
        $windows = @()
        $ids = [int[]]@($processes | ForEach-Object { $_.pid })
        foreach ($window in [WeBridgeWindowProbe]::Windows($ids)) {
            $owner = $processes | Where-Object { $_.pid -eq $window.Pid } | Select-Object -First 1
            $windows += @{ hwnd = $window.Hwnd.ToString(); pid = [int]$window.Pid;
                title = $window.Title; visible = $window.Visible; minimized = $window.Minimized; version = $owner.version }
        }
        $available = @($windows | Where-Object { $_.visible -and -not $_.minimized }).Count -gt 0
        $issue = if (-not $processes.Count) { 'not_running' } elseif (-not $available) { 'no_visible_window' } else { '' }
        Write-ProbeResult @{ ok = $true; supported = $true; available = $available; processCount = $processes.Count;
            processes = $processes; windows = $windows; issueCode = $issue }
        exit 0
    }

    $owner = $processes | Where-Object { $_.pid -eq $ProcessId } | Select-Object -First 1
    $ownerProcess = $wechatProcesses | Where-Object { $_.Id -eq $ProcessId } | Select-Object -First 1
    $window = [WeBridgeWindowProbe]::Inspect($WindowHandle)
    if (-not $owner -or $WindowHandle -le 0 -or $window.Pid -ne $ProcessId -or -not $window.Visible -or $window.Minimized -or -not $window.TopLevel) {
        Write-ProbeResult @{ ok = $false; supported = $true; available = $false; texts = @(); issueCode = 'window_changed' }
        exit 0
    }
    $ownerStarted = $ownerProcess.StartTime.ToUniversalTime().Ticks
    if ($Mode -eq 'capture') {
        $window = [WeBridgeWindowProbe]::CaptureInspect($WindowHandle)
        $issue = [WeBridgeWindowProbe]::CaptureIssue($WindowHandle)
        if (-not [WeBridgeWindowProbe]::SameWindow($window, [WeBridgeWindowProbe]::CaptureInspect($WindowHandle))) { $issue = 'window_changed' }
        if ($issue) {
            Write-ProbeResult @{ ok = $false; supported = $true; available = $false; issueCode = $issue }
            exit 0
        }
        Add-Type -AssemblyName System.Drawing
        $width = $window.Right - $window.Left
        $height = $window.Bottom - $window.Top
        $bitmap = $null
        $graphics = $null
        $stream = $null
        try {
            $bitmap = New-Object Drawing.Bitmap($width, $height, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
            $graphics = [Drawing.Graphics]::FromImage($bitmap)
            $graphics.CopyFromScreen($window.Left, $window.Top, 0, 0, (New-Object Drawing.Size($width, $height)), [Drawing.CopyPixelOperation]::SourceCopy)
            $issue = [WeBridgeWindowProbe]::CaptureIssue($WindowHandle)
            $currentWindow = [WeBridgeWindowProbe]::CaptureInspect($WindowHandle)
            $currentProcess = Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
            if (-not [WeBridgeWindowProbe]::SameWindow($window, $currentWindow) -or -not $currentProcess -or
                $currentProcess.ProcessName -notin @('Weixin', 'WeChat') -or
                $currentProcess.StartTime.ToUniversalTime().Ticks -ne $ownerStarted) { $issue = 'window_changed' }
            if ($issue) {
                Write-ProbeResult @{ ok = $false; supported = $true; available = $false; issueCode = $issue }
                exit 0
            }
            $stream = New-Object IO.MemoryStream
            $bitmap.Save($stream, [Drawing.Imaging.ImageFormat]::Png)
            if ($stream.Length -gt 8MB) {
                Write-ProbeResult @{ ok = $false; supported = $true; available = $false; issueCode = 'capture_too_large' }
                exit 0
            }
            Write-ProbeResult @{ ok = $true; supported = $true; available = $true; issueCode = '';
                pid = $ProcessId; hwnd = $WindowHandle.ToString(); title = $window.Title; version = $owner.version;
                geometry = @{ x = $window.Left; y = $window.Top; width = $width; height = $height; dpi = $window.Dpi };
                png_base64 = [Convert]::ToBase64String($stream.ToArray()) }
        } finally {
            if ($null -ne $stream) { $stream.Dispose() }
            if ($null -ne $graphics) { $graphics.Dispose() }
            if ($null -ne $bitmap) { $bitmap.Dispose() }
        }
        exit 0
    }
    $allowedProcessIds = New-Object 'System.Collections.Generic.HashSet[int]'
    foreach ($process in $wechatProcesses) { $null = $allowedProcessIds.Add($process.Id) }
    Add-Type -AssemblyName UIAutomationClient
    Add-Type -AssemblyName UIAutomationTypes
    $root = [Windows.Automation.AutomationElement]::FromHandle([IntPtr]$WindowHandle)
    $walker = [Windows.Automation.TreeWalker]::ControlViewWalker
    $queue = New-Object 'System.Collections.Generic.Queue[object]'
    $queue.Enqueue(@{ element = $root; depth = 0 })
    $seenText = New-Object 'System.Collections.Generic.HashSet[string]'
    $texts = New-Object 'System.Collections.Generic.List[object]'
    $nodeCount = 0
    $controlTypes = @{}
    $characters = 0
    $truncated = $false
    while ($queue.Count -gt 0 -and $nodeCount -lt 400 -and $texts.Count -lt 200 -and $characters -lt 40000) {
        $item = $queue.Dequeue()
        $element = $item.element
        $nodeCount++
        try {
            $current = $element.Current
            if (-not $allowedProcessIds.Contains($current.ProcessId)) { continue }
            $kind = $current.ControlType.ProgrammaticName.Split('.')[-1]
            if (-not $controlTypes.ContainsKey($kind)) { $controlTypes[$kind] = 0 }
            $controlTypes[$kind]++
            if ($Mode -eq 'preview') {
                $text = $current.Name.Trim()
                if (-not $current.IsOffscreen -and $kind -in @('Text', 'ListItem', 'Document') -and $text -and $seenText.Add($text)) {
                    $limit = [Math]::Min(3000, 40000 - $characters)
                    if ($text.Length -gt $limit) { $text = $text.Substring(0, $limit); $truncated = $true }
                    $texts.Add(@{ text = $text; controlType = $kind })
                    $characters += $text.Length
                }
            }
            if ($item.depth -lt 12) {
                $next = $walker.GetFirstChild($element)
                while ($null -ne $next) {
                    if (($queue.Count + $nodeCount) -ge 400) { $truncated = $true; break }
                    $queue.Enqueue(@{ element = $next; depth = $item.depth + 1 })
                    $next = $walker.GetNextSibling($next)
                }
            } else { $truncated = $true }
        } catch { }
    }
    $currentWindow = [WeBridgeWindowProbe]::Inspect($WindowHandle)
    $currentProcess = Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
    if ($currentWindow.Pid -ne $ProcessId -or -not $currentWindow.Visible -or $currentWindow.Minimized -or
        $currentWindow.Title -cne $window.Title -or -not $currentProcess -or
        $currentProcess.ProcessName -notin @('Weixin', 'WeChat') -or
        $currentProcess.StartTime.ToUniversalTime().Ticks -ne $ownerStarted) {
        Write-ProbeResult @{ ok = $false; supported = $true; available = $false; texts = @(); issueCode = 'window_changed' }
        exit 0
    }
    if ($queue.Count) { $truncated = $true }
    if ($Mode -eq 'inspect') {
        Write-ProbeResult @{ ok = $true; supported = $true; available = $true; pid = $ProcessId;
            hwnd = $WindowHandle.ToString(); nodeCount = $nodeCount; controlTypes = $controlTypes; truncated = $truncated; issueCode = '' }
        exit 0
    }
    $issue = if ($texts.Count) { '' } else { 'no_accessible_text' }
    Write-ProbeResult @{ ok = ($texts.Count -gt 0); supported = $true; available = $true;
        hwnd = $WindowHandle.ToString(); pid = $ProcessId; title = $window.Title; version = $owner.version;
        nodeCount = $nodeCount; texts = @($texts.ToArray()); truncated = $truncated; issueCode = $issue }
} catch {
    $failureCode = if ($Mode -eq 'capture') { 'capture_unavailable' } else { 'uia_unavailable' }
    Write-ProbeResult @{ ok = $false; supported = $true; available = $false; texts = @(); windows = @();
        processes = @(); processCount = 0; issueCode = $failureCode }
}
