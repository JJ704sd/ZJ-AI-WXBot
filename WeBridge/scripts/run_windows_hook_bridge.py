"""Local repeatable text bridge; startup configures the agent but never sends.

Only explicit authenticated POST requests may allocate and submit text. The
trusted workbench server verifies the requested conversation exists in its current
database snapshot and is watched, then freezes that target in a draft; browsers
cannot call this bridge directly. This bridge checks the internal target ID and exact account/process
binding, then durably records each request before any native call. Shutdown pins
the agent before detaching, using the lifecycle verified by the smoke harness.
"""
from __future__ import annotations

import argparse
from contextlib import closing
import hashlib
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import os
from pathlib import Path
import re
import secrets
import sqlite3
import threading
import time

from run_windows_hook_smoke import (NativeSession, SmokeError, CHECKS, CODE_RVAS,
    PROTOCOL, PROFILE, ROOT, RUNTIME, handler_type, public_failure)

SCRIPT = ROOT / 'execution/windows/native_send_text.js'
TEXT_RVAS = {**CODE_RVAS, 'stringAssign': 0x3E150, 'releaseShared': 0x53120}
MAX_TEXT_BYTES, MAX_TEXT_UNITS = 8000, 2000
TARGET_ID = re.compile(r'[A-Za-z0-9_.@-]{1,256}')
GUID = re.compile(r'[0-9a-fA-F]{8}(?:-[0-9a-fA-F]{4}){3}-[0-9a-fA-F]{12}')


def atomic_json(path, value):
    temporary = path.with_name(path.name + '.' + secrets.token_hex(8) + '.tmp')
    with temporary.open('x', encoding='utf-8') as stream:
        json.dump(value, stream, ensure_ascii=False)
        stream.flush()
        os.fsync(stream.fileno())
    os.replace(temporary, path)


class TextNativeSession(NativeSession):
    def __init__(self, runtime_dir=RUNTIME):
        super().__init__(script_path=SCRIPT, runtime_dir=runtime_dir, code_rvas=TEXT_RVAS)

    def construct(self, payload):
        self.native_call_started = True
        result = self._rpc('construct', {'nonce': self.nonce, 'requestId': payload['requestId'],
            'targetId': payload['targetId'], 'text': payload['text']})
        checks = result.get('checks')
        if (result.get('state') != 'constructed' or result.get('sendCalled') is not False or
                result.get('targetId') != payload['targetId'] or
                result.get('submissionAttempted') is not False or not isinstance(checks, dict) or
                set(checks) != CHECKS or any(value is not True for value in checks.values()) or
                not isinstance(result.get('constructionId'), str) or
                not isinstance(result.get('clientMessageId'), str) or not GUID.fullmatch(result['clientMessageId'])):
            self.invalidated = True
            raise SmokeError('native_construction_failed')
        return result

    def submit(self, payload, construction):
        return self._rpc('submit', {'nonce': self.nonce, 'requestId': payload['requestId'],
            'constructionId': construction['constructionId'], 'binding': self.binding,
            'targetId': payload['targetId'], 'text': payload['text'], 'confirmed': True})


class TextBridge:
    def __init__(self, native, directory):
        self.native = native
        self.binding = dict(native.binding)
        self.directory = Path(directory)
        self.directory.mkdir(parents=True, exist_ok=True)
        self.path = self.directory / 'hook-bridge-attempts.sqlite'
        self.lock = threading.Lock()
        with closing(self.connect()) as database:
            database.execute('CREATE TABLE IF NOT EXISTS attempts ('
                'request_id TEXT PRIMARY KEY, request_hash TEXT NOT NULL, response TEXT NOT NULL)')
            database.commit()

    def connect(self):
        database = sqlite3.connect(self.path, timeout=10)
        database.execute('PRAGMA synchronous=FULL')
        return database

    def status(self):
        return {'protocol': PROTOCOL, 'ready': not self.native.detached and not self.native.invalidated,
            'instanceId': self.binding['instanceId'], 'binding': self.binding,
            'capabilities': {'sendText': True, 'idempotency': True},
            'scope': {'targetPolicy': 'selected_conversation', 'maxTextBytes': MAX_TEXT_BYTES, 'maxTextUnits': MAX_TEXT_UNITS},
            'delivered': False}

    def response(self, payload, status, attempted, **extra):
        return {'protocol': PROTOCOL, 'requestId': payload['requestId'], 'textHash': payload['textHash'],
            'targetId': payload['targetId'], 'binding': self.binding, 'status': status,
            'submissionAttempted': attempted, 'delivered': False, 'retryAllowed': False, **extra}

    def validate(self, payload):
        required = {'protocol', 'requestId', 'draftId', 'textHash', 'text', 'targetId', 'expectedBinding'}
        if (not isinstance(payload, dict) or set(payload) != required or payload.get('protocol') != PROTOCOL or
                not isinstance(payload.get('targetId'), str) or not TARGET_ID.fullmatch(payload['targetId']) or
                not isinstance(payload.get('requestId'), str) or
                not re.fullmatch(r'[a-f0-9]{32}', payload['requestId']) or payload.get('draftId') != payload['requestId']):
            raise SmokeError('invalid_request')
        text = payload.get('text')
        if (not isinstance(text, str) or not text.strip() or
                any(ord(char) < 32 and char not in '\n\t' or ord(char) == 127 for char in text)):
            raise SmokeError('invalid_text')
        try:
            encoded = text.encode('utf-8')
            units = len(text.encode('utf-16-le')) // 2
        except UnicodeError:
            raise SmokeError('invalid_text') from None
        if (len(encoded) > MAX_TEXT_BYTES or units > MAX_TEXT_UNITS or
                hashlib.sha256(encoded).hexdigest() != payload.get('textHash')):
            raise SmokeError('invalid_text')

    def send(self, payload):
        self.validate(payload)
        digest = hashlib.sha256(json.dumps(payload, sort_keys=True, separators=(',', ':')).encode()).hexdigest()
        with self.lock, closing(self.connect()) as database:
            database.execute('BEGIN IMMEDIATE')
            previous = database.execute('SELECT request_hash,response FROM attempts WHERE request_id=?',
                                        (payload['requestId'],)).fetchone()
            if previous:
                return json.loads(previous[1]) if previous[0] == digest else self.response(payload, 'not_submitted', False)
            if payload['expectedBinding'] != self.binding:
                return self.response(payload, 'not_submitted', False)
            try:
                self.native.revalidate()
            except Exception:
                return self.response(payload, 'not_submitted', False)
            response = self.response(payload, 'unknown', True)
            database.execute('INSERT INTO attempts VALUES(?,?,?)',
                             (payload['requestId'], digest, json.dumps(response)))
            database.commit()
            try:
                construction = self.native.construct(payload)
                # A native GUID is useful for diagnostics. It is not a server ACK
                # and is not claimed to be present in every local DB schema.
                response['clientMessageId'] = construction['clientMessageId']
                database.execute('UPDATE attempts SET response=? WHERE request_id=?',
                                 (json.dumps(response), payload['requestId']))
                database.commit()  # Preserve correlation before the submit RPC.
                result = self.native.submit(payload, construction)
                if (result.get('state') == 'submitted_unconfirmed' and result.get('submissionAttempted') is True and
                        result.get('nativeReturned') is True and
                        result.get('clientMessageId') == construction['clientMessageId']):
                    response['status'] = 'submitted'
                    if result.get('ready') is not True or result.get('callerReferencesReleased') is not True:
                        self.native.invalidated = True
                else:
                    self.native.invalidated = True
            except Exception:
                self.native.invalidated = True
            database.execute('UPDATE attempts SET response=? WHERE request_id=?',
                             (json.dumps(response), payload['requestId']))
            database.commit()
            return response


class OwnedConfiguration:
    def __init__(self, directory, instance_id, token, port):
        self.directory = Path(directory)
        self.token_name = f'hook-bridge-token-{instance_id}'
        self.profile_name = f'hook-bridge-profiles-{instance_id}.json'
        self.config = {'endpoint': f'http://127.0.0.1:{port}', 'tokenFile': self.token_name,
                       'profilesFile': self.profile_name}
        self.files = {self.token_name: token, self.profile_name: json.dumps([PROFILE])}

    def publish(self):
        for name, content in self.files.items():
            with (self.directory / name).open('x', encoding='utf-8') as stream:
                stream.write(content)
                stream.flush()
                os.fsync(stream.fileno())
        atomic_json(self.directory / 'hook-config.json', self.config)

    def cleanup(self):
        path = self.directory / 'hook-config.json'
        try:
            if json.loads(path.read_text(encoding='utf-8')) == self.config:
                path.unlink()
        except (OSError, ValueError):
            pass
        for name, content in self.files.items():
            path = self.directory / name
            try:
                if path.read_text(encoding='utf-8') == content:
                    path.unlink()
            except OSError:
                pass


def stop_requested(directory, instance_id):
    try:
        return json.loads((directory / 'hook-bridge-stop.json').read_text(encoding='utf-8')).get('instanceId') == instance_id
    except (OSError, ValueError, AttributeError):
        return False


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--serve', action='store_true', required=True)
    parser.add_argument('--runtime-dir', type=Path, default=RUNTIME)
    parser.add_argument('--port', type=int, default=8789)
    parser.add_argument('--instance-id', default=None)
    args = parser.parse_args(argv)
    if not 1024 <= args.port <= 65535:
        parser.error('port must be between 1024 and 65535')
    instance_id = args.instance_id or secrets.token_hex(16)
    if not re.fullmatch(r'[a-f0-9]{32}', instance_id):
        parser.error('invalid instance id')
    directory = args.runtime_dir.resolve()
    directory.mkdir(parents=True, exist_ok=True)
    state_path = directory / 'hook-bridge-state.json'
    state = {'instanceId': instance_id, 'processId': os.getpid(), 'startedAt': time.time(), 'state': 'starting',
             'endpoint': f'http://127.0.0.1:{args.port}', 'issueCode': '', 'sendCalled': False}
    native = server = configuration = None
    stage, failed = 'binding', False
    try:
        # Bind before attaching so a duplicate launch cannot create a second
        # agent in the client. No requests are served before configure completes.
        server = ThreadingHTTPServer(('127.0.0.1', args.port), BaseHTTPRequestHandler)
        server.daemon_threads = False
        server.timeout = 0.25
        atomic_json(state_path, state)
        stage = 'configuring'
        native = TextNativeSession(directory)
        if stop_requested(directory, instance_id):
            return 0
        bridge = TextBridge(native, directory)
        token = secrets.token_urlsafe(32)
        server.RequestHandlerClass = handler_type(bridge, token, args.port, max_request_bytes=32768)
        server.RequestHandlerClass.server_version = 'WeBridgeHook'
        configuration = OwnedConfiguration(directory, instance_id, token, args.port)
        stage = 'publishing'
        configuration.publish()
        state.update(state='ready', nativeInstanceId=native.binding['instanceId'])
        atomic_json(state_path, state)
        print(json.dumps({'ok': True, 'state': 'ready', 'endpoint': state['endpoint'], 'sendCalled': False}), flush=True)
        stage = 'serving'
        while not stop_requested(directory, instance_id) and not native.detached and not native.invalidated:
            server.handle_request()
        return 0
    except KeyboardInterrupt:
        return 0
    except BaseException as error:
        failed = True
        failure = public_failure(error, stage)
        state.update(state='failed', issueCode=failure['issueCode'])
        print(json.dumps(failure), flush=True)
        return 1
    finally:
        if server is not None:
            # Wait for an accepted POST to finish before pinning its script.
            server.server_close()
        if native is not None:
            if not native.close():
                state.update(state='stopping', issueCode='agent_residency_unconfirmed')
                atomic_json(state_path, state)
                native.wait_for_client_exit()
            atomic_json(directory / 'hook-bridge-lifecycle.json', native.lifecycle_report())
        if configuration is not None:
            configuration.cleanup()
        try:
            current = json.loads(state_path.read_text(encoding='utf-8'))
            if current.get('instanceId') == instance_id:
                state.update(state='failed' if failed else 'stopped')
                atomic_json(state_path, state)
        except (OSError, ValueError):
            pass
        if stop_requested(directory, instance_id):
            try:
                (directory / 'hook-bridge-stop.json').unlink()
            except OSError:
                pass


if __name__ == '__main__':
    raise SystemExit(main())
