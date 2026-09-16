from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path
from urllib.request import Request, urlopen
import json
import sqlite3
import threading

import pytest

from wechat_agent_poc.api_channel import ChannelError
from wechat_agent_poc.api_config import live_arm_blockers, parse_api_config
from wechat_agent_poc.clock import FrozenClock
from wechat_agent_poc.config import ConfigError
from wechat_agent_poc.pad_auth import (
    LOCAL_COMPUTED_VECTORS,
    PeerEvidence,
    official_hmac_vector_report,
    pad_metadata_hmac,
)
from wechat_agent_poc.pad_cli import build_parser, main
from wechat_agent_poc.pad_config import (
    load_pad_config,
    load_pad_provider_profile,
    parse_pad_config,
    parse_pad_provider_profile,
    pad_p0_gaps,
)
from wechat_agent_poc.pad_observer import PadObserver, ReadOnlyPadTransport, describe_pad_status
from wechat_agent_poc.pad_store import PadStore

NOW = datetime(2026, 9, 16, 12, 0, tzinfo=timezone.utc)
ROOM = "example_group@chatroom"
SELF = "wxid_self_test"
SECRET = "your-signature-secret"
POC = Path(__file__).resolve().parents[1]
MAX_PROFILE = POC / "pad-provider-profile.max.example.json"
LEGACY_PROFILE = POC / "pad-provider-profile.legacy.example.json"


def _env():
    return {
        "PAD_WEBHOOK_SECRET": SECRET,
        "PAD_GATEWAY_TOKEN": "t" * 32,
        "PAD_GATEWAY_BASE_URL": "https://example.invalid",
    }


def _raw(tmp_path: Path, **overrides):
    data = {
        "config_version": "pad-config/1",
        "enabled": True,
        "live": False,
        "allow_live_send": False,
        "allow_model": False,
        "allow_network": False,
        "authorization_ref": "p1-offline",
        "api_flavor": "MAX",
        "provider_profile_path": str(MAX_PROFILE),
        "credential_ref": "env:PAD_GATEWAY_TOKEN",
        "signature_secret_ref": "env:PAD_WEBHOOK_SECRET",
        "observation_store_path": str(tmp_path / "pad-observe" / "observe.sqlite"),
        "agent_state_path": str(tmp_path / "pad-agent" / "state.sqlite"),
        "evidence_root": str(tmp_path / "pad-observe" / "evidence"),
        "lock_path": str(tmp_path / "pad-observe" / "observer.lock"),
        "bind_host": "127.0.0.1",
        "bind_port": 0,
        "max_seconds": 1800,
        "max_samples": 200,
        "ingress": {"mode": "synthetic_private"},
        "binding": {"account_key": SELF, "conversation_key": ROOM, "binding_version": "bv-pad"},
        "readonly": {"base_url_ref": "env:PAD_GATEWAY_BASE_URL"},
    }
    for key, value in overrides.items():
        if isinstance(value, dict) and isinstance(data.get(key), dict):
            merged = dict(data[key])
            merged.update(value)
            data[key] = merged
        else:
            data[key] = value
    return data


def _config(tmp_path: Path, **overrides):
    return parse_pad_config(_raw(tmp_path, **overrides), source_path=tmp_path / "pad.toml", environ=_env())


def _observer(tmp_path: Path, **overrides) -> PadObserver:
    config = _config(tmp_path, **overrides)
    store = PadStore(config.observation_store_path, clock=FrozenClock(NOW))
    return PadObserver(config, store, clock=FrozenClock(NOW), environ=_env())


def _envelope(*messages, **top):
    payload = {
        "Wxid": SELF,
        "MessageType": "sync_message",
        "Timestamp": 1758000100,
        "Signature": "",
        "Data": {"messages": list(messages)},
    }
    payload.update(top)
    if payload.get("Signature") == "" and "Signature" in top:
        pass
    return payload


def _msg(**overrides):
    item = {
        "newMsgId": 3768973957878705000,
        "createTime": 1758000001,
        "fromUser": "wxid_member_a",
        "toUser": ROOM,
        "isSelf": False,
        "msgType": "TEXT",
        "text": "synthetic in-scope text",
    }
    item.update(overrides)
    return item


def _signed(envelope: dict, secret: str = SECRET) -> dict:
    signed = json.loads(json.dumps(envelope))
    signed["Signature"] = pad_metadata_hmac(secret, signed["Wxid"], signed["MessageType"], signed["Timestamp"])
    return signed


def _peer(trusted: bool = True) -> PeerEvidence:
    if trusted:
        return PeerEvidence(True, "synthetic", "127.0.0.1")
    return PeerEvidence(False, "untrusted", "203.0.113.9")


def test_example_pad_config_is_offline():
    config = load_pad_config(POC / "config.pad.example.toml")
    assert config.config_version == "pad-config/1"
    assert config.live is False
    assert config.enabled is False
    assert config.api_flavor == "MAX"
    assert config.profile.p0_closed is False
    assert "gewe-observe" not in str(config.observation_store_path).replace("\\", "/")
    assert config.observation_store_path != config.agent_state_path


def test_legacy_and_max_profiles_are_not_mixed():
    max_profile = load_pad_provider_profile(MAX_PROFILE)
    legacy = load_pad_provider_profile(LEGACY_PROFILE)
    assert max_profile.api_flavor == "MAX"
    assert legacy.api_flavor == "legacy"
    assert max_profile.p0_closed is False
    assert legacy.p0_closed is False
    assert legacy.capabilities["send_txt"]["status"] == "unsupported"
    with pytest.raises(ConfigError, match="must not be mixed"):
        parse_pad_config(
            {
                "config_version": "pad-config/1",
                "api_flavor": "legacy",
                "provider_profile_path": str(MAX_PROFILE),
                "observation_store_path": ".local/pad-observe/observe.sqlite",
                "agent_state_path": ".local/pad-agent/state.sqlite",
                "ingress": {"mode": "none"},
                "binding": {},
                "readonly": {},
            }
        )
    with pytest.raises(ConfigError, match="provider-profile/1"):
        parse_pad_provider_profile({"schema_version": "provider-profile/1", "api_flavor": "MAX"})
    with pytest.raises(ConfigError, match="unknown field"):
        parse_pad_config(
            {
                "config_version": "pad-config/1",
                "api_flavor": "MAX",
                "provider_profile_path": str(MAX_PROFILE),
                "extra": 1,
                "ingress": {"mode": "none"},
                "binding": {},
                "readonly": {},
            }
        )


def test_old_api_config_and_gewe_store_paths_rejected(tmp_path: Path):
    with pytest.raises(ConfigError, match="api-config/1"):
        parse_pad_config({"config_version": "api-config/1", "profile": "offline"})
    with pytest.raises(ConfigError, match="collides"):
        parse_pad_config(_raw(tmp_path, observation_store_path=str(tmp_path / "gewe-observe" / "observe.sqlite")), source_path=tmp_path / "x.toml")
    with pytest.raises(ConfigError, match="unverified provider"):
        parse_api_config(
            {
                "config_version": "api-config/1",
                "profile": "offline",
                "channel": {"provider": "wechatpadpro", "contract_version": "wechat-api-event/1"},
                "binding": {},
                "agent": {"model_provider": "mock"},
                "run": {"stage": "A1"},
                "inquiry": {"enabled": False, "target_keys": []},
            }
        )


def test_hmac_official_vectors_conflict_and_do_not_cover_data():
    report = official_hmac_vector_report()
    assert report["kind"] == "document_fixture"
    assert report["not_observed"] is True
    assert report["covers_data"] is False
    assert report["document_page_vectors_match_formula"] is False
    assert report["algorithm_modified_to_match_page"] is False
    for ts, digest in LOCAL_COMPUTED_VECTORS.items():
        assert pad_metadata_hmac(SECRET, "wxid_xxxxxxxxxxxxxxxx", "sync_message", ts) == digest
    envelope = _envelope(_msg())
    tampered = _envelope(_msg(text="tampered body"))
    assert pad_metadata_hmac(SECRET, envelope["Wxid"], envelope["MessageType"], envelope["Timestamp"]) == pad_metadata_hmac(
        SECRET, tampered["Wxid"], tampered["MessageType"], tampered["Timestamp"]
    )
    fixture = json.loads((POC / "fixtures" / "pad" / "document_hmac_vectors.json").read_text(encoding="utf-8"))
    assert fixture["kind"] == "document_fixture"
    assert fixture["not_observed"] is True
    page_values = fixture["page_listed_hex"]["values"]
    assert page_values["1757156304"] == "df5fdde88d2f3a9329cd0193969c0bac5a1d57e40cc6c28e181f478d3629c510"
    assert page_values["1757156307"] == "54cd72f857387f150ae84293ec35fb96e6347e9610ad2f1ee13025e245b72a80"
    assert page_values["1757156304"] != LOCAL_COMPUTED_VECTORS[1757156304]
    assets = json.loads((POC / "fixtures" / "pad" / "github-v2.01-release-assets.json").read_text(encoding="utf-8"))
    assert assets["not_observed"] is True
    linux = next(item for item in assets["assets"] if item["name"].endswith("linux-amd64.zip"))
    assert linux["digest"] == "sha256:9367619f6c882f691172c44acfab59581571c9c37b9f6e01db0138b2793bd048"


def test_batch_duplicate_conflict_cross_group_and_bad_items(tmp_path: Path):
    observer = _observer(tmp_path)
    observer.start()
    peer = _peer()
    first = _signed(_envelope(_msg(), _msg(newMsgId=3768973957878705000, text="synthetic in-scope text"), _msg(newMsgId=11, fromUser="wxid_stranger", toUser="wxid_stranger"), _msg(newMsgId=1.5)))
    ack = observer.accept(peer, json.dumps(first).encode())
    assert ack.accepted is True
    actions = [item.action for item in ack.items]
    assert actions[0] == "stored"
    assert actions[1] == "duplicate"
    assert actions[2] == "dropped_unbound"
    assert actions[3] == "rejected"
    samples = observer.store.samples()
    assert len(samples) == 1
    assert samples[0]["text"] == "synthetic in-scope text"
    assert samples[0]["native_message_id"] == "3768973957878705000"
    assert samples[0]["mention_status"] == "unknown"
    assert samples[0]["history_status"] == "unknown"
    assert samples[0]["identity_status"] == "unknown"
    assert observer.store.sample_count() == 1
    conflict = observer.accept(peer, json.dumps(_signed(_envelope(_msg(text="changed")))).encode())
    assert conflict.paused is True
    assert any(item.action == "conflict" for item in conflict.items)
    later = observer.accept(peer, json.dumps(_signed(_envelope(_msg(newMsgId=99)))).encode())
    assert later.accepted is False
    assert later.http_status == 503


def test_cross_restart_duplicate_and_transaction_failure(tmp_path: Path):
    path = tmp_path / "pad-observe" / "observe.sqlite"
    observer = _observer(tmp_path)
    observer.start()
    body = json.dumps(_signed(_envelope(_msg(newMsgId=42)))).encode()
    assert observer.accept(_peer(), body).accepted is True
    observer.store.close()
    store2 = PadStore(path, clock=FrozenClock(NOW))
    observer2 = PadObserver(_config(tmp_path), store2, clock=FrozenClock(NOW), environ=_env())
    dup = observer2.accept(_peer(), body)
    assert dup.accepted is True
    assert dup.items[0].action == "duplicate"
    assert store2.sample_count() == 1
    store2.fail_next_batch = True
    failed = observer2.accept(_peer(), json.dumps(_signed(_envelope(_msg(newMsgId=43)))).encode())
    assert failed.accepted is False
    assert failed.http_status == 503
    assert failed.code == "persist_error"
    assert store2.sample_count() == 1


def test_schema_drift_v2_and_document_sample_not_observed(tmp_path: Path):
    observer = _observer(tmp_path)
    observer.start()
    v2 = _signed(_envelope(_msg(), **{"MessageType": "wechatpad.message.v2"}))
    ack = observer.accept(_peer(), json.dumps(v2).encode())
    assert ack.accepted is False
    assert ack.code == "v2_unsupported"
    assert observer.store.sample_count() == 0
    observer2 = _observer(tmp_path / "b")
    observer2.start()
    drift = _signed(_envelope(_msg(), ExtraField="nope"))
    ack2 = observer2.accept(_peer(), json.dumps(drift).encode())
    assert ack2.accepted is False
    assert ack2.code == "schema_drift"
    fixture = json.loads((POC / "fixtures" / "pad" / "synthetic_v1_envelope.json").read_text(encoding="utf-8"))
    assert fixture["kind"] == "synthetic"
    assert fixture["not_observed"] is True


def test_hmac_valid_without_peer_cannot_trigger_and_tamper_has_no_payload_integrity(tmp_path: Path):
    observer = _observer(tmp_path)
    observer.start()
    signed = _signed(_envelope(_msg()))
    denied = observer.accept(_peer(False), json.dumps(signed).encode())
    assert denied.accepted is False
    assert denied.http_status == 401
    assert denied.metadata_signature_valid is True
    assert denied.payload_integrity_verified is False
    assert observer.store.sample_count() == 0
    tampered = _signed(_envelope(_msg(text="rewritten")))
    ack = observer.accept(_peer(), json.dumps(tampered).encode())
    assert ack.accepted is True
    assert ack.metadata_signature_valid is True
    assert ack.payload_integrity_verified is False
    assert ack.private_gateway_transport_verified is True


def test_unknown_mention_history_and_is_self_top_level_ignored(tmp_path: Path):
    observer = _observer(tmp_path)
    observer.start()
    body = _signed(_envelope(_msg(isSelf=False, atuserlist=["wxid_self_test"], isHistory=False), IsSelf=True))
    # Extra envelope key IsSelf is allowed? IsSelf is in V1_ENVELOPE_KEYS so not drift.
    ack = observer.accept(_peer(), json.dumps(body).encode())
    assert ack.accepted is True
    sample = observer.store.samples()[0]
    assert sample["mention_status"] == "unknown"
    assert sample["history_status"] == "unknown"
    assert sample["is_self"] == "false"


def test_large_integer_id_and_envelope_timestamp_not_used_as_occurred_at(tmp_path: Path):
    observer = _observer(tmp_path)
    observer.start()
    huge = 2**62
    ack = observer.accept(_peer(), json.dumps(_signed(_envelope(_msg(newMsgId=huge, createTime=1758000001), Timestamp=1))).encode())
    assert ack.accepted is True
    sample = observer.store.samples()[0]
    assert sample["native_message_id"] == str(huge)
    assert sample["occurred_at"].startswith("2025-") or "2025-09-16" in sample["occurred_at"] or sample["occurred_at"].endswith("Z")
    assert "1970" not in sample["occurred_at"]


def test_stop_race_expiry_and_restart_does_not_create_outbox(tmp_path: Path):
    clock = FrozenClock(NOW)
    config = _config(tmp_path, max_seconds=30)
    store = PadStore(config.observation_store_path, clock=clock)
    observer = PadObserver(config, store, clock=clock, environ=_env())
    observer.start()
    errors = []

    def worker():
        try:
            observer.accept(_peer(), json.dumps(_signed(_envelope(_msg(newMsgId=7)))).encode())
        except Exception as exc:  # noqa: BLE001
            errors.append(exc)

    threads = [threading.Thread(target=worker) for _ in range(8)]
    for thread in threads:
        thread.start()
    observer.stop("operator_stop")
    for thread in threads:
        thread.join()
    assert errors == []
    assert observer.status().status == "stopped"
    after = observer.accept(_peer(), json.dumps(_signed(_envelope(_msg(newMsgId=8)))).encode())
    assert after.http_status == 503
    names = store.table_names()
    assert "outbox" not in names
    assert "tasks" not in names
    assert "inbox" not in names
    clock2 = FrozenClock(NOW)
    observer_e = PadObserver(_config(tmp_path / "exp", max_seconds=10), PadStore(tmp_path / "exp" / "pad-observe" / "observe.sqlite", clock=clock2), clock=clock2, environ=_env())
    observer_e.start()
    clock2.advance(11)
    expired = observer_e.accept(_peer(), json.dumps(_signed(_envelope(_msg(newMsgId=9)))).encode())
    assert expired.http_status == 503
    assert expired.code == "expired"
    assert observer_e.store.sample_count() == 0
    assert observer_e.send_calls == 0
    assert observer_e.model_calls == 0
    assert observer_e.task_creates == 0


def test_http_stub_and_readonly_transport_rejects_writes(tmp_path: Path):
    observer = _observer(tmp_path)
    started = observer.serve_http(host="127.0.0.1", port=0)
    try:
        port = int(started["listen_port"])
        body = json.dumps(_signed(_envelope(_msg(newMsgId=55)))).encode()
        req = Request(f"http://127.0.0.1:{port}/callbacks/pad", data=body, method="POST", headers={"Content-Type": "application/json"})
        with urlopen(req, timeout=3) as response:
            assert response.status == 200
            payload = json.loads(response.read().decode("utf-8"))
        assert payload["accepted"] is True
        assert payload["payload_integrity_verified"] is False
        assert observer.store.sample_count() == 1
    finally:
        observer.stop("operator_stop")
    transport = ReadOnlyPadTransport()
    with pytest.raises(ChannelError, match="rejected /Msg/SendTxt") as send_err:
        transport.post("/Msg/SendTxt", {"ToWxid": ROOM, "Content": "nope"})
    assert send_err.value.code == "write_forbidden"
    with pytest.raises(ChannelError, match="rejected /Msg/Sync") as sync_err:
        transport.post("/Msg/Sync", {})
    assert sync_err.value.code == "write_forbidden"
    with pytest.raises(ChannelError, match="readonly Pad HTTP is disabled") as net_err:
        transport.get_online_info()
    assert net_err.value.code == "network_disabled"
    assert transport.calls == []


def test_cli_help_check_status_stop_and_no_send(tmp_path: Path, capsys):
    help_text = build_parser().format_help()
    for command in ("check", "observe", "status", "stop", "verify"):
        assert command in help_text
    assert "send" not in help_text.split("positional arguments")[-1].lower() or "No send" in help_text or "no send" in help_text.lower()
    example = POC / "config.pad.example.toml"
    assert main(["--config", str(example), "check"]) == 0
    out = capsys.readouterr().out
    assert "pad-config/1" in out
    assert '"p0_closed": false' in out
    assert '"network": false' in out
    cfg = tmp_path / "pad.toml"
    text = example.read_text(encoding="utf-8")
    text = text.replace('observation_store_path = ".local/pad-observe/observe.sqlite"', f'observation_store_path = "{(tmp_path / "pad-observe" / "observe.sqlite").as_posix()}"')
    text = text.replace('agent_state_path = ".local/pad-agent/state.sqlite"', f'agent_state_path = "{(tmp_path / "pad-agent" / "state.sqlite").as_posix()}"')
    text = text.replace('provider_profile_path = "pad-provider-profile.max.example.json"', f'provider_profile_path = "{MAX_PROFILE.as_posix()}"')
    cfg.write_text(text, encoding="utf-8")
    assert main(["--config", str(cfg), "status"]) == 0
    status_out = capsys.readouterr().out
    assert '"send": false' in status_out
    assert main(["--config", str(cfg), "stop"]) == 0
    assert main(["--config", str(cfg), "verify"]) == 2
    assert main(["--config", str(cfg), "check", "--probe"]) == 0
    probe_out = capsys.readouterr().out
    assert "未执行" in probe_out
    status = describe_pad_status(PadStore(tmp_path / "pad-observe" / "observe.sqlite"))
    assert status["network"] is False
    assert status["model"] is False
    assert status["send"] is False


def test_a1_live_reject_and_gewe_blockers_unchanged():
    runtime = Path(__file__).resolve().parents[1] / "wechat_agent_poc" / "api_runtime.py"
    assert 'raise RuntimeError_("A1 refuses live start")' in runtime.read_text(encoding="utf-8")
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


def test_p0_gaps_are_reported():
    profile = load_pad_provider_profile(MAX_PROFILE)
    gaps = pad_p0_gaps(profile)
    assert any("P0 is not closed" in item for item in gaps)
    assert any("real_mention_receive" in item for item in gaps)
    assert any("webhook_v2" in item for item in gaps)


def test_opening_gewe_sqlite_is_rejected(tmp_path: Path):
    gewe = tmp_path / "observe.sqlite"
    conn = sqlite3.connect(gewe)
    conn.execute("CREATE TABLE observe_runs (run_id TEXT)")
    conn.commit()
    conn.close()
    with pytest.raises(ConfigError, match="collides"):
        PadStore(gewe)
