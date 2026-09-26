#!/usr/bin/env python3
"""Local protocol lab login helper; never prints raw auth responses or keys."""
import argparse
import json
import os
from pathlib import Path
import secrets
import urllib.error
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
STATE = ROOT / '.secrets/protocol-session.json'
BASE = 'http://127.0.0.1:18081'


def post(path, state, body=None):
    data = json.dumps(body).encode() if body is not None else b''
    req = urllib.request.Request(BASE + path + '?sessionId=' + state['sessionId'], data=data,
                                 headers={'Content-Type': 'application/json'}, method='POST')
    opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
    try:
        with opener.open(req, timeout=55) as response:
            return response.status, response.read()
    except urllib.error.HTTPError as error:
        return error.code, error.read()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command', choices=['qr', 'status', 'authenticate', 'init'])
    args = parser.parse_args()
    if STATE.exists():
        state = json.loads(STATE.read_text())
    elif args.command == 'qr':
        state = {'sessionId': secrets.token_hex(16), 'deviceId': 'W' + secrets.token_hex(8)}
        STATE.parent.mkdir(mode=0o700, exist_ok=True)
        STATE.write_text(json.dumps(state))
        os.chmod(STATE, 0o600)
    else:
        raise SystemExit('Create a QR session first')
    if args.command == 'qr':
        if state.get('authenticated'):
            raise SystemExit('Already authenticated; refusing to replace session')
        code, data = post('/v1/login/getloginqrcode', state, {'deviceId': state['deviceId'], 'deviceType': 'Windows 10 x64', 'deviceName': 'SelfHostedProtocolLab'})
        if code != 200 or not data.startswith(b'\x89PNG\r\n\x1a\n'):
            raise SystemExit('QR request failed, HTTP ' + str(code))
        path = ROOT / '.runtime/protocol-login-qr.png'
        path.parent.mkdir(mode=0o700, exist_ok=True)
        path.write_bytes(data)
        os.chmod(path, 0o600)
        print(json.dumps({'http': code, 'qrPath': str(path), 'bytes': len(data)}))
        return
    endpoint = {'status': '/v1/login/checkloginqrcode', 'authenticate': '/v1/login/secmanualauth', 'init': '/v1/message/newinit'}[args.command]
    code, data = post(endpoint, state)
    try:
        value = json.loads(data)
    except ValueError:
        raise SystemExit('Non-JSON response, HTTP ' + str(code))
    # Upstream status/auth responses contain credentials; whitelist display fields.
    result = {'http': code}
    if args.command == 'status':
        result.update({k: value[k] for k in ['status', 'expiredTime'] if k in value})
    else:
        base = value.get('baseResponse', {})
        result['ret'] = base.get('ret')
        result['message'] = base.get('errMsg', {}).get('string')
        if args.command == 'authenticate':
            result['authSectionFlag'] = value.get('unifyAuthSectFlag')
            if result['ret'] == 0 and (result['authSectionFlag'] or 0) > 0:
                state['authenticated'] = True
                STATE.write_text(json.dumps(state))
                os.chmod(STATE, 0o600)
        else:
            result['cmdCount'] = value.get('cmdCount')
            result['continueFlag'] = value.get('continueFlag')
    if code != 200:
        # Known local errors are sanitized; never emit arbitrary payloads.
        result['error'] = 'request_failed'
        if value.get('error') == 'qrcode time out':
            result['error'] = 'qr_expired_or_server_rejected'
    print(json.dumps(result, ensure_ascii=False))


if __name__ == '__main__':
    main()
