from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any
from uuid import uuid4
import hashlib
import json
import sqlite3
import threading

from wechat_agent_poc.api_channel import ApiMessageV1
from wechat_agent_poc.api_config import isoformat
from wechat_agent_poc.clock import Clock, SystemClock
from wechat_agent_poc.config import ConfigError
from wechat_agent_poc.hashes import sha256_text

USER_VERSION = 1
FORBIDDEN_TABLES = frozenset(
    {"drafts", "approvals", "send_attempts", "outbox", "tasks", "inbox", "observe_runs"}
)

SCHEMA = """
CREATE TABLE IF NOT EXISTS pad_observe_runs (
    run_id TEXT PRIMARY KEY,
    observe_epoch TEXT NOT NULL UNIQUE,
    status TEXT NOT NULL,
    api_flavor TEXT NOT NULL,
    account_key TEXT NOT NULL,
    conversation_key TEXT NOT NULL,
    binding_version TEXT NOT NULL,
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
    schema_version INTEGER NOT NULL DEFAULT 1
);
CREATE TABLE IF NOT EXISTS pad_samples (
    sample_id TEXT PRIMARY KEY,
    run_id TEXT NOT NULL,
    sample_key TEXT NOT NULL UNIQUE,
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
    delivery_count INTEGER NOT NULL DEFAULT 1,
    text TEXT,
    occurred_at TEXT,
    received_at TEXT NOT NULL,
    created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS pad_sample_conflicts (
    conflict_id TEXT PRIMARY KEY,
    run_id TEXT NOT NULL,
    sample_key TEXT NOT NULL,
    body_hash TEXT NOT NULL,
    created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS pad_item_dispositions (
    disposition_id TEXT PRIMARY KEY,
    batch_id TEXT NOT NULL,
    run_id TEXT,
    item_index INTEGER NOT NULL,
    action TEXT NOT NULL,
    native_message_id TEXT,
    reason TEXT NOT NULL,
    stored_text INTEGER NOT NULL,
    created_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS pad_batches (
    batch_id TEXT PRIMARY KEY,
    run_id TEXT,
    received_at TEXT NOT NULL,
    metadata_signature_valid INTEGER,
    private_gateway_transport_verified INTEGER NOT NULL,
    payload_integrity_verified INTEGER NOT NULL DEFAULT 0,
    http_status INTEGER NOT NULL,
    code TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS pad_counters (
    name TEXT PRIMARY KEY,
    value INTEGER NOT NULL
);
"""


@dataclass(frozen=True)
class ItemRecord:
    index: int
    action: str
    reason: str
    native_message_id: str | None
    stored_text: bool
    event: ApiMessageV1 | None = None


@dataclass(frozen=True)
class BatchPersistResult:
    action: str
    http_status: int
    batch_id: str
    paused: bool = False
    reason: str = ""
    items: tuple[ItemRecord, ...] = field(default_factory=tuple)


class PadStore:
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
        self.fail_next_batch = False
        self._ensure_schema()

    def close(self) -> None:
        with self._lock:
            self._db.close()

    def _ensure_schema(self) -> None:
        version = int(self._db.execute("PRAGMA user_version").fetchone()[0])
        tables = {row[0] for row in self._db.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()}
        if tables & FORBIDDEN_TABLES:
            raise ConfigError("pad observer sqlite collides with an agent, GeWe, or old PoC store")
        if version not in {0, USER_VERSION}:
            raise ConfigError(f"unsupported pad observer user_version {version}")
        self._db.executescript(SCHEMA)
        self._db.execute(f"PRAGMA user_version={USER_VERSION}")

    def create_run(
        self,
        *,
        api_flavor: str,
        account_key: str,
        conversation_key: str,
        binding_version: str,
        authorization_ref: str,
        max_seconds: int,
        max_samples: int,
        max_body_bytes: int,
        status: str = "serving",
    ) -> dict[str, Any]:
        with self._lock:
            active = self._db.execute(
                "SELECT run_id FROM pad_observe_runs WHERE stopped_at IS NULL AND status NOT IN ('stopped','failed')"
            ).fetchone()
            if active:
                raise ConfigError("a pad observer run is already active; multi-session start is refused")
            now = self.clock.now()
            run_id = uuid4().hex
            epoch = uuid4().hex
            expires = datetime.fromtimestamp(now.timestamp() + max_seconds, tz=timezone.utc)
            self._db.execute(
                """INSERT INTO pad_observe_runs(
                    run_id, observe_epoch, status, api_flavor, account_key, conversation_key, binding_version,
                    authorization_ref, started_at, expires_at, permit_generation, max_samples, max_body_bytes,
                    sample_count, body_bytes, schema_version
                ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,0,0,?)""",
                (
                    run_id,
                    epoch,
                    status,
                    api_flavor,
                    account_key,
                    conversation_key,
                    binding_version,
                    authorization_ref,
                    isoformat(now),
                    isoformat(expires),
                    1,
                    max_samples,
                    max_body_bytes,
                    USER_VERSION,
                ),
            )
            return self._current_run_unlocked() or {}

    def current_run(self) -> dict[str, Any] | None:
        with self._lock:
            return self._current_run_unlocked()

    def _current_run_unlocked(self) -> dict[str, Any] | None:
        row = self._db.execute("SELECT * FROM pad_observe_runs ORDER BY started_at DESC LIMIT 1").fetchone()
        return dict(row) if row else None

    def interrupt_unfinished(self, reason: str = "process_interrupted") -> int:
        with self._lock:
            now = isoformat(self.clock.now())
            cur = self._db.execute(
                """UPDATE pad_observe_runs
                   SET status='failed', stopped_at=?, stop_reason=?, permit_generation=permit_generation+1
                   WHERE stopped_at IS NULL AND status NOT IN ('stopped','failed')""",
                (now, reason),
            )
            return int(cur.rowcount or 0)

    def stop(self, reason: str) -> dict[str, Any]:
        with self._lock:
            now = isoformat(self.clock.now())
            row = self._current_run_unlocked()
            if row is None:
                return {"stopped": False, "reason": "no_run"}
            self._db.execute(
                """UPDATE pad_observe_runs
                   SET status='stopped', stopped_at=?, stop_reason=?, permit_generation=permit_generation+1
                   WHERE run_id=?""",
                (now, reason, row["run_id"]),
            )
            return {"stopped": True, "run_id": row["run_id"], "reason": reason, "stopped_at": now}

    def request_stop(self, reason: str, *, run_id: str | None = None) -> dict[str, Any]:
        with self._lock:
            row = self._current_run_unlocked()
            if row is None:
                return {"stop_requested": False, "reason": "no_run"}
            if run_id and row["run_id"] != run_id:
                return {"stop_requested": False, "reason": "run_mismatch"}
            if row["stopped_at"] or row["status"] in {"stopped", "failed"}:
                return {
                    "stop_requested": False,
                    "stopped_confirmed": True,
                    "run_id": row["run_id"],
                    "reason": "already_stopped",
                }
            now = isoformat(self.clock.now())
            self._db.execute(
                """UPDATE pad_observe_runs
                   SET status='stopping', stop_reason=?, permit_generation=permit_generation+1
                   WHERE run_id=?""",
                (reason, row["run_id"]),
            )
            return {"stop_requested": True, "stopped_confirmed": False, "run_id": row["run_id"], "reason": reason, "requested_at": now}

    def attach_process(self, run_id: str, *, pid: int, owner_nonce: str, listen_host: str, listen_port: int) -> None:
        with self._lock:
            now = isoformat(self.clock.now())
            self._db.execute(
                """UPDATE pad_observe_runs
                   SET pid=?, owner_nonce=?, listen_host=?, listen_port=?,
                       heartbeat_at=?, process_created_at=?, status='serving'
                   WHERE run_id=? AND stopped_at IS NULL""",
                (pid, owner_nonce, listen_host, listen_port, now, now, run_id),
            )

    def heartbeat(self, run_id: str) -> None:
        with self._lock:
            self._db.execute(
                "UPDATE pad_observe_runs SET heartbeat_at=? WHERE run_id=? AND stopped_at IS NULL AND status='serving'",
                (isoformat(self.clock.now()), run_id),
            )

    def bump_counter(self, name: str, delta: int = 1) -> None:
        with self._lock:
            self._bump_unlocked(name, delta)

    def _bump_unlocked(self, name: str, delta: int = 1) -> None:
        self._db.execute(
            "INSERT INTO pad_counters(name, value) VALUES (?, ?) ON CONFLICT(name) DO UPDATE SET value=value+excluded.value",
            (name, delta),
        )

    def counters(self) -> dict[str, int]:
        with self._lock:
            return {row["name"]: int(row["value"]) for row in self._db.execute("SELECT name, value FROM pad_counters")}

    def persist_batch(
        self,
        *,
        items: list[ItemRecord],
        metadata_signature_valid: bool | None,
        private_gateway_transport_verified: bool,
        received_at: str,
    ) -> BatchPersistResult:
        with self._lock:
            batch_id = uuid4().hex
            if self.fail_next_batch:
                self.fail_next_batch = False
                self._bump_unlocked("persist_error")
                raise sqlite3.OperationalError("injected persist failure")
            run = self._current_run_unlocked()
            if run is None:
                self._bump_unlocked("persist_rejected_no_run")
                return BatchPersistResult("rejected", 503, batch_id, reason="no_run", items=tuple(items))
            if run["stopped_at"] or run["status"] in {"stopped", "stopping", "failed"}:
                self._bump_unlocked("persist_rejected_stopped")
                return BatchPersistResult("rejected", 503, batch_id, reason="stopped", items=tuple(items))
            if run["status"] == "paused":
                self._bump_unlocked("persist_rejected_paused")
                return BatchPersistResult("rejected", 503, batch_id, reason="paused", paused=True, items=tuple(items))
            expires = datetime.fromisoformat(str(run["expires_at"]).replace("Z", "+00:00"))
            if self.clock.now() >= expires:
                self._db.execute(
                    "UPDATE pad_observe_runs SET status='stopped', stopped_at=?, stop_reason='expired' WHERE run_id=?",
                    (isoformat(self.clock.now()), run["run_id"]),
                )
                self._bump_unlocked("persist_rejected_expired")
                return BatchPersistResult("rejected", 503, batch_id, reason="expired", items=tuple(items))
            self._db.execute("BEGIN IMMEDIATE")
            try:
                persisted: list[ItemRecord] = []
                paused = False
                for item in items:
                    result_item, paused_now = self._persist_item_unlocked(run, item)
                    persisted.append(result_item)
                    self._db.execute(
                        """INSERT INTO pad_item_dispositions(
                            disposition_id, batch_id, run_id, item_index, action, native_message_id, reason, stored_text, created_at
                        ) VALUES (?,?,?,?,?,?,?,?,?)""",
                        (
                            uuid4().hex,
                            batch_id,
                            run["run_id"],
                            result_item.index,
                            result_item.action,
                            result_item.native_message_id,
                            result_item.reason,
                            int(result_item.stored_text),
                            isoformat(self.clock.now()),
                        ),
                    )
                    if paused_now:
                        paused = True
                code = "conflict" if paused else "accepted"
                http_status = 200
                self._db.execute(
                    """INSERT INTO pad_batches(
                        batch_id, run_id, received_at, metadata_signature_valid, private_gateway_transport_verified,
                        payload_integrity_verified, http_status, code
                    ) VALUES (?,?,?,?,?,0,?,?)""",
                    (
                        batch_id,
                        run["run_id"],
                        received_at,
                        None if metadata_signature_valid is None else int(metadata_signature_valid),
                        int(private_gateway_transport_verified),
                        http_status,
                        code,
                    ),
                )
                self._db.execute("COMMIT")
            except Exception:
                self._db.execute("ROLLBACK")
                self._bump_unlocked("persist_error")
                raise
            return BatchPersistResult(
                "conflict" if paused else "stored",
                200,
                batch_id,
                paused=paused,
                reason="sample_conflict" if paused else "ok",
                items=tuple(persisted),
            )

    def _persist_item_unlocked(self, run: dict[str, Any], item: ItemRecord) -> tuple[ItemRecord, bool]:
        if item.action in {"dropped_unbound", "rejected", "isolated"}:
            self._bump_unlocked(item.action)
            stored_text = False
            return ItemRecord(item.index, item.action, item.reason, item.native_message_id, stored_text, item.event), False
        event = item.event
        if event is None or not event.native_message_id:
            self._bump_unlocked("rejected")
            return ItemRecord(item.index, "rejected", item.reason or "missing_native_id", item.native_message_id, False, None), False
        if int(run["sample_count"]) >= int(run["max_samples"]):
            self._db.execute(
                "UPDATE pad_observe_runs SET status='stopped', stop_reason='capacity' WHERE run_id=?",
                (run["run_id"],),
            )
            self._bump_unlocked("capacity_exhausted")
            return ItemRecord(item.index, "rejected", "capacity", event.native_message_id, False, event), False
        body_hash = sha256_text(event.body_fingerprint())
        existing = self._db.execute(
            "SELECT sample_id, body_hash, delivery_count FROM pad_samples WHERE sample_key=?",
            (event.event_key,),
        ).fetchone()
        if existing:
            if existing["body_hash"] == body_hash:
                self._db.execute(
                    "UPDATE pad_samples SET delivery_count=delivery_count+1 WHERE sample_id=?",
                    (existing["sample_id"],),
                )
                self._bump_unlocked("duplicate_delivery")
                return ItemRecord(item.index, "duplicate", "duplicate", event.native_message_id, False, event), False
            self._db.execute(
                "INSERT INTO pad_sample_conflicts(conflict_id, run_id, sample_key, body_hash, created_at) VALUES (?,?,?,?,?)",
                (uuid4().hex, run["run_id"], event.event_key, body_hash, isoformat(self.clock.now())),
            )
            self._db.execute(
                "UPDATE pad_observe_runs SET status='paused', stop_reason='sample_conflict' WHERE run_id=?",
                (run["run_id"],),
            )
            self._bump_unlocked("sample_conflict")
            return ItemRecord(item.index, "conflict", "sample_conflict", event.native_message_id, False, event), True
        text = event.text if item.stored_text else None
        self._db.execute(
            """INSERT INTO pad_samples(
                sample_id, run_id, sample_key, native_message_id, body_hash, account_key, conversation_key,
                sender_key, identity_status, is_self, kind, mention_status, history_status, parse_status,
                delivery_count, text, occurred_at, received_at, created_at
            ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?,?,?)""",
            (
                uuid4().hex,
                run["run_id"],
                event.event_key,
                event.native_message_id,
                body_hash,
                event.account_key,
                event.conversation_key,
                event.sender_key,
                event.identity_status,
                event.is_self,
                event.kind,
                event.mention_status,
                event.history_status,
                event.parse_status,
                text,
                event.occurred_at,
                event.received_at,
                isoformat(self.clock.now()),
            ),
        )
        body_len = len((text or "").encode("utf-8"))
        self._db.execute(
            "UPDATE pad_observe_runs SET sample_count=sample_count+1, body_bytes=body_bytes+? WHERE run_id=?",
            (body_len, run["run_id"]),
        )
        run["sample_count"] = int(run["sample_count"]) + 1
        self._bump_unlocked("samples_stored")
        return ItemRecord(item.index, "stored", "ok", event.native_message_id, bool(text is not None), event), False

    def sample_count(self) -> int:
        with self._lock:
            row = self._db.execute("SELECT COUNT(*) AS n FROM pad_samples").fetchone()
            return int(row["n"])

    def samples(self) -> list[dict[str, Any]]:
        with self._lock:
            return [dict(row) for row in self._db.execute("SELECT * FROM pad_samples ORDER BY created_at")]

    def dispositions(self) -> list[dict[str, Any]]:
        with self._lock:
            return [dict(row) for row in self._db.execute("SELECT * FROM pad_item_dispositions ORDER BY created_at")]

    def table_names(self) -> set[str]:
        with self._lock:
            return {row[0] for row in self._db.execute("SELECT name FROM sqlite_master WHERE type='table'")}

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
                    "delivery_count": row["delivery_count"],
                    "text": row["text"],
                    "occurred_at": row["occurred_at"],
                    "received_at": row["received_at"],
                }
            )
        return exported
