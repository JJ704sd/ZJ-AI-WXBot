"""Windows regression and isolated demo coverage without a running WeChat client."""
from datetime import timedelta
import http.client
from http.server import ThreadingHTTPServer
import importlib.util
import json
from pathlib import Path
import sqlite3
import tempfile
import threading
import time
import unittest
from unittest.mock import patch
from zoneinfo import ZoneInfoNotFoundError

import backend
from backend import Engine, Store
from demo_backend import DemoAdapter, prepare_demo
from media_host import MediaCache
from runtime_support import ProcessLock, environment_report, runtime_summary
from test_backend import FakeAdapter
from server import LoginFlow, make_handler


class RuntimeTests(unittest.TestCase):
    def test_live_capability_is_not_reported_as_connected_until_account_and_bridge_are_ready(self):
        with tempfile.TemporaryDirectory() as directory:
            engine = Engine(Store(Path(directory) / 'state.sqlite'), FakeAdapter())
            offline = runtime_summary(engine)
            self.assertTrue(offline['capabilities']['supportsLiveSend'])
            self.assertFalse(offline['capabilities']['liveSend'])
            self.assertFalse(offline['connected'])
            engine.refresh_connection()
            self.assertTrue(runtime_summary(engine)['capabilities']['liveSend'])
            engine.logging_out = True
            self.assertFalse(runtime_summary(engine)['capabilities']['liveSend'])
            self.assertFalse(runtime_summary(engine)['connected'])

    def test_store_closes_connections_after_commit_and_rollback(self):
        with tempfile.TemporaryDirectory() as directory:
            store = Store(Path(directory) / 'state.sqlite')
            with store.connect() as connection:
                connection.execute('CREATE TABLE closing_test(value INTEGER)')
                connection.execute('INSERT INTO closing_test VALUES(1)')
            with self.assertRaises(sqlite3.ProgrammingError):
                connection.execute('SELECT 1')
            with self.assertRaisesRegex(ValueError, 'rollback'):
                with store.connect() as failed:
                    failed.execute('INSERT INTO closing_test VALUES(2)')
                    raise ValueError('rollback')
            with self.assertRaises(sqlite3.ProgrammingError):
                failed.execute('SELECT 1')
            self.assertEqual(store.rows('SELECT value FROM closing_test'), [{'value': 1}])

    def test_lock_excludes_second_owner_and_releases_on_exit(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'server.lock'
            with ProcessLock(path):
                with self.assertRaises(RuntimeError):
                    with ProcessLock(path):
                        self.fail('Second process lock was acquired')
            with ProcessLock(path):
                pass

    def test_no_iana_database_falls_back_to_current_china_offset(self):
        spec = importlib.util.spec_from_file_location('backend_without_tzdata', backend.__file__)
        module = importlib.util.module_from_spec(spec)
        with patch('zoneinfo.ZoneInfo', side_effect=ZoneInfoNotFoundError('Asia/Shanghai')):
            spec.loader.exec_module(module)
        self.assertEqual(module.TZ.utcoffset(None), timedelta(hours=8))

    def test_demo_send_and_diagnostics_never_open_external_connection(self):
        with tempfile.TemporaryDirectory() as directory:
            with patch('subprocess.run', side_effect=AssertionError('No Docker in demo')), \
                 patch('urllib.request.build_opener', side_effect=AssertionError('No network in demo')):
                engine = Engine(Store(Path(directory) / 'state-demo.sqlite'), DemoAdapter())
                prepare_demo(engine)
                account, group = engine.account, engine.selected
                report = environment_report(engine)
                self.assertTrue(report['ready'])
                self.assertFalse(report['capabilities']['liveSend'])
                self.assertTrue(report['capabilities']['demo'])
                self.assertEqual(len(engine.group_list), 3)
                self.assertTrue(engine.store.rows('SELECT id FROM messages'))
                row = engine.store.enqueue(account, group, '仅本地测试', ['demo-xiaolin'])
                sender = threading.Thread(target=engine.send_loop, daemon=True)
                sender.start()
                try:
                    deadline = time.monotonic() + 3
                    while time.monotonic() < deadline:
                        sent = engine.store.outbox(account)[0]
                        if sent['status'] == 'sent':
                            break
                        time.sleep(.02)
                    self.assertEqual(sent['id'], row['id'])
                    self.assertEqual(sent['status'], 'sent')
                    self.assertTrue(sent['result']['simulated'])
                    self.assertIn('@小林', sent['result']['text'])
                finally:
                    engine.stop.set()
                    sender.join(timeout=3)
                engine.logout(account)
                self.assertIsNone(engine.account)
                flow = LoginFlow(engine)
                flow.start()
                self.assertEqual(engine.account, account)
                self.assertEqual(flow.snapshot()['type'], 'login_success')

    def test_demo_subscriptions_survive_reinitialization(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'state-demo.sqlite'
            first = Engine(Store(path), DemoAdapter())
            prepare_demo(first)
            first.set_watched(first.account, [])
            second = Engine(Store(path), DemoAdapter())
            prepare_demo(second)
            self.assertEqual(second.store.watched(second.account), [])
            self.assertIsNone(second.selected)


class DemoHttpTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.engine = Engine(Store(Path(self.directory.name) / 'state-demo.sqlite'), DemoAdapter())
        prepare_demo(self.engine)
        self.login = LoginFlow(self.engine)
        self.server = ThreadingHTTPServer(('127.0.0.1', 0), http.server.BaseHTTPRequestHandler)
        self.port = self.server.server_port
        media = MediaCache(self.engine, Path(self.directory.name) / 'media')
        self.server.RequestHandlerClass = make_handler(self.engine, self.login, 'demo-test-token', self.port, media)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()

    def tearDown(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join()
        self.directory.cleanup()

    def request(self, method, path, body=None, **headers):
        if body is not None:
            headers = {'Origin': f'http://127.0.0.1:{self.port}', 'Content-Type': 'application/json',
                       'X-CSRF-Token': 'demo-test-token', **headers}
        connection = http.client.HTTPConnection('127.0.0.1', self.port, timeout=5)
        try:
            connection.request(method, path, json.dumps(body) if body is not None else None, headers)
            response = connection.getresponse()
            return response.status, json.loads(response.read())
        finally:
            connection.close()

    def test_environment_and_state_expose_mode_and_enforce_local_host(self):
        status, environment = self.request('GET', '/api/environment')
        self.assertEqual(status, 200)
        self.assertEqual(environment['mode'], 'demo')
        self.assertTrue(environment['ready'])
        self.assertTrue(all(row['status'] in ('ok', 'warning', 'error') for row in environment['checks']))
        status, state = self.request('GET', '/api/state')
        self.assertEqual(state['runtime']['capabilities']['send'], 'simulated')
        self.assertEqual(state['account'], 'demo-account')
        self.assertEqual(len(state['watchedGroups']), 3)
        self.assertEqual(self.request('GET', '/api/environment', Host='outside.example')[0], 403)

    def test_demo_group_members_and_owner_match_existing_client_contract(self):
        query = '?account=demo-account&groupId=demo-project@chatroom'
        status, group = self.request('GET', '/api/group' + query)
        self.assertEqual(status, 200)
        self.assertEqual(len(group['members']), 4)
        self.assertTrue(any(message['mentionSelf'] for message in group['messages']))
        _, info = self.request('GET', '/api/group-info' + query)
        self.assertEqual(info['ownerName'], '陈工')
        self.assertIn(info['ownerId'], [member['id'] for member in info['members']])

    def test_demo_logout_login_and_send_preserve_csrf_boundary(self):
        payload = {'account': 'demo-account', 'groupId': 'demo-project@chatroom', 'text': '仅测试'}
        self.assertEqual(self.request('POST', '/api/send', payload, **{'X-CSRF-Token': 'wrong'})[0], 403)
        self.assertEqual(self.request('POST', '/api/send', payload)[0], 202)
        self.assertEqual(self.request('POST', '/api/logout', {'account': 'demo-account'})[0], 200)
        self.assertEqual(self.request('POST', '/api/send', payload)[0], 400)
        self.assertEqual(self.request('POST', '/api/login', {})[0], 200)
        self.assertEqual(self.engine.account, 'demo-account')


if __name__ == '__main__':
    unittest.main()
