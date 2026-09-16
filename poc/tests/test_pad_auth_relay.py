import urllib.error
import urllib.request
import pytest
import socket
import time
import ssl

from scripts import pad_861_auth_relay as relay


def test_body_timeout_preserves_received_status_and_stage(monkeypatch):
    class Response:
        status = 200
        headers = {'Content-Type': 'application/json'}
        def __enter__(self): return self
        def __exit__(self, *args): pass
        def read(self, size): raise TimeoutError('sensitive details')
    class Opener:
        def open(self, request, timeout): return Response()
    monkeypatch.setattr(relay, 'build_opener', lambda *args: Opener())
    with pytest.raises(Exception) as failure:
        relay.upstream_request('POST', relay.GENERATE, b'{}')
    assert getattr(failure.value, 'upstream_status', None) == 200
    assert failure.value.phase == 'response_body'
    assert failure.value.elapsed_seconds >= 0
    assert 'sensitive details' not in str(failure.value)


def test_connection_error_reports_type_without_private_reason(monkeypatch):
    class Opener:
        def open(self, request, timeout):
            raise urllib.error.URLError(ssl.SSLError(1, 'private url and credentials'))
    monkeypatch.setattr(relay, 'build_opener', lambda *args: Opener())
    with pytest.raises(relay.TransportFailure) as failure:
        relay.upstream_request('POST', relay.GENERATE, b'{}')
    error = failure.value
    assert error.phase == 'connect_or_response_headers'
    assert error.upstream_status is None
    assert error.cause_details == {'underlying_type': 'SSLError', 'errno': 1}
    assert 'private' not in str(error)


def request(base, path, body=None):
    opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
    try:
        return opener.open(urllib.request.Request(base + path, data=body), timeout=2)
    except urllib.error.HTTPError as error:
        return error


def test_exact_route_and_unchanged_vendor_failure(monkeypatch):
    sent = []

    def upstream(method, path, body):
        sent.append((method, path, body))
        return 401, b'{"code":401,"message":"denied"}', 'application/json'

    monkeypatch.setattr(relay, 'upstream_request', upstream)
    with relay.running_relay() as (base, events):
        with request(base, '/api/v1/public/auth/generate', b'{"signature":"synthetic"}') as response:
            assert response.status == 401
            assert response.read() == b'{"code":401,"message":"denied"}'
        with request(base, '/api/v1/public/auth/generate', b'{}') as response:
            assert response.status == 409
        for path in ['/other', '/ping?secret=x', '//example.com/ping']:
            with request(base, path) as response:
                assert response.status == 403
    assert sent == [('POST', '/api/v1/public/auth/generate', b'{"signature":"synthetic"}')]
    assert 'synthetic' not in str(events)


def test_uncertain_submission_blocks_retry_without_leaking_error(monkeypatch):
    def upstream(method, path, body):
        raise TimeoutError('private request contents')

    monkeypatch.setattr(relay, 'upstream_request', upstream)
    with relay.running_relay() as (base, events):
        with request(base, relay.GENERATE, b'{}') as response:
            assert response.status == 502
            assert response.read() == b''
        with request(base, relay.GENERATE, b'{}') as response:
            assert response.status == 409
    assert events[0]['upstream_attempted'] is True
    assert events[1]['duplicate_blocked'] is True
    assert 'private request contents' not in str(events)


def test_reconciliation_mode_cannot_generate(monkeypatch):
    sent = []
    def upstream(method, path, body):
        sent.append(path)
        return 200, b'{"devices":[]}', 'application/json'
    monkeypatch.setattr(relay, 'upstream_request', upstream)
    with relay.running_relay(mode='reconcile') as (base, events):
        with request(base, relay.GENERATE, b'{}') as response:
            assert response.status == 403
        with request(base, relay.DEVICES, b'{}') as response:
            assert response.status == 200
            assert response.read() == b'{"devices":[]}'
    assert sent == [relay.DEVICES]


def test_late_response_saved_even_after_client_disconnect(monkeypatch, tmp_path):
    def upstream(method, path, body):
        time.sleep(0.15)
        return 200, b'{"result":"synthetic-late"}', 'application/json'
    monkeypatch.setattr(relay, 'upstream_request', upstream)
    receipt = tmp_path / 'late.private.json'
    with relay.running_relay(receipt_path=receipt) as (base, events):
        port = int(base.rsplit(':', 1)[1])
        with socket.create_connection(('127.0.0.1', port)) as client:
            client.sendall(b'POST /api/v1/public/auth/generate HTTP/1.0\r\nContent-Length: 2\r\n\r\n{}')
        deadline = time.monotonic() + 3
        while not receipt.exists() and time.monotonic() < deadline:
            time.sleep(0.02)
    assert receipt.read_bytes() == b'{"result":"synthetic-late"}'
    assert events[0]['phase'] == 'response_complete'
    assert 'synthetic-late' not in str(events)
