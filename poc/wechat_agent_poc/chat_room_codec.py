"""Decode chat_room.ext_buffer member keys from protobuf wire format.

Unknown or truncated encodings halt. This does not scan message bodies.
"""

from __future__ import annotations

import re
from dataclasses import dataclass

from wechat_agent_poc.models import Halt, HaltError

MEMBER_KEY_RE = re.compile(r"^(wxid_[A-Za-z0-9_-]+|\d+@openim|[A-Za-z0-9_-]+@chatroom)$")
FEATURE_RE = re.compile(r"^[^/\s]+/[^/\s]+$")


@dataclass(frozen=True)
class ChatRoomMembers:
    username: str
    owner: str
    member_keys: tuple[str, ...]
    feature_labels: tuple[str, ...]
    decode_status: str
    note: str


def decode_ext_buffer(raw: object, *, username: str = "", owner: str = "") -> ChatRoomMembers:
    blob = _as_bytes(raw)
    if not blob:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "chat_room.ext_buffer is empty; refusing to locate members from history",
                {"phase": "CHAT_ROOM", "username": username},
            )
        )
    strings = extract_protobuf_strings(blob)
    if strings is None:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "chat_room.ext_buffer is not a proven protobuf encoding",
                {"phase": "CHAT_ROOM", "username": username, "size": len(blob)},
            )
        )
    member_keys = tuple(dict.fromkeys(item for item in strings if MEMBER_KEY_RE.fullmatch(item)))
    features = tuple(dict.fromkeys(item for item in strings if FEATURE_RE.fullmatch(item) and item not in member_keys))
    if not member_keys:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "chat_room.ext_buffer decoded but contained no member identifiers",
                {"phase": "CHAT_ROOM", "username": username, "string_count": len(strings)},
            )
        )
    return ChatRoomMembers(
        username=username,
        owner=owner,
        member_keys=member_keys,
        feature_labels=features,
        decode_status="ok",
        note="protobuf_length_delimited_strings",
    )


def extract_protobuf_strings(blob: bytes) -> list[str] | None:
    candidates = [blob]
    if len(blob) >= 4:
        prefixed = int.from_bytes(blob[:4], "little")
        if 0 < prefixed <= len(blob) - 4:
            candidates.append(blob[4 : 4 + prefixed])
        prefixed_be = int.from_bytes(blob[:4], "big")
        if 0 < prefixed_be <= len(blob) - 4:
            candidates.append(blob[4 : 4 + prefixed_be])
    for candidate in candidates:
        parsed = _parse_protobuf_strings(candidate)
        if parsed is not None:
            return parsed
    return None


def encode_len_delim(field_num: int, value: bytes) -> bytes:
    return _varint((field_num << 3) | 2) + _varint(len(value)) + value


def encode_chat_room_buffer(member_keys: tuple[str, ...], features: tuple[str, ...] = (), *, owner: str = "") -> bytes:
    out = bytearray()
    if owner:
        out.extend(encode_len_delim(1, owner.encode("utf-8")))
    for key in member_keys:
        out.extend(encode_len_delim(2, key.encode("utf-8")))
        if owner:
            out.extend(encode_len_delim(1, owner.encode("utf-8")))
    for feature in features:
        out.extend(encode_len_delim(3, feature.encode("utf-8")))
    return bytes(out)


def _parse_protobuf_strings(blob: bytes) -> list[str] | None:
    index = 0
    strings: list[str] = []
    saw_field = False
    while index < len(blob):
        if blob[index] == 0 and index == len(blob) - 1:
            break
        tag, index = _read_varint(blob, index)
        if tag is None:
            return None if not saw_field else strings
        field_num = tag >> 3
        wire = tag & 7
        if field_num == 0:
            return None
        saw_field = True
        if wire == 0:
            value, index = _read_varint(blob, index)
            if value is None:
                return None
        elif wire == 1:
            if index + 8 > len(blob):
                return None
            index += 8
        elif wire == 5:
            if index + 4 > len(blob):
                return None
            index += 4
        elif wire == 2:
            length, index = _read_varint(blob, index)
            if length is None or index + length > len(blob):
                return None
            chunk = blob[index : index + length]
            index += length
            nested = _parse_protobuf_strings(chunk)
            if nested:
                strings.extend(nested)
            else:
                try:
                    text = chunk.decode("utf-8")
                except UnicodeDecodeError:
                    continue
                if text:
                    strings.append(text)
        else:
            return None
    return strings if saw_field else None


def _as_bytes(value: object) -> bytes:
    if value is None:
        return b""
    if isinstance(value, memoryview):
        return bytes(value)
    if isinstance(value, (bytes, bytearray)):
        return bytes(value)
    if isinstance(value, str):
        return value.encode("utf-8")
    return b""


def _varint(value: int) -> bytes:
    out = bytearray()
    remaining = value
    while remaining > 0x7F:
        out.append((remaining & 0x7F) | 0x80)
        remaining >>= 7
    out.append(remaining)
    return bytes(out)


def _read_varint(data: bytes, index: int) -> tuple[int | None, int]:
    shift = 0
    result = 0
    while index < len(data) and shift < 35:
        byte = data[index]
        index += 1
        result |= (byte & 0x7F) << shift
        if byte & 0x80 == 0:
            return result, index
        shift += 7
    return None, index
