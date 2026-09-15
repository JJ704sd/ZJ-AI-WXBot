"""Structured @mention recognition. Never falls back to nickname matching."""

from __future__ import annotations

import json
import re
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from typing import Any, Literal, Mapping

from wechat_agent_poc.chat_room_codec import MEMBER_KEY_RE, extract_protobuf_strings
from wechat_agent_poc.models import MentionSelf

MENTION_ALL_KEYS = frozenset(
    {
        "notify@all",
        "all",
        "@all",
        "atuserlist:@all",
        "announcement@all",
    }
)
STRUCTURED_FIELD_NAMES = (
    "packed_info",
    "packed_info_data",
    "message_source",
    "msgsource",
    "msg_source",
    "source",
    "at_list",
    "atuserlist",
    "mention_list",
    "mentioned_keys",
)
QUOTE_TAGS = frozenset({"refermsg", "quotedmessage", "quote", "appmsg"})
MentionStatus = Literal["true", "false", "unknown"]


@dataclass(frozen=True)
class MentionDecision:
    mention_self: MentionSelf
    mentioned_keys: tuple[str, ...]
    mention_all: bool
    source_field: str | None
    reason: str

    def as_dict(self) -> dict[str, object]:
        return {
            "mention_self": self.mention_self,
            "mentioned_keys": list(self.mentioned_keys),
            "mention_all": self.mention_all,
            "source_field": self.source_field,
            "reason": self.reason,
        }


def classify_mention(
    *,
    self_sender_key: str,
    fields: Mapping[str, Any] | None = None,
    text: str | None = None,
) -> MentionDecision:
    payload = dict(fields or {})
    structured = _first_structured_field(payload)
    if structured is None:
        return MentionDecision(
            mention_self="unknown",
            mentioned_keys=(),
            mention_all=False,
            source_field=None,
            reason="mention_field_absent",
        )
    name, value = structured
    parsed = _parse_structured_value(value, field_name=name)
    if parsed is None:
        return MentionDecision(
            mention_self="unknown",
            mentioned_keys=(),
            mention_all=False,
            source_field=name,
            reason="mention_parse_failed",
        )
    keys, mention_all, reason = parsed
    if mention_all:
        return MentionDecision("false", keys, True, name, "mention_all")
    if not keys:
        return MentionDecision("false", (), False, name, "structured_empty")
    unique = tuple(dict.fromkeys(keys))
    if not self_sender_key:
        return MentionDecision("unknown", unique, False, name, "self_sender_key_missing")
    if unique == (self_sender_key,):
        return MentionDecision("true", unique, False, name, "structured_self_only")
    return MentionDecision("false", unique, False, name, "structured_not_self_only")


def strip_display_mentions(text: str | None) -> str:
    """Remove visible @tokens from question text. Does not decide trigger eligibility."""
    if not text:
        return ""
    cleaned = re.sub(r"@[^\s@]+", " ", text)
    return " ".join(cleaned.split())


def _first_structured_field(fields: Mapping[str, Any]) -> tuple[str, Any] | None:
    lowered = {str(key).lower(): (str(key), value) for key, value in fields.items()}
    for name in STRUCTURED_FIELD_NAMES:
        if name in lowered:
            original, value = lowered[name]
            if value is None:
                continue
            if isinstance(value, (bytes, bytearray)) and not bytes(value):
                continue
            if isinstance(value, str) and not value.strip():
                continue
            if isinstance(value, (list, tuple, dict)) and len(value) == 0:
                return original, value
            return original, value
    return None


def _parse_structured_value(value: Any, *, field_name: str) -> tuple[tuple[str, ...], bool, str] | None:
    if isinstance(value, (list, tuple)):
        keys = [_normalize_member_key(item) for item in value]
        keys = [item for item in keys if item]
        mention_all = any(item.lower() in MENTION_ALL_KEYS for item in keys) or any(
            str(item).lower() in MENTION_ALL_KEYS for item in value
        )
        member_keys = tuple(item for item in keys if item.lower() not in MENTION_ALL_KEYS)
        return member_keys, mention_all, "list"
    if isinstance(value, dict):
        if "mentioned_keys" in value or "at_list" in value or "atuserlist" in value:
            inner = value.get("mentioned_keys") or value.get("at_list") or value.get("atuserlist")
            return _parse_structured_value(inner, field_name=field_name)
        mention_all = bool(value.get("mention_all") or value.get("at_all"))
        keys = [_normalize_member_key(item) for item in (value.get("ids") or ())]
        return tuple(item for item in keys if item), mention_all, "dict"
    raw = _as_text_or_bytes(value)
    if raw is None:
        return None
    text, blob = raw
    xml_keys = _parse_top_level_xml_atuserlist(text)
    if xml_keys is not None:
        keys, mention_all = xml_keys
        return keys, mention_all, "xml_atuserlist"
    if text.strip().startswith("{") or text.strip().startswith("["):
        try:
            loaded = json.loads(text)
        except json.JSONDecodeError:
            loaded = None
        if loaded is not None:
            return _parse_structured_value(loaded, field_name=field_name)
    proto = extract_protobuf_strings(blob) if blob else None
    if proto is not None:
        keys = [_normalize_member_key(item) for item in proto]
        member_keys = tuple(item for item in keys if item and item.lower() not in MENTION_ALL_KEYS)
        mention_all = any(item.lower() in MENTION_ALL_KEYS for item in proto if isinstance(item, str))
        if member_keys or mention_all:
            return member_keys, mention_all, "protobuf_ids"
        return (), False, "protobuf_no_mention_ids"
    if "," in text and all(_looks_like_member_or_all(part.strip()) for part in text.split(",") if part.strip()):
        parts = [part.strip() for part in text.split(",") if part.strip()]
        mention_all = any(part.lower() in MENTION_ALL_KEYS for part in parts)
        keys = tuple(_normalize_member_key(part) for part in parts if part.lower() not in MENTION_ALL_KEYS)
        keys = tuple(item for item in keys if item)
        return keys, mention_all, "comma_ids"
    if _looks_like_member_or_all(text.strip()):
        if text.strip().lower() in MENTION_ALL_KEYS:
            return (), True, "all_token"
        key = _normalize_member_key(text.strip())
        if key:
            return (key,), False, "single_id"
    return None


def _parse_top_level_xml_atuserlist(text: str) -> tuple[tuple[str, ...], bool] | None:
    stripped = text.strip()
    if not stripped.startswith("<"):
        return None
    try:
        wrapped = stripped if stripped.startswith("<?xml") else f"<root>{stripped}</root>"
        root = ET.fromstring(wrapped)
    except ET.ParseError:
        return None
    nodes = []
    for node in root.iter():
        tag = _local_tag(node.tag).lower()
        if tag in {"atuserlist", "atuser", "at_list"}:
            if _inside_quote(node, root):
                continue
            nodes.append(node)
    if not nodes and _has_quote_container(root):
        return (), False
    if not nodes:
        return None
    tokens: list[str] = []
    mention_all = False
    for node in nodes:
        body = (node.text or "").strip()
        if not body:
            continue
        for part in re.split(r"[,\s]+", body):
            if not part:
                continue
            if part.lower() in MENTION_ALL_KEYS:
                mention_all = True
                continue
            key = _normalize_member_key(part)
            if key:
                tokens.append(key)
    return tuple(dict.fromkeys(tokens)), mention_all


def _inside_quote(node: ET.Element, root: ET.Element) -> bool:
    parent_map = {child: parent for parent in root.iter() for child in list(parent)}
    current = parent_map.get(node)
    while current is not None:
        if _local_tag(current.tag).lower() in QUOTE_TAGS:
            return True
        current = parent_map.get(current)
    return False


def _has_quote_container(root: ET.Element) -> bool:
    return any(_local_tag(node.tag).lower() in QUOTE_TAGS for node in root.iter())


def _local_tag(tag: str) -> str:
    if "}" in tag:
        return tag.rsplit("}", 1)[-1]
    return tag


def _normalize_member_key(value: Any) -> str:
    text = str(value or "").strip()
    if text.lower() in MENTION_ALL_KEYS:
        return ""
    if MEMBER_KEY_RE.fullmatch(text):
        return text
    return ""


def _looks_like_member_or_all(text: str) -> bool:
    return text.lower() in MENTION_ALL_KEYS or bool(MEMBER_KEY_RE.fullmatch(text))


def _as_text_or_bytes(value: Any) -> tuple[str, bytes] | None:
    if isinstance(value, memoryview):
        value = bytes(value)
    if isinstance(value, (bytes, bytearray)):
        raw = bytes(value)
        try:
            return raw.decode("utf-8"), raw
        except UnicodeDecodeError:
            return "", raw
    if isinstance(value, str):
        return value, value.encode("utf-8")
    return None
