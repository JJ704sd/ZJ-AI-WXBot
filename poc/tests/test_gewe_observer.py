from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path
from urllib.error import HTTPError
from urllib.request import Request, urlopen
import json
import socket
import threading
import time

import pytest

from wechat_agent_poc.api_channel import ChannelError
from wechat_agent_poc.api_cli import main
from wechat_agent_poc.api_config import live_arm_blockers, parse_api_config
from wechat_agent_poc.clock import FrozenClock
from wechat_agent_poc.config import ConfigError
from wechat_agent_poc.gewe_channel import PATH_POST_TEXT, GeweTransport
from wechat_agent_poc.gewe_observe_store import ObserveStore
from wechat_agent_poc.gewe_observer import (
    GeweObserver,
    ReadOnlyGeweClient,
    VerifiedIngress,
    build_callback_app,
)
from wechat_agent_poc.observer_config import observe_blockers, parse_observer_config

NOW = datetime(2026, 9, 16, 6, 0, tzinfo=timezone.utc)
ROOM = "example_group@chatroom"
SELF = "wxid_self_test"
APP = "wx_device_test"
CALLBACK_SECRET = "c" * 32
BRIDGE_TOKEN = "b" * 32
OTHER_SECRET = "d" * 32


def _observer_raw(tmp_path: Path, **overrides):
    data = {
        "config_version": "observer-config/1",
        "enabled": True,
        "allow_live_send": False,
        "allow_model": False,
        "allow_network": False,
        "authorization_ref": "g1-offline",
        "bind_host": "127.0.0.1",
        "bind_port": 0,
        "max_seconds": 1800,
        "max_samples": 200,
        "max_body_bytes": 10485760,
        "ingress": {
            "mode": "none",
            "callback_secret_ref": "env:WECHAT_CALLBACK_SECRET",
            "bridge_token_ref": "env:WECHAT_CALLBACK_BRIDGE_TOKEN",
            "path_prefix": "/callbacks/gewe",
        },
        "channel": {
            "provider": "geweapi",
            "base_url_ref": "env:WECHAT_GATEWAY_BASE_URL",
            "credential_ref": "env:WECHAT_GATEWAY_TOKEN",
            "app_id_ref": "env:WECHAT_GATEWAY_APP_ID",
        },
        "binding": {
            "account_key": SELF,
            "conversation_key": ROOM,
            "binding_version": "bv-obs",
            "candidate_member_keys": ["wxid_member_a"],
        },
        "store": {"path": str(tmp_path / "gewe-observe" / "observe.sqlite")},
        "probe": {},
    }
    for key, value in overrides.items():
        if isinstance(value, dict) and isinstance(data.get(key), dict):
            merged = dict(data[key])
            merged.update(value)
            data[key] = merged
        else:
            data[key] = value
    return data


def _env():
    return {
        "WECHAT_CALLBACK_SECRET": CALLBACK_SECRET,
        "WECHAT_CALLBACK_BRIDGE_TOKEN": BRIDGE_TOKEN,
        "WECHAT_GATEWAY_BASE_URL": "https://example.invalid",
        "WECHAT_GATEWAY_TOKEN": "api-token-secret",
        "WECHAT_GATEWAY_APP_ID": APP,
    }


def _observer(tmp_path: Path, **overrides) -> GeweObserver:
    config = parse_observer_config(_observer_raw(tmp_path, **overrides), source_path=tmp_path / "obs.toml", environ=_env())
    store = ObserveStore(config.store_path, clock=FrozenClock(NOW))
    return GeweObserver(config, store, clock=FrozenClock(NOW), environ=_env())


def _event(**overrides):
    payload = {
        "appid": APP,
        "wxid": SELF,
        "content": "@机器人 现在方便测试吗？",
        "createTime": 1758000001,
        "fromUser": "wxid_member_a",
        "isSelf": False,
        "msgType": "TEXT",
        "newMsgId": 3768973957878705000,
        "toUser": ROOM,
    }
    payload.update(overrides)
    return payload


def test_example_observer_config_is_disabled():
    from wechat_agent_poc.observer_config import load_observer_config

    config = load_observer_config(Path(__file__).resolve().parents[1] / "config.observer.example.toml")
    assert config.enabled is False
    assert config.ingress.mode == "none"
    assert config.allow_live_send is False
    blockers = observe_blockers(config)
    assert "observer.enabled is false" in blockers


def test_send_and_vendor_signature_rejected(tmp_path: Path):
    with pytest.raises(ConfigError, match="allow_live_send"):
        parse_observer_config(_observer_raw(tmp_path, allow_live_send=True), source_path=tmp_path / "x.toml")
    with pytest.raises(ConfigError, match="vendor_signature"):
        parse_observer_config(
            _observer_raw(tmp_path, ingress={"mode": "vendor_signature"}),
            source_path=tmp_path / "x.toml",
        )


def test_store_path_cannot_reuse_agent_db(tmp_path: Path):
    with pytest.raises(ConfigError, match="cannot reuse"):
        parse_observer_config(
            _observer_raw(tmp_path, store={"path": str(tmp_path / "api-agent" / "state.sqlite")}),
            source_path=tmp_path / "x.toml",
        )


def test_agent_blockers_keep_mention_and_history_gaps():
    config = parse_api_config(
        {
            "config_version": "api-config/1",
            "profile": "observe",
            "allow_live_read": True,
            "allow_live_send": False,
            "authorization_ref": "auth",
            "state_path": ".local/api-agent/state.sqlite",
            "evidence_root": ".local/api-agent/runs",
            "channel": {
                "provider": "geweapi",
                "contract_version": "wechat-api-event/1",
                "base_url_ref": "env:WECHAT_GATEWAY_BASE_URL",
                "credential_ref": "env:WECHAT_GATEWAY_TOKEN",
                "app_id_ref": "env:WECHAT_GATEWAY_APP_ID",
                "callback_bridge_token_ref": "env:WECHAT_CALLBACK_BRIDGE_TOKEN",
            },
            "binding": {"account_key": SELF, "conversation_key": ROOM, "binding_version": "bv"},
            "agent": {"model_provider": "mock"},
            "run": {"stage": "A2a", "max_seconds": 1800, "member_cooldown_seconds": 10},
            "inquiry": {"enabled": False, "target_keys": []},
        }
    )
    blockers = live_arm_blockers(config)
    assert any("native @ receive" in item for item in blockers)
    assert any("history" in item for item in blockers)


def test_synthetic_accept_filters_and_unknown_fields(tmp_path: Path):
    observer = _observer(tmp_path)
    run_id = observer.start()
    verified = VerifiedIngress("synthetic", BRIDGE_TOKEN)
    body = json.dumps(_event()).encode()
    ack = observer.accept(verified, body)
    assert ack.http_status == 200
    assert ack.stored is True
    sample = observer.store.samples()[0]
    assert sample["native_message_id"] == "3768973957878705000"
    assert sample["mention_status"] == "unknown"
    assert sample["history_status"] == "unknown"
    assert sample["identity_status"] == "unknown"
    assert sample["sender_key"] == "wxid_member_a"
    private = json.dumps(_event(toUser="wxid_stranger", fromUser="wxid_stranger"))
    ack2 = observer.accept(verified, private.encode())
    assert ack2.http_status == 200
    assert ack2.stored is False
    assert observer.store.sample_count() == 1
    assert observer.store.counters()["out_of_scope"] == 1
    dup = observer.accept(verified, body)
    assert dup.code == "duplicate"
    assert observer.store.sample_count() == 1
    conflict = observer.accept(verified, json.dumps(_event(content="changed")).encode())
    assert conflict.details.get("paused") or observer.status().status == "paused"
    assert observer.send_calls == 0
    assert observer.model_calls == 0
    assert observer.task_creates == 0
    assert run_id


def test_bridge_and_callback_secrets_are_not_interchangeable(tmp_path: Path):
    observer = _observer(tmp_path, ingress={"mode": "callback_bearer"})
    observer.start()
    wrong_bridge = observer.accept(VerifiedIngress("callback_bearer", CALLBACK_SECRET), json.dumps(_event()).encode())
    assert wrong_bridge.http_status == 401
    assert observer.store.sample_count() == 0
    vendor = observer.accept(VerifiedIngress("vendor_verified", BRIDGE_TOKEN), json.dumps(_event()).encode())
    assert vendor.http_status == 401
    assert observer.store.sample_count() == 0


def test_float_id_and_openim_not_treated_as_room(tmp_path: Path):
    observer = _observer(tmp_path)
    observer.start()
    verified = VerifiedIngress("synthetic", BRIDGE_TOKEN)
    ack = observer.accept(verified, json.dumps(_event(newMsgId=1.5)).encode())
    assert ack.http_status == 200
    sample = observer.store.samples()[0]
    assert sample["parse_status"] == "error"
    ack2 = observer.accept(
        verified,
        json.dumps(_event(fromUser="wxid_corp@openim", toUser="wxid_corp@openim", newMsgId=99)).encode(),
    )
    assert ack2.stored is False
    assert observer.store.counters()["out_of_scope"] == 1


def test_stop_rejects_later_persist(tmp_path: Path):
    observer = _observer(tmp_path)
    observer.start()
    observer.stop("operator_stop")
    ack = observer.accept(VerifiedIngress("synthetic", BRIDGE_TOKEN), json.dumps(_event()).encode())
    assert ack.http_status == 503
    assert observer.store.sample_count() == 0
    assert observer.status().status == "stopped"


def test_capacity_stops_new_bodies(tmp_path: Path):
    observer = _observer(tmp_path, max_samples=1)
    observer.start()
    verified = VerifiedIngress("synthetic", BRIDGE_TOKEN)
    assert observer.accept(verified, json.dumps(_event()).encode()).stored is True
    ack = observer.accept(verified, json.dumps(_event(newMsgId=2)).encode())
    assert ack.http_status == 503
    assert observer.store.sample_count() == 1


def test_readonly_client_rejects_write_and_plaintext_public_root():
    client = ReadOnlyGeweClient(base_url="http://api.geweapi.com", token="t", app_id=APP, allow_network=True)
    try:
        client.check_online()
        raise AssertionError("plaintext public root must fail")
    except ChannelError as exc:
        assert exc.code == "https_required"
    transport = GeweTransport(opener=object())
    client2 = ReadOnlyGeweClient(
        base_url="https://example.invalid",
        token="t",
        app_id=APP,
        transport=transport,
        allow_network=True,
    )
    try:
        client2._post(PATH_POST_TEXT, {"appId": APP})
        raise AssertionError("postText must fail")
    except ChannelError as exc:
        assert exc.code == "write_forbidden"
        assert client2.rejected_writes == 1
    assert client2.calls == []


def test_construct_and_status_do_not_network(tmp_path: Path):
    class Boom:
        def open(self, req, timeout):
            raise AssertionError("network")

    transport = GeweTransport(opener=Boom())
    client = ReadOnlyGeweClient(
        base_url="https://example.invalid",
        token="t",
        app_id=APP,
        transport=transport,
        allow_network=False,
        allow_loopback_http=True,
    )
    observer = _observer(tmp_path)
    observer.readonly_client = client
    observer.start()
    observer.status()
    observer.stop("done")
    assert client.calls == []


def test_cli_observer_start_status_stop_and_agent_untouched(tmp_path: Path, capsys):
    cfg = tmp_path / "obs.toml"
    cfg.write_text(
        f"""
config_version = "observer-config/1"
enabled = true
allow_live_send = false
allow_model = false
allow_network = false
authorization_ref = "g1-offline"
bind_host = "127.0.0.1"
bind_port = 0
[ingress]
mode = "none"
callback_secret_ref = "env:WECHAT_CALLBACK_SECRET"
bridge_token_ref = "env:WECHAT_CALLBACK_BRIDGE_TOKEN"
[channel]
provider = "geweapi"
base_url_ref = "env:WECHAT_GATEWAY_BASE_URL"
credential_ref = "env:WECHAT_GATEWAY_TOKEN"
app_id_ref = "env:WECHAT_GATEWAY_APP_ID"
[binding]
account_key = "{SELF}"
conversation_key = "{ROOM}"
binding_version = "bv-obs"
candidate_member_keys = ["wxid_member_a"]
[store]
path = "{(tmp_path / "gewe-observe" / "observe.sqlite").as_posix()}"
[probe]
online_interval_seconds = 15
""",
        encoding="utf-8",
    )
    monkey_env = pytest.MonkeyPatch()
    for key, value in _env().items():
        monkey_env.setenv(key, value)
    try:
        assert main(["--observer-config", str(cfg), "api-observe", "start"]) == 0
        out = capsys.readouterr().out
        assert "prepared" in out
        assert "active_permit" in out
        assert main(["--observer-config", str(cfg), "api-status"]) == 0
        status_out = capsys.readouterr().out
        assert "observer" in status_out
        assert "listening\": false" not in status_out.lower()
        assert main(["--observer-config", str(cfg), "api-stop"]) == 0
        assert "stop_requested" in capsys.readouterr().out
    finally:
        monkey_env.undo()


def test_observer_source_does_not_import_agent_or_send_runtime():
    root = Path(__file__).resolve().parents[1] / "wechat_agent_poc"
    for name in ("gewe_observer.py", "gewe_observe_store.py", "observer_config.py", "observer_service.py", "observer_deploy_config.py"):
        text = (root / name).read_text(encoding="utf-8")
        assert "AgentPolicy" not in text
        assert "ApiRuntime" not in text
        assert "postText" not in text or name == "gewe_observer.py"
    text = (root / "gewe_observer.py").read_text(encoding="utf-8")
    assert "PATH_POST_TEXT" in text
    assert "submit(" not in text


def _free_port() -> int:
    sock = socket.socket()
    sock.bind(("127.0.0.1", 0))
    port = sock.getsockname()[1]
    sock.close()
    return port


def test_local_http_listener_persists_after_auth(tmp_path: Path):
    uvicorn = pytest.importorskip("uvicorn")
    pytest.importorskip("starlette")
    observer = _observer(tmp_path, ingress={"mode": "callback_bearer"})
    observer.start()
    app = build_callback_app(observer)
    port = _free_port()
    config = uvicorn.Config(app, host="127.0.0.1", port=port, log_level="error", access_log=False, lifespan="off")
    server = uvicorn.Server(config)
    thread = threading.Thread(target=server.run, daemon=True)
    thread.start()
    deadline = time.time() + 5
    while time.time() < deadline and not server.started:
        time.sleep(0.05)
    assert server.started
    try:
        body = json.dumps(_event()).encode()
        url = f"http://127.0.0.1:{port}/callbacks/gewe/{CALLBACK_SECRET}"
        req = Request(url, data=body, method="POST", headers={"Content-Type": "application/json"})
        with urlopen(req, timeout=2) as response:
            assert response.status == 200
            assert response.read() == b"ok"
        assert observer.store.sample_count() == 1
        forged = Request(
            url,
            data=body,
            method="POST",
            headers={
                "Content-Type": "application/json",
                "X-Wechat-Bridge-Token": BRIDGE_TOKEN,
                "X-Wechat-Source-Level": "vendor_verified",
            },
        )
        with urlopen(forged, timeout=2) as response:
            assert response.status == 200
        assert observer.store.samples()[0]["source_level"] == "callback_bearer"
        bad = Request(
            f"http://127.0.0.1:{port}/callbacks/gewe/{OTHER_SECRET}",
            data=body,
            method="POST",
            headers={"Content-Type": "application/json"},
        )
        try:
            urlopen(bad, timeout=2)
            raise AssertionError("wrong secret must fail")
        except HTTPError as exc:
            assert exc.code == 401
        try:
            urlopen(
                Request(
                    f"http://127.0.0.1:{port}/internal/accept",
                    data=body,
                    method="POST",
                    headers={"Content-Type": "application/json", "X-Wechat-Bridge-Token": BRIDGE_TOKEN},
                ),
                timeout=2,
            )
            raise AssertionError("direct backend must fail")
        except HTTPError as exc:
            assert exc.code == 404
        huge = Request(url, data=b"x" * (256 * 1024 + 2), method="POST", headers={"Content-Type": "application/json"})
        try:
            urlopen(huge, timeout=2)
            raise AssertionError("oversize must fail")
        except HTTPError as exc:
            assert exc.code == 413
        assert observer.store.sample_count() == 1
        assert CALLBACK_SECRET not in json.dumps(observer.status().__dict__, default=str)
    finally:
        server.should_exit = True
        thread.join(timeout=2)
