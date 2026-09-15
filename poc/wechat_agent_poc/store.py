from __future__ import annotations

import json
import sqlite3
from dataclasses import dataclass
from datetime import timedelta
from pathlib import Path
from typing import Any, Iterable
from uuid import uuid4

from wechat_agent_poc.clock import Clock, SystemClock
from wechat_agent_poc.config import isoformat
from wechat_agent_poc.hashes import sha256_text
from wechat_agent_poc.models import Event, Halt, HaltError

SCHEMA = """
CREATE TABLE IF NOT EXISTS events (
    event_key TEXT PRIMARY KEY,
    schema_version TEXT NOT NULL,
    account_alias TEXT NOT NULL,
    conversation_key TEXT NOT NULL,
    source_shard TEXT NOT NULL,
    source_table TEXT NOT NULL,
    source_message_id INTEGER,
    sender_key TEXT,
    is_self TEXT NOT NULL,
    source_time INTEGER,
    observed_at TEXT NOT NULL,
    text TEXT,
    evidence_ref TEXT,
    identity_status TEXT NOT NULL,
    is_historical INTEGER NOT NULL,
    parse_status TEXT NOT NULL,
    is_replay INTEGER NOT NULL DEFAULT 0,
    runtime_id TEXT,
    raw_json TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS checkpoints (
    account_alias TEXT NOT NULL,
    source_shard TEXT NOT NULL,
    source_table TEXT NOT NULL,
    last_source_time INTEGER,
    last_message_id INTEGER,
    initialized INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (account_alias, source_shard, source_table)
);
CREATE TABLE IF NOT EXISTS seen_keys (
    event_key TEXT PRIMARY KEY,
    observed_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS drafts (
    draft_id TEXT PRIMARY KEY,
    event_key TEXT NOT NULL UNIQUE,
    action TEXT NOT NULL,
    text TEXT,
    text_hash TEXT,
    evidence_keys TEXT NOT NULL,
    reason TEXT NOT NULL,
    status TEXT NOT NULL,
    binding_version TEXT NOT NULL,
    conversation_key TEXT NOT NULL,
    account_alias TEXT NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS approvals (
    approval_id TEXT PRIMARY KEY,
    draft_id TEXT NOT NULL,
    operator TEXT NOT NULL,
    expected_text_hash TEXT NOT NULL,
    binding_version TEXT NOT NULL,
    conversation_key TEXT NOT NULL,
    account_alias TEXT NOT NULL,
    approved_text TEXT NOT NULL,
    created_at TEXT NOT NULL,
    expires_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS send_attempts (
    attempt_id TEXT PRIMARY KEY,
    approval_id TEXT NOT NULL,
    draft_id TEXT NOT NULL,
    status TEXT NOT NULL,
    local_result TEXT,
    wecom_receiver TEXT,
    wechat_receiver TEXT,
    created_at TEXT NOT NULL,
    note TEXT
);
CREATE TABLE IF NOT EXISTS discovered_files (
    path TEXT PRIMARY KEY,
    kind TEXT NOT NULL,
    fingerprint TEXT NOT NULL,
    first_seen TEXT NOT NULL,
    last_seen TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS runtime (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS audit (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    at TEXT NOT NULL,
    kind TEXT NOT NULL,
    payload TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS baseline_keys (
    account_alias TEXT NOT NULL,
    source_shard TEXT NOT NULL,
    source_table TEXT NOT NULL,
    source_message_id INTEGER NOT NULL,
    source_time INTEGER,
    PRIMARY KEY (account_alias, source_shard, source_table, source_message_id)
);
"""


@dataclass(frozen=True)
class Checkpoint:
    account_alias: str
    source_shard: str
    source_table: str
    last_source_time: int | None
    last_message_id: int | None
    initialized: bool


@dataclass(frozen=True)
class DraftRecord:
    draft_id: str
    event_key: str
    action: str
    text: str | None
    text_hash: str | None
    evidence_keys: list[str]
    reason: str
    status: str
    binding_version: str
    conversation_key: str
    account_alias: str
    created_at: str
    updated_at: str


class Store:
    def __init__(self, path: str | Path, clock: Clock | None = None):
        self.path = Path(path)
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self.clock = clock or SystemClock()
        self._init()

    def connect(self) -> sqlite3.Connection:
        conn = sqlite3.connect(self.path)
        conn.row_factory = sqlite3.Row
        conn.execute("PRAGMA foreign_keys = ON")
        return conn

    def _init(self) -> None:
        with self.connect() as conn:
            conn.executescript(SCHEMA)
            self._migrate(conn)

    def _migrate(self, conn: sqlite3.Connection) -> None:
        approval_cols = {row[1] for row in conn.execute("PRAGMA table_info(approvals)")}
        if "consumed_at" not in approval_cols:
            conn.execute("ALTER TABLE approvals ADD COLUMN consumed_at TEXT")
        attempt_cols = {row[1] for row in conn.execute("PRAGMA table_info(send_attempts)")}
        if "submit_stage" not in attempt_cols:
            conn.execute("ALTER TABLE send_attempts ADD COLUMN submit_stage TEXT")
        if "sender_kind" not in attempt_cols:
            conn.execute("ALTER TABLE send_attempts ADD COLUMN sender_kind TEXT")
        if "receiver_kind" not in attempt_cols:
            conn.execute("ALTER TABLE send_attempts ADD COLUMN receiver_kind TEXT")

    def now(self) -> str:
        return isoformat(self.clock.now())

    def audit(self, kind: str, payload: dict[str, Any]) -> None:
        redacted = {key: value for key, value in payload.items() if "key" not in key.lower() or key in {"event_key", "evidence_keys", "text_hash"}}
        if "secret" in payload or "token" in payload or "credential" in payload:
            redacted = {k: v for k, v in redacted.items() if k not in {"secret", "token", "credential"}}
        with self.connect() as conn:
            conn.execute(
                "INSERT INTO audit(at, kind, payload) VALUES (?, ?, ?)",
                (self.now(), kind, json.dumps(redacted, ensure_ascii=False)),
            )

    def runtime_get(self, key: str, default: str | None = None) -> str | None:
        with self.connect() as conn:
            row = conn.execute("SELECT value FROM runtime WHERE key = ?", (key,)).fetchone()
        return row["value"] if row else default

    def runtime_set(self, key: str, value: str) -> None:
        with self.connect() as conn:
            conn.execute(
                "INSERT INTO runtime(key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value",
                (key, value),
            )

    def paused(self) -> bool:
        return self.runtime_get("paused", "0") == "1"

    def pause(self, reason: str) -> None:
        self.runtime_set("paused", "1")
        self.runtime_set("pause_reason", reason)
        self.audit("pause", {"reason": reason})

    def resume(self) -> None:
        if self.has_uncertain_send():
            raise HaltError(Halt("SENDING_UNCERTAIN", "cannot resume while a sending task is uncertain"))
        self.runtime_set("paused", "0")
        self.audit("resume", {})

    def halt_reason(self) -> str | None:
        return self.runtime_get("halt_reason")

    def set_halt(self, reason: str, message: str) -> None:
        self.runtime_set("halt_reason", reason)
        self.runtime_set("halt_message", message)
        self.pause(reason)

    def checkpoint(self, account: str, shard: str, table: str) -> Checkpoint | None:
        with self.connect() as conn:
            row = conn.execute(
                "SELECT * FROM checkpoints WHERE account_alias=? AND source_shard=? AND source_table=?",
                (account, shard, table),
            ).fetchone()
        if row is None:
            return None
        return Checkpoint(
            account_alias=row["account_alias"],
            source_shard=row["source_shard"],
            source_table=row["source_table"],
            last_source_time=row["last_source_time"],
            last_message_id=row["last_message_id"],
            initialized=bool(row["initialized"]),
        )

    def ingest(self, events: Iterable[Event], checkpoints: Iterable[Checkpoint]) -> list[Event]:
        accepted: list[Event] = []
        with self.connect() as conn:
            for event in events:
                exists = conn.execute("SELECT 1 FROM seen_keys WHERE event_key = ?", (event.event_key,)).fetchone()
                if exists:
                    event.is_replay = True
                    conn.execute(
                        "UPDATE events SET is_replay = 1 WHERE event_key = ?",
                        (event.event_key,),
                    )
                    self._audit_conn(conn, "replay", {"event_key": event.event_key})
                    continue
                conn.execute(
                    """INSERT INTO events(
                        event_key, schema_version, account_alias, conversation_key, source_shard,
                        source_table, source_message_id, sender_key, is_self, source_time,
                        observed_at, text, evidence_ref, identity_status, is_historical,
                        parse_status, is_replay, runtime_id, raw_json
                    ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                    (
                        event.event_key,
                        event.schema_version,
                        event.account_alias,
                        event.conversation_key,
                        event.source_shard,
                        event.source_table,
                        event.source_message_id,
                        event.sender_key,
                        event.is_self,
                        event.source_time,
                        event.observed_at,
                        event.text,
                        event.evidence_ref,
                        event.identity_status,
                        int(event.is_historical),
                        event.parse_status,
                        int(event.is_replay),
                        event.runtime_id,
                        json.dumps(event.to_dict(), ensure_ascii=False),
                    ),
                )
                conn.execute(
                    "INSERT INTO seen_keys(event_key, observed_at) VALUES (?, ?)",
                    (event.event_key, event.observed_at),
                )
                accepted.append(event)
            for item in checkpoints:
                conn.execute(
                    """INSERT INTO checkpoints(account_alias, source_shard, source_table, last_source_time, last_message_id, initialized)
                       VALUES (?,?,?,?,?,?)
                       ON CONFLICT(account_alias, source_shard, source_table) DO UPDATE SET
                         last_source_time=excluded.last_source_time,
                         last_message_id=excluded.last_message_id,
                         initialized=excluded.initialized""",
                    (
                        item.account_alias,
                        item.source_shard,
                        item.source_table,
                        item.last_source_time,
                        item.last_message_id,
                        int(item.initialized),
                    ),
                )
        return accepted

    def get_event(self, event_key: str) -> Event | None:
        with self.connect() as conn:
            row = conn.execute("SELECT raw_json FROM events WHERE event_key = ?", (event_key,)).fetchone()
        if row is None:
            return None
        data = json.loads(row["raw_json"])
        return Event.from_dict(data)

    def context(self, conversation_key: str, before_time: int | None, limit: int) -> list[Event]:
        sql = """SELECT raw_json FROM events
                 WHERE conversation_key = ? AND parse_status = 'ok' AND text IS NOT NULL
                   AND is_historical = 0 AND is_replay = 0"""
        params: list[Any] = [conversation_key]
        if before_time is not None:
            sql += " AND (source_time IS NULL OR source_time <= ?)"
            params.append(before_time)
        sql += " ORDER BY source_time ASC, source_shard ASC, source_table ASC, source_message_id ASC"
        with self.connect() as conn:
            rows = conn.execute(sql, params).fetchall()
        events = [Event.from_dict(json.loads(row["raw_json"])) for row in rows]
        return events[-limit:]

    def record_file(self, path: str, kind: str, fingerprint: str) -> bool:
        """Return True if this fingerprint is new or changed."""
        now = self.now()
        with self.connect() as conn:
            row = conn.execute("SELECT fingerprint FROM discovered_files WHERE path = ?", (path,)).fetchone()
            if row is None:
                conn.execute(
                    "INSERT INTO discovered_files(path, kind, fingerprint, first_seen, last_seen) VALUES (?,?,?,?,?)",
                    (path, kind, fingerprint, now, now),
                )
                return True
            changed = row["fingerprint"] != fingerprint
            conn.execute(
                "UPDATE discovered_files SET fingerprint=?, last_seen=?, kind=? WHERE path=?",
                (fingerprint, now, kind, path),
            )
            return changed

    def create_draft(
        self,
        event: Event,
        action: str,
        text: str | None,
        evidence_keys: list[str],
        reason: str,
        binding_version: str,
    ) -> DraftRecord | None:
        if action == "ignore":
            return None
        existing = self.draft_for_event(event.event_key)
        if existing is not None:
            return existing
        draft_id = f"draft-{uuid4().hex[:12]}"
        text_hash = sha256_text(text) if text else None
        status = "draft" if action == "draft" else "needs_review"
        now = self.now()
        record = DraftRecord(
            draft_id=draft_id,
            event_key=event.event_key,
            action=action,
            text=text,
            text_hash=text_hash,
            evidence_keys=list(evidence_keys),
            reason=reason,
            status=status,
            binding_version=binding_version,
            conversation_key=event.conversation_key,
            account_alias=event.account_alias,
            created_at=now,
            updated_at=now,
        )
        try:
            with self.connect() as conn:
                conn.execute(
                    """INSERT INTO drafts(draft_id, event_key, action, text, text_hash, evidence_keys, reason, status,
                       binding_version, conversation_key, account_alias, created_at, updated_at)
                       VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                    (
                        record.draft_id,
                        record.event_key,
                        record.action,
                        record.text,
                        record.text_hash,
                        json.dumps(record.evidence_keys, ensure_ascii=False),
                        record.reason,
                        record.status,
                        record.binding_version,
                        record.conversation_key,
                        record.account_alias,
                        record.created_at,
                        record.updated_at,
                    ),
                )
        except sqlite3.IntegrityError:
            return self.draft_for_event(event.event_key)
        self.audit("draft_created", {"draft_id": draft_id, "event_key": event.event_key, "action": action})
        return record

    def draft_for_event(self, event_key: str) -> DraftRecord | None:
        with self.connect() as conn:
            row = conn.execute("SELECT * FROM drafts WHERE event_key = ?", (event_key,)).fetchone()
        return self._draft(row) if row else None

    def get_draft(self, draft_id: str) -> DraftRecord | None:
        with self.connect() as conn:
            row = conn.execute("SELECT * FROM drafts WHERE draft_id = ?", (draft_id,)).fetchone()
        return self._draft(row) if row else None

    def list_drafts(self, statuses: Iterable[str] | None = None) -> list[DraftRecord]:
        sql = "SELECT * FROM drafts"
        params: list[Any] = []
        values = list(statuses or ())
        if values:
            sql += " WHERE status IN (%s)" % ",".join("?" for _ in values)
            params.extend(values)
        sql += " ORDER BY created_at ASC"
        with self.connect() as conn:
            rows = conn.execute(sql, params).fetchall()
        return [self._draft(row) for row in rows]

    def save_baseline_keys(
        self,
        account: str,
        shard: str,
        table: str,
        ids: Iterable[tuple[int | None, int | None]],
    ) -> None:
        with self.connect() as conn:
            for message_id, source_time in ids:
                if message_id is None:
                    continue
                conn.execute(
                    """INSERT OR IGNORE INTO baseline_keys(
                        account_alias, source_shard, source_table, source_message_id, source_time
                    ) VALUES (?,?,?,?,?)""",
                    (account, shard, table, int(message_id), source_time),
                )

    def baseline_message_ids(self, account: str, shard: str, table: str) -> set[int]:
        with self.connect() as conn:
            rows = conn.execute(
                """SELECT source_message_id FROM baseline_keys
                   WHERE account_alias=? AND source_shard=? AND source_table=?""",
                (account, shard, table),
            ).fetchall()
        return {int(row["source_message_id"]) for row in rows}

    def bind_namespace(self, namespace: str) -> None:
        existing = self.runtime_get("namespace")
        if existing is None:
            self.runtime_set("namespace", namespace)
            return
        if existing != namespace:
            raise HaltError(
                Halt(
                    "STATE_NAMESPACE",
                    "refusing to reuse this state database across synthetic and live namespaces",
                    {"existing": existing, "requested": namespace},
                )
            )

    def occupy_approved_for_send(self, draft_id: str, approval_id: str) -> None:
        now = self.now()
        conn = sqlite3.connect(self.path, isolation_level="IMMEDIATE")
        conn.row_factory = sqlite3.Row
        try:
            if conn.execute("SELECT 1 FROM drafts WHERE status = 'uncertain' LIMIT 1").fetchone():
                raise HaltError(Halt("SENDING_UNCERTAIN", "an earlier send is uncertain; do not retry"))
            if conn.execute("SELECT 1 FROM drafts WHERE status = 'sending' LIMIT 1").fetchone():
                raise HaltError(Halt("SENDING_UNCERTAIN", "another send is in flight"))
            approval = conn.execute("SELECT * FROM approvals WHERE approval_id = ?", (approval_id,)).fetchone()
            if approval is None:
                raise HaltError(Halt("REVIEW_MISSING", "approval not found"))
            keys = approval.keys()
            consumed = approval["consumed_at"] if "consumed_at" in keys else None
            if consumed:
                raise HaltError(Halt("REVIEW_STATE", "approval already consumed"))
            cursor = conn.execute(
                "UPDATE drafts SET status=?, updated_at=? WHERE draft_id=? AND status='approved'",
                ("sending", now, draft_id),
            )
            if cursor.rowcount != 1:
                raise HaltError(Halt("REVIEW_STATE", "task is not an unconsumed approved draft"))
            consumed_cursor = conn.execute(
                "UPDATE approvals SET consumed_at=? WHERE approval_id=? AND IFNULL(consumed_at,'') = ''",
                (now, approval_id),
            )
            if consumed_cursor.rowcount != 1:
                raise HaltError(Halt("REVIEW_STATE", "approval consume raced"))
            conn.commit()
        except Exception:
            conn.rollback()
            raise
        finally:
            conn.close()
        self.audit("occupy_send", {"draft_id": draft_id, "approval_id": approval_id})

    def set_draft_status(self, draft_id: str, status: str, extra: dict[str, Any] | None = None) -> None:
        with self.connect() as conn:
            conn.execute(
                "UPDATE drafts SET status=?, updated_at=? WHERE draft_id=?",
                (status, self.now(), draft_id),
            )
        payload = {"draft_id": draft_id, "status": status}
        if extra:
            payload.update(extra)
        self.audit("draft_status", payload)

    def create_approval(
        self,
        draft: DraftRecord,
        operator: str,
        expected_text_hash: str,
        binding_version: str,
        ttl_seconds: int,
    ) -> str:
        approval_id = f"appr-{uuid4().hex[:12]}"
        created = self.clock.now()
        expires = created + timedelta(seconds=ttl_seconds)
        with self.connect() as conn:
            conn.execute(
                """INSERT INTO approvals(approval_id, draft_id, operator, expected_text_hash, binding_version,
                   conversation_key, account_alias, approved_text, created_at, expires_at)
                   VALUES (?,?,?,?,?,?,?,?,?,?)""",
                (
                    approval_id,
                    draft.draft_id,
                    operator,
                    expected_text_hash,
                    binding_version,
                    draft.conversation_key,
                    draft.account_alias,
                    draft.text or "",
                    isoformat(created),
                    isoformat(expires),
                ),
            )
            conn.execute(
                "UPDATE drafts SET status=?, updated_at=? WHERE draft_id=?",
                ("approved", isoformat(created), draft.draft_id),
            )
        self.audit("approved", {"approval_id": approval_id, "draft_id": draft.draft_id, "operator": operator})
        return approval_id

    def get_approval(self, approval_id: str) -> sqlite3.Row | None:
        with self.connect() as conn:
            return conn.execute("SELECT * FROM approvals WHERE approval_id = ?", (approval_id,)).fetchone()

    def in_flight(self) -> DraftRecord | None:
        with self.connect() as conn:
            row = conn.execute("SELECT * FROM drafts WHERE status = 'sending' LIMIT 1").fetchone()
        return self._draft(row) if row else None

    def has_uncertain_send(self) -> bool:
        with self.connect() as conn:
            row = conn.execute("SELECT 1 FROM drafts WHERE status = 'uncertain' LIMIT 1").fetchone()
        return row is not None

    def recover_sending(self) -> list[str]:
        recovered: list[str] = []
        with self.connect() as conn:
            rows = conn.execute("SELECT draft_id FROM drafts WHERE status = 'sending'").fetchall()
            for row in rows:
                conn.execute(
                    "UPDATE drafts SET status=?, updated_at=? WHERE draft_id=?",
                    ("uncertain", self.now(), row["draft_id"]),
                )
                recovered.append(row["draft_id"])
        if recovered:
            self.pause("SENDING_UNCERTAIN")
            self.audit("recover_sending", {"draft_ids": recovered})
        return recovered

    def record_attempt(
        self,
        approval_id: str,
        draft_id: str,
        status: str,
        local_result: str,
        note: str,
        wecom: str = "pending",
        wechat: str = "pending",
        submit_stage: str | None = None,
        sender_kind: str | None = None,
        receiver_kind: str | None = None,
    ) -> str:
        attempt_id = f"att-{uuid4().hex[:12]}"
        with self.connect() as conn:
            conn.execute(
                """INSERT INTO send_attempts(attempt_id, approval_id, draft_id, status, local_result, wecom_receiver,
                   wechat_receiver, created_at, note, submit_stage, sender_kind, receiver_kind)
                   VALUES (?,?,?,?,?,?,?,?,?,?,?,?)""",
                (
                    attempt_id,
                    approval_id,
                    draft_id,
                    status,
                    local_result,
                    wecom,
                    wechat,
                    self.now(),
                    note,
                    submit_stage,
                    sender_kind,
                    receiver_kind,
                ),
            )
        return attempt_id

    def update_attempt_receivers(self, draft_id: str, wecom: str, wechat: str, note: str) -> None:
        with self.connect() as conn:
            conn.execute(
                """UPDATE send_attempts SET wecom_receiver=?, wechat_receiver=?, note=?
                   WHERE draft_id=? AND created_at = (
                     SELECT MAX(created_at) FROM send_attempts WHERE draft_id=?
                   )""",
                (wecom, wechat, note, draft_id, draft_id),
            )

    def evidence_inventory(self, max_age_days: int = 7) -> list[dict[str, Any]]:
        cutoff = self.clock.now().timestamp() - max_age_days * 86400
        items = []
        with self.connect() as conn:
            for row in conn.execute("SELECT id, at, kind FROM audit"):
                items.append({"id": row["id"], "at": row["at"], "kind": row["kind"]})
        return items

    def _draft(self, row: sqlite3.Row) -> DraftRecord:
        return DraftRecord(
            draft_id=row["draft_id"],
            event_key=row["event_key"],
            action=row["action"],
            text=row["text"],
            text_hash=row["text_hash"],
            evidence_keys=json.loads(row["evidence_keys"]),
            reason=row["reason"],
            status=row["status"],
            binding_version=row["binding_version"],
            conversation_key=row["conversation_key"],
            account_alias=row["account_alias"],
            created_at=row["created_at"],
            updated_at=row["updated_at"],
        )

    def _audit_conn(self, conn: sqlite3.Connection, kind: str, payload: dict[str, Any]) -> None:
        conn.execute(
            "INSERT INTO audit(at, kind, payload) VALUES (?, ?, ?)",
            (self.now(), kind, json.dumps(payload, ensure_ascii=False)),
        )


def after_checkpoint(source_time: int | None, message_id: int | None, checkpoint: Checkpoint | None, lookback_seconds: int) -> tuple[bool, str]:
    if checkpoint is None or not checkpoint.initialized:
        return False, "baseline"
    if source_time is None or message_id is None:
        return False, "unkeyed"
    last_time = checkpoint.last_source_time or 0
    last_id = checkpoint.last_message_id or 0
    if source_time > last_time:
        return True, "newer_time"
    if source_time == last_time and int(message_id) > int(last_id):
        return True, "newer_numeric_id"
    if source_time >= last_time - lookback_seconds and (
        source_time > last_time or (source_time == last_time and int(message_id) > int(last_id)) or source_time < last_time
    ):
        if source_time == last_time and int(message_id) <= int(last_id):
            return False, "seen_or_older_id"
        if source_time < last_time:
            return True, "lookback"
    return False, "before_checkpoint"


def late_beyond_lookback(source_time: int | None, checkpoint: Checkpoint | None, lookback_seconds: int) -> bool:
    if checkpoint is None or not checkpoint.initialized or source_time is None:
        return False
    last_time = checkpoint.last_source_time or 0
    return source_time < last_time - lookback_seconds
