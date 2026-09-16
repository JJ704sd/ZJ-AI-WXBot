from __future__ import annotations

from dataclasses import asdict, dataclass, field
from datetime import datetime, timedelta, timezone
from typing import Any, Literal, Mapping, Protocol
from uuid import uuid4
import json

from wechat_agent_poc.api_config import API_EVENT_CONTRACT, BindingSettings, isoformat, parse_iso
from wechat_agent_poc.clock import Clock, SystemClock

SCHEMA_VERSION = API_EVENT_CONTRACT
MAX_CALLBACK_BYTES = 256 * 1024
IDENTITY_STATUSES = ("resolved", "unknown", "ambiguous")
SELF_STATUSES = ("true", "false", "unknown")
KINDS = ("text", "system", "other")
MENTION_STATUSES = ("structured", "none", "unknown")
HISTORY_STATUSES = ("true", "false", "unknown")
PARSE_STATUSES = ("ok", "unknown", "error")
SUBMIT_STATUSES = ("accepted", "not_submitted", "unknown")
RECEIPT_STATUSES = ("unverified", "verified", "failed")
FAKE_CALLBACK_HEADER = "X-Fake-Token"


class ChannelError(ValueError):
    def __init__(self, code: str, message: str, http_status: int = 400):
        super().__init__(message)
        self.code = code
        self.http_status = http_status


@dataclass(frozen=True)
class ApiMessageV1:
    schema_version: str
    provider: str
    account_key: str
    conversation_key: str
    native_message_id: str
    event_key: str
    session_epoch: str
    occurred_at: str
    received_at: str
    sender_key: str
    identity_status: str
    is_self: str
    kind: str
    text: str | None
    mention_status: str
    mention_keys: tuple[str, ...]
    mention_all: bool
    reply_to_message_id: str | None
    history_status: str
    parse_status: str

    def to_dict(self) -> dict[str, Any]:
        data = asdict(self)
        data["mention_keys"] = list(self.mention_keys)
        return data

    def body_fingerprint(self) -> str:
        payload = {
            "text": self.text,
            "sender_key": self.sender_key,
            "kind": self.kind,
            "mention_keys": list(self.mention_keys),
            "mention_all": self.mention_all,
            "occurred_at": self.occurred_at,
        }
        return json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(",", ":"))


@dataclass(frozen=True)
class MemberMap:
    candidate_ref: str
    member_key: str | None
    status: Literal["resolved", "ambiguous", "not_found", "out_of_scope"]
    display_hint: str = ""


@dataclass(frozen=True)
class ChannelEvidence:
    provider: str
    provider_version: str
    account_key: str
    session_epoch: str
    online: bool
    conversation_exists: bool
    member_maps: tuple[MemberMap, ...]
    observed_at: str
    capabilities: Mapping[str, bool]
    unique_account: bool = True
    unique_conversation: bool = True


@dataclass(frozen=True)
class OutboundCommand:
    action_id: str
    binding_version: str
    account_key: str
    conversation_key: str
    mention_keys: tuple[str, ...]
    text: str
    deadline_at: str
    idempotency_key: str
    native_mention: bool = False


@dataclass(frozen=True)
class SubmitResult:
    status: Literal["accepted", "not_submitted", "unknown"]
    reason: str
    provider_request_id: str | None = None
    provider_message_id: str | None = None
    write_calls: int = 1


@dataclass(frozen=True)
class CallbackAck:
    http_status: int
    code: str
    accepted: bool
    event_key: str | None = None
    details: dict[str, Any] = field(default_factory=dict)


class Channel(Protocol):
    provider: str

    def authenticate_callback(self, headers: Mapping[str, str], body: bytes) -> None: ...
    def normalize(self, raw: Mapping[str, Any], *, received_at: str) -> ApiMessageV1: ...
    def probe(self, binding: BindingSettings) -> ChannelEvidence: ...
    def resolve_members(self, binding: BindingSettings, candidate_refs: tuple[str, ...]) -> tuple[MemberMap, ...]: ...
    def submit(self, command: OutboundCommand) -> SubmitResult: ...


def event_key(provider: str, account_key: str, conversation_key: str, native_message_id: str) -> str:
    return f"{provider}|{account_key}|{conversation_key}|{native_message_id}"


def native_id_as_str(value: Any) -> str:
    if value is None or value is True or value is False:
        raise ChannelError("missing_field", "native_message_id is required")
    if isinstance(value, float):
        raise ChannelError("invalid_native_id", "native_message_id must not pass through float conversion")
    if isinstance(value, int):
        return str(value)
    text = str(value).strip()
    if not text or text.lower() in {"none", "null"}:
        raise ChannelError("missing_field", "native_message_id is required")
    return text


def normalize_api_event(raw: Mapping[str, Any], *, received_at: str, expected_provider: str | None = None) -> ApiMessageV1:
    if not isinstance(raw, Mapping):
        raise ChannelError("invalid_json", "event must be a JSON object")
    schema = str(raw.get("schema_version") or "")
    if schema != SCHEMA_VERSION:
        raise ChannelError("unsupported_version", f"unsupported schema_version {schema!r}")
    required = (
        "provider",
        "account_key",
        "conversation_key",
        "native_message_id",
        "session_epoch",
        "occurred_at",
        "sender_key",
        "identity_status",
        "is_self",
        "kind",
        "mention_status",
        "history_status",
        "parse_status",
    )
    missing = [name for name in required if name not in raw or raw.get(name) in (None, "")]
    if missing:
        raise ChannelError("missing_field", f"missing {','.join(missing)}")
    provider = str(raw["provider"])
    if expected_provider and provider != expected_provider:
        raise ChannelError("provider_mismatch", "provider does not match configured channel")
    native = native_id_as_str(raw.get("native_message_id"))
    account = str(raw["account_key"])
    conversation = str(raw["conversation_key"])
    computed = event_key(provider, account, conversation, native)
    provided_key = raw.get("event_key")
    if provided_key not in (None, "") and str(provided_key) != computed:
        raise ChannelError("event_key_mismatch", "event_key must be provider|account|conversation|native_id")
    identity = _enum(raw.get("identity_status"), IDENTITY_STATUSES, "identity_status")
    is_self = _enum(raw.get("is_self"), SELF_STATUSES, "is_self")
    kind = _enum(raw.get("kind"), KINDS, "kind")
    mention_status = _enum(raw.get("mention_status"), MENTION_STATUSES, "mention_status")
    history_status = _enum(raw.get("history_status"), HISTORY_STATUSES, "history_status")
    parse_status = _enum(raw.get("parse_status"), PARSE_STATUSES, "parse_status")
    mention_keys = tuple(str(item) for item in (raw.get("mention_keys") or ()))
    mention_all = bool(raw.get("mention_all") or False)
    if mention_status == "structured" and not mention_keys and not mention_all:
        mention_status = "none"
    text = raw.get("text")
    if text is not None:
        text = str(text)
    reply_to = raw.get("reply_to_message_id")
    occurred_at = str(raw["occurred_at"])
    parse_iso(occurred_at)
    parse_iso(received_at)
    return ApiMessageV1(
        schema_version=schema,
        provider=provider,
        account_key=account,
        conversation_key=conversation,
        native_message_id=native,
        event_key=computed,
        session_epoch=str(raw["session_epoch"]),
        occurred_at=occurred_at,
        received_at=received_at,
        sender_key=str(raw["sender_key"]),
        identity_status=identity,
        is_self=is_self,
        kind=kind,
        text=text,
        mention_status=mention_status,
        mention_keys=mention_keys,
        mention_all=mention_all,
        reply_to_message_id=None if reply_to in (None, "") else str(reply_to),
        history_status=history_status,
        parse_status=parse_status,
    )


def _enum(value: Any, allowed: tuple[str, ...], name: str) -> str:
    text = str(value or "")
    if text not in allowed:
        raise ChannelError("invalid_field", f"{name} must be one of {allowed}")
    return text


class FakeChannel:
    """In-process channel. One write RPC per submit(); never retries."""

    provider = "fake"
    provider_version = "fake/1"

    def __init__(
        self,
        *,
        token: str = "fake-offline",
        account_key: str = "acct_test",
        conversation_key: str = "conv_test",
        self_key: str = "member_self",
        members: Mapping[str, str] | None = None,
        session_epoch: str = "epoch-1",
        clock: Clock | None = None,
    ):
        self.token = token
        self.account_key = account_key
        self.conversation_key = conversation_key
        self.self_key = self_key
        self.members = dict(members or {"member_self": self_key, "member_a": "member_a", "member_b": "member_b"})
        self.session_epoch = session_epoch
        self.clock = clock or SystemClock()
        self.online = True
        self.conversation_exists = True
        self.unique_account = True
        self.unique_conversation = True
        self.stale_probe_seconds = 0.0
        self.submit_mode: str | Any = "accepted"
        self.write_calls: list[OutboundCommand] = []
        self.write_counts: dict[str, int] = {}
        self.capabilities = {
            "receive_text": True,
            "send_text": True,
            "native_mention": True,
            "group_members_scoped": True,
            "callback_ack": True,
            "replay_cursor": False,
        }

    def authenticate_callback(self, headers: Mapping[str, str], body: bytes) -> None:
        if len(body) > MAX_CALLBACK_BYTES:
            raise ChannelError("payload_too_large", "callback exceeds 256 KiB", 413)
        if body.lstrip().startswith(b"<"):
            raise ChannelError("xml_rejected", "XML callbacks are rejected", 415)
        supplied = headers.get(FAKE_CALLBACK_HEADER) or headers.get("x-fake-token") or ""
        auth = headers.get("Authorization") or headers.get("authorization") or ""
        if auth.lower().startswith("bearer "):
            supplied = supplied or auth[7:].strip()
        if not self.token or supplied != self.token:
            raise ChannelError("auth_failed", "callback authentication failed", 401)

    def normalize(self, raw: Mapping[str, Any], *, received_at: str) -> ApiMessageV1:
        return normalize_api_event(raw, received_at=received_at, expected_provider=self.provider)

    def probe(self, binding: BindingSettings) -> ChannelEvidence:
        observed = self.clock.now() - timedelta(seconds=self.stale_probe_seconds)
        account_ok = binding.account_key in ("", self.account_key)
        conv_ok = binding.conversation_key in ("", self.conversation_key)
        maps = tuple(
            MemberMap(candidate_ref=key, member_key=key, status="resolved")
            for key in self.members
            if key != self.self_key
        )
        return ChannelEvidence(
            provider=self.provider,
            provider_version=self.provider_version,
            account_key=self.account_key,
            session_epoch=self.session_epoch,
            online=self.online and account_ok,
            conversation_exists=self.conversation_exists and conv_ok,
            member_maps=maps,
            observed_at=isoformat(observed),
            capabilities=dict(self.capabilities),
            unique_account=self.unique_account,
            unique_conversation=self.unique_conversation,
        )

    def resolve_members(self, binding: BindingSettings, candidate_refs: tuple[str, ...]) -> tuple[MemberMap, ...]:
        if binding.conversation_key not in ("", self.conversation_key):
            return tuple(MemberMap(ref, None, "out_of_scope") for ref in candidate_refs)
        result: list[MemberMap] = []
        for ref in candidate_refs:
            if ref in self.members:
                result.append(MemberMap(ref, self.members[ref], "resolved"))
            else:
                result.append(MemberMap(ref, None, "not_found"))
        return tuple(result)

    def submit(self, command: OutboundCommand) -> SubmitResult:
        count = self.write_counts.get(command.action_id, 0) + 1
        self.write_counts[command.action_id] = count
        self.write_calls.append(command)
        if count > 1:
            return SubmitResult("unknown", "duplicate_write_forbidden", write_calls=count)
        now = self.clock.now()
        if parse_iso(command.deadline_at) < now:
            return SubmitResult("not_submitted", "deadline_passed", write_calls=count)
        mode = self.submit_mode(command) if callable(self.submit_mode) else self.submit_mode
        if mode == "crash":
            raise RuntimeError("simulated provider crash after write started")
        if mode in {"timeout", "http_5xx"}:
            return SubmitResult("unknown", mode, write_calls=count)
        if mode in {"business_reject", "not_submitted"}:
            return SubmitResult("not_submitted", "provider_rejected", write_calls=count)
        if mode != "accepted":
            return SubmitResult("unknown", str(mode), write_calls=count)
        return SubmitResult(
            "accepted",
            "accepted",
            provider_request_id=f"req-{command.action_id}",
            provider_message_id=f"mid-{uuid4().hex[:12]}",
            write_calls=count,
        )


def decode_callback_body(body: bytes) -> dict[str, Any]:
    if len(body) > MAX_CALLBACK_BYTES:
        raise ChannelError("payload_too_large", "callback exceeds 256 KiB", 413)
    if body.lstrip().startswith(b"<"):
        raise ChannelError("xml_rejected", "XML callbacks are rejected", 415)
    try:
        raw = json.loads(body.decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise ChannelError("invalid_json", "callback is not JSON") from exc
    if not isinstance(raw, dict):
        raise ChannelError("invalid_json", "callback JSON must be an object")
    return raw


def evidence_is_fresh(evidence: ChannelEvidence, now: datetime, *, max_age_seconds: float = 5) -> bool:
    observed = parse_iso(evidence.observed_at)
    if observed.tzinfo is None:
        observed = observed.replace(tzinfo=timezone.utc)
    return 0 <= (now - observed).total_seconds() <= max_age_seconds


def build_channel(config, *, clock=None, transport=None, environ=None, allow_network: bool = False, **fake_kwargs):
    """Construct a channel. Real GeWe HTTP stays off unless allow_network and a transport are explicit."""
    from wechat_agent_poc.api_config import ApiConfig

    if not isinstance(config, ApiConfig):
        raise TypeError("build_channel requires ApiConfig")
    if config.channel.provider == "fake":
        return FakeChannel(clock=clock, **fake_kwargs)
    if config.channel.provider == "geweapi":
        from wechat_agent_poc.gewe_channel import GeweChannel

        return GeweChannel.from_config(
            config,
            clock=clock,
            transport=transport,
            environ=environ,
            allow_network=allow_network,
        )
    raise ChannelError("unknown_provider", f"no adapter for {config.channel.provider}")
