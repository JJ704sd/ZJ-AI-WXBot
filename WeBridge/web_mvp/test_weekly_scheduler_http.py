"""Weekly schedule HTTP acceptance over synthetic snapshots and a recording bridge."""
from contextlib import closing
from datetime import datetime
import http.client
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import tempfile
import threading
import unittest
from unittest.mock import patch

from server import LoginFlow, make_handler
from test_windows_inbound import InboundFixture
from windows_scheduler import BEIJING, WindowsScheduler


class WeeklyScheduleHttpTests(unittest.TestCase):
    def setUp(self):
        directory = tempfile.TemporaryDirectory(prefix='webridge-synthetic-weekly-http-')
        self.addCleanup(directory.cleanup)
        self.f = InboundFixture(directory.name)
        self.f.now = datetime(2026, 10, 3, 10, 0, tzinfo=BEIJING).timestamp()
        self.scheduler = self.new_scheduler()
        self.f.engine.windows_scheduler = self.scheduler
        self.server = ThreadingHTTPServer(('127.0.0.1', 0), BaseHTTPRequestHandler)
        self.port = self.server.server_port
        self.server.RequestHandlerClass = make_handler(self.f.engine, LoginFlow(self.f.engine),
            'synthetic-csrf', self.port, database_service=self.f.source)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()
        self.addCleanup(self.stop_server)

    def new_scheduler(self):
        f = self.f
        return WindowsScheduler(f.engine, f.source, lambda: f.sender, clock=lambda: f.now)

    def stop_server(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join(timeout=5)
        self.assertFalse(self.thread.is_alive())

    def request(self, method, path, payload=None, *, headers_only=False, **overrides):
        headers = {'Origin': f'http://127.0.0.1:{self.port}', 'Content-Type': 'application/json',
                   'X-CSRF-Token': 'synthetic-csrf'}
        headers.update(overrides)
        body=json.dumps(payload) if payload is not None else None
        if headers_only:
            # Test early Content-Length rejection without unread upload bytes
            # causing a Windows TCP reset to hide the HTTP error response.
            headers['Content-Length']=str(len(body.encode('utf-8')))
        with closing(http.client.HTTPConnection('127.0.0.1', self.port, timeout=5)) as connection:
            connection.request(method, path, None if headers_only else body, headers)
            response = connection.getresponse()
            return response.status, json.loads(response.read())

    def data(self, **changes):
        return {'account': self.f.account, 'groupId': self.f.group, 'text': '每周采购询价合成任务',
                'requestId': 'synthetic-weekly-http-request', 'mode': 'weekly', 'clock': '10:01',
                'weekdays': [5, 1, 3], **changes}

    def test_create_snapshot_retry_and_resume_use_selected_days(self):
        code, job = self.request('POST', '/api/jobs', self.data())
        self.assertEqual(code, 201)
        self.assertEqual(job['weekdays'], [1, 3, 5])
        self.assertEqual(job['nextRun'], datetime(2026, 10, 5, 10, 1, tzinfo=BEIJING).timestamp())
        code, snapshot = self.request('GET', '/api/state')
        self.assertEqual(code, 200)
        self.assertEqual(snapshot['jobs'], [job])
        code, repeated = self.request('POST', '/api/jobs', self.data(weekdays=[3, 5, 1]))
        self.assertEqual((code, repeated['id']), (201, job['id']))
        self.assertEqual(self.request('POST', '/api/jobs', self.data(weekdays=[1, 3]))[0], 400)
        self.assertEqual(len(self.scheduler.list(self.f.account)), 1)
        action = {'account': self.f.account, 'id': job['id']}
        self.assertEqual(self.request('POST', '/api/jobs/pause', action)[1]['state'], 'paused')
        self.f.now = job['nextRun']+30
        code, resumed = self.request('POST', '/api/jobs/resume', action)
        self.assertEqual(code, 200)
        self.assertEqual(resumed['nextRun'], datetime(2026, 10, 7, 10, 1, tzinfo=BEIJING).timestamp())
        self.scheduler.tick()
        self.assertEqual(self.scheduler.list(self.f.account)[0]['runs'], [])
        self.assertEqual(self.f.posts, [])

    def test_invalid_calendar_and_untrusted_posts_never_contact_sender(self):
        with patch.object(self.scheduler, 'sender_factory', side_effect=AssertionError('Unexpected Hook contact')):
            for changes in ({'weekdays': []}, {'weekdays': [True]}, {'weekdays': [0]},
                            {'weekdays': [8]}, {'weekdays': [1, 1]}, {'weekdays': '1,3,5'},
                            {'weekdays': ['1']}, {'weekdays': None}, {'weekdays': [{'day': 1}]},
                            {'mode': 'daily'}, {'mode': 'once', 'at': '2026-10-05T10:01'}):
                with self.subTest(changes=changes):
                    self.assertEqual(self.request('POST', '/api/jobs', self.data(**changes))[0], 400)
            for headers in ({'Origin': 'https://untrusted.invalid'}, {'X-CSRF-Token': ''}, {'Host': 'untrusted.invalid'}):
                with self.subTest(headers=headers):
                    self.assertEqual(self.request('POST', '/api/jobs', self.data(), **headers)[0], 403)
        self.assertEqual(self.scheduler.list(self.f.account), [])
        self.assertEqual(self.f.posts, [])

    def test_old_daily_request_and_persisted_spec_survive_new_reader(self):
        request = self.data(mode='daily')
        del request['weekdays']
        code, old = self.request('POST', '/api/jobs', request)
        self.assertEqual(code, 201)
        with closing(self.scheduler._db()) as db:
            payload = json.loads(db.execute('SELECT payload FROM schedules').fetchone()[0])
        self.assertNotIn('weekdays', payload)
        self.assertNotIn('weekdays', payload['spec'])
        self.scheduler = self.new_scheduler()
        self.f.engine.windows_scheduler = self.scheduler
        code, replayed = self.request('POST', '/api/jobs', request)
        self.assertEqual(code, 201)
        self.assertEqual(replayed['id'], old['id'])
        self.assertEqual(replayed['nextRun'], old['nextRun'])
        self.assertEqual(replayed['weekdays'], [1, 2, 3, 4, 5, 6, 7])
        self.assertFalse(replayed['enabled'])
        self.assertEqual(replayed['state'], 'paused')
        self.assertEqual(self.f.posts, [])


if __name__ == '__main__':
    unittest.main()
