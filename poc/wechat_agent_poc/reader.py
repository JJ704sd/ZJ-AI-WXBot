from __future__ import annotations

import sqlite3
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Protocol

from wechat_agent_poc.config import AppConfig, isoformat
from wechat_agent_poc.discovery import ShardSnapshot, discover_account_shards
from wechat_agent_poc.models import SCHEMA_VERSION, Event, Halt, HaltError, event_key
from wechat_agent_poc.session_map import allow_conversation, quoted_ident, resolve_msg_table
from wechat_agent_poc.store import Checkpoint, Store, late_beyond_lookback
from wechat_agent_poc.text_decode import decode_message_text


class MessageSource(Protocol):
    def read_new_messages(self, binding, checkpoint_store: Store) -> list[Event]: ...


@dataclass
class RawRow:
    shard: str
    table: str
    local_id: int | None
    create_time: int | None
    sender_key: str | None
    sender_rowid: int | None
    message_value: object
    compress_value: object
    self_rowid: int | None


class SqlitePlainReader:
    """Read unencrypted fixture/message DBs. Does not extract keys or attach to processes."""

    def __init__(self, config: AppConfig, store: Store):
        self.config = config
        self.store = store

    def read_new_messages(self, binding=None, checkpoint_store: Store | None = None) -> list[Event]:
        store = checkpoint_store or self.store
        if store.paused():
            raise HaltError(Halt("PAUSED", store.runtime_get("pause_reason") or "paused"))
        if self.config.data_root is None:
            raise HaltError(Halt("READ_FAILURE", "data_root is not configured"))
        if not self.config.binding.account_wxid:
            raise HaltError(Halt("ACCOUNT_UNKNOWN", "account.wxid is required for database reading"))
        if not self.config.binding.conversation_key:
            raise HaltError(Halt("GROUP_UNKNOWN", "group.conversation_key is required"))
        shards = discover_account_shards(self.config.data_root, self.config.binding.account_wxid)
        first_boot = store.runtime_get("reader_initialized") != "1"
        events: list[Event] = []
        checkpoints: list[Checkpoint] = []
        for shard in shards:
            store.record_file(str(shard.db_path), "db", shard.fingerprint)
            if shard.wal_path is not None:
                store.record_file(str(shard.wal_path), "wal", shard.fingerprint)
            events.extend(self._read_shard(shard, store, checkpoints, first_boot=first_boot))
        accepted = store.ingest(events, checkpoints)
        store.runtime_set("reader_initialized", "1")
        return accepted

    def _read_shard(
        self,
        shard: ShardSnapshot,
        store: Store,
        checkpoints: list[Checkpoint],
        *,
        first_boot: bool,
    ) -> list[Event]:
        try:
            conn = sqlite3.connect(str(shard.db_path))
            conn.execute("PRAGMA query_only = ON")
        except sqlite3.Error as exc:
            raise HaltError(Halt("DB_LOCK", f"cannot open {shard.db_path.name}: {exc}")) from exc
        conn.text_factory = bytes
        try:
            return list(self._iter_shard(conn, shard, store, checkpoints, first_boot=first_boot))
        except sqlite3.Error as exc:
            raise HaltError(Halt("READ_FAILURE", f"sqlite error on {shard.shard_name}: {exc}")) from exc
        finally:
            conn.close()

    def _iter_shard(
        self,
        conn: sqlite3.Connection,
        shard: ShardSnapshot,
        store: Store,
        checkpoints: list[Checkpoint],
        *,
        first_boot: bool,
    ) -> Iterable[Event]:
        conversation = self.config.binding.conversation_key
        if not allow_conversation(conversation, self.config.whitelist):
            return
        table = resolve_msg_table(conn, conversation)
        if table is None:
            return
        checkpoint = store.checkpoint(self.config.binding.account_alias, shard.source_shard, table)
        rows = list(_fetch_rows(conn, table, shard.source_shard, self.config.binding.self_sender_key))
        if not rows:
            checkpoints.append(
                Checkpoint(
                    self.config.binding.account_alias,
                    shard.source_shard,
                    table,
                    checkpoint.last_source_time if checkpoint else None,
                    checkpoint.last_message_id if checkpoint else None,
                    initialized=True if checkpoint else False,
                )
            )
            return
        initialized = checkpoint is not None and checkpoint.initialized
        max_time = max((row.create_time or 0) for row in rows)
        max_id_at_max_time = max((row.local_id or 0) for row in rows if (row.create_time or 0) == max_time)
        if not initialized and first_boot:
            for row in rows:
                yield self._to_event(row, table, historical=True, replay=False, late=False)
            checkpoints.append(
                Checkpoint(
                    self.config.binding.account_alias,
                    shard.source_shard,
                    table,
                    max_time,
                    max_id_at_max_time,
                    initialized=True,
                )
            )
            return
        if not initialized and not first_boot:
            checkpoint = Checkpoint(
                self.config.binding.account_alias,
                shard.source_shard,
                table,
                last_source_time=-1,
                last_message_id=-1,
                initialized=True,
            )
        new_max_time = checkpoint.last_source_time or 0
        new_max_id = checkpoint.last_message_id or 0
        for row in rows:
            if row.local_id is None:
                yield self._to_event(row, table, historical=True, replay=False, late=False, identity="unknown")
                continue
            if late_beyond_lookback(row.create_time, checkpoint, self.config.lookback_seconds):
                yield self._to_event(row, table, historical=True, replay=False, late=True)
                continue
            is_new = _is_new_row(row, checkpoint, self.config.lookback_seconds)
            if not is_new:
                continue
            yield self._to_event(row, table, historical=False, replay=False, late=False)
            if row.create_time is not None and row.create_time > new_max_time:
                new_max_time = row.create_time
                new_max_id = row.local_id or 0
            elif row.create_time == new_max_time and (row.local_id or 0) > new_max_id:
                new_max_id = row.local_id or 0
        checkpoints.append(
            Checkpoint(
                self.config.binding.account_alias,
                shard.source_shard,
                table,
                new_max_time,
                new_max_id,
                initialized=True,
            )
        )

    def _to_event(
        self,
        row: RawRow,
        table: str,
        *,
        historical: bool,
        replay: bool,
        late: bool,
        identity: str | None = None,
    ) -> Event:
        decoded = decode_message_text(row.message_value, row.compress_value)
        is_self: str = "unknown"
        if row.self_rowid is not None and row.sender_rowid is not None:
            is_self = "true" if row.sender_rowid == row.self_rowid else "false"
        elif self.config.binding.self_sender_key and row.sender_key:
            is_self = "true" if row.sender_key == self.config.binding.self_sender_key else "false"
        identity_status = identity or ("resolved" if row.local_id is not None and is_self != "unknown" else "unknown")
        text = decoded.text if decoded.sendable else None
        return Event(
            schema_version=SCHEMA_VERSION,
            event_key=event_key(self.config.binding.account_alias, row.shard, table, row.local_id),
            account_alias=self.config.binding.account_alias,
            conversation_key=self.config.binding.conversation_key,
            source_shard=row.shard,
            source_table=table,
            source_message_id=row.local_id,
            sender_key=row.sender_key,
            is_self=is_self,  # type: ignore[arg-type]
            source_time=row.create_time,
            observed_at=isoformat(),
            text=text,
            evidence_ref=f"{row.shard}:{table}:{row.local_id}",
            identity_status=identity_status,  # type: ignore[arg-type]
            is_historical=historical or late,
            parse_status="ok" if decoded.sendable else decoded.status,  # type: ignore[arg-type]
            is_replay=replay,
        )


def _is_new_row(row: RawRow, checkpoint: Checkpoint, lookback_seconds: int) -> bool:
    source_time = row.create_time if row.create_time is not None else -1
    message_id = int(row.local_id or -1)
    last_time = checkpoint.last_source_time if checkpoint.last_source_time is not None else -1
    last_id = int(checkpoint.last_message_id) if checkpoint.last_message_id is not None else -1
    if source_time > last_time:
        return True
    if source_time == last_time and message_id > last_id:
        return True
    if last_time - lookback_seconds <= source_time < last_time:
        return True
    return False


def _fetch_rows(conn: sqlite3.Connection, table: str, shard: str, self_sender_key: str) -> list[RawRow]:
    quoted = quoted_ident(table)
    columns = { _col_name(row[1]) for row in conn.execute(f'PRAGMA table_info({quoted})') }
    has_compress = "compress_content" in columns
    has_server = "server_id" in columns
    compress = ", m.compress_content" if has_compress else ", NULL"
    server = ", m.server_id" if has_server else ", NULL"
    order_col = "sort_seq" if "sort_seq" in columns else "create_time"
    self_rowid = _lookup_self_rowid(conn, self_sender_key)
    sql = (
        f"SELECT m.local_id, m.create_time, m.real_sender_id, m.message_content{compress}{server}, "
        f"n.user_name FROM {quoted} m LEFT JOIN Name2Id n ON m.real_sender_id = n.rowid "
        f'ORDER BY m."{order_col}" ASC, m.local_id ASC'
    )
    try:
        fetched = conn.execute(sql).fetchall()
    except sqlite3.Error:
        sql = (
            f"SELECT m.local_id, m.create_time, m.real_sender_id, m.message_content{compress}{server}, "
            f"NULL FROM {quoted} m ORDER BY m.local_id ASC"
        )
        fetched = conn.execute(sql).fetchall()
    rows: list[RawRow] = []
    for item in fetched:
        sender = _maybe_text(item[5]) if len(item) > 5 else None
        rows.append(
            RawRow(
                shard=shard,
                table=table,
                local_id=_maybe_int(item[0]),
                create_time=_maybe_int(item[1]),
                sender_key=sender,
                sender_rowid=_maybe_int(item[2]),
                message_value=item[3],
                compress_value=item[4],
                self_rowid=self_rowid,
            )
        )
    return rows


def _lookup_self_rowid(conn: sqlite3.Connection, self_sender_key: str) -> int | None:
    if not self_sender_key:
        return None
    try:
        row = conn.execute("SELECT rowid FROM Name2Id WHERE user_name = ? LIMIT 1", (self_sender_key.encode("utf-8"),)).fetchone()
        if row is None:
            row = conn.execute("SELECT rowid FROM Name2Id WHERE user_name = ? LIMIT 1", (self_sender_key,)).fetchone()
    except sqlite3.Error:
        return None
    return int(row[0]) if row else None


def _col_name(value: object) -> str:
    if isinstance(value, bytes):
        return value.decode("utf-8", errors="replace")
    return str(value)


def _maybe_int(value: object) -> int | None:
    if value is None or value == b"":
        return None
    if isinstance(value, bytes):
        value = value.decode("utf-8")
    try:
        return int(value)
    except (TypeError, ValueError):
        return None


def _maybe_text(value: object) -> str | None:
    if value is None:
        return None
    if isinstance(value, bytes):
        try:
            return value.decode("utf-8")
        except UnicodeDecodeError:
            return None
    return str(value)


class SqlcipherReader:
    def __init__(self, config: AppConfig, store: Store):
        self.config = config
        self.store = store

    def read_new_messages(self, binding=None, checkpoint_store: Store | None = None) -> list[Event]:
        if self.config.authorized_key_ref in ("", "none"):
            raise HaltError(
                Halt(
                    "READ_FAILURE",
                    "sqlcipher_readonly requires an authorized key reference; process key extraction is not a fallback",
                    {
                        "potential_key_scope": "all databases protected by the same material, not single-group",
                        "program_query_scope": "bound conversation tables plus Name2Id mapping only",
                    },
                )
            )
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "live SQLCipher opening is not enabled in this offline PoC build",
                {"authorized_key_ref_configured": True},
            )
        )
