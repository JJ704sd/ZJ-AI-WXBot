"""Synthetic HTTP/native contract tests; never load or contact WeChat."""
from contextlib import closing
from copy import deepcopy
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
from pathlib import Path
import sqlite3
import tempfile
import threading
import unittest
from unittest.mock import patch

from windows_hook_sender import HookSendError, LoopbackTransport, PROTOCOL, WindowsHookSender


class HookTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='webridge-hook-synthetic-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.now = 1000
        self.profile = {'clientVersion': '4.1.15.13', 'arch': 'x64', 'moduleName': 'Weixin.dll', 'moduleSha256': 'a' * 64}
        self.source = {'account': 'database:synthetic', 'sourceId': 'database:synthetic', 'selfId': 'wxid_synthetic',
                       'sourceRoot': str(self.root / 'synthetic-account')}
        self.native = {**self.profile, 'pid': 123, 'processStarted': '134019987654321000',
                       'selfId': self.source['selfId'], 'sourceRoot': self.source['sourceRoot']}
        self.instance = 'synthetic-bridge-instance-1'
        self.calls, self.outcome = [], 'server_accepted'
        self.scope = {'targetId': 'filehelper'}
        self.sender = WindowsHookSender(self.root, transport=self.transport, profiles=[self.profile], clock=lambda: self.now)
        self.data = {**self.source, 'targetId': 'filehelper', 'targetName': '文件传输助手',
                     'text': 'synthetic 中文 🙂\n第二行', 'idempotencyKey': 'synthetic-hook-request-001'}

    def transport(self, method, path, payload=None):
        self.calls.append((method, path, deepcopy(payload)))
        if method == 'GET':
            return {'protocol': PROTOCOL, 'ready': True, 'instanceId': self.instance,
                    'capabilities': {'sendText': True, 'idempotency': True}, 'binding': deepcopy(self.native),
                    **({'scope': deepcopy(self.scope)} if self.scope is not None else {})}
        if isinstance(self.outcome, BaseException):
            raise self.outcome
        response = {key: payload[key] for key in ('protocol', 'requestId', 'textHash', 'targetId')}
        return {**response, 'binding': payload['expectedBinding'], 'status': self.outcome,
                'serverId': '123456789012345678', 'submissionAttempted': self.outcome != 'not_submitted'}

    def confirm_data(self, draft):
        return {**self.source, 'draftId': draft['draftId'], 'textHash': draft['textHash'], 'targetConfirmed': True}

    def test_real_contract_preflight_once_and_restart_idempotency(self):
        draft = self.sender.prepare(self.data)
        self.assertEqual(self.sender.prepare(self.data), draft)
        self.assertEqual([call[0] for call in self.calls], ['GET'])
        result = self.sender.confirm(self.confirm_data(draft))
        self.assertEqual(result['status'], 'server_accepted')
        self.assertTrue(result['serverAccepted'])
        self.assertFalse(result['localRecordConfirmed'])
        self.assertFalse(result['delivered'])
        self.assertEqual([call[0] for call in self.calls], ['GET', 'GET', 'POST'])
        self.sender = WindowsHookSender(self.root, transport=self.transport, profiles=[self.profile])
        self.assertEqual(self.sender.confirm(self.confirm_data(draft)), result)
        self.assertEqual(len(self.calls), 3)

    def test_empty_profiles_are_unsupported_even_when_bridge_claims_ready(self):
        self.sender.profiles = ()
        status = self.sender.status(self.source)
        self.assertFalse(status['available'])
        self.assertEqual(status['issueCode'], 'unsupported_version')
        self.assertEqual(status['moduleSha256'], 'a' * 64)
        with self.assertRaises(HookSendError):
            self.sender.prepare(self.data)
        self.assertFalse(any(call[0] == 'POST' for call in self.calls))

    def test_conversation_scope_preserves_target_and_old_bridge_stays_filehelper_only(self):
        group = {**self.data, 'targetId': '123456789012345@chatroom', 'targetName': '合成测试群'}
        for scope in (None, {'targetId': 'filehelper'}):
            self.scope = scope
            with self.assertRaises(HookSendError) as error:
                self.sender.prepare(group)
            self.assertEqual(error.exception.code, 'unsupported_target')
        self.scope = {'targetPolicy': 'selected_conversation'}
        draft = self.sender.prepare(group)
        self.assertEqual(self.sender.confirm(self.confirm_data(draft))['targetId'], group['targetId'])
        posts = [call[2] for call in self.calls if call[0] == 'POST']
        self.assertEqual(len(posts), 1)
        self.assertEqual(posts[0]['targetId'], group['targetId'])

    def test_scope_contraction_after_prepare_blocks_confirm(self):
        self.scope = {'targetPolicy': 'selected_conversation'}
        draft = self.sender.prepare({**self.data, 'targetId': '123456789012345@chatroom'})
        self.scope = {'targetId': 'filehelper'}
        result = self.sender.confirm(self.confirm_data(draft))
        self.assertEqual((result['status'], result['issueCode']), ('blocked', 'unsupported_target'))
        self.assertFalse(any(call[0] == 'POST' for call in self.calls))

    def test_status_without_source_cannot_claim_send_available(self):
        self.assertTrue(self.sender.status(self.source)['available'])
        self.assertFalse(self.sender.status()['available'])
        self.assertEqual(self.sender.status({**self.source, 'selfId': 'other'})['issueCode'], 'source_changed')

    def test_each_native_identity_component_is_frozen_before_post(self):
        draft = self.sender.prepare(self.data)
        changes = {'pid': 456, 'processStarted': '134019987654321001', 'selfId': 'another',
                   'sourceRoot': str(self.root / 'another'), 'clientVersion': '4.1.16.1',
                   'moduleSha256': 'b' * 64, 'arch': 'x86', 'moduleName': 'WeChatWin.dll'}
        for key, value in changes.items():
            with self.subTest(key=key):
                original = self.native[key]
                self.native[key] = value
                result = self.sender.confirm(self.confirm_data(draft))
                self.assertEqual(result['status'], 'blocked')
                self.native[key] = original
                with closing(sqlite3.connect(self.sender.path)) as db:
                    db.execute("UPDATE hook_drafts SET status='prepared' WHERE id=?", (draft['draftId'],)); db.commit()
        self.instance += '-restarted'
        self.assertEqual(self.sender.confirm(self.confirm_data(draft))['issueCode'], 'binding_changed')
        self.assertFalse(any(call[0] == 'POST' for call in self.calls))

    def test_changed_source_cannot_prepare_reuse_get_confirm_or_reconcile(self):
        draft = self.sender.prepare(self.data)
        for key, value in {'account': 'other', 'selfId': 'other', 'sourceRoot': str(self.root / 'other')}.items():
            with self.subTest(key=key):
                changed = {**self.source, key: value}
                with self.assertRaises(HookSendError): self.sender.get(draft['draftId'], changed)
                with self.assertRaises(HookSendError): self.sender.confirm({**self.confirm_data(draft), **changed})
                with self.assertRaises(HookSendError): self.sender.reconcile(draft['draftId'], [], changed, target_id='filehelper')
        with self.assertRaises(HookSendError): self.sender.get(draft['draftId'])
        with self.assertRaises(HookSendError): self.sender.prepare({**self.data, 'text': 'changed'})
        self.assertEqual(len(self.calls), 1)

    def test_expiry_target_and_text_mismatch_do_not_post(self):
        draft = self.sender.prepare(self.data)
        for changes in ({'targetConfirmed': False}, {'targetId': 'someone'}, {'textHash': 'wrong'}, {'text': 'wrong'}):
            with self.assertRaises(HookSendError): self.sender.confirm({**self.confirm_data(draft), **changes})
        self.now += 120
        self.assertEqual(self.sender.confirm(self.confirm_data(draft))['status'], 'expired')
        self.assertEqual(len(self.calls), 1)

    def test_post_timeout_and_interruption_are_not_retried(self):
        draft = self.sender.prepare(self.data)
        self.outcome = TimeoutError('sensitive native detail TOKEN')
        result = self.sender.confirm(self.confirm_data(draft))
        self.assertEqual(result['status'], 'unknown')
        self.assertNotIn('TOKEN', json.dumps(result))
        self.sender.confirm(self.confirm_data(draft))
        self.assertEqual(sum(call[0] == 'POST' for call in self.calls), 1)
        second = self.sender.prepare({**self.data, 'idempotencyKey': 'synthetic-hook-request-002'})
        self.outcome = KeyboardInterrupt()
        with self.assertRaises(KeyboardInterrupt): self.sender.confirm(self.confirm_data(second))
        restarted = WindowsHookSender(self.root, transport=self.transport, profiles=[self.profile])
        self.assertEqual(restarted.confirm(self.confirm_data(second))['status'], 'unknown')
        self.assertEqual(sum(call[0] == 'POST' for call in self.calls), 2)

    def test_malformed_or_wrong_ack_never_proves_accepted(self):
        original = self.transport
        wrong = ({'requestId': 'other'}, {'targetId': 'other'}, {'textHash': 'other'}, {'protocol': 'other'},
                 {'binding': None}, {'serverId': '0'}, {'serverId': 123}, {'status': 'delivered'})
        for index, change in enumerate(wrong):
            with self.subTest(change=change):
                def transport(method, path, payload=None):
                    response = original(method, path, payload)
                    return {**response, **change} if method == 'POST' else response
                self.sender.transport = transport
                draft = self.sender.prepare({**self.data, 'idempotencyKey': 'synthetic-ack-case-%03d' % index})
                result = self.sender.confirm(self.confirm_data(draft))
                self.assertEqual(result['status'], 'unknown')
                self.assertFalse(result['serverAccepted'])

    def test_submitted_and_proven_not_submitted_are_distinct(self):
        for index, (native, expected) in enumerate((('submitted', 'submitted_unconfirmed'), ('not_submitted', 'blocked'))):
            self.outcome = native
            draft = self.sender.prepare({**self.data, 'idempotencyKey': 'synthetic-stage-case-%03d' % index})
            self.assertEqual(self.sender.confirm(self.confirm_data(draft))['status'], expected)

    def test_database_confirmation_needs_exact_source_sender_id_target_and_text(self):
        draft = self.sender.prepare(self.data)
        result = self.sender.confirm(self.confirm_data(draft))
        message = {'serverId': result['serverId'], 'senderId': self.source['selfId'], 'sourceId': self.source['sourceId'],
                   'source': 'database', 'isSelfKnown': True, 'isSelf': True, 'type': 1, 'text': self.data['text'], 'kind': 'text'}
        for key, value in {'serverId': '99', 'sourceId': 'another', 'senderId': 'another', 'isSelfKnown': False,
                           'isSelf': False, 'type': 47, 'text': 'different', 'kind': 'revoke', 'source': 'mock'}.items():
            outcome = self.sender.reconcile(draft['draftId'], [{**message, key: value}], self.source, target_id='filehelper')
            self.assertEqual(outcome['status'], 'server_accepted', key)
        with self.assertRaises(HookSendError):
            self.sender.reconcile(draft['draftId'], [message], self.source, target_id='someone')
        outcome = self.sender.reconcile(draft['draftId'], [message], self.source, target_id='filehelper')
        self.assertTrue(outcome['localRecordConfirmed'])
        self.assertFalse(outcome['delivered'])

    def test_invalid_requests_do_not_contact_bridge(self):
        for change in ({'text': '\ud800'}, {'text': '\0'}, {'sourceRoot': 'relative'}, {'mentionIds': ['someone']},
                       {'targetId': ''}, {'idempotencyKey': 'short'}):
            with self.assertRaises(HookSendError): self.sender.prepare({**self.data, **change})
        self.assertEqual(self.calls, [])

    def test_new_self_record_observation_and_repeat_send_do_not_claim_server_ack(self):
        self.outcome = 'submitted'
        def message(identity, server_id, timestamp=1000):
            return {'id': identity, 'serverId': server_id, 'timestamp': timestamp,
                    'senderId': self.source['selfId'], 'sourceId': self.source['sourceId'],
                    'source': 'database', 'isSelfKnown': True, 'isSelf': True, 'type': 1,
                    'text': self.data['text'], 'kind': 'text', 'decodeStatus': 'ok'}
        old, first, second = message('old', '10', 999), message('first', '11'), message('second', '12')
        draft = self.sender.prepare(self.data)
        self.sender.confirm(self.confirm_data(draft), baseline_messages=[old])
        lookup = lambda rows: self.sender.reconcile(draft['draftId'], rows, self.source, target_id='filehelper')
        self.assertEqual(lookup([old])['status'], 'submitted_unconfirmed')
        self.assertEqual(lookup([old, first, second])['status'], 'submitted_unconfirmed')
        result = lookup([old, first])
        self.assertEqual(result['status'], 'local_record_observed')
        self.assertTrue(result['localRecordObserved'])
        self.assertFalse(result['localRecordConfirmed'])
        self.assertFalse(result['serverAccepted'])
        self.assertFalse(result['delivered'])
        self.assertNotIn('baselineMessageIds', result)
        draft = self.sender.prepare({**self.data, 'idempotencyKey': 'synthetic-repeat-text-002'})
        self.sender.confirm(self.confirm_data(draft), baseline_messages=[old])
        self.assertEqual(lookup([old, first])['status'], 'submitted_unconfirmed')
        self.assertEqual(lookup([old, first, second])['serverId'], '12')

    def test_native_lock_prevents_overlapping_different_requests(self):
        entered, release = threading.Event(), threading.Event()
        original = self.transport
        def transport(method, path, payload=None):
            if method == 'POST':
                entered.set()
                release.wait(3)
            return original(method, path, payload)
        self.sender.transport = transport
        first = self.sender.prepare(self.data)
        second = self.sender.prepare({**self.data, 'idempotencyKey': 'synthetic-hook-request-002'})
        results = []
        thread = threading.Thread(target=lambda: results.append(self.sender.confirm(self.confirm_data(first))))
        thread.start()
        try:
            self.assertTrue(entered.wait(2))
            with self.assertRaisesRegex(HookSendError, '正在进行'):
                self.sender.confirm(self.confirm_data(second))
        finally:
            release.set(); thread.join(3)
        self.assertEqual(len(results), 1)
        self.assertEqual(sum(call[0] == 'POST' for call in self.calls), 1)

    def test_loopback_url_validation_and_config_fail_closed(self):
        for url in ('https://127.0.0.1:1', 'http://example.com:1', 'http://127.0.0.1:1/path',
                    'http://user:pass@127.0.0.1:1', 'http://192.168.1.2:1', 'http://localhost:1',
                    'http://127.0.0.1:1?token=secret'):
            with self.assertRaises(HookSendError): LoopbackTransport(url, 'a' * 32)
        LoopbackTransport('http://[::1]:1234', 'a' * 32)
        config = self.root / 'hook-config.json'
        missing = WindowsHookSender.from_config(self.root / 'config-test', config)
        self.assertEqual(missing.status(self.source)['issueCode'], 'bridge_not_configured')
        config.write_text('{"token":"PRIVATE"}', encoding='utf-8')
        invalid = WindowsHookSender.from_config(self.root / 'config-test', config)
        result = invalid.status(self.source)
        self.assertEqual(result['issueCode'], 'bridge_config_invalid')
        self.assertNotIn('PRIVATE', json.dumps(result))

    def test_actual_loopback_http_roundtrip_config_and_redirect_refusal(self):
        testcase = self
        seen = []
        class Handler(BaseHTTPRequestHandler):
            def log_message(self, *args): pass
            def do_GET(self):
                seen.append(('GET', self.path, self.headers.get('Authorization')))
                if self.path == '/redirect':
                    self.send_response(302); self.send_header('Location', '/v1/status'); self.end_headers(); return
                self.respond(testcase.transport('GET', self.path))
            def do_POST(self):
                body = json.loads(self.rfile.read(int(self.headers['Content-Length'])))
                seen.append(('POST', self.path, self.headers.get('Authorization')))
                self.respond(testcase.transport('POST', self.path, body))
            def respond(self, data):
                body = json.dumps(data).encode('utf-8')
                self.send_response(200); self.send_header('Content-Type', 'application/json')
                self.send_header('Content-Length', str(len(body))); self.end_headers(); self.wfile.write(body)
        server = ThreadingHTTPServer(('127.0.0.1', 0), Handler)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        self.addCleanup(server.server_close)
        self.addCleanup(server.shutdown)
        endpoint = 'http://127.0.0.1:%d' % server.server_port
        (self.root / 'hook-token').write_text('a' * 32, encoding='ascii')
        (self.root / 'profiles.json').write_text(json.dumps([self.profile]), encoding='utf-8')
        config = self.root / 'hook-config.json'
        config.write_text(json.dumps({'endpoint': endpoint, 'tokenFile': 'hook-token', 'profilesFile': 'profiles.json'}), encoding='utf-8')
        client = WindowsHookSender.from_config(self.root / 'http-test', config)
        self.assertTrue(client.status(self.source)['available'])
        draft = client.prepare(self.data)
        result = client.confirm(self.confirm_data(draft))
        self.assertEqual(result['status'], 'server_accepted')
        self.assertEqual(client.confirm(self.confirm_data(draft)), result)
        restarted = WindowsHookSender.from_config(self.root / 'http-test', config)
        self.assertEqual(restarted.confirm(self.confirm_data(draft)), result)
        self.assertEqual(sum(row[0] == 'POST' for row in seen), 1)
        self.assertTrue(all(row[2] == 'Bearer ' + 'a' * 32 for row in seen))
        transport = LoopbackTransport(endpoint, 'a' * 32)
        before = len(seen)
        with self.assertRaises(HookSendError): transport('GET', '/redirect')
        self.assertEqual(len(seen), before + 1)

        # Simulate process interruption after a real POST returned. The durable
        # attempted row must survive and prohibit another native invocation.
        crash_draft = client.prepare({**self.data, 'idempotencyKey': 'synthetic-real-http-crash'})
        actual = client.transport
        def interrupted(method, path, payload=None):
            result = actual(method, path, payload)
            if method == 'POST':
                raise KeyboardInterrupt()
            return result
        client.transport = interrupted
        with self.assertRaises(KeyboardInterrupt): client.confirm(self.confirm_data(crash_draft))
        restarted = WindowsHookSender.from_config(self.root / 'http-test', config)
        self.assertEqual(restarted.confirm(self.confirm_data(crash_draft))['status'], 'unknown')
        self.assertEqual(sum(row[0] == 'POST' for row in seen), 2)

    def test_real_socket_timeout_is_unknown_and_never_posted_again(self):
        testcase = self
        posted, release = threading.Event(), threading.Event()
        counts = []
        class Handler(BaseHTTPRequestHandler):
            def log_message(self, *args): pass
            def do_GET(self):
                body = json.dumps(testcase.transport('GET', self.path)).encode('utf-8')
                self.send_response(200); self.send_header('Content-Type', 'application/json')
                self.send_header('Content-Length', str(len(body))); self.end_headers(); self.wfile.write(body)
            def do_POST(self):
                self.rfile.read(int(self.headers['Content-Length']))
                counts.append(1); posted.set()
                release.wait(3)  # synthetic bridge deliberately loses its ACK
        server = ThreadingHTTPServer(('127.0.0.1', 0), Handler)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        self.addCleanup(server.server_close)
        self.addCleanup(server.shutdown)
        self.addCleanup(release.set)
        client = WindowsHookSender(self.root / 'http-timeout', endpoint='http://127.0.0.1:%d' % server.server_port,
                                   token='a' * 32, profiles=[self.profile], clock=lambda: self.now)
        draft = client.prepare(self.data)
        with patch('windows_hook_sender.SEND_TIMEOUT', 0.05):
            result = client.confirm(self.confirm_data(draft))
        self.assertTrue(posted.is_set())
        self.assertEqual(result['status'], 'unknown')
        self.assertEqual(client.confirm(self.confirm_data(draft)), result)
        self.assertEqual(counts, [1])


if __name__ == '__main__':
    unittest.main()
