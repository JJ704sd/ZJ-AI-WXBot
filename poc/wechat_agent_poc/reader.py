from __future__ import annotations

import sqlite3
from dataclasses import dataclass
from pathlib import Path
from typing import Callable, Iterable, Protocol

from wechat_agent_poc.config import AppConfig, isoformat
from wechat_agent_poc.discovery import ShardSnapshot, discover_account_shards
from wechat_agent_poc.keys import resolve_authorized_key
from wechat_agent_poc.live_guard import assert_live_read_permitted, assert_plaintext_fixture_only, is_live_wechat_root
from wechat_agent_poc.mention import STRUCTURED_FIELD_NAMES, classify_mention
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
    mention_fields: dict[str, object] | None = None


class SqlitePlainReader:
    """Read unencrypted fixture/message DBs. Does not extract keys or attach to processes."""

    def __init__(self, config: AppConfig, store: Store):
        self.config = config
        self.store = store
        self.last_sql: list[tuple[str, str]] = []

    def read_new_messages(self, binding=None, checkpoint_store: Store | None = None) -> list[Event]:
        store = checkpoint_store or self.store
        self.last_sql = []
        if store.paused():
            raise HaltError(Halt("PAUSED", store.runtime_get("pause_reason") or "paused"))
        if self.config.data_root is None:
            raise HaltError(Halt("READ_FAILURE", "data_root is not configured"))
        if not self.config.binding.account_wxid:
            raise HaltError(Halt("ACCOUNT_UNKNOWN", "account.wxid is required for database reading"))
        if not self.config.binding.conversation_key:
            raise HaltError(Halt("GROUP_UNKNOWN", "group.conversation_key is required"))
        self._assert_read_permitted()
        shards = discover_account_shards(
            self.config.data_root,
            self.config.binding.account_wxid,
            enumerate_siblings=not is_live_wechat_root(self.config.data_root),
        )
        events: list[Event] = []
        checkpoints: list[Checkpoint] = []
        for shard in shards:
            store.record_file(str(shard.db_path), "db", shard.fingerprint)
            if shard.wal_path is not None:
                store.record_file(str(shard.wal_path), "wal", shard.fingerprint)
            events.extend(self._read_shard(shard, store, checkpoints))
        accepted = store.ingest(events, checkpoints)
        store.runtime_set("reader_initialized", "1")
        if store.runtime_get("baseline_ready_at") is None:
            store.runtime_set("baseline_ready_at", isoformat())
        return accepted

    def _assert_read_permitted(self) -> None:
        assert_plaintext_fixture_only(self.config)

    def _open_connection(self, db_path: Path):
        conn = sqlite3.connect(str(db_path))
        conn.execute("PRAGMA query_only = ON")
        return conn

    def _read_shard(
        self,
        shard: ShardSnapshot,
        store: Store,
        checkpoints: list[Checkpoint],
    ) -> list[Event]:
        try:
            conn = self._open_connection(shard.db_path)
            conn.text_factory = bytes
        except sqlite3.Error as exc:
            raise HaltError(Halt("DB_LOCK", f"cannot open {shard.db_path.name}: {exc}")) from exc
        try:
            return list(self._iter_shard(conn, shard, store, checkpoints))
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
    ) -> Iterable[Event]:
        conversation = self.config.binding.conversation_key
        if not allow_conversation(conversation, self.config.whitelist):
            return
        table = resolve_msg_table(conn, conversation)
        if table is None:
            return
        account = self.config.binding.account_alias
        checkpoint = store.checkpoint(account, shard.source_shard, table)
        if checkpoint is None or not checkpoint.initialized:
            meta = _fetch_metadata(conn, table, self.last_sql)
            store.save_baseline_keys(account, shard.source_shard, table, meta)
            max_time = max((item[1] or 0) for item in meta) if meta else None
            max_id = 0
            if meta:
                peak = max_time or 0
                max_id = max((item[0] or 0) for item in meta if (item[1] or 0) == peak)
            checkpoints.append(
                Checkpoint(
                    account,
                    shard.source_shard,
                    table,
                    max_time,
                    max_id if meta else None,
                    initialized=True,
                )
            )
            return
        exclude_ids = store.baseline_message_ids(account, shard.source_shard, table)
        rows = list(
            _fetch_incremental(
                conn,
                table,
                shard.source_shard,
                self.config.binding.self_sender_key,
                checkpoint,
                self.config.lookback_seconds,
                exclude_ids,
                self.last_sql,
            )
        )
        new_max_time = checkpoint.last_source_time if checkpoint.last_source_time is not None else -1
        new_max_id = int(checkpoint.last_message_id) if checkpoint.last_message_id is not None else -1
        for row in rows:
            if row.local_id is None:
                continue
            if late_beyond_lookback(row.create_time, checkpoint, self.config.lookback_seconds):
                continue
            if not _is_new_row(row, checkpoint, self.config.lookback_seconds):
                continue
            yield self._to_event(row, table, historical=False, replay=False, late=False)
            if row.create_time is not None and row.create_time > new_max_time:
                new_max_time = row.create_time
                new_max_id = row.local_id or 0
            elif row.create_time == new_max_time and (row.local_id or 0) > new_max_id:
                new_max_id = row.local_id or 0
        checkpoints.append(
            Checkpoint(
                account,
                shard.source_shard,
                table,
                new_max_time if new_max_time >= 0 else checkpoint.last_source_time,
                new_max_id if new_max_id >= 0 else checkpoint.last_message_id,
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
        mention = classify_mention(
            self_sender_key=self.config.binding.self_sender_key,
            fields=row.mention_fields,
            text=text,
        )
        return Event(
            schema_version=SCHEMA_VERSION,
            event_key=event_key(
                self.config.binding.account_alias,
                row.shard,
                table,
                row.local_id,
                self.config.binding.conversation_key,
            ),
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
            mention_self=mention.mention_self,
            mentioned_keys=mention.mentioned_keys,
            mention_all=mention.mention_all,
            mention_field=mention.source_field,
            mention_reason=mention.reason,
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


def _fetch_metadata(
    conn: sqlite3.Connection, table: str, last_sql: list[tuple[str, str]]
) -> list[tuple[int | None, int | None]]:
    quoted = quoted_ident(table)
    sql = f'SELECT m.local_id, m.create_time FROM {quoted} m ORDER BY m.create_time ASC, m.local_id ASC'
    last_sql.append(("baseline", sql))
    rows = []
    for item in conn.execute(sql).fetchall():
        rows.append((_maybe_int(item[0]), _maybe_int(item[1])))
    return rows


def _fetch_incremental(
    conn: sqlite3.Connection,
    table: str,
    shard: str,
    self_sender_key: str,
    checkpoint: Checkpoint,
    lookback_seconds: int,
    exclude_ids: set[int],
    last_sql: list[tuple[str, str]],
) -> list[RawRow]:
    quoted = quoted_ident(table)
    columns = {_col_name(row[1]) for row in conn.execute(f"PRAGMA table_info({quoted})")}
    has_compress = "compress_content" in columns
    has_server = "server_id" in columns
    compress = ", m.compress_content" if has_compress else ", NULL"
    server = ", m.server_id" if has_server else ", NULL"
    order_col = "sort_seq" if "sort_seq" in columns else "create_time"
    self_rowid = _lookup_self_rowid(conn, self_sender_key)
    last_time = checkpoint.last_source_time if checkpoint.last_source_time is not None else -1
    last_id = int(checkpoint.last_message_id) if checkpoint.last_message_id is not None else -1
    lookback_start = last_time - lookback_seconds
    mention_cols = [name for name in STRUCTURED_FIELD_NAMES if name in columns]
    mention_select = "".join(f", m.{quoted_ident(name)}" for name in mention_cols)
    select = (
        f"SELECT m.local_id, m.create_time, m.real_sender_id, m.message_content{compress}{server}, "
        f"n.user_name{mention_select} FROM {quoted} m LEFT JOIN Name2Id n ON m.real_sender_id = n.rowid "
    )
    where = (
        "WHERE (m.create_time > ? OR (m.create_time = ? AND m.local_id > ?) "
        "OR (m.create_time >= ? AND m.create_time < ?))"
    )
    params: list[object] = [last_time, last_time, last_id, lookback_start, last_time]
    if exclude_ids:
        placeholders = ",".join("?" for _ in exclude_ids)
        where += f" AND m.local_id NOT IN ({placeholders})"
        params.extend(sorted(exclude_ids))
    sql = f'{select} {where} ORDER BY m."{order_col}" ASC, m.local_id ASC'
    last_sql.append(("incremental", sql))
    try:
        fetched = conn.execute(sql, params).fetchall()
    except sqlite3.Error:
        fallback = (
            f"SELECT m.local_id, m.create_time, m.real_sender_id, m.message_content{compress}{server}, "
            f"NULL{mention_select} FROM {quoted} m {where} ORDER BY m.local_id ASC"
        )
        last_sql.append(("incremental", fallback))
        fetched = conn.execute(fallback, params).fetchall()
    rows: list[RawRow] = []
    for item in fetched:
        sender = _maybe_text(item[6]) if len(item) > 6 else None
        mention_fields = {}
        for offset, name in enumerate(mention_cols):
            index = 7 + offset
            if index < len(item):
                mention_fields[name] = item[index]
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
                mention_fields=mention_fields or None,
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


class SqlcipherReader(SqlitePlainReader):
    """Open SQLCipher DBs with an authorized key reference. Never extracts process keys."""

    def __init__(self, config: AppConfig, store: Store, opener: Callable[..., object] | None = None):
        super().__init__(config, store)
        self._opener = opener

    def _assert_read_permitted(self) -> None:
        resolve_authorized_key(self.config.authorized_key_ref)
        assert_live_read_permitted(self.config)

    def _open_connection(self, db_path: Path):
        key = resolve_authorized_key(self.config.authorized_key_ref)
        if self._opener is not None:
            conn = self._opener(str(db_path), key)
            conn.execute("PRAGMA query_only = ON")
            return conn
        try:
            import sqlcipher3
        except ImportError as exc:
            raise HaltError(
                Halt(
                    "READ_FAILURE",
                    "sqlcipher3 is not installed; install the sqlcipher extra. Process key extraction is not a fallback",
                    {"authorized_key_ref_configured": True},
                )
            ) from exc
        conn = sqlcipher3.connect(str(db_path))
        conn.execute("PRAGMA query_only = ON")
        conn.execute("PRAGMA key = ?", (key,))
        return conn
