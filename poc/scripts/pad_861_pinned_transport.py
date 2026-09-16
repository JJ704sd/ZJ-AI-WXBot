"""Per-request DNS pinning with original TLS hostname; no global network changes."""
import ipaddress
import json
import subprocess
import time
from pad_861_auth_relay import ORIGIN, GENERATE, DEVICES, LIMIT, TransportFailure


def pinned_request(ip, method, path, body):
    if not ipaddress.ip_address(ip).is_global:
        raise ValueError('public address required')
    if (method, path) not in {('GET', '/ping'), ('POST', GENERATE), ('POST', DEVICES)}:
        raise ValueError('route denied')
    command = ['curl.exe', '-q', '--silent', '--show-error', '--noproxy', '*',
               '--resolve', 'adminkeyservice.knowhub.cloud:443:' + ip,
               '--connect-timeout', '4', '--max-time', '15', '--max-filesize', str(LIMIT),
               '--request', method, '--header', 'Content-Type: application/json',
               '--write-out', '%{stderr}\n%{json}']
    if method == 'POST':
        command += ['--data-binary', '@-']
    command.append(ORIGIN + path)
    started = time.monotonic()
    result = subprocess.run(command, input=body, capture_output=True, timeout=18,
                            creationflags=subprocess.CREATE_NO_WINDOW)
    try:
        metrics = json.loads(result.stderr.decode('utf-8', errors='replace').splitlines()[-1])
    except (ValueError, IndexError):
        metrics = {}
    status = metrics.get('http_code') or None
    if result.returncode or len(result.stdout) > LIMIT:
        phase = 'response_body' if status else 'connect_or_response_headers'
        raise TransportFailure(phase, status, time.monotonic()-started, 'CurlTransportError', {'curl_exit_code':result.returncode})
    if status is None:
        raise TransportFailure('response_headers', None, time.monotonic()-started, 'MissingHTTPStatus')
    return status, result.stdout, metrics.get('content_type') or 'application/json'
