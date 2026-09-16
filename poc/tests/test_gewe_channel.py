from __future__ import annotations

import io
import json
from pathlib import Path
from urllib.error import HTTPError, URLError

from wechat_agent_poc.api_channel import ChannelError, OutboundCommand, build_channel
from wechat_agent_poc.api_cli import main
from wechat_agent_poc.api_config import BindingSettings, parse_api_config
from wechat_agent_poc.clock import FrozenClock
from datetime import datetime, timezone

from wechat_agent_poc.gewe_channel import (
    BRIDGE_HEADER,
    PATH_CHECK_ONLINE,
    PATH_MEMBER_DETAIL,
    PATH_POST_TEXT,
    PATH_PROFILE,
    GeweChannel,
    GeweTransport,
)

NOW = datetime(2026, 9, 16, 4, 0, tzinfo=timezone.utc)
ROOM = "example_group@chatroom"
SELF = "wxid_self_test"
APP = "wx_device_test"


class ScriptedOpener:
    def __init__(self, script):
        self.script = list(script)
        self.requests = []

    def open(self, req, timeout):
        payload = json.loads(req.data.decode("utf-8")) if req.data else {}
        headers = {k.lower(): v for k, v in req.header_items()}
        self.requests.append({"url": req.full_url, "payload": payload, "headers": headers, "timeout": timeout})
        item = self.script.pop(0)
        if isinstance(item, BaseException):
            raise item
        status, body = item
        buf = io.BytesIO(json.dumps(body).encode("utf-8"))
        buf.status = status
        return buf


def _cfg(tmp_path: Path, **channel):
    raw = {
        "config_version": "api-config/1",
        "profile": "offline",
        "allow_live_read": False,
        "allow_live_send": False,
        "authorization_ref": "",
        "state_path": str(tmp_path / "api-state.sqlite"),
        "evidence_root": str(tmp_path / "runs"),
        "channel": {
            "provider": "geweapi",
            "contract_version": "wechat-api-event/1",
            "base_url_ref": "env:WECHAT_GATEWAY_BASE_URL",
            "credential_ref": "env:WECHAT_GATEWAY_TOKEN",
            "app_id_ref": "env:WECHAT_GATEWAY_APP_ID",
            "callback_bridge_token_ref": "env:WECHAT_CALLBACK_BRIDGE_TOKEN",
            "provider_profile_path": "",
            **channel,
        },
        "binding": {"account_key": SELF, "conversation_key": ROOM, "binding_version": "bv-gewe"},
        "agent": {"model_provider": "mock"},
        "run": {"stage": "A2a", "max_seconds": 1800, "member_cooldown_seconds": 10},
        "inquiry": {"enabled": False, "target_keys": []},
    }
    return parse_api_config(raw, source_path=tmp_path / "cfg.toml")


def _env():
    return {
        "WECHAT_GATEWAY_BASE_URL": "http://127.0.0.1:9",
        "WECHAT_GATEWAY_TOKEN": "secret-token-do-not-log",
        "WECHAT_GATEWAY_APP_ID": APP,
        "WECHAT_CALLBACK_BRIDGE_TOKEN": "bridge-secret",
    }


def _channel(tmp_path: Path, opener: ScriptedOpener) -> GeweChannel:
    transport = GeweTransport(opener=opener)
    return GeweChannel.from_config(
        _cfg(tmp_path),
        clock=FrozenClock(NOW),
        transport=transport,
        environ=_env(),
        allow_network=False,
    )


def _event(**overrides):
    payload = {
        "appid": APP,
        "wxid": SELF,
        "content": "@机器人 现在方便测试吗？",
        "createTime": 1758000001,
        "fromUser": "wxid_member_a",
        "isSelf": False,
        "msgId": 1298811784,
        "msgType": "TEXT",
        "newMsgId": 3768973957878705000,
        "toUser": ROOM,
    }
    payload.update(overrides)
    return payload


def test_callback_auth_and_v1_rejected(tmp_path: Path):
    ch = _channel(tmp_path, ScriptedOpener([]))
    body = json.dumps(_event()).encode()
    try:
        ch.authenticate_callback({}, body)
        raise AssertionError("missing bridge token must fail")
    except ChannelError as exc:
        assert exc.http_status == 401
    ch.authenticate_callback({BRIDGE_HEADER: "bridge-secret"}, body)
    try:
        ch.normalize({"TypeName": "AddMsg", "Appid": APP, "Data": {"NewMsgId": 1}}, received_at="2026-09-16T04:00:01Z")
        raise AssertionError("v1 payload must fail")
    except ChannelError as exc:
        assert exc.code == "unsupported_version"


def test_normalize_group_text_keeps_id_precision_and_unknown_mention(tmp_path: Path):
    ch = _channel(tmp_path, ScriptedOpener([]))
    event = ch.normalize(_event(), received_at="2026-09-16T04:00:01Z")
    assert event.provider == "geweapi"
    assert event.native_message_id == "3768973957878705000"
    assert event.account_key == SELF
    assert event.conversation_key == ROOM
    assert event.sender_key == "wxid_member_a"
    assert event.is_self == "false"
    assert event.mention_status == "unknown"
    assert event.mention_keys == ()
    assert event.history_status == "unknown"
    assert event.identity_status == "unknown"
    assert event.session_epoch == "unbound"
    try:
        ch.normalize(_event(newMsgId=1.5), received_at="2026-09-16T04:00:01Z")
        raise AssertionError("float id must fail")
    except ChannelError as exc:
        assert exc.code == "invalid_native_id"


def test_resolve_members_only_queries_requested_room_ids(tmp_path: Path):
    opener = ScriptedOpener(
        [
            (
                200,
                {
                    "ret": 200,
                    "msg": "ok",
                    "data": [{"userName": "wxid_member_a", "nickName": "A"}],
                },
            )
        ]
    )
    ch = _channel(tmp_path, opener)
    binding = BindingSettings(SELF, ROOM, "bv-gewe")
    maps = ch.resolve_members(binding, ("wxid_member_a", "wxid_missing"))
    assert maps[0].status == "resolved"
    assert maps[1].status == "not_found"
    assert opener.requests[0]["url"].endswith(PATH_MEMBER_DETAIL)
    assert opener.requests[0]["payload"] == {
        "appId": APP,
        "chatroomId": ROOM,
        "memberWxids": ["wxid_member_a", "wxid_missing"],
    }
    assert ch.resolve_members(binding, ()) == ()


def test_submit_fields_no_retry_and_result_mapping(tmp_path: Path):
    accepted = {
        "ret": 200,
        "msg": "操作成功",
        "data": {"toWxid": ROOM, "createTime": 1703841160, "msgId": 0, "newMsgId": 3768973957878705000, "type": 1},
    }
    opener = ScriptedOpener([(200, accepted)])
    ch = _channel(tmp_path, opener)
    command = OutboundCommand(
        action_id="act-1",
        binding_version="bv-gewe",
        account_key=SELF,
        conversation_key=ROOM,
        mention_keys=("wxid_member_a",),
        text="这是一条 Agent 接入测试。",
        deadline_at="2026-09-16T04:00:08Z",
        idempotency_key="idem-1",
        native_mention=True,
    )
    result = ch.submit(command)
    assert result.status == "accepted"
    assert result.provider_message_id == "3768973957878705000"
    assert result.write_calls == 1
    req = opener.requests[0]
    assert req["url"].endswith(PATH_POST_TEXT)
    assert req["payload"]["appId"] == APP
    assert req["payload"]["toWxid"] == ROOM
    assert req["payload"]["ats"] == "wxid_member_a"
    assert req["payload"]["content"].startswith("@ ")
    assert "猿猴" not in req["payload"]["content"]
    assert "secret-token-do-not-log" not in json.dumps(req["payload"])
    second = ch.submit(command)
    assert second.status == "unknown"
    assert second.reason == "duplicate_write_forbidden"
    assert len(opener.requests) == 1


def test_http_business_timeout_and_5xx(tmp_path: Path):
    ch = _channel(tmp_path, ScriptedOpener([(200, {"ret": 500, "msg": "失败", "data": {}})]))
    command = OutboundCommand("a", "bv", SELF, ROOM, (), "hi", "2026-09-16T04:00:08Z", "i")
    assert ch.submit(command).status == "not_submitted"
    ch2 = _channel(tmp_path, ScriptedOpener([URLError("timed out")]))
    assert ch2.submit(command).status == "unknown"
    assert ch2.submit(command).reason == "duplicate_write_forbidden"
    err = HTTPError("http://127.0.0.1:9/x", 503, "x", hdrs={}, fp=io.BytesIO(b""))
    ch3 = _channel(tmp_path, ScriptedOpener([err]))
    assert ch3.submit(command).status == "unknown"


def test_probe_uses_online_and_profile_not_send(tmp_path: Path):
    opener = ScriptedOpener(
        [
            (200, {"ret": 200, "msg": "ok", "data": True}),
            (200, {"ret": 200, "msg": "ok", "data": {"wxid": SELF, "mobile": "mobile-synthetic", "nickName": "n"}}),
            (200, {"ret": 200, "msg": "ok", "data": [{"userName": SELF}]}),
        ]
    )
    ch = _channel(tmp_path, opener)
    evidence = ch.probe(BindingSettings(SELF, ROOM, "bv-gewe"))
    assert evidence.online is True
    assert evidence.account_key == SELF
    assert evidence.conversation_exists is True
    paths = [item["url"].split("http://127.0.0.1:9")[-1] for item in opener.requests]
    assert paths == [PATH_CHECK_ONLINE, PATH_PROFILE, PATH_MEMBER_DETAIL]
    assert PATH_POST_TEXT not in paths
    dumped = json.dumps(dict(evidence.capabilities) | {"account_key": evidence.account_key})
    assert "mobile-synthetic" not in dumped
    assert evidence.capabilities["native_mention_receive"] is False


def test_build_channel_factory_and_status_cli_have_no_http(tmp_path: Path, capsys):
    config = _cfg(tmp_path)
    channel = build_channel(config, environ=_env(), allow_network=False)
    assert isinstance(channel, GeweChannel)
    cfg = tmp_path / "g.toml"
    cfg.write_text(
        f"""
config_version = "api-config/1"
profile = "offline"
allow_live_read = false
allow_live_send = false
authorization_ref = ""
state_path = "{(tmp_path / "st.sqlite").as_posix()}"
evidence_root = "{(tmp_path / "runs").as_posix()}"
[channel]
provider = "geweapi"
contract_version = "wechat-api-event/1"
base_url_ref = "env:WECHAT_GATEWAY_BASE_URL"
credential_ref = "env:WECHAT_GATEWAY_TOKEN"
app_id_ref = "env:WECHAT_GATEWAY_APP_ID"
callback_bridge_token_ref = "env:WECHAT_CALLBACK_BRIDGE_TOKEN"
[binding]
account_key = ""
conversation_key = ""
binding_version = ""
[agent]
model_provider = "mock"
[run]
stage = "A1"
max_seconds = 1800
member_cooldown_seconds = 10
[inquiry]
enabled = false
target_keys = []
""",
        encoding="utf-8",
    )
    assert main(["--config", str(cfg), "api-status"]) == 0
    out = capsys.readouterr().out
    assert "network" in out
    assert main(["--config", str(cfg), "api-stop"]) == 0
    capsys.readouterr()
    assert main(["--config", str(cfg), "api-verify", "act-x", "--operator", "tester"]) == 0
    capsys.readouterr()
    assert main(["--config", str(cfg), "api-check", "--probe"]) == 0
    check_out = capsys.readouterr().out
    assert "checkOnline" in check_out
    assert "未执行" in check_out
    assert main(["--config", str(cfg), "api-observe"]) == 2
    assert "未执行" in capsys.readouterr().out


def test_network_disabled_without_injected_opener(tmp_path: Path):
    ch = GeweChannel.from_config(_cfg(tmp_path), environ=_env(), allow_network=False)
    try:
        ch.probe(BindingSettings(SELF, ROOM, "bv-gewe"))
        raise AssertionError("probe must not open live HTTP")
    except ChannelError as exc:
        assert exc.code == "network_disabled"
    command = OutboundCommand("a", "bv", SELF, ROOM, (), "hi", "2026-09-16T04:00:08Z", "i")
    try:
        ch.submit(command)
        raise AssertionError("submit must not open live HTTP")
    except ChannelError as exc:
        assert exc.code == "network_disabled"


def test_invalid_json_and_string_message_id(tmp_path: Path):
    event = _channel(tmp_path, ScriptedOpener([])).normalize(
        _event(newMsgId="3768973957878705000"),
        received_at="2026-09-16T04:00:01Z",
    )
    assert event.native_message_id == "3768973957878705000"

    class BadBody:
        status = 200

        def read(self, n):
            return b"not-json"

        def __enter__(self):
            return self

        def __exit__(self, *args):
            return False

    class BadOpener:
        def open(self, req, timeout):
            return BadBody()

    ch = GeweChannel.from_config(
        _cfg(tmp_path),
        transport=GeweTransport(opener=BadOpener()),
        environ=_env(),
    )
    result = ch.submit(OutboundCommand("a", "bv", SELF, ROOM, (), "hi", "2026-09-16T04:00:08Z", "i"))
    assert result.status == "unknown"
