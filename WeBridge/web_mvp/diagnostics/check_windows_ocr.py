#!/usr/bin/env python3
"""Exercise real Windows OCR on generated pixels, never capture a desktop.

Run: python web_mvp/diagnostics/check_windows_ocr.py
This substitutes only the capture seam; OCR and result filtering are real.
It proves neither WeChat capture nor native message identity/continuity.
"""
import base64
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import windows_reader


DRAW = r'''
param([string]$Destination)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$bitmap = [Drawing.Bitmap]::new(960, 220)
$graphics = [Drawing.Graphics]::FromImage($bitmap)
$font = [Drawing.Font]::new('Segoe UI', 36)
try {
    $graphics.Clear([Drawing.Color]::White)
    $bitmap.Save((Join-Path $Destination 'blank.png'), [Drawing.Imaging.ImageFormat]::Png)
    $graphics.DrawString('WE BRIDGE OCR 12345', $font, [Drawing.Brushes]::Black, 24, 60)
    $bitmap.Save((Join-Path $Destination 'text.png'), [Drawing.Imaging.ImageFormat]::Png)
} finally {
    $font.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
}
'''


def main():
    if os.name != 'nt':
        raise SystemExit('This diagnostic requires Windows; it does not capture a screen.')
    powershell = Path(os.environ.get('SystemRoot', r'C:\Windows')) / 'System32/WindowsPowerShell/v1.0/powershell.exe'
    results = []
    with tempfile.TemporaryDirectory(prefix='webridge-synthetic-ocr-') as folder:
        directory = Path(folder)
        script = directory / 'draw.ps1'
        script.write_text(DRAW, encoding='utf-8-sig')
        subprocess.run([str(powershell), '-NoProfile', '-NonInteractive', '-ExecutionPolicy',
                        'Bypass', '-File', str(script), '-Destination', folder],
                       check=True, timeout=15, stdout=subprocess.DEVNULL,
                       creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
        for name in ('text', 'blank'):
            capture = {'ok': True, 'pid': 1, 'hwnd': '1', 'title': 'Generated OCR fixture',
                       'png_base64': base64.b64encode((directory / (name + '.png')).read_bytes()).decode('ascii')}
            with patch.object(windows_reader.windows_client, 'capture', return_value=capture):
                result = windows_reader.preview_ocr(1, '1')
            assert 'png_base64' not in result and not result['canSend'] and not result['identityVerified']
            text = ' '.join(row['text'] for row in result['texts'])
            if name == 'text':
                # Chinese OCR can segment a Latin word with extra spaces.
                assert result['ok'] and ''.join(text.split()) == 'WEBRIDGEOCR12345', {'issue': result['issue'], 'syntheticText': text}
            else:
                assert not result['ok'] and result['issueCode'] == 'ocr_no_text', result['issue']
            results.append({'fixture': name, 'passed': True, 'ok': result['ok'],
                            'issueCode': result['issueCode'], 'text': text})
    print(json.dumps({'checks': results, 'engine': 'Windows.Media.Ocr',
                      'capture': 'synthetic substitution', 'realClientTested': False,
                      'temporaryFilesRemoved': not directory.exists()}, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
