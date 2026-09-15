from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Mapping
import tomllib

from wechat_agent_poc.models import Binding, Mode


class ConfigError(ValueError):
    pass


@dataclass(frozen=True)
class ModelConfig:
    provider: str
    endpoint: str
    model_name: str
    credential_source: str
    timeout_seconds: float = 30.0


@dataclass(frozen=True)
class AdapterConfig:
    reader: str
    sender: str


@dataclass(frozen=True)
class WindowConfig:
    observer: str = "none"
    observation_path: Path | None = None


KNOWN_ALLOW_FLAGS = frozenset(
    {
        "allow_live_read",
        "allow_live_send",
        "allow_live_discovery",
        "allow_key_material_from_live_client",
    }
)


@dataclass(frozen=True)
class AppConfig:
    mode: Mode
    data_dir: Path
    lookback_seconds: int
    context_limit: int
    max_draft_chars: int
    approval_ttl_seconds: int
    binding: Binding
    model: ModelConfig
    adapters: AdapterConfig
    data_root: Path | None
    authorized_key_ref: str
    operator: str
    wechat_version_recorded: str
    receivers: tuple[str, ...]
    coverage_note: str
    source_path: Path | None = None
    allow_live_read: bool = False
    allow_live_send: bool = False
    allow_live_discovery: bool = False
    allow_key_material_from_live_client: bool = False
    authorization_ref: str = ""
    configured_self_sender_key: str = ""
    excluded_wxids: tuple[str, ...] = ()
    run_id: str = ""
    window: WindowConfig = WindowConfig()
    adapters_allow_flags: tuple[str, ...] = ()

    @property
    def store_path(self) -> Path:
        return self.data_dir / "state.sqlite"

    @property
    def whitelist(self) -> frozenset[str]:
        return frozenset({self.binding.conversation_key})


def load_config(path: str | Path) -> AppConfig:
    config_path = Path(path)
    with config_path.open("rb") as handle:
        raw = tomllib.load(handle)
    return parse_config(raw, source_path=config_path)


def parse_config(raw: Mapping[str, Any], source_path: Path | None = None) -> AppConfig:
    for key in raw:
        if str(key).startswith("allow_") and str(key) not in KNOWN_ALLOW_FLAGS:
            raise ConfigError(f"unknown allow_* flag {key!r}; refusing to ignore an unimplemented switch")
    mode = str(raw.get("mode") or "offline")
    if mode not in ("offline", "read_only", "draft_only", "manual_send"):
        raise ConfigError(
            f"unsupported mode {mode!r}; auto_reply_test and scheduled_mention_test are not aliases of existing modes"
        )
    account = dict(raw.get("account") or {})
    group = dict(raw.get("group") or {})
    model = dict(raw.get("model") or {})
    adapters = dict(raw.get("adapters") or {})
    adapter_allow_flags = tuple(str(key) for key in adapters if str(key).startswith("allow_"))
    window_raw = dict(raw.get("window") or {})
    base = source_path.parent if source_path else Path.cwd()
    data_dir = Path(str(raw.get("data_dir") or ".local/poc"))
    if not data_dir.is_absolute():
        data_dir = (base / data_dir).resolve() if source_path else data_dir
    data_root_value = account.get("data_root") or raw.get("data_root") or ""
    data_root = Path(str(data_root_value)).expanduser() if data_root_value else None
    observation_value = window_raw.get("observation_path") or ""
    observation_path = Path(str(observation_value)).expanduser() if observation_value else None
    if observation_path is not None and not observation_path.is_absolute() and source_path is not None:
        observation_path = (base / observation_path).resolve()
    binding = Binding(
        account_alias=str(account.get("alias") or "unconfigured-account"),
        account_wxid=str(account.get("wxid") or ""),
        group_alias=str(group.get("alias") or "unconfigured-group"),
        conversation_key=str(group.get("conversation_key") or ""),
        binding_version=str(group.get("binding_version") or "unversioned"),
        member_features=tuple(str(item) for item in (group.get("member_features") or ())),
        display_name=str(group.get("display_name") or ""),
        required_detail_tokens=tuple(str(item) for item in (group.get("required_detail_tokens") or ())),
        self_sender_key=str(account.get("self_sender_key") or account.get("wxid") or ""),
    )
    configured_self = str(account.get("self_sender_key") or "")
    excluded = tuple(str(item) for item in (account.get("excluded_wxids") or ()))
    config = AppConfig(
        mode=mode,  # type: ignore[arg-type]
        data_dir=data_dir,
        lookback_seconds=int(raw.get("lookback_seconds") or 120),
        context_limit=int(raw.get("context_limit") or 20),
        max_draft_chars=int(raw.get("max_draft_chars") or 500),
        approval_ttl_seconds=int(raw.get("approval_ttl_seconds") or 300),
        binding=binding,
        model=ModelConfig(
            provider=str(model.get("provider") or "mock"),
            endpoint=str(model.get("endpoint") or ""),
            model_name=str(model.get("model_name") or ""),
            credential_source=str(model.get("credential_source") or "none"),
            timeout_seconds=float(model.get("timeout_seconds") or 30),
        ),
        adapters=AdapterConfig(
            reader=str(adapters.get("reader") or "mock"),
            sender=str(adapters.get("sender") or "mock"),
        ),
        data_root=data_root,
        authorized_key_ref=str(account.get("authorized_key_ref") or "none"),
        operator=str(raw.get("operator") or "local-operator"),
        wechat_version_recorded=str(raw.get("wechat_version_recorded") or ""),
        receivers=tuple(str(item) for item in (raw.get("receivers") or ())),
        coverage_note=(
            "First start records metadata only. Late messages older than checkpoint "
            "minus lookback_seconds are a coverage gap and are not auto-queued for reply."
        ),
        source_path=source_path,
        allow_live_read=bool(raw.get("allow_live_read") or False),
        allow_live_send=bool(raw.get("allow_live_send") or False),
        allow_live_discovery=bool(raw.get("allow_live_discovery") or False),
        allow_key_material_from_live_client=bool(raw.get("allow_key_material_from_live_client") or False),
        authorization_ref=str(raw.get("authorization_ref") or ""),
        configured_self_sender_key=configured_self,
        excluded_wxids=excluded,
        run_id=str(raw.get("run_id") or ""),
        window=WindowConfig(
            observer=str(window_raw.get("observer") or "none"),
            observation_path=observation_path,
        ),
        adapters_allow_flags=adapter_allow_flags,
    )
    from wechat_agent_poc.gates import assert_mode_lock

    assert_mode_lock(config)
    return config


def missing_live_fields(config: AppConfig) -> list[str]:
    missing: list[str] = []
    if not config.binding.account_wxid:
        missing.append("account.wxid")
    if config.data_root is None:
        missing.append("account.data_root")
    if not config.binding.conversation_key:
        missing.append("group.conversation_key")
    if not config.binding.member_features:
        missing.append("group.member_features")
    if not config.binding.display_name:
        missing.append("group.display_name")
    if not config.binding.required_detail_tokens:
        missing.append("group.required_detail_tokens")
    if not config.wechat_version_recorded:
        missing.append("wechat_version_recorded")
    if len(config.receivers) < 2:
        missing.append("receivers (wecom + wechat verifiers)")
    if config.model.provider == "http":
        if not config.model.endpoint:
            missing.append("model.endpoint")
        if not config.model.model_name:
            missing.append("model.model_name")
        if config.model.credential_source in ("", "none"):
            missing.append("model.credential_source")
    if config.adapters.reader == "sqlcipher_readonly" and config.authorized_key_ref in ("", "none"):
        if not config.allow_key_material_from_live_client:
            missing.append("account.authorized_key_ref")
    return missing


def missing_open_fields(config: AppConfig) -> list[str]:
    """Fields required to attempt G-OPEN. Internal group keys are intentionally omitted."""
    skip = {
        "group.conversation_key",
        "group.member_features",
        "group.display_name",
        "group.required_detail_tokens",
        "receivers (wecom + wechat verifiers)",
        "model.endpoint",
        "model.model_name",
        "model.credential_source",
    }
    return [item for item in missing_live_fields(config) if item not in skip]


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


def isoformat(moment: datetime | None = None) -> str:
    value = moment or utcnow()
    return value.astimezone(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
