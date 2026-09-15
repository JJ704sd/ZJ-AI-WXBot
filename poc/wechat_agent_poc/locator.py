"""Metadata-only group and self mapping. Never selects message bodies."""

from __future__ import annotations

import sqlite3
from dataclasses import dataclass
from pathlib import Path

from wechat_agent_poc.chat_room_codec import ChatRoomMembers, decode_ext_buffer
from wechat_agent_poc.models import Halt, HaltError
from wechat_agent_poc.session_map import conversation_table_candidates, quoted_ident

SQL_TEMPLATES = {
    "sqlite_master_tables": "SELECT name FROM sqlite_master WHERE type = ? LIMIT ?",
    "pragma_table_info": "PRAGMA table_info({table})",
    "session_usernames": "SELECT username FROM {table} LIMIT ?",
    "contact_identity": "SELECT username, remark, nick_name, alias FROM {table} LIMIT ?",
    "name2id_usernames": "SELECT user_name FROM Name2Id LIMIT ?",
    "chatroom_username": "SELECT username FROM {table} LIMIT ?",
    "chatroom_ext": "SELECT username, owner, ext_buffer FROM {table} LIMIT ?",
    "baseline_ids": "SELECT m.local_id, m.create_time FROM {table} m ORDER BY m.create_time ASC, m.local_id ASC LIMIT ?",
}

FORBIDDEN_TOKENS = ("message_content", "compress_content", "select *")
DEFAULT_LIMIT = 5000
SELF_DISPLAY_CANDIDATE = "示例本人"


def assert_metadata_sql(sql: str) -> None:
    lowered = " ".join(sql.lower().split())
    for token in FORBIDDEN_TOKENS:
        if token in lowered:
            raise HaltError(Halt("READ_FAILURE", "refusing body or SELECT * SQL in metadata locate", {"sql_id": "rejected"}))


def _text(value: object) -> str:
    if value is None:
        return ""
    if isinstance(value, bytes):
        try:
            return value.decode("utf-8")
        except UnicodeDecodeError:
            return ""
    return str(value).strip()


def _connect(path: Path) -> sqlite3.Connection:
    conn = sqlite3.connect(f"file:{path.as_posix()}?mode=ro", uri=True)
    conn.execute("PRAGMA query_only = ON")
    conn.text_factory = bytes
    return conn


def _table_names(conn: sqlite3.Connection) -> list[str]:
    sql = SQL_TEMPLATES["sqlite_master_tables"]
    assert_metadata_sql(sql)
    rows = conn.execute(sql, ("table", DEFAULT_LIMIT)).fetchall()
    names = []
    for row in rows:
        name = _text(row[0])
        if name:
            names.append(name)
    return names


def _columns(conn: sqlite3.Connection, table: str) -> set[str]:
    quoted = quoted_ident(table)
    sql = SQL_TEMPLATES["pragma_table_info"].format(table=quoted)
    assert_metadata_sql(sql)
    return {_text(row[1]).lower() for row in conn.execute(sql).fetchall()}


def _pick_table(names: list[str], candidates: tuple[str, ...]) -> str | None:
    lowered = {name.lower(): name for name in names}
    for item in candidates:
        if item.lower() in lowered:
            return lowered[item.lower()]
    return None


@dataclass(frozen=True)
class ContactRow:
    username: str
    remark: str
    nick_name: str
    alias: str

    def labels(self) -> set[str]:
        return {item for item in (self.remark, self.nick_name, self.alias, self.username) if item}

    def display(self) -> str:
        return self.remark or self.nick_name or self.alias or self.username


def load_contacts(contact_db: Path | None) -> list[ContactRow]:
    if contact_db is None:
        return []
    conn = _connect(contact_db)
    try:
        names = _table_names(conn)
        rows: list[ContactRow] = []
        seen: set[str] = set()
        for table in (_pick_table(names, ("contact", "Contact")), _pick_table(names, ("stranger", "Stranger"))):
            if table is None:
                continue
            columns = _columns(conn, table)
            needed = {"username", "remark", "nick_name", "alias"}
            if not needed.issubset(columns):
                continue
            sql = SQL_TEMPLATES["contact_identity"].format(table=quoted_ident(table))
            assert_metadata_sql(sql)
            for item in conn.execute(sql, (DEFAULT_LIMIT,)).fetchall():
                row = ContactRow(_text(item[0]), _text(item[1]), _text(item[2]), _text(item[3]))
                if row.username and row.username not in seen:
                    seen.add(row.username)
                    rows.append(row)
        return rows
    finally:
        conn.close()


def load_sessions(session_db: Path | None) -> list[str]:
    if session_db is None:
        return []
    conn = _connect(session_db)
    try:
        names = _table_names(conn)
        table = _pick_table(names, ("SessionTable", "Session", "session"))
        if table is None:
            return []
        columns = _columns(conn, table)
        if "username" not in columns:
            return []
        sql = SQL_TEMPLATES["session_usernames"].format(table=quoted_ident(table))
        assert_metadata_sql(sql)
        return [_text(row[0]) for row in conn.execute(sql, (DEFAULT_LIMIT,)).fetchall() if _text(row[0])]
    finally:
        conn.close()


def load_name2id(message_db: Path) -> list[str]:
    conn = _connect(message_db)
    try:
        names = _table_names(conn)
        if "Name2Id" not in names and "name2id" not in {item.lower() for item in names}:
            return []
        sql = SQL_TEMPLATES["name2id_usernames"]
        assert_metadata_sql(sql)
        return [_text(row[0]) for row in conn.execute(sql, (DEFAULT_LIMIT,)).fetchall() if _text(row[0])]
    finally:
        conn.close()


def load_chat_rooms(contact_db: Path | None) -> list[ChatRoomMembers] | None:
    if contact_db is None:
        return None
    conn = _connect(contact_db)
    try:
        names = _table_names(conn)
        table = _pick_table(names, ("chat_room", "ChatRoom", "chatroom"))
        if table is None:
            return None
        columns = _columns(conn, table)
        if "username" not in columns or "ext_buffer" not in columns:
            return []
        sql = SQL_TEMPLATES["chatroom_ext"].format(table=quoted_ident(table))
        assert_metadata_sql(sql)
        rows: list[ChatRoomMembers] = []
        for item in conn.execute(sql, (DEFAULT_LIMIT,)).fetchall():
            username = _text(item[0])
            owner = _text(item[1])
            if not username:
                continue
            try:
                rows.append(decode_ext_buffer(item[2], username=username, owner=owner))
            except HaltError:
                continue
        return rows
    finally:
        conn.close()


def locate_group(
    *,
    display_name: str,
    member_features: tuple[str, ...],
    contacts: list[ContactRow],
    sessions: list[str],
    chat_rooms: list[ChatRoomMembers] | None = None,
) -> dict[str, object]:
    by_user = {row.username: row for row in contacts}
    name_hits = [row for row in contacts if display_name and display_name in row.labels()]
    session_hits = [username for username in sessions if username in {row.username for row in name_hits}]
    if not session_hits:
        session_hits = [
            username
            for username in sessions
            if display_name and display_name in by_user.get(username, ContactRow(username, "", "", "")).labels()
        ]
    unique = list(dict.fromkeys(session_hits))
    status = "unique" if len(unique) == 1 else ("none" if not unique else "ambiguous")
    bindable = status == "unique"
    member_hits: list[dict[str, object]] = []
    missing_members: list[str] = []
    member_keys: list[str] = []
    member_source = "contact_labels"
    room_note = ""
    templates = ["session_usernames", "contact_identity"]
    if chat_rooms is not None:
        templates.append("chatroom_ext")
        member_source = "chat_room.ext_buffer"
        rooms = {row.username: row for row in chat_rooms}
        if status == "unique":
            room = rooms.get(unique[0])
            if room is None:
                bindable = False
                status = "unknown"
                room_note = "unique session has no decoded chat_room.ext_buffer"
                missing_members = list(member_features)
            else:
                member_keys = list(room.member_keys)
                allowed = set(room.member_keys)
                feature_contacts = [row for row in contacts if row.username in allowed]
                extra_labels = set(room.feature_labels)
                extra_labels.update(room.member_keys)
                for feature in member_features:
                    matched = [
                        row.username
                        for row in feature_contacts
                        if feature in row.labels() or feature in row.display()
                    ]
                    if not matched and feature in extra_labels:
                        matched = [unique[0]]
                    if matched:
                        member_hits.append({"feature": feature, "usernames": matched[:5], "count": len(matched)})
                    else:
                        missing_members.append(feature)
        else:
            missing_members = list(member_features)
    else:
        for feature in member_features:
            matched = [row.username for row in contacts if feature in row.labels() or feature in row.display()]
            if matched:
                member_hits.append({"feature": feature, "usernames": matched[:5], "count": len(matched)})
            else:
                missing_members.append(feature)
    note = "示例本人 is a display-name clue only and is not used as conversation_key"
    if room_note:
        note = room_note
    return {
        "sql_templates": templates,
        "display_name": display_name,
        "session_candidate_count": len(unique),
        "session_candidates": unique[:10],
        "name_hit_count": len(name_hits),
        "member_feature_hits": member_hits,
        "missing_member_features": missing_members,
        "member_keys": member_keys[:20],
        "member_source": member_source,
        "status": status,
        "bindable": bindable,
        "conversation_key": unique[0] if bindable else "",
        "note": note,
    }


def map_self(
    *,
    account_wxid: str,
    contacts: list[ContactRow],
    name2id: list[str],
) -> dict[str, object]:
    contact_users = {row.username for row in contacts}
    wxid_in_map = list(dict.fromkeys(item for item in name2id if item.startswith("wxid_")))
    not_in_contact = [item for item in wxid_in_map if item not in contact_users]
    prefix = account_wxid.rsplit("_", 1)[0]
    dir_hits = [
        item
        for item in wxid_in_map
        if item == account_wxid or item == prefix or account_wxid.startswith(item + "_")
    ]
    qijiao = [row for row in contacts if SELF_DISPLAY_CANDIDATE in row.labels()]
    evidence = {
        "sql_templates": ["name2id_usernames", "contact_identity"],
        "directory_wxid": account_wxid,
        "name2id_wxid_count": len(wxid_in_map),
        "wxid_not_in_contact_count": len(not_in_contact),
        "directory_match_count": len(dir_hits),
        "qijiao_contact_count": len(qijiao),
        "qijiao_is_display_clue_only": True,
    }
    unique_self = None
    if len(not_in_contact) == 1:
        unique_self = not_in_contact[0]
    elif len(dir_hits) == 1:
        unique_self = dir_hits[0]
    if unique_self is None:
        return {
            **evidence,
            "status": "unknown",
            "self_sender_key": "",
            "bindable": False,
            "note": "display name 示例本人 is insufficient; Name2Id/contact mapping was not unique",
        }
    if len(qijiao) == 1 and qijiao[0].username != unique_self:
        return {
            **evidence,
            "status": "ambiguous",
            "self_sender_key": "",
            "bindable": False,
            "note": "示例本人 mapped to a contact that is not the unique self candidate; refusing to guess",
        }
    return {
        **evidence,
        "status": "resolved",
        "self_sender_key": unique_self,
        "bindable": True,
        "qijiao_matched_self": bool(qijiao) and all(row.username == unique_self for row in qijiao),
    }


def baseline_metadata(message_db: Path, conversation_key: str, *, limit: int = DEFAULT_LIMIT) -> dict[str, object]:
    if not conversation_key:
        raise HaltError(Halt("GROUP_UNKNOWN", "conversation_key is required for baseline"))
    conn = _connect(message_db)
    try:
        names = _table_names(conn)
        wanted = {item.lower() for item in conversation_table_candidates(conversation_key)}
        table = None
        for name in names:
            if name.lower() in wanted:
                table = name
                break
        if table is None:
            return {
                "sql_templates": ["sqlite_master_tables", "baseline_ids"],
                "table": None,
                "row_count": 0,
                "max_local_id": None,
                "max_create_time": None,
                "bodies_read": False,
            }
        sql = SQL_TEMPLATES["baseline_ids"].format(table=quoted_ident(table))
        assert_metadata_sql(sql)
        rows = conn.execute(sql, (limit,)).fetchall()
        ids = []
        times = []
        for local_id, create_time in rows:
            if local_id is not None:
                ids.append(int(local_id))
            if create_time is not None:
                times.append(int(create_time))
        return {
            "sql_templates": ["sqlite_master_tables", "baseline_ids"],
            "table": table,
            "row_count": len(rows),
            "max_local_id": max(ids) if ids else None,
            "max_create_time": max(times) if times else None,
            "bodies_read": False,
        }
    finally:
        conn.close()
