"""Real subprocess fault injection for the synthetic UIA collector; no GUI access."""
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import time

from probe_uia_v3_native import run_collection


def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--hang':
        child = subprocess.Popen([sys.executable, '-c', 'import time; time.sleep(60)'],
                                 creationflags=0x08000000)
        Path(sys.argv[2]).write_text(str(child.pid), encoding='utf-8')
        time.sleep(60)
        return
    with tempfile.TemporaryDirectory(prefix='uia-watchdog-test-') as folder:
        root = Path(folder)
        marker = root / 'child.pid'
        start = time.monotonic()
        timed = run_collection([sys.executable, __file__, '--hang', str(marker)], root / 'absent.json', timeout=2)
        elapsed = time.monotonic() - start
        assert marker.exists(), 'fault worker did not start'
        assert timed['execution_status'] == 'timed_out' and timed['passed'] is False
        assert timed['run_id'] and timed['cleanup']['tracked_processes'] >= 2
        assert not timed['cleanup']['errors'] and not timed['cleanup']['remaining_pids']
        import psutil
        assert not psutil.pid_exists(int(marker.read_text())), 'synthetic descendant survived'
        missing = run_collection([sys.executable, '-c', 'pass'], root / 'missing.json', timeout=2)
        assert missing['execution_status'] == 'error' and missing['error_type'] == 'FileNotFoundError'
        false_success = root / 'false-success.json'
        false_success.write_text('{"execution_status":"completed","passed":true}', encoding='utf-8')
        crashed = run_collection([sys.executable, '-c', 'raise SystemExit(3)'], false_success, timeout=2)
        assert crashed['execution_status'] == 'error' and crashed['passed'] is False
        receipt = {'schema': 'uia-watchdog-check/1', 'wechat_access': False,
                   'fault_cases_passed': 3, 'timeout_elapsed_seconds': round(elapsed, 3),
                   'timed_out': timed, 'missing_report': missing, 'nonzero_exit': crashed}
        Path(sys.argv[1]).write_text(json.dumps(receipt, indent=2), encoding='utf-8')
        print(json.dumps(receipt))


if __name__ == '__main__':
    main()
