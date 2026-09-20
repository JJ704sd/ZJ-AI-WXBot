from pathlib import Path
import json
import subprocess

import pytest

from wechat_agent_poc.hybrid_observer import ObservationBlocked
from wechat_agent_poc.local_ocr import WindowsOcr


class Image:
    def save(self, path):
        Path(path).write_bytes(b'synthetic')


def test_unique_temp_crops_removed_and_whitespace_preserved(monkeypatch):
    paths = []
    def run(command, **options):
        source = Path(command[command.index('-ImagePath') + 1])
        output = Path(command[command.index('-OutputPath') + 1])
        paths.append(source)
        assert source.exists()
        assert options['timeout'] == 12
        output.write_text(json.dumps({'status': 'ok', 'lines': [
            {'text': 'a b', 'box': [1, 2, 30, 40]}]}), encoding='utf-8')
        return subprocess.CompletedProcess(command, 0)
    monkeypatch.setenv('SystemRoot', 'C:/Windows')
    monkeypatch.setattr(subprocess, 'run', run)
    ocr = WindowsOcr()
    assert ocr.recognize(Image())[0]['text'] == 'a b'
    ocr.recognize(Image())
    assert paths[0] != paths[1]
    assert all(not path.parent.exists() for path in paths)


def test_ocr_timeout_is_distinct_and_cleans_input(monkeypatch):
    paths = []
    def run(command, **options):
        paths.append(Path(command[command.index('-ImagePath') + 1]))
        raise subprocess.TimeoutExpired(command, 12)
    monkeypatch.setenv('SystemRoot', 'C:/Windows')
    monkeypatch.setattr(subprocess, 'run', run)
    with pytest.raises(ObservationBlocked, match='^ocr_timeout$'):
        WindowsOcr().recognize(Image())
    assert not paths[0].parent.exists()


def test_missing_language_is_not_successful_empty_ocr(monkeypatch):
    def run(command, **options):
        Path(command[command.index('-OutputPath') + 1]).write_text(
            '{"status":"ocr_language_unavailable"}', encoding='utf-8')
        return subprocess.CompletedProcess(command, 2)
    monkeypatch.setenv('SystemRoot', 'C:/Windows')
    monkeypatch.setattr(subprocess, 'run', run)
    with pytest.raises(ObservationBlocked, match='^ocr_language_unavailable$'):
        WindowsOcr().recognize(Image())
