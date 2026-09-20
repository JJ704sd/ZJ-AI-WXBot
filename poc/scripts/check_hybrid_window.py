"""Check a supplied HWND without capturing images, reading names or activating."""
import argparse
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.hybrid_observer import ObservationBlocked
from wechat_agent_poc.hybrid_windows import WindowsBackend

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('hwnd', type=lambda value: int(value, 0))
args = parser.parse_args()
try:
    backend = WindowsBackend(args.hwnd)
    print(json.dumps({'status': 'WINDOW_AVAILABLE', **backend.observe()}))
except ObservationBlocked as exc:
    print(json.dumps({'status': 'BLOCKED', 'reason': str(exc)}))
    raise SystemExit(2)
except Exception:
    print(json.dumps({'status': 'BLOCKED', 'reason': 'window_check_failed'}))
    raise SystemExit(2)
