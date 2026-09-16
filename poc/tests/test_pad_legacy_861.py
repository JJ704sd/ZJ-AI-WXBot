from __future__ import annotations

import io
import json
from datetime import datetime, timezone
from pathlib import Path
from urllib.error import URLError

import pytest

from wechat_agent_poc.api_channel import ChannelError, OutboundCommand, build_channel
from wechat_agent_poc.api_config import BindingSettings, live_arm_blockers, load_api_config, parse_api_config
from wechat_agent_poc.api_store import ApiStore
from wechat_agent_poc.clock import FrozenClock
from wechat_agent_poc.pad_legacy_channel import Legacy861Channel
from wechat_agent_poc.pad_legacy_decoder import auto_trigger_allowed, decode_sync_payload
from wechat_agent_poc.pad_legacy_receive import FileWatermark, Legacy861Receiver
from wechat_agent_poc.pad_legacy_transport import (
    PATH_HTTP_SYNC,
    PATH_SEND_TEXT,
    Legacy861Transport,
    classify_auth_generate,
    require_loopback_base,
    select_receive_channel,
    sync_count_body,
)

NOW = datetime(2026, 9, 16, 10, 0, tzinfo=timezone.utc)
ROOM = "example_group@chatroom"
SELF = "wxid_self_test"
MEMBER = "member_a"
POC = Path(__file__).resolve().parents[1]
SYNTHETIC = json.loads((POC / "fixtures" / "pad" / "legacy_http_sync_synthetic.json").read_text(encoding="utf-8"))


class ScriptedOpener:
    def __init__(self, script):
        self.script = list(script)
        self.requests = []

    def open(self, req, timeout):
        payload = json.loads(req.data.decode("utf-8")) if req.data else None
        headers = {key.lower(): value for key, value in req.header_items()}
        self.requests.append({"url": req.full_url, "payload": payload, "headers": headers, "timeout": timeout, "method": req.get_method()})
        item = self.script.pop(0)
        if isinstance(item, BaseException):
            raise item
        status, body = item
        buf = io.BytesIO(json.dumps(body).encode("utf-8"))
        buf.status = status
        return buf


def _cfg(tmp_path: Path):
    return parse_api_config(
        {
            "config_version": "api-config/1",
            "profile": "offline",
            "allow_live_read": False,
            "allow_live_send": False,
            "authorization_ref": "",
            "state_path": str(tmp_path / "api-state.sqlite"),
            "evidence_root": str(tmp_path / "runs"),
            "channel": {
                "provider": "wechatpadpro_legacy",
                "contract_version": "wechat-api-event/1",
                "base_url_ref": "env:WECHAT_GATEWAY_BASE_URL",
                "credential_ref": "env:WECHAT_PAD_DEVICE_KEY",
            },
            "binding": {"account_key": SELF, "conversation_key": ROOM, "binding_version": "bv-legacy"},
            "agent": {"model_provider": "mock"},
            "run": {"stage": "A2a", "max_seconds": 1800, "member_cooldown_seconds": 10},
            "inquiry": {"enabled": False, "target_keys": []},
        },
        source_path=tmp_path / "cfg.toml",
    )


def _env():
    return {
        "WECHAT_GATEWAY_BASE_URL": "http://127.0.0.1:9",
        "WECHAT_PAD_DEVICE_KEY": "synthetic-device-key",
    }


def _channel(tmp_path: Path, opener: ScriptedOpener, **kwargs) -> Legacy861Channel:
    transport = Legacy861Transport(opener=opener)
    return Legacy861Channel.from_config(
        _cfg(tmp_path),
        clock=FrozenClock(NOW),
        transport=transport,
        environ=_env(),
        allow_network=False,
        **kwargs,
    )


def _command(**overrides) -> OutboundCommand:
    payload = {
        "action_id": "act-1",
        "binding_version": "bv-legacy",
        "account_key": SELF,
        "conversation_key": ROOM,
        "mention_keys": (),
        "text": "ACK",
        "deadline_at": "2026-09-16T10:00:08Z",
        "idempotency_key": "act-1",
        "native_mention": False,
    }
    payload.update(overrides)
    return OutboundCommand(**payload)


def _item(**overrides):
    item = {
        "synthetic_msg_id": "1001",
        "from_user": MEMBER,
        "to_user": ROOM,
        "msg_type": 1,
        "text": "hello",
        "create_time": 1758000001,
        "is_self": False,
        "is_history": False,
        "identity_status": "resolved",
        "at_wxid_list": [SELF],
    }
    item.update(overrides)
    return {"legacy_sync_schema": "synthetic_v0", "item": item}


def test_example_legacy_config_stays_offline():
    config = load_api_config(POC / "config.api.legacy861.example.toml")
    assert config.channel.provider == "wechatpadpro_legacy"
    assert config.allow_live_read is False
    assert config.allow_live_send is False
    blockers = live_arm_blockers(config)
    assert "profile=offline cannot arm live" in blockers
    assert any("device key issuance is blocked" in item for item in blockers)


def test_http200_business_code_1_is_not_success():
    verdict = classify_auth_generate(200, {"code": 1, "Data": None, "Text": "自动注册管理员密钥失败: 查找系统用户失败"})
    assert verdict.http_200 is True
    assert verdict.business_ok is False
    assert verdict.device_key_issued is False
    assert verdict.outcome == "business_error"
    assert verdict.business_code == 1


def test_gateway_code_300_and_timeout_are_not_issued():
    late = classify_auth_generate(200, {"Code": 300, "Data": None})
    assert late.http_200 is True
    assert late.device_key_issued is False
    assert late.outcome == "business_error"
    timed = classify_auth_generate(0, None, reason="timeout")
    assert timed.outcome == "timeout"
    assert timed.business_ok is False
    unknown = classify_auth_generate(200, {"ok": True})
    assert unknown.outcome == "unknown_envelope"


def test_empty_or_zero_count_refused():
    with pytest.raises(ChannelError) as exc:
        sync_count_body(0)
    assert exc.value.code == "unbounded_sync_forbidden"
    with pytest.raises(ChannelError):
        sync_count_body(-1)
    assert sync_count_body(10) == {"Count": 10}


def test_only_http_sync_receive_channel():
    assert select_receive_channel(("http_sync",)) == "http_sync"
    with pytest.raises(ChannelError) as exc:
        select_receive_channel(("http_sync", "webhook"))
    assert exc.value.code == "multiple_receive_channels"
    with pytest.raises(ChannelError) as denied:
        select_receive_channel(("webhook",))
    assert denied.value.code == "receive_channel_unavailable"


def test_non_loopback_and_missing_key(tmp_path: Path):
    with pytest.raises(ChannelError) as exc:
        require_loopback_base("https://example.invalid/api")
    assert exc.value.code == "non_loopback_forbidden"
    ch = Legacy861Channel(
        base_url="http://127.0.0.1:9",
        device_key="",
        clock=FrozenClock(NOW),
        transport=Legacy861Transport(opener=ScriptedOpener([])),
        bound_account=SELF,
        bound_conversation=ROOM,
    )
    result = ch.submit(_command())
    assert result.status == "not_submitted"
    assert result.reason == "missing_credential"
    assert result.write_calls == 0


def test_send_timeout_unknown_does_not_retry(tmp_path: Path):
    opener = ScriptedOpener([TimeoutError("late")])
    ch = _channel(tmp_path, opener)
    first = ch.submit(_command())
    assert first.status == "unknown"
    assert first.reason == "timeout"
    second = ch.submit(_command())
    assert second.status == "unknown"
    assert second.reason == "duplicate_write_forbidden"
    assert len(opener.requests) == 1
    assert opener.requests[0]["url"].startswith("http://127.0.0.1:9" + PATH_SEND_TEXT)
    assert "synthetic-device-key" not in json.dumps(ch.transport.calls[0].payload)
    assert ch.transport.calls[0].query_key_present is True


def test_http200_send_business_failure_and_wrong_target(tmp_path: Path):
    opener = ScriptedOpener([(200, {"Code": 1, "Data": None})])
    ch = _channel(tmp_path, opener)
    failed = ch.submit(_command())
    assert failed.status == "not_submitted"
    assert failed.reason == "business_code_1"
    wrong = ch.submit(_command(action_id="act-2", conversation_key="other@chatroom"))
    assert wrong.status == "not_submitted"
    assert wrong.reason == "conversation_mismatch"
    account = ch.submit(_command(action_id="act-3", account_key="other_account"))
    assert account.reason == "account_mismatch"


def test_webhook_callback_and_max_v1_are_rejected(tmp_path: Path):
    ch = _channel(tmp_path, ScriptedOpener([]))
    with pytest.raises(ChannelError) as exc:
        ch.authenticate_callback({}, b'{"hello":true}')
    assert exc.value.code == "callback_channel_not_selected"
    schema, items = decode_sync_payload(
        {"Wxid": "x", "MessageType": "sync_message", "Data": {"messages": []}},
        received_at="2026-09-16T10:00:00Z",
        bound_account=SELF,
        bound_conversation=ROOM,
        session_epoch="epoch-1",
        self_key=SELF,
    )
    assert schema == "max_v1_rejected"
    assert items[0].action == "isolated"
    with pytest.raises(ChannelError) as unmapped:
        ch.normalize({"Code": 200, "Data": [{"MsgId": "1"}]}, received_at="2026-09-16T10:00:00Z")
    assert unmapped.value.code == "schema_unmapped"


def test_real_versus_pseudo_mention_and_history():
    real = decode_sync_payload(
        _item(),
        received_at="2026-09-16T10:00:00Z",
        bound_account=SELF,
        bound_conversation=ROOM,
        session_epoch="epoch-1",
        self_key=SELF,
    )[1][0].event
    assert real is not None
    assert auto_trigger_allowed(real, SELF) is True
    nickname_item = dict(_item()["item"])
    nickname_item.pop("at_wxid_list")
    nickname_item["text"] = "@机器人 你好"
    pseudo = decode_sync_payload(
        {"legacy_sync_schema": "synthetic_v0", "item": nickname_item},
        received_at="2026-09-16T10:00:00Z",
        bound_account=SELF,
        bound_conversation=ROOM,
        session_epoch="epoch-1",
        self_key=SELF,
    )[1][0].event
    assert pseudo is not None
    assert pseudo.mention_status == "unknown"
    assert auto_trigger_allowed(pseudo, SELF) is False
    other = decode_sync_payload(
        _item(at_wxid_list=["someone_else"]),
        received_at="2026-09-16T10:00:00Z",
        bound_account=SELF,
        bound_conversation=ROOM,
        session_epoch="epoch-1",
        self_key=SELF,
    )[1][0].event
    assert auto_trigger_allowed(other, SELF) is False
    history = decode_sync_payload(
        _item(is_history=True),
        received_at="2026-09-16T10:00:00Z",
        bound_account=SELF,
        bound_conversation=ROOM,
        session_epoch="epoch-1",
        self_key=SELF,
    )[1][0].event
    assert history.history_status == "true"
    assert auto_trigger_allowed(history, SELF) is False
    unknown_history_item = dict(_item()["item"])
    unknown_history_item.pop("is_history")
    unknown_history = decode_sync_payload(
        {"legacy_sync_schema": "synthetic_v0", "item": unknown_history_item},
        received_at="2026-09-16T10:00:00Z",
        bound_account=SELF,
        bound_conversation=ROOM,
        session_epoch="epoch-1",
        self_key=SELF,
    )[1][0].event
    assert unknown_history.history_status == "unknown"
    assert auto_trigger_allowed(unknown_history, SELF) is False


def test_large_message_id_string_and_same_body_different_ids(tmp_path: Path):
    huge = "9" * 39
    schema, items = decode_sync_payload(
        _item(synthetic_msg_id=huge),
        received_at="2026-09-16T10:00:00Z",
        bound_account=SELF,
        bound_conversation=ROOM,
        session_epoch="epoch-1",
        self_key=SELF,
    )
    assert schema == "synthetic_v0"
    assert items[0].event is not None
    assert items[0].event.native_message_id == huge
    store = ApiStore(tmp_path / "store.sqlite", clock=FrozenClock(NOW))
    first = items[0].event
    second_schema, second_items = decode_sync_payload(
        _item(synthetic_msg_id="9" * 38 + "8", text=first.text),
        received_at="2026-09-16T10:00:00Z",
        bound_account=SELF,
        bound_conversation=ROOM,
        session_epoch="epoch-1",
        self_key=SELF,
    )
    del second_schema
    second = second_items[0].event
    assert second is not None
    assert first.text == second.text
    assert first.native_message_id != second.native_message_id
    assert store.insert_inbox(first).duplicate is False
    assert store.insert_inbox(second).duplicate is False
    assert store.insert_inbox(first).duplicate is True


def test_http_sync_pull_uses_positive_count_and_watermark_survives_restart(tmp_path: Path):
    opener = ScriptedOpener(
        [
            (200, {"Code": 200, **SYNTHETIC}),
            (200, {"Code": 200, **SYNTHETIC}),
        ]
    )
    mark = FileWatermark.load(tmp_path / "wm.json")
    receiver = Legacy861Receiver(
        transport=Legacy861Transport(opener=opener),
        base_url="http://127.0.0.1:9",
        device_key="synthetic-device-key",
        bound_account=SELF,
        bound_conversation=ROOM,
        self_key="member_self",
        watermark=mark,
        clock=FrozenClock(NOW),
        sleep=lambda _seconds: None,
    )
    first = receiver.pull_once(10)
    assert opener.requests[0]["payload"] == {"Count": 10}
    assert PATH_HTTP_SYNC in opener.requests[0]["url"]
    assert first.stored == ("9007199254740993",)
    restarted = Legacy861Receiver(
        transport=Legacy861Transport(opener=opener),
        base_url="http://127.0.0.1:9",
        device_key="synthetic-device-key",
        bound_account=SELF,
        bound_conversation=ROOM,
        self_key="member_self",
        watermark=FileWatermark.load(tmp_path / "wm.json"),
        clock=FrozenClock(NOW),
    )
    second = restarted.pull_once(10)
    assert second.duplicates == ("9007199254740993",)
    with pytest.raises(ChannelError):
        receiver.pull_once(0)


def test_bounded_observe_stops_without_live_sleep():
    clock = FrozenClock(NOW)
    opener = ScriptedOpener([(200, {"Code": 200, "Data": []}), (200, {"Code": 200, "Data": []})])

    def advance(seconds: float) -> None:
        clock.advance(seconds)

    receiver = Legacy861Receiver(
        transport=Legacy861Transport(opener=opener),
        base_url="http://127.0.0.1:9",
        device_key="synthetic-device-key",
        bound_account=SELF,
        bound_conversation=ROOM,
        clock=clock,
        sleep=advance,
    )
    results = receiver.run_bounded(max_seconds=5, count=10, interval_seconds=3)
    assert len(results) >= 1
    assert receiver.pulls <= 3


def test_probe_does_not_invent_online_or_group(tmp_path: Path):
    opener = ScriptedOpener(
        [
            (200, {"Code": 200, "Data": {}}),
            (200, {"Code": 200, "Data": {"ChatRoomName": ROOM}}),
        ]
    )
    ch = _channel(tmp_path, opener)
    evidence = ch.probe(BindingSettings(SELF, ROOM, "bv-legacy"))
    assert evidence.online is False
    assert evidence.conversation_exists is False
    assert evidence.unique_conversation is False
    assert evidence.capabilities["webhook"] is False
    assert evidence.capabilities["native_mention_receive"] is False
    assert evidence.capabilities["replay_cursor"] is False


def test_build_channel_wires_legacy_provider(tmp_path: Path):
    opener = ScriptedOpener([])
    channel = build_channel(
        _cfg(tmp_path),
        clock=FrozenClock(NOW),
        transport=Legacy861Transport(opener=opener),
        environ=_env(),
        allow_network=False,
    )
    assert isinstance(channel, Legacy861Channel)
    assert channel.provider == "wechatpadpro_legacy"


def test_legacy_decoder_does_not_reuse_max_hmac_or_v1():
    import wechat_agent_poc.pad_legacy_decoder as decoder
    import wechat_agent_poc.pad_legacy_channel as channel

    assert "pad_metadata_hmac" not in decoder.__dict__
    assert "decode_v1_envelope" not in decoder.__dict__
    assert "decode_v1_envelope" not in channel.__dict__
    assert "pad_metadata_hmac" not in channel.__dict__


def _sync_batch(*native_ids: str) -> dict:
    items = [_item(synthetic_msg_id=native_id)["item"] for native_id in native_ids]
    return {"Code": 200, "legacy_sync_schema": "synthetic_v0", "items": items}


def test_late_smaller_id_and_out_of_order_batch_are_not_skipped(tmp_path: Path):
    opener = ScriptedOpener(
        [
            (200, _sync_batch("9000", "20", "50")),
            (200, _sync_batch("9", "10", "9000")),
        ]
    )
    mark = FileWatermark.load(tmp_path / "wm.json")
    receiver = Legacy861Receiver(
        transport=Legacy861Transport(opener=opener),
        base_url="http://127.0.0.1:9",
        device_key="synthetic-device-key",
        bound_account=SELF,
        bound_conversation=ROOM,
        self_key=SELF,
        watermark=mark,
        clock=FrozenClock(NOW),
    )
    first = receiver.pull_once(10)
    assert first.stored == ("9000", "20", "50")
    assert first.duplicates == ()
    payload = json.loads((tmp_path / "wm.json").read_text(encoding="utf-8"))
    assert payload["kind"] == "id_set"
    assert payload["ordering"] == "unknown"
    assert payload["monotonic_id"] is False
    restarted = Legacy861Receiver(
        transport=Legacy861Transport(opener=opener),
        base_url="http://127.0.0.1:9",
        device_key="synthetic-device-key",
        bound_account=SELF,
        bound_conversation=ROOM,
        self_key=SELF,
        watermark=FileWatermark.load(tmp_path / "wm.json"),
        clock=FrozenClock(NOW),
    )
    second = restarted.pull_once(10)
    assert second.stored == ("9", "10")
    assert second.duplicates == ("9000",)
    assert mark.seen("20") and restarted.watermark.seen("10")
    assert restarted.watermark.seen("9000")


def test_max_id_cursor_file_is_refused(tmp_path: Path):
    path = tmp_path / "max-cursor.json"
    path.write_text(json.dumps({"max_native_id": "9000", "native_message_ids": ["20"]}), encoding="utf-8")
    with pytest.raises(ChannelError) as exc:
        FileWatermark.load(path)
    assert exc.value.code == "max_id_cursor_forbidden"


def test_sync_timeout_is_unknown_not_empty_success(tmp_path: Path):
    opener = ScriptedOpener([URLError("timed out")])
    receiver = Legacy861Receiver(
        transport=Legacy861Transport(opener=opener),
        base_url="http://127.0.0.1:9",
        device_key="synthetic-device-key",
        bound_account=SELF,
        bound_conversation=ROOM,
        clock=FrozenClock(NOW),
    )
    pulled = receiver.pull_once(10)
    assert pulled.classified == "timeout"
    assert pulled.items == ()
    assert pulled.stored == ()
