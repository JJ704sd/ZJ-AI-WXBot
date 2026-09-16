from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Any, Literal, Mapping
import os
import tomllib

from wechat_agent_poc.api_config import _is_placeholder, _reject_unknown, _strict_bool, _table
from wechat_agent_poc.config import ConfigError

OBSERVER_CONFIG_VERSION = "observer-config/1"
INGRESS_MODES = ("none", "callback_bearer", "vendor_signature", "vendor_mtls_or_private")
SOURCE_LEVELS = ("none", "synthetic", "callback_bearer", "vendor_verified")
FORBIDDEN_STORE_MARKERS = ("api-agent/state.sqlite", "poc-state.sqlite")
DEFAULT_MAX_SECONDS = 1800
DEFAULT_MAX_SAMPLES = 200
DEFAULT_MAX_BODY_BYTES = 10 * 1024 * 1024
DEFAULT_RATE = 10
DEFAULT_BURST = 20
MIN_SECRET_BYTES = 32

TOP_KEYS = frozenset(
    {
        "config_version",
        "enabled",
        "allow_live_send",
        "allow_model",
        "allow_network",
        "authorization_ref",
        "bind_host",
        "bind_port",
        "max_seconds",
        "max_samples",
        "max_body_bytes",
        "rate_limit_per_second",
        "burst",
        "ingress",
        "channel",
        "binding",
        "store",
        "probe",
    }
)
INGRESS_KEYS = frozenset({"mode", "callback_secret_ref", "bridge_token_ref", "path_prefix"})
CHANNEL_KEYS = frozenset({"provider", "base_url_ref", "credential_ref", "app_id_ref"})
BINDING_KEYS = frozenset({"account_key", "conversation_key", "binding_version", "candidate_member_keys"})
STORE_KEYS = frozenset({"path"})
PROBE_KEYS = frozenset({"online_interval_seconds", "profile_interval_seconds", "timeout_seconds"})


@dataclass(frozen=True)
class ObserverIngressSettings:
    mode: Literal["none", "callback_bearer", "vendor_signature", "vendor_mtls_or_private"]
    callback_secret_ref: str
    bridge_token_ref: str
    path_prefix: str


@dataclass(frozen=True)
class ObserverChannelSettings:
    provider: str
    base_url_ref: str
    credential_ref: str
    app_id_ref: str


@dataclass(frozen=True)
class ObserverBindingSettings:
    account_key: str
    conversation_key: str
    binding_version: str
    candidate_member_keys: tuple[str, ...]


@dataclass(frozen=True)
class ObserverProbeSettings:
    online_interval_seconds: int
    profile_interval_seconds: int
    timeout_seconds: float


@dataclass(frozen=True)
class ObserverConfig:
    config_version: str
    enabled: bool
    allow_live_send: bool
    allow_model: bool
    allow_network: bool
    authorization_ref: str
    bind_host: str
    bind_port: int
    max_seconds: int
    max_samples: int
    max_body_bytes: int
    rate_limit_per_second: int
    burst: int
    ingress: ObserverIngressSettings
    channel: ObserverChannelSettings
    binding: ObserverBindingSettings
    store_path: Path
    probe: ObserverProbeSettings
    source_path: Path | None = None


def load_observer_config(path: str | Path, *, environ: Mapping[str, str] | None = None) -> ObserverConfig:
    config_path = Path(path)
    raw = tomllib.loads(config_path.read_text(encoding="utf-8"))
    return parse_observer_config(raw, source_path=config_path, environ=environ)


def parse_observer_config(
    raw: Mapping[str, Any],
    *,
    source_path: Path | None = None,
    environ: Mapping[str, str] | None = None,
) -> ObserverConfig:
    if raw.get("config_version") != OBSERVER_CONFIG_VERSION:
        raise ConfigError("observer config must be observer-config/1")
    if raw.get("mode") is not None:
        raise ConfigError("old PoC config is rejected by the observer parser")
    _reject_unknown(raw, TOP_KEYS)
    if _strict_bool(raw.get("allow_live_send", False), "allow_live_send"):
        raise ConfigError("observer forbids allow_live_send=true")
    if _strict_bool(raw.get("allow_model", False), "allow_model"):
        raise ConfigError("observer forbids allow_model=true")
    ingress_raw = _table(raw.get("ingress"), "ingress")
    channel_raw = _table(raw.get("channel"), "channel")
    binding_raw = _table(raw.get("binding"), "binding")
    store_raw = _table(raw.get("store"), "store")
    probe_raw = _table(raw.get("probe"), "probe")
    _reject_unknown(ingress_raw, INGRESS_KEYS, "ingress.")
    _reject_unknown(channel_raw, CHANNEL_KEYS, "channel.")
    _reject_unknown(binding_raw, BINDING_KEYS, "binding.")
    _reject_unknown(store_raw, STORE_KEYS, "store.")
    _reject_unknown(probe_raw, PROBE_KEYS, "probe.")
    mode = str(ingress_raw.get("mode") or "none")
    if mode not in INGRESS_MODES:
        raise ConfigError(f"unsupported ingress.mode {mode!r}")
    if mode == "vendor_signature":
        raise ConfigError("ingress.mode=vendor_signature is unsupported; GeWe signature protocol is not documented")
    if mode == "vendor_mtls_or_private":
        raise ConfigError("ingress.mode=vendor_mtls_or_private is unsupported until the vendor protocol is verified")
    provider = str(channel_raw.get("provider") or "")
    if provider != "geweapi":
        raise ConfigError("observer only implements provider=geweapi")
    bind_host = str(raw.get("bind_host") or "127.0.0.1")
    if bind_host not in {"127.0.0.1", "localhost"}:
        raise ConfigError("observer bind_host must be loopback in this round")
    base = source_path.parent if source_path else Path.cwd()
    store_path = _resolve_store_path(store_raw.get("path") or ".local/gewe-observe/observe.sqlite", base)
    members = tuple(str(item) for item in (binding_raw.get("candidate_member_keys") or ()))
    config = ObserverConfig(
        config_version=OBSERVER_CONFIG_VERSION,
        enabled=_strict_bool(raw.get("enabled", False), "enabled"),
        allow_live_send=False,
        allow_model=False,
        allow_network=_strict_bool(raw.get("allow_network", False), "allow_network"),
        authorization_ref=str(raw.get("authorization_ref") or ""),
        bind_host=bind_host,
        bind_port=int(raw.get("bind_port") or 0),
        max_seconds=int(raw.get("max_seconds") or DEFAULT_MAX_SECONDS),
        max_samples=int(raw.get("max_samples") or DEFAULT_MAX_SAMPLES),
        max_body_bytes=int(raw.get("max_body_bytes") or DEFAULT_MAX_BODY_BYTES),
        rate_limit_per_second=int(raw.get("rate_limit_per_second") or DEFAULT_RATE),
        burst=int(raw.get("burst") or DEFAULT_BURST),
        ingress=ObserverIngressSettings(
            mode=mode,  # type: ignore[arg-type]
            callback_secret_ref=str(ingress_raw.get("callback_secret_ref") or ""),
            bridge_token_ref=str(ingress_raw.get("bridge_token_ref") or ""),
            path_prefix=str(ingress_raw.get("path_prefix") or "/callbacks/gewe"),
        ),
        channel=ObserverChannelSettings(
            provider=provider,
            base_url_ref=str(channel_raw.get("base_url_ref") or ""),
            credential_ref=str(channel_raw.get("credential_ref") or ""),
            app_id_ref=str(channel_raw.get("app_id_ref") or ""),
        ),
        binding=ObserverBindingSettings(
            account_key=str(binding_raw.get("account_key") or ""),
            conversation_key=str(binding_raw.get("conversation_key") or ""),
            binding_version=str(binding_raw.get("binding_version") or ""),
            candidate_member_keys=members,
        ),
        store_path=store_path,
        probe=ObserverProbeSettings(
            online_interval_seconds=int(probe_raw.get("online_interval_seconds") or 15),
            profile_interval_seconds=int(probe_raw.get("profile_interval_seconds") or 60),
            timeout_seconds=float(probe_raw.get("timeout_seconds") or 8),
        ),
        source_path=source_path,
    )
    if config.max_seconds > DEFAULT_MAX_SECONDS:
        raise ConfigError("max_seconds cannot exceed 1800")
    if config.max_samples > DEFAULT_MAX_SAMPLES:
        raise ConfigError("max_samples cannot exceed 200")
    if config.max_body_bytes > DEFAULT_MAX_BODY_BYTES:
        raise ConfigError("max_body_bytes cannot exceed 10 MiB")
    return config


def resolve_secret_ref(ref: str, environ: Mapping[str, str] | None = None) -> str:
    env = environ if environ is not None else os.environ
    text = (ref or "").strip()
    if not text:
        return ""
    if text.startswith("value:") or text.startswith("literal:"):
        raise ConfigError("credentials must come from env refs, not inline config")
    if text.startswith("env:"):
        return str(env.get(text[4:], "") or "")
    return str(env.get(text, "") or "")


def observe_blockers(config: ObserverConfig, *, environ: Mapping[str, str] | None = None) -> list[str]:
    blockers: list[str] = []
    if not config.enabled:
        blockers.append("observer.enabled is false")
    if config.allow_live_send:
        blockers.append("allow_live_send is forbidden on the observer")
    if config.allow_model:
        blockers.append("allow_model is forbidden on the observer")
    if not (config.authorization_ref or "").strip():
        blockers.append("authorization_ref missing")
    if _is_placeholder(config.binding.account_key):
        blockers.append("binding.account_key missing")
    if _is_placeholder(config.binding.conversation_key):
        blockers.append("binding.conversation_key missing")
    if _is_placeholder(config.binding.binding_version):
        blockers.append("binding.binding_version missing")
    if config.ingress.mode == "none" and config.allow_network:
        blockers.append("ingress.mode=none cannot sample live callbacks")
    if config.ingress.mode == "callback_bearer":
        secret = resolve_secret_ref(config.ingress.callback_secret_ref, environ)
        bridge = resolve_secret_ref(config.ingress.bridge_token_ref, environ)
        if len(secret.encode("utf-8")) < MIN_SECRET_BYTES:
            blockers.append("callback secret missing or shorter than 32 bytes")
        if len(bridge.encode("utf-8")) < MIN_SECRET_BYTES:
            blockers.append("internal bridge token missing or shorter than 32 bytes")
        if secret and bridge and secret == bridge:
            blockers.append("callback secret and bridge token must be different")
    if config.allow_network:
        base = resolve_secret_ref(config.channel.base_url_ref, environ)
        token = resolve_secret_ref(config.channel.credential_ref, environ)
        app_id = resolve_secret_ref(config.channel.app_id_ref, environ)
        if not base:
            blockers.append("channel.base_url_ref missing")
        elif not base.startswith("https://"):
            blockers.append("live GeWe API root must be HTTPS; documented http://api.geweapi.com cannot carry tokens")
        if not token:
            blockers.append("channel.credential_ref missing")
        if not app_id:
            blockers.append("channel.app_id_ref missing")
    return blockers


def agent_blockers_note() -> str:
    return (
        "observe_blockers do not require mention or history rules; "
        "agent/live_arm_blockers still include undocumented @ receive and history flags"
    )


def _resolve_store_path(value: Any, base: Path) -> Path:
    path = Path(str(value))
    if not path.is_absolute():
        path = (base / path).resolve()
    lowered = str(path).replace("\\", "/").lower()
    if lowered.endswith("/api-agent/state.sqlite") or lowered.endswith("/state.sqlite") and "api-agent" in lowered:
        raise ConfigError("observer sqlite cannot reuse api-agent/state.sqlite")
    for marker in FORBIDDEN_STORE_MARKERS:
        if marker in lowered:
            raise ConfigError("observer sqlite path collides with an agent or old PoC store")
    return path
