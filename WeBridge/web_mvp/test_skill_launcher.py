"""Windows public launcher contract with a synthetic local executable."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import time
import unittest


@unittest.skipUnless(os.name == 'nt', 'Windows launcher integration')
class SkillLauncherTests(unittest.TestCase):
    def test_parse_returns_the_actual_completed_receipt(self):
        project = Path(__file__).resolve().parents[1]
        powershell = Path(os.environ['SYSTEMROOT']) / 'System32/WindowsPowerShell/v1.0/powershell.exe'
        with tempfile.TemporaryDirectory(prefix='skill launcher ') as temporary:
            root = Path(temporary).resolve()
            (root / 'scripts').mkdir()
            (root / 'bin').mkdir()
            shutil.copyfile(project / 'skills/local-wechat-archive/scripts/run.ps1', root / 'scripts/run.ps1')
            binary = root / 'bin/fixture.exe'
            source = root / 'fixture.cs'
            source.write_text(r'''
using System;
using System.IO;
using System.Diagnostics;
using System.Threading;
class Fixture {
    static string JsonString(string text, string key) {
        string marker = "\"" + key + "\":";
        int start = text.IndexOf(marker, StringComparison.Ordinal);
        if (start < 0) return null;
        start += marker.Length;
        while (start < text.Length && Char.IsWhiteSpace(text[start])) start++;
        if (start >= text.Length || text[start] != '\"') return null;
        start++;
        int end = text.IndexOf('\"', start);
        if (end < 0) return null;
        return text.Substring(start, end - start).Replace("\\\\", "\\");
    }
    static void Main(string[] args) {
        string path = null, launch = null, launchResult = null;
        for (int i=0; i<args.Length-1; i++) {
            if (args[i]=="--open-result-json") path=args[i+1];
            if (args[i]=="--launch-desktop-json") launch=args[i+1];
            if (args[i]=="--result-json") launchResult=args[i+1];
        }
        if (launch!=null) {
            string receipt = JsonString(File.ReadAllText(launch), "receipt");
            if (launchResult!=null) File.WriteAllText(launchResult, "{\"ok\":true,\"state\":\"started\"}");
            if (receipt==null) return;
            File.WriteAllText(receipt, "{\"state\":\"starting\"}");
            Thread.Sleep(1200);
            string name = JsonString(File.ReadAllText(launch), "chatName");
            string final = name == "Awaiting review" ? "{\"state\":\"awaiting_review\",\"ok\":false,\"exportedRows\":2}" : "{\"state\":\"completed\",\"ok\":true,\"exportedRows\":2}";
            File.WriteAllText(receipt, final);
            return;
        }
        if (path==null) return;
        File.WriteAllText(path, "{\"state\":\"starting\"}");
        Thread.Sleep(1200);
        File.WriteAllText(path, "{\"state\":\"completed\",\"ok\":true,\"exportedRows\":2}");
    }
}''', encoding='utf-8')
            compile_command = "Add-Type -Path '" + str(source).replace("'", "''") + "' -OutputAssembly '" + str(binary).replace("'", "''") + "' -OutputType WindowsApplication"
            subprocess.run([str(powershell), '-NoProfile', '-Command', compile_command], check=True, capture_output=True, timeout=30)
            (root / 'runtime.json').write_text(json.dumps({'version': 'synthetic',
                'exeRelativePath': 'bin/fixture.exe', 'exeSha256': hashlib.sha256(binary.read_bytes()).hexdigest()}))
            result = subprocess.run([str(powershell), '-NoProfile', '-ExecutionPolicy', 'Bypass',
                '-File', str(root / 'scripts/run.ps1'), '-ChatName', 'Synthetic sample',
                '-DataDir', str(root / 'profile')], capture_output=True, timeout=30)
            time.sleep(2)  # Allow the synthetic executable to release its file before cleanup.
            self.assertEqual(result.returncode, 0, result.stderr.decode(errors='replace'))
            output = json.loads(result.stdout.decode('utf-8-sig'))
            self.assertEqual(output['state'], 'completed')
            self.assertTrue(output['ok'])
            self.assertEqual(output['exportedRows'], 2)
            receipt = Path(output['resultFile'])
            self.assertEqual(receipt.parent, root / 'profile/requests')
            self.assertEqual(json.loads(receipt.read_text())['state'], 'completed')
            result = subprocess.run([str(powershell), '-NoProfile', '-ExecutionPolicy', 'Bypass',
                '-File', str(root / 'scripts/run.ps1'), '-ChatName', 'Awaiting review',
                '-DataDir', str(root / 'review-profile')], capture_output=True, timeout=30)
            self.assertEqual(result.returncode, 0, result.stderr.decode(errors='replace'))
            pending = json.loads(result.stdout.decode('utf-8-sig'))
            self.assertEqual(pending['state'], 'awaiting_review')
            self.assertFalse(pending['ok'])
            self.assertEqual(json.loads(Path(pending['resultFile']).read_text())['state'], 'awaiting_review')
            self.assertNotIn('exportFiles', pending)
            self.assertFalse((root / 'review-profile/exports').exists())



    def test_direct_export_is_rejected_before_profile_or_runtime_access(self):
        project = Path(__file__).resolve().parents[1]
        powershell = Path(os.environ['SYSTEMROOT']) / 'System32/WindowsPowerShell/v1.0/powershell.exe'
        with tempfile.TemporaryDirectory(prefix='synthetic-skill-gate-') as folder:
            profile = Path(folder) / 'profile'
            result = subprocess.run([str(powershell), '-NoProfile', '-ExecutionPolicy', 'Bypass',
                '-File', str(project / 'skills/local-wechat-archive/scripts/run.ps1'),
                '-Mode', 'Export', '-ChatName', 'Synthetic sample', '-DataDir', str(profile)],
                capture_output=True, timeout=10)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn('Direct export is disabled', result.stderr.decode(errors='replace'))
            self.assertFalse(profile.exists())
