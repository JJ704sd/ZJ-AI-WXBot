"""Decode non-MAX 861 envelopes without inventing unobserved callback fields."""
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
from wechat_agent_poc.pad_legacy_transport import LEGACY_PROVIDER, business_code

SYNTHETIC_V0 = "synthetic_v0"
OBSERVED_UNMAPPED = "observed_unmapped"
SYNTHETIC_ITEM_KEYS = frozenset(
    {
        "synthetic_msg_id",
        "from_user",
        "to_user",
        "msg_type",
        "text",
        "create_time",
        "is_self",
        "at_wxid_list",
        "is_history",
        "identity_status",
    }
)


@dataclass(frozen=True)
class DecodeItem:
    index: int
    action: str
    reason: str
    event: ApiMessageV1 | None
    native_message_id: str | None
    schema: str


def auto_trigger_allowed(event: ApiMessageV1 | None, self_key: str) -> bool:
    if event is None:
        return False
    if event.parse_status != "ok":
        return False
    if event.identity_status != "resolved":
        return False
    if event.is_self != "false":
        return False
    if event.history_status != "false":
        return False
    if event.mention_status != "structured" or event.mention_all:
        return False
    return event.mention_keys == (self_key,)


def detect_sync_schema(raw: Mapping[str, Any]) -> str:
    if not isinstance(raw, Mapping):
        return "invalid"
    declared = str(raw.get("legacy_sync_schema") or "")
    if declared == SYNTHETIC_V0:
        return SYNTHETIC_V0
    if declared == OBSERVED_UNMAPPED:
        return OBSERVED_UNMAPPED
    if set(raw) >= {"Wxid", "MessageType", "Data"} or (
        isinstance(raw.get("Data"), Mapping) and isinstance((raw.get("Data") or {}).get("messages"), list)
    ):
        return "max_v1_rejected"
    return OBSERVED_UNMAPPED


def decode_sync_payload(
    raw: Mapping[str, Any],
    *,
    received_at: str,
    bound_account: str,
    bound_conversation: str,
    session_epoch: str,
    self_key: str,
) -> tuple[str, tuple[DecodeItem, ...]]:
    if not isinstance(raw, Mapping):
        return "invalid", ()
    schema = detect_sync_schema(raw)
    if schema == "max_v1_rejected":
        return schema, (DecodeItem(0, "isolated", "max_v1_not_legacy_contract", None, None, schema),)
    items_raw = raw.get("item")
    if items_raw is None:
        items_raw = raw.get("items")
    if items_raw is None and isinstance(raw.get("Data"), list):
        items_raw = raw.get("Data")
    if items_raw is None and isinstance(raw.get("Data"), Mapping):
        data = raw["Data"]
        items_raw = data.get("items") or data.get("AddMsgs") or data.get("messages")
    if items_raw is None and "synthetic_msg_id" in raw:
        items_raw = [raw]
    if isinstance(items_raw, Mapping):
        items_raw = [items_raw]
    if items_raw is None:
        return schema, ()
    if not isinstance(items_raw, list):
        return schema, (DecodeItem(0, "isolated", "items_not_list", None, None, schema),)
    decoded = []
    for index, item in enumerate(items_raw):
        decoded.append(
            decode_sync_item(
                item,
                index=index,
                schema=schema,
                received_at=received_at,
                bound_account=bound_account,
                bound_conversation=bound_conversation,
                session_epoch=session_epoch,
                self_key=self_key,
            )
        )
    return schema, tuple(decoded)


def decode_sync_item(
    item: Any,
    *,
    index: int,
    schema: str,
    received_at: str,
    bound_account: str,
    bound_conversation: str,
    session_epoch: str,
    self_key: str,
) -> DecodeItem:
    if not isinstance(item, Mapping):
        return DecodeItem(index, "rejected", "item_not_object", None, None, schema)
    if schema != SYNTHETIC_V0:
        return DecodeItem(index, "isolated", "schema_unmapped", None, None, schema)
    extra = set(item) - SYNTHETIC_ITEM_KEYS
    if extra:
        return DecodeItem(index, "isolated", "synthetic_schema_drift", None, None, schema)
    try:
        native = native_id_as_str(item.get("synthetic_msg_id"))
    except ChannelError as exc:
        return DecodeItem(index, "rejected", exc.code, None, None, schema)
    from_user = str(item.get("from_user") or "")
    to_user = str(item.get("to_user") or "")
    conversation = bound_conversation or (to_user if to_user.endswith("@chatroom") else from_user)
    if bound_conversation and bound_conversation not in {from_user, to_user, conversation}:
        return DecodeItem(index, "dropped_unbound", "out_of_scope", None, native, schema)
    account = bound_account
    sender = from_user if from_user != conversation else ""
    identity = str(item.get("identity_status") or "unknown")
    if identity not in {"resolved", "unknown", "ambiguous"}:
        identity = "unknown"
    is_self_raw = item.get("is_self")
    if is_self_raw is True:
        is_self = "true"
    elif is_self_raw is False:
        is_self = "false"
    else:
        is_self = "unknown"
    try:
        occurred_at = _unix_to_iso(item.get("create_time"))
        parse_status = "ok"
    except ChannelError:
        return DecodeItem(index, "rejected", "invalid_timestamp", None, native, schema)
    msg_type = item.get("msg_type")
    text = None if item.get("text") is None else str(item.get("text"))
    kind = "text" if msg_type in {1, "1", "text", None} and text is not None else "other"
    mention_keys = tuple(str(value) for value in (item.get("at_wxid_list") or ()))
    if "at_wxid_list" not in item:
        mention_status = "unknown"
        mention_keys = ()
    elif mention_keys:
        mention_status = "structured"
    else:
        mention_status = "none"
    history_raw = item.get("is_history")
    if history_raw is True:
        history_status = "true"
    elif history_raw is False:
        history_status = "false"
    else:
        history_status = "unknown"
    event = ApiMessageV1(
        schema_version="wechat-api-event/1",
        provider=LEGACY_PROVIDER,
        account_key=account,
        conversation_key=conversation,
        native_message_id=native,
        event_key=event_key(LEGACY_PROVIDER, account, conversation, native),
        session_epoch=session_epoch or "unknown",
        occurred_at=occurred_at,
        received_at=received_at,
        sender_key=sender,
        identity_status=identity,
        is_self=is_self,
        kind=kind,
        text=text,
        mention_status=mention_status,
        mention_keys=mention_keys,
        mention_all=False,
        reply_to_message_id=None,
        history_status=history_status,
        parse_status=parse_status,
    )
    action = "ok"
    reason = "ok"
    if not auto_trigger_allowed(event, self_key):
        reason = "observe_only"
    return DecodeItem(index, action, reason, event, native, schema)


def decode_gateway_items(
    http_status: int,
    body: Mapping[str, Any] | None,
    reason: str,
    **decode_kwargs: Any,
) -> tuple[str, tuple[DecodeItem, ...]]:
    code = business_code(body)
    if reason == "timeout" or http_status == 0:
        return "timeout", ()
    if http_status == 200 and code not in (None, 200) and not isinstance(body, Mapping):
        return "business_error", ()
    if http_status == 200 and code not in (None, 200):
        return "business_error", ()
    if not isinstance(body, Mapping):
        return "unknown_envelope", ()
    return decode_sync_payload(body, **decode_kwargs)


def _unix_to_iso(value: Any) -> str:
    if value in (None, ""):
        raise ChannelError("missing_field", "create_time is required")
    if isinstance(value, float):
        raise ChannelError("invalid_timestamp", "create_time must not pass through float conversion")
    if isinstance(value, bool) or not isinstance(value, int):
        text = str(value).strip()
        if not text.isdigit():
            raise ChannelError("invalid_timestamp", "create_time must be unix seconds")
        value = int(text)
    return isoformat(datetime.fromtimestamp(int(value), tz=timezone.utc))
