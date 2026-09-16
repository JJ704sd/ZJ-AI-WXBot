"""Fixed-origin, one-generation transport for the unchanged 861 authorization client."""
from contextlib import contextmanager
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import threading
import time
from urllib.error import HTTPError
from urllib.request import HTTPRedirectHandler, ProxyHandler, Request, build_opener

ORIGIN = 'https://adminkeyservice.knowhub.cloud'
GENERATE = '/api/v1/public/auth/generate'
DEVICES = '/api/v1/auth/devices'
LIMIT = 256 * 1024


class TransportFailure(Exception):
    def __init__(self, phase, status, elapsed, cause_type, cause_details=None):
        super().__init__('upstream transport incomplete')
        self.phase = phase
        self.upstream_status = status
        self.elapsed_seconds = round(elapsed, 3)
        self.cause_type = cause_type
        self.cause_details = cause_details or {}


class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def upstream_request(method, path, body):
    if (method, path) not in {('GET', '/ping'), ('POST', GENERATE), ('POST', DEVICES)}:
        raise ValueError('route denied')
    opener = build_opener(ProxyHandler({'https': 'http://127.0.0.1:17891'}), NoRedirect())
    request = Request(ORIGIN + path, data=body, method=method,
                      headers={'Content-Type': 'application/json', 'Accept-Encoding': 'identity'})
    started = time.monotonic()
    phase, status = 'connect_or_response_headers', None
    try:
        try:
            # Allow collection of a late vendor response after the gateway's own
            # five-second timeout; never replay the request on client disconnect.
            response = opener.open(request, timeout=4 if method == 'GET' else 15)
        except HTTPError as error:
            response = error
        with response:
            status = response.status
            phase = 'response_body'
            raw = response.read(LIMIT + 1)
            if len(raw) > LIMIT:
                raise ValueError('response too large')
            return status, raw, response.headers.get('Content-Type', 'application/octet-stream')
    except Exception as error:
        underlying = getattr(error, 'reason', error)
        details = {'underlying_type': type(underlying).__name__}
        for field in ('errno', 'winerror', 'verify_code'):
            value = getattr(underlying, field, None)
            if isinstance(value, int):
                details[field] = value
        raise TransportFailure(phase, status, time.monotonic() - started, type(error).__name__, details) from None


@contextmanager
def running_relay(*, mode='generate', receipt_path=None, transport=None):
    if mode not in {'generate', 'reconcile'}:
        raise ValueError('unknown mode')
    post_path = GENERATE if mode == 'generate' else DEVICES
    events = []
    lock = threading.Lock()
    generation_attempted = False

    class Handler(BaseHTTPRequestHandler):
        def setup(self):
            super().setup()
            self.connection.settimeout(5)

        def log_message(self, *args):
            pass

        def handle_request(self):
            nonlocal generation_attempted
            event = {'method': self.command, 'route': 'denied'}
            events.append(event)
            status, raw, content_type = 403, b'', 'application/json'
            if (self.command, self.path) not in {('GET', '/ping'), ('POST', post_path)}:
                # Drain a small rejected body so closing TCP does not discard the
                # deliberate 403 response. Never forward it or keep its content.
                try:
                    rejected_length = int(self.headers.get('Content-Length', '0'))
                    if 0 < rejected_length <= LIMIT and not self.headers.get('Transfer-Encoding'):
                        self.rfile.read(rejected_length)
                except (ValueError, OSError):
                    pass
            if (self.command, self.path) in {('GET', '/ping'), ('POST', post_path)}:
                event['route'] = 'health' if self.command == 'GET' else mode
                try:
                    if self.headers.get('Transfer-Encoding'):
                        raise ValueError('unsupported framing')
                    lengths = self.headers.get_all('Content-Length', [])
                    if len(lengths) > 1:
                        raise ValueError('ambiguous framing')
                    length = int(lengths[0]) if lengths else 0
                    if not 0 <= length <= LIMIT or (self.command == 'GET' and length):
                        raise ValueError('invalid size')
                    body = self.rfile.read(length) if self.command == 'POST' else None
                    if body is not None and len(body) != length:
                        raise ValueError('incomplete body')
                    with lock:
                        denied = self.command == 'POST' and generation_attempted
                        if self.command == 'POST':
                            generation_attempted = True
                    if denied:
                        status = 409
                        event['duplicate_blocked'] = True
                    else:
                        event['upstream_attempted'] = True
                        started = time.monotonic()
                        status, raw, content_type = (transport or upstream_request)(self.command, self.path, body)
                        event['upstream_status'] = status
                        event['elapsed_seconds'] = round(time.monotonic() - started, 3)
                        event['phase'] = 'response_complete'
                        if self.command == 'POST' and receipt_path is not None:
                            with receipt_path.open('xb') as receipt:
                                receipt.write(raw)
                            event['private_receipt_saved'] = True
                except TransportFailure as error:
                    status, raw = 502, b''
                    event.update(error_type=error.cause_type, phase=error.phase,
                                 elapsed_seconds=error.elapsed_seconds)
                    event.update(error.cause_details)
                    if error.upstream_status is not None:
                        event['upstream_status'] = error.upstream_status
                except ValueError:
                    status = 400
                except Exception as error:
                    status, raw = 502, b''
                    event['error_type'] = type(error).__name__
            event['returned_status'] = status
            try:
                self.send_response(status)
                self.send_header('Content-Type', content_type)
                self.send_header('Content-Length', str(len(raw)))
                self.end_headers()
                self.wfile.write(raw)
            except ConnectionError:
                event['client_disconnected'] = True

        do_GET = handle_request
        do_POST = handle_request

    server = ThreadingHTTPServer(('127.0.0.1', 0), Handler)
    server.daemon_threads = False
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    try:
        yield f'http://127.0.0.1:{server.server_port}', events
    finally:
        server.shutdown()
        server.server_close()
        thread.join(timeout=2)
