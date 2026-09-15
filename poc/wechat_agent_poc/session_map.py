"""Conversation-to-table mapping and whitelist filtering.

Table-name candidates follow the documented Msg_<md5(conversation)> pattern.
Session inclusion is an explicit binding whitelist. The attachment's
`@openim` exclusion rule is treated as a regression fixture, not policy.
"""

from __future__ import annotations

import hashlib
import re
import sqlite3
from collections.abc import Iterable


def conversation_table_candidates(conversation_key: str) -> tuple[str, ...]:
    digest = hashlib.md5(conversation_key.encode("utf-8")).hexdigest()
    return (f"Msg_{digest}", f"msg_{digest}", f"Chat_{digest}", f"chat_{digest}")


def resolve_msg_table(conn: sqlite3.Connection, conversation_key: str) -> str | None:
    digest = hashlib.md5(conversation_key.encode("utf-8")).hexdigest().lower()
    names = []
    for row in conn.execute("SELECT name FROM sqlite_master WHERE type='table'"):
        name = row[0]
        if isinstance(name, bytes):
            try:
                name = name.decode("utf-8")
            except UnicodeDecodeError:
                continue
        names.append(str(name))
    expected = {item.lower() for item in conversation_table_candidates(conversation_key)}
    for name in names:
        if name.lower() in expected:
            return name
    for name in names:
        lowered = name.lower()
        if digest in lowered and (lowered.startswith("msg_") or lowered.startswith("chat_")):
            return name
    return None


def allow_conversation(conversation_key: str, whitelist: Iterable[str]) -> bool:
    if not conversation_key:
        return False
    return conversation_key in set(whitelist)


def reject_openim_exclusion(conversation_key: str) -> bool:
    """Attachment anti-pattern: True if the old exporter would have dropped it."""
    return "@openim" in conversation_key or "@kefu.openim" in conversation_key


def quoted_ident(name: str) -> str:
    if not re.fullmatch(r"[A-Za-z0-9_]+", name):
        raise ValueError(f"refusing non-identifier table name {name!r}")
    return f'"{name}"'
