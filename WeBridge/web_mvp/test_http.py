"""Exercise the HTTP boundary with an isolated database and fake WeChat adapter."""
import http.client
from http.server import ThreadingHTTPServer
import json
from pathlib import Path
import tempfile
import threading
from types import SimpleNamespace
import unittest
from unittest.mock import Mock, patch

from backend import Engine, Store
from server import LoginFlow, make_handler
from media_host import MediaCache
from test_backend import FakeAdapter


class HttpTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.store = Store(Path(self.directory.name) / 'state.sqlite')
        self.engine = Engine(self.store, FakeAdapter())
        self.engine.refresh_connection()
        self.server = ThreadingHTTPServer(('127.0.0.1', 0), http.server.BaseHTTPRequestHandler)
        self.port = self.server.server_port
        self.media = MediaCache(self.engine, Path(self.directory.name)/'media')
        self.server.RequestHandlerClass = make_handler(self.engine, LoginFlow(self.engine), 'test-csrf', self.port,self.media)
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()

    def tearDown(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join()
        self.directory.cleanup()

    def request(self, method, path, body=None, **overrides):
        headers = {'Origin': f'http://127.0.0.1:{self.port}', 'Content-Type': 'application/json',
                   'X-CSRF-Token': 'test-csrf'}
        headers.update(overrides)
        conn = http.client.HTTPConnection('127.0.0.1', self.port, timeout=5)
        try:
            conn.request(method, path, json.dumps(body) if body is not None else None, headers)
            response = conn.getresponse()
            return response.status, json.loads(response.read())
        finally:
            conn.close()

    def payload(self):
        return {'account': 'account-a', 'groupId': 'group-a', 'text': 'test only',
                'mentionIds': [], 'requestId': 'http-request-123'}

    def test_cross_origin_and_missing_csrf_cannot_enqueue(self):
        for headers in ({'Origin': 'https://outside.example'}, {'X-CSRF-Token': ''},
                        {'Sec-Fetch-Site': 'cross-site'}):
            status, _ = self.request('POST', '/api/send', self.payload(), **headers)
            self.assertEqual(status, 403)
        self.assertEqual(self.store.outbox('account-a'), [])

    def test_unrecognized_host_cannot_read_account(self):
        status, _ = self.request('GET', '/api/state', **{'Host': f'outside.example:{self.port}'})
        self.assertEqual(status, 403)

    def test_repeated_submission_queues_once_and_account_mismatch_is_rejected(self):
        for _ in range(2):
            status, _ = self.request('POST', '/api/send', self.payload())
            self.assertEqual(status, 202)
        wrong = {**self.payload(), 'account': 'account-b'}
        self.assertEqual(self.request('POST', '/api/send', wrong)[0], 400)
        self.assertEqual(len(self.store.outbox('account-a')), 1)
        self.assertEqual(self.engine.adapter.sent, [])

    def test_video_bytes_support_seeking_and_stop_after_scope_removal(self):
        self.engine.set_watched('account-a',['group-a'])
        self.store.ingest('account-a','group-a',[{'id':'video-1','kind':'video'}])
        path=Path(self.directory.name)/'clip.mp4';path.write_bytes(b'0123456789')
        self.media.entries['asset-test']={'key':('account-a','group-a','video-1',''),'path':path,
            'public':{'size':10,'mime':'video/mp4','filename':'测试视频.mp4'}}
        conn=http.client.HTTPConnection('127.0.0.1',self.port,timeout=5)
        try:
            conn.request('GET','/api/asset?id=asset-test&account=account-a',headers={'Range':'bytes=2-5'})
            response=conn.getresponse()
            self.assertEqual(response.status,206);self.assertEqual(response.getheader('Content-Range'),'bytes 2-5/10')
            self.assertEqual(response.getheader('Content-Type'),'video/mp4');self.assertEqual(response.read(),b'2345')
        finally:conn.close()
        self.engine.set_watched('account-a',[])
        self.assertEqual(self.request('GET','/api/asset?id=asset-test&account=account-a')[0],400)

    def test_pdf_renderer_assets_cannot_traverse_to_private_data(self):
        self.assertEqual(self.request('GET','/vendor/pdfjs/../../../backend.py')[0],404)

    def test_windows_status_host_boundary_blocks_client_probe(self):
        status_probe = Mock(return_value={'platform': 'Windows', 'clients': []})
        with patch.dict('sys.modules', {'windows_client': SimpleNamespace(status=status_probe)}):
            response, _ = self.request('GET', '/api/windows/status', Host='outside.example')
            self.assertEqual(response, 403)
            status_probe.assert_not_called()
            response, result = self.request('GET', '/api/windows/status')
            self.assertEqual(response, 200)
            self.assertEqual(result['platform'], 'Windows')
            status_probe.assert_called_once_with()

    def test_windows_preview_requires_csrf_and_forwards_only_selected_window(self):
        preview = Mock(return_value={'ok': True, 'messages': [], 'readOnly': True})
        payload = {'pid': 123, 'hwnd': 456, 'account': 'account-a', 'text': 'must never send'}
        with patch.dict('sys.modules', {'windows_client': SimpleNamespace(preview=preview)}):
            response, _ = self.request('POST', '/api/windows/preview', payload, **{'X-CSRF-Token': ''})
            self.assertEqual(response, 403)
            preview.assert_not_called()
            response, result = self.request('POST', '/api/windows/preview', payload)
            self.assertEqual(response, 200)
            self.assertTrue(result['readOnly'])
            preview.assert_called_once_with(123, 456)
            self.assertEqual(self.engine.adapter.sent, [])
            self.assertEqual(self.store.outbox('account-a'), [])

    def test_native_ocr_and_structure_checks_require_csrf_and_never_enqueue(self):
        payload = {'pid': 123, 'hwnd': '456'}
        for path, module, method in (('/api/windows/ocr-preview', 'windows_reader', 'preview_ocr'),
                                     ('/api/windows/inspect', 'windows_client', 'inspect')):
            operation = Mock(return_value={'ok': True, 'readOnly': True})
            with self.subTest(path=path), patch.dict('sys.modules', {module: SimpleNamespace(**{method: operation})}):
                response, _ = self.request('POST', path, payload, **{'X-CSRF-Token': ''})
                self.assertEqual(response, 403)
                operation.assert_not_called()
                response, result = self.request('POST', path, payload)
                self.assertEqual(response, 200)
                self.assertTrue(result['readOnly'])
                operation.assert_called_once_with(123, '456')
        self.assertEqual(self.engine.adapter.sent, [])
        self.assertEqual(self.store.outbox('account-a'), [])


if __name__ == '__main__':
    unittest.main()
