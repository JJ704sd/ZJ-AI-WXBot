"""Legacy Windows 861 Channel. No auto login, no key generation, no MAX routes."""
from __future__ import annotations

from datetime import datetime, timezone
from typing import Any, Mapping

from wechat_agent_poc.api_channel import (
    MAX_CALLBACK_BYTES,
    ApiMessageV1,
    ChannelError,
    ChannelEvidence,
    MemberMap,
    OutboundCommand,
    SubmitResult,
    native_id_as_str,
    normalize_api_event,
)
from wechat_agent_poc.api_config import ApiConfig, BindingSettings, isoformat
from wechat_agent_poc.clock import Clock, SystemClock
from wechat_agent_poc.gewe_channel import resolve_env_ref
from wechat_agent_poc.pad_legacy_decoder import SYNTHETIC_V0, decode_sync_payload
from wechat_agent_poc.pad_legacy_transport import (
    DEFAULT_TIMEOUT_SECONDS,
    LEGACY_PROVIDER,
    LEGACY_PROVIDER_VERSION,
    PATH_CHATROOM_INFO,
    PATH_CHATROOM_MEMBERS,
    PATH_LOGIN_STATUS,
    PATH_SEND_TEXT,
    Legacy861Transport,
    classify_gateway_response,
    require_loopback_base,
    select_receive_channel,
)


class Legacy861Channel:
    """Online probe and fixed-text submit against 20250822 swagger send/sync models."""

    provider = LEGACY_PROVIDER
    provider_version = LEGACY_PROVIDER_VERSION

    def __init__(
        self,
        *,
        base_url: str,
        device_key: str,
        clock: Clock | None = None,
        transport: Legacy861Transport | None = None,
        allow_network: bool = False,
        bound_account: str = "",
        bound_conversation: str = "",
        session_epoch: str = "unknown",
        self_key: str = "",
        receive_channels: tuple[str, ...] = ("http_sync",),
    ):
        require_loopback_base(base_url)
        self.base_url = base_url.rstrip("/")
        self._device_key = device_key
        self.clock = clock or SystemClock()
        self.transport = transport or Legacy861Transport()
        self.allow_network = allow_network
        self.account_key = bound_account
        self.conversation_key = bound_conversation
        self.session_epoch = session_epoch
        self.self_key = self_key
        self.receive_channel = select_receive_channel(receive_channels)
        self.write_calls: list[OutboundCommand] = []
        self.write_counts: dict[str, int] = {}
        self.capabilities = {
            "receive_text": False,
            "send_text": True,
            "native_mention_send": False,
            "native_mention_receive": False,
            "group_members_scoped": False,
            "callback_ack": False,
            "callback_signature": False,
            "replay_cursor": False,
            "mixed_group_openim": False,
            "history_flag": False,
            "http_sync": True,
            "websocket": False,
            "webhook": False,
        }

    @classmethod
    def from_config(
        cls,
        config: ApiConfig,
        *,
        clock: Clock | None = None,
        transport: Legacy861Transport | None = None,
        environ: Mapping[str, str] | None = None,
        allow_network: bool = False,
    ) -> Legacy861Channel:
        return cls(
            base_url=resolve_env_ref(config.channel.base_url_ref, environ),
            device_key=resolve_env_ref(config.channel.credential_ref, environ),
            clock=clock,
            transport=transport,
            allow_network=allow_network,
            bound_account=config.binding.account_key,
            bound_conversation=config.binding.conversation_key,
            self_key="",
        )

    def authenticate_callback(self, headers: Mapping[str, str], body: bytes) -> None:
        del headers
        if len(body) > MAX_CALLBACK_BYTES:
            raise ChannelError("payload_too_large", "callback exceeds 256 KiB", 413)
        raise ChannelError(
            "callback_channel_not_selected",
            "legacy webhook signature is unobserved; HttpSyncMsg is the selected receive channel",
            401,
        )

    def normalize(self, raw: Mapping[str, Any], *, received_at: str) -> ApiMessageV1:
        if isinstance(raw, Mapping) and raw.get("schema_version") == "wechat-api-event/1":
            return normalize_api_event(raw, received_at=received_at, expected_provider=self.provider)
        schema, items = decode_sync_payload(
            raw,
            received_at=received_at,
            bound_account=self.account_key,
            bound_conversation=self.conversation_key,
            session_epoch=self.session_epoch,
            self_key=self.self_key,
        )
        if schema != SYNTHETIC_V0:
            raise ChannelError("schema_unmapped", "861 HttpSync item schema is not observed; refusing normalize")
        if len(items) != 1 or items[0].event is None:
            raise ChannelError("invalid_field", items[0].reason if items else "empty_sync_item")
        if items[0].action not in {"ok"}:
            raise ChannelError(items[0].reason, items[0].reason)
        return items[0].event

    def probe(self, binding: BindingSettings) -> ChannelEvidence:
        if not self._network_ready():
            raise ChannelError("network_disabled", "live legacy 861 HTTP is disabled in this round")
        if not self._device_key:
            raise ChannelError("missing_credential", "device key is required")
        status_result = self._call("GET", PATH_LOGIN_STATUS, None)
        classified = classify_gateway_response(status_result.http_status, status_result.body, status_result.reason)
        online = False
        conversation_exists = False
        if classified == "business_ok" and binding.conversation_key:
            info = self._call("POST", PATH_CHATROOM_INFO, {"ChatRoomWxIdList": [binding.conversation_key]})
            info_class = classify_gateway_response(info.http_status, info.body, info.reason)
            if info_class == "business_ok":
                conversation_exists = False
        account = binding.account_key or self.account_key
        return ChannelEvidence(
            provider=self.provider,
            provider_version=self.provider_version,
            account_key=account,
            session_epoch=self.session_epoch,
            online=online,
            conversation_exists=conversation_exists,
            member_maps=(),
            observed_at=isoformat(self.clock.now()),
            capabilities=dict(self.capabilities),
            unique_account=bool(account) and (not binding.account_key or binding.account_key == account),
            unique_conversation=False,
        )

    def resolve_members(self, binding: BindingSettings, candidate_refs: tuple[str, ...]) -> tuple[MemberMap, ...]:
        if not candidate_refs:
            return ()
        if not binding.conversation_key:
            return tuple(MemberMap(ref, None, "out_of_scope", "unbound_conversation") for ref in candidate_refs)
        if not self._network_ready() or not self._device_key:
            return tuple(MemberMap(ref, None, "not_found", "schema_unmapped") for ref in candidate_refs)
        result = self._call("POST", PATH_CHATROOM_MEMBERS, {"ChatRoomName": binding.conversation_key})
        classified = classify_gateway_response(result.http_status, result.body, result.reason)
        data = result.body.get("Data") if isinstance(result.body, Mapping) else None
        found: dict[str, str] = {}
        if classified == "business_ok" and isinstance(data, dict) and data.get("legacy_sync_schema") == SYNTHETIC_V0:
            for item in data.get("synthetic_members") or []:
                if isinstance(item, dict) and item.get("member_key"):
                    found[str(item["member_key"])] = str(item["member_key"])
        return tuple(
            MemberMap(ref, found.get(ref), "resolved" if ref in found else "not_found", "schema_unmapped" if ref not in found else "")
            for ref in candidate_refs
        )

    def submit(self, command: OutboundCommand) -> SubmitResult:
        if not self._device_key:
            return SubmitResult("not_submitted", "missing_credential", write_calls=0)
        if self.account_key and command.account_key != self.account_key:
            return SubmitResult("not_submitted", "account_mismatch", write_calls=0)
        if self.conversation_key and command.conversation_key != self.conversation_key:
            return SubmitResult("not_submitted", "conversation_mismatch", write_calls=0)
        count = self.write_counts.get(command.action_id, 0) + 1
        self.write_counts[command.action_id] = count
        self.write_calls.append(command)
        if count > 1:
            return SubmitResult("unknown", "duplicate_write_forbidden", write_calls=count)
        now = self.clock.now()
        deadline = _parse_deadline(command.deadline_at)
        if deadline is not None and deadline < now:
            return SubmitResult("not_submitted", "deadline_passed", write_calls=count)
        if not self._network_ready():
            return SubmitResult("not_submitted", "network_disabled", write_calls=count)
        item: dict[str, Any] = {
            "ToUserName": command.conversation_key,
            "TextContent": command.text,
            "MsgType": 1,
        }
        if command.native_mention:
            item["AtWxIDList"] = list(command.mention_keys)
        payload = {"MsgItem": [item]}
        result = self._call("POST", PATH_SEND_TEXT, payload, write=True)
        classified = classify_gateway_response(result.http_status, result.body, result.reason)
        if classified == "timeout":
            return SubmitResult("unknown", "timeout", write_calls=count)
        if classified == "business_error":
            return SubmitResult("not_submitted", f"business_code_{business_code_text(result.body)}", write_calls=count)
        if classified != "business_ok":
            return SubmitResult("unknown", classified, write_calls=count)
        try:
            provider_message_id = _optional_id(result.body)
        except ChannelError:
            return SubmitResult("unknown", "float_message_id", write_calls=count)
        return SubmitResult(
            "accepted",
            "accepted",
            provider_request_id=command.action_id,
            provider_message_id=provider_message_id,
            write_calls=count,
        )

    def _network_ready(self) -> bool:
        return bool(self.allow_network or getattr(self.transport, "_opener", None) is not None)

    def _call(self, method: str, path: str, payload: dict[str, Any] | None, *, write: bool = False):
        del write
        if not self._device_key:
            raise ChannelError("missing_credential", "device key is required")
        return self.transport.request(
            method,
            self.base_url + path,
            payload=payload,
            query_key=self._device_key,
            timeout=DEFAULT_TIMEOUT_SECONDS,
        )


def business_code_text(body: Mapping[str, Any] | None) -> str:
    if not isinstance(body, Mapping):
        return "unknown"
    code = body.get("Code", body.get("code"))
    return "none" if code is None else str(code)


def _optional_id(body: Mapping[str, Any] | None) -> str | None:
    if not isinstance(body, Mapping):
        return None
    data = body.get("Data")
    if not isinstance(data, Mapping):
        return None
    value = data.get("synthetic_msg_id")
    if value in (None, ""):
        return None
    if isinstance(value, float):
        raise ChannelError("invalid_native_id", "provider message id must not pass through float conversion")
    return native_id_as_str(value)


def _parse_deadline(value: str) -> datetime | None:
    if not value:
        return None
    text = str(value)
    if text.endswith("Z"):
        text = text[:-1] + "+00:00"
    moment = datetime.fromisoformat(text)
    if moment.tzinfo is None:
        moment = moment.replace(tzinfo=timezone.utc)
    return moment
