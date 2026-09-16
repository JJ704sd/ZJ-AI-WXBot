from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Any, Literal, Mapping
import json
import os
import tomllib

from wechat_agent_poc.api_config import (
    _is_placeholder,
    _reject_unknown,
    _resolve_path,
    _strict_bool,
    _table,
)
from wechat_agent_poc.config import ConfigError

PAD_CONFIG_VERSION = "pad-config/1"
PAD_PROFILE_VERSION = "pad-provider-profile/1"
PAD_PROVIDER = "wechatpadpro"
API_FLAVORS = ("legacy", "MAX")
INGRESS_MODES = ("none", "synthetic_private", "private_gateway")
CAPABILITY_STATUSES = frozenset({"documented", "observed", "unknown", "unsupported"})
DEFAULT_MAX_SECONDS = 1800
DEFAULT_MAX_SAMPLES = 200
DEFAULT_MAX_BODY_BYTES = 256 * 1024
DEFAULT_MAX_BATCH = 100
FORBIDDEN_STORE_MARKERS = (
    "api-agent/state.sqlite",
    "poc-state.sqlite",
    "gewe-observe",
)
P0_LOCK_FIELDS = (
    "release_tag",
    "build_id",
    "download_source",
    "binary_sha256_or_digest",
    "docs_export_sha256",
    "data_paths",
    "license_fee_validity",
    "observed_at",
)

TOP_KEYS = frozenset(
    {
        "config_version",
        "enabled",
        "live",
        "allow_live_send",
        "allow_model",
        "allow_network",
        "authorization_ref",
        "api_flavor",
        "provider_profile_path",
        "credential_ref",
        "signature_secret_ref",
        "observation_store_path",
        "agent_state_path",
        "evidence_root",
        "lock_path",
        "bind_host",
        "bind_port",
        "max_seconds",
        "max_samples",
        "max_body_bytes",
        "max_batch_messages",
        "binding",
        "ingress",
        "readonly",
    }
)
BINDING_KEYS = frozenset({"account_key", "conversation_key", "binding_version"})
INGRESS_KEYS = frozenset({"mode"})
READONLY_KEYS = frozenset({"base_url_ref"})
PROFILE_TOP_KEYS = frozenset(
    {
        "schema_version",
        "generated_at",
        "spec_version",
        "provider",
        "api_flavor",
        "p0_closed",
        "note",
        "product",
        "capabilities",
        "hmac",
        "observed_live",
    }
)
PRODUCT_KEYS = frozenset(
    {
        "family",
        "release_tag",
        "build_id",
        "download_source",
        "binary_sha256_or_digest",
        "docs_export_sha256",
        "protocol_api_version",
        "os",
        "runtime_dependencies",
        "config_summary",
        "auth_form",
        "data_paths",
        "license_fee_validity",
        "sample_refs",
        "observed_at",
    }
)
REQUIRED_CAPABILITIES = frozenset(
    {
        "webhook_v1",
        "webhook_v2",
        "real_mention_receive",
        "history_flag",
        "send_txt",
        "native_at_encoding",
        "type_enum",
        "self_identity_response",
        "online_response",
        "metadata_hmac",
        "payload_integrity",
        "group_text_sender_prefix",
        "builtin_automation_off",
    }
)
HMAC_KEYS = frozenset({"algorithm", "covers_data", "official_vectors", "local_computed"})
STATUS_OBJECT_KEYS = frozenset(
    {
        "status",
        "value",
        "note",
        "source",
        "kind",
        "covers_data",
        "meets_v05",
        "official_vectors",
        "measured_at",
    }
)
OBSERVED_LIVE_KEYS = frozenset({"login", "callback_sample", "mixed_group", "send", "build_lock"})


@dataclass(frozen=True)
class PadBindingSettings:
    account_key: str
    conversation_key: str
    binding_version: str


@dataclass(frozen=True)
class PadIngressSettings:
    mode: Literal["none", "synthetic_private", "private_gateway"]


@dataclass(frozen=True)
class PadReadonlySettings:
    base_url_ref: str


@dataclass(frozen=True)
class PadProviderProfile:
    schema_version: str
    api_flavor: str
    p0_closed: bool
    provider: str
    product: dict[str, Any]
    capabilities: dict[str, Any]
    hmac: dict[str, Any]
    observed_live: dict[str, Any]
    source_path: Path | None = None

    def capability_status(self, name: str) -> str:
        item = self.capabilities.get(name) or {}
        return str(item.get("status") or "unknown")


@dataclass(frozen=True)
class PadConfig:
    config_version: str
    enabled: bool
    live: bool
    allow_live_send: bool
    allow_model: bool
    allow_network: bool
    authorization_ref: str
    api_flavor: str
    provider_profile_path: Path
    credential_ref: str
    signature_secret_ref: str
    observation_store_path: Path
    agent_state_path: Path
    evidence_root: Path
    lock_path: Path
    bind_host: str
    bind_port: int
    max_seconds: int
    max_samples: int
    max_body_bytes: int
    max_batch_messages: int
    binding: PadBindingSettings
    ingress: PadIngressSettings
    readonly: PadReadonlySettings
    profile: PadProviderProfile
    source_path: Path | None = None


def load_pad_config(path: str | Path, *, environ: Mapping[str, str] | None = None) -> PadConfig:
    config_path = Path(path)
    raw = tomllib.loads(config_path.read_text(encoding="utf-8"))
    return parse_pad_config(raw, source_path=config_path, environ=environ)


def parse_pad_config(
    raw: Mapping[str, Any],
    *,
    source_path: Path | None = None,
    environ: Mapping[str, str] | None = None,
    profile: PadProviderProfile | None = None,
) -> PadConfig:
    if not isinstance(raw, Mapping):
        raise ConfigError("pad-config/1 must be a table")
    if "mode" in raw and "config_version" not in raw:
        raise ConfigError("refusing old PoC config; pad CLI requires config_version=pad-config/1")
    if raw.get("config_version") == "api-config/1":
        raise ConfigError("pad CLI rejects api-config/1; use pad-config/1")
    if raw.get("config_version") != PAD_CONFIG_VERSION:
        raise ConfigError(f"unsupported config_version {raw.get('config_version')!r}; expected {PAD_CONFIG_VERSION}")
    _reject_unknown(raw, TOP_KEYS)
    if _strict_bool(raw.get("allow_live_send", False), "allow_live_send"):
        raise ConfigError("pad-config/1 forbids allow_live_send=true")
    if _strict_bool(raw.get("allow_model", False), "allow_model"):
        raise ConfigError("pad-config/1 forbids allow_model=true")
    live = _strict_bool(raw.get("live", False), "live")
    flavor = str(raw.get("api_flavor") or "")
    if flavor not in API_FLAVORS:
        raise ConfigError(f"api_flavor must be legacy or MAX, not {flavor!r}")
    binding_raw = _table(raw.get("binding"), "binding")
    ingress_raw = _table(raw.get("ingress"), "ingress")
    readonly_raw = _table(raw.get("readonly"), "readonly")
    _reject_unknown(binding_raw, BINDING_KEYS, "binding.")
    _reject_unknown(ingress_raw, INGRESS_KEYS, "ingress.")
    _reject_unknown(readonly_raw, READONLY_KEYS, "readonly.")
    mode = str(ingress_raw.get("mode") or "none")
    if mode not in INGRESS_MODES:
        raise ConfigError(f"unsupported ingress.mode {mode!r}")
    bind_host = str(raw.get("bind_host") or "127.0.0.1")
    if bind_host not in {"127.0.0.1", "localhost"}:
        raise ConfigError("pad bind_host must be loopback in this round")
    base = source_path.parent if source_path else Path.cwd()
    profile_path = _resolve_path(raw.get("provider_profile_path") or "pad-provider-profile.max.example.json", base)
    loaded = profile or load_pad_provider_profile(profile_path)
    if loaded.api_flavor != flavor:
        raise ConfigError(
            f"pad-config api_flavor={flavor} does not match profile api_flavor={loaded.api_flavor}; "
            "legacy and MAX must not be mixed"
        )
    if loaded.provider != PAD_PROVIDER:
        raise ConfigError(f"pad profile provider must be {PAD_PROVIDER}")
    observation_path = _resolve_pad_store(
        raw.get("observation_store_path") or ".local/pad-observe/observe.sqlite",
        base,
        kind="observation",
    )
    agent_path = _resolve_pad_store(
        raw.get("agent_state_path") or ".local/pad-agent/state.sqlite",
        base,
        kind="agent",
    )
    if observation_path.resolve() == agent_path.resolve():
        raise ConfigError("observation_store_path and agent_state_path must be distinct")
    config = PadConfig(
        config_version=PAD_CONFIG_VERSION,
        enabled=_strict_bool(raw.get("enabled", False), "enabled"),
        live=live,
        allow_live_send=False,
        allow_model=False,
        allow_network=_strict_bool(raw.get("allow_network", False), "allow_network"),
        authorization_ref=str(raw.get("authorization_ref") or ""),
        api_flavor=flavor,
        provider_profile_path=profile_path,
        credential_ref=str(raw.get("credential_ref") or ""),
        signature_secret_ref=str(raw.get("signature_secret_ref") or ""),
        observation_store_path=observation_path,
        agent_state_path=agent_path,
        evidence_root=_resolve_path(raw.get("evidence_root") or ".local/pad-observe/evidence", base),
        lock_path=_resolve_path(raw.get("lock_path") or ".local/pad-observe/observer.lock", base),
        bind_host=bind_host,
        bind_port=int(raw.get("bind_port") or 0),
        max_seconds=int(raw.get("max_seconds") or DEFAULT_MAX_SECONDS),
        max_samples=int(raw.get("max_samples") or DEFAULT_MAX_SAMPLES),
        max_body_bytes=int(raw.get("max_body_bytes") or DEFAULT_MAX_BODY_BYTES),
        max_batch_messages=int(raw.get("max_batch_messages") or DEFAULT_MAX_BATCH),
        binding=PadBindingSettings(
            account_key=str(binding_raw.get("account_key") or ""),
            conversation_key=str(binding_raw.get("conversation_key") or ""),
            binding_version=str(binding_raw.get("binding_version") or ""),
        ),
        ingress=PadIngressSettings(mode=mode),  # type: ignore[arg-type]
        readonly=PadReadonlySettings(base_url_ref=str(readonly_raw.get("base_url_ref") or "")),
        profile=loaded,
        source_path=source_path,
    )
    if config.max_seconds > DEFAULT_MAX_SECONDS:
        raise ConfigError("max_seconds cannot exceed 1800")
    if config.max_samples > DEFAULT_MAX_SAMPLES:
        raise ConfigError("max_samples cannot exceed 200")
    if config.max_body_bytes > DEFAULT_MAX_BODY_BYTES:
        raise ConfigError("max_body_bytes cannot exceed 256 KiB")
    if config.max_batch_messages > DEFAULT_MAX_BATCH or config.max_batch_messages < 1:
        raise ConfigError("max_batch_messages must be between 1 and 100")
    if config.live and not config.profile.p0_closed:
        # Parsing succeeds so check can report; live start is still blocked.
        pass
    return config


def load_pad_provider_profile(path: str | Path) -> PadProviderProfile:
    profile_path = Path(path)
    try:
        raw = json.loads(profile_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ConfigError(f"unreadable pad-provider-profile/1 at {profile_path}") from exc
    return parse_pad_provider_profile(raw, source_path=profile_path)


def parse_pad_provider_profile(raw: Mapping[str, Any], *, source_path: Path | None = None) -> PadProviderProfile:
    if not isinstance(raw, Mapping):
        raise ConfigError("pad-provider-profile/1 must be an object")
    if raw.get("schema_version") == "provider-profile/1":
        raise ConfigError("refusing provider-profile/1; Pad requires pad-provider-profile/1")
    if raw.get("schema_version") != PAD_PROFILE_VERSION:
        raise ConfigError(f"unsupported profile schema_version {raw.get('schema_version')!r}")
    _reject_unknown(raw, PROFILE_TOP_KEYS)
    flavor = str(raw.get("api_flavor") or "")
    if flavor not in API_FLAVORS:
        raise ConfigError(f"profile api_flavor must be legacy or MAX, not {flavor!r}")
    provider = str(raw.get("provider") or "")
    if provider != PAD_PROVIDER:
        raise ConfigError(f"profile provider must be {PAD_PROVIDER}")
    claimed_closed = _strict_bool(raw.get("p0_closed", False), "p0_closed")
    product = _table(raw.get("product"), "product")
    capabilities = _table(raw.get("capabilities"), "capabilities")
    hmac = _table(raw.get("hmac"), "hmac")
    observed_live = _table(raw.get("observed_live"), "observed_live")
    _reject_unknown(product, PRODUCT_KEYS, "product.")
    _reject_unknown(hmac, HMAC_KEYS, "hmac.")
    _reject_unknown(observed_live, OBSERVED_LIVE_KEYS, "observed_live.")
    extra_caps = set(capabilities) - REQUIRED_CAPABILITIES
    if extra_caps:
        raise ConfigError(f"unknown capability {sorted(extra_caps)[0]}")
    missing_caps = REQUIRED_CAPABILITIES - set(capabilities)
    if missing_caps:
        raise ConfigError(f"missing capability {sorted(missing_caps)[0]}")
    for name in PRODUCT_KEYS:
        _status_object(product.get(name), f"product.{name}")
    for name in REQUIRED_CAPABILITIES:
        _status_object(capabilities.get(name), f"capabilities.{name}")
    for name in HMAC_KEYS:
        _status_object(hmac.get(name), f"hmac.{name}")
    if flavor == "MAX" and capabilities["send_txt"].get("status") == "documented":
        value = str(capabilities["send_txt"].get("value") or "")
        if value and "/Msg/SendTxt" not in value:
            raise ConfigError("MAX send_txt documented path must not be rewritten")
    if flavor == "legacy" and capabilities["send_txt"].get("status") == "documented":
        raise ConfigError("legacy profile must not document MAX /Msg/SendTxt as available")
    p0_closed = claimed_closed and _p0_lock_complete(product)
    if claimed_closed and not p0_closed:
        raise ConfigError("p0_closed=true is refused while required product lock fields are unknown")
    return PadProviderProfile(
        schema_version=PAD_PROFILE_VERSION,
        api_flavor=flavor,
        p0_closed=p0_closed,
        provider=provider,
        product=dict(product),
        capabilities=dict(capabilities),
        hmac=dict(hmac),
        observed_live=dict(observed_live),
        source_path=source_path,
    )


def resolve_pad_secret(ref: str, environ: Mapping[str, str] | None = None) -> str:
    env = environ if environ is not None else os.environ
    text = (ref or "").strip()
    if not text:
        return ""
    if text.startswith("value:") or text.startswith("literal:"):
        raise ConfigError("credentials must come from env refs, not inline config")
    if text.startswith("env:"):
        return str(env.get(text[4:], "") or "")
    return str(env.get(text, "") or "")


def pad_observe_blockers(config: PadConfig, *, environ: Mapping[str, str] | None = None) -> list[str]:
    """Hard blockers for starting the offline observer. P0 gaps are reported separately."""
    blockers: list[str] = []
    if not config.enabled:
        blockers.append("pad.enabled is false")
    if config.allow_live_send:
        blockers.append("allow_live_send is forbidden on the pad observer")
    if config.allow_model:
        blockers.append("allow_model is forbidden on the pad observer")
    if config.live:
        blockers.append("live=true is refused until P0 is closed against a locked build")
    if not (config.authorization_ref or "").strip():
        blockers.append("authorization_ref missing")
    if _is_placeholder(config.binding.account_key):
        blockers.append("binding.account_key missing")
    if _is_placeholder(config.binding.conversation_key):
        blockers.append("binding.conversation_key missing")
    if _is_placeholder(config.binding.binding_version):
        blockers.append("binding.binding_version missing")
    if config.ingress.mode == "none":
        blockers.append("ingress.mode=none cannot sample callbacks")
    if config.ingress.mode == "private_gateway" and not config.profile.p0_closed:
        blockers.append("private_gateway ingress requires a locked P0 build")
    if config.allow_network:
        blockers.append("P1 pad observer must not enable allow_network; no gateway binary or live HTTP")
        if not resolve_pad_secret(config.readonly.base_url_ref, environ):
            blockers.append("readonly.base_url_ref missing")
        if not resolve_pad_secret(config.credential_ref, environ):
            blockers.append("credential_ref missing")
    return blockers


def pad_p0_gaps(profile: PadProviderProfile) -> list[str]:
    gaps = []
    for name in P0_LOCK_FIELDS:
        item = profile.product.get(name) or {}
        if item.get("status") != "observed":
            gaps.append(f"product.{name} is {item.get('status')}")
    for name in (
        "webhook_v2",
        "real_mention_receive",
        "history_flag",
        "native_at_encoding",
        "type_enum",
        "self_identity_response",
        "online_response",
        "group_text_sender_prefix",
        "builtin_automation_off",
    ):
        status = profile.capability_status(name)
        if status != "observed":
            gaps.append(f"capabilities.{name} is {status}")
    vectors = profile.hmac.get("official_vectors") or {}
    if vectors.get("value") == "conflict" or vectors.get("status") == "unknown":
        gaps.append("documented HMAC test vectors are conflicting or unknown for this flavor")
    if not profile.p0_closed:
        gaps.append("P0 is not closed: product and capability evidence remains incomplete")
    return gaps


def _p0_lock_complete(product: Mapping[str, Any]) -> bool:
    for name in ("build_id", "binary_sha256_or_digest", "docs_export_sha256", "download_source", "observed_at"):
        if (product.get(name) or {}).get("status") != "observed":
            return False
    return True


def _status_object(value: Any, name: str) -> dict[str, Any]:
    if not isinstance(value, Mapping):
        raise ConfigError(f"{name} must be an object with status")
    _reject_unknown(value, STATUS_OBJECT_KEYS, f"{name}.")
    status = str(value.get("status") or "")
    if status not in CAPABILITY_STATUSES:
        raise ConfigError(f"{name}.status must be one of {sorted(CAPABILITY_STATUSES)}")
    return dict(value)


def _resolve_pad_store(value: Any, base: Path, *, kind: str) -> Path:
    path = _resolve_path(value, base)
    lowered = str(path).replace("\\", "/").lower()
    for marker in FORBIDDEN_STORE_MARKERS:
        if marker in lowered:
            raise ConfigError(f"pad {kind} sqlite path collides with an agent, old PoC, or GeWe store")
    if kind == "observation" and lowered.endswith("/api-agent/state.sqlite"):
        raise ConfigError("pad observation sqlite cannot reuse api-agent/state.sqlite")
    if kind == "observation" and "pad-agent" in lowered and lowered.endswith("state.sqlite"):
        raise ConfigError("pad observation sqlite cannot reuse pad-agent/state.sqlite")
    if kind == "agent" and "pad-observe" in lowered:
        raise ConfigError("pad agent sqlite cannot reuse the observation store")
    return path
