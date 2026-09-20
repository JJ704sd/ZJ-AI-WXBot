"""Windows built-in OCR, no network, no global SDK initialization."""
import json
import os
from pathlib import Path
import subprocess
import tempfile

from .hybrid_observer import ObservationBlocked


class WindowsOcr:
    def __init__(self, language='zh-Hans', timeout=12):
        self.language, self.timeout = language, timeout

    def recognize(self, image):
        executable = Path(os.environ['SystemRoot']) / 'System32/WindowsPowerShell/v1.0/powershell.exe'
        with tempfile.TemporaryDirectory(prefix='wechat-readonly-ocr-') as directory:
            source, output = Path(directory) / 'crop.png', Path(directory) / 'result.json'
            image.save(source)
            try:
                process = subprocess.run(
                    [str(executable), '-NoProfile', '-NonInteractive',
                     '-ExecutionPolicy', 'Bypass', '-File',
                     str(Path(__file__).with_name('windows_ocr.ps1')),
                     '-ImagePath', str(source), '-OutputPath', str(output),
                     '-Language', self.language], timeout=self.timeout,
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                    creationflags=0x08000000)
            except subprocess.TimeoutExpired:
                raise ObservationBlocked('ocr_timeout') from None
            if not output.exists():
                raise ObservationBlocked('ocr_unavailable_or_failed')
            value = json.loads(output.read_text(encoding='utf-8'))
            status = value.get('status')
            if status in {'ocr_initialization_failed', 'ocr_language_unavailable',
                          'ocr_decode_failed', 'ocr_recognition_failed'}:
                raise ObservationBlocked(status)
            if status != 'ok' or process.returncode != 0:
                raise ObservationBlocked('ocr_unavailable_or_failed')
            return value['lines']


class ImageBackend:
    """Explicit offline input. Never claims a live WeChat observation."""
    def __init__(self, path):
        from PIL import Image
        self.image = Image.open(path).convert('RGB')

    def observe(self):
        return {'kind': 'offline_image', 'available': True, 'size': list(self.image.size)}

    def uia(self, layout):
        return {'status': 'semantic_unavailable'}

    def capture(self):
        return self.image.copy()

    def close(self):
        self.image.close()
