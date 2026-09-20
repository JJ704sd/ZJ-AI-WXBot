"""One bounded target-window capture for manual ROI calibration; no UI inputs."""
import argparse
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.hybrid_windows import wait_for_window
from wechat_agent_poc.hybrid_observer import ObservationBlocked

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('hwnd', type=lambda value: int(value, 0))
parser.add_argument('output', type=Path)
parser.add_argument('--capture-method', choices=['window', 'screen_region'], default='window')
parser.add_argument('--wait-for-foreground', type=int, choices=range(0, 31), default=0,
                    metavar='0..30', help='Bounded metadata-only wait before one capture')
args = parser.parse_args()
try:
    if args.output.exists():
        raise ObservationBlocked('output_already_exists')
    backend = wait_for_window(args.hwnd, args.capture_method, args.wait_for_foreground)
    before = backend.observe()
    with backend.capture() as image:
        if backend.observe() != before or list(image.size) != before['size']:
            raise ObservationBlocked('capture_binding_changed')
        args.output.parent.mkdir(parents=True, exist_ok=True)
        with args.output.open('xb') as stream:
            image.save(stream, format='PNG')
    print(json.dumps({'status': 'CAPTURED', 'size': before['size'],
                      'capture_method': args.capture_method, 'ocr_executed': False}))
except ObservationBlocked as exc:
    print(json.dumps({'status': 'BLOCKED', 'reason': str(exc)}))
    raise SystemExit(2)
except Exception:
    print(json.dumps({'status': 'BLOCKED', 'reason': 'capture_failed'}))
    raise SystemExit(2)
