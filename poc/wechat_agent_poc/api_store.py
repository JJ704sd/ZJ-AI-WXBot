from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Any
from uuid import uuid4
import json
import sqlite3
import threading

from wechat_agent_poc.api_channel import ApiMessageV1
from wechat_agent_poc.api_config import isoformat
from wechat_agent_poc.clock import Clock, SystemClock
from wechat_agent_poc.hashes import sha256_text

USER_VERSION = 1
OLD_STORE_MARKERS = frozenset({"drafts", "approvals", "send_attempts"})

SCHEMA = """
CREATE TABLE IF NOT EXISTS bindings (
    binding_version TEXT PRIMARY KEY,
    account_key TEXT NOT NULL,
    conversation_key TEXT NOT NULL,
    fingerprint TEXT NOT NULL,
    payload TEXT NOT NULL,
    created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS runs (
    run_id TEXT PRIMARY KEY,
    spec_version TEXT NOT NULL,
    config_version TEXT NOT NULL,
    config_hash TEXT NOT NULL,
    stage TEXT NOT NULL,
    profile TEXT NOT NULL,
    account_key TEXT NOT NULL,
    conversation_key TEXT NOT NULL,
    binding_version TEXT NOT NULL,
    binding_fingerprint TEXT NOT NULL,
    session_epoch TEXT NOT NULL,
    started_at TEXT NOT NULL,
    expires_at TEXT,
    revoked_at TEXT,
    paused INTEGER NOT NULL DEFAULT 0,
    pause_reason TEXT,
    armed_at TEXT,
    model_budget INTEGER NOT NULL,
    model_used INTEGER NOT NULL DEFAULT 0,
    model_passive_budget INTEGER NOT NULL,
    model_active_budget INTEGER NOT NULL,
    model_passive_used INTEGER NOT NULL DEFAULT 0,
    model_active_used INTEGER NOT NULL DEFAULT 0,
    send_budget INTEGER NOT NULL,
    send_used INTEGER NOT NULL DEFAULT 0,
    send_passive_budget INTEGER NOT NULL,
    send_active_budget INTEGER NOT NULL,
    send_passive_used INTEGER NOT NULL DEFAULT 0,
    send_active_used INTEGER NOT NULL DEFAULT 0,
    permit_json TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS inbox (
    event_key TEXT PRIMARY KEY,
    native_message_id TEXT NOT NULL,
    provider TEXT NOT NULL,
    account_key TEXT NOT NULL,
    conversation_key TEXT NOT NULL,
    sender_key TEXT,
    body_hash TEXT NOT NULL,
    occurred_at TEXT NOT NULL,
    received_at TEXT NOT NULL,
    text TEXT,
    payload_json TEXT NOT NULL,
    claim_status TEXT NOT NULL,
    claimed_by TEXT,
    claimed_at TEXT,
    ignore_reason TEXT,
    created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS inbound_counts (
    kind TEXT PRIMARY KEY,
    count INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS tasks (
    task_id TEXT PRIMARY KEY,
    task_version TEXT NOT NULL,
    run_id TEXT NOT NULL,
    binding_version TEXT NOT NULL,
    target_keys TEXT NOT NULL,
    template_id TEXT NOT NULL,
    required_slots TEXT NOT NULL,
    schedule_kind TEXT NOT NULL,
    delay_seconds INTEGER NOT NULL,
    timezone TEXT NOT NULL,
    due_at TEXT,
    expiry_at TEXT,
    status TEXT NOT NULL,
    payload_json TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS sessions (
    session_pk TEXT PRIMARY KEY,
    run_id TEXT NOT NULL,
    task_id TEXT NOT NULL,
    account_key TEXT NOT NULL,
    conversation_key TEXT NOT NULL,
    target_key TEXT NOT NULL,
    version INTEGER NOT NULL DEFAULT 0,
    status TEXT NOT NULL,
    opened_at TEXT,
    expires_at TEXT,
    followup_used INTEGER NOT NULL DEFAULT 0,
    slots_json TEXT NOT NULL,
    context_json TEXT NOT NULL,
    last_send_at TEXT,
    closing_action_id TEXT
);
CREATE TABLE IF NOT EXISTS outbox (
    action_id TEXT PRIMARY KEY,
    run_id TEXT NOT NULL,
    event_key TEXT,
    session_pk TEXT,
    route TEXT NOT NULL,
    tool TEXT NOT NULL,
    account_key TEXT NOT NULL,
    conversation_key TEXT NOT NULL,
    mention_keys TEXT NOT NULL,
    text TEXT,
    status TEXT NOT NULL,
    binding_version TEXT NOT NULL,
    deadline_at TEXT,
    idempotency_key TEXT UNIQUE,
    provider_request_id TEXT,
    provider_message_id TEXT,
    write_calls INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS receipts (
    action_id TEXT PRIMARY KEY,
    receipt_status TEXT NOT NULL,
    wecom_confirmed INTEGER,
    wechat_confirmed INTEGER,
    note TEXT,
    recorded_by TEXT,
    recorded_at TEXT
);
CREATE TABLE IF NOT EXISTS audit (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    at TEXT NOT NULL,
    kind TEXT NOT NULL,
    payload TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS runtime_kv (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);
"""


class ApiStoreError(RuntimeError):
    pass


@dataclass(frozen=True)
class InboxInsert:
    status: str
    event_key: str
    conflict: bool = False
    duplicate: bool = False
    dropped: bool = False


class ApiStore:
    def __init__(self, path: str | Path, clock: Clock | None = None):
        self.path = Path(path)
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self.clock = clock or SystemClock()
        self._lock = threading.RLock()
        self.send_lock = threading.Lock()
        self._init()

    def _connect(self) -> sqlite3.Connection:
        conn = sqlite3.connect(self.path, check_same_thread=False)
        conn.row_factory = sqlite3.Row
        conn.execute("PRAGMA journal_mode=WAL")
        conn.execute("PRAGMA foreign_keys=ON")
        return conn

    def _init(self) -> None:
        with self._lock:
            conn = self._connect()
            try:
                self._reject_old_store(conn)
                version = conn.execute("PRAGMA user_version").fetchone()[0]
                if version not in (0, USER_VERSION):
                    raise ApiStoreError(f"unsupported api-agent user_version {version}")
                conn.executescript(SCHEMA)
                conn.execute(f"PRAGMA user_version={USER_VERSION}")
                conn.commit()
            finally:
                conn.close()

    def _reject_old_store(self, conn: sqlite3.Connection) -> None:
        names = {row[0] for row in conn.execute("SELECT name FROM sqlite_master WHERE type='table'")}
        if names & OLD_STORE_MARKERS and "inbox" not in names:
            raise ApiStoreError("refusing to open or migrate the old PoC state database")

    def transaction(self):
        return _Txn(self)

    def audit(self, kind: str, payload: dict[str, Any]) -> None:
        with self.transaction() as txn:
            txn.audit(kind, payload)

    def increment_count(self, kind: str, amount: int = 1) -> int:
        with self.transaction() as txn:
            return txn.increment_count(kind, amount)

    def get_count(self, kind: str) -> int:
        with self.transaction() as txn:
            return txn.get_count(kind)

    def insert_inbox(self, event: ApiMessageV1) -> InboxInsert:
        with self.transaction() as txn:
            return txn.insert_inbox(event)

    def claim_next(self, worker_id: str) -> ApiMessageV1 | None:
        with self.transaction() as txn:
            return txn.claim_next(worker_id)

    def mark_processed(self, event_key: str, *, ignore_reason: str | None = None) -> None:
        with self.transaction() as txn:
            txn.mark_processed(event_key, ignore_reason=ignore_reason)

    def get(self, sql: str, args: tuple[Any, ...] = ()) -> sqlite3.Row | None:
        with self._lock:
            conn = self._connect()
            try:
                return conn.execute(sql, args).fetchone()
            finally:
                conn.close()

    def query(self, sql: str, args: tuple[Any, ...] = ()) -> list[sqlite3.Row]:
        with self._lock:
            conn = self._connect()
            try:
                return list(conn.execute(sql, args).fetchall())
            finally:
                conn.close()

    def recover(self) -> dict[str, Any]:
        with self.transaction() as txn:
            return txn.recover()


class _Txn:
    def __init__(self, store: ApiStore):
        self.store = store
        self.conn: sqlite3.Connection | None = None

    def __enter__(self) -> _Txn:
        self.store._lock.acquire()
        self.conn = self.store._connect()
        self.conn.execute("BEGIN IMMEDIATE")
        return self

    def __exit__(self, exc_type, exc, tb) -> None:
        assert self.conn is not None
        try:
            if exc_type is None:
                self.conn.commit()
            else:
                self.conn.rollback()
        finally:
            self.conn.close()
            self.store._lock.release()

    @property
    def db(self) -> sqlite3.Connection:
        assert self.conn is not None
        return self.conn

    def now(self) -> str:
        return isoformat(self.store.clock.now())

    def audit(self, kind: str, payload: dict[str, Any]) -> None:
        self.db.execute(
            "INSERT INTO audit(at, kind, payload) VALUES (?,?,?)",
            (self.now(), kind, json.dumps(payload, ensure_ascii=False)),
        )

    def increment_count(self, kind: str, amount: int = 1) -> int:
        row = self.db.execute("SELECT count FROM inbound_counts WHERE kind=?", (kind,)).fetchone()
        current = int(row["count"]) if row else 0
        next_value = current + amount
        self.db.execute(
            "INSERT INTO inbound_counts(kind, count) VALUES (?,?) ON CONFLICT(kind) DO UPDATE SET count=excluded.count",
            (kind, next_value),
        )
        return next_value

    def get_count(self, kind: str) -> int:
        row = self.db.execute("SELECT count FROM inbound_counts WHERE kind=?", (kind,)).fetchone()
        return int(row["count"]) if row else 0

    def insert_inbox(self, event: ApiMessageV1) -> InboxInsert:
        body_hash = sha256_text(event.body_fingerprint())
        existing = self.db.execute("SELECT body_hash, claim_status FROM inbox WHERE event_key=?", (event.event_key,)).fetchone()
        if existing:
            if existing["body_hash"] != body_hash:
                self.db.execute(
                    "UPDATE inbox SET claim_status='conflict', ignore_reason='event_conflict' WHERE event_key=?",
                    (event.event_key,),
                )
                self.audit("event_conflict", {"event_key": event.event_key})
                return InboxInsert("conflict", event.event_key, conflict=True)
            return InboxInsert("duplicate", event.event_key, duplicate=True)
        payload = json.dumps(event.to_dict(), ensure_ascii=False)
        self.db.execute(
            """INSERT INTO inbox(event_key, native_message_id, provider, account_key, conversation_key, sender_key,
               body_hash, occurred_at, received_at, text, payload_json, claim_status, created_at)
               VALUES (?,?,?,?,?,?,?,?,?,?,?,'queued',?)""",
            (
                event.event_key,
                event.native_message_id,
                event.provider,
                event.account_key,
                event.conversation_key,
                event.sender_key,
                body_hash,
                event.occurred_at,
                event.received_at,
                event.text,
                payload,
                self.now(),
            ),
        )
        return InboxInsert("queued", event.event_key)

    def claim_next(self, worker_id: str) -> ApiMessageV1 | None:
        row = self.db.execute(
            "SELECT * FROM inbox WHERE claim_status='queued' ORDER BY received_at, event_key LIMIT 1"
        ).fetchone()
        if row is None:
            return None
        now = self.now()
        self.db.execute(
            "UPDATE inbox SET claim_status='claimed', claimed_by=?, claimed_at=? WHERE event_key=? AND claim_status='queued'",
            (worker_id, now, row["event_key"]),
        )
        if self.db.execute("SELECT changes()").fetchone()[0] != 1:
            return None
        payload = json.loads(row["payload_json"])
        payload["mention_keys"] = tuple(payload.get("mention_keys") or ())
        return ApiMessageV1(**payload)

    def mark_processed(self, event_key: str, *, ignore_reason: str | None = None) -> None:
        status = "ignored" if ignore_reason else "processed"
        self.db.execute(
            "UPDATE inbox SET claim_status=?, ignore_reason=? WHERE event_key=?",
            (status, ignore_reason, event_key),
        )

    def upsert_binding(self, binding_version: str, account_key: str, conversation_key: str, payload: dict[str, Any]) -> str:
        fingerprint = sha256_text(json.dumps(payload, sort_keys=True, ensure_ascii=False))
        self.db.execute(
            """INSERT INTO bindings(binding_version, account_key, conversation_key, fingerprint, payload, created_at)
               VALUES (?,?,?,?,?,?)
               ON CONFLICT(binding_version) DO UPDATE SET fingerprint=excluded.fingerprint, payload=excluded.payload""",
            (
                binding_version,
                account_key,
                conversation_key,
                fingerprint,
                json.dumps(payload, ensure_ascii=False),
                self.now(),
            ),
        )
        return fingerprint

    def create_run(self, permit: dict[str, Any]) -> None:
        self.db.execute(
            """INSERT INTO runs(run_id, spec_version, config_version, config_hash, stage, profile, account_key,
               conversation_key, binding_version, binding_fingerprint, session_epoch, started_at, expires_at,
               paused, pause_reason, armed_at, model_budget, model_used, model_passive_budget, model_active_budget,
               send_budget, send_used, send_passive_budget, send_active_budget, permit_json)
               VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
            (
                permit["run_id"],
                permit["spec_version"],
                permit["config_version"],
                permit["config_hash"],
                permit["stage"],
                permit["profile"],
                permit["account_key"],
                permit["conversation_key"],
                permit["binding_version"],
                permit["binding_fingerprint"],
                permit["session_epoch"],
                permit["started_at"],
                permit.get("expires_at"),
                0,
                None,
                permit.get("armed_at"),
                permit["model_budget"],
                0,
                permit["model_passive_budget"],
                permit["model_active_budget"],
                permit["send_budget"],
                0,
                permit["send_passive_budget"],
                permit["send_active_budget"],
                json.dumps(permit, ensure_ascii=False),
            ),
        )

    def current_run(self) -> sqlite3.Row | None:
        return self.db.execute(
            "SELECT * FROM runs WHERE revoked_at IS NULL ORDER BY started_at DESC LIMIT 1"
        ).fetchone()

    def run_by_id(self, run_id: str) -> sqlite3.Row | None:
        return self.db.execute("SELECT * FROM runs WHERE run_id=?", (run_id,)).fetchone()

    def pause_run(self, run_id: str, reason: str) -> None:
        self.db.execute("UPDATE runs SET paused=1, pause_reason=? WHERE run_id=?", (reason, run_id))
        self.audit("pause", {"run_id": run_id, "reason": reason})

    def revoke_run(self, run_id: str, reason: str) -> None:
        self.db.execute(
            "UPDATE runs SET revoked_at=?, paused=1, pause_reason=? WHERE run_id=? AND revoked_at IS NULL",
            (self.now(), reason, run_id),
        )
        self.audit("revoke", {"run_id": run_id, "reason": reason})

    def occupy_model(self, run_id: str, route: str) -> bool:
        row = self.db.execute("SELECT * FROM runs WHERE run_id=?", (run_id,)).fetchone()
        if row is None or row["paused"] or row["revoked_at"]:
            return False
        if int(row["model_used"]) >= int(row["model_budget"]):
            return False
        if route == "passive" and int(row["model_passive_used"]) >= int(row["model_passive_budget"]):
            return False
        if route == "active" and int(row["model_active_used"]) >= int(row["model_active_budget"]):
            return False
        self.db.execute(
            "UPDATE runs SET model_used=model_used+1, model_passive_used=model_passive_used+?, model_active_used=model_active_used+? WHERE run_id=?",
            (1 if route == "passive" else 0, 1 if route == "active" else 0, run_id),
        )
        return True

    def reserve_outbox(self, record: dict[str, Any]) -> str | None:
        run = self.db.execute("SELECT * FROM runs WHERE run_id=?", (record["run_id"],)).fetchone()
        if run is None or run["paused"] or run["revoked_at"]:
            return None
        route = record["route"]
        if int(run["send_used"]) >= int(run["send_budget"]):
            return None
        if route == "passive" and int(run["send_passive_used"]) >= int(run["send_passive_budget"]):
            return None
        if route == "active" and int(run["send_active_used"]) >= int(run["send_active_budget"]):
            return None
        action_id = record.get("action_id") or uuid4().hex
        idem = record.get("idempotency_key") or action_id
        existing = self.db.execute("SELECT action_id, status FROM outbox WHERE idempotency_key=?", (idem,)).fetchone()
        if existing:
            return None if existing["status"] != "reserved" else existing["action_id"]
        now = self.now()
        self.db.execute(
            """INSERT INTO outbox(action_id, run_id, event_key, session_pk, route, tool, account_key, conversation_key,
               mention_keys, text, status, binding_version, deadline_at, idempotency_key, created_at, updated_at)
               VALUES (?,?,?,?,?,?,?,?,?,?,'reserved',?,?,?,?,?)""",
            (
                action_id,
                record["run_id"],
                record.get("event_key"),
                record.get("session_pk"),
                route,
                record["tool"],
                record["account_key"],
                record["conversation_key"],
                json.dumps(list(record.get("mention_keys") or ()), ensure_ascii=False),
                record.get("text"),
                record["binding_version"],
                record.get("deadline_at"),
                idem,
                now,
                now,
            ),
        )
        self.db.execute(
            "UPDATE runs SET send_used=send_used+1, send_passive_used=send_passive_used+?, send_active_used=send_active_used+? WHERE run_id=?",
            (1 if route == "passive" else 0, 1 if route == "active" else 0, record["run_id"]),
        )
        self.db.execute(
            "INSERT INTO receipts(action_id, receipt_status) VALUES (?, 'unverified')",
            (action_id,),
        )
        return action_id

    def mark_submitting(self, action_id: str) -> bool:
        self.db.execute(
            "UPDATE outbox SET status='submitting', updated_at=? WHERE action_id=? AND status='reserved'",
            (self.now(), action_id),
        )
        return self.db.execute("SELECT changes()").fetchone()[0] == 1

    def finish_outbox(self, action_id: str, status: str, *, reason: str, provider_request_id: str | None = None,
                      provider_message_id: str | None = None, write_calls: int = 1) -> None:
        self.db.execute(
            """UPDATE outbox SET status=?, provider_request_id=?, provider_message_id=?, write_calls=?, updated_at=?
               WHERE action_id=?""",
            (status, provider_request_id, provider_message_id, write_calls, self.now(), action_id),
        )
        self.audit("submit_result", {"action_id": action_id, "status": status, "reason": reason})

    def cancel_reserved(self, run_id: str, reason: str) -> int:
        rows = self.db.execute(
            "SELECT action_id FROM outbox WHERE run_id=? AND status IN ('reserved', 'queued')",
            (run_id,),
        ).fetchall()
        self.db.execute(
            "UPDATE outbox SET status='cancelled', updated_at=? WHERE run_id=? AND status IN ('reserved','queued')",
            (self.now(), run_id),
        )
        self.audit("cancel_reserved", {"run_id": run_id, "reason": reason, "count": len(rows)})
        return len(rows)

    def recover(self) -> dict[str, Any]:
        submitting = list(self.db.execute("SELECT action_id, run_id FROM outbox WHERE status='submitting'"))
        reserved = list(self.db.execute("SELECT action_id, run_id FROM outbox WHERE status IN ('reserved','queued')"))
        paused_runs = set()
        for row in submitting:
            self.finish_outbox(row["action_id"], "unknown", reason="crash_window")
            self.pause_run(row["run_id"], "unknown_submit")
            paused_runs.add(row["run_id"])
        cancelled = 0
        for row in reserved:
            self.db.execute(
                "UPDATE outbox SET status='cancelled', updated_at=? WHERE action_id=?",
                (self.now(), row["action_id"]),
            )
            cancelled += 1
        if reserved:
            self.audit("recover_cancel_unsent", {"count": cancelled})
        return {
            "unknown_from_submitting": [row["action_id"] for row in submitting],
            "cancelled_unsent": cancelled,
            "paused_runs": sorted(paused_runs),
        }

    def create_task(self, record: dict[str, Any]) -> None:
        self.db.execute(
            """INSERT INTO tasks(task_id, task_version, run_id, binding_version, target_keys, template_id, required_slots,
               schedule_kind, delay_seconds, timezone, due_at, expiry_at, status, payload_json)
               VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
            (
                record["task_id"],
                record["task_version"],
                record["run_id"],
                record["binding_version"],
                json.dumps(list(record["target_keys"]), ensure_ascii=False),
                record["template_id"],
                json.dumps(list(record["required_slots"]), ensure_ascii=False),
                record["schedule_kind"],
                record["delay_seconds"],
                record["timezone"],
                record.get("due_at"),
                record.get("expiry_at"),
                record["status"],
                json.dumps(record, ensure_ascii=False),
            ),
        )

    def upsert_session(self, record: dict[str, Any]) -> None:
        self.db.execute(
            """INSERT INTO sessions(session_pk, run_id, task_id, account_key, conversation_key, target_key, version,
               status, opened_at, expires_at, followup_used, slots_json, context_json, last_send_at, closing_action_id)
               VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
               ON CONFLICT(session_pk) DO UPDATE SET version=excluded.version, status=excluded.status,
               opened_at=excluded.opened_at, expires_at=excluded.expires_at, followup_used=excluded.followup_used,
               slots_json=excluded.slots_json, context_json=excluded.context_json, last_send_at=excluded.last_send_at,
               closing_action_id=excluded.closing_action_id""",
            (
                record["session_pk"],
                record["run_id"],
                record["task_id"],
                record["account_key"],
                record["conversation_key"],
                record["target_key"],
                record.get("version", 0),
                record["status"],
                record.get("opened_at"),
                record.get("expires_at"),
                record.get("followup_used", 0),
                json.dumps(record.get("slots") or {}, ensure_ascii=False),
                json.dumps(record.get("context") or [], ensure_ascii=False),
                record.get("last_send_at"),
                record.get("closing_action_id"),
            ),
        )

    def session_row(self, session_pk: str) -> sqlite3.Row | None:
        return self.db.execute("SELECT * FROM sessions WHERE session_pk=?", (session_pk,)).fetchone()

    def active_session_for(self, run_id: str, sender_key: str) -> sqlite3.Row | None:
        return self.db.execute(
            """SELECT * FROM sessions WHERE run_id=? AND target_key=? AND status IN
               ('scheduled','initial_submitting','awaiting_reply','closing_pending')""",
            (run_id, sender_key),
        ).fetchone()

    def bump_session_version(self, session_pk: str) -> int:
        row = self.session_row(session_pk)
        if row is None:
            return 0
        version = int(row["version"]) + 1
        self.db.execute("UPDATE sessions SET version=? WHERE session_pk=?", (version, session_pk))
        return version

    def set_kv(self, key: str, value: str) -> None:
        self.db.execute(
            "INSERT INTO runtime_kv(key, value) VALUES (?,?) ON CONFLICT(key) DO UPDATE SET value=excluded.value",
            (key, value),
        )

    def get_kv(self, key: str) -> str | None:
        row = self.db.execute("SELECT value FROM runtime_kv WHERE key=?", (key,)).fetchone()
        return None if row is None else str(row["value"])
