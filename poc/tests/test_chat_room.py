from __future__ import annotations

import sqlite3
from pathlib import Path

import pytest

from wechat_agent_poc.chat_room_codec import ChatRoomMembers, decode_ext_buffer, encode_chat_room_buffer
from wechat_agent_poc.locator import ContactRow, load_chat_rooms, locate_group
from wechat_agent_poc.models import HaltError


SELF = "wxid_example_account"
OWNER = "10000000000000001@openim"
MEMBERS = (
    "10000000000000002@openim",
    OWNER,
    "10000000000000003@openim",
    "10000000000000004@openim",
    "10000000000000005@openim",
    SELF,
)
FEATURES = ("示例企业B/示例群主", "示例企业B/示例成员C", "示例企业A/示例成员A")
ROOM = "example_group@chatroom"


def test_ext_buffer_roundtrip_extracts_member_keys_not_nicknames():
    blob = encode_chat_room_buffer(MEMBERS, FEATURES, owner=OWNER)
    decoded = decode_ext_buffer(blob, username=ROOM, owner=OWNER)
    assert set(decoded.member_keys) == set(MEMBERS)
    assert set(FEATURES).issubset(decoded.feature_labels)
    assert "示例本人" not in decoded.member_keys


def test_unknown_ext_buffer_halts():
    with pytest.raises(HaltError) as caught:
        decode_ext_buffer(b"\xff\xfe not protobuf", username=ROOM)
    assert caught.value.halt.details.get("phase") == "CHAT_ROOM"


def test_empty_buffer_does_not_scan_history():
    with pytest.raises(HaltError) as caught:
        decode_ext_buffer(b"", username=ROOM)
    assert "history" in caught.value.halt.message.lower() or "empty" in caught.value.halt.message.lower()


def test_locate_group_uses_room_members_and_refuses_ambiguity():
    contacts = [
        ContactRow(ROOM, "", "示例混合群", ""),
        ContactRow(OWNER, "示例企业B/示例群主", "示例群主", ""),
        ContactRow("10000000000000004@openim", "示例企业B/示例成员C", "示例成员C", ""),
        ContactRow("10000000000000002@openim", "示例企业A/示例成员A", "示例成员A", ""),
        ContactRow("wxid_other", "示例企业C/示例群主", "示例群主", ""),
    ]
    room = ChatRoomMembers(ROOM, OWNER, MEMBERS, FEATURES, "ok", "test")
    unique = locate_group(
        display_name="示例混合群",
        member_features=("示例企业B/示例群主", "示例企业B/示例成员C", "示例企业A/示例成员A"),
        contacts=contacts,
        sessions=[ROOM],
        chat_rooms=[room],
    )
    assert unique["bindable"] is True
    assert unique["conversation_key"] == ROOM
    assert unique["member_source"] == "chat_room.ext_buffer"
    assert "示例企业C/示例群主" not in str(unique["member_feature_hits"])
    missing = locate_group(
        display_name="示例混合群",
        member_features=("示例企业B/示例群主",),
        contacts=contacts,
        sessions=[ROOM],
        chat_rooms=[],
    )
    assert missing["bindable"] is False
    many = locate_group(
        display_name="示例混合群",
        member_features=("示例企业B/示例群主",),
        contacts=contacts + [ContactRow("room-b@chatroom", "", "示例混合群", "")],
        sessions=[ROOM, "room-b@chatroom"],
        chat_rooms=[room],
    )
    assert many["bindable"] is False


def test_load_chat_rooms_reads_ext_buffer(tmp_path: Path):
    db = tmp_path / "contact.db"
    conn = sqlite3.connect(db)
    conn.execute("CREATE TABLE chat_room (username TEXT, owner TEXT, ext_buffer BLOB)")
    conn.execute(
        "INSERT INTO chat_room VALUES (?,?,?)",
        (ROOM, OWNER, encode_chat_room_buffer(MEMBERS, FEATURES, owner=OWNER)),
    )
    conn.commit()
    conn.close()
    rooms = load_chat_rooms(db)
    assert rooms is not None
    assert rooms[0].member_keys[-1] == SELF or SELF in rooms[0].member_keys
