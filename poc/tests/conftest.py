from __future__ import annotations

import hashlib
import sqlite3
from pathlib import Path

from wechat_agent_poc.config import parse_config

CONVERSATION = "synthetic_group@openim"
OTHER_GROUP = "other_group@chatroom"
ACCOUNT = "wxid_target"
OTHER_ACCOUNT = "wxid_other"
SELF = "wxid_self"
TIME = 1_800_000_000


def table_for(conversation: str) -> str:
    return "Msg_" + hashlib.md5(conversation.encode("utf-8")).hexdigest()


def make_config(tmp_path: Path, **overrides):
    raw = {
        "mode": "offline",
        "data_dir": str(tmp_path / "state"),
        "lookback_seconds": 120,
        "context_limit": 20,
        "max_draft_chars": 500,
        "approval_ttl_seconds": 300,
        "operator": "tester",
        "wechat_version_recorded": "",
        "receivers": [],
        "account": {
            "alias": "test-wechat-a",
            "wxid": ACCOUNT,
            "data_root": str(tmp_path / "data"),
            "self_sender_key": SELF,
            "authorized_key_ref": "none",
        },
        "group": {
            "alias": "test-external-group",
            "conversation_key": CONVERSATION,
            "binding_version": "bv-1",
            "member_features": ["synthetic_wecom_member", "synthetic_wechat_member"],
            "display_name": "合成测试群",
            "required_detail_tokens": ["合成测试群", "external-poc"],
        },
        "model": {"provider": "mock", "credential_source": "none"},
        "adapters": {"reader": "sqlite_plain", "sender": "mock"},
    }
    _merge(raw, overrides)
    return parse_config(raw)


def _merge(base: dict, extra: dict) -> None:
    for key, value in extra.items():
        if isinstance(value, dict) and isinstance(base.get(key), dict):
            _merge(base[key], value)
        else:
            base[key] = value


def account_dir(root: Path, wxid: str) -> Path:
    path = root / "xwechat_files" / wxid / "db_storage" / "message"
    path.mkdir(parents=True, exist_ok=True)
    return path


def write_db(
    path: Path,
    conversation: str,
    rows: list[dict],
    *,
    extra_conversations: list[str] | None = None,
    self_wxid: str = SELF,
):
    conn = sqlite3.connect(path)
    conn.execute("CREATE TABLE IF NOT EXISTS Name2Id(user_name TEXT)")
    existing = {row[0] for row in conn.execute("SELECT user_name FROM Name2Id")}
    if self_wxid not in existing:
        conn.execute("INSERT INTO Name2Id(rowid, user_name) VALUES (2, ?)", (self_wxid,))
    if "synthetic_wecom_member" not in existing:
        conn.execute("INSERT INTO Name2Id(rowid, user_name) VALUES (9, ?)", ("synthetic_wecom_member",))
    if "synthetic_wechat_member" not in existing:
        conn.execute("INSERT INTO Name2Id(rowid, user_name) VALUES (10, ?)", ("synthetic_wechat_member",))
    for name in [conversation, *(extra_conversations or [])]:
        table = table_for(name)
        conn.execute(
            f'CREATE TABLE IF NOT EXISTS "{table}" (local_id INTEGER, create_time INTEGER, message_content TEXT, '
            "compress_content BLOB, real_sender_id INTEGER, local_type INTEGER, server_id INTEGER)"
        )
    table = table_for(conversation)
    for row in rows:
        conn.execute(
            f'INSERT INTO "{table}" VALUES (?,?,?,?,?,?,?)',
            (
                row["local_id"],
                row.get("create_time", TIME),
                row.get("text"),
                row.get("compress"),
                row.get("sender_rowid", 9),
                row.get("local_type", 1),
                row.get("server_id", 0),
            ),
        )
    conn.commit()
    conn.close()
