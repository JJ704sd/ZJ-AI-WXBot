"""Bounded health diagnostic; synthetic replies are 503, optional real /ping relay."""
from __future__ import annotations

import hashlib
import argparse
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import os
from pathlib import Path
import socket
import subprocess
import threading
import time
from urllib.parse import urlencode
from urllib.request import ProxyHandler, build_opener
from urllib.error import HTTPError
from probe_pad_861_metadata import NoRedirect

ROOT = Path(__file__).resolve().parents[1] / ".local" / "pad-legacy-861"
EXE = ROOT / "runtime" / "wechatpadpro-windows-amd64-vios18.61-861.exe"
EXPECTED = "5308323f32d4249f325a750b0c0faa91aba5b91f50593c88931d9829ffb203e9"


def main(*, relay_health=False):
    if hashlib.sha256(EXE.read_bytes()).hexdigest() != EXPECTED:
        raise ValueError("wrong build")
    for port in (1238, 8098):
        with socket.socket() as sock:
            sock.settimeout(0.2)
            if sock.connect_ex(("127.0.0.1", port)) == 0:
                raise ValueError("existing gateway listener")
    hits = []

    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            # Do not capture query strings, headers, bodies, IDs, tokens, or other credentials.
            event = {"method": "GET", "is_ping": self.path.split("?", 1)[0].endswith("/ping"),
                     "absolute_form": self.path.startswith("http://")}
            hits.append(event)
            status, body = 503, b""
            if relay_health and self.path == "/ping":
                try:
                    opener = build_opener(ProxyHandler({"https": "http://127.0.0.1:17891"}), NoRedirect())
                    try:
                        upstream = opener.open("https://adminkeyservice.knowhub.cloud/ping", timeout=4)
                    except HTTPError as exc:
                        upstream = exc
                    with upstream:
                        status = upstream.status
                        body = upstream.read(4097)
                        if len(body) > 4096:
                            status, body = 502, b""
                    event["upstream_status"] = status
                    event["upstream_body_sha256"] = hashlib.sha256(body).hexdigest()
                except Exception as exc:
                    status = 502
                    event["upstream_error_type"] = type(exc).__name__
            event["returned_status"] = status
            try:
                self.send_response(status)
                self.send_header("Content-Length", str(len(body)))
                self.end_headers()
                self.wfile.write(body)
            except ConnectionError:
                event["client_disconnected"] = True

        def do_POST(self):
            hits.append({"method": "POST", "is_ping": False, "absolute_form": False})
            self.send_response(503)
            self.send_header("Content-Length", "0")
            self.end_headers()

        def log_message(self, *args):
            pass

    server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
    server.daemon_threads = True
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    local = f"http://127.0.0.1:{server.server_port}"
    results = []
    original_hash = hashlib.sha256((ROOT / "runtime" / ".env").read_bytes()).hexdigest()
    admin_key = next(line.partition("=")[2].strip() for line in (ROOT / "runtime" / ".env").read_text(encoding="utf-8-sig").splitlines() if line.startswith("ADMIN_KEY="))
    try:
        cases = (("verified_upstream_health_relay", local),) if relay_health else (("direct_loopback_control", local), ("environment_proxy", "http://pad861-diagnostic.invalid"))
        for case, base in cases:
            hits.clear()
            env = os.environ.copy()
            env.update(ADMIN_KEY_SERVICE_URL=base, HTTP_PROXY=local, HTTPS_PROXY=local, ALL_PROXY="", NO_PROXY="")
            proc = None
            with (ROOT / f"proxy-{case}.stdout.private.log").open("wb") as out, (ROOT / f"proxy-{case}.stderr.private.log").open("wb") as err:
                try:
                    proc = subprocess.Popen([str(EXE)], cwd=EXE.parent, env=env, stdout=out, stderr=err,
                                            creationflags=subprocess.CREATE_NO_WINDOW)
                    deadline = time.monotonic() + 5
                    while time.monotonic() < deadline:
                        with socket.socket() as sock:
                            sock.settimeout(0.1)
                            if sock.connect_ex(("127.0.0.1", 1238)) == 0:
                                break
                        time.sleep(0.1)
                    # The authorization client is initialized lazily by an admin read operation.
                    read_result = "not_completed"
                    try:
                        url = "http://127.0.0.1:1238/admin/GetAllDevices?" + urlencode({"key": admin_key})
                        with build_opener(ProxyHandler({})).open(url, timeout=6) as response:
                            data = json.loads(response.read(256 * 1024))
                            read_result = {"code": data.get("Code")}
                    except Exception as exc:
                        read_result = type(exc).__name__
                    time.sleep(3)
                    results.append({"case": case, "gateway_running_at_end": proc.poll() is None,
                                    "readonly_inventory_result": read_result,
                                    "observed_requests": list(hits), "health_mode": "real_upstream_passthrough" if relay_health else "synthetic_503"})
                finally:
                    if proc is not None and proc.poll() is None:
                        proc.terminate()
                        proc.wait(timeout=5)
            time.sleep(0.3)
    finally:
        server.shutdown()
        server.server_close()
    remaining = []
    for port in (1238, 8098):
        with socket.socket() as sock:
            sock.settimeout(0.2)
            if sock.connect_ex(("127.0.0.1", port)) == 0:
                remaining.append(port)
    report = {"cases": results, "remaining_listeners": remaining,
              "config_unchanged": hashlib.sha256((ROOT / "runtime" / ".env").read_bytes()).hexdigest() == original_hash,
              "generation_calls": 0, "qr_calls": 0, "message_calls": 0, "successful_authorization_responses": 0}
    filename = "proxy-health-relay-result.json" if relay_health else "proxy-control-result.json"
    (ROOT / filename).write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--relay-health", action="store_true", help="Only /ping is relayed to the exact vendor TLS endpoint; all other requests return 503")
    main(relay_health=parser.parse_args().relay_health)
