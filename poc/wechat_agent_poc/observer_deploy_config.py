from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Any, Literal, Mapping
import tomllib

from wechat_agent_poc.api_config import _reject_unknown
from wechat_agent_poc.config import ConfigError

DEPLOY_CONFIG_VERSION = "observer-deploy/1"
DEPLOY_MODES = ("synthetic", "live_observe")
TLS_MODES = ("off", "file", "acme")

TOP_KEYS = frozenset(
    {
        "config_version",
        "mode",
        "bind_host",
        "bind_port",
        "external_hostname",
        "tls_mode",
        "tls_cert_file",
        "tls_key_file",
        "max_concurrent_requests",
        "queue_depth",
        "body_read_timeout_seconds",
        "heartbeat_stale_seconds",
        "listen_shutdown_seconds",
        "process_exit_seconds",
        "lock_path",
        "log_dir",
    }
)


@dataclass(frozen=True)
class ObserverDeployConfig:
    config_version: str
    mode: Literal["synthetic", "live_observe"]
    bind_host: str
    bind_port: int
    external_hostname: str
    tls_mode: Literal["off", "file", "acme"]
    tls_cert_file: Path | None
    tls_key_file: Path | None
    max_concurrent_requests: int
    queue_depth: int
    body_read_timeout_seconds: float
    heartbeat_stale_seconds: float
    listen_shutdown_seconds: float
    process_exit_seconds: float
    lock_path: Path
    log_dir: Path
    source_path: Path | None = None


def load_observer_deploy_config(path: str | Path) -> ObserverDeployConfig:
    config_path = Path(path)
    raw = tomllib.loads(config_path.read_text(encoding="utf-8"))
    return parse_observer_deploy_config(raw, source_path=config_path)


def parse_observer_deploy_config(raw: Mapping[str, Any], *, source_path: Path | None = None) -> ObserverDeployConfig:
    if raw.get("config_version") != DEPLOY_CONFIG_VERSION:
        raise ConfigError("deploy config must be observer-deploy/1")
    _reject_unknown(raw, TOP_KEYS)
    mode = str(raw.get("mode") or "synthetic")
    if mode not in DEPLOY_MODES:
        raise ConfigError(f"unsupported deploy mode {mode!r}")
    tls_mode = str(raw.get("tls_mode") or "off")
    if tls_mode not in TLS_MODES:
        raise ConfigError(f"unsupported tls_mode {tls_mode!r}")
    bind_host = str(raw.get("bind_host") or "127.0.0.1")
    if bind_host not in {"127.0.0.1", "localhost"}:
        raise ConfigError("deploy bind_host must be loopback")
    bind_port = int(raw.get("bind_port") or 8765)
    if bind_port <= 0 or bind_port > 65535:
        raise ConfigError("bind_port must be a TCP port")
    base = source_path.parent if source_path else Path.cwd()
    cert = raw.get("tls_cert_file") or ""
    key = raw.get("tls_key_file") or ""
    if tls_mode == "file" and (not cert or not key):
        raise ConfigError("tls_mode=file requires tls_cert_file and tls_key_file")
    if tls_mode == "acme":
        raise ConfigError("tls_mode=acme is reserved for G2c/public deploy and is not enabled")
    lock_path = _resolve(raw.get("lock_path") or ".local/gewe-observe/observer.lock", base)
    log_dir = _resolve(raw.get("log_dir") or ".local/gewe-observe/logs", base)
    return ObserverDeployConfig(
        config_version=DEPLOY_CONFIG_VERSION,
        mode=mode,  # type: ignore[arg-type]
        bind_host=bind_host,
        bind_port=bind_port,
        external_hostname=str(raw.get("external_hostname") or "localhost"),
        tls_mode=tls_mode,  # type: ignore[arg-type]
        tls_cert_file=_resolve(cert, base) if cert else None,
        tls_key_file=_resolve(key, base) if key else None,
        max_concurrent_requests=int(raw.get("max_concurrent_requests") or 8),
        queue_depth=int(raw.get("queue_depth") or 8),
        body_read_timeout_seconds=float(raw.get("body_read_timeout_seconds") or 1.0),
        heartbeat_stale_seconds=float(raw.get("heartbeat_stale_seconds") or 5),
        listen_shutdown_seconds=float(raw.get("listen_shutdown_seconds") or 5),
        process_exit_seconds=float(raw.get("process_exit_seconds") or 10),
        lock_path=lock_path,
        log_dir=log_dir,
        source_path=source_path,
    )


def deploy_blockers(config: ObserverDeployConfig, observer_allow_network: bool) -> list[str]:
    blockers: list[str] = []
    if config.mode == "synthetic" and observer_allow_network:
        blockers.append("synthetic deploy cannot set observer allow_network=true")
    if config.mode == "live_observe" and not observer_allow_network:
        blockers.append("live_observe requires observer allow_network=true and an explicit later G3 authorization")
    if config.max_concurrent_requests < 1 or config.max_concurrent_requests > 32:
        blockers.append("max_concurrent_requests out of range")
    if config.queue_depth < 1 or config.queue_depth > 32:
        blockers.append("queue_depth out of range")
    return blockers


def _resolve(value: Any, base: Path) -> Path:
    path = Path(str(value))
    if not path.is_absolute():
        path = (base / path).resolve()
    return path
