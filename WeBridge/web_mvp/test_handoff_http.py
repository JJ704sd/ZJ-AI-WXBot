"""HTTP human queue contracts over invented snapshots; no native sends."""
from contextlib import closing
import http.client
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import tempfile
import threading
import unittest
from unittest.mock import Mock, patch
from urllib.parse import urlencode

from server import LoginFlow, make_handler
from test_database_adapter import MIXED
from test_windows_inbound import InboundFixture


class HandoffHttpTests(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory(prefix='webridge-synthetic-handoff-http-')
        self.addCleanup(directory.cleanup)
        self.f = InboundFixture(directory.name)
        self.f.engine.windows_auto_reply = self.f.service
        self.manager = Mock()
        self.manager.status.return_value = {'state': 'stopped'}
        self.server = ThreadingHTTPServer(('127.0.0.1', 0), BaseHTTPRequestHandler)
        self.port = self.server.server_port
        self.server.RequestHandlerClass = make_handler(self.f.engine, LoginFlow(self.f.engine),
            'test-csrf', self.port, database_service=self.f.source,
            hook_sender=self.f.sender, hook_manager=self.manager)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()
        self.addCleanup(self.stop_server)

    def stop_server(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(timeout=5)
        self.assertFalse(self.thread.is_alive())

    def request(self, method, path, payload=None, **overrides):
        headers = {'Origin': f'http://127.0.0.1:{self.port}', 'Content-Type': 'application/json',
                   'X-CSRF-Token': 'test-csrf'}
        headers.update(overrides)
        with closing(http.client.HTTPConnection('127.0.0.1', self.port, timeout=5)) as connection:
            connection.request(method, path, json.dumps(payload) if payload is not None else None, headers)
            response = connection.getresponse()
            data = response.read()
            if 'application/json' in response.getheader('Content-Type', ''):
                data = json.loads(data)
            return response.status, data

    def get(self, path='/api/handoffs', **params):
        return self.request('GET', path+'?'+urlencode({'account': self.f.account, **params}))

    def action(self, **params):
        return self.request('POST', '/api/handoffs/action',
            {'account': self.f.account, 'id': 'event-1', 'version': 1,
             'action': 'claim', 'owner': '负责人', **params})

    def enqueue(self, event='event-1', *, group=None, account=None, created=None):
        f = self.f
        trigger = {'messageId': 'message-1', 'serverId': '9001', 'senderId': 'synthetic-sender',
            'senderName': '合成联系人', 'timestamp': f.now, 'text': '请人工核实报价', 'textTruncated': False}
        with closing(f.service._db()) as db, db:
            f.service.handoffs.enqueue(db, event, account or f.account, group or f.group,
                '合成业务群', trigger, f.now if created is None else created)

    def test_list_filters_and_pagination_keep_scope_before_limit(self):
        self.enqueue('old', created=1)
        self.enqueue('new', created=2)
        self.enqueue('unwatched', group=MIXED, created=3)
        self.enqueue('other-account', account='database:another-source', created=4)
        code, page = self.get(limit=1, status='pending', groupId=self.f.group)
        self.assertEqual(code, 200)
        self.assertEqual([row['id'] for row in page['records']], ['new'])
        self.assertTrue(page['hasMore'])
        code, tail = self.get(limit=1, status='pending', groupId=self.f.group, cursor=page['nextCursor'])
        self.assertEqual(code, 200)
        self.assertEqual([row['id'] for row in tail['records']], ['old'])
        self.assertFalse(tail['hasMore'])
        for params in ({'account': 'wrong'}, {'groupId': MIXED}, {'status': 'wrong'},
                       {'limit': 201}, {'limit': '01'}, {'cursor': 'bad-cursor'},
                       {'cursor': page['nextCursor'], 'limit': 1, 'status': 'all'}):
            with self.subTest(params=params):
                self.assertEqual(self.get(**params)[0], 400)
        self.assertNotIn(str(self.f.root), json.dumps(page))
        self.assertEqual(self.f.posts, [])

    def test_actions_detail_and_conflict_are_explicit_without_sends(self):
        self.enqueue()
        code, claimed = self.action(note='核对中')
        self.assertEqual(code, 200)
        self.assertEqual((claimed['status'], claimed['version'], claimed['owner']), ('in_progress', 2, '负责人'))
        code, conflict = self.action(owner='另一个负责人')
        self.assertEqual(code, 409)
        self.assertEqual(conflict['code'], 'handoff_conflict')
        self.assertIn('error', conflict)
        code, detail = self.get('/api/handoffs/detail', id='event-1')
        self.assertEqual(code, 200)
        self.assertEqual(detail['record'], claimed)
        self.assertEqual([row['action'] for row in detail['changes']], ['claim', 'created'])
        code, completed = self.action(version=2, action='complete', note='核对完成')
        self.assertEqual(code, 200)
        self.assertEqual(completed['status'], 'completed')
        self.assertEqual(self.get()[1]['records'], [])
        self.assertEqual(self.get(status='completed')[1]['records'][0], completed)
        self.assertFalse(self.f.service.get(self.f.account, self.f.group)['enabled'])
        self.assertEqual(self.f.posts, [])

    def test_http_guards_and_task_scope_reject_without_mutations(self):
        self.enqueue()
        payload = {'account': self.f.account, 'id': 'event-1', 'version': 1, 'action': 'claim', 'owner': '负责人'}
        for headers in ({'Host': 'untrusted.invalid'}, {'Origin': 'http://untrusted.invalid'},
                        {'X-CSRF-Token': ''}, {'Sec-Fetch-Site': 'cross-site'}):
            with self.subTest(headers=headers):
                self.assertEqual(self.request('POST', '/api/handoffs/action', payload, **headers)[0], 403)
        for headers in ({'Host': 'untrusted.invalid'}, {'Sec-Fetch-Site': 'cross-site'}):
            self.assertEqual(self.request('GET', '/api/handoffs?account='+self.f.account, **headers)[0], 403)
        for params in ({'account': 'wrong'}, {'version': True}, {'version': '1'}, {'owner': ''},
                       {'owner': 'line\nbreak'}, {'note': 'x'*2001}, {'id': ''}, {'action': 'send'}):
            with self.subTest(params=params):
                self.assertEqual(self.action(**params)[0], 400)
        self.assertEqual(self.get()[1]['records'][0]['version'], 1)
        self.f.engine.set_watched(self.f.account, [])
        self.assertEqual(self.get()[1]['records'], [])
        self.assertEqual(self.get('/api/handoffs/detail', id='event-1')[0], 400)
        self.assertEqual(self.action()[0], 400)
        self.assertEqual(self.f.posts, [])

    def test_rule_mode_survives_old_http_client_and_hook_stop(self):
        payload = {'account': self.f.account, 'groupId': self.f.group, 'enabled': True,
                   'text': '', 'cooldown': 30, 'mode': 'handoff'}
        with patch.object(self.f.service, 'sender_factory', side_effect=AssertionError('handoff must not prepare native sending')):
            code, rule = self.request('POST', '/api/reply', payload)
            self.assertEqual(code, 200)
            self.assertEqual(rule['mode'], 'handoff')
            payload.pop('mode')
            self.assertEqual(self.request('POST', '/api/reply', payload)[1]['mode'], 'handoff')
            self.assertEqual(self.request('POST', '/api/windows/hook/stop', {'account': self.f.account})[0], 200)
        current = self.f.service.get(self.f.account, self.f.group)
        self.assertTrue(current['enabled'])
        self.assertEqual(current['mode'], 'handoff')
        self.manager.stop.assert_called_once_with()
        self.assertEqual(self.f.posts, [])


if __name__ == '__main__':
    unittest.main()
