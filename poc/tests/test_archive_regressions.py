from __future__ import annotations

import sqlite3
from pathlib import Path

import pytest
import zstandard

from wechat_agent_poc.discovery import discover_account_shards, list_account_directories
from wechat_agent_poc.models import HaltError
from wechat_agent_poc.reader import SqlitePlainReader
from wechat_agent_poc.session_map import allow_conversation, reject_openim_exclusion
from wechat_agent_poc.store import Store
from wechat_agent_poc.text_decode import decode_message_text

from conftest import ACCOUNT, CONVERSATION, OTHER_ACCOUNT, OTHER_GROUP, TIME, account_dir, make_config, table_for, write_db


def test_two_shards_merge_without_overwrite(tmp_path: Path):
    config = make_config(tmp_path)
    message_dir = account_dir(tmp_path / "data", ACCOUNT)
    write_db(message_dir / "message_0.db", CONVERSATION, [])
    write_db(message_dir / "message_1.db", CONVERSATION, [])
    store = Store(tmp_path / "state.sqlite")
    reader = SqlitePlainReader(config, store)
    assert reader.read_new_messages() == []
    write_db(message_dir / "message_0.db", CONVERSATION, [{"local_id": 1, "text": "shard0-A"}])
    write_db(message_dir / "message_1.db", CONVERSATION, [{"local_id": 1, "text": "shard1-A"}])
    first = reader.read_new_messages()
    assert {event.text for event in first} == {"shard0-A", "shard1-A"}
    assert len({event.event_key for event in first}) == 2
    assert all(event.is_historical is False for event in first)


def test_openim_whitelist_kept_and_non_whitelist_dropped(tmp_path: Path):
    assert reject_openim_exclusion(CONVERSATION)
    assert allow_conversation(CONVERSATION, {CONVERSATION})
    assert not allow_conversation(OTHER_GROUP, {CONVERSATION})
    config = make_config(tmp_path)
    message_dir = account_dir(tmp_path / "data", ACCOUNT)
    write_db(message_dir / "message_0.db", CONVERSATION, [], extra_conversations=[OTHER_GROUP])
    store = Store(tmp_path / "state.sqlite")
    reader = SqlitePlainReader(config, store)
    assert reader.read_new_messages() == []
    write_db(message_dir / "message_0.db", CONVERSATION, [{"local_id": 1, "text": "keep-openim"}])
    other_table = table_for(OTHER_GROUP)
    conn = sqlite3.connect(message_dir / "message_0.db")
    conn.execute(
        f'INSERT INTO "{other_table}" VALUES (1, ?, "secret-other", NULL, 9, 1, 0)',
        (TIME,),
    )
    conn.commit()
    conn.close()
    events = reader.read_new_messages()
    assert [event.text for event in events] == ["keep-openim"]
    assert all(event.conversation_key == CONVERSATION for event in events)


def test_same_body_two_native_ids(tmp_path: Path):
    config = make_config(tmp_path)
    message_dir = account_dir(tmp_path / "data", ACCOUNT)
    write_db(message_dir / "message_0.db", CONVERSATION, [])
    reader = SqlitePlainReader(config, Store(tmp_path / "s.sqlite"))
    assert reader.read_new_messages() == []
    write_db(
        message_dir / "message_0.db",
        CONVERSATION,
        [
            {"local_id": 1, "text": "same body"},
            {"local_id": 2, "text": "same body"},
        ],
    )
    events = reader.read_new_messages()
    assert len(events) == 2
    assert events[0].event_key != events[1].event_key


def test_corrupt_zstd_is_not_sendable(tmp_path: Path):
    bad = decode_message_text(b"\x28\xb5\x2f\xfd" + b"not-a-frame")
    assert not bad.sendable
    assert bad.status == "decode_error"
    ok = decode_message_text(None, zstandard.compress(b"hello-plain"))
    assert ok.sendable
    assert ok.text == "hello-plain"
    config = make_config(tmp_path)
    message_dir = account_dir(tmp_path / "data", ACCOUNT)
    write_db(message_dir / "message_0.db", CONVERSATION, [])
    reader = SqlitePlainReader(config, Store(tmp_path / "s.sqlite"))
    assert reader.read_new_messages() == []
    write_db(
        message_dir / "message_0.db",
        CONVERSATION,
        [{"local_id": 1, "text": None, "compress": b"\x28\xb5\x2f\xfdgarbage"}],
    )
    events = reader.read_new_messages()
    assert events[0].parse_status == "decode_error"
    assert events[0].text is None
    eligible, why = events[0].eligible_for_reply()
    assert not eligible


def test_does_not_select_first_discovered_account(tmp_path: Path):
    other_dir = account_dir(tmp_path / "data", OTHER_ACCOUNT)
    target_dir = account_dir(tmp_path / "data", ACCOUNT)
    write_db(other_dir / "message_0.db", CONVERSATION, [{"local_id": 1, "text": "wrong-account"}])
    write_db(target_dir / "message_0.db", CONVERSATION, [])
    discovered = list_account_directories(tmp_path / "data")
    assert discovered[0] == OTHER_ACCOUNT
    shards = discover_account_shards(tmp_path / "data", ACCOUNT)
    assert {item.account_wxid for item in shards} == {ACCOUNT}
    with pytest.raises(HaltError) as caught:
        discover_account_shards(tmp_path / "data", "wxid_missing")
    assert caught.value.halt.details["would_have_picked_first"] == OTHER_ACCOUNT
    reader = SqlitePlainReader(make_config(tmp_path), Store(tmp_path / "s.sqlite"))
    assert reader.read_new_messages() == []
    write_db(target_dir / "message_0.db", CONVERSATION, [{"local_id": 1, "text": "right-account"}])
    events = reader.read_new_messages()
    assert [event.text for event in events] == ["right-account"]
