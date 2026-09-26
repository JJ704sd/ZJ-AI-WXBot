"""Public launcher preflight against a real Windows filesystem failure."""
import os
from pathlib import Path
import socket
import stat
import subprocess
import sys
import tempfile
import unittest


@unittest.skipUnless(os.name == 'nt', 'Windows PowerShell launcher')
class WindowsLauncherTests(unittest.TestCase):
    def test_preflight_reports_unwritable_existing_state(self):
        root = Path(__file__).resolve().parents[1]
        with tempfile.TemporaryDirectory(prefix='webridge-launcher-check-') as directory:
            lock = Path(directory) / 'server.lock'
            lock.write_text('0')
            with socket.socket() as port_probe:
                port_probe.bind(('127.0.0.1', 0))
                port = port_probe.getsockname()[1]
            command = ['powershell.exe', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File',
                       str(root / 'scripts/start_web_mvp.ps1'), '-CheckOnly', '-NoBrowser',
                       '-Python', sys.executable, '-Port', str(port), '-RuntimeDir', directory]
            try:
                lock.chmod(stat.S_IREAD)
                failed = subprocess.run(command, capture_output=True, text=True, timeout=20, env=dict(os.environ))
                self.assertEqual(failed.returncode, 1, failed.stdout + failed.stderr)
                self.assertIn('not writable', failed.stdout)
                self.assertIn('server.lock', failed.stdout)
                self.assertFalse((Path(directory) / 'server.pid').exists())
            finally:
                lock.chmod(stat.S_IREAD | stat.S_IWRITE)
            passed = subprocess.run(command, capture_output=True, text=True, timeout=20, env=dict(os.environ))
            self.assertEqual(passed.returncode, 0, passed.stdout + passed.stderr)
            self.assertIn('Preflight passed', passed.stdout)


if __name__ == '__main__':
    unittest.main()
