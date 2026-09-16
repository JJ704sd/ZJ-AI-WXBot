from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any, Mapping

from wechat_agent_poc.api_channel import (
    ApiMessageV1,
    ChannelError,
    event_key,
    native_id_as_str,
)
from wechat_agent_poc.api_config import isoformat
from wechat_agent_poc.pad_config import PAD_PROVIDER

V1_ENVELOPE_KEYS = frozenset({"Wxid", "MessageType", "Timestamp", "Signature", "Data", "IsSelf"})
V1_MESSAGE_KEYS = frozenset({"newMsgId", "createTime", "fromUser", "toUser", "isSelf", "msgType", "text"})
V2_MARKERS = ("wechatpad.message.v2", "reply_context")
MENTION_HINT_KEYS = frozenset({"atuserlist", "atUserList", "msgSource", "MsgSource"})
HISTORY_HINT_KEYS = frozenset({"isHistory", "is_history", "history"})


@dataclass(frozen=True)
class DecodeItem:
    index: int
    action: str
    reason: str
    event: ApiMessageV1 | None
    stored_text: bool
    native_message_id: str | None


@dataclass(frozen=True)
class EnvelopeDecode:
    version: str
    action: str
    reason: str
    account_key: str
    items: tuple[DecodeItem, ...]


def detect_callback_version(raw: Mapping[str, Any]) -> str:
    if not isinstance(raw, Mapping):
        return "invalid"
    blob = _lower_blob(raw)
    if any(marker in blob for marker in V2_MARKERS) or str(raw.get("MessageType") or "").lower().endswith(".v2"):
        return "v2"
    schema = str(raw.get("schema_version") or raw.get("schema") or "")
    if "v2" in schema.lower():
        return "v2"
    data = raw.get("Data")
    if isinstance(data, Mapping) and isinstance(data.get("messages"), list):
        extra = set(raw) - V1_ENVELOPE_KEYS
        if extra:
            return "drift"
        return "v1"
    if "Data" in raw or "MessageType" in raw or "Wxid" in raw:
        return "drift"
    return "unknown"


def decode_v1_envelope(
    raw: Mapping[str, Any],
    *,
    received_at: str,
    bound_account: str,
    bound_conversation: str,
    session_epoch: str = "unknown",
    prefix_split_confirmed: bool = False,
) -> EnvelopeDecode:
    version = detect_callback_version(raw)
    if version == "v2":
        return EnvelopeDecode("v2", "isolated", "v2_unsupported", str(raw.get("Wxid") or ""), ())
    if version != "v1":
        return EnvelopeDecode(version, "isolated", "schema_drift", str(raw.get("Wxid") or ""), ())
    account = str(raw.get("Wxid") or "")
    data = raw.get("Data")
    messages = data.get("messages") if isinstance(data, Mapping) else None
    if not isinstance(messages, list):
        return EnvelopeDecode("v1", "isolated", "missing_messages", account, ())
    items = []
    for index, item in enumerate(messages):
        items.append(
            _decode_v1_message(
                item,
                index=index,
                received_at=received_at,
                envelope_account=account,
                bound_account=bound_account,
                bound_conversation=bound_conversation,
                session_epoch=session_epoch,
                prefix_split_confirmed=prefix_split_confirmed,
            )
        )
    return EnvelopeDecode("v1", "decoded", "ok", account, tuple(items))


def _decode_v1_message(
    item: Any,
    *,
    index: int,
    received_at: str,
    envelope_account: str,
    bound_account: str,
    bound_conversation: str,
    session_epoch: str,
    prefix_split_confirmed: bool,
) -> DecodeItem:
    if not isinstance(item, Mapping):
        return DecodeItem(index, "rejected", "item_not_object", None, False, None)
    account = bound_account or envelope_account
    if envelope_account and bound_account and envelope_account != bound_account:
        return DecodeItem(index, "dropped_unbound", "account_mismatch", None, False, None)
    from_user = str(item.get("fromUser") or "")
    to_user = str(item.get("toUser") or "")
    in_scope = bool(bound_conversation) and bound_conversation in {from_user, to_user}
    native = None
    try:
        if item.get("newMsgId") not in (None, ""):
            native = native_id_as_str(item.get("newMsgId"))
    except ChannelError as exc:
        if not in_scope:
            return DecodeItem(index, "dropped_unbound", "out_of_scope", None, False, None)
        return DecodeItem(index, "rejected", exc.code, None, False, None)
    if not in_scope:
        return DecodeItem(index, "dropped_unbound", "out_of_scope", None, False, native)
    if not native:
        return DecodeItem(index, "rejected", "missing_native_id", None, False, None)
    if not prefix_split_confirmed:
        sender = from_user if from_user and from_user != bound_conversation else ""
        text = None if item.get("text") is None else str(item.get("text"))
        identity = "unknown"
    else:
        sender = from_user if from_user != bound_conversation else ""
        text = None if item.get("text") is None else str(item.get("text"))
        identity = "unknown"
    is_self = _is_self(item.get("isSelf"), sender, account)
    parse_status = "ok"
    try:
        occurred_at = _unix_to_iso(item.get("createTime"))
    except ChannelError as exc:
        if exc.code == "invalid_timestamp":
            return DecodeItem(index, "rejected", exc.code, None, False, native)
        parse_status = "unknown"
        occurred_at = received_at
    kind = "text" if item.get("text") is not None else "other"
    mention_keys = item.keys() if hasattr(item, "keys") else []
    if set(mention_keys) & (MENTION_HINT_KEYS | HISTORY_HINT_KEYS):
        # Presence is not evidence; keep unknown and do not parse those fields.
        pass
    event = ApiMessageV1(
        schema_version="wechat-api-event/1",
        provider=PAD_PROVIDER,
        account_key=account,
        conversation_key=bound_conversation,
        native_message_id=native,
        event_key=event_key(PAD_PROVIDER, account, bound_conversation, native),
        session_epoch=session_epoch or "unknown",
        occurred_at=occurred_at,
        received_at=received_at,
        sender_key=sender,
        identity_status=identity,
        is_self=is_self,
        kind=kind,
        text=text,
        mention_status="unknown",
        mention_keys=(),
        mention_all=False,
        reply_to_message_id=None,
        history_status="unknown",
        parse_status=parse_status,
    )
    return DecodeItem(index, "ok", "ok", event, True, native)


def _is_self(value: Any, sender: str, account: str) -> str:
    if isinstance(value, bool):
        mapped = "true" if value else "false"
    else:
        mapped = "unknown"
    if sender and account and sender == account and mapped == "false":
        return "unknown"
    if sender and account and sender != account and mapped == "true":
        return "unknown"
    return mapped


def _unix_to_iso(value: Any) -> str:
    if value in (None, ""):
        raise ChannelError("missing_field", "createTime is required")
    if isinstance(value, float):
        raise ChannelError("invalid_timestamp", "createTime must not pass through float conversion")
    if isinstance(value, bool) or not isinstance(value, int):
        text = str(value).strip()
        if not text.isdigit():
            raise ChannelError("invalid_timestamp", "createTime must be unix seconds")
        value = int(text)
    moment = datetime.fromtimestamp(int(value), tz=timezone.utc)
    return isoformat(moment)


def _lower_blob(raw: Mapping[str, Any]) -> str:
    try:
        import json

        return json.dumps(raw, ensure_ascii=False).lower()
    except (TypeError, ValueError):
        return str(raw).lower()
