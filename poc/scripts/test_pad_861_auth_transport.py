"""One bounded generation trial through fixed vendor TLS transport; no firewall changes."""
import hashlib
import argparse
import json
import os
import socket
import subprocess
import threading
import time
from urllib.parse import urlencode
from urllib.request import ProxyHandler, build_opener

from pad_861_auth_relay import running_relay, NoRedirect
from prepare_pad_861_device import prepare
from probe_pad_861_proxy import ROOT, EXE, EXPECTED


def occupied():
    result = []
    for port in (1238, 8098):
        with socket.socket() as sock:
            sock.settimeout(0.2)
            if sock.connect_ex(('127.0.0.1', port)) == 0:
                result.append(port)
    return result


def verify_firewall():
    command = "Get-NetFirewallRule -DisplayName 'Codex-Pad861-Offline-Inbound','Codex-Pad861-Offline-Outbound' | ForEach-Object { [pscustomobject]@{Direction=[string]$_.Direction;Enabled=[string]$_.Enabled;Action=[string]$_.Action;Program=($_ | Get-NetFirewallApplicationFilter).Program} } | ConvertTo-Json -Compress"
    raw = subprocess.check_output(['powershell', '-NoProfile', '-Command', command],
                                  creationflags=subprocess.CREATE_NO_WINDOW, timeout=15)
    rules = json.loads(raw)
    if len(rules) != 2 or {r['Direction'] for r in rules} != {'Inbound', 'Outbound'}:
        raise ValueError('firewall rules missing')
    if any(r['Enabled'] != 'True' or r['Action'] != 'Block' or os.path.normcase(r['Program']) != os.path.normcase(str(EXE)) for r in rules):
        raise ValueError('firewall boundary mismatch')


def main(*, late_response_trial=False, pinned_ip=None):
    if hashlib.sha256(EXE.read_bytes()).hexdigest() != EXPECTED or occupied():
        raise ValueError('build or occupied ports')
    verify_firewall()
    # A durable run guard also prevents repeating trials that stopped before generation.
    prefix = 'auth-late-response' if late_response_trial else 'auth-transport'
    transport = None
    if pinned_ip:
        from pad_861_pinned_transport import pinned_request
        prefix = 'auth-pinned-trial'
        transport = lambda method, path, body: pinned_request(pinned_ip, method, path, body)
    with (ROOT / (prefix + '-run-intent.json')).open('x', encoding='utf-8') as stream:
        json.dump({'trial': prefix, 'automatic_retry': False, 'previous_outcome_unknown': late_response_trial}, stream)
    original = hashlib.sha256((EXE.parent / '.env').read_bytes()).hexdigest()
    report = {'qr_calls': 0, 'message_calls': 0}
    proc = None
    timer = None
    events = []
    try:
        with running_relay(receipt_path=ROOT / (prefix + '-upstream.private.json'), transport=transport) as (base, events):
            env = os.environ.copy()
            env.update(ADMIN_KEY_SERVICE_URL=base, HTTP_PROXY=base, HTTPS_PROXY=base, ALL_PROXY='', NO_PROXY='')
            with (ROOT / (prefix + '.stdout.private.log')).open('wb') as out, (ROOT / (prefix + '.stderr.private.log')).open('wb') as err:
                try:
                    proc = subprocess.Popen([str(EXE)], cwd=EXE.parent, env=env, stdout=out, stderr=err,
                                            creationflags=subprocess.CREATE_NO_WINDOW)
                    timer = threading.Timer(30, lambda: proc.kill() if proc.poll() is None else None)
                    timer.start()
                    deadline = time.monotonic() + 7
                    while 1238 not in occupied():
                        if proc.poll() is not None or time.monotonic() > deadline:
                            raise TimeoutError('gateway readiness')
                        time.sleep(0.1)
                    key = next(line.partition('=')[2].strip() for line in (EXE.parent / '.env').read_text(encoding='utf-8-sig').splitlines() if line.startswith('ADMIN_KEY='))
                    url = 'http://127.0.0.1:1238/admin/GetAllDevices?' + urlencode({'key': key})
                    with build_opener(ProxyHandler({}), NoRedirect()).open(url, timeout=5) as response:
                        inventory = json.loads(response.read(256 * 1024))
                    if inventory.get('Code') != 200 or inventory.get('Data', {}).get('devices') != []:
                        raise ValueError('expected empty inventory')
                    deadline = time.monotonic() + 6
                    while not any(e.get('route') == 'health' and e.get('upstream_status') == 200 for e in events):
                        if time.monotonic() > deadline:
                            raise TimeoutError('real upstream health failed')
                        time.sleep(0.1)
                    time.sleep(0.2)
                    report['generation'] = prepare(ROOT, transport_trial=not late_response_trial and not pinned_ip, late_response_trial=late_response_trial, pinned_trial=bool(pinned_ip))
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
        generation_events = [e for e in events if e.get('route') == 'generate']
        report['upstream_generation_outcome'] = (
            'unknown' if any('error_type' in e for e in generation_events)
            else ('response_received' if any('upstream_status' in e for e in generation_events) else 'not_submitted'))
        report['automatic_retry_allowed'] = False
        report['remaining_listeners'] = occupied()
        report['gateway_stopped'] = proc is None or proc.poll() is not None
        report['config_unchanged'] = hashlib.sha256((EXE.parent / '.env').read_bytes()).hexdigest() == original
        try:
            verify_firewall()
            report['both_firewall_blocks_verified'] = True
        except Exception:
            report['both_firewall_blocks_verified'] = False
        (ROOT / (prefix + '-result.json')).write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
        print(json.dumps(report))
    return 0 if report.get('generation', {}).get('code') == 200 and not report['remaining_listeners'] and report['both_firewall_blocks_verified'] and report['gateway_stopped'] and report['config_unchanged'] else 2


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--late-response-trial', action='store_true')
    parser.add_argument('--pinned-ip')
    args = parser.parse_args()
    if args.pinned_ip and args.late_response_trial:
        parser.error('choose one trial')
    raise SystemExit(main(late_response_trial=args.late_response_trial, pinned_ip=args.pinned_ip))
