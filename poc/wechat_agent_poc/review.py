from __future__ import annotations

from wechat_agent_poc.config import AppConfig
from wechat_agent_poc.hashes import sha256_text
from wechat_agent_poc.models import Halt, HaltError
from wechat_agent_poc.store import DraftRecord, Store


def format_draft(store: Store, draft: DraftRecord) -> str:
    event = store.get_event(draft.event_key)
    original = event.text if event else "(missing event)"
    evidence_lines = []
    for key in draft.evidence_keys:
        item = store.get_event(key)
        snippet = (item.text or "") if item else ""
        evidence_lines.append(f"  - {key}: {snippet}")
    return "\n".join(
        [
            f"DRAFT {draft.draft_id}",
            f"status: {draft.status}",
            f"account: {draft.account_alias}",
            f"group: {draft.conversation_key}",
            f"binding_version: {draft.binding_version}",
            f"event_key: {draft.event_key}",
            f"original: {original}",
            f"draft_text: {draft.text or ''}",
            f"text_hash: {draft.text_hash or ''}",
            f"reason: {draft.reason}",
            "evidence:",
            *(evidence_lines or ["  (none)"]),
            "approve with: review approve <id> --text-hash <hash> --binding-version <ver> --operator <name>",
            "there is no approve-all command",
        ]
    )


def approve(
    store: Store,
    config: AppConfig,
    draft_id: str,
    expected_text_hash: str,
    binding_version: str,
    operator: str,
) -> str:
    if store.paused():
        raise HaltError(Halt("PAUSED", store.runtime_get("pause_reason") or "paused"))
    draft = store.get_draft(draft_id)
    if draft is None:
        raise HaltError(Halt("REVIEW_MISSING", f"draft {draft_id} not found"))
    if draft.status not in {"draft"}:
        raise HaltError(Halt("REVIEW_STATE", f"draft status is {draft.status}"))
    current_hash = sha256_text(draft.text or "")
    if current_hash != expected_text_hash or (draft.text_hash and draft.text_hash != expected_text_hash):
        raise HaltError(Halt("REVIEW_HASH", "text hash mismatch; re-confirm the exact draft"))
    if binding_version != config.binding.binding_version or binding_version != draft.binding_version:
        raise HaltError(Halt("BINDING_CHANGED", "binding version mismatch; re-confirm target group"))
    if draft.conversation_key != config.binding.conversation_key:
        raise HaltError(Halt("GROUP_UNKNOWN", "draft conversation is not the bound group"))
    return store.create_approval(draft, operator, expected_text_hash, binding_version, config.approval_ttl_seconds)


def reject(store: Store, draft_id: str, operator: str) -> None:
    draft = store.get_draft(draft_id)
    if draft is None:
        raise HaltError(Halt("REVIEW_MISSING", f"draft {draft_id} not found"))
    store.set_draft_status(draft_id, "rejected", {"operator": operator})
