from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any
from uuid import uuid4
import hashlib
import json
import shutil
import sqlite3
import threading

from wechat_agent_poc.api_config import isoformat
from wechat_agent_poc.clock import Clock, SystemClock
from wechat_agent_poc.config import ConfigError

USER_VERSION = 2
FORBIDDEN_TABLES = frozenset({"drafts", "approvals", "send_attempts", "outbox", "tasks", "inbox"})
RUN_V2_COLUMNS = (
    ("pid", "INTEGER"),
    ("owner_nonce", "TEXT"),
    ("heartbeat_at", "TEXT"),
    ("process_created_at", "TEXT"),
    ("listen_host", "TEXT"),
    ("listen_port", "INTEGER"),
    ("schema_version", "INTEGER NOT NULL DEFAULT 2"),
)

SCHEMA = """
CREATE TABLE IF NOT EXISTS observe_runs (
    run_id TEXT PRIMARY KEY,
    observe_epoch TEXT NOT NULL UNIQUE,
    status TEXT NOT NULL,
    account_key TEXT NOT NULL,
    conversation_key TEXT NOT NULL,
    binding_version TEXT NOT NULL,
    app_id TEXT NOT NULL,
    source_level TEXT NOT NULL,
    authorization_ref TEXT NOT NULL,
    started_at TEXT NOT NULL,
    expires_at TEXT NOT NULL,
    stopped_at TEXT,
    stop_reason TEXT,
    permit_generation INTEGER NOT NULL DEFAULT 1,
    max_samples INTEGER NOT NULL,
    max_body_bytes INTEGER NOT NULL,
    sample_count INTEGER NOT NULL DEFAULT 0,
    body_bytes INTEGER NOT NULL DEFAULT 0,
    pid INTEGER,
    owner_nonce TEXT,
    heartbeat_at TEXT,
    process_created_at TEXT,
    listen_host TEXT,
    listen_port INTEGER,
    schema_version INTEGER NOT NULL DEFAULT 2
);
CREATE TABLE IF NOT EXISTS bindings (
    binding_version TEXT PRIMARY KEY,
    account_key TEXT NOT NULL,
    conversation_key TEXT NOT NULL,
    payload TEXT NOT NULL,
    created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS samples (
    sample_id TEXT PRIMARY KEY,
    run_id TEXT NOT NULL,
    observe_epoch TEXT NOT NULL,
    sample_key TEXT NOT NULL,
    native_message_id TEXT,
    body_hash TEXT NOT NULL,
    account_key TEXT,
    conversation_key TEXT,
    sender_key TEXT,
    identity_status TEXT NOT NULL,
    is_self TEXT NOT NULL,
    kind TEXT NOT NULL,
    mention_status TEXT NOT NULL,
    history_status TEXT NOT NULL,
    parse_status TEXT NOT NULL,
    source_level TEXT NOT NULL,
    delivery_count INTEGER NOT NULL DEFAULT 1,
    restricted_raw TEXT,
    text TEXT,
    occurred_at TEXT,
    received_at TEXT NOT NULL,
    created_at TEXT NOT NULL,
    UNIQUE(run_id, sample_key)
);
CREATE TABLE IF NOT EXISTS sample_conflicts (
    conflict_id TEXT PRIMARY KEY,
    run_id TEXT NOT NULL,
    sample_key TEXT NOT NULL,
    body_hash TEXT NOT NULL,
    created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS counters (
    name TEXT PRIMARY KEY,
    value INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS capability_evidence (
    case_id TEXT PRIMARY KEY,
    capability TEXT NOT NULL,
    status TEXT NOT NULL,
    note TEXT NOT NULL,
    created_at TEXT NOT NULL
);
"""


@dataclass(frozen=True)
class PersistResult:
    action: str
    http_status: int
    sample_id: str | None = None
    paused: bool = False
    reason: str = ""


class ObserveStore:
    def __init__(self, path: str | Path, clock: Clock | None = None):
        self.path = Path(path)
        self.clock = clock or SystemClock()
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self._lock = threading.Lock()
        self._db = sqlite3.connect(str(self.path), check_same_thread=False, isolation_level=None)
        self._db.row_factory = sqlite3.Row
        self._db.execute("PRAGMA journal_mode=WAL")
        self._db.execute("PRAGMA synchronous=FULL")
        self._db.execute("PRAGMA busy_timeout=800")
        self._ensure_schema()

    def close(self) -> None:
        with self._lock:
            self._db.close()

    def _ensure_schema(self) -> None:
        version = int(self._db.execute("PRAGMA user_version").fetchone()[0])
        tables = {row[0] for row in self._db.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()}
        if tables & FORBIDDEN_TABLES:
            raise ConfigError("observer sqlite collides with an agent or old PoC store")
        if version not in {0, 1, USER_VERSION}:
            raise ConfigError(f"unsupported observer user_version {version}")
        if version == 1:
            backup = self.path.with_name(self.path.name + ".v1.bak")
            if not backup.exists():
                shutil.copy2(self.path, backup)
            existing = {row[1] for row in self._db.execute("PRAGMA table_info(observe_runs)").fetchall()}
            for name, decl in RUN_V2_COLUMNS:
                if name not in existing:
                    self._db.execute(f"ALTER TABLE observe_runs ADD COLUMN {name} {decl}")
        self._db.executescript(SCHEMA)
        self._db.execute(f"PRAGMA user_version={USER_VERSION}")

    def create_run(
        self,
        *,
        account_key: str,
        conversation_key: str,
        binding_version: str,
        app_id: str,
        source_level: str,
        authorization_ref: str,
        max_seconds: int,
        max_samples: int,
        max_body_bytes: int,
        status: str = "observing",
    ) -> dict[str, Any]:
        with self._lock:
            active = self._db.execute(
                "SELECT run_id FROM observe_runs WHERE stopped_at IS NULL AND status NOT IN ('stopped','failed')"
            ).fetchone()
            if active:
                raise ConfigError("an observer run is already active; multi-session start is refused")
            now = self.clock.now()
            run_id = uuid4().hex
            epoch = uuid4().hex
            expires = datetime.fromtimestamp(now.timestamp() + max_seconds, tz=timezone.utc)
            self._db.execute(
                """INSERT INTO observe_runs(
                    run_id, observe_epoch, status, account_key, conversation_key, binding_version, app_id,
                    source_level, authorization_ref, started_at, expires_at, permit_generation,
                    max_samples, max_body_bytes, sample_count, body_bytes, schema_version
                ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,0,0,?)""",
                (
                    run_id,
                    epoch,
                    status,
                    account_key,
                    conversation_key,
                    binding_version,
                    app_id,
                    source_level,
                    authorization_ref,
                    isoformat(now),
                    isoformat(expires),
                    1,
                    max_samples,
                    max_body_bytes,
                    USER_VERSION,
                ),
            )
            self._db.execute(
                "INSERT OR REPLACE INTO bindings(binding_version, account_key, conversation_key, payload, created_at) VALUES (?,?,?,?,?)",
                (
                    binding_version,
                    account_key,
                    conversation_key,
                    json.dumps({"account_key": account_key, "conversation_key": conversation_key}, ensure_ascii=False),
                    isoformat(now),
                ),
            )
            return self._current_run_unlocked() or {}

    def current_run(self) -> dict[str, Any] | None:
        with self._lock:
            return self._current_run_unlocked()

    def _current_run_unlocked(self) -> dict[str, Any] | None:
        row = self._db.execute(
            "SELECT * FROM observe_runs ORDER BY started_at DESC LIMIT 1"
        ).fetchone()
        return dict(row) if row else None

    def set_status(self, run_id: str, status: str, *, reason: str = "") -> None:
        with self._lock:
            self._db.execute(
                "UPDATE observe_runs SET status=?, stop_reason=COALESCE(NULLIF(?, ''), stop_reason) WHERE run_id=?",
                (status, reason, run_id),
            )

    def stop(self, reason: str) -> dict[str, Any]:
        with self._lock:
            now = isoformat(self.clock.now())
            row = self._current_run_unlocked()
            if row is None:
                return {"stopped": False, "reason": "no_run"}
            self._db.execute(
                """UPDATE observe_runs
                   SET status='stopped', stopped_at=?, stop_reason=?, permit_generation=permit_generation+1
                   WHERE run_id=?""",
                (now, reason, row["run_id"]),
            )
            return {"stopped": True, "run_id": row["run_id"], "reason": reason, "stopped_at": now}

    def interrupt_unfinished(self, reason: str = "process_interrupted") -> int:
        with self._lock:
            now = isoformat(self.clock.now())
            cur = self._db.execute(
                """UPDATE observe_runs
                   SET status='failed', stopped_at=?, stop_reason=?, permit_generation=permit_generation+1
                   WHERE stopped_at IS NULL AND status NOT IN ('stopped','failed')""",
                (now, reason),
            )
            return int(cur.rowcount or 0)

    def request_stop(self, reason: str, *, run_id: str | None = None, owner_nonce: str | None = None) -> dict[str, Any]:
        with self._lock:
            row = self._current_run_unlocked()
            if row is None:
                return {"stop_requested": False, "reason": "no_run"}
            if run_id and row["run_id"] != run_id:
                return {"stop_requested": False, "reason": "run_mismatch"}
            if owner_nonce and row["owner_nonce"] and row["owner_nonce"] != owner_nonce:
                return {"stop_requested": False, "reason": "owner_mismatch"}
            if row["stopped_at"] or row["status"] in {"stopped", "failed"}:
                return {"stop_requested": False, "stopped_confirmed": True, "run_id": row["run_id"], "reason": "already_stopped"}
            now = isoformat(self.clock.now())
            self._db.execute(
                """UPDATE observe_runs
                   SET status='stopping', stop_reason=?, permit_generation=permit_generation+1
                   WHERE run_id=?""",
                (reason, row["run_id"]),
            )
            return {"stop_requested": True, "stopped_confirmed": False, "run_id": row["run_id"], "reason": reason, "requested_at": now}

    def attach_process(
        self,
        run_id: str,
        *,
        pid: int,
        owner_nonce: str,
        listen_host: str,
        listen_port: int,
    ) -> None:
        with self._lock:
            now = isoformat(self.clock.now())
            self._db.execute(
                """UPDATE observe_runs
                   SET pid=?, owner_nonce=?, listen_host=?, listen_port=?,
                       heartbeat_at=?, process_created_at=?, status='serving'
                   WHERE run_id=? AND stopped_at IS NULL""",
                (pid, owner_nonce, listen_host, listen_port, now, now, run_id),
            )

    def heartbeat(self, run_id: str) -> None:
        with self._lock:
            self._db.execute(
                "UPDATE observe_runs SET heartbeat_at=? WHERE run_id=? AND stopped_at IS NULL AND status='serving'",
                (isoformat(self.clock.now()), run_id),
            )

    def fail_run(self, run_id: str, reason: str) -> None:
        with self._lock:
            self._db.execute(
                """UPDATE observe_runs
                   SET status='failed', stopped_at=?, stop_reason=?, permit_generation=permit_generation+1
                   WHERE run_id=?""",
                (isoformat(self.clock.now()), reason, run_id),
            )

    def bump_counter(self, name: str, delta: int = 1) -> None:
        with self._lock:
            self._bump_unlocked(name, delta)

    def _bump_unlocked(self, name: str, delta: int = 1) -> None:
        self._db.execute(
            "INSERT INTO counters(name, value) VALUES(?, ?) ON CONFLICT(name) DO UPDATE SET value=value+excluded.value",
            (name, delta),
        )

    def counters(self) -> dict[str, int]:
        with self._lock:
            return {row["name"]: int(row["value"]) for row in self._db.execute("SELECT name, value FROM counters")}

    def persist_sample(self, *, run_id: str, expected_epoch: str, expected_generation: int, record: dict[str, Any]) -> PersistResult:
        with self._lock:
            run = self._db.execute("SELECT * FROM observe_runs WHERE run_id=?", (run_id,)).fetchone()
            if run is None:
                self._bump_unlocked("persist_rejected_no_run")
                return PersistResult("rejected", 503, reason="no_run")
            if run["stopped_at"] or run["status"] in {"stopped", "stopping", "failed", "probing"}:
                self._bump_unlocked("persist_rejected_stopped")
                return PersistResult("rejected", 503, reason="stopped")
            if run["observe_epoch"] != expected_epoch or int(run["permit_generation"]) != expected_generation:
                self._bump_unlocked("persist_rejected_epoch")
                return PersistResult("rejected", 503, reason="epoch_mismatch")
            expires = datetime.fromisoformat(str(run["expires_at"]).replace("Z", "+00:00"))
            if self.clock.now() >= expires:
                self._db.execute(
                    "UPDATE observe_runs SET status='stopped', stopped_at=?, stop_reason='expired' WHERE run_id=?",
                    (isoformat(self.clock.now()), run_id),
                )
                self._bump_unlocked("persist_rejected_expired")
                return PersistResult("rejected", 503, reason="expired")
            if int(run["sample_count"]) >= int(run["max_samples"]) or int(run["body_bytes"]) >= int(run["max_body_bytes"]):
                self._db.execute(
                    "UPDATE observe_runs SET status='stopped', stop_reason='capacity' WHERE run_id=?",
                    (run_id,),
                )
                self._bump_unlocked("capacity_exhausted")
                return PersistResult("rejected", 503, reason="capacity", paused=True)
            existing = self._db.execute(
                "SELECT sample_id, body_hash, delivery_count FROM samples WHERE run_id=? AND sample_key=?",
                (run_id, record["sample_key"]),
            ).fetchone()
            if existing:
                if existing["body_hash"] == record["body_hash"]:
                    self._db.execute(
                        "UPDATE samples SET delivery_count=delivery_count+1 WHERE sample_id=?",
                        (existing["sample_id"],),
                    )
                    self._bump_unlocked("duplicate_delivery")
                    return PersistResult("duplicate", 200, sample_id=existing["sample_id"])
                self._db.execute(
                    "INSERT INTO sample_conflicts(conflict_id, run_id, sample_key, body_hash, created_at) VALUES (?,?,?,?,?)",
                    (uuid4().hex, run_id, record["sample_key"], record["body_hash"], isoformat(self.clock.now())),
                )
                self._db.execute(
                    "UPDATE observe_runs SET status='paused', stop_reason='sample_conflict' WHERE run_id=?",
                    (run_id,),
                )
                self._bump_unlocked("sample_conflict")
                return PersistResult("conflict", 200, sample_id=existing["sample_id"], paused=True, reason="sample_conflict")
            sample_id = uuid4().hex
            raw = record.get("restricted_raw") or ""
            body_len = len(raw.encode("utf-8")) if raw else 0
            self._db.execute(
                """INSERT INTO samples(
                    sample_id, run_id, observe_epoch, sample_key, native_message_id, body_hash,
                    account_key, conversation_key, sender_key, identity_status, is_self, kind,
                    mention_status, history_status, parse_status, source_level, delivery_count,
                    restricted_raw, text, occurred_at, received_at, created_at
                ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?,?,?,?)""",
                (
                    sample_id,
                    run_id,
                    expected_epoch,
                    record["sample_key"],
                    record.get("native_message_id"),
                    record["body_hash"],
                    record.get("account_key"),
                    record.get("conversation_key"),
                    record.get("sender_key"),
                    record.get("identity_status") or "unknown",
                    record.get("is_self") or "unknown",
                    record.get("kind") or "other",
                    record.get("mention_status") or "unknown",
                    record.get("history_status") or "unknown",
                    record.get("parse_status") or "unknown",
                    record.get("source_level") or "none",
                    raw or None,
                    record.get("text"),
                    record.get("occurred_at"),
                    record["received_at"],
                    isoformat(self.clock.now()),
                ),
            )
            self._db.execute(
                "UPDATE observe_runs SET sample_count=sample_count+1, body_bytes=body_bytes+? WHERE run_id=?",
                (body_len, run_id),
            )
            self._bump_unlocked("samples_stored")
            return PersistResult("stored", 200, sample_id=sample_id)

    def sample_count(self) -> int:
        with self._lock:
            row = self._db.execute("SELECT COUNT(*) AS n FROM samples").fetchone()
            return int(row["n"])

    def samples(self) -> list[dict[str, Any]]:
        with self._lock:
            return [dict(row) for row in self._db.execute("SELECT * FROM samples ORDER BY created_at")]

    def export_desensitized(self) -> list[dict[str, Any]]:
        aliases: dict[str, str] = {}

        def alias(value: str | None, prefix: str) -> str | None:
            if not value:
                return value
            if value not in aliases:
                aliases[value] = f"{prefix}_{len(aliases)+1:03d}"
            return aliases[value]

        exported = []
        for row in self.samples():
            exported.append(
                {
                    "sample_id": row["sample_id"],
                    "sample_key_hash": hashlib.sha256(row["sample_key"].encode("utf-8")).hexdigest()[:16],
                    "native_message_id": row["native_message_id"],
                    "account_key": alias(row["account_key"], "acct"),
                    "conversation_key": alias(row["conversation_key"], "room"),
                    "sender_key": alias(row["sender_key"], "member"),
                    "identity_status": row["identity_status"],
                    "is_self": row["is_self"],
                    "kind": row["kind"],
                    "mention_status": row["mention_status"],
                    "history_status": row["history_status"],
                    "parse_status": row["parse_status"],
                    "source_level": row["source_level"],
                    "delivery_count": row["delivery_count"],
                    "text": row["text"],
                    "occurred_at": row["occurred_at"],
                    "received_at": row["received_at"],
                }
            )
        return exported
