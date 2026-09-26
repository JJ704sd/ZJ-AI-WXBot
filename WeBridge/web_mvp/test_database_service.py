"""Exercise actual copy/SQLite/HTTP boundaries with generated, non-WeChat data."""
from contextlib import closing
import hashlib
import http.client
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
import json
from pathlib import Path
import sqlite3
import tempfile
import threading
import unittest
from unittest.mock import patch

from backend import Engine, Store
from database_adapter import DatabaseAdapter
from database_service import DatabaseService
from server import LoginFlow, make_handler
from runtime_support import runtime_summary


def make_source(root):
    root.mkdir()
    database = root / 'message_0.db'
    table = 'Msg_' + hashlib.md5(b'fixture@chatroom').hexdigest()
    with closing(sqlite3.connect(database)) as db:
        db.execute('CREATE TABLE Name2Id(user_name TEXT)')
        db.executemany('INSERT INTO Name2Id VALUES(?)', [('fixture@chatroom',), ('fixture-self',)])
        db.execute('CREATE TABLE ' + table + '(local_id INTEGER, server_id INTEGER, local_type INTEGER, create_time INTEGER, real_sender_id INTEGER, message_content TEXT)')
        db.execute('INSERT INTO ' + table + ' VALUES(1,9001,1,1700000000,2,?)', ('Synthetic message only',))
        db.commit()
    return database


class DatabaseServiceTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.original = make_source(self.root / 'source')
        self.adapter = DatabaseAdapter()
        self.engine = Engine(Store(self.root / 'runtime/state.sqlite'), self.adapter)
        self.service = DatabaseService(self.adapter, self.root / 'runtime', self.engine)

    def tearDown(self):
        if self.service.worker:
            self.service.worker.join(10)
        self.temporary.cleanup()

    def load(self):
        self.service.configure({'sourceRoot': str(self.original.parent), 'selfId': 'fixture-self'})
        self.service.worker.join(10)
        self.assertFalse(self.service.busy)
        self.assertEqual(self.service.error, '')

    def test_real_copy_reload_and_restore_keep_source_unchanged(self):
        original = self.original.read_bytes()
        self.load()
        info = self.service.snapshot()
        self.assertEqual(info['source']['status'], 'snapshot_ready')
        self.assertEqual(self.original.read_bytes(), original)
        self.assertFalse(list(self.original.parent.glob('*-shm')))
        self.assertTrue(runtime_summary(self.engine)['capabilities']['read'])
        self.assertFalse(runtime_summary(self.engine)['capabilities']['canSend'])
        account = self.engine.account
        self.engine.set_watched(account, ['fixture@chatroom'])
        first_revision = info['source']['revision']
        self.service.refresh()
        self.service.worker.join(10)
        self.assertEqual(self.service.error, '')
        self.assertEqual(self.engine.account, account)
        self.assertNotEqual(self.service.snapshot()['source']['revision'], first_revision)
        self.assertEqual(self.engine.store.watched(account), ['fixture@chatroom'])
        restored = DatabaseService(DatabaseAdapter(), self.root / 'runtime')
        self.assertTrue(restored.snapshot()['configured'])
        self.assertEqual(restored.snapshot()['source']['id'], account)

    def test_busy_rejected_failed_update_preserves_previous_source(self):
        self.load()
        previous = self.adapter.get_source_info()['revision']
        started, release = threading.Event(), threading.Event()
        from database_snapshot import SnapshotError
        def fail(*args, **kwargs):
            started.set()
            release.wait(5)
            raise SnapshotError('合成测试：副本校验失败。')
        with patch('database_snapshot.prepare_snapshot', side_effect=fail):
            self.service.refresh()
            self.assertTrue(started.wait(5))
            try:
                with self.assertRaises(ValueError): self.service.refresh()
            finally:
                release.set()
                self.service.worker.join(10)
        self.assertEqual(self.adapter.get_source_info()['revision'], previous)
        self.assertIn('合成测试', self.service.error)

    def test_known_generations_stay_bounded_across_restarts(self):
        self.load()
        for _ in range(3):
            self.service = DatabaseService(DatabaseAdapter(), self.root / 'runtime')
            self.service.refresh()
            self.service.worker.join(10)
            self.assertEqual(self.service.error, '')
            self.assertLessEqual(len(list(self.service.snapshot_directory.iterdir())), 2)

    def test_change_monitor_reads_new_message_and_bounds_owned_generations(self):
        self.load()
        initial_worker = self.service.worker
        self.service.check_for_changes()
        self.assertIs(self.service.worker, initial_worker)
        account = self.engine.account
        table = 'Msg_' + hashlib.md5(b'fixture@chatroom').hexdigest()
        for index in range(2, 5):
            with closing(sqlite3.connect(self.original)) as db:
                db.execute('INSERT INTO ' + table + ' VALUES(?,?,1,1700000001,2,?)',
                           (index, 9000 + index, 'Synthetic update ' + str(index)))
                db.commit()
            self.service.next_check = 0
            self.service.check_for_changes()
            self.service.worker.join(10)
            self.assertEqual(self.service.error, '')
            messages = self.adapter.call('messages', account=account, groupId='fixture@chatroom')['messages']
            self.assertEqual(len(messages), index)
            self.assertLessEqual(len(list(self.service.snapshot_directory.iterdir())), 2)

    def test_corrupt_restored_snapshot_does_not_prevent_server_setup(self):
        self.load()
        saved = json.loads(self.service.config_path.read_text(encoding='utf-8'))
        (Path(saved['snapshotRoot']) / 'message_0.db').write_bytes(b'invalid synthetic database')
        restored = DatabaseService(DatabaseAdapter(), self.root / 'runtime')
        self.assertFalse(restored.snapshot()['configured'])
        self.assertTrue(restored.error)

    def test_valid_sqlite_without_message_schema_leaves_no_unpublished_copy(self):
        self.load()
        previous = self.adapter.get_source_info()['revision']
        before = set(self.service.snapshot_directory.iterdir())
        rejected = self.root / 'unsupported'
        rejected.mkdir()
        with closing(sqlite3.connect(rejected / 'contact.db')) as db:
            db.execute('CREATE TABLE arbitrary(value TEXT)')
            db.commit()
        self.service.configure({'sourceRoot': str(rejected)})
        self.service.worker.join(10)
        self.assertTrue(self.service.error)
        self.assertEqual(self.adapter.get_source_info()['revision'], previous)
        self.assertEqual(set(self.service.snapshot_directory.iterdir()), before)
        self.assertFalse(self.service.config_path.with_suffix('.json.tmp').exists())

    def test_http_reads_only_watched_copy_and_blocks_all_legacy_send_paths(self):
        self.load()
        server = ThreadingHTTPServer(('127.0.0.1', 0), BaseHTTPRequestHandler)
        port = server.server_port
        calls = []
        class FakeSender:
            def preview(sender, data):
                calls.append(data)
                return {'status': 'blocked', 'issue': 'synthetic transport only'}
        server.RequestHandlerClass = make_handler(self.engine, LoginFlow(self.engine), 'fixture-csrf', port, database_service=self.service, desktop_sender=FakeSender())
        worker = threading.Thread(target=server.serve_forever, daemon=True)
        worker.start()
        def request(method, path, body=None, token='fixture-csrf'):
            connection = http.client.HTTPConnection('127.0.0.1', port, timeout=10)
            try:
                connection.request(method, path, json.dumps(body) if body is not None else None,
                                   {'Origin': f'http://127.0.0.1:{port}', 'Content-Type': 'application/json', 'X-CSRF-Token': token})
                response = connection.getresponse()
                return response.status, json.loads(response.read())
            finally:
                connection.close()
        try:
            account = self.engine.account
            query = '/api/messages?account=' + account + '&groupId=fixture@chatroom'
            self.assertEqual(request('GET', query)[1]['messages'], [])
            self.engine.set_watched(account, ['fixture@chatroom'])
            messages = request('GET', query)[1]['messages']
            self.assertEqual(messages[0]['text'], 'Synthetic message only')
            self.assertEqual(self.engine.store.rows('SELECT id FROM messages'), [])
            for path in ('send', 'reply', 'jobs', 'jobs/cancel', 'login', 'logout', 'media'):
                code, data = request('POST', '/api/' + path, {'account': account, 'groupId': 'fixture@chatroom', 'text': 'MUST NOT SEND'})
                self.assertEqual(code, 400, path)
            self.assertEqual(self.engine.store.rows('SELECT id FROM outbox'), [])
            self.assertEqual(request('POST', '/api/database/refresh', {}, token='')[0], 403)
            self.assertEqual(request('POST', '/api/windows/send/preview', {}, token='')[0], 403)
            self.assertFalse(calls)
            code, result = request('POST', '/api/windows/send/preview', {'sourceRoot': str(self.root / 'wrong-account'), 'account': 'wrong-account'})
            self.assertEqual(code, 200)
            self.assertEqual(result['status'], 'blocked')
            self.assertEqual(calls[0]['sourceRoot'], str(self.original.parent))
            self.assertEqual(calls[0]['account'], account)
            self.assertEqual(request('GET', '/api/asset?id=anything')[0], 400)
        finally:
            server.shutdown()
            server.server_close()
            worker.join()


if __name__ == '__main__':
    unittest.main()
