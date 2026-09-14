from __future__ import annotations

from pathlib import Path

import pytest

from wechat_agent_poc.mocking import MockReader, make_event
from wechat_agent_poc.models import HaltError
from wechat_agent_poc.responder import MockModelClient, Responder
from wechat_agent_poc.runner import Runner
from wechat_agent_poc.store import Store

from conftest import CONVERSATION, make_config


def test_pause_and_injected_restriction_stop(tmp_path: Path):
    config = make_config(tmp_path, mode="offline", adapters={"reader": "mock"})
    store = Store(tmp_path / "s.sqlite")
    reader = MockReader(
        [
            make_event(
                conversation=CONVERSATION,
                message_id=1,
                text="账号验证限制，请完成验证",
                halt_reason="VERIFY_PROMPT",
            )
        ]
    )
    runner = Runner(config, store, reader, Responder(config, store, MockModelClient()))
    result = runner.run_bounded(max_cycles=3, max_seconds=2)
    assert result["halted"] == "VERIFY_PROMPT"
    assert store.paused()


def test_historical_and_self_do_not_draft(tmp_path: Path):
    config = make_config(tmp_path)
    store = Store(tmp_path / "s.sqlite")
    reader = MockReader(
        [
            make_event(conversation=CONVERSATION, message_id=1, text="到仓时间改到 9/20", historical=True),
            make_event(conversation=CONVERSATION, message_id=2, text="ACK", is_self="true"),
            make_event(conversation=CONVERSATION, message_id=3, text="到仓时间是哪天？"),
        ]
    )
    runner = Runner(config, store, reader, Responder(config, store, MockModelClient()))
    result = runner.run_bounded(max_cycles=1)
    assert result["drafts"] == 1
    drafts = store.list_drafts()
    assert len(drafts) == 1
    assert "9/20" in (drafts[0].text or "")


def test_read_only_skips_drafts(tmp_path: Path):
    config = make_config(tmp_path, mode="read_only")
    store = Store(tmp_path / "s.sqlite")
    reader = MockReader([make_event(conversation=CONVERSATION, message_id=1, text="到仓时间是哪天？")])
    result = Runner(config, store, reader, Responder(config, store, MockModelClient())).run_bounded()
    assert result["drafts"] == 0


def test_sqlcipher_without_key_is_blocked(tmp_path: Path):
    from wechat_agent_poc.reader import SqlcipherReader

    config = make_config(tmp_path, adapters={"reader": "sqlcipher_readonly"})
    with pytest.raises(HaltError) as caught:
        SqlcipherReader(config, Store(tmp_path / "s.sqlite")).read_new_messages()
    assert "authorized key" in caught.value.halt.message
