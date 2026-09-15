from __future__ import annotations

import sqlite3
from pathlib import Path

import pytest

from wechat_agent_poc.account_scope import resolve_account_dir
from wechat_agent_poc.cli import main
from wechat_agent_poc.config import ConfigError, parse_config
from wechat_agent_poc.gates import evaluate_gates
from wechat_agent_poc.key_material import KeyBundle, KeyMaterial, obtain_live_client_material
from wechat_agent_poc.keys import resolve_authorized_key
from wechat_agent_poc.live_guard import (
    live_discovery_blockers,
    live_ingest_blockers,
    live_key_blockers,
    live_open_blockers,
)
from wechat_agent_poc.locator import assert_metadata_sql, locate_group, map_self, ContactRow
from wechat_agent_poc.models import Halt, HaltError
from wechat_agent_poc.page_cipher import PAGE_SIZE, SQLITE_HEADER, decrypt_database, encrypt_page_for_tests
from wechat_agent_poc.r0_pipeline import execute_r0
from wechat_agent_poc.secrets_out import scrub_text

from conftest import ACCOUNT, CONVERSATION, TIME, write_db


EXCLUDED = "wxid_example_excluded_dir"
AUTHORIZED = "wxid_example_account_dir"


def _live_cfg(tmp_path: Path, **overrides):
    raw = {
        "mode": "read_only",
        "data_dir": str(tmp_path / "state"),
        "allow_live_read": False,
        "allow_live_discovery": False,
        "allow_key_material_from_live_client": False,
        "allow_live_send": False,
        "authorization_ref": "spec-v0.3-test",
        "wechat_version_recorded": "4.1.13.65",
        "account": {
            "alias": "a",
            "wxid": AUTHORIZED,
            "data_root": str(tmp_path / "xwechat_files"),
            "self_sender_key": "",
            "authorized_key_ref": "none",
        },
        "group": {
            "alias": "g",
            "conversation_key": "",
            "binding_version": "bv-test",
            "member_features": ["示例企业A/示例成员A", "微信联系人/示例本人"],
            "display_name": "示例混合群",
            "required_detail_tokens": ["示例混合群"],
        },
        "model": {"provider": "mock", "credential_source": "none"},
        "adapters": {"reader": "sqlcipher_readonly", "sender": "mock"},
    }
    for key, value in overrides.items():
        if isinstance(value, dict) and isinstance(raw.get(key), dict):
            raw[key].update(value)
        else:
            raw[key] = value
    return parse_config(raw)


def test_unknown_allow_flag_is_rejected(tmp_path: Path):
    with pytest.raises(ConfigError, match="unknown allow_"):
        parse_config(
            {
                "mode": "read_only",
                "data_dir": str(tmp_path),
                "allow_live_hook": True,
                "account": {"alias": "a", "wxid": AUTHORIZED},
                "group": {"alias": "g"},
                "model": {"provider": "mock", "credential_source": "none"},
                "adapters": {"reader": "mock", "sender": "mock"},
            }
        )


def test_offline_cannot_arm_v03_switches(tmp_path: Path):
    with pytest.raises(ConfigError, match="allow_live_discovery"):
        parse_config(
            {
                "mode": "offline",
                "data_dir": str(tmp_path),
                "allow_live_discovery": True,
                "account": {"alias": "a"},
                "group": {"alias": "g"},
                "model": {"provider": "mock", "credential_source": "none"},
                "adapters": {"reader": "mock", "sender": "mock"},
            }
        )


def test_g_key_does_not_require_existing_key(tmp_path: Path):
    config = _live_cfg(
        tmp_path,
        allow_key_material_from_live_client=True,
        allow_live_read=True,
    )
    assert config.authorized_key_ref == "none"
    assert live_key_blockers(config) == []
    assert "account.authorized_key_ref" not in evaluate_gates(config)["G-KEY"].get("blockers", [])


def test_g_open_and_discovery_do_not_require_internal_keys(tmp_path: Path):
    config = _live_cfg(
        tmp_path,
        allow_live_read=True,
        allow_live_discovery=True,
        account={"authorized_key_ref": "env:POC_SQLCIPHER_TEST_KEY"},
    )
    assert not config.binding.conversation_key
    assert not config.configured_self_sender_key
    assert "group.conversation_key missing" not in live_open_blockers(config, has_in_process_key=True)
    assert "account.self_sender_key missing" not in live_open_blockers(config, has_in_process_key=True)
    assert "group.conversation_key missing" not in live_discovery_blockers(config, has_in_process_key=True)
    ingest = live_ingest_blockers(config, has_in_process_key=True)
    assert "group.conversation_key missing" in ingest
    assert "account.self_sender_key missing" in ingest


def test_g_key_refuses_process_that_also_holds_excluded(tmp_path: Path):
    config = _live_cfg(tmp_path, allow_key_material_from_live_client=True)
    (tmp_path / "xwechat_files" / AUTHORIZED).mkdir(parents=True)

    def resolver(files, excluded_files=None, **_kwargs):
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "candidate Weixin process also holds an excluded account database; refusing key extraction",
                {"phase": "G-KEY", "reason": "process_account_not_unique"},
            )
        )

    with pytest.raises(HaltError) as caught:
        obtain_live_client_material(config, pid_resolver=resolver, scanner=lambda _pid: [])
    assert caught.value.halt.details.get("reason") == "process_account_not_unique"


def test_switches_off_block_low_level_key_and_decrypt(tmp_path: Path, monkeypatch):
    config = _live_cfg(tmp_path)
    assert live_key_blockers(config)
    called = {"scan": False}

    def boom(_pid: int):
        called["scan"] = True
        raise AssertionError("scan must not run")

    with pytest.raises(HaltError) as caught:
        obtain_live_client_material(config, pid_resolver=lambda _files: {"pid": 1}, scanner=boom)
    assert caught.value.halt.details.get("phase") == "G-KEY"
    assert called["scan"] is False
    live = tmp_path / "Documents" / "xwechat_files" / AUTHORIZED / "db.db"
    live.parent.mkdir(parents=True)
    live.write_bytes(b"x" * 16)
    monkeypatch.setattr("wechat_agent_poc.page_cipher.is_live_wechat_root", lambda path, live_roots=None: True)
    with pytest.raises(HaltError) as blocked:
        decrypt_database(live, tmp_path / "out.db", [b"0" * 32], allow_live=False)
    assert blocked.value.halt.details.get("phase") == "G-OPEN"


def test_wrong_account_and_excluded_path_blocked(tmp_path: Path):
    root = tmp_path / "xwechat_files"
    (root / EXCLUDED).mkdir(parents=True)
    (root / AUTHORIZED).mkdir(parents=True)
    with pytest.raises(HaltError):
        resolve_account_dir(root, EXCLUDED)
    resolved = resolve_account_dir(root, AUTHORIZED)
    assert resolved.name == AUTHORIZED
    linked = tmp_path / "alias" / AUTHORIZED
    linked.parent.mkdir(parents=True)
    try:
        linked.symlink_to(root / EXCLUDED, target_is_directory=True)
    except OSError:
        pytest.skip("symlink not permitted")
    with pytest.raises(HaltError):
        resolve_account_dir(linked.parent, AUTHORIZED)


def test_zero_and_multiple_group_candidates_refuse_binding():
    contacts = [
        ContactRow("room-a@openim", "", "示例混合群", ""),
        ContactRow("room-b@openim", "", "示例混合群", ""),
        ContactRow("wxid_other", "示例企业A/示例成员A", "示例成员A", ""),
    ]
    none = locate_group(display_name="示例混合群", member_features=("示例企业A/示例成员A",), contacts=contacts, sessions=["unrelated@openim"])
    assert none["session_candidate_count"] == 0
    assert none["bindable"] is False
    many = locate_group(
        display_name="示例混合群",
        member_features=("示例企业A/示例成员A",),
        contacts=contacts,
        sessions=["room-a@openim", "room-b@openim"],
    )
    assert many["session_candidate_count"] == 2
    assert many["bindable"] is False


def test_unknown_self_cannot_ingest():
    mapped = map_self(
        account_wxid=AUTHORIZED,
        contacts=[ContactRow("wxid_other", "示例本人", "示例本人", "")],
        name2id=["wxid_alpha", "wxid_beta"],
    )
    assert mapped["bindable"] is False
    assert mapped["status"] in {"unknown", "ambiguous"}


def test_key_material_not_in_output_or_repr():
    secret = "a" * 64
    bundle = KeyBundle(items=[KeyMaterial(key_hex=secret, salt_hex="b" * 32)], source="test", ref_name="env:WXBOT_R0_DB_KEY")
    text = repr(bundle) + str(bundle.items[0]) + scrub_text(f"PRAGMA key = \"x'{secret}'\";")
    assert secret not in text
    assert "redacted" in text.lower() or "[redacted" in text.lower()


def test_read_only_cannot_send(tmp_path: Path):
    cfg = tmp_path / "ro.toml"
    cfg.write_text(
        f"""
mode = "read_only"
data_dir = "{str(tmp_path / "st").replace(chr(92), "/")}"
allow_live_send = false
[account]
alias = "a"
wxid = "{ACCOUNT}"
[group]
alias = "g"
conversation_key = "{CONVERSATION}"
binding_version = "bv-1"
[model]
provider = "mock"
credential_source = "none"
[adapters]
reader = "mock"
sender = "mock"
""",
        encoding="utf-8",
    )
    assert main(["--config", str(cfg), "send-once", "appr-x"]) == 2


def test_body_sql_rejected():
    with pytest.raises(HaltError):
        assert_metadata_sql("SELECT message_content FROM Msg_x")
    with pytest.raises(HaltError):
        assert_metadata_sql("SELECT * FROM contact")


def test_env_key_ref_still_works(monkeypatch):
    monkeypatch.setenv("POC_SQLCIPHER_TEST_KEY", "fixture-key")
    assert resolve_authorized_key("env:POC_SQLCIPHER_TEST_KEY") == "fixture-key"
    with pytest.raises(HaltError):
        resolve_authorized_key("process:weixin")


def test_page_decrypt_requires_every_page(tmp_path: Path):
    pytest.importorskip("cryptography")
    key = bytes.fromhex("11" * 32)
    salt = bytes.fromhex("22" * 16)
    header_page = bytearray(PAGE_SIZE)
    header_page[0:16] = SQLITE_HEADER
    header_page[16:100] = b"plain-ok" + b"\x00" * 76
    encrypted = encrypt_page_for_tests(bytes(header_page), 1, key, salt, first=True)
    src = tmp_path / "enc.db"
    src.write_bytes(encrypted)
    dest = tmp_path / "out.db"
    info = decrypt_database(src, dest, [key])
    assert info["pages"] == 1
    assert dest.read_bytes().startswith(SQLITE_HEADER)
    bad = bytearray(encrypted)
    bad[-1] ^= 0x01
    src.write_bytes(bytes(bad))
    with pytest.raises(HaltError):
        decrypt_database(src, tmp_path / "out2.db", [key])


def _write_meta_dbs(root: Path, conversation: str, self_wxid: str) -> None:
    message_dir = root / AUTHORIZED / "db_storage" / "message"
    message_dir.mkdir(parents=True, exist_ok=True)
    write_db(message_dir / "message_0.db", conversation, [{"local_id": 3, "text": "hist", "create_time": TIME}], self_wxid=self_wxid)
    contact = root / AUTHORIZED / "db_storage" / "contact" / "contact.db"
    contact.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(contact)
    conn.execute("CREATE TABLE contact (username TEXT, remark TEXT, nick_name TEXT, alias TEXT, verify_flag INTEGER)")
    conn.execute(
        "INSERT INTO contact VALUES (?,?,?,?,0)",
        (conversation, "", "示例混合群", ""),
    )
    conn.execute(
        "INSERT INTO contact VALUES (?,?,?,?,0)",
        ("wxid_other", "示例企业A/示例成员A", "示例成员A", ""),
    )
    conn.commit()
    conn.close()
    session = root / AUTHORIZED / "db_storage" / "session" / "session.db"
    session.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(session)
    conn.execute("CREATE TABLE SessionTable (username TEXT, sort_timestamp INTEGER)")
    conn.execute("INSERT INTO SessionTable VALUES (?, 1)", (conversation,))
    conn.commit()
    conn.close()


def test_r0_pipeline_unique_bind_and_cleanup(tmp_path: Path):
    root = tmp_path / "xwechat_files"
    conversation = "room-unique@openim"
    self_wxid = "wxid_selfonly"
    _write_meta_dbs(root, conversation, self_wxid)
    config = _live_cfg(
        tmp_path,
        allow_live_read=True,
        allow_live_discovery=True,
        allow_key_material_from_live_client=True,
        run_id="r0-test-offline",
        account={"data_root": str(root), "wxid": AUTHORIZED},
    )
    bundle = KeyBundle(items=[KeyMaterial(key_hex="aa" * 32)], source="test", ref_name="env:WXBOT_R0_DB_KEY")
    record = execute_r0(config, key_factory=lambda _cfg: bundle)
    assert "halt" not in record
    assert record["stages"]["G-DISCOVERY"]["group"]["session_candidate_count"] == 1
    assert record["stages"]["G-DISCOVERY"]["group"]["conversation_key"] == conversation
    assert record["stages"]["G-DISCOVERY"]["self"]["bindable"] is True
    leftover = list((config.data_dir / "runs" / "r0-test-offline").rglob("*.db"))
    assert leftover == []
    dumped = (config.data_dir / "runs" / "r0-test-offline" / "r0-record.json").read_text(encoding="utf-8")
    assert "aa" * 32 not in dumped
    assert record["stages"]["G-INGEST"]["verdict"] == "未执行"


def test_r0_check_lists_new_gates(tmp_path: Path, capsys):
    cfg = tmp_path / "cfg.toml"
    cfg.write_text(
        f"""
mode = "offline"
data_dir = "{str(tmp_path / "st").replace(chr(92), "/")}"
[account]
alias = "a"
authorized_key_ref = "none"
[group]
alias = "g"
conversation_key = "synthetic_group@openim"
[model]
provider = "mock"
credential_source = "none"
[adapters]
reader = "mock"
sender = "mock"
""",
        encoding="utf-8",
    )
    assert main(["--config", str(cfg), "r0-check"]) == 0
    out = capsys.readouterr().out
    assert "G-KEY" in out
    assert "G-OPEN" in out
    assert "G-DISCOVERY" in out
    assert "G-INGEST" in out
    assert "G-READ" in out
