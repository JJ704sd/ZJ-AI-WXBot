from __future__ import annotations

import sqlite3
from pathlib import Path

import pytest

from wechat_agent_poc.mocking import make_event
from wechat_agent_poc.models import Event
from wechat_agent_poc.store import Checkpoint, Store

from conftest import CONVERSATION


def test_ingest_and_checkpoint_same_transaction(tmp_path: Path):
    store = Store(tmp_path / "s.sqlite")
    event = make_event(conversation=CONVERSATION, message_id=1, text="n")
    checkpoint = Checkpoint("test-wechat-a", "message_0", "Msg_demo", 10, 1, True)
    original = store.ingest

    def exploding(events, checkpoints):
        with store.connect() as conn:
            conn.execute("INSERT INTO seen_keys(event_key, observed_at) VALUES (?, ?)", ("partial", "now"))
            raise RuntimeError("boom")

    store.ingest = exploding  # type: ignore[method-assign]
    with pytest.raises(RuntimeError):
        store.ingest([event], [checkpoint])
    store.ingest = original  # type: ignore[method-assign]
    with store.connect() as conn:
        assert conn.execute("SELECT COUNT(*) AS n FROM seen_keys").fetchone()["n"] == 0
    store.ingest([event], [checkpoint])
    assert store.get_event(event.event_key) is not None
    assert store.checkpoint("test-wechat-a", "message_0", "Msg_demo") is not None


def test_replay_persisted(tmp_path: Path):
    store = Store(tmp_path / "s.sqlite")
    event = make_event(conversation=CONVERSATION, message_id=8, text="dup")
    first = store.ingest([event], [])
    second = store.ingest([event], [])
    assert len(first) == 1
    assert second == []
    with store.connect() as conn:
        row = conn.execute("SELECT is_replay FROM events WHERE event_key=?", (event.event_key,)).fetchone()
    assert row["is_replay"] == 1
