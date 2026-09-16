from __future__ import annotations

from dataclasses import dataclass
from datetime import timedelta
from threading import Lock
from typing import Any, Mapping
from uuid import uuid4
import json

from wechat_agent_poc.agent_policy import (
    AgentPolicy,
    PolicyDecision,
    PolicyRequest,
    default_slot_schema,
    inquiry_goal_text,
    slots_complete,
)
from wechat_agent_poc.api_channel import (
    ApiMessageV1,
    CallbackAck,
    Channel,
    ChannelError,
    FakeChannel,
    OutboundCommand,
    decode_callback_body,
    evidence_is_fresh,
)
from wechat_agent_poc.api_config import (
    API_CONFIG_VERSION,
    REQUIRED_SLOTS,
    SPEC_VERSION,
    ApiConfig,
    BindingSettings,
    isoformat,
    live_arm_blockers,
    parse_iso,
)
from wechat_agent_poc.api_store import ApiStore
from wechat_agent_poc.clock import Clock, SystemClock
from wechat_agent_poc.hashes import stable_json_hash

STOP_MARKERS = ("停止测试", "不要再找我", "不要再发", "别再发", "停止")
DECLINE_MARKERS = ("没时间", "不方便继续", "拒绝")
SYSTEM_PAUSE_KINDS = frozenset({"offline", "logged_out", "binding_changed", "session_replaced"})
PASSIVE_MAX_AGE_SECONDS = 30
FUTURE_SKEW_SECONDS = 5
PROBE_MAX_AGE_SECONDS = 5
SEND_HTTP_SECONDS = 8


class RuntimeError_(RuntimeError):
    pass


@dataclass
class RuntimeStatus:
    run_id: str | None
    paused: bool
    pause_reason: str | None
    revoked: bool
    in_flight: list[str]
    unknown: list[str]
    model_used: int
    send_used: int

    def as_dict(self) -> dict[str, Any]:
        return {
            "run_id": self.run_id,
            "paused": self.paused,
            "pause_reason": self.pause_reason,
            "revoked": self.revoked,
            "in_flight": self.in_flight,
            "unknown": self.unknown,
            "model_used": self.model_used,
            "send_used": self.send_used,
        }


class ApiRuntime:
    def __init__(
        self,
        config: ApiConfig,
        store: ApiStore,
        channel: Channel,
        policy: AgentPolicy,
        clock: Clock | None = None,
        *,
        self_key: str = "member_self",
        worker_id: str | None = None,
    ):
        self.config = config
        self.store = store
        self.channel = channel
        self.policy = policy
        self.clock = clock or SystemClock()
        self.self_key = self_key
        self.worker_id = worker_id or uuid4().hex[:8]
        self.send_lock = store.send_lock
        self._model_lock = Lock()
        self.last_recovery: dict[str, Any] = {}

    def recover(self) -> dict[str, Any]:
        self.last_recovery = self.store.recover()
        return self.last_recovery

    def start(self, *, stage: str | None = None) -> str:
        self.recover()
        if self.config.live_requested:
            blockers = live_arm_blockers(self.config)
            if blockers:
                raise RuntimeError_(f"live start refused: {', '.join(blockers)}")
            raise RuntimeError_("A1 refuses live start")
        if self.config.channel.provider != "fake" or self.config.agent.model_provider != "mock":
            raise RuntimeError_("offline start requires fake channel and mock model")
        with self.store.transaction() as txn:
            current = txn.current_run()
            if current is not None and not current["revoked_at"]:
                raise RuntimeError_("an active or paused run still holds the permit; stop it first")
            if txn.db.execute("SELECT 1 FROM outbox WHERE status='unknown' LIMIT 1").fetchone() and current is not None:
                raise RuntimeError_("unresolved unknown submits keep the current run paused")
            evidence = self.channel.probe(self.config.binding)
            if self.config.binding.account_key and evidence.account_key != self.config.binding.account_key:
                raise RuntimeError_("probe account does not match binding")
            if self.config.binding.conversation_key and evidence.account_key and not evidence.conversation_exists:
                raise RuntimeError_("probe conversation missing")
            if not evidence.unique_account or not evidence.unique_conversation:
                raise RuntimeError_("account or conversation is not unique; refusing to arm")
            account = self.config.binding.account_key or evidence.account_key
            conversation = self.config.binding.conversation_key or getattr(self.channel, "conversation_key", "")
            binding_version = self.config.binding.binding_version or "fake-offline"
            fingerprint = txn.upsert_binding(
                binding_version,
                account,
                conversation,
                {"account_key": account, "conversation_key": conversation, "session_epoch": evidence.session_epoch},
            )
            now = self.clock.now()
            stage_name = stage or self.config.run.stage
            limits = self.config.limits
            if stage_name != self.config.run.stage:
                from wechat_agent_poc.api_config import STAGE_LIMITS

                limits = STAGE_LIMITS[stage_name]
            targets = self.config.inquiry.target_keys
            run_id = uuid4().hex
            expires = now + timedelta(seconds=self.config.run.max_seconds)
            armed_at = isoformat(now)
            permit = {
                "run_id": run_id,
                "spec_version": SPEC_VERSION,
                "config_version": API_CONFIG_VERSION,
                "config_hash": stable_json_hash(
                    {
                        "profile": self.config.profile,
                        "stage": stage_name,
                        "binding": fingerprint,
                    }
                ),
                "stage": stage_name,
                "profile": self.config.profile,
                "account_key": account,
                "conversation_key": conversation,
                "binding_version": binding_version,
                "binding_fingerprint": fingerprint,
                "session_epoch": evidence.session_epoch,
                "started_at": armed_at,
                "expires_at": isoformat(expires),
                "armed_at": armed_at,
                "model_budget": limits.model_total,
                "model_passive_budget": limits.model_passive,
                "model_active_budget": limits.model_active,
                "send_budget": limits.send_total(len(targets)),
                "send_passive_budget": limits.send_passive or limits.send_total(len(targets)),
                "send_active_budget": limits.send_active(len(targets)),
                "allowed_actions": ["reply_text", "ask_target", "close_session", "ignore"],
                "template_id": self.config.inquiry.template_id,
                "target_keys": list(targets),
                "slot_schema": default_slot_schema(),
            }
            if permit["send_passive_budget"] == 0 and permit["send_budget"] > 0:
                permit["send_passive_budget"] = permit["send_budget"]
            txn.create_run(permit)
            txn.set_kv("current_run_id", run_id)
            if self.config.inquiry.enabled:
                due = now + timedelta(seconds=self.config.inquiry.delay_seconds)
                txn.create_task(
                    {
                        "task_id": "inquiry-1",
                        "task_version": "1",
                        "run_id": run_id,
                        "binding_version": binding_version,
                        "target_keys": list(targets),
                        "template_id": self.config.inquiry.template_id,
                        "required_slots": list(REQUIRED_SLOTS),
                        "schedule_kind": "once_after",
                        "delay_seconds": self.config.inquiry.delay_seconds,
                        "timezone": self.config.inquiry.timezone,
                        "due_at": isoformat(due),
                        "expiry_at": isoformat(expires),
                        "status": "scheduled",
                    }
                )
            txn.audit("start", {"run_id": run_id, "stage": stage_name, "armed_at": armed_at})
        return run_id

    def ingest_callback(self, headers: Mapping[str, str], body: bytes) -> CallbackAck:
        try:
            self.channel.authenticate_callback(headers, body)
            raw = decode_callback_body(body)
            received_at = isoformat(self.clock.now())
            event = self.channel.normalize(raw, received_at=received_at)
        except ChannelError as exc:
            return CallbackAck(exc.http_status, exc.code, False, details={"error": str(exc)})
        binding_account = self.config.binding.account_key or getattr(self.channel, "account_key", "")
        binding_conv = self.config.binding.conversation_key or getattr(self.channel, "conversation_key", "")
        if event.account_key != binding_account or event.conversation_key != binding_conv:
            self.store.increment_count("unbound_or_private")
            return CallbackAck(200, "dropped_unbound", True, details={"stored_text": False})
        if event.kind == "system" and (event.text or "") in SYSTEM_PAUSE_KINDS:
            with self.store.transaction() as txn:
                inserted = txn.insert_inbox(event)
                run = txn.current_run()
                if run is not None:
                    txn.pause_run(run["run_id"], f"system:{event.text}")
                    txn.cancel_reserved(run["run_id"], "system_event")
            return CallbackAck(200, "system_pause", True, inserted.event_key)
        inserted = self.store.insert_inbox(event)
        if inserted.conflict:
            with self.store.transaction() as txn:
                run = txn.current_run()
                if run is not None:
                    txn.pause_run(run["run_id"], "event_conflict")
            return CallbackAck(200, "event_conflict", True, inserted.event_key)
        if inserted.duplicate:
            return CallbackAck(200, "duplicate", True, inserted.event_key)
        return CallbackAck(200, "queued", True, inserted.event_key)

    def tick(self) -> None:
        self._expire_if_needed()
        self._process_due_tasks()
        while True:
            event = self.store.claim_next(self.worker_id)
            if event is None:
                return
            self._route(event)

    def stop(self, reason: str = "operator_stop") -> dict[str, Any]:
        with self.store.transaction() as txn:
            run = txn.current_run()
            if run is None:
                return {"stopped": False, "reason": "no_active_run"}
            cancelled = txn.cancel_reserved(run["run_id"], reason)
            txn.revoke_run(run["run_id"], reason)
            in_flight = [row["action_id"] for row in txn.db.execute(
                "SELECT action_id FROM outbox WHERE run_id=? AND status='submitting'", (run["run_id"],)
            )]
            unknown = [row["action_id"] for row in txn.db.execute(
                "SELECT action_id FROM outbox WHERE run_id=? AND status='unknown'", (run["run_id"],)
            )]
        return {
            "stopped": True,
            "run_id": run["run_id"],
            "cancelled_reserved": cancelled,
            "in_flight": in_flight,
            "unknown": unknown,
            "reason": reason,
        }

    def status(self) -> RuntimeStatus:
        with self.store.transaction() as txn:
            run = txn.current_run()
            if run is None:
                run = txn.db.execute("SELECT * FROM runs ORDER BY started_at DESC LIMIT 1").fetchone()
            if run is None:
                return RuntimeStatus(None, False, None, True, [], [], 0, 0)
            in_flight = [row["action_id"] for row in txn.db.execute(
                "SELECT action_id FROM outbox WHERE run_id=? AND status='submitting'", (run["run_id"],)
            )]
            unknown = [row["action_id"] for row in txn.db.execute(
                "SELECT action_id FROM outbox WHERE status='unknown'"
            )]
            return RuntimeStatus(
                run["run_id"],
                bool(run["paused"]),
                run["pause_reason"],
                bool(run["revoked_at"]),
                in_flight,
                unknown,
                int(run["model_used"]),
                int(run["send_used"]),
            )

    def verify_receipt(self, action_id: str, *, wecom: bool, wechat: bool, operator: str, note: str = "") -> dict[str, Any]:
        status = "verified" if wecom and wechat else "unverified"
        if not wecom and not wechat:
            status = "failed"
        with self.store.transaction() as txn:
            row = txn.db.execute("SELECT action_id FROM outbox WHERE action_id=?", (action_id,)).fetchone()
            if row is None:
                return {"recorded": False, "reason": "unknown_action"}
            txn.db.execute(
                """UPDATE receipts SET receipt_status=?, wecom_confirmed=?, wechat_confirmed=?, note=?, recorded_by=?, recorded_at=?
                   WHERE action_id=?""",
                (status, int(wecom), int(wechat), note, operator, isoformat(self.clock.now()), action_id),
            )
            txn.audit("verify", {"action_id": action_id, "status": status, "operator": operator})
        return {"recorded": True, "receipt_status": status, "resumed": False, "resent": False}

    def _expire_if_needed(self) -> None:
        now = self.clock.now()
        with self.store.transaction() as txn:
            run = txn.current_run()
            if run is None:
                return
            if run["expires_at"] and parse_iso(run["expires_at"]) <= now:
                txn.cancel_reserved(run["run_id"], "run_expired")
                txn.revoke_run(run["run_id"], "run_expired")
                return
            oldest = txn.db.execute(
                "SELECT received_at FROM inbox WHERE claim_status IN ('queued','claimed') ORDER BY received_at LIMIT 1"
            ).fetchone()
            if oldest and (now - parse_iso(oldest["received_at"])).total_seconds() > PASSIVE_MAX_AGE_SECONDS:
                txn.pause_run(run["run_id"], "queue_too_old")
            for row in txn.db.execute(
                "SELECT * FROM sessions WHERE run_id=? AND status='awaiting_reply'",
                (run["run_id"],),
            ):
                if row["expires_at"] and parse_iso(row["expires_at"]) <= now:
                    payload = _session_dict(row)
                    payload["status"] = "expired"
                    payload["version"] = int(row["version"]) + 1
                    txn.upsert_session(payload)
                    txn.audit("session_expired", {"session_pk": row["session_pk"]})

    def _process_due_tasks(self) -> None:
        now = self.clock.now()
        with self.store.transaction() as txn:
            run = txn.current_run()
            if run is None or run["paused"] or run["revoked_at"]:
                return
            task = txn.db.execute(
                "SELECT * FROM tasks WHERE run_id=? AND status='scheduled'", (run["run_id"],)
            ).fetchone()
            if task is None:
                return
            due = parse_iso(task["due_at"])
            if now < due:
                return
            grace = timedelta(seconds=self.config.inquiry.start_grace_seconds)
            if now > due + grace:
                txn.db.execute("UPDATE tasks SET status='cancelled' WHERE task_id=?", (task["task_id"],))
                txn.audit("missed_window", {"task_id": task["task_id"]})
                return
            txn.db.execute("UPDATE tasks SET status='dispatching' WHERE task_id=?", (task["task_id"],))
            targets = json.loads(task["target_keys"])
        for index, target in enumerate(targets):
            now = self.clock.now()
            if now > due + grace:
                with self.store.transaction() as txn:
                    txn.db.execute("UPDATE tasks SET status='cancelled' WHERE task_id=?", (task["task_id"],))
                    txn.audit("missed_window_later_target", {"target": "anonymous", "index": index})
                return
            session_pk = _session_pk(run["run_id"], task["task_id"], run["account_key"], run["conversation_key"], target)
            with self.store.transaction() as txn:
                txn.upsert_session(
                    {
                        "session_pk": session_pk,
                        "run_id": run["run_id"],
                        "task_id": task["task_id"],
                        "account_key": run["account_key"],
                        "conversation_key": run["conversation_key"],
                        "target_key": target,
                        "version": 1,
                        "status": "initial_submitting",
                        "slots": {name: "unknown" for name in REQUIRED_SLOTS},
                        "context": [],
                    }
                )
            idem = f"{task['task_id']}|{task['task_version']}|{task['due_at']}|{target}"
            result = self._submit_tool(
                tool="ask_target",
                text=inquiry_goal_text(),
                route="active",
                mention_keys=(target,),
                native_mention=True,
                session_pk=session_pk,
                idempotency_key=idem,
                consume_followup=False,
            )
            with self.store.transaction() as txn:
                session = txn.session_row(session_pk)
                payload = _session_dict(session) if session else None
                if payload is None:
                    continue
                if result["status"] == "accepted":
                    opened = self.clock.now()
                    run_expiry = parse_iso(run["expires_at"]) if run["expires_at"] else opened + timedelta(seconds=600)
                    session_end = min(opened + timedelta(seconds=self.config.inquiry.session_seconds), run_expiry)
                    payload["status"] = "awaiting_reply"
                    payload["opened_at"] = isoformat(opened)
                    payload["expires_at"] = isoformat(session_end)
                    payload["last_send_at"] = isoformat(opened)
                    payload["context"] = [{"role": "agent", "text": inquiry_goal_text()}]
                    txn.upsert_session(payload)
                elif result["status"] == "unknown":
                    payload["status"] = "uncertain"
                    txn.upsert_session(payload)
                    txn.pause_run(run["run_id"], "unknown_submit")
                    return
                else:
                    payload["status"] = "cancelled"
                    txn.upsert_session(payload)
        with self.store.transaction() as txn:
            txn.db.execute("UPDATE tasks SET status='opened' WHERE task_id=?", (task["task_id"],))

    def _route(self, event: ApiMessageV1) -> None:
        reason = self._pre_ignore_reason(event)
        if reason:
            self.store.mark_processed(event.event_key, ignore_reason=reason)
            return
        with self.store.transaction() as txn:
            run = txn.current_run()
            if run is None or run["paused"] or run["revoked_at"]:
                txn.mark_processed(event.event_key, ignore_reason="run_inactive")
                return
            if event.session_epoch and event.session_epoch != run["session_epoch"]:
                txn.pause_run(run["run_id"], "session_epoch_changed")
                txn.mark_processed(event.event_key, ignore_reason="session_epoch_changed")
                return
            session = txn.active_session_for(run["run_id"], event.sender_key)
        if session is not None and _is_stop_or_decline(event.text or ""):
            self._close_session(session["session_pk"], "declined", event.event_key)
            self.store.mark_processed(event.event_key, ignore_reason="declined")
            return
        mention_self = _real_self_mention(event, self.self_key)
        mention_conflict = event.mention_all or (
            event.mention_status == "structured" and any(key != self.self_key for key in event.mention_keys)
        )
        if session is not None and not mention_conflict:
            self._inquiry_path(event, session, mention_self)
            return
        if mention_self:
            self._mention_path(event)
            return
        self.store.mark_processed(event.event_key, ignore_reason="not_eligible")

    def _pre_ignore_reason(self, event: ApiMessageV1) -> str | None:
        if event.kind != "text":
            return "non_text"
        if event.parse_status != "ok":
            return "parse_not_ok"
        if event.is_self != "false":
            return "self_or_unknown"
        if event.identity_status != "resolved":
            return "identity_unresolved"
        if event.history_status != "false":
            return "historical"
        run_row = self.store.get("SELECT * FROM runs WHERE revoked_at IS NULL ORDER BY started_at DESC LIMIT 1")
        if run_row is None:
            return "no_run"
        armed_at = parse_iso(run_row["armed_at"]) if run_row["armed_at"] else parse_iso(run_row["started_at"])
        occurred = parse_iso(event.occurred_at)
        now = self.clock.now()
        if occurred < armed_at:
            return "before_baseline"
        if (occurred - now).total_seconds() > FUTURE_SKEW_SECONDS:
            return "future_clock"
        if (now - occurred).total_seconds() > PASSIVE_MAX_AGE_SECONDS:
            return "stale"
        binding_account = run_row["account_key"]
        binding_conv = run_row["conversation_key"]
        if event.account_key != binding_account or event.conversation_key != binding_conv:
            return "cross_group"
        if event.text and len(event.text) > self.config.agent.max_input_chars:
            return "input_too_long"
        return None

    def _mention_path(self, event: ApiMessageV1) -> None:
        occupied = self._occupy_model("passive")
        if not occupied:
            self.store.mark_processed(event.event_key, ignore_reason="model_budget")
            return
        decision = self._decide(
            PolicyRequest(task_type="mention_reply", allow_standalone_reply=False, current_input=event.text or "")
        )
        if decision.status != "ok" or not decision.sends:
            self.store.mark_processed(event.event_key, ignore_reason=decision.status if decision.status != "ok" else "ignored")
            return
        self._submit_tool(
            tool="reply_text",
            text=decision.text or "",
            route="passive",
            mention_keys=(),
            event_key=event.event_key,
        )
        self.store.mark_processed(event.event_key)

    def _inquiry_path(self, event: ApiMessageV1, session_row: Any, mention_self: bool) -> None:
        session_pk = session_row["session_pk"]
        version_before = int(session_row["version"])
        occupied = self._occupy_model("active")
        if not occupied:
            self.store.mark_processed(event.event_key, ignore_reason="model_budget")
            return
        slots = json.loads(session_row["slots_json"])
        context = json.loads(session_row["context_json"] or "[]")
        pairs = _context_pairs(context)
        decision = self._decide(
            PolicyRequest(
                task_type="inquiry_reply",
                allow_standalone_reply=mention_self,
                current_input=event.text or "",
                slot_schema=default_slot_schema(),
                filled_slots=slots,
                context_pairs=pairs,
                inquiry_goal=inquiry_goal_text(),
            )
        )
        with self.store.transaction() as txn:
            latest = txn.session_row(session_pk)
            if latest is None or int(latest["version"]) != version_before:
                txn.mark_processed(event.event_key, ignore_reason="stale_model_result")
                return
        if decision.status != "ok":
            self.store.mark_processed(event.event_key, ignore_reason=decision.status)
            return
        if decision.relation != "related":
            if mention_self and decision.action == "reply" and decision.text:
                self._submit_tool(
                    tool="reply_text",
                    text=decision.text,
                    route="passive",
                    mention_keys=(),
                    event_key=event.event_key,
                )
                self.store.mark_processed(event.event_key)
                return
            self.store.mark_processed(event.event_key, ignore_reason=decision.relation)
            return
        slots.update({key: value for key, value in decision.slot_updates.items() if value in {"true", "false", "unknown"}})
        associated = context + [{"role": "user", "text": event.text or ""}]
        if decision.action in {"reply", "ask"} and decision.text:
            if int(session_row["followup_used"]) >= self.config.inquiry.max_followup_attempts:
                self._close_session(session_pk, "exhausted", event.event_key, slots=slots, context=associated)
                self.store.mark_processed(event.event_key, ignore_reason="exhausted")
                return
            complete = slots_complete(slots) or decision.reason_code == "complete"
            if complete and not slots_complete(slots):
                complete = False
            result = self._submit_tool(
                tool="ask_target" if decision.action == "ask" else "reply_text",
                text=decision.text,
                route="active",
                mention_keys=(),
                event_key=event.event_key,
                session_pk=session_pk,
                consume_followup=True,
            )
            associated = associated + [{"role": "agent", "text": decision.text}]
            if result["status"] == "unknown":
                self._close_session(session_pk, "uncertain", event.event_key, slots=slots, context=associated)
                self.store.mark_processed(event.event_key)
                return
            if complete and result["status"] == "accepted":
                self._close_session(session_pk, "completed", event.event_key, slots=slots, context=associated)
            else:
                self._update_session(session_pk, slots=slots, context=associated, last_send=True)
            self.store.mark_processed(event.event_key)
            return
        if decision.action == "close" or decision.reason_code in {"complete", "declined"}:
            reason = "declined" if decision.reason_code == "declined" else "completed"
            if reason == "completed" and not slots_complete(slots):
                self._update_session(session_pk, slots=slots, context=associated)
                self.store.mark_processed(event.event_key, ignore_reason="incomplete_close_blocked")
                return
            self._close_session(session_pk, reason, event.event_key, slots=slots, context=associated)
            self.store.mark_processed(event.event_key)
            return
        self._update_session(session_pk, slots=slots, context=associated)
        self.store.mark_processed(event.event_key, ignore_reason="ignored")

    def _decide(self, request: PolicyRequest) -> PolicyDecision:
        with self._model_lock:
            return self.policy.decide(request)

    def _occupy_model(self, route: str) -> bool:
        with self.store.transaction() as txn:
            run = txn.current_run()
            if run is None:
                return False
            return txn.occupy_model(run["run_id"], route)

    def _submit_tool(
        self,
        *,
        tool: str,
        text: str,
        route: str,
        mention_keys: tuple[str, ...],
        native_mention: bool = False,
        event_key: str | None = None,
        session_pk: str | None = None,
        idempotency_key: str | None = None,
        consume_followup: bool = False,
    ) -> dict[str, Any]:
        if tool not in {"reply_text", "ask_target"}:
            return {"status": "not_submitted", "reason": "unknown_tool"}
        now = self.clock.now()
        deadline = isoformat(now + timedelta(seconds=SEND_HTTP_SECONDS))
        with self.store.transaction() as txn:
            run = txn.current_run()
            if run is None or run["paused"] or run["revoked_at"]:
                return {"status": "not_submitted", "reason": "run_inactive"}
            if consume_followup and session_pk:
                session = txn.session_row(session_pk)
                if session is None:
                    return {"status": "not_submitted", "reason": "no_session"}
                if int(session["followup_used"]) >= self.config.inquiry.max_followup_attempts:
                    return {"status": "not_submitted", "reason": "followup_exhausted"}
                if session["last_send_at"]:
                    elapsed = (now - parse_iso(session["last_send_at"])).total_seconds()
                    if elapsed < self.config.run.member_cooldown_seconds:
                        return {"status": "not_submitted", "reason": "cooldown"}
            evidence = self.channel.probe(
                BindingSettings(run["account_key"], run["conversation_key"], run["binding_version"])
            )
            if not evidence.online or not evidence.conversation_exists:
                return {"status": "not_submitted", "reason": "offline_or_missing_group"}
            if not evidence_is_fresh(evidence, now, max_age_seconds=PROBE_MAX_AGE_SECONDS):
                return {"status": "not_submitted", "reason": "stale_probe"}
            action_id = txn.reserve_outbox(
                {
                    "run_id": run["run_id"],
                    "event_key": event_key,
                    "session_pk": session_pk,
                    "route": route,
                    "tool": tool,
                    "account_key": run["account_key"],
                    "conversation_key": run["conversation_key"],
                    "mention_keys": mention_keys,
                    "text": text,
                    "binding_version": run["binding_version"],
                    "deadline_at": deadline,
                    "idempotency_key": idempotency_key,
                }
            )
            if not action_id:
                return {"status": "not_submitted", "reason": "budget_or_duplicate"}
            if consume_followup and session_pk:
                session = txn.session_row(session_pk)
                payload = _session_dict(session)
                payload["followup_used"] = int(session["followup_used"]) + 1
                txn.upsert_session(payload)
            txn.mark_submitting(action_id)
        if not self.send_lock.acquire(timeout=3):
            with self.store.transaction() as txn:
                txn.finish_outbox(action_id, "not_submitted", reason="send_lock_timeout")
            return {"status": "not_submitted", "reason": "send_lock_timeout", "action_id": action_id}
        try:
            command = OutboundCommand(
                action_id=action_id,
                binding_version=self.config.binding.binding_version or "fake-offline",
                account_key=self.config.binding.account_key or getattr(self.channel, "account_key", ""),
                conversation_key=self.config.binding.conversation_key or getattr(self.channel, "conversation_key", ""),
                mention_keys=mention_keys,
                text=text,
                deadline_at=deadline,
                idempotency_key=idempotency_key or action_id,
                native_mention=native_mention,
            )
            try:
                result = self.channel.submit(command)
            except Exception:  # noqa: BLE001
                with self.store.transaction() as txn:
                    txn.finish_outbox(action_id, "unknown", reason="crash")
                    run = txn.current_run()
                    if run is not None:
                        txn.pause_run(run["run_id"], "unknown_submit")
                        txn.cancel_reserved(run["run_id"], "unknown_submit")
                return {"status": "unknown", "reason": "crash", "action_id": action_id}
        finally:
            self.send_lock.release()
        with self.store.transaction() as txn:
            if result.write_calls > 1:
                txn.finish_outbox(action_id, "unknown", reason="write_retry_detected", write_calls=result.write_calls)
                run = txn.current_run()
                if run is not None:
                    txn.pause_run(run["run_id"], "write_retry_detected")
                return {"status": "unknown", "reason": "write_retry_detected", "action_id": action_id}
            txn.finish_outbox(
                action_id,
                result.status,
                reason=result.reason,
                provider_request_id=result.provider_request_id,
                provider_message_id=result.provider_message_id,
                write_calls=result.write_calls,
            )
            if result.status == "unknown":
                run = txn.current_run()
                if run is not None:
                    txn.pause_run(run["run_id"], "unknown_submit")
                    txn.cancel_reserved(run["run_id"], "unknown_submit")
            if result.status == "accepted" and session_pk:
                session = txn.session_row(session_pk)
                if session is not None:
                    payload = _session_dict(session)
                    payload["last_send_at"] = isoformat(self.clock.now())
                    txn.upsert_session(payload)
        return {"status": result.status, "reason": result.reason, "action_id": action_id}

    def _close_session(
        self,
        session_pk: str,
        status: str,
        event_key: str | None,
        *,
        slots: dict[str, str] | None = None,
        context: list[dict[str, str]] | None = None,
    ) -> None:
        with self.store.transaction() as txn:
            session = txn.session_row(session_pk)
            if session is None:
                return
            payload = _session_dict(session)
            payload["status"] = status
            payload["version"] = int(session["version"]) + 1
            if slots is not None:
                payload["slots"] = slots
            if context is not None:
                payload["context"] = context
            txn.upsert_session(payload)
            txn.db.execute(
                "UPDATE outbox SET status='cancelled', updated_at=? WHERE session_pk=? AND status='reserved'",
                (isoformat(self.clock.now()), session_pk),
            )
            txn.audit("close_session", {"session_pk": session_pk, "status": status, "event_key": event_key})

    def _update_session(
        self,
        session_pk: str,
        *,
        slots: dict[str, str],
        context: list[dict[str, str]],
        last_send: bool = False,
    ) -> None:
        with self.store.transaction() as txn:
            session = txn.session_row(session_pk)
            if session is None:
                return
            payload = _session_dict(session)
            payload["slots"] = slots
            payload["context"] = context
            payload["version"] = int(session["version"]) + 1
            if last_send:
                payload["last_send_at"] = isoformat(self.clock.now())
            txn.upsert_session(payload)


def build_offline_runtime(
    config: ApiConfig,
    *,
    store: ApiStore | None = None,
    channel: FakeChannel | None = None,
    policy: AgentPolicy | None = None,
    clock: Clock | None = None,
    completer=None,
    self_key: str = "member_self",
) -> ApiRuntime:
    clock = clock or SystemClock()
    store = store or ApiStore(config.state_path, clock=clock)
    channel = channel or FakeChannel(clock=clock)
    if policy is None:
        from wechat_agent_poc.agent_policy import ScriptedCompleter

        policy = AgentPolicy(
            completer or ScriptedCompleter([]),
            max_input_chars=config.agent.max_input_chars,
            max_output_chars=config.agent.max_output_chars,
            context_max_chars=config.agent.context_max_chars,
            timeout_seconds=config.agent.model_timeout_seconds,
        )
    return ApiRuntime(config, store, channel, policy, clock, self_key=self_key)


def _session_pk(run_id: str, task_id: str, account: str, conversation: str, target: str) -> str:
    return f"{run_id}|{task_id}|{account}|{conversation}|{target}"


def _session_dict(row: Any) -> dict[str, Any]:
    return {
        "session_pk": row["session_pk"],
        "run_id": row["run_id"],
        "task_id": row["task_id"],
        "account_key": row["account_key"],
        "conversation_key": row["conversation_key"],
        "target_key": row["target_key"],
        "version": int(row["version"]),
        "status": row["status"],
        "opened_at": row["opened_at"],
        "expires_at": row["expires_at"],
        "followup_used": int(row["followup_used"]),
        "slots": json.loads(row["slots_json"]),
        "context": json.loads(row["context_json"] or "[]"),
        "last_send_at": row["last_send_at"],
        "closing_action_id": row["closing_action_id"],
    }


def _context_pairs(context: list[dict[str, str]]) -> list[dict[str, str]]:
    pairs: list[dict[str, str]] = []
    for item in context:
        if item.get("role") in {"user", "agent"} and item.get("text"):
            pairs.append({"role": item["role"], "text": item["text"]})
    return pairs[-6:]


def _real_self_mention(event: ApiMessageV1, self_key: str) -> bool:
    if event.mention_status != "structured" or event.mention_all:
        return False
    return event.mention_keys == (self_key,)


def _is_stop_or_decline(text: str) -> bool:
    stripped = text.strip()
    return any(marker in stripped for marker in STOP_MARKERS + DECLINE_MARKERS)
