from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Literal, Mapping
import tomllib

from wechat_agent_poc.config import ConfigError

API_CONFIG_VERSION = "api-config/1"
API_EVENT_CONTRACT = "wechat-api-event/1"
SPEC_VERSION = "poc-v0.5"
PROFILES = ("offline", "observe", "bounded_agent")
STAGES = ("A1", "A2a", "A2b", "A2c", "A3", "A4")
IMPLEMENTED_PROVIDERS = frozenset({"fake", "geweapi"})
IMPLEMENTED_MODELS = frozenset({"mock"})
KNOWN_ALLOW_FLAGS = frozenset({"allow_live_read", "allow_live_send"})
PLACEHOLDER_KEYS = frozenset({"", "todo", "changeme", "your-id", "example", "placeholder"})

TOP_KEYS = frozenset(
    {
        "config_version",
        "profile",
        "allow_live_read",
        "allow_live_send",
        "authorization_ref",
        "state_path",
        "evidence_root",
        "channel",
        "binding",
        "agent",
        "run",
        "inquiry",
    }
)
CHANNEL_KEYS = frozenset(
    {
        "provider",
        "contract_version",
        "base_url_ref",
        "credential_ref",
        "provider_profile_path",
        "app_id_ref",
        "callback_bridge_token_ref",
    }
)
BINDING_KEYS = frozenset({"account_key", "conversation_key", "binding_version"})
AGENT_KEYS = frozenset(
    {
        "model_provider",
        "credential_ref",
        "max_input_chars",
        "max_output_chars",
        "context_max_chars",
        "model_timeout_seconds",
    }
)
RUN_KEYS = frozenset({"stage", "max_seconds", "member_cooldown_seconds"})
INQUIRY_KEYS = frozenset(
    {
        "enabled",
        "schedule_kind",
        "delay_seconds",
        "start_grace_seconds",
        "timezone",
        "template_id",
        "target_keys",
        "session_seconds",
        "max_followup_attempts",
    }
)

TECHNICAL_TEMPLATE_ID = "connectivity_receipt_and_willingness_v1"
TECHNICAL_TEMPLATE_TEXT = (
    "这是一条 Agent 接入测试。请回复是否收到本条消息，以及现在是否方便继续测试；无需提供业务信息。"
)
REQUIRED_SLOTS = ("receipt", "willingness")
SLOT_VALUES = ("true", "false", "unknown")


@dataclass(frozen=True)
class StageLimits:
    max_seconds: int
    model_total: int
    model_passive: int
    model_active: int
    send_passive: int
    send_ack: int
    send_mention_per_target: int
    send_active_initial_per_target: int
    send_active_followup_per_target: int

    def send_total(self, target_count: int) -> int:
        if self.send_ack:
            return self.send_ack
        if self.send_mention_per_target:
            return self.send_mention_per_target * max(target_count, 0)
        return self.send_passive + (
            self.send_active_initial_per_target + self.send_active_followup_per_target
        ) * max(target_count, 0)

    def send_active(self, target_count: int) -> int:
        return (
            self.send_active_initial_per_target + self.send_active_followup_per_target
        ) * max(target_count, 0)


STAGE_LIMITS: dict[str, StageLimits] = {
    "A1": StageLimits(1800, 0, 0, 0, 0, 0, 0, 0, 0),
    "A2a": StageLimits(1800, 0, 0, 0, 0, 0, 0, 0, 0),
    "A2b": StageLimits(1800, 0, 0, 0, 0, 3, 0, 0, 0),
    "A2c": StageLimits(600, 0, 0, 0, 0, 0, 1, 0, 0),
    "A3": StageLimits(1800, 10, 10, 0, 10, 0, 0, 0, 0),
    "A4": StageLimits(1800, 30, 10, 20, 10, 0, 0, 1, 3),
}


@dataclass(frozen=True)
class ChannelSettings:
    provider: str
    contract_version: str
    base_url_ref: str
    credential_ref: str
    provider_profile_path: Path | None
    app_id_ref: str = ""
    callback_bridge_token_ref: str = ""


@dataclass(frozen=True)
class BindingSettings:
    account_key: str
    conversation_key: str
    binding_version: str


@dataclass(frozen=True)
class AgentSettings:
    model_provider: str
    credential_ref: str
    max_input_chars: int
    max_output_chars: int
    context_max_chars: int
    model_timeout_seconds: float


@dataclass(frozen=True)
class RunSettings:
    stage: str
    max_seconds: int
    member_cooldown_seconds: int


@dataclass(frozen=True)
class InquirySettings:
    enabled: bool
    schedule_kind: str
    delay_seconds: int
    start_grace_seconds: int
    timezone: str
    template_id: str
    target_keys: tuple[str, ...]
    session_seconds: int
    max_followup_attempts: int


@dataclass(frozen=True)
class ApiConfig:
    config_version: str
    profile: Literal["offline", "observe", "bounded_agent"]
    allow_live_read: bool
    allow_live_send: bool
    authorization_ref: str
    state_path: Path
    evidence_root: Path
    channel: ChannelSettings
    binding: BindingSettings
    agent: AgentSettings
    run: RunSettings
    inquiry: InquirySettings
    source_path: Path | None = None

    @property
    def limits(self) -> StageLimits:
        return STAGE_LIMITS[self.run.stage]

    @property
    def target_count(self) -> int:
        return len(self.inquiry.target_keys)

    @property
    def live_requested(self) -> bool:
        return self.profile != "offline" or self.allow_live_read or self.allow_live_send


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


def isoformat(moment: datetime | None = None) -> str:
    value = (moment or utcnow()).astimezone(timezone.utc)
    return value.replace(microsecond=0).isoformat().replace("+00:00", "Z")


def parse_iso(value: str) -> datetime:
    text = value.strip()
    if text.endswith("Z"):
        text = text[:-1] + "+00:00"
    parsed = datetime.fromisoformat(text)
    if parsed.tzinfo is None:
        parsed = parsed.replace(tzinfo=timezone.utc)
    return parsed.astimezone(timezone.utc)


def load_api_config(path: str | Path) -> ApiConfig:
    config_path = Path(path)
    with config_path.open("rb") as handle:
        raw = tomllib.load(handle)
    return parse_api_config(raw, source_path=config_path)


def parse_api_config(raw: Mapping[str, Any], source_path: Path | None = None) -> ApiConfig:
    if not isinstance(raw, Mapping):
        raise ConfigError("api-config/1 must be a table")
    if "mode" in raw and "config_version" not in raw:
        raise ConfigError("refusing old PoC config; api_cli requires config_version=api-config/1")
    _reject_unknown(raw, TOP_KEYS)
    _reject_misplaced_allows(raw)
    version = str(raw.get("config_version") or "")
    if version != API_CONFIG_VERSION:
        raise ConfigError(f"unsupported config_version {version!r}; expected {API_CONFIG_VERSION}")
    profile = str(raw.get("profile") or "offline")
    if profile not in PROFILES:
        raise ConfigError(f"unsupported profile {profile!r}")
    allow_live_read = _strict_bool(raw.get("allow_live_read", False), "allow_live_read")
    allow_live_send = _strict_bool(raw.get("allow_live_send", False), "allow_live_send")
    authorization_ref = str(raw.get("authorization_ref") or "")
    channel_raw = _table(raw.get("channel"), "channel")
    binding_raw = _table(raw.get("binding"), "binding")
    agent_raw = _table(raw.get("agent"), "agent")
    run_raw = _table(raw.get("run"), "run")
    inquiry_raw = _table(raw.get("inquiry"), "inquiry")
    _reject_unknown(channel_raw, CHANNEL_KEYS, "channel.")
    _reject_unknown(binding_raw, BINDING_KEYS, "binding.")
    _reject_unknown(agent_raw, AGENT_KEYS, "agent.")
    _reject_unknown(run_raw, RUN_KEYS, "run.")
    _reject_unknown(inquiry_raw, INQUIRY_KEYS, "inquiry.")

    provider = str(channel_raw.get("provider") or "")
    if provider not in IMPLEMENTED_PROVIDERS:
        raise ConfigError(
            f"unknown or unverified provider {provider!r}; implemented backends are fake and geweapi; "
            "do not treat undocumented vendor names as available backends"
        )
    contract = str(channel_raw.get("contract_version") or "")
    if contract != API_EVENT_CONTRACT:
        raise ConfigError(f"unsupported channel.contract_version {contract!r}")
    model_provider = str(agent_raw.get("model_provider") or "")
    if model_provider not in IMPLEMENTED_MODELS:
        raise ConfigError(
            f"unsupported agent.model_provider {model_provider!r}; A1 implements only mock"
        )
    stage = str(run_raw.get("stage") or "A1")
    if stage not in STAGES:
        raise ConfigError(f"unsupported run.stage {stage!r}")
    schedule_kind = str(inquiry_raw.get("schedule_kind") or "once_after")
    if schedule_kind == "recurring":
        raise ConfigError("schedule_kind=recurring is reserved and refused in this version")
    if schedule_kind != "once_after":
        raise ConfigError(f"unsupported inquiry.schedule_kind {schedule_kind!r}")

    base = source_path.parent if source_path else Path.cwd()
    state_path = _resolve_path(raw.get("state_path") or ".local/api-agent/state.sqlite", base)
    evidence_root = _resolve_path(raw.get("evidence_root") or ".local/api-agent/runs", base)
    profile_value = channel_raw.get("provider_profile_path") or ""
    profile_path = _resolve_path(profile_value, base) if profile_value else None
    target_keys = tuple(str(item) for item in (inquiry_raw.get("target_keys") or ()))
    inquiry_enabled = _strict_bool(inquiry_raw.get("enabled", False), "inquiry.enabled")
    max_seconds = int(run_raw.get("max_seconds") or STAGE_LIMITS[stage].max_seconds)
    limits = STAGE_LIMITS[stage]
    if max_seconds > limits.max_seconds:
        raise ConfigError("run.max_seconds cannot exceed the stage cap")
    if inquiry_enabled and stage != "A4":
        raise ConfigError("inquiry.enabled is only allowed for stage A4")
    if inquiry_enabled and not target_keys:
        raise ConfigError("inquiry.enabled requires non-empty inquiry.target_keys")
    if any(_is_placeholder(item) for item in target_keys):
        raise ConfigError("inquiry.target_keys cannot use placeholder values")
    template_id = str(inquiry_raw.get("template_id") or TECHNICAL_TEMPLATE_ID)
    if template_id != TECHNICAL_TEMPLATE_ID:
        raise ConfigError("only the technical acceptance template is allowed in this version")
    delay_seconds = int(inquiry_raw.get("delay_seconds") or 120)
    if delay_seconds != 120:
        raise ConfigError("inquiry.delay_seconds is fixed at 120 for this version")
    session_seconds = int(inquiry_raw.get("session_seconds") or 600)
    if session_seconds > 600:
        raise ConfigError("inquiry.session_seconds cannot exceed 600")
    followups = int(inquiry_raw.get("max_followup_attempts") or 3)
    if followups > 3:
        raise ConfigError("inquiry.max_followup_attempts cannot exceed 3")
    cooldown = int(run_raw.get("member_cooldown_seconds") or 10)
    if cooldown < 10:
        raise ConfigError("run.member_cooldown_seconds cannot be lower than 10")

    binding = BindingSettings(
        account_key=str(binding_raw.get("account_key") or ""),
        conversation_key=str(binding_raw.get("conversation_key") or ""),
        binding_version=str(binding_raw.get("binding_version") or ""),
    )
    config = ApiConfig(
        config_version=version,
        profile=profile,  # type: ignore[arg-type]
        allow_live_read=allow_live_read,
        allow_live_send=allow_live_send,
        authorization_ref=authorization_ref,
        state_path=state_path,
        evidence_root=evidence_root,
        channel=ChannelSettings(
            provider=provider,
            contract_version=contract,
            base_url_ref=str(channel_raw.get("base_url_ref") or ""),
            credential_ref=str(channel_raw.get("credential_ref") or ""),
            provider_profile_path=profile_path,
            app_id_ref=str(channel_raw.get("app_id_ref") or ""),
            callback_bridge_token_ref=str(channel_raw.get("callback_bridge_token_ref") or ""),
        ),
        binding=binding,
        agent=AgentSettings(
            model_provider=model_provider,
            credential_ref=str(agent_raw.get("credential_ref") or ""),
            max_input_chars=int(agent_raw.get("max_input_chars") or 2000),
            max_output_chars=int(agent_raw.get("max_output_chars") or 300),
            context_max_chars=int(agent_raw.get("context_max_chars") or 8000),
            model_timeout_seconds=float(agent_raw.get("model_timeout_seconds") or 12),
        ),
        run=RunSettings(stage=stage, max_seconds=max_seconds, member_cooldown_seconds=cooldown),
        inquiry=InquirySettings(
            enabled=inquiry_enabled,
            schedule_kind=schedule_kind,
            delay_seconds=delay_seconds,
            start_grace_seconds=int(inquiry_raw.get("start_grace_seconds") or 10),
            timezone=str(inquiry_raw.get("timezone") or "Asia/Shanghai"),
            template_id=template_id,
            target_keys=target_keys,
            session_seconds=session_seconds,
            max_followup_attempts=followups,
        ),
        source_path=source_path,
    )
    _assert_profile_lock(config)
    return config


def live_arm_blockers(config: ApiConfig) -> list[str]:
    blockers: list[str] = []
    if config.profile == "offline":
        blockers.append("profile=offline cannot arm live")
    if _is_placeholder(config.binding.account_key):
        blockers.append("binding.account_key missing")
    if _is_placeholder(config.binding.conversation_key):
        blockers.append("binding.conversation_key missing")
    if _is_placeholder(config.binding.binding_version):
        blockers.append("binding.binding_version missing")
    if not (config.authorization_ref or "").strip():
        blockers.append("authorization_ref missing")
    if config.allow_live_send and config.profile != "bounded_agent":
        blockers.append("allow_live_send requires profile=bounded_agent")
    if config.allow_live_read and config.profile == "offline":
        blockers.append("allow_live_read requires observe or bounded_agent")
    if config.inquiry.enabled and not config.inquiry.target_keys:
        blockers.append("live inquiry requires mapped target_keys")
    if config.channel.provider == "fake":
        blockers.append("fake provider cannot arm live wechat")
    elif config.channel.provider == "geweapi":
        if not (config.channel.base_url_ref or "").strip():
            blockers.append("channel.base_url_ref missing")
        if not (config.channel.credential_ref or "").strip():
            blockers.append("channel.credential_ref missing")
        if not (config.channel.app_id_ref or "").strip():
            blockers.append("channel.app_id_ref missing")
        if not (config.channel.callback_bridge_token_ref or "").strip():
            blockers.append("callback_bridge_token_ref missing; GeWe webhook has no documented signature")
        blockers.append("geweapi mixed-group native @ receive is undocumented")
        blockers.append("geweapi history/sync flag is undocumented")
    return blockers


def agent_blockers(config: ApiConfig) -> list[str]:
    """Auto-reply / Agent live conditions. Mention and history gaps stay here."""
    return live_arm_blockers(config)


def _assert_profile_lock(config: ApiConfig) -> None:
    if config.profile == "offline" and (config.allow_live_read or config.allow_live_send):
        raise ConfigError("offline profile cannot set live switches")
    if config.allow_live_send and config.profile != "bounded_agent":
        raise ConfigError("allow_live_send requires profile=bounded_agent")
    if config.profile != "offline" and live_arm_blockers(config):
        # observe/bounded_agent may be authored before identities exist, but empty
        # keys cannot enable live. Parsing still succeeds so api-check can report.
        return
    if config.live_requested and live_arm_blockers(config) and config.profile != "offline":
        return


def _reject_unknown(raw: Mapping[str, Any], allowed: frozenset[str], prefix: str = "") -> None:
    for key in raw:
        name = str(key)
        if name not in allowed:
            if name.startswith("allow_"):
                raise ConfigError(f"unknown or misplaced allow flag {prefix}{name}")
            raise ConfigError(f"unknown field {prefix}{name}")


def _reject_misplaced_allows(raw: Mapping[str, Any]) -> None:
    for key, value in raw.items():
        if str(key).startswith("allow_") and str(key) not in KNOWN_ALLOW_FLAGS:
            raise ConfigError(f"unknown allow_* flag {key!r}; refusing to ignore an unimplemented switch")
        if isinstance(value, Mapping):
            for nested in value:
                if str(nested).startswith("allow_"):
                    raise ConfigError(
                        f"nested allow flag {key}.{nested} is misplaced and cannot arm live paths"
                    )


def _table(value: Any, name: str) -> dict[str, Any]:
    if value is None:
        return {}
    if not isinstance(value, Mapping):
        raise ConfigError(f"{name} must be a table")
    return dict(value)


def _strict_bool(value: Any, name: str) -> bool:
    if isinstance(value, bool):
        return value
    raise ConfigError(f"{name} must be a boolean")


def _resolve_path(value: Any, base: Path) -> Path:
    path = Path(str(value))
    if not path.is_absolute():
        path = (base / path).resolve()
    return path


def _is_placeholder(value: str) -> bool:
    return str(value or "").strip().lower() in PLACEHOLDER_KEYS
