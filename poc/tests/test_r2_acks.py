from __future__ import annotations

from pathlib import Path

import pytest

from wechat_agent_poc.hashes import sha256_text
from wechat_agent_poc.mocking import make_event
from wechat_agent_poc.models import HaltError, ReceiverEvidence
from wechat_agent_poc.review import approve
from wechat_agent_poc.sender import DesktopStubSender, MockSender, attach_receiver_evidence, send_text
from wechat_agent_poc.store import Store

from conftest import CONVERSATION, make_config


def test_r2_three_numbered_acks_require_both_receivers(tmp_path: Path):
    config = make_config(tmp_path)
    store = Store(tmp_path / "s.sqlite")
    sender = MockSender()
    verified = []
    for index in range(1, 4):
        text = f"ACK-{index:03d} 合成确认"
        event = make_event(conversation=CONVERSATION, message_id=index, text=f"请确认 {text}")
        store.ingest([event], [])
        draft = store.create_draft(event, "draft", text, [event.event_key], "fixed-ack", config.binding.binding_version)
        assert draft is not None
        approval = approve(store, config, draft.draft_id, sha256_text(text), "bv-1", "operator")
        assert send_text(store, config, sender, approval) == "sending"
        assert sender.sent[-1] == (CONVERSATION, text)
        status = attach_receiver_evidence(
            store,
            draft.draft_id,
            ReceiverEvidence(True, True, f"wecom+wechat saw {text}", "operator"),
        )
        verified.append(status)
    assert verified == ["verified", "verified", "verified"]
    assert [item[1] for item in sender.sent] == ["ACK-001 合成确认", "ACK-002 合成确认", "ACK-003 合成确认"]
    assert [row.status for row in store.list_drafts(("verified",))] == ["verified", "verified", "verified"]


def test_r2_desktop_stub_does_not_send(tmp_path: Path):
    config = make_config(tmp_path)
    store = Store(tmp_path / "s.sqlite")
    event = make_event(conversation=CONVERSATION, message_id=1, text="请确认 ACK-001")
    store.ingest([event], [])
    draft = store.create_draft(event, "draft", "ACK-001 合成确认", [event.event_key], "fixed-ack", "bv-1")
    approval = approve(store, config, draft.draft_id, sha256_text("ACK-001 合成确认"), "bv-1", "operator")
    with pytest.raises(HaltError) as caught:
        send_text(store, config, DesktopStubSender(), approval)
    assert caught.value.halt.reason == "WINDOW_MISMATCH"
    assert store.get_draft(draft.draft_id).status == "failed"
