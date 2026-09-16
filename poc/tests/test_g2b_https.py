from __future__ import annotations

from datetime import datetime, timedelta, timezone
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen
import ipaddress
import json
import os
import socket
import ssl
import sqlite3
import statistics
import subprocess
import threading
import time

import pytest

from wechat_agent_poc.observer_config import parse_observer_config
from wechat_agent_poc.observer_deploy_config import parse_observer_deploy_config
from wechat_agent_poc.observer_service import ObserverService

POC_ROOT = Path(__file__).resolve().parents[1]
CADDYFILE_EXAMPLE = POC_ROOT / "deploy" / "gewe-observer" / "Caddyfile.example"
DEFAULT_CADDY = POC_ROOT / ".local" / "tools" / "caddy" / "caddy.exe"
ROOM = "example_group@chatroom"
SELF = "wxid_self_test"
APP = "wx_device_test"
CALLBACK_SECRET = "g2bC" + "c" * 28
BRIDGE_TOKEN = "g2bB" + "b" * 28
GATEWAY_TOKEN = "g2bG" + "g" * 28
WRONG_SECRET = "g2bW" + "w" * 28
LEAK_NEEDLES = (CALLBACK_SECRET, BRIDGE_TOKEN, GATEWAY_TOKEN, WRONG_SECRET)


def _caddy_exe() -> Path:
    override = os.environ.get("G2B_CADDY_EXE")
    path = Path(override) if override else DEFAULT_CADDY
    if not path.is_file():
        pytest.skip(f"G2b skipped: local Caddy portable missing at {path}")
    return path


def _free_port() -> int:
    sock = socket.socket()
    sock.bind(("127.0.0.1", 0))
    port = int(sock.getsockname()[1])
    sock.close()
    assert port > 1024
    return port


def _port_open(host: str, port: int) -> bool:
    with socket.socket() as sock:
        sock.settimeout(0.2)
        return sock.connect_ex((host, port)) == 0


def _wait_port(host: str, port: int, timeout: float) -> None:
    deadline = time.time() + timeout
    while time.time() < deadline:
        if _port_open(host, port):
            return
        time.sleep(0.05)
    raise AssertionError(f"{host}:{port} did not become ready")


def _wait_closed(host: str, port: int, timeout: float) -> None:
    deadline = time.time() + timeout
    while time.time() < deadline:
        if not _port_open(host, port):
            return
        time.sleep(0.05)
    raise AssertionError(f"{host}:{port} still accepting connections")


def _loopback_only(port: int) -> None:
    raw = subprocess.check_output(["netstat", "-ano", "-p", "TCP"], text=True, encoding="utf-8", errors="replace")
    hits = [line for line in raw.splitlines() if f":{port} " in f"{line} " and ("LISTENING" in line.upper() or "侦听" in line)]
    assert hits, f"port {port} is not listening:\n{raw}"
    for line in hits:
        assert f"0.0.0.0:{port}" not in line, line
        assert f"[::]:{port}" not in line, line
        assert f"127.0.0.1:{port}" in line or f"[::1]:{port}" in line, line


def _env() -> dict[str, str]:
    return {
        "WECHAT_CALLBACK_SECRET": CALLBACK_SECRET,
        "WECHAT_CALLBACK_BRIDGE_TOKEN": BRIDGE_TOKEN,
        "WECHAT_GATEWAY_BASE_URL": "https://example.invalid",
        "WECHAT_GATEWAY_TOKEN": GATEWAY_TOKEN,
        "WECHAT_GATEWAY_APP_ID": APP,
    }


def _observer_raw(tmp_path: Path, **overrides) -> dict:
    raw = {
        "config_version": "observer-config/1",
        "enabled": True,
        "allow_live_send": False,
        "allow_model": False,
        "allow_network": False,
        "authorization_ref": "g2b-offline",
        "bind_host": "127.0.0.1",
        "bind_port": 0,
        "max_seconds": 1800,
        "max_samples": 200,
        "ingress": {
            "mode": "callback_bearer",
            "callback_secret_ref": "env:WECHAT_CALLBACK_SECRET",
            "bridge_token_ref": "env:WECHAT_CALLBACK_BRIDGE_TOKEN",
        },
        "channel": {
            "provider": "geweapi",
            "base_url_ref": "env:WECHAT_GATEWAY_BASE_URL",
            "credential_ref": "env:WECHAT_GATEWAY_TOKEN",
            "app_id_ref": "env:WECHAT_GATEWAY_APP_ID",
        },
        "binding": {"account_key": SELF, "conversation_key": ROOM, "binding_version": "bv-g2b"},
        "store": {"path": str(tmp_path / "observe.sqlite")},
        "probe": {},
    }
    raw.update(overrides)
    return raw


def _write_toml(path: Path, data: dict) -> None:
    chunks: list[str] = []
    tables: dict[str, dict] = {}
    for key, value in data.items():
        if isinstance(value, dict):
            tables[key] = value
        else:
            chunks.append(f"{key} = {_toml_value(value)}")
    for name, table in tables.items():
        chunks.append(f"[{name}]")
        for key, value in table.items():
            chunks.append(f"{key} = {_toml_value(value)}")
    path.write_text("\n".join(chunks) + "\n", encoding="utf-8")


def _toml_value(value) -> str:
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    text = str(value).replace("\\", "\\\\").replace('"', '\\"')
    return f'"{text}"'


def _event(**overrides) -> dict:
    payload = {
        "appid": APP,
        "wxid": SELF,
        "content": "g2b ping",
        "createTime": 1758000001,
        "fromUser": "wxid_member_a",
        "isSelf": False,
        "msgType": "TEXT",
        "newMsgId": 3768973957878705000,
        "toUser": ROOM,
    }
    payload.update(overrides)
    return payload


def generate_local_tls(directory: Path) -> tuple[Path, Path, Path]:
    from cryptography import x509
    from cryptography.hazmat.primitives import hashes, serialization
    from cryptography.hazmat.primitives.asymmetric import rsa
    from cryptography.x509.oid import ExtendedKeyUsageOID, NameOID

    directory.mkdir(parents=True, exist_ok=True)
    now = datetime.now(timezone.utc)
    ca_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    ca_name = x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, "g2b-local-ca")])
    ca_cert = (
        x509.CertificateBuilder()
        .subject_name(ca_name)
        .issuer_name(ca_name)
        .public_key(ca_key.public_key())
        .serial_number(x509.random_serial_number())
        .not_valid_before(now - timedelta(minutes=1))
        .not_valid_after(now + timedelta(days=1))
        .add_extension(x509.BasicConstraints(ca=True, path_length=0), critical=True)
        .sign(ca_key, hashes.SHA256())
    )
    server_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    server_name = x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, "127.0.0.1")])
    server_cert = (
        x509.CertificateBuilder()
        .subject_name(server_name)
        .issuer_name(ca_name)
        .public_key(server_key.public_key())
        .serial_number(x509.random_serial_number())
        .not_valid_before(now - timedelta(minutes=1))
        .not_valid_after(now + timedelta(days=1))
        .add_extension(
            x509.SubjectAlternativeName(
                [x509.DNSName("localhost"), x509.IPAddress(ipaddress.IPv4Address("127.0.0.1"))]
            ),
            critical=False,
        )
        .add_extension(x509.ExtendedKeyUsage([ExtendedKeyUsageOID.SERVER_AUTH]), critical=False)
        .sign(ca_key, hashes.SHA256())
    )
    ca_path = directory / "ca.pem"
    cert_path = directory / "test.pem"
    key_path = directory / "test.key"
    ca_path.write_bytes(ca_cert.public_bytes(serialization.Encoding.PEM))
    cert_path.write_bytes(server_cert.public_bytes(serialization.Encoding.PEM))
    key_path.write_bytes(
        server_key.private_bytes(
            serialization.Encoding.PEM,
            serialization.PrivateFormat.TraditionalOpenSSL,
            serialization.NoEncryption(),
        )
    )
    return ca_path, cert_path, key_path


def render_caddyfile(*, https_port: int, backend_port: int, cert: Path, key: Path, log_file: Path) -> str:
    assert https_port > 1024
    assert backend_port > 1024
    return f"""{{
	auto_https off
	admin off
	log {{
		output file {log_file.as_posix()}
		format filter {{
			wrap json
			fields {{
				request>uri delete
				request>headers delete
			}}
		}}
	}}
}}

https://127.0.0.1:{https_port} {{
	bind 127.0.0.1
	tls {cert.as_posix()} {key.as_posix()}

	@callback {{
		method POST
		path /callbacks/gewe/*
	}}

	route {{
	handle @callback {{
		reverse_proxy 127.0.0.1:{backend_port} {{
			header_up -X-Wechat-Bridge-Token
			header_up -X-Wechat-Bridge-*
			header_up -X-Wechat-Source-Level
			header_up -X-Wechat-Source-*
			header_up -X-Source-Level
			lb_retries 0
			transport http {{
				dial_timeout 1s
				read_timeout 3s
				write_timeout 3s
			}}
		}}
	}}

	handle {{
		respond 404
	}}
	}}
}}
"""


def tls_context(ca_path: Path) -> ssl.SSLContext:
    context = ssl.create_default_context(cafile=str(ca_path))
    assert context.verify_mode == ssl.CERT_REQUIRED
    assert context.check_hostname is True
    return context


def https_request(
    https_port: int,
    ca_path: Path,
    *,
    method: str = "POST",
    path: str,
    body: bytes | None = None,
    headers: dict[str, str] | None = None,
    timeout: float = 5,
) -> tuple[int, bytes, float]:
    request_headers = dict(headers or {})
    if body is not None and "Content-Type" not in request_headers:
        request_headers["Content-Type"] = "application/json"
    req = Request(
        f"https://127.0.0.1:{https_port}{path}",
        data=body,
        method=method,
        headers=request_headers,
    )
    started = time.perf_counter()
    try:
        with urlopen(req, timeout=timeout, context=tls_context(ca_path)) as response:
            payload = response.read()
            return response.status, payload, time.perf_counter() - started
    except HTTPError as exc:
        return exc.code, exc.read() if exc.fp else b"", time.perf_counter() - started


def https_callback(https_port: int, ca_path: Path, secret: str, payload: dict, extra_headers=None, timeout: float = 5):
    return https_request(
        https_port,
        ca_path,
        path=f"/callbacks/gewe/{secret}",
        body=json.dumps(payload).encode(),
        headers=extra_headers,
        timeout=timeout,
    )


def scan_for_leaks(*parts: Path | str) -> None:
    blobs: list[str] = []
    for part in parts:
        if isinstance(part, Path):
            if part.is_file():
                blobs.append(part.read_text(encoding="utf-8", errors="replace"))
            elif part.is_dir():
                for item in part.rglob("*"):
                    if item.is_file():
                        blobs.append(item.read_text(encoding="utf-8", errors="replace"))
        else:
            blobs.append(part)
    combined = "\n".join(blobs)
    for needle in LEAK_NEEDLES:
        assert needle not in combined, "fault logs leaked a credential"


def _popen(command: list[str], cwd: Path, env: dict[str, str], stdout_path: Path, stderr_path: Path) -> subprocess.Popen:
    stdout_path.parent.mkdir(parents=True, exist_ok=True)
    stdout = stdout_path.open("wb")
    stderr = stderr_path.open("wb")
    proc = subprocess.Popen(
        command,
        cwd=str(cwd),
        env=env,
        stdout=stdout,
        stderr=stderr,
        creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
    )
    proc._g2b_stdout = stdout  # type: ignore[attr-defined]
    proc._g2b_stderr = stderr  # type: ignore[attr-defined]
    return proc


def _close_stdio(proc: subprocess.Popen) -> None:
    for attr in ("_g2b_stdout", "_g2b_stderr"):
        handle = getattr(proc, attr, None)
        if handle is not None and not handle.closed:
            handle.close()
        setattr(proc, attr, None)


def terminate_proc(proc: subprocess.Popen | None, timeout: float = 10) -> None:
    if proc is None:
        return
    if proc.poll() is None:
        proc.terminate()
        try:
            proc.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            proc.kill()
            proc.wait(timeout=5)
    _close_stdio(proc)


def start_caddy(*, caddy: Path, caddyfile: Path, https_port: int, log_dir: Path) -> subprocess.Popen:
    subprocess.check_call(
        [str(caddy), "fmt", "--overwrite", str(caddyfile)],
        cwd=str(POC_ROOT),
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    adapted = subprocess.check_output(
        [str(caddy), "adapt", "--config", str(caddyfile), "--adapter", "caddyfile"],
        cwd=str(POC_ROOT),
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    adapted_json = json.loads(adapted)
    dumped = json.dumps(adapted_json)
    assert "X-Wechat-Bridge-Token" in dumped
    assert "vendor_verified" not in dumped
    assert ": " + CALLBACK_SECRET not in dumped
    subprocess.check_call(
        [str(caddy), "validate", "--config", str(caddyfile), "--adapter", "caddyfile"],
        cwd=str(POC_ROOT),
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    env = os.environ.copy()
    env["HOME"] = str(log_dir / "caddy-home")
    proc = _popen(
        [str(caddy), "run", "--config", str(caddyfile), "--adapter", "caddyfile"],
        cwd=POC_ROOT,
        env=env,
        stdout_path=log_dir / "caddy.stdout.log",
        stderr_path=log_dir / "caddy.stderr.log",
    )
    try:
        _wait_port("127.0.0.1", https_port, 8)
    except Exception:
        terminate_proc(proc)
        raise
    _loopback_only(https_port)
    assert proc.poll() is None
    return proc


class TwoProcessStack:
    def __init__(self, tmp_path: Path, deploy: dict | None = None, **observer_overrides):
        self.tmp_path = tmp_path
        self.observer_overrides = observer_overrides
        self.deploy_overrides = deploy or {}
        self.caddy: Path = _caddy_exe()
        self.ca_path: Path
        self.https_port = _free_port()
        self.backend_port = _free_port()
        self.observer_proc: subprocess.Popen | None = None
        self.caddy_proc: subprocess.Popen | None = None
        self.log_dir = tmp_path / "logs"
        self.obs_cfg = tmp_path / "obs.toml"
        self.dep_cfg = tmp_path / "dep.toml"
        self.python = POC_ROOT / ".venv" / "Scripts" / "python.exe"

    def start(self) -> None:
        self.log_dir.mkdir(parents=True, exist_ok=True)
        ca_path, cert_path, key_path = generate_local_tls(self.tmp_path / "certs")
        self.ca_path = ca_path
        raw = _observer_raw(self.tmp_path, **self.observer_overrides)
        _write_toml(self.obs_cfg, raw)
        deploy = {
            "config_version": "observer-deploy/1",
            "mode": "synthetic",
            "bind_host": "127.0.0.1",
            "bind_port": self.backend_port,
            "tls_mode": "off",
            "max_concurrent_requests": 8,
            "body_read_timeout_seconds": 1.0,
            "lock_path": str(self.tmp_path / "observer.lock"),
            "log_dir": str(self.log_dir),
        }
        deploy.update(self.deploy_overrides)
        _write_toml(self.dep_cfg, deploy)
        caddyfile = self.tmp_path / "Caddyfile"
        caddyfile.write_text(
            render_caddyfile(
                https_port=self.https_port,
                backend_port=self.backend_port,
                cert=cert_path,
                key=key_path,
                log_file=self.log_dir / "caddy.json.log",
            ),
            encoding="utf-8",
        )
        env = os.environ.copy()
        env.update(_env())
        env["PYTHONUNBUFFERED"] = "1"
        env["PYTHONPATH"] = str(POC_ROOT)
        self.observer_proc = _popen(
            [
                str(self.python),
                "-m",
                "wechat_agent_poc.api_cli",
                "--observer-config",
                str(self.obs_cfg),
                "api-observe",
                "start",
                "--serve",
                "--deployment-config",
                str(self.dep_cfg),
            ],
            cwd=POC_ROOT,
            env=env,
            stdout_path=self.log_dir / "observer.stdout.log",
            stderr_path=self.log_dir / "observer.stderr.log",
        )
        try:
            _wait_port("127.0.0.1", self.backend_port, 12)
        except Exception as exc:
            _close_stdio(self.observer_proc)
            stdout = (self.log_dir / "observer.stdout.log").read_text(encoding="utf-8", errors="replace")
            stderr = (self.log_dir / "observer.stderr.log").read_text(encoding="utf-8", errors="replace")
            code = self.observer_proc.poll()
            terminate_proc(self.observer_proc)
            raise AssertionError(f"observer did not listen; exit={code}\nSTDOUT:\n{stdout}\nSTDERR:\n{stderr}") from exc
        _loopback_only(self.backend_port)
        assert self.observer_proc.poll() is None
        self.caddy_proc = start_caddy(
            caddy=self.caddy,
            caddyfile=caddyfile,
            https_port=self.https_port,
            log_dir=self.log_dir,
        )

    def cli(self, action: str) -> subprocess.CompletedProcess:
        env = os.environ.copy()
        env.update(_env())
        env["PYTHONPATH"] = str(POC_ROOT)
        return subprocess.run(
            [
                str(self.python),
                "-m",
                "wechat_agent_poc.api_cli",
                "--observer-config",
                str(self.obs_cfg),
                "api-observe",
                action,
            ],
            cwd=str(POC_ROOT),
            env=env,
            check=False,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            timeout=15,
        )

    def stop_both(self) -> None:
        try:
            self.cli("stop")
            if self.observer_proc is not None and self.observer_proc.poll() is None:
                self.observer_proc.wait(timeout=10)
        finally:
            terminate_proc(self.observer_proc)
            terminate_proc(self.caddy_proc)
        _wait_closed("127.0.0.1", self.https_port, 5)
        _wait_closed("127.0.0.1", self.backend_port, 5)

    def leak_scan(self, *extra: str) -> None:
        scan_for_leaks(self.log_dir, *extra)


def test_caddyfile_example_is_loopback_and_does_not_inject_auth():
    text = CADDYFILE_EXAMPLE.read_text(encoding="utf-8")
    assert "bind 127.0.0.1" in text
    assert "https://127.0.0.1:18443" in text
    assert "localhost:443" not in text
    assert "0.0.0.0:443" not in text
    assert ":443 {" not in text
    assert "auto_https off" in text
    assert "admin off" in text
    assert "header_up -X-Wechat-Bridge-Token" in text
    assert "header_up -X-Wechat-Bridge-*" in text
    assert "header_up -X-Wechat-Source-Level" in text
    assert "lb_retries 0" in text
    assert "request>uri delete" in text
    assert "request>headers delete" in text
    assert "handle @callback" in text
    assert "handle {" in text
    assert "respond 404" in text
    assert "0.0.0.0" not in text
    version = subprocess.check_output([str(_caddy_exe()), "version"], text=True, encoding="utf-8").strip()
    assert version.startswith("v2.11.4")


def test_https_chain_legal_auth_headers_duplicate_logs_and_stop(tmp_path: Path):
    stack = TwoProcessStack(tmp_path)
    stack.start()
    latencies: list[float] = []
    try:
        with pytest.raises((ssl.SSLError, URLError)):
            urlopen(
                f"https://127.0.0.1:{stack.https_port}/callbacks/gewe/{CALLBACK_SECRET}",
                data=json.dumps(_event()).encode(),
                timeout=3,
                context=ssl.create_default_context(),
            )
        for idx in range(5):
            status, payload, elapsed = https_callback(
                stack.https_port,
                stack.ca_path,
                CALLBACK_SECRET,
                _event(newMsgId=3768973957878705000 + idx, content=f"g2b ping {idx}"),
            )
            assert status == 200, payload
            assert payload == b"ok"
            assert elapsed < 3
            latencies.append(elapsed)
        p95 = latencies[int(round((len(latencies) - 1) * 0.95))]
        mean = statistics.mean(latencies)
        print(f"G2B_LATENCY_SECONDS latencies={latencies} p95={p95:.4f} mean={mean:.4f}")
        assert p95 < 1, latencies
        status, payload, _ = https_callback(
            stack.https_port,
            stack.ca_path,
            CALLBACK_SECRET,
            _event(newMsgId=3768973957878705000, content="g2b ping 0"),
        )
        assert status == 200
        assert payload == b"ok"
        status, payload, _ = https_callback(stack.https_port, stack.ca_path, WRONG_SECRET, _event(newMsgId=99))
        assert status == 401
        assert payload == b"denied"
        status, payload, _ = https_callback(
            stack.https_port,
            stack.ca_path,
            CALLBACK_SECRET,
            _event(newMsgId=4001, content="forged"),
            extra_headers={
                "X-Wechat-Bridge-Token": BRIDGE_TOKEN,
                "X-Wechat-Source-Level": "vendor_verified",
                "X-Source-Level": "vendor_verified",
            },
        )
        assert status == 200
        status, payload, _ = https_request(stack.https_port, stack.ca_path, method="GET", path="/")
        assert status == 404
        db = sqlite3.connect(str(tmp_path / "observe.sqlite"))
        rows = list(db.execute("SELECT source_level, native_message_id, text FROM samples ORDER BY created_at"))
        db.close()
        assert len(rows) == 6
        assert {row[0] for row in rows} == {"callback_bearer"}
        assert "4001" in {row[1] for row in rows}
        stop = stack.cli("stop")
        assert stop.returncode == 0
        if stack.observer_proc is not None:
            stack.observer_proc.wait(timeout=10)
            assert stack.observer_proc.poll() is not None
        terminate_proc(stack.caddy_proc)
        stack.caddy_proc = None
        stack.observer_proc = None
        _wait_closed("127.0.0.1", stack.https_port, 5)
        _wait_closed("127.0.0.1", stack.backend_port, 5)
        with pytest.raises((URLError, OSError, ssl.SSLError)):
            https_callback(stack.https_port, stack.ca_path, CALLBACK_SECRET, _event(newMsgId=5001), timeout=2)
        status_after = stack.cli("status")
        assert '"listen_state": "stopped"' in status_after.stdout or '"lifecycle": "stopped"' in status_after.stdout
        stack.leak_scan(stop.stdout, stop.stderr, status_after.stdout, json.dumps({"p95": p95, "latencies": latencies}))
        (tmp_path / "latency.json").write_text(json.dumps({"latencies": latencies, "p95": p95, "mean": statistics.mean(latencies)}), encoding="utf-8")
    finally:
        stack.stop_both()


def test_https_request_limit_and_slow_body_stop_race(tmp_path: Path):
    stack = TwoProcessStack(tmp_path, rate_limit_per_second=1, burst=1, max_samples=200)
    stack.start()
    try:
        first = https_callback(stack.https_port, stack.ca_path, CALLBACK_SECRET, _event(newMsgId=6001))
        assert first[0] == 200
        limited = https_callback(stack.https_port, stack.ca_path, CALLBACK_SECRET, _event(newMsgId=6002))
        assert limited[0] == 503
        assert limited[1] == b"denied"
        time.sleep(1.2)
        holder_error: list[BaseException] = []
        holder_result: list[bytes] = []

        def slow_body() -> None:
            try:
                sock = socket.create_connection(("127.0.0.1", stack.https_port), timeout=5)
                context = tls_context(stack.ca_path)
                wrapped = context.wrap_socket(sock, server_hostname="127.0.0.1")
                body = json.dumps(_event(newMsgId=6003, content="slow")).encode()
                path = f"/callbacks/gewe/{CALLBACK_SECRET}"
                wrapped.sendall(
                    (
                        f"POST {path} HTTP/1.1\r\n"
                        f"Host: 127.0.0.1:{stack.https_port}\r\n"
                        "Content-Type: application/json\r\n"
                        f"Content-Length: {len(body)}\r\n"
                        "Connection: close\r\n"
                        "\r\n"
                    ).encode()
                )
                wrapped.sendall(body[:8])
                time.sleep(0.4)
                stop = stack.cli("stop")
                assert stop.returncode == 0
                wrapped.sendall(body[8:])
                holder_result.append(wrapped.recv(4096))
                wrapped.close()
            except BaseException as exc:  # noqa: BLE001
                holder_error.append(exc)

        thread = threading.Thread(target=slow_body)
        thread.start()
        thread.join(timeout=15)
        assert not thread.is_alive()
        if holder_result:
            text = holder_result[0].decode("latin-1", errors="replace")
            assert CALLBACK_SECRET not in text
            status_line = text.split("\r\n", 1)[0]
            assert " 200 " not in status_line
        if stack.observer_proc is not None and stack.observer_proc.poll() is None:
            stack.observer_proc.wait(timeout=10)
        terminate_proc(stack.caddy_proc)
        stack.caddy_proc = None
        stack.observer_proc = None
        _wait_closed("127.0.0.1", stack.https_port, 5)
        _wait_closed("127.0.0.1", stack.backend_port, 5)
        db = sqlite3.connect(str(tmp_path / "observe.sqlite"))
        stored = [row[0] for row in db.execute("SELECT native_message_id FROM samples")]
        db.close()
        assert "6003" not in stored
        stack.leak_scan()
        assert not holder_error or all(isinstance(item, (URLError, OSError, ssl.SSLError, TimeoutError, ConnectionError)) for item in holder_error)
    finally:
        stack.stop_both()


def test_https_expiry_exits_both_listeners(tmp_path: Path):
    stack = TwoProcessStack(tmp_path, max_seconds=2)
    stack.start()
    try:
        status, payload, elapsed = https_callback(stack.https_port, stack.ca_path, CALLBACK_SECRET, _event(newMsgId=7001))
        assert status == 200
        assert elapsed < 3
        deadline = time.time() + 8
        while time.time() < deadline and stack.observer_proc is not None and stack.observer_proc.poll() is None:
            time.sleep(0.2)
        assert stack.observer_proc is not None
        assert stack.observer_proc.poll() is not None
        terminate_proc(stack.caddy_proc)
        stack.caddy_proc = None
        _wait_closed("127.0.0.1", stack.backend_port, 5)
        _wait_closed("127.0.0.1", stack.https_port, 5)
        db = sqlite3.connect(str(tmp_path / "observe.sqlite"))
        row = db.execute("SELECT status, stop_reason FROM observe_runs ORDER BY started_at DESC LIMIT 1").fetchone()
        db.close()
        assert row[0] in {"stopped", "failed"}
        stack.leak_scan()
    finally:
        stack.stop_both()


def test_https_storage_failure_and_persist_stop_race(tmp_path: Path):
    caddy = _caddy_exe()
    backend_port = _free_port()
    https_port = _free_port()
    log_dir = tmp_path / "logs"
    log_dir.mkdir()
    ca_path, cert_path, key_path = generate_local_tls(tmp_path / "certs")
    caddyfile = tmp_path / "Caddyfile"
    caddyfile.write_text(
        render_caddyfile(
            https_port=https_port,
            backend_port=backend_port,
            cert=cert_path,
            key=key_path,
            log_file=log_dir / "caddy.json.log",
        ),
        encoding="utf-8",
    )
    cfg = parse_observer_config(_observer_raw(tmp_path), source_path=tmp_path / "obs.toml", environ=_env())
    deploy = parse_observer_deploy_config(
        {
            "config_version": "observer-deploy/1",
            "mode": "synthetic",
            "bind_host": "127.0.0.1",
            "bind_port": backend_port,
            "tls_mode": "off",
            "lock_path": str(tmp_path / "observer.lock"),
            "log_dir": str(log_dir),
        },
        source_path=tmp_path / "dep.toml",
    )
    service = ObserverService(cfg, deploy, environ=_env())
    caddy_proc = None
    try:
        service.start(background=True)
        _wait_port("127.0.0.1", backend_port, 5)
        caddy_proc = start_caddy(caddy=caddy, caddyfile=caddyfile, https_port=https_port, log_dir=log_dir)
        original = service.store.persist_sample

        def boom(**kwargs):
            raise sqlite3.OperationalError("simulated disk I/O error")

        service.store.persist_sample = boom  # type: ignore[method-assign]
        status, payload, _ = https_callback(https_port, ca_path, CALLBACK_SECRET, _event(newMsgId=8001))
        assert status == 503
        assert payload == b"denied"
        assert service.store.sample_count() == 0

        entered = threading.Event()
        proceed = threading.Event()

        def delayed(**kwargs):
            entered.set()
            assert proceed.wait(5)
            return original(**kwargs)

        service.store.persist_sample = delayed  # type: ignore[method-assign]
        result: list[tuple[int, bytes]] = []

        def in_flight() -> None:
            result.append(https_callback(https_port, ca_path, CALLBACK_SECRET, _event(newMsgId=8002)))

        worker = threading.Thread(target=in_flight)
        worker.start()
        assert entered.wait(5)
        service.store.request_stop("operator_stop")
        proceed.set()
        worker.join(timeout=10)
        assert result and result[0][0] == 503
        assert service.store.sample_count() == 0
        stopped = service.stop("operator_stop")
        assert stopped["stop_requested"] is True
        terminate_proc(caddy_proc)
        caddy_proc = None
        _wait_closed("127.0.0.1", https_port, 5)
        _wait_closed("127.0.0.1", backend_port, 5)
        scan_for_leaks(log_dir)
    finally:
        try:
            service.stop("cleanup")
        except Exception:
            pass
        terminate_proc(caddy_proc)
