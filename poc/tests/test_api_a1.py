from __future__ import annotations

import json
import sqlite3
import threading
from datetime import datetime, timedelta, timezone
from pathlib import Path

import pytest

from wechat_agent_poc.agent_policy import AgentPolicy, ScriptedCompleter
from wechat_agent_poc.api_channel import FAKE_CALLBACK_HEADER, FakeChannel
from wechat_agent_poc.api_channel import MemberMap
from wechat_agent_poc.api_config import BindingSettings, isoformat, parse_api_config
from wechat_agent_poc.api_runtime import ApiRuntime
from wechat_agent_poc.api_store import ApiStore, ApiStoreError
from wechat_agent_poc.clock import FrozenClock
from wechat_agent_poc.live_guard import live_send_blockers
from wechat_agent_poc.config import parse_config as parse_old_config

NOW = datetime(2026, 9, 16, 4, 0, tzinfo=timezone.utc)
REPLY = {
    "action": "reply",
    "relation": "unrelated",
    "text": "这是一条测试回复。",
    "slot_updates": {},
    "reason_code": "answer",
}


def _raw(tmp_path: Path, **overrides):
    data = {
        "config_version": "api-config/1",
        "profile": "offline",
        "allow_live_read": False,
        "allow_live_send": False,
        "authorization_ref": "",
        "state_path": str(tmp_path / "api-state.sqlite"),
        "evidence_root": str(tmp_path / "runs"),
        "channel": {"provider": "fake", "contract_version": "wechat-api-event/1"},
        "binding": {
            "account_key": "acct_test",
            "conversation_key": "conv_test",
            "binding_version": "bv-api",
        },
        "agent": {"model_provider": "mock", "max_input_chars": 2000, "max_output_chars": 300, "context_max_chars": 8000},
        "run": {"stage": "A3", "max_seconds": 1800, "member_cooldown_seconds": 10},
        "inquiry": {"enabled": False, "target_keys": []},
    }
    for key, value in overrides.items():
        if isinstance(value, dict) and isinstance(data.get(key), dict):
            merged = dict(data[key])
            merged.update(value)
            data[key] = merged
        else:
            data[key] = value
    return data


def _event(**overrides):
    payload = {
        "schema_version": "wechat-api-event/1",
        "provider": "fake",
        "account_key": "acct_test",
        "conversation_key": "conv_test",
        "native_message_id": "n-1",
        "session_epoch": "epoch-1",
        "occurred_at": "2026-09-16T04:00:01Z",
        "sender_key": "member_a",
        "identity_status": "resolved",
        "is_self": "false",
        "kind": "text",
        "text": "请问接入测试如何确认？",
        "mention_status": "structured",
        "mention_keys": ["member_self"],
        "mention_all": False,
        "history_status": "false",
        "parse_status": "ok",
    }
    payload.update(overrides)
    return payload


def _harness(tmp_path: Path, *, script=None, **overrides):
    clock = FrozenClock(NOW)
    config = parse_api_config(_raw(tmp_path, **overrides), source_path=tmp_path / "cfg.toml")
    store = ApiStore(config.state_path, clock=clock)
    channel = FakeChannel(clock=clock)
    completer = ScriptedCompleter(script if script is not None else [REPLY])
    policy = AgentPolicy(completer, max_output_chars=300, context_max_chars=8000)
    runtime = ApiRuntime(config, store, channel, policy, clock)
    return runtime, channel, completer, clock, store


def _fresh(clock: FrozenClock, **overrides):
    return _event(occurred_at=isoformat(clock.now() + timedelta(seconds=1)), **overrides)


def _ingest(runtime: ApiRuntime, raw: dict, token: str = "fake-offline"):
    return runtime.ingest_callback({FAKE_CALLBACK_HEADER: token}, json.dumps(raw, ensure_ascii=False).encode("utf-8"))


def test_callback_persists_then_acks(tmp_path: Path):
    runtime, channel, _, _, store = _harness(tmp_path)
    runtime.start()
    ack = _ingest(runtime, _event())
    assert ack.http_status == 200
    assert ack.code == "queued"
    row = store.get("SELECT claim_status, text FROM inbox WHERE event_key=?", (ack.event_key,))
    assert row["claim_status"] == "queued"
    assert "确认" in row["text"]
    runtime.tick()
    assert len(channel.write_calls) == 1
    assert channel.write_counts[channel.write_calls[0].action_id] == 1


def test_auth_and_missing_fields_do_not_persist(tmp_path: Path):
    runtime, _, _, _, store = _harness(tmp_path)
    runtime.start()
    denied = runtime.ingest_callback({}, json.dumps(_event()).encode())
    assert denied.http_status == 401
    missing = _ingest(runtime, {"schema_version": "wechat-api-event/1", "provider": "fake"})
    assert missing.accepted is False
    assert store.get("SELECT COUNT(*) AS n FROM inbox")["n"] == 0


def test_real_vs_fake_mention_and_identity(tmp_path: Path):
    runtime, channel, completer, _, store = _harness(tmp_path, script=[REPLY])
    runtime.start()
    _ingest(runtime, _event(native_message_id="real"))
    _ingest(runtime, _event(native_message_id="fake-at", mention_status="none", mention_keys=[], text="@本人 你好"))
    _ingest(runtime, _event(native_message_id="multi", mention_keys=["member_self", "member_b"]))
    _ingest(runtime, _event(native_message_id="all", mention_all=True, mention_keys=["member_self"]))
    _ingest(runtime, _event(native_message_id="self", is_self="true", sender_key="member_self"))
    _ingest(runtime, _event(native_message_id="amb", identity_status="ambiguous"))
    _ingest(runtime, _event(native_message_id="cross", conversation_key="other_group"))
    runtime.tick()
    assert len(channel.write_calls) == 1
    reasons = {row["ignore_reason"] for row in store.query("SELECT ignore_reason FROM inbox WHERE ignore_reason IS NOT NULL")}
    assert "not_eligible" in reasons
    assert "self_or_unknown" in reasons
    assert "identity_unresolved" in reasons
    assert store.get_count("unbound_or_private") == 1
    assert len(completer.calls) == 1


def test_duplicate_and_conflict_and_history(tmp_path: Path):
    runtime, channel, _, clock, store = _harness(tmp_path, script=[REPLY, REPLY])
    runtime.start()
    first = _ingest(runtime, _event())
    dup = _ingest(runtime, _event())
    assert dup.code == "duplicate"
    runtime.tick()
    conflict = _ingest(runtime, _event(text="不同正文"))
    assert conflict.code == "event_conflict"
    assert runtime.status().paused is True
    _ingest(runtime, _event(native_message_id="hist", history_status="true", occurred_at="2026-09-16T03:00:00Z"))
    clock.advance(1)
    runtime.tick()
    hist = store.get("SELECT ignore_reason FROM inbox WHERE native_message_id='hist'")
    assert hist is None or hist["ignore_reason"] in {None, "historical", "run_inactive"}
    assert len(channel.write_calls) == 1


def test_stale_future_and_before_baseline(tmp_path: Path):
    runtime, channel, _, clock, store = _harness(tmp_path, script=[REPLY, REPLY, REPLY])
    runtime.start()
    _ingest(runtime, _event(native_message_id="old", occurred_at="2026-09-16T03:59:00Z"))
    _ingest(runtime, _event(native_message_id="future", occurred_at="2026-09-16T05:00:00Z"))
    runtime.tick()
    clock.advance(40)
    _ingest(runtime, _event(native_message_id="late", occurred_at="2026-09-16T04:00:01Z"))
    runtime.tick()
    reasons = {row["ignore_reason"] for row in store.query("SELECT ignore_reason FROM inbox")}
    assert {"before_baseline", "future_clock", "stale"} <= reasons
    assert channel.write_calls == []


def test_model_overreach_invalid_output_no_send(tmp_path: Path):
    overreach = '{"action":"reply","relation":"unrelated","text":"hi","slot_updates":{},"reason_code":"answer","conversation_key":"x"}'
    invalid = "not-json"
    runtime, channel, _, _, store = _harness(tmp_path, script=[overreach, invalid])
    runtime.start()
    _ingest(runtime, _event(native_message_id="o"))
    _ingest(runtime, _event(native_message_id="i", occurred_at="2026-09-16T04:00:02Z"))
    runtime.tick()
    assert channel.write_calls == []
    assert store.get("SELECT model_used FROM runs")["model_used"] == 2


def test_send_timeout_5xx_crash_pause_and_no_retry(tmp_path: Path):
    runtime, channel, _, _, _ = _harness(tmp_path, script=[REPLY, REPLY, REPLY])
    runtime.start()
    channel.submit_mode = "timeout"
    _ingest(runtime, _event(native_message_id="t"))
    runtime.tick()
    assert runtime.status().paused is True
    assert runtime.status().unknown
    assert channel.write_counts[channel.write_calls[0].action_id] == 1
    runtime.stop()
    # new runtime needs its own db; cover crash on the original channel after stop+new start is refused while unknown remains on revoked run
    runtime_b, channel_b, _, _, _ = _harness(tmp_path / "b", script=[REPLY])
    runtime_b.start()
    channel_b.submit_mode = "crash"
    _ingest(runtime_b, _event())
    runtime_b.tick()
    assert runtime_b.status().paused is True
    assert runtime_b.status().unknown
    assert channel_b.write_counts[channel_b.write_calls[0].action_id] == 1
    runtime_c, channel_c, _, _, _ = _harness(tmp_path / "c", script=[REPLY])
    runtime_c.start()
    channel_c.submit_mode = "business_reject"
    _ingest(runtime_c, _event())
    runtime_c.tick()
    assert channel_c.write_calls[0]
    row = runtime_c.store.get("SELECT status FROM outbox")
    assert row["status"] == "not_submitted"
    assert runtime_c.status().paused is False


def test_crash_window_recovery_cancels_unsent(tmp_path: Path):
    runtime, _, _, _, store = _harness(tmp_path)
    runtime.start()
    with store.transaction() as txn:
        run = txn.current_run()
        action = txn.reserve_outbox(
            {
                "run_id": run["run_id"],
                "route": "passive",
                "tool": "reply_text",
                "account_key": run["account_key"],
                "conversation_key": run["conversation_key"],
                "mention_keys": (),
                "text": "queued",
                "binding_version": run["binding_version"],
                "deadline_at": "2026-09-16T04:00:08Z",
            }
        )
        txn.mark_submitting(action)
        reserved = txn.reserve_outbox(
            {
                "run_id": run["run_id"],
                "route": "passive",
                "tool": "reply_text",
                "account_key": run["account_key"],
                "conversation_key": run["conversation_key"],
                "mention_keys": (),
                "text": "reserved",
                "binding_version": run["binding_version"],
                "deadline_at": "2026-09-16T04:00:08Z",
            }
        )
    report = runtime.recover()
    assert action in report["unknown_from_submitting"]
    assert report["cancelled_unsent"] == 1
    assert store.get("SELECT status FROM outbox WHERE action_id=?", (reserved,))["status"] == "cancelled"
    assert runtime.status().paused is True


def test_old_store_is_not_migrated(tmp_path: Path):
    path = tmp_path / "old.sqlite"
    conn = sqlite3.connect(path)
    conn.execute("CREATE TABLE drafts (draft_id TEXT)")
    conn.commit()
    conn.close()
    with pytest.raises(ApiStoreError, match="old PoC"):
        ApiStore(path)


def test_two_sessions_isolated_and_unrelated_silent(tmp_path: Path):
    related = {
        "action": "reply",
        "relation": "related",
        "text": "已记录收到。现在方便继续测试吗？",
        "slot_updates": {"receipt": "true"},
        "reason_code": "missing_slot",
    }
    unrelated = {
        "action": "ignore",
        "relation": "unrelated",
        "text": None,
        "slot_updates": {},
        "reason_code": "unrelated",
    }
    complete = {
        "action": "close",
        "relation": "related",
        "text": None,
        "slot_updates": {"willingness": "true"},
        "reason_code": "complete",
    }
    runtime, channel, completer, clock, store = _harness(
        tmp_path,
        script=[related, unrelated, complete],
        run={"stage": "A4", "max_seconds": 1800, "member_cooldown_seconds": 10},
        inquiry={"enabled": True, "target_keys": ["member_a", "member_b"]},
    )
    runtime.start()
    clock.advance(120)
    runtime.tick()
    assert len(channel.write_calls) == 2
    assert all(cmd.native_mention and cmd.mention_keys for cmd in channel.write_calls)
    clock.advance(10)
    _ingest(runtime, _fresh(clock, native_message_id="a-1", sender_key="member_a", mention_status="none", mention_keys=[], text="收到"))
    _ingest(runtime, _fresh(clock, native_message_id="b-chat", sender_key="member_b", mention_status="none", mention_keys=[], text="今天天气不错"))
    runtime.tick()
    clock.advance(10)
    _ingest(runtime, _fresh(clock, native_message_id="a-2", sender_key="member_a", mention_status="none", mention_keys=[], text="现在方便"))
    runtime.tick()
    sessions = store.query("SELECT target_key, status, slots_json, context_json FROM sessions")
    by_target = {row["target_key"]: row for row in sessions}
    assert by_target["member_a"]["status"] == "completed"
    assert "天气" not in by_target["member_a"]["context_json"]
    context_b = json.loads(by_target["member_b"]["context_json"])
    assert all(item.get("role") != "user" for item in context_b)
    assert by_target["member_b"]["status"] == "awaiting_reply"
    assert "conversation_key" not in json.dumps(completer.calls, ensure_ascii=False)
    assert "acct_test" not in json.dumps(completer.calls[0], ensure_ascii=False)


def test_missed_window_and_restart_do_not_backfill(tmp_path: Path):
    runtime, channel, _, clock, store = _harness(
        tmp_path,
        run={"stage": "A4", "max_seconds": 1800, "member_cooldown_seconds": 10},
        inquiry={"enabled": True, "target_keys": ["member_a"]},
    )
    runtime.start()
    clock.advance(131)
    runtime.tick()
    assert channel.write_calls == []
    assert store.get("SELECT status FROM tasks")["status"] == "cancelled"
    runtime.stop()
    runtime2, channel2, _, clock2, _ = _harness(
        tmp_path / "n",
        run={"stage": "A4", "max_seconds": 1800, "member_cooldown_seconds": 10},
        inquiry={"enabled": True, "target_keys": ["member_a"]},
    )
    runtime2.start()
    clock2.advance(50)
    runtime2.stop()
    assert channel2.write_calls == []


def test_stop_beats_late_model(tmp_path: Path):
    gate = threading.Event()
    release = threading.Event()

    def blocking(_messages):
        gate.set()
        release.wait(2)
        return {
            "action": "reply",
            "relation": "related",
            "text": "迟到的追问",
            "slot_updates": {"receipt": "true"},
            "reason_code": "missing_slot",
        }

    runtime, channel, _, clock, store = _harness(
        tmp_path,
        script=blocking,
        run={"stage": "A4", "max_seconds": 1800, "member_cooldown_seconds": 10},
        inquiry={"enabled": True, "target_keys": ["member_a"]},
    )
    runtime.start()
    clock.advance(120)
    runtime.tick()
    clock.advance(10)
    _ingest(runtime, _fresh(clock, native_message_id="talk", mention_status="none", mention_keys=[], text="收到一半"))
    worker = ApiRuntime(runtime.config, store, channel, AgentPolicy(ScriptedCompleter([])), clock, worker_id="w2")
    thread = threading.Thread(target=runtime.tick)
    thread.start()
    assert gate.wait(2)
    _ingest(worker, _fresh(clock, native_message_id="stop", mention_status="none", mention_keys=[], text="停止测试"))
    worker.tick()
    release.set()
    thread.join(3)
    assert store.get("SELECT status FROM sessions")["status"] == "declined"
    assert not any(cmd.text == "迟到的追问" for cmd in channel.write_calls)


def test_concurrent_send_budget(tmp_path: Path):
    replies = [REPLY for _ in range(12)]
    runtime, channel, _, clock, store = _harness(tmp_path, script=replies)
    other = ApiRuntime(runtime.config, store, channel, AgentPolicy(ScriptedCompleter(replies)), clock, worker_id="w2")
    runtime.start()
    for i in range(12):
        _ingest(runtime, _event(native_message_id=f"m{i}", occurred_at="2026-09-16T04:00:01Z", text=f"问题{i}"))
    t1 = threading.Thread(target=runtime.tick)
    t2 = threading.Thread(target=other.tick)
    t1.start()
    t2.start()
    t1.join()
    t2.join()
    used = store.get("SELECT send_used, model_used FROM runs")
    assert used["send_used"] <= 10
    assert used["model_used"] <= 10
    assert len(channel.write_calls) == used["send_used"]


def test_no_nudge_when_silent(tmp_path: Path):
    runtime, channel, _, clock, _ = _harness(
        tmp_path,
        run={"stage": "A4", "max_seconds": 1800, "member_cooldown_seconds": 10},
        inquiry={"enabled": True, "target_keys": ["member_a"]},
    )
    runtime.start()
    clock.advance(120)
    runtime.tick()
    initial = len(channel.write_calls)
    clock.advance(600)
    runtime.tick()
    assert len(channel.write_calls) == initial


def test_api_modules_do_not_touch_old_live_paths():
    root = Path(__file__).resolve().parents[1] / "wechat_agent_poc"
    forbidden = ("weixin_uia", "ObservedDesktopSender", "key_material", "weixin_cipher_scan", "SendKeys")
    for name in ("api_config.py", "api_channel.py", "api_store.py", "api_runtime.py", "agent_policy.py", "api_cli.py", "gewe_channel.py", "gewe_observer.py", "gewe_observe_store.py", "observer_config.py", "observer_service.py", "observer_deploy_config.py", "pad_config.py", "pad_auth.py", "pad_decoder.py", "pad_store.py", "pad_ingress.py", "pad_observer.py", "pad_cli.py"):
        text = (root / name).read_text(encoding="utf-8")
        for token in forbidden:
            assert token not in text, f"{name} contains {token}"
        assert "WindowState" not in text


def test_resolve_members_stays_in_requested_scope():
    channel = FakeChannel(members={"member_self": "member_self", "member_a": "member_a", "stranger": "stranger"})
    binding = BindingSettings("acct_test", "conv_test", "bv-api")
    assert channel.resolve_members(binding, ("member_a",)) == (MemberMap("member_a", "member_a", "resolved"),)
    assert channel.resolve_members(binding, ()) == ()
    assert channel.resolve_members(BindingSettings("acct_test", "other", "bv-api"), ("member_a",))[0].status == "out_of_scope"


def test_old_manual_send_guards_unchanged(tmp_path: Path):
    config = parse_old_config(
        {
            "mode": "offline",
            "data_dir": str(tmp_path),
            "account": {"alias": "a"},
            "group": {"alias": "g"},
            "model": {"provider": "mock", "credential_source": "none"},
            "adapters": {"reader": "mock", "sender": "mock"},
        }
    )
    blockers = live_send_blockers(config)
    assert "live send requires mode=manual_send" in blockers
    assert "window.observer is none" in blockers
