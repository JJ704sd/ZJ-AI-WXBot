"""Compare snapshot implementations using only generated local data.

The parent creates fixtures once and alternates baseline/current subprocesses.
Timed operations exclude fixture creation and SHA-256 comparison. A separate
tracemalloc pass records Python allocation peak (not total process working set).
No keys, accounts, network access, or real chat data are required.
"""
import argparse
from contextlib import closing
import hashlib
import hmac
import json
from pathlib import Path
import shutil
import sqlite3
import statistics
import struct
import subprocess
import sys
import tempfile
import time
import tracemalloc


ROOT = Path(__file__).resolve().parents[1]


def file_hash(path):
    with path.open('rb') as handle:
        return hashlib.file_digest(handle, 'sha256').hexdigest()


def fixtures(root, mib):
    sys.path.insert(0, str(ROOT / 'web_mvp'))
    from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
    from wecom_crypto import page_iv
    from database_snapshot import SQLITE_HEADER
    key, salt = bytes(range(32)), bytes(range(16))
    mac_key = hashlib.pbkdf2_hmac('sha512', key, bytes(b ^ 0x3a for b in salt), 2, 32)
    expected = hashlib.sha256()
    with (root / 'wechat.db').open('xb') as outgoing:
        for number in range(1, mib * 256 + 1):
            offset = 16 if number == 1 else 0
            body = bytes([number % 251]) * (4016 - offset)
            iv = number.to_bytes(16, 'little')
            encryptor = Cipher(algorithms.AES(key), modes.CBC(iv)).encryptor()
            encrypted = encryptor.update(body) + encryptor.finalize() + iv
            mac = hmac.new(mac_key, encrypted + number.to_bytes(4, 'little'), hashlib.sha512).digest()
            outgoing.write((salt if offset else b'') + encrypted + mac)
            expected.update((SQLITE_HEADER if offset else b'') + body + iv + mac)
    hashes = {'wechat': expected.hexdigest()}
    plain = root / 'wecom-plain'
    plain.mkdir()
    for name in ('message.db', 'session.db', 'user.db'):
        with closing(sqlite3.connect(plain / name)) as connection:
            connection.execute('PRAGMA page_size=4096')
            connection.execute('CREATE TABLE samples(id INTEGER PRIMARY KEY, payload BLOB)')
            count = mib * 1024 if name == 'message.db' else 8
            connection.executemany('INSERT INTO samples(payload) VALUES (?)', ((bytes(1024),) for _ in range(count)))
            connection.commit()
    hashes['wecom'] = {p.name: file_hash(p) for p in plain.iterdir()}
    encrypted_root = root / 'wecom-encrypted'
    encrypted_root.mkdir()
    for path in plain.iterdir():
        with path.open('rb') as incoming, (encrypted_root / path.name).open('xb') as outgoing:
            number = 0
            while page := incoming.read(4096):
                number += 1
                pagekey = hashlib.md5(key[:16] + struct.pack('<I', number) + b'sAlT').digest()
                encryptor = Cipher(algorithms.AES(pagekey), modes.CBC(page_iv(number))).encryptor()
                body = page[16:] if number == 1 else page
                encrypted = encryptor.update(body) + encryptor.finalize()
                outgoing.write(bytes(8) + encrypted[:8] + page[16:24] + encrypted[8:] if number == 1 else encrypted)
    (root / 'keys.json').write_text(json.dumps({'wecomKeys': [{'database': '*', 'key_hex': key[:16].hex()}]}))
    (root / 'expected.json').write_text(json.dumps(hashes))
    return {'wechatBytes': (root / 'wechat.db').stat().st_size,
            'wecomBytes': sum(p.stat().st_size for p in plain.iterdir()), 'wecomRows': mib * 1024 + 16}


def worker(args):
    # Baseline contains only changed modules; unchanged dependencies come from
    # the checkout. No production config or runtime folder is imported.
    sys.path[:0] = [str(args.module_root), str(ROOT / 'web_mvp')]
    import database_snapshot
    import wecom_snapshot
    fixture = args.fixture
    expected = json.loads((fixture / 'expected.json').read_text())
    source_hashes = {path: file_hash(path) for case in args.cases for path in
                     ([fixture / 'wechat.db'] if case == 'wechat' else (fixture / case).glob('*.db'))}
    results = {}
    with tempfile.TemporaryDirectory(prefix='group-snapshot-worker-') as folder:
        output = Path(folder)
        for case in args.cases:
            def operation():
                if case == 'wechat':
                    target = output / 'wechat.db'
                    database_snapshot._decrypt_database(fixture / 'wechat.db', target,
                                                        {bytes(range(16)): [bytes(range(32))]})
                    return target
                result = wecom_snapshot.prepare_snapshot(fixture / case, output,
                    fixture / 'keys.json' if case.endswith('encrypted') else None)
                return result['root']

            def verify_and_remove(path):
                if case == 'wechat':
                    assert file_hash(path) == expected['wechat']
                    path.unlink()
                else:
                    assert {p.name: file_hash(p) for p in path.glob('*.db')} == expected['wecom']
                    assert path.resolve() != output.resolve() and path.resolve().is_relative_to(output.resolve())
                    shutil.rmtree(path)

            # Warm crypto/SQLite imports independently of timed samples.
            verify_and_remove(operation())
            started = time.perf_counter()
            result = operation()
            elapsed = time.perf_counter() - started
            verify_and_remove(result)
            peak = None
            if args.trace:
                tracemalloc.start()
                result = operation()
                _, peak = tracemalloc.get_traced_memory()
                tracemalloc.stop()
                verify_and_remove(result)
            results[case] = {'seconds': elapsed, 'pythonPeakBytes': peak, 'exactOutput': True}
    assert all(file_hash(path) == digest for path, digest in source_hashes.items())
    print(json.dumps(results))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--baseline', type=Path)
    parser.add_argument('--mib', type=int, default=32)
    parser.add_argument('--repeats', type=int, default=3)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--cases', nargs='+', choices=('wechat', 'wecom-plain', 'wecom-encrypted'),
                        default=('wechat', 'wecom-plain', 'wecom-encrypted'))
    parser.add_argument('--worker', action='store_true', help=argparse.SUPPRESS)
    parser.add_argument('--module-root', type=Path, help=argparse.SUPPRESS)
    parser.add_argument('--fixture', type=Path, help=argparse.SUPPRESS)
    parser.add_argument('--trace', action='store_true', help=argparse.SUPPRESS)
    args = parser.parse_args()
    if args.worker:
        worker(args)
        return
    if not args.baseline or not args.output or args.mib < 1 or args.repeats < 1:
        parser.error('--baseline, --output, positive --mib and --repeats are required')
    report = {'method': 'Alternating local synthetic baseline/current runs; warm filesystem cache; '
              'timing excludes fixture creation, hash comparison and allocation tracing. '
              'Peak is Python traced allocation, not process working set. '
              'WeChat case is authenticated page decryption only; WeCom cases include stable '
              'capture, complete source rehash, decoding, quick_check and manifest.',
              'python': sys.version, 'repeats': args.repeats, 'cases': args.cases,
              'allocationSamplesPerVersion': 1, 'runs': {'baseline': [], 'current': []}}
    with tempfile.TemporaryDirectory(prefix='group-snapshot-benchmark-') as folder:
        fixture = Path(folder)
        report['fixture'] = fixtures(fixture, args.mib)
        roots = {'baseline': args.baseline.resolve(), 'current': ROOT / 'web_mvp'}
        report['sourceHashes'] = {label: {name: file_hash(root / name) for name in
            ('database_snapshot.py', 'wecom_snapshot.py', 'wecom_crypto.py')} for label, root in roots.items()}
        for iteration in range(args.repeats):
            for label in (('baseline', 'current') if iteration % 2 == 0 else ('current', 'baseline')):
                process = subprocess.run([sys.executable, '-X', 'utf8', __file__, '--worker',
                    '--module-root', str(roots[label]), '--fixture', str(fixture),
                    '--cases', *args.cases, *(['--trace'] if iteration == 0 else [])],
                    check=True, capture_output=True, text=True, encoding='utf8')
                report['runs'][label].append(json.loads(process.stdout))
        report['summary'] = {}
        for case in args.cases:
            summary = {label: {'medianSeconds': statistics.median(row[case]['seconds'] for row in runs),
                              'maxPythonPeakBytes': max(row[case]['pythonPeakBytes'] for row in runs
                                                       if row[case]['pythonPeakBytes'] is not None)}
                       for label, runs in report['runs'].items()}
            summary['elapsedReductionPercent'] = 100 * (1 - summary['current']['medianSeconds'] /
                                                        summary['baseline']['medianSeconds'])
            report['summary'][case] = summary
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding='utf8')
    print(json.dumps(report['summary'], indent=2))


if __name__ == '__main__':
    main()
