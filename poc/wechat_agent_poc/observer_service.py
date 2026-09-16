from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Mapping
from uuid import uuid4
import json
import os
import socket
import threading
import time

from wechat_agent_poc.api_channel import ChannelError
from wechat_agent_poc.api_config import isoformat
from wechat_agent_poc.clock import SystemClock
from wechat_agent_poc.config import ConfigError
from wechat_agent_poc.gewe_observe_store import ObserveStore
from wechat_agent_poc.gewe_observer import GeweObserver, ReadOnlyGeweClient, build_callback_app
from wechat_agent_poc.observer_config import ObserverConfig, observe_blockers, resolve_secret_ref
from wechat_agent_poc.observer_deploy_config import ObserverDeployConfig, deploy_blockers

HEARTBEAT_INTERVAL = 1.0
SUPERVISOR_INTERVAL = 0.5


@dataclass(frozen=True)
class PrepareResult:
    status: str
    blockers: tuple[str, ...]
    active_permit: bool
    run_id: str | None = None


class ProcessLock:
    def __init__(self, path: Path):
        self.path = path
        self._fd: int | None = None

    def acquire(self) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self._fd = os.open(str(self.path), os.O_CREAT | os.O_RDWR)
        try:
            os.lseek(self._fd, 0, os.SEEK_SET)
            if os.fstat(self._fd).st_size == 0:
                os.write(self._fd, b"\0")
                os.lseek(self._fd, 0, os.SEEK_SET)
            _lock_nb(self._fd)
        except OSError as exc:
            os.close(self._fd)
            self._fd = None
            raise ConfigError("observer lock is held; duplicate instance refused") from exc

    def write_meta(self, payload: dict[str, Any]) -> None:
        if self._fd is None:
            return
        encoded = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        os.lseek(self._fd, 1, os.SEEK_SET)
        os.ftruncate(self._fd, 1)
        os.write(self._fd, encoded)

    def release(self) -> None:
        if self._fd is None:
            return
        try:
            _unlock(self._fd)
        finally:
            os.close(self._fd)
            self._fd = None


def read_lock_meta(path: Path) -> dict[str, Any]:
    if not path.is_file():
        return {}
    try:
        raw = path.read_text(encoding="utf-8").strip()
        if raw.startswith("\x00"):
            raw = raw[1:]
        data = json.loads(raw) if raw else {}
        return data if isinstance(data, dict) else {}
    except (OSError, json.JSONDecodeError):
        return {}


class ObserverService:
    """Bounded supervisor. CLI uses prepare/start/status/stop only."""

    def __init__(
        self,
        observer_config: ObserverConfig,
        deploy: ObserverDeployConfig,
        *,
        environ: Mapping[str, str] | None = None,
        store: ObserveStore | None = None,
        readonly_client: ReadOnlyGeweClient | None = None,
    ):
        self.observer_config = observer_config
        self.deploy = deploy
        self.environ = environ
        self.store = store or ObserveStore(observer_config.store_path)
        self.readonly_client = readonly_client
        self.lock = ProcessLock(deploy.lock_path)
        self._stop = threading.Event()
        self._server = None
        self._sock: socket.socket | None = None
        self._observer: GeweObserver | None = None
        self._thread: threading.Thread | None = None
        self._supervisor: threading.Thread | None = None
        self._deadline_mono = 0.0
        self.owner_nonce = uuid4().hex
        self.send_calls = 0
        self.model_calls = 0

    def prepare(self) -> PrepareResult:
        blockers = list(observe_blockers(self.observer_config, environ=self.environ))
        blockers.extend(deploy_blockers(self.deploy, self.observer_config.allow_network))
        if self.deploy.mode == "live_observe" and self.observer_config.ingress.mode != "callback_bearer":
            blockers.append("live_observe requires ingress.mode=callback_bearer")
        if self.deploy.mode == "synthetic" and self.observer_config.ingress.mode not in {"none", "callback_bearer"}:
            blockers.append("synthetic deploy requires ingress none or callback_bearer")
        if self.observer_config.allow_live_send or self.observer_config.allow_model:
            blockers.append("observer cannot enable send or model")
        return PrepareResult(
            status="prepared" if not blockers else "blocked",
            blockers=tuple(blockers),
            active_permit=False,
        )

    def start(self, *, background: bool = False) -> dict[str, Any]:
        prepared = self.prepare()
        if prepared.blockers:
            raise ChannelError("observe_blocked", "; ".join(prepared.blockers))
        self.lock.acquire()
        run_id = None
        try:
            self.store.interrupt_unfinished("process_interrupted")
            self._sock = _bind_loopback(self.deploy.bind_host, self.deploy.bind_port, self.deploy.queue_depth)
            observer = self._build_observer()
            if self.deploy.mode == "live_observe":
                try:
                    if observer.readonly_client is None:
                        raise ChannelError("probe_required", "live_observe requires ReadOnlyGeweClient")
                    observer.start(status="probing")
                except Exception:
                    run = observer.store.current_run()
                    if run and run.get("run_id"):
                        self.store.fail_run(str(run["run_id"]), "probe_failed")
                    raise
            else:
                if observer.readonly_client is not None:
                    raise ChannelError("synthetic_network_forbidden", "synthetic mode must not assemble a live client")
                observer.start(status="serving")
            self._observer = observer
            run = observer.store.current_run() or {}
            run_id = str(run.get("run_id") or "")
            if self.deploy.mode == "live_observe" and run.get("status") == "awaiting_binding":
                self.store.fail_run(run_id, "binding_unverified")
                raise ChannelError("binding_unverified", "live observe refused to serve without a verified group")
            port = int(self._sock.getsockname()[1])
            self.store.attach_process(
                run_id,
                pid=os.getpid(),
                owner_nonce=self.owner_nonce,
                listen_host=self.deploy.bind_host,
                listen_port=port,
            )
            self.lock.write_meta(
                {
                    "pid": os.getpid(),
                    "owner_nonce": self.owner_nonce,
                    "run_id": run_id,
                    "listen_host": self.deploy.bind_host,
                    "listen_port": port,
                }
            )
            observer._run = self.store.current_run()
            self._deadline_mono = time.monotonic() + self.observer_config.max_seconds
            app = build_callback_app(
                observer,
                max_concurrent=self.deploy.max_concurrent_requests,
                body_read_timeout=self.deploy.body_read_timeout_seconds,
            )
            self._serve(app, background=background)
            return {"run_id": run_id, "status": "serving", "listen_port": port, "pid": os.getpid()}
        except Exception as exc:
            if run_id:
                self.store.fail_run(run_id, getattr(exc, "code", None) or type(exc).__name__)
            self._cleanup_listen()
            self.lock.release()
            raise

    def serve_forever(self) -> dict[str, Any]:
        started = self.start(background=False)
        return started

    def status(self) -> dict[str, Any]:
        return describe_observer_status(
            self.store,
            lock_path=self.deploy.lock_path,
            stale_seconds=self.deploy.heartbeat_stale_seconds,
        )

    def stop(self, reason: str = "operator_stop") -> dict[str, Any]:
        run = self.store.current_run() or {}
        requested = self.store.request_stop(reason, run_id=run.get("run_id"))
        if self._server is None and self._thread is None:
            confirmed = self._wait_sqlite_stopped(self.deploy.listen_shutdown_seconds)
            return {
                "stop_requested": bool(requested.get("stop_requested") or requested.get("stopped_confirmed")),
                "stopped_confirmed": confirmed,
                "run_id": run.get("run_id"),
                "reason": reason,
                "listen_state": "stopped" if confirmed else "unknown/stale",
            }
        self._stop.set()
        if self._server is not None:
            self._server.should_exit = True
        confirmed = self._wait_stopped(self.deploy.listen_shutdown_seconds)
        if self._observer is not None:
            self._observer.stop(reason)
        else:
            self.store.stop(reason)
        self._cleanup_listen()
        self.lock.release()
        stopped = (self.store.current_run() or {}).get("status") in {"stopped", "failed"}
        return {
            "stop_requested": True,
            "stopped_confirmed": bool(confirmed or stopped),
            "run_id": run.get("run_id"),
            "reason": reason,
            "listen_state": "stopped" if confirmed or stopped else "unknown/stale",
        }

    def _build_observer(self) -> GeweObserver:
        client = self.readonly_client
        if self.deploy.mode == "live_observe" and client is None:
            client = ReadOnlyGeweClient(
                base_url=resolve_secret_ref(self.observer_config.channel.base_url_ref, self.environ),
                token=resolve_secret_ref(self.observer_config.channel.credential_ref, self.environ),
                app_id=resolve_secret_ref(self.observer_config.channel.app_id_ref, self.environ),
                allow_network=True,
            )
        if self.deploy.mode == "synthetic":
            client = None
        return GeweObserver(
            self.observer_config,
            self.store,
            clock=SystemClock(),
            environ=self.environ,
            readonly_client=client,
        )

    def _serve(self, app, *, background: bool) -> None:
        import uvicorn

        assert self._sock is not None
        config = uvicorn.Config(
            app,
            host=self.deploy.bind_host,
            port=int(self._sock.getsockname()[1]),
            log_level="error",
            access_log=False,
            lifespan="off",
            workers=1,
            reload=False,
        )
        self._server = uvicorn.Server(config)
        self._stop.clear()
        self._supervisor = threading.Thread(target=self._supervise, daemon=True)
        self._supervisor.start()

        def run() -> None:
            assert self._sock is not None and self._server is not None
            self._server.run(sockets=[self._sock])

        if background:
            self._thread = threading.Thread(target=run, daemon=True)
            self._thread.start()
            deadline = time.time() + 5
            while time.time() < deadline and not getattr(self._server, "started", False):
                time.sleep(0.05)
            if not getattr(self._server, "started", False):
                raise ChannelError("listen_failed", "uvicorn did not become ready")
            return
        run()

    def _supervise(self) -> None:
        run = self.store.current_run() or {}
        run_id = str(run.get("run_id") or "")
        while not self._stop.wait(SUPERVISOR_INTERVAL):
            current = self.store.current_run() or {}
            if current.get("status") in {"stopping", "stopped", "failed"}:
                break
            if time.monotonic() >= self._deadline_mono:
                self.store.request_stop("expired", run_id=run_id)
                break
            if int(current.get("sample_count") or 0) >= int(current.get("max_samples") or 0):
                self.store.request_stop("capacity", run_id=run_id)
                break
            if run_id:
                self.store.heartbeat(run_id)
        if run_id:
            self.store.stop("supervisor_exit")
        if self._server is not None:
            self._server.should_exit = True

    def _wait_sqlite_stopped(self, timeout: float) -> bool:
        deadline = time.time() + timeout
        while time.time() < deadline:
            status = (self.store.current_run() or {}).get("status")
            if status in {"stopped", "failed"}:
                return True
            time.sleep(0.05)
        return (self.store.current_run() or {}).get("status") in {"stopped", "failed"}

    def _wait_stopped(self, timeout: float) -> bool:
        deadline = time.time() + timeout
        while time.time() < deadline:
            if self._server is None or not getattr(self._server, "started", False):
                return True
            time.sleep(0.05)
        return not getattr(self._server, "started", False)

    def _cleanup_listen(self) -> None:
        if self._server is not None:
            self._server.should_exit = True
        if self._sock is not None:
            try:
                self._sock.close()
            except OSError:
                pass
            self._sock = None


def describe_observer_status(store: ObserveStore, *, lock_path: Path | None = None, stale_seconds: float = 5.0) -> dict[str, Any]:
    run = store.current_run() or {}
    listen_state = "unknown/stale"
    lifecycle = str(run.get("status") or "stopped")
    if not run:
        listen_state = "stopped"
        lifecycle = "stopped"
    elif run.get("stopped_at") or lifecycle in {"stopped", "failed"}:
        listen_state = "stopped"
    elif lifecycle == "serving":
        heartbeat = run.get("heartbeat_at")
        stale = True
        if heartbeat:
            try:
                moment = datetime.fromisoformat(str(heartbeat).replace("Z", "+00:00"))
                stale = (datetime.now(timezone.utc) - moment).total_seconds() > stale_seconds
            except ValueError:
                stale = True
        pid = run.get("pid")
        alive = pid_is_alive(int(pid)) if pid else False
        if alive and not stale:
            listen_state = "serving"
        else:
            listen_state = "unknown/stale"
            lifecycle = "unknown/stale"
    payload = {
        "target": "observer",
        "run_id": run.get("run_id"),
        "lifecycle": lifecycle,
        "listen_state": listen_state,
        "pid": run.get("pid"),
        "listen_host": run.get("listen_host"),
        "listen_port": run.get("listen_port"),
        "owner_nonce": run.get("owner_nonce"),
        "process_created_at": run.get("process_created_at"),
        "heartbeat_at": run.get("heartbeat_at"),
        "sample_count": run.get("sample_count") or 0,
        "expires_at": run.get("expires_at"),
        "stop_reason": run.get("stop_reason"),
        "schema_version": run.get("schema_version"),
        "network": False,
        "model": False,
        "send": False,
        "counters": store.counters(),
    }
    text = json.dumps(payload, ensure_ascii=False, default=str)
    if "callbacks/gewe/" in text:
        raise AssertionError("status must not include callback secrets")
    return payload


def pid_is_alive(pid: int) -> bool:
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


def _bind_loopback(host: str, port: int, queue_depth: int) -> socket.socket:
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        if os.name != "nt":
            sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind((host, port))
        sock.listen(queue_depth)
        return sock
    except OSError:
        sock.close()
        raise ConfigError(f"loopback port {host}:{port} is unavailable")


def _lock_nb(fd: int) -> None:
    if os.name == "nt":
        import msvcrt

        msvcrt.locking(fd, msvcrt.LK_NBLCK, 1)
        return
    import fcntl

    fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)


def _unlock(fd: int) -> None:
    if os.name == "nt":
        import msvcrt

        try:
            os.lseek(fd, 0, os.SEEK_SET)
            msvcrt.locking(fd, msvcrt.LK_UNLCK, 1)
        except OSError:
            return
        return
    import fcntl

    fcntl.flock(fd, fcntl.LOCK_UN)
