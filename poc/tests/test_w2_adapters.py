from __future__ import annotations

import json
import sqlite3
from pathlib import Path

import pytest

from wechat_agent_poc.cli import main
from wechat_agent_poc.keys import resolve_authorized_key
from wechat_agent_poc.live_guard import is_live_wechat_root
from wechat_agent_poc.models import HaltError
from wechat_agent_poc.reader import SqlcipherReader, SqlitePlainReader
from wechat_agent_poc.review import approve
from wechat_agent_poc.sender import ObservedDesktopSender, send_text
from wechat_agent_poc.store import Store
from wechat_agent_poc.window_observer import ManualFileWindowObserver

from conftest import ACCOUNT, CONVERSATION, TIME, account_dir, make_config, write_db
from test_review_sender import _draft


def test_sqlite_plain_refuses_live_wechat_root(tmp_path: Path, monkeypatch):
    live_root = tmp_path / "Documents" / "xwechat_files"
    live_root.mkdir(parents=True)
    monkeypatch.setattr("wechat_agent_poc.live_guard.default_live_roots", lambda: (live_root,))
    config = make_config(tmp_path, account={"data_root": str(live_root), "wxid": ACCOUNT})
    with pytest.raises(HaltError) as caught:
        SqlitePlainReader(config, Store(tmp_path / "s.sqlite")).read_new_messages()
    assert caught.value.halt.reason == "READ_FAILURE"
    assert "plaintext" in caught.value.halt.message.lower() or "live" in caught.value.halt.message.lower()


def test_sqlite_plain_refuses_real_documents_root_without_listing(tmp_path: Path):
    real = Path.home() / "Documents" / "xwechat_files"
    if not real.exists():
        pytest.skip("default xwechat_files is absent")
    config = make_config(tmp_path, account={"data_root": str(real), "wxid": "wxid_not_enumerated"})
    with pytest.raises(HaltError) as caught:
        SqlitePlainReader(config, Store(tmp_path / "no-open.sqlite")).read_new_messages()
    assert caught.value.halt.reason == "READ_FAILURE"
    assert caught.value.halt.details.get("process_key_extraction") == "not_authorized"


def test_sqlcipher_without_key_still_blocked(tmp_path: Path):
    config = make_config(tmp_path, adapters={"reader": "sqlcipher_readonly"})
    with pytest.raises(HaltError) as caught:
        SqlcipherReader(config, Store(tmp_path / "s.sqlite")).read_new_messages()
    assert "authorized key" in caught.value.halt.message


def test_sqlcipher_env_key_uses_same_baseline_as_plain(tmp_path: Path, monkeypatch):
    monkeypatch.setenv("POC_SQLCIPHER_TEST_KEY", "fixture-key")
    config = make_config(
        tmp_path,
        adapters={"reader": "sqlcipher_readonly"},
        account={"authorized_key_ref": "env:POC_SQLCIPHER_TEST_KEY"},
    )
    db = account_dir(tmp_path / "data", ACCOUNT) / "message_0.db"
    write_db(db, CONVERSATION, [{"local_id": 1, "text": "old", "create_time": TIME}])
    seen_keys: list[str] = []

    def opener(path: str, key: str):
        seen_keys.append(key)
        conn = sqlite3.connect(path)
        conn.execute("PRAGMA query_only = ON")
        return conn

    store = Store(tmp_path / "s.sqlite")
    reader = SqlcipherReader(config, store, opener=opener)
    assert reader.read_new_messages() == []
    assert seen_keys == ["fixture-key"]
    write_db(db, CONVERSATION, [{"local_id": 2, "text": "new", "create_time": TIME + 1}])
    events = reader.read_new_messages()
    assert [event.text for event in events] == ["new"]


def test_sqlcipher_missing_module_without_opener(tmp_path: Path, monkeypatch):
    monkeypatch.setenv("POC_SQLCIPHER_TEST_KEY", "fixture-key")
    config = make_config(
        tmp_path,
        adapters={"reader": "sqlcipher_readonly"},
        account={"authorized_key_ref": "env:POC_SQLCIPHER_TEST_KEY"},
    )
    db = account_dir(tmp_path / "data", ACCOUNT) / "message_0.db"
    write_db(db, CONVERSATION, [])
    import builtins

    real_import = builtins.__import__

    def fake_import(name, *args, **kwargs):
        if name == "sqlcipher3":
            raise ImportError("blocked in test")
        return real_import(name, *args, **kwargs)

    monkeypatch.setattr("builtins.__import__", fake_import)
    with pytest.raises(HaltError) as caught:
        SqlcipherReader(config, Store(tmp_path / "s.sqlite")).read_new_messages()
    assert "sqlcipher3" in caught.value.halt.message


def test_key_ref_does_not_search_process(tmp_path: Path):
    with pytest.raises(HaltError) as caught:
        resolve_authorized_key("process:weixin")
    assert "unsupported" in caught.value.halt.message


def test_manual_file_observation_allows_manual_send_window(tmp_path: Path):
    store, config, draft, _ = _draft(tmp_path)
    approval = approve(store, config, draft.draft_id, draft.text_hash or "", "bv-1", "op")
    live = make_config(
        tmp_path / "live",
        mode="manual_send",
        adapters={"reader": "mock", "sender": "desktop_observed"},
        window={"observer": "manual_file", "observation_path": str(tmp_path / "obs.json")},
    )
    payload = {
        "account_alias": live.binding.account_alias,
        "account_wxid": live.binding.account_wxid,
        "display_name": live.binding.display_name,
        "conversation_key": live.binding.conversation_key,
        "details": "合成测试群 external-poc",
        "member_features": list(live.binding.member_features),
        "focus": True,
        "rebuilt": False,
        "located_by": "operator_window_check",
    }
    (tmp_path / "obs.json").write_text(json.dumps(payload), encoding="utf-8")
    window = ManualFileWindowObserver(tmp_path / "obs.json").observe(live.binding)
    with pytest.raises(HaltError) as caught:
        send_text(store, live, ObservedDesktopSender(), approval, window)
    assert "not armed" in caught.value.halt.message
    assert caught.value.halt.details.get("submit_stage") == "not_sent"
    assert store.get_draft(draft.draft_id).status == "failed"


def test_read_only_run_blocked_without_live_authorization(tmp_path: Path, capsys):
    config_path = tmp_path / "cfg.toml"
    config_path.write_text(
        f"""
mode = "read_only"
data_dir = "{str(tmp_path / "st").replace(chr(92), "/")}"
allow_live_read = false
[account]
alias = "a"
wxid = "{ACCOUNT}"
data_root = "{str(tmp_path / "data").replace(chr(92), "/")}"
[group]
alias = "g"
conversation_key = "{CONVERSATION}"
binding_version = "bv-1"
member_features = ["synthetic_wecom_member"]
display_name = "合成测试群"
required_detail_tokens = ["合成测试群"]
[model]
provider = "mock"
credential_source = "none"
[adapters]
reader = "sqlite_plain"
sender = "mock"
""",
        encoding="utf-8",
    )
    assert main(["--config", str(config_path), "run", "--cycles", "1"]) == 2
    out = capsys.readouterr().out
    assert "G-INGEST" in out
    assert "blocked" in out


def test_is_live_root_does_not_treat_tmp_fixture_as_live(tmp_path: Path):
    fixture = tmp_path / "data" / "xwechat_files"
    fixture.mkdir(parents=True)
    assert is_live_wechat_root(fixture) is False
