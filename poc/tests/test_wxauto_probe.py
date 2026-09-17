import importlib.util
import json
from pathlib import Path
import subprocess

spec = importlib.util.spec_from_file_location('probe', Path(__file__).parents[1] / 'scripts' / 'probe_wxauto4_capability.py')
probe = importlib.util.module_from_spec(spec)
spec.loader.exec_module(probe)


def test_timeout_has_one_attempt(tmp_path):
    calls = []
    def run(cmd, **kwargs):
        calls.append(cmd)
        assert kwargs['timeout'] == 30
        assert kwargs['stdout'] == subprocess.DEVNULL
        raise subprocess.TimeoutExpired(cmd, 30)
    assert probe.bounded_worker(tmp_path / 'result.json', run=run)['status'] == 'probe_timeout'
    assert len(calls) == 1


def test_missing_report_is_not_success(tmp_path):
    assert probe.bounded_worker(tmp_path / 'result.json', run=lambda *a, **k: None)['status'] == 'worker_failed_without_report'


def test_metadata_result_only(tmp_path):
    path = tmp_path / 'result.json'
    def run(*args, **kwargs):
        path.write_text(json.dumps({'status': 'uia_unavailable'}), encoding='utf-8')
    assert probe.bounded_worker(path, run=run)['status'] == 'uia_unavailable'
