from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path
from urllib.error import HTTPError
from urllib.request import Request, urlopen
import json
import socket
import sqlite3
import time

import pytest

from wechat_agent_poc.api_channel import ChannelError
from wechat_agent_poc.api_cli import main
from wechat_agent_poc.api_config import live_arm_blockers, parse_api_config
from wechat_agent_poc.config import ConfigError
from wechat_agent_poc.gewe_channel import GeweTransport
from wechat_agent_poc.gewe_observe_store import ObserveStore, USER_VERSION
from wechat_agent_poc.gewe_observer import ReadOnlyGeweClient
from wechat_agent_poc.observer_config import parse_observer_config
from wechat_agent_poc.observer_deploy_config import parse_observer_deploy_config
from wechat_agent_poc.observer_service import ObserverService, describe_observer_status

NOW = datetime(2026, 9, 16, 7, 0, tzinfo=timezone.utc)
ROOM = "example_group@chatroom"
SELF = "wxid_self_test"
APP = "wx_device_test"
CALLBACK_SECRET = "c" * 32
BRIDGE_TOKEN = "b" * 32


def _free_port() -> int:
    sock = socket.socket()
    sock.bind(("127.0.0.1", 0))
    port = sock.getsockname()[1]
    sock.close()
    return port


def _env():
    return {
        "WECHAT_CALLBACK_SECRET": CALLBACK_SECRET,
        "WECHAT_CALLBACK_BRIDGE_TOKEN": BRIDGE_TOKEN,
        "WECHAT_GATEWAY_BASE_URL": "https://example.invalid",
        "WECHAT_GATEWAY_TOKEN": "api-token-secret",
        "WECHAT_GATEWAY_APP_ID": APP,
    }


def _observer_cfg(tmp_path: Path, **overrides):
    raw = {
        "config_version": "observer-config/1",
        "enabled": True,
        "allow_live_send": False,
        "allow_model": False,
        "allow_network": False,
        "authorization_ref": "g2a-offline",
        "bind_host": "127.0.0.1",
        "bind_port": 0,
        "max_seconds": 1800,
        "max_samples": 200,
        "ingress": {
            "mode": "callback_bearer",
            "callback_secret_ref": "env:WECHAT_CALLBACK_SECRET",
            "bridge_token_ref": "env:WECHAT_CALLBACK_BRIDGE_TOKEN",
        },
        "channel": {
            "provider": "geweapi",
            "base_url_ref": "env:WECHAT_GATEWAY_BASE_URL",
            "credential_ref": "env:WECHAT_GATEWAY_TOKEN",
            "app_id_ref": "env:WECHAT_GATEWAY_APP_ID",
        },
        "binding": {"account_key": SELF, "conversation_key": ROOM, "binding_version": "bv-g2"},
        "store": {"path": str(tmp_path / "observe.sqlite")},
        "probe": {},
    }
    raw.update(overrides)
    return parse_observer_config(raw, source_path=tmp_path / "obs.toml", environ=_env())


def _deploy(tmp_path: Path, port: int, **overrides):
    raw = {
        "config_version": "observer-deploy/1",
        "mode": "synthetic",
        "bind_host": "127.0.0.1",
        "bind_port": port,
        "tls_mode": "off",
        "lock_path": str(tmp_path / "observer.lock"),
        "log_dir": str(tmp_path / "logs"),
    }
    raw.update(overrides)
    return parse_observer_deploy_config(raw, source_path=tmp_path / "dep.toml")


def _event(**overrides):
    payload = {
        "appid": APP,
        "wxid": SELF,
        "content": "ping",
        "createTime": 1758000001,
        "fromUser": "wxid_member_a",
        "isSelf": False,
        "msgType": "TEXT",
        "newMsgId": 3768973957878705000,
        "toUser": ROOM,
    }
    payload.update(overrides)
    return payload


def _post(port: int, secret: str, body: bytes, extra_headers=None):
    headers = {"Content-Type": "application/json"}
    if extra_headers:
        headers.update(extra_headers)
    req = Request(f"http://127.0.0.1:{port}/callbacks/gewe/{secret}", data=body, method="POST", headers=headers)
    with urlopen(req, timeout=3) as response:
        return response.status, response.read()


def test_prepare_does_not_create_permit(tmp_path: Path):
    port = _free_port()
    service = ObserverService(_observer_cfg(tmp_path), _deploy(tmp_path, port), environ=_env())
    prepared = service.prepare()
    assert prepared.status == "prepared"
    assert prepared.active_permit is False
    assert service.store.current_run() is None


def test_serve_rollback_on_port_conflict(tmp_path: Path):
    port = _free_port()
    blocker = socket.socket()
    blocker.bind(("127.0.0.1", port))
    blocker.listen(1)
    try:
        service = ObserverService(_observer_cfg(tmp_path), _deploy(tmp_path, port), environ=_env())
        with pytest.raises(ConfigError, match="unavailable"):
            service.start(background=True)
        run = service.store.current_run()
        assert run is None or run.get("status") in {"failed", "stopped", None}
        if run:
            assert run.get("status") == "failed"
    finally:
        blocker.close()


def test_duplicate_instance_and_probe_failure_leave_no_active_permit(tmp_path: Path):
    port = _free_port()
    first = ObserverService(_observer_cfg(tmp_path), _deploy(tmp_path, port), environ=_env())
    first.start(background=True)
    try:
        second = ObserverService(_observer_cfg(tmp_path), _deploy(tmp_path, port), environ=_env())
        with pytest.raises(ConfigError, match="duplicate"):
            second.start(background=True)
        assert first.status()["listen_state"] == "serving"
    finally:
        stopped = first.stop("operator_stop")
        assert stopped["stop_requested"] is True

    live_cfg = _observer_cfg(tmp_path, allow_network=True)
    live_deploy = _deploy(tmp_path, _free_port(), mode="live_observe")
    class Boom:
        def open(self, req, timeout):
            raise TimeoutError("nope")

    client = ReadOnlyGeweClient(
        base_url="https://example.invalid",
        token="t",
        app_id=APP,
        transport=GeweTransport(opener=Boom()),
        allow_network=True,
    )
    failing = ObserverService(live_cfg, live_deploy, environ=_env(), readonly_client=client, store=ObserveStore(tmp_path / "live.sqlite"))
    with pytest.raises(ChannelError):
        failing.start(background=True)
    leftover = failing.store.current_run()
    assert leftover is None or leftover.get("status") in {"failed", "stopped"}


def test_service_http_auth_stop_and_status_have_no_secrets(tmp_path: Path):
    port = _free_port()
    service = ObserverService(_observer_cfg(tmp_path), _deploy(tmp_path, port), environ=_env())
    started = service.start(background=True)
    try:
        assert started["status"] == "serving"
        body = json.dumps(_event()).encode()
        status, payload = _post(port, CALLBACK_SECRET, body)
        assert status == 200
        assert payload == b"ok"
        assert service.store.sample_count() == 1
        status, payload = _post(
            port,
            CALLBACK_SECRET,
            body,
            extra_headers={"X-Wechat-Bridge-Token": BRIDGE_TOKEN, "X-Wechat-Source-Level": "vendor_verified"},
        )
        assert status == 200
        assert service.store.samples()[0]["source_level"] == "callback_bearer"
        try:
            _post(port, "d" * 32, body)
            raise AssertionError("wrong secret must fail")
        except HTTPError as exc:
            assert exc.code == 401
        report = describe_observer_status(service.store, lock_path=service.deploy.lock_path)
        dumped = json.dumps(report, default=str)
        assert CALLBACK_SECRET not in dumped
        assert "api-token-secret" not in dumped
        assert report["listen_state"] == "serving"
        assert report["network"] is False
        assert service.send_calls == 0
        assert service.model_calls == 0
    finally:
        result = service.stop("operator_stop")
        assert result["stopped_confirmed"] is True
    try:
        _post(port, CALLBACK_SECRET, json.dumps(_event(newMsgId=2)).encode())
        raise AssertionError("port must be closed")
    except OSError:
        pass


def test_monotonic_expiry_without_callbacks(tmp_path: Path):
    port = _free_port()
    cfg = _observer_cfg(tmp_path, max_seconds=1)
    service = ObserverService(cfg, _deploy(tmp_path, port), environ=_env())
    service.start(background=True)
    time.sleep(2.2)
    status = describe_observer_status(service.store, lock_path=service.deploy.lock_path)
    assert status["lifecycle"] in {"stopped", "failed", "unknown/stale"}
    service.stop("cleanup")


def test_v1_store_migrates_and_agent_blockers_remain(tmp_path: Path):
    path = tmp_path / "old.sqlite"
    db = sqlite3.connect(str(path))
    db.execute("PRAGMA user_version=1")
    db.execute(
        """CREATE TABLE observe_runs (
            run_id TEXT PRIMARY KEY, observe_epoch TEXT NOT NULL UNIQUE, status TEXT NOT NULL,
            account_key TEXT NOT NULL, conversation_key TEXT NOT NULL, binding_version TEXT NOT NULL,
            app_id TEXT NOT NULL, source_level TEXT NOT NULL, authorization_ref TEXT NOT NULL,
            started_at TEXT NOT NULL, expires_at TEXT NOT NULL, stopped_at TEXT, stop_reason TEXT,
            permit_generation INTEGER NOT NULL DEFAULT 1, max_samples INTEGER NOT NULL,
            max_body_bytes INTEGER NOT NULL, sample_count INTEGER NOT NULL DEFAULT 0, body_bytes INTEGER NOT NULL DEFAULT 0
        )"""
    )
    db.commit()
    db.close()
    store = ObserveStore(path)
    assert int(store._db.execute("PRAGMA user_version").fetchone()[0]) == USER_VERSION
    assert path.with_name(path.name + ".v1.bak").exists()
    config = parse_api_config(
        {
            "config_version": "api-config/1",
            "profile": "observe",
            "allow_live_read": True,
            "allow_live_send": False,
            "authorization_ref": "auth",
            "state_path": str(tmp_path / "api-agent" / "state.sqlite"),
            "evidence_root": str(tmp_path / "runs"),
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


def test_cli_serve_requires_deploy_and_prepare_has_no_run(tmp_path: Path, capsys):
    cfg = tmp_path / "obs.toml"
    cfg.write_text(
        f"""
config_version = "observer-config/1"
enabled = true
allow_live_send = false
allow_model = false
allow_network = false
authorization_ref = "g2a"
bind_host = "127.0.0.1"
[ingress]
mode = "callback_bearer"
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
binding_version = "bv-g2"
[store]
path = "{(tmp_path / "observe.sqlite").as_posix()}"
""",
        encoding="utf-8",
    )
    monkey = pytest.MonkeyPatch()
    for key, value in _env().items():
        monkey.setenv(key, value)
    try:
        assert main(["--observer-config", str(cfg), "api-observe", "start", "--serve"]) == 2
        assert "deployment-config" in capsys.readouterr().out
        assert main(["--observer-config", str(cfg), "api-observe", "start"]) == 0
        out = capsys.readouterr().out
        assert '"active_permit": false' in out
    finally:
        monkey.undo()
