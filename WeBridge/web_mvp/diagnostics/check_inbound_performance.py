"""Benchmark inbound scans using only temporary synthetic SQLite snapshots.

Run with Python from any directory; no native client or send operation is used.
"""
import argparse
from contextlib import contextmanager, closing
from collections import Counter
import hashlib
import json
import os
from pathlib import Path
import platform
import sqlite3
import statistics
import sys
import tempfile
import threading
import time
from types import SimpleNamespace


PROJECT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(PROJECT / 'web_mvp'))
from backend import Engine, Store
from database_adapter import DatabaseAdapter
from test_database_adapter import create_metadata, create_shard, GROUP, SELF, STAMP
from windows_auto_reply import WindowsAutoReply


class TimedLock:
    def __init__(self):
        self.lock = threading.RLock()
        self.depth = 0
        self.holds = []

    def __enter__(self):
        self.lock.acquire()
        if not self.depth:
            self.started = time.perf_counter()
        self.depth += 1
        return self

    def __exit__(self, *args):
        self.depth -= 1
        if not self.depth:
            self.holds.append(time.perf_counter() - self.started)
        self.lock.release()


class NoSend:
    def _request(self, request):
        return request

    def automation_binding(self, binding):
        return {'synthetic': True}

    def supports_target(self, group):
        return True

    def send_automatic(self, *args, **kwargs):
        raise AssertionError('This diagnosis must never reach a sender')


class Meter:
    def __init__(self):
        self.reset()

    def reset(self):
        self.present_count = 0
        self.present_seconds = 0
        self.execute_seconds = 0
        self.statements = Counter()
        self.vm_steps_approx = 0
        self.plans = {}

    def record_plan(self, db, sql, params):
        if not sql.startswith('SELECT') or ' FROM "Msg_' not in sql:
            return
        if 'inbound_rowid' not in sql:
            label = 'recent200'
        else:
            label = 'revokes' if '4294967295' in sql else 'window'
            if ') > (?,?,?)' in sql:
                label += '_continuation'
        self.statements[label] += 1
        if label not in self.plans:
            self.plans[label] = {'sql': sql, 'params': list(params),
                'plan': [[value.decode() if isinstance(value, bytes) else value for value in row]
                         for row in db.execute('EXPLAIN QUERY PLAN ' + sql, params)]}


class MeteredDB:
    def __init__(self, db, meter):
        self.db, self.meter = db, meter

    def execute(self, sql, params=()):
        self.meter.record_plan(self.db, sql, params)
        self.meter.statements['all_execute'] += 1
        started = time.perf_counter()
        result = self.db.execute(sql, params)
        self.meter.execute_seconds += time.perf_counter() - started
        return result


def instrument(adapter, meter):
    original_present = adapter._present_message
    original_connect = adapter._connect

    def present(*args, **kwargs):
        meter.present_count += 1
        started = time.perf_counter()
        result = original_present(*args, **kwargs)
        meter.present_seconds += time.perf_counter() - started
        return result

    @contextmanager
    def connect(path):
        with original_connect(path) as db:
            def progress():
                meter.vm_steps_approx += 1000
                return 0
            db.set_progress_handler(progress, 1000)
            yield MeteredDB(db, meter)

    adapter._present_message = present
    adapter._connect = connect


def build_fixture(root, history_count, kind, indexed):
    create_metadata(root)
    now = STAMP + 100000
    historical_text = ('<sysmsg><content>synthetic historical system notice</content></sysmsg>'
                       if kind == 'system' else '<msg><img length="12345" width="320" height="200"/></msg>')
    rows = [{'local': i + 1, 'server': i + 1, 'time': STAMP + i,
             'type': 10000 if kind == 'system' else 3, 'text': historical_text}
            for i in range(history_count)]
    rows += [{'local': history_count + i + 1, 'server': history_count + i + 1,
              'time': now - 2 + i // 101, 'type': 1, 'text': 'synthetic current plain text ' + str(i),
              'atuserlist': ''} for i in range(201)]
    path = create_shard(root, rows=rows)
    if indexed:
        with closing(sqlite3.connect(path)) as db:
            db.execute('CREATE INDEX message_time_local ON "Msg_' + hashlib.md5(GROUP.encode()).hexdigest() + '"(create_time,local_id)')
            db.commit()
    return now


def run_case(root, count, kind, indexed, repeats):
    source_root = root / 'source'
    now = build_fixture(source_root, count, kind, indexed)
    adapter = DatabaseAdapter(source_root, self_id=SELF, source_id='synthetic-perf', source_info={'revision': 'fixed'})
    meter = Meter()
    instrument(adapter, meter)
    engine = Engine(Store(root / 'engine/state.sqlite'), adapter)
    engine.refresh_connection(force=True)
    engine.set_watched('synthetic-perf', [GROUP])
    source_lock, sync_lock = TimedLock(), TimedLock()
    engine.sync_lock = sync_lock
    source = SimpleNamespace(lock=source_lock, busy=False, error='',
        config={'autoRefresh': True, 'selfId': SELF, 'sourceRoot': str(source_root)})
    clock = SimpleNamespace(now=now-3)
    service = WindowsAutoReply(engine, source, lambda: NoSend(), clock=lambda: clock.now)
    service.configure('synthetic-perf', GROUP, True, 'synthetic approved reply never sent', 30)
    clock.now = now

    def scan():
        cursor, found, pages = None, [], 0
        with source.lock, engine.sync_lock:
            while True:
                data = adapter.call('inbound_messages', account='synthetic-perf', groupId=GROUP,
                                    start=now-120, end=now+5, cursor=cursor)
                assert not data['warnings'], data['warnings']
                found.extend(row['id'] for row in data['messages'])
                pages += 1
                if data['complete']:
                    break
                cursor = data['cursor']
        assert len(found) == 201 and len(set(found)) == 201
        return {'delivered': len(found), 'pages': pages}

    def recent():
        data = adapter.call('messages', account='synthetic-perf', groupId=GROUP)
        assert len(data['messages']) == 200 and not data['warnings']
        return {'delivered': 200}

    def tick():
        service.tick()
        assert service.get('synthetic-perf', GROUP)['enabled']
        assert service.get('synthetic-perf', GROUP)['attempts'] == []
        return {'rules': 1, 'sends': 0}

    measured = {name: [] for name in ('scan', 'tick', 'recent200')}
    plans = {}
    for name, operation in (('scan', scan), ('tick', tick), ('recent200', recent)):
        # A fresh adapter state makes the first observation cold for any
        # in-memory derived data, without changing the snapshot revision label.
        adapter.configure(source_root, self_id=SELF, source_id='synthetic-perf', source_info={'revision': 'fixed'})
        for repeat in range(repeats):
            meter.reset()
            source_lock.holds.clear()
            sync_lock.holds.clear()
            started = time.perf_counter()
            detail = operation()
            elapsed = time.perf_counter() - started
            measured[name].append({'repeat': repeat, 'elapsed_ms': round(elapsed*1000, 3),
                'present_count': meter.present_count, 'present_ms': round(meter.present_seconds*1000, 3),
                'execute_ms': round(meter.execute_seconds*1000, 3), 'sql': dict(meter.statements),
                'vm_steps_approx': meter.vm_steps_approx,
                'source_lock_ms': round(sum(source_lock.holds)*1000, 3),
                'sync_lock_ms': round(sum(sync_lock.holds)*1000, 3), **detail})
            plans.update(meter.plans)
    result = {'history_rows': count, 'history_kind': kind, 'indexed': indexed, 'window_rows': 201,
              'samples': measured, 'query_plans': plans}
    for name, samples in measured.items():
        times = [row['elapsed_ms'] for row in samples]
        result.setdefault('summary', {})[name] = {'median_ms': round(statistics.median(times), 3),
             'min_ms': min(times), 'max_ms': max(times), 'decode_counts': sorted({row['present_count'] for row in samples})}
    print(json.dumps({'case': [count, kind, indexed], 'summary': result['summary']}, ensure_ascii=False), flush=True)
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--repeats', type=int, default=3)
    parser.add_argument('--output', type=Path, default=PROJECT / '.runtime/diagnostics/inbound_performance.json')
    args = parser.parse_args()
    if args.repeats < 1:
        parser.error('--repeats must be positive')
    output = {'environment': {'python': sys.version, 'executable': sys.executable,
        'os': platform.platform(), 'machine': platform.machine(), 'cpu': platform.processor(),
        'logical_cpus': os.cpu_count(), 'sqlite': sqlite3.sqlite_version,
        'production_sha256': {name: hashlib.sha256((PROJECT / 'web_mvp' / name).read_bytes()).hexdigest()
            for name in ('inbound_messages.py', 'database_adapter.py', 'windows_auto_reply.py')}},
        'method': {'repeats': args.repeats, 'warmup': 'setup excluded; each operation starts with fresh adapter state; OS caches not flushed',
            'clock': 'fixed synthetic value', 'sender': 'NoSend local stub, raises on send',
            'instrumentation': 'present calls/timing, connection execute timing, SQLite progress every 1000 VM ops',
            'limitations': 'single group; no real snapshots or Hook; first measured call is not a cold boot; timings include narrow instrumentation'},
        'cases': []}
    with tempfile.TemporaryDirectory(prefix='webridge-synthetic-inbound-perf-') as temp:
        for count, kind, indexed in ((3000, 'system', True), (10000, 'system', True),
                                     (3000, 'image', True), (10000, 'image', True), (10000, 'image', False)):
            output['cases'].append(run_case(Path(temp) / f'{count}_{kind}_{indexed}', count, kind, indexed, args.repeats))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(output, ensure_ascii=False, indent=2), encoding='utf-8')


if __name__ == '__main__':
    main()
