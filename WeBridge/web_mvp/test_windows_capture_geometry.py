"""Compile production geometry checks and exercise synthetic rectangles only."""
import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


@unittest.skipUnless(os.name == 'nt', 'Windows PowerShell geometry implementation')
class CaptureGeometryTests(unittest.TestCase):
    def test_visible_frame_screen_edges_multimonitor_and_occlusion(self):
        root = Path(__file__).resolve().parents[1]
        script = (root / 'scripts/windows_probe.ps1').read_text(encoding='utf-8')
        native = re.search(r"Add-Type -TypeDefinition @'\r?\n(.*?)\r?\n'@", script, re.DOTALL).group(1)
        cases = r'''
function Box([int]$left, [int]$top, [int]$right, [int]$bottom) {
    $box = New-Object WeBridgeWindowProbe+WindowInfo
    $box.Left=$left; $box.Top=$top; $box.Right=$right; $box.Bottom=$bottom
    return $box
}
function Check($target, $desktop, $above, $expected) {
    $actual=[WeBridgeWindowProbe]::GeometryIssue($target, $desktop[0], $desktop[1], $desktop[2], $desktop[3], $above)
    if ($actual -ne $expected) { throw "Expected '$expected', got '$actual'" }
}
# Invisible maximized resize borders exceed the desktop, but visible DWM frame fits.
Check (Box -8 -8 1928 1088) @(0,0,1920,1080) @() 'window_outside_desktop'
Check (Box 0 0 1920 1080) @(0,0,1920,1080) @() ''
# Rectangles use exclusive right/bottom edges: adjacency is not occlusion.
Check (Box 0 0 1000 800) @(0,0,1920,1080) @((Box 1000 0 1800 800)) ''
Check (Box 0 0 1000 800) @(0,0,1920,1080) @((Box 999 0 1800 800)) 'window_occluded'
# Negative screen coordinates are legitimate on a monitor left of the primary.
Check (Box -1920 0 0 1080) @(-1920,0,3840,1080) @() ''
Check (Box -1921 0 0 1080) @(-1920,0,3840,1080) @() 'window_outside_desktop'
Check (Box 0 0 5001 100) @(0,0,6000,1200) @() 'capture_too_large'
Check (Box 0 0 0 100) @(0,0,1920,1080) @() 'window_changed'
Write-Output 'PASS: 8 synthetic geometry cases; no window or screen APIs invoked'
'''
        with tempfile.TemporaryDirectory(prefix='webridge-geometry-') as directory:
            target = Path(directory) / 'check.ps1'
            target.write_text("$ErrorActionPreference='Stop'\nAdd-Type -TypeDefinition @'\n" + native + "\n'@\n" + cases, encoding='ascii')
            result = subprocess.run(['powershell.exe', '-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'Bypass', '-File', str(target)], capture_output=True, text=True, timeout=20, env=dict(os.environ))
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn('PASS: 8 synthetic geometry cases', result.stdout)


if __name__ == '__main__':
    unittest.main()
