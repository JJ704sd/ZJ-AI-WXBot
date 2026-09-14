from __future__ import annotations

from pathlib import Path
import sqlite3

from wechat_agent_poc.discovery import discover_account_shards
from wechat_agent_poc.reader import SqlitePlainReader
from wechat_agent_poc.store import Store

from conftest import ACCOUNT, CONVERSATION, TIME, account_dir, make_config, table_for, write_db


def test_numeric_id_10_after_9_same_second(tmp_path: Path):
    config = make_config(tmp_path)
    message_dir = account_dir(tmp_path / "data", ACCOUNT)
    db = message_dir / "message_0.db"
    write_db(db, CONVERSATION, [{"local_id": 9, "text": "first", "create_time": TIME}])
    store = Store(tmp_path / "s.sqlite")
    reader = SqlitePlainReader(config, store)
    baseline = reader.read_new_messages()
    assert len(baseline) == 1 and baseline[0].is_historical
    write_db(db, CONVERSATION, [{"local_id": 10, "text": "second", "create_time": TIME}])
    second = reader.read_new_messages()
    assert [event.source_message_id for event in second] == [10]
    assert second[0].is_historical is False
    assert second[0].text == "second"


def test_late_smaller_table_after_start(tmp_path: Path):
    config = make_config(tmp_path)
    message_dir = account_dir(tmp_path / "data", ACCOUNT)
    db = message_dir / "message_0.db"
    write_db(db, CONVERSATION, [{"local_id": 1, "text": "from-z-like", "create_time": TIME}])
    store = Store(tmp_path / "s.sqlite")
    reader = SqlitePlainReader(config, store)
    reader.read_new_messages()
    write_db(
        db,
        "aaa_synthetic_other_table_not_used",
        [],
    )
    # A newly appearing bound-table row after boot must not be swallowed by another table's cursor.
    # Simulate by inserting another row into the same bound table with a lexicographically
    # smaller companion table at the same timestamp, which a global string cursor would skip.
    import sqlite3

    conn = sqlite3.connect(db)
    conn.execute(
        'CREATE TABLE "Msg_aaa" (local_id INTEGER, create_time INTEGER, message_content TEXT, compress_content BLOB, real_sender_id INTEGER, local_type INTEGER, server_id INTEGER)'
    )
    conn.execute('INSERT INTO "Msg_aaa" VALUES (1, ?, "late-other-table", NULL, 9, 1, 0)', (TIME,))
    conn.commit()
    conn.close()
    write_db(db, CONVERSATION, [{"local_id": 2, "text": "late-bound", "create_time": TIME}])
    events = reader.read_new_messages()
    texts = [event.text for event in events]
    assert "late-bound" in texts
    assert "late-other-table" not in texts


def test_new_wal_after_discovery_is_seen(tmp_path: Path):
    config = make_config(tmp_path)
    message_dir = account_dir(tmp_path / "data", ACCOUNT)
    db = message_dir / "message_0.db"
    write_db(db, CONVERSATION, [{"local_id": 1, "text": "base"}])
    store = Store(tmp_path / "s.sqlite")
    reader = SqlitePlainReader(config, store)
    reader.read_new_messages()
    first = discover_account_shards(tmp_path / "data", ACCOUNT)
    assert first[0].wal_path is None
    conn = sqlite3.connect(db)
    conn.execute("PRAGMA journal_mode=WAL")
    table = table_for(CONVERSATION)
    conn.execute(
        f'INSERT INTO "{table}" VALUES (2, ?, "after-wal", NULL, 9, 1, 0)',
        (TIME,),
    )
    conn.commit()
    second = discover_account_shards(tmp_path / "data", ACCOUNT)
    assert second[0].wal_path is not None and second[0].wal_path.exists()
    events = reader.read_new_messages()
    conn.close()
    assert [event.text for event in events] == ["after-wal"]


def test_account_namespace_in_event_key(tmp_path: Path):
    config_a = make_config(tmp_path, account={"alias": "account-a"})
    events_spec = [{"local_id": 1, "text": "hello"}]
    message_dir = account_dir(tmp_path / "data", ACCOUNT)
    write_db(message_dir / "message_0.db", CONVERSATION, events_spec)
    store = Store(tmp_path / "s.sqlite")
    one = SqlitePlainReader(config_a, store).read_new_messages()
    config_b = make_config(tmp_path, account={"alias": "account-b"})
    # Re-read same native ids under a different account alias into a fresh store.
    store_b = Store(tmp_path / "s2.sqlite")
    two = SqlitePlainReader(config_b, store_b).read_new_messages()
    assert one[0].event_key != two[0].event_key
    assert one[0].event_key.startswith("account-a|")
    assert two[0].event_key.startswith("account-b|")


def test_lookback_accepts_late_row_but_not_beyond_window(tmp_path: Path):
    config = make_config(tmp_path, lookback_seconds=120)
    message_dir = account_dir(tmp_path / "data", ACCOUNT)
    db = message_dir / "message_0.db"
    write_db(db, CONVERSATION, [{"local_id": 1, "text": "base", "create_time": TIME}])
    store = Store(tmp_path / "s.sqlite")
    reader = SqlitePlainReader(config, store)
    reader.read_new_messages()
    write_db(db, CONVERSATION, [{"local_id": 2, "text": "late-ok", "create_time": TIME - 30}])
    write_db(db, CONVERSATION, [{"local_id": 3, "text": "too-old", "create_time": TIME - 400}])
    events = reader.read_new_messages()
    by_text = {event.text: event for event in events}
    assert "late-ok" in by_text
    assert by_text["late-ok"].is_historical is False
    assert "too-old" in by_text
    assert by_text["too-old"].is_historical is True


def test_replay_does_not_create_new_event(tmp_path: Path):
    config = make_config(tmp_path)
    message_dir = account_dir(tmp_path / "data", ACCOUNT)
    write_db(message_dir / "message_0.db", CONVERSATION, [{"local_id": 3, "text": "once"}])
    store = Store(tmp_path / "s.sqlite")
    reader = SqlitePlainReader(config, store)
    reader.read_new_messages()
    write_db(message_dir / "message_0.db", CONVERSATION, [{"local_id": 4, "text": "new"}])
    second = reader.read_new_messages()
    assert [event.text for event in second] == ["new"]
    third = reader.read_new_messages()
    assert third == []
