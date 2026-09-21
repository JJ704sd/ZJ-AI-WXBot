"""Bounded experimental visible-text trigger; no sender identity or send API."""
import argparse
import json
from pathlib import Path
import re
import subprocess
import sys
import time

from .hybrid_observer import HybridSessionObserver, Layout, ObservationBlocked, label_key


class ControlledTrigger:
    def __init__(self, expected):
        if not re.fullmatch(r'UIA-READ-[A-Z0-9]{8}(?: [^\r\n]{1,60})?', expected):
            raise ValueError('invalid_test_trigger')
        self.expected = expected
        self.marker = expected.split()[0]
        self.binding = None
        self.header = None
        self.seen_snapshots = set()
        self.streak = 0
        self.emitted = False
        self.paused = False

    def consume(self, snapshot):
        if self.paused:
            raise ObservationBlocked('trigger_paused')
        try:
            return self._consume(snapshot)
        except (ObservationBlocked, KeyError, TypeError):
            self.paused = True
            raise

    def _consume(self, snapshot):
        if snapshot['capture_kind'] != 'live_window':
            raise ObservationBlocked('live_snapshot_required')
        if snapshot.get('review_required') is True or snapshot.get('target_label_match') is not True:
            raise ObservationBlocked('target_label_unconfirmed')
        identity = snapshot['snapshot_id']
        if identity in self.seen_snapshots:
            return 'REPLAY_IGNORED'
        self.seen_snapshots.add(identity)
        # Each poll already checks a stable capture rectangle. Between polls,
        # pure translation is harmless to window-relative ROIs; retain size/DPI.
        binding = {k: v for k, v in snapshot['window_observation'].items() if k != 'rect'}
        header = tuple(label_key(row['text']) for row in snapshot['header'])
        if not header:
            raise ObservationBlocked('header_absent')
        rows = [row['text'] for row in snapshot['messages']]
        occurrences = sum(self.marker in text for text in rows)
        complete = sum(label_key(self.expected) == label_key(text) for text in rows)
        if self.binding is None:
            if occurrences:
                raise ObservationBlocked('trigger_already_in_baseline')
            self.binding, self.header = binding, header
            return 'BASELINE_READY'
        if binding != self.binding or header != self.header:
            raise ObservationBlocked('window_or_header_changed')
        if self.emitted:
            return 'ALREADY_EMITTED'
        self.streak = self.streak + 1 if occurrences == complete == 1 else 0
        if self.streak >= 2:
            self.emitted = True
            return 'CANDIDATE_ONCE'
        return 'WAITING'


def write_new(path, value):
    with path.open('x', encoding='utf-8') as stream:
        json.dump(value, stream, ensure_ascii=False, indent=2)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--hwnd', type=int, required=True)
    parser.add_argument('--layout', type=Path, required=True)
    parser.add_argument('--run-dir', type=Path, required=True)
    parser.add_argument('--trigger', required=True)
    parser.add_argument('--cycles', type=int, default=12)
    parser.add_argument('--interval', type=float, default=3)
    parser.add_argument('--draft', action='store_true', help='At most one M3 request; never send')
    args = parser.parse_args()
    if not 3 <= args.cycles <= 20 or not 2 <= args.interval <= 10:
        parser.error('cycles 3..20 and interval 2..10 required')
    detector = ControlledTrigger(args.trigger)
    args.run_dir.mkdir(parents=True, exist_ok=False)
    report = {'status': 'STARTED', 'polls': 0, 'candidate_count': 0,
              'draft_attempts': 0, 'send_attempts': 0,
              'native_mentions_verified': False, 'new_messages_verified': False,
              'account_verified': False, 'group_verified': False}
    try:
        from .hybrid_windows import WindowsBackend
        from .rapid_ocr import RapidOcr
        layout = Layout.from_dict(json.loads(args.layout.read_text(encoding='utf-8-sig')))
        observer = HybridSessionObserver(WindowsBackend(args.hwnd, 'screen_region'), RapidOcr(),
                                         layout, review_unconfirmed_title=False)
        for index in range(args.cycles):
            snapshot = observer.poll()
            path = args.run_dir / f'snapshot-{index:02}.json'
            write_new(path, snapshot)
            report['polls'] += 1
            signal = detector.consume(snapshot)
            print(json.dumps({'poll': index, 'signal': signal}), flush=True)
            if signal == 'BASELINE_READY':
                write_new(args.run_dir / 'ready.json', {'trigger': args.trigger,
                          'baseline_snapshot_id': snapshot['snapshot_id'], 'send_enabled': False})
            if signal == 'CANDIDATE_ONCE':
                report.update(status='CANDIDATE_OBSERVED', candidate_count=1)
                # Persistent claim is made before the one external model call.
                write_new(args.run_dir / 'candidate-claim.json', {
                    'snapshot_id': snapshot['snapshot_id'], 'trigger': args.trigger,
                    'interpretation': 'newly visible controlled string, not a native message event'})
                if args.draft:
                    report['draft_attempts'] = 1
                    result = subprocess.run([sys.executable,
                        str(Path(__file__).resolve().parents[1] / 'scripts/prepare_controlled_m3_reply.py'),
                        '--source-snapshot', str(path.resolve()), '--trigger', args.trigger,
                        '--output', str((args.run_dir / 'draft.json').resolve())],
                        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=30)
                    report['status'] = 'DRAFT_PREPARED' if result.returncode == 0 else 'DRAFT_FAILED_NO_RETRY'
                break
            if index + 1 < args.cycles:
                time.sleep(args.interval)
        else:
            report['status'] = 'TIMEOUT_NO_CANDIDATE'
    except ObservationBlocked as exc:
        report.update(status='BLOCKED', reason=str(exc))
    except Exception as exc:
        report.update(status='ERROR', reason=type(exc).__name__)
    finally:
        write_new(args.run_dir / 'result.json', report)
    print(json.dumps(report), flush=True)
    return 0 if report['status'] in ('CANDIDATE_OBSERVED', 'DRAFT_PREPARED') else 2


if __name__ == '__main__':
    raise SystemExit(main())
