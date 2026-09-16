"""Credential-free, bounded TLS health comparison; never starts the gateway."""
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from pathlib import Path
import subprocess
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[1] / '.local' / 'pad-legacy-861'
URL = 'https://adminkeyservice.knowhub.cloud/ping'


def sample(mode, index):
    body_path = ROOT / f'health-matrix-{mode}-{index}.body'
    command = ['curl.exe', '-q', '--silent', '--show-error', '--connect-timeout', '4',
               '--max-time', '8', '--output', str(body_path), '--write-out', '%{json}']
    command += ['--proxy', 'http://127.0.0.1:17891', '--noproxy', ''] if mode == 'proxy' else ['--noproxy', '*']
    command.append(URL)
    result = subprocess.run(command, capture_output=True, timeout=11,
                            creationflags=subprocess.CREATE_NO_WINDOW)
    try:
        data = json.loads(result.stdout)
    except ValueError:
        data = {}
    body = body_path.read_bytes() if body_path.exists() else b''
    try:
        pong = json.loads(body).get('message') == 'pong'
    except (ValueError, AttributeError):
        pong = False
    record = {'mode': mode, 'sample': index, 'exit_code': result.returncode,
              'pong': pong, 'body_sha256': hashlib.sha256(body).hexdigest()}
    for name in ('http_code', 'http_connect', 'remote_ip', 'ssl_verify_result',
                 'time_namelookup', 'time_connect', 'time_appconnect', 'time_starttransfer', 'time_total'):
        record[name] = data.get(name)
    # Do not store arbitrary tool stderr or server content in shared evidence.
    record['success'] = result.returncode == 0 and data.get('http_code') == 200 and pong
    if body_path.exists():
        body_path.unlink()
    return record


def run_mode(mode):
    return [sample(mode, index) for index in range(1, 6)]


def main():
    with ThreadPoolExecutor(max_workers=2) as pool:
        results = list(pool.map(run_mode, ('proxy', 'direct')))
    report = {'timestamp_utc': datetime.now(timezone.utc).isoformat(), 'url': URL,
              'credentials_sent': False, 'generation_calls': 0, 'samples': sum(results, [])}
    for mode in ('proxy', 'direct'):
        rows = [r for r in report['samples'] if r['mode'] == mode]
        report[mode] = {'successes': sum(r['success'] for r in rows), 'attempts': len(rows),
                        'max_seconds': max(r['time_total'] or 0 for r in rows)}
    (ROOT / 'network-matrix-result.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report))


if __name__ == '__main__':
    main()
