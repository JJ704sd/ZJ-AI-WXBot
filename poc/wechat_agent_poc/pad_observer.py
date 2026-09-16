from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any, Mapping
from urllib.parse import urlsplit
from uuid import uuid4
import json
import os
import threading
import time

from wechat_agent_poc.api_channel import ChannelError
from wechat_agent_poc.clock import Clock, SystemClock
from wechat_agent_poc.pad_auth import PeerEvidence, peer_from_local_request
from wechat_agent_poc.pad_config import PadConfig, pad_observe_blockers, resolve_pad_secret
from wechat_agent_poc.pad_ingress import PadAck, PadIngress
from wechat_agent_poc.pad_store import PadStore

READ_PATHS = frozenset({"/User/GetOnlineInfo"})
WRITE_PATHS = frozenset({"/Msg/SendTxt", "/Webhook/Set", "/Msg/Sync", "/Login/"})


@dataclass(frozen=True)
class PadObserveStatus:
    run_id: str | None
    status: str
    observe_epoch: str | None
    sample_count: int
    counters: dict[str, int]
    send_calls: int
    model_calls: int
    task_creates: int
    readonly_calls: tuple[str, ...]
    network: bool
    listening: bool

    def as_dict(self) -> dict[str, Any]:
        return {
            "run_id": self.run_id,
            "status": self.status,
            "observe_epoch": self.observe_epoch,
            "sample_count": self.sample_count,
            "counters": self.counters,
            "send_calls": self.send_calls,
            "model_calls": self.model_calls,
            "task_creates": self.task_creates,
            "readonly_calls": list(self.readonly_calls),
            "network": self.network,
            "listening": self.listening,
            "model": False,
            "send": False,
        }


class ReadOnlyPadTransport:
    """Documented read paths only. Constructor does not send. /Msg/Sync is a control write."""

    def __init__(
        self,
        *,
        base_url: str = "",
        token: str = "",
        opener=None,
        allow_network: bool = False,
    ):
        self.base_url = (base_url or "").rstrip("/")
        self._token = token
        self._opener = opener
        self.allow_network = allow_network
        self.calls: list[str] = []
        self.rejected_writes = 0

    def get_online_info(self) -> dict[str, Any]:
        return self._request("GET", "/User/GetOnlineInfo")

    def post(self, path: str, payload: dict[str, Any] | None = None) -> dict[str, Any]:
        del payload
        return self._request("POST", path)

    def _request(self, method: str, path: str) -> dict[str, Any]:
        if path not in READ_PATHS or path in WRITE_PATHS or path.startswith("/Login/") or path.startswith("/Msg/"):
            self.rejected_writes += 1
            raise ChannelError("write_forbidden", f"readonly pad transport rejected {path}")
        self._assert_url(self.base_url + path if self.base_url else path, path)
        if not self.allow_network and self._opener is None:
            raise ChannelError("network_disabled", "readonly Pad HTTP is disabled")
        self.calls.append(f"{method} {path}")
        if self._opener is None:
            raise ChannelError("network_disabled", "readonly Pad HTTP is disabled")
        raise ChannelError("online_mapping_unknown", "GetOnlineInfo Data mapping is not observed")

    def reject_write(self, path: str) -> None:
        self.rejected_writes += 1
        raise ChannelError("write_forbidden", f"readonly pad transport rejected {path}")

    def _assert_url(self, url: str, path: str) -> None:
        parsed = urlsplit(url if "://" in url else f"https://invalid.example{path}")
        if parsed.query or parsed.fragment:
            raise ChannelError("path_forbidden", "readonly URL must use an exact metadata path")


class PadObserver:
    """Independent read-only Pad observer. No model, send client, outbox, or scheduled tasks."""

    def __init__(
        self,
        config: PadConfig,
        store: PadStore,
        *,
        clock: Clock | None = None,
        environ: Mapping[str, str] | None = None,
        readonly_transport: ReadOnlyPadTransport | None = None,
    ):
        self.config = config
        self.store = store
        self.clock = clock or SystemClock()
        self.environ = environ
        if readonly_transport is not None:
            self.readonly_transport = readonly_transport
        else:
            self.readonly_transport = ReadOnlyPadTransport(
                base_url=resolve_pad_secret(config.readonly.base_url_ref, environ),
                token=resolve_pad_secret(config.credential_ref, environ),
                allow_network=False,
            )
        secret = ""
        if config.signature_secret_ref:
            secret = resolve_pad_secret(config.signature_secret_ref, environ)
        self.ingress = PadIngress(config, store, clock=self.clock, signature_secret=secret)
        self.send_calls = 0
        self.model_calls = 0
        self.task_creates = 0
        self.listening = False
        self._run: dict[str, Any] | None = None
        self._server: ThreadingHTTPServer | None = None
        self._thread: threading.Thread | None = None
        self._accept_lock = threading.Lock()
        self.owner_nonce = uuid4().hex

    def start(self, *, status: str = "serving") -> str:
        if self.config.allow_live_send or self.config.allow_model:
            raise ChannelError("send_forbidden", "observer cannot start with send or model enabled")
        blockers = pad_observe_blockers(self.config, environ=self.environ)
        if blockers:
            raise ChannelError("observe_blocked", "; ".join(blockers))
        if self.readonly_transport.calls:
            raise ChannelError("probe_on_construct_forbidden", "readonly transport must not request before start")
        self.store.interrupt_unfinished("process_interrupted")
        run = self.store.create_run(
            api_flavor=self.config.api_flavor,
            account_key=self.config.binding.account_key,
            conversation_key=self.config.binding.conversation_key,
            binding_version=self.config.binding.binding_version,
            authorization_ref=self.config.authorization_ref,
            max_seconds=self.config.max_seconds,
            max_samples=self.config.max_samples,
            max_body_bytes=self.config.max_body_bytes,
            status=status,
        )
        self._run = run
        return str(run["run_id"])

    def accept(self, peer: PeerEvidence, raw: bytes, headers: Mapping[str, str] | None = None) -> PadAck:
        with self._accept_lock:
            self.ingress.send_calls = self.send_calls
            self.ingress.model_calls = self.model_calls
            self.ingress.task_creates = self.task_creates
            return self.ingress.accept(headers or {}, raw, peer)

    def serve_http(self, *, host: str | None = None, port: int | None = None) -> dict[str, Any]:
        if self._run is None:
            self.start()
        bind_host = host or self.config.bind_host
        bind_port = self.config.bind_port if port is None else port
        observer = self

        class Handler(BaseHTTPRequestHandler):
            def log_message(self, format, *args):  # noqa: A003
                return

            def do_POST(self):  # noqa: N802
                length = int(self.headers.get("Content-Length") or 0)
                raw = self.rfile.read(length)
                remote = self.client_address[0]
                peer = peer_from_local_request(remote=remote, ingress_mode=observer.config.ingress.mode)
                ack = observer.accept(peer, raw, {k: v for k, v in self.headers.items()})
                body = json.dumps(ack.to_dict(), ensure_ascii=False).encode("utf-8")
                self.send_response(ack.http_status)
                self.send_header("Content-Type", "application/json")
                self.send_header("Content-Length", str(len(body)))
                self.end_headers()
                self.wfile.write(body)

        self._server = ThreadingHTTPServer((bind_host, bind_port), Handler)
        port_used = int(self._server.server_address[1])
        self.store.attach_process(
            str(self._run["run_id"]),
            pid=os.getpid(),
            owner_nonce=self.owner_nonce,
            listen_host=bind_host,
            listen_port=port_used,
        )
        self.listening = True
        self._thread = threading.Thread(target=self._server.serve_forever, daemon=True)
        self._thread.start()
        return {"run_id": self._run["run_id"], "listen_host": bind_host, "listen_port": port_used, "status": "serving"}

    def status(self) -> PadObserveStatus:
        run = self.store.current_run() or {}
        return PadObserveStatus(
            run_id=run.get("run_id"),
            status=str(run.get("status") or "stopped"),
            observe_epoch=run.get("observe_epoch"),
            sample_count=int(run.get("sample_count") or 0),
            counters=self.store.counters(),
            send_calls=self.send_calls,
            model_calls=self.model_calls,
            task_creates=self.task_creates,
            readonly_calls=tuple(self.readonly_transport.calls),
            network=False,
            listening=self.listening,
        )

    def stop(self, reason: str = "operator_stop") -> dict[str, Any]:
        self.listening = False
        if self._server is not None:
            self._server.shutdown()
            self._server.server_close()
            self._server = None
        result = self.store.stop(reason)
        self._run = self.store.current_run()
        return result | {"send_calls": self.send_calls, "model_calls": self.model_calls, "task_creates": self.task_creates, "listen_state": "stopped"}


def describe_pad_status(store: PadStore, *, stale_seconds: float = 5.0) -> dict[str, Any]:
    run = store.current_run() or {}
    listen_state = "unknown/stale"
    lifecycle = str(run.get("status") or "stopped")
    if not run:
        listen_state = "stopped"
        lifecycle = "stopped"
    elif run.get("stopped_at") or lifecycle in {"stopped", "failed"}:
        listen_state = "stopped"
    elif lifecycle in {"serving", "stopping"}:
        heartbeat = run.get("heartbeat_at")
        stale = True
        if heartbeat:
            try:
                moment = datetime.fromisoformat(str(heartbeat).replace("Z", "+00:00"))
                stale = (datetime.now(timezone.utc) - moment).total_seconds() > stale_seconds
            except ValueError:
                stale = True
        pid = run.get("pid")
        alive = _pid_is_alive(int(pid)) if pid else False
        if lifecycle == "serving" and alive and not stale:
            listen_state = "serving"
        elif lifecycle == "stopping":
            listen_state = "stopping"
        else:
            listen_state = "unknown/stale"
            lifecycle = "unknown/stale"
    payload = {
        "target": "pad-observer",
        "run_id": run.get("run_id"),
        "lifecycle": lifecycle,
        "listen_state": listen_state,
        "pid": run.get("pid"),
        "listen_host": run.get("listen_host"),
        "listen_port": run.get("listen_port"),
        "sample_count": run.get("sample_count") or 0,
        "expires_at": run.get("expires_at"),
        "stop_reason": run.get("stop_reason"),
        "network": False,
        "model": False,
        "send": False,
        "counters": store.counters(),
    }
    text = json.dumps(payload, ensure_ascii=False, default=str)
    if "PAD_WEBHOOK_SECRET" in text or "PAD_GATEWAY_TOKEN" in text:
        raise AssertionError("status must not include credential names with secrets")
    return payload


def _pid_is_alive(pid: int) -> bool:
    if pid <= 0:
        return False
    if pid == os.getpid():
        return True
    if os.name == "nt":
        import ctypes

        handle = ctypes.windll.kernel32.OpenProcess(0x1000, False, pid)
        if handle:
            ctypes.windll.kernel32.CloseHandle(handle)
            return True
        return False
    try:
        os.kill(pid, 0)
        return True
    except OSError:
        return False


def wait_briefly(seconds: float = 0.05) -> None:
    time.sleep(seconds)
