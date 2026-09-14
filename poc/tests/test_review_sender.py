from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path

import pytest

from wechat_agent_poc.clock import FrozenClock
from wechat_agent_poc.hashes import sha256_text
from wechat_agent_poc.mocking import make_event
from wechat_agent_poc.models import HaltError, ReceiverEvidence, WindowState
from wechat_agent_poc.review import approve, format_draft, reject
from wechat_agent_poc.sender import MockSender, attach_receiver_evidence, send_text
from wechat_agent_poc.store import Store

from conftest import CONVERSATION, make_config


def _draft(tmp_path: Path, text: str = "ACK-001 合成确认"):
    clock = FrozenClock(datetime(2026, 9, 14, 3, 0, tzinfo=timezone.utc))
    store = Store(tmp_path / "s.sqlite", clock=clock)
    config = make_config(tmp_path)
    event = make_event(conversation=CONVERSATION, message_id=1, text="请确认 ACK-001")
    store.ingest([event], [])
    draft = store.create_draft(event, "draft", text, [event.event_key], "fixed", config.binding.binding_version)
    assert draft is not None
    return store, config, draft, clock


def test_review_requires_exact_hash_and_binding(tmp_path: Path):
    store, config, draft, _ = _draft(tmp_path)
    rendered = format_draft(store, draft)
    assert "请确认 ACK-001" in rendered
    assert "合成测试" in config.binding.display_name or "synthetic_group" in rendered
    with pytest.raises(HaltError):
        approve(store, config, draft.draft_id, "sha256:dead", "bv-1", "op")
    with pytest.raises(HaltError):
        approve(store, config, draft.draft_id, draft.text_hash or "", "bv-old", "op")
    approval = approve(store, config, draft.draft_id, draft.text_hash or "", "bv-1", "op")
    assert approval.startswith("appr-")


def test_approval_expires_and_text_change(tmp_path: Path):
    store, config, draft, clock = _draft(tmp_path)
    approval = approve(store, config, draft.draft_id, draft.text_hash or "", "bv-1", "op")
    clock.advance(301)
    with pytest.raises(HaltError) as expired:
        send_text(store, config, MockSender(), approval)
    assert expired.value.halt.reason == "REVIEW_EXPIRED"
    store2, config2, draft2, _ = _draft(tmp_path / "b", text="old")
    with store2.connect() as conn:
        conn.execute("UPDATE drafts SET text=? WHERE draft_id=?", ("tampered", draft2.draft_id))
    with pytest.raises(HaltError):
        approve(store2, config2, draft2.draft_id, sha256_text("old"), "bv-1", "op")


def test_send_persists_sending_and_needs_receivers(tmp_path: Path):
    store, config, draft, _ = _draft(tmp_path)
    approval = approve(store, config, draft.draft_id, draft.text_hash or "", "bv-1", "op")
    status = send_text(store, config, MockSender(), approval)
    assert status == "sending"
    assert store.get_draft(draft.draft_id).status == "sending"
    verified = attach_receiver_evidence(
        store,
        draft.draft_id,
        ReceiverEvidence(True, True, "both clients saw ACK-001", "op"),
    )
    assert verified == "verified"


def test_unknown_send_does_not_retry(tmp_path: Path):
    store, config, draft, _ = _draft(tmp_path)
    approval = approve(store, config, draft.draft_id, draft.text_hash or "", "bv-1", "op")
    sender = MockSender()
    sender.next_result.status = "unknown"
    status = send_text(store, config, sender, approval)
    assert status == "uncertain"
    with pytest.raises(HaltError) as caught:
        send_text(store, config, sender, approval)
    assert caught.value.halt.reason == "SENDING_UNCERTAIN"


def test_restart_sending_becomes_uncertain(tmp_path: Path):
    store, config, draft, _ = _draft(tmp_path)
    approval = approve(store, config, draft.draft_id, draft.text_hash or "", "bv-1", "op")
    send_text(store, config, MockSender(), approval)
    recovered = store.recover_sending()
    assert recovered == [draft.draft_id]
    assert store.get_draft(draft.draft_id).status == "uncertain"
    assert store.paused()


def test_name_search_only_is_rejected(tmp_path: Path):
    store, config, draft, _ = _draft(tmp_path)
    approval = approve(store, config, draft.draft_id, draft.text_hash or "", "bv-1", "op")
    window = WindowState(
        account_alias=config.binding.account_alias,
        account_wxid=config.binding.account_wxid,
        display_name=config.binding.display_name,
        conversation_key=config.binding.conversation_key,
        details="合成测试群 external-poc",
        member_features=config.binding.member_features,
        located_by="name_search_only",
    )
    with pytest.raises(HaltError) as caught:
        send_text(store, config, MockSender(), approval, window)
    assert caught.value.halt.reason == "WINDOW_MISMATCH"


def test_ambiguous_runtime_id_cannot_reply():
    event = make_event(
        conversation=CONVERSATION,
        message_id=None,
        text="ui text",
        identity="ambiguous",
        runtime_id="runtime-1",
    )
    ok, why = event.eligible_for_reply()
    assert ok is False
    assert why == "identity_unresolved" or why == "missing_native_id"


def test_one_task_per_event(tmp_path: Path):
    store, config, draft, _ = _draft(tmp_path)
    event = store.get_event(draft.event_key)
    again = store.create_draft(event, "draft", "other", [draft.event_key], "x", "bv-1")
    assert again.draft_id == draft.draft_id
