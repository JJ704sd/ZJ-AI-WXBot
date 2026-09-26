"""Compile the production native visual helper without inspecting any window."""
import json
import os
from pathlib import Path
import subprocess
import unittest


class WindowsVisualNativeTests(unittest.TestCase):
    @unittest.skipUnless(os.name == 'nt', 'Windows PowerShell native compilation')
    def test_production_helper_compiles_and_checks_synthetic_pixels_without_input(self):
        script = Path(__file__).resolve().parents[1] / 'scripts/windows_visual_send.ps1'
        result = subprocess.run(
            ['powershell.exe', '-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'Bypass',
             '-File', str(script), '-SelfTest'],
            capture_output=True, text=True, encoding='utf-8', timeout=30,
            creationflags=subprocess.CREATE_NO_WINDOW,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        result = json.loads(result.stdout)
        self.assertTrue(result['ok'])
        self.assertEqual(result['mode'], 'no-window-no-input')
        self.assertEqual(result['abi'], 'compiled-and-synthetic-pixels')


if __name__ == '__main__':
    unittest.main()
