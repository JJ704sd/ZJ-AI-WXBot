"""Read-only inventory reconciliation. Generation routes remain denied."""
import hashlib
import json
import os
import subprocess
import threading
import time
from urllib.parse import urlencode
from urllib.request import ProxyHandler, build_opener

from pad_861_auth_relay import running_relay, NoRedirect
from probe_pad_861_proxy import ROOT, EXE, EXPECTED
from test_pad_861_auth_transport import verify_firewall, occupied


def main():
    if hashlib.sha256(EXE.read_bytes()).hexdigest() != EXPECTED or occupied():
        raise ValueError('build or occupied ports')
    verify_firewall()
    original = hashlib.sha256((EXE.parent / '.env').read_bytes()).hexdigest()
    report = {'generation_calls': 0, 'qr_calls': 0, 'message_calls': 0}
    proc = None
    timer = None
    events = []
    try:
        with running_relay(mode='reconcile') as (base, events):
            env = os.environ.copy()
            env.update(ADMIN_KEY_SERVICE_URL=base, HTTP_PROXY=base, HTTPS_PROXY=base, ALL_PROXY='', NO_PROXY='')
            with (ROOT / 'reconcile.stdout.private.log').open('wb') as out, (ROOT / 'reconcile.stderr.private.log').open('wb') as err:
                try:
                    proc = subprocess.Popen([str(EXE)], cwd=EXE.parent, env=env, stdout=out, stderr=err,
                                            creationflags=subprocess.CREATE_NO_WINDOW)
                    timer = threading.Timer(30, lambda: proc.kill() if proc.poll() is None else None)
                    timer.start()
                    deadline = time.monotonic() + 7
                    while 1238 not in occupied():
                        if proc.poll() is not None or time.monotonic() > deadline:
                            raise TimeoutError('readiness')
                        time.sleep(0.1)
                    key = next(line.partition('=')[2].strip() for line in (EXE.parent / '.env').read_text(encoding='utf-8-sig').splitlines() if line.startswith('ADMIN_KEY='))
                    url = 'http://127.0.0.1:1238/admin/GetAllDevices?' + urlencode({'key': key})
                    report['inventories'] = []
                    for index in range(2):
                        with build_opener(ProxyHandler({}), NoRedirect()).open(url, timeout=12) as response:
                            raw = response.read(256 * 1024 + 1)
                            if len(raw) > 256 * 1024:
                                raise ValueError('oversized inventory')
                        (ROOT / f'reconcile-inventory-{index}.private.json').write_bytes(raw)
                        inventory = json.loads(raw)
                        devices = inventory.get('Data', {}).get('devices')
                        report['inventories'].append({'code': inventory.get('Code'), 'device_count': len(devices) if isinstance(devices, list) else None})
                        if index == 0:
                            time.sleep(3)
                finally:
                    if proc is not None and proc.poll() is None:
                        proc.terminate()
                        proc.wait(timeout=5)
                    if timer is not None:
                        timer.cancel()
    except Exception as error:
        report['error_type'] = type(error).__name__
    finally:
        report['transport_events'] = events
        report['upstream_inventory_observed'] = any(e.get('route') == 'reconcile' and 'upstream_status' in e for e in events)
        report['remaining_listeners'] = occupied()
        report['gateway_stopped'] = proc is None or proc.poll() is not None
        report['config_unchanged'] = hashlib.sha256((EXE.parent / '.env').read_bytes()).hexdigest() == original
        try:
            verify_firewall()
            report['both_firewall_blocks_verified'] = True
        except Exception:
            report['both_firewall_blocks_verified'] = False
        (ROOT / 'reconcile-result.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
        print(json.dumps(report))


if __name__ == '__main__':
    main()
