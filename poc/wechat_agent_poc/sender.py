from __future__ import annotations

from datetime import datetime, timezone
from typing import Protocol

from wechat_agent_poc.config import AppConfig
from wechat_agent_poc.models import Binding, Halt, HaltError, ReceiverEvidence, SendResult, WindowState
from wechat_agent_poc.store import Store


class Sender(Protocol):
    def send_text(self, binding: Binding, text: str, window: WindowState | None) -> SendResult: ...


class MockSender:
    def __init__(self):
        self.sent: list[tuple[str, str]] = []
        self.next_result = SendResult("local_ok", "mock local bubble only", local_bubble=True)

    def send_text(self, binding: Binding, text: str, window: WindowState | None) -> SendResult:
        self.sent.append((binding.conversation_key, text))
        return self.next_result


class DesktopStubSender:
    def send_text(self, binding: Binding, text: str, window: WindowState | None) -> SendResult:
        raise HaltError(
            Halt(
                "WINDOW_MISMATCH",
                "desktop sender is a stub; live UI send is not enabled in this build",
                {"binding_version": binding.binding_version},
            )
        )


def parse_time(value: str) -> datetime:
    if value.endswith("Z"):
        value = value[:-1] + "+00:00"
    return datetime.fromisoformat(value).astimezone(timezone.utc)


def send_text(
    store: Store,
    config: AppConfig,
    sender: Sender,
    approval_id: str,
    window: WindowState | None = None,
) -> str:
    if store.has_uncertain_send():
        raise HaltError(Halt("SENDING_UNCERTAIN", "an earlier send is uncertain; do not retry"))
    if store.paused():
        raise HaltError(Halt("PAUSED", store.runtime_get("pause_reason") or "paused"))
    if store.in_flight() is not None:
        raise HaltError(Halt("SENDING_UNCERTAIN", "another send is in flight"))
    approval = store.get_approval(approval_id)
    if approval is None:
        raise HaltError(Halt("REVIEW_MISSING", "approval not found"))
    draft = store.get_draft(approval["draft_id"])
    if draft is None:
        raise HaltError(Halt("REVIEW_MISSING", "draft missing for approval"))
    now = store.clock.now()
    if parse_time(approval["expires_at"]) <= now:
        store.set_draft_status(draft.draft_id, "expired")
        raise HaltError(Halt("REVIEW_EXPIRED", "approval expired; re-confirm"))
    if approval["binding_version"] != config.binding.binding_version:
        raise HaltError(Halt("BINDING_CHANGED", "binding changed after approval"))
    if approval["conversation_key"] != config.binding.conversation_key:
        raise HaltError(Halt("GROUP_UNKNOWN", "approval target is not the bound group"))
    if approval["approved_text"] != (draft.text or ""):
        raise HaltError(Halt("REVIEW_HASH", "draft text changed after approval"))
    window_state = window or _default_window(config)
    ok, why = config.binding.matches_window(window_state.as_mapping())
    if not ok:
        raise HaltError(Halt("WINDOW_MISMATCH", why))
    store.set_draft_status(draft.draft_id, "sending")
    store.record_attempt(approval_id, draft.draft_id, "sending", "pending", "persisted before send")
    try:
        result = sender.send_text(config.binding, approval["approved_text"], window_state)
    except HaltError:
        store.set_draft_status(draft.draft_id, "failed", {"phase": "before_client"})
        raise
    except Exception as exc:
        store.set_draft_status(draft.draft_id, "uncertain", {"error": type(exc).__name__})
        store.pause("SENDING_UNCERTAIN")
        raise HaltError(Halt("SENDING_UNCERTAIN", f"send aborted after handoff: {exc}")) from exc
    if result.status == "not_sent":
        store.set_draft_status(draft.draft_id, "failed")
        store.record_attempt(approval_id, draft.draft_id, "failed", "not_sent", result.note)
        return "failed"
    if result.status == "unknown":
        store.set_draft_status(draft.draft_id, "uncertain")
        store.pause("SENDING_UNCERTAIN")
        store.record_attempt(approval_id, draft.draft_id, "uncertain", "unknown", result.note)
        return "uncertain"
    store.record_attempt(approval_id, draft.draft_id, "sending", "local_ok", result.note)
    return "sending"


def attach_receiver_evidence(store: Store, draft_id: str, evidence: ReceiverEvidence) -> str:
    draft = store.get_draft(draft_id)
    if draft is None:
        raise HaltError(Halt("REVIEW_MISSING", "draft not found"))
    if draft.status not in {"sending", "uncertain"}:
        raise HaltError(Halt("REVIEW_STATE", f"cannot verify status {draft.status}"))
    wecom = "confirmed" if evidence.wecom_confirmed else "missing"
    wechat = "confirmed" if evidence.wechat_confirmed else "missing"
    store.update_attempt_receivers(draft_id, wecom, wechat, evidence.note)
    if evidence.wecom_confirmed and evidence.wechat_confirmed:
        store.set_draft_status(draft_id, "verified", {"recorded_by": evidence.recorded_by})
        return "verified"
    store.set_draft_status(draft_id, "uncertain", {"recorded_by": evidence.recorded_by})
    store.pause("SENDING_UNCERTAIN")
    return "uncertain"


def _default_window(config: AppConfig) -> WindowState:
    return WindowState(
        account_alias=config.binding.account_alias,
        account_wxid=config.binding.account_wxid,
        display_name=config.binding.display_name,
        conversation_key=config.binding.conversation_key,
        details=" ".join(config.binding.required_detail_tokens),
        member_features=config.binding.member_features,
        focus=True,
        rebuilt=False,
        located_by="binding_map",
    )
