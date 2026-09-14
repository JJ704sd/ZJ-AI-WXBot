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
    mode = str(raw.get("mode") or "offline")
    if mode not in ("offline", "read_only", "draft_only", "manual_send"):
        raise ConfigError(f"unsupported mode {mode!r}; auto_send is not implemented")
    account = dict(raw.get("account") or {})
    group = dict(raw.get("group") or {})
    model = dict(raw.get("model") or {})
    adapters = dict(raw.get("adapters") or {})
    base = source_path.parent if source_path else Path.cwd()
    data_dir = Path(str(raw.get("data_dir") or ".local/poc"))
    if not data_dir.is_absolute():
        data_dir = (base / data_dir).resolve() if source_path else data_dir
    data_root_value = account.get("data_root") or raw.get("data_root") or ""
    data_root = Path(str(data_root_value)).expanduser() if data_root_value else None
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
    return AppConfig(
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
            "Late or backfilled messages older than checkpoint minus lookback_seconds "
            "are marked historical and are not auto-queued for reply."
        ),
        source_path=source_path,
    )


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
        missing.append("account.authorized_key_ref")
    return missing


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


def isoformat(moment: datetime | None = None) -> str:
    value = moment or utcnow()
    return value.astimezone(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
