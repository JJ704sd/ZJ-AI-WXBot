from __future__ import annotations

import re
from dataclasses import dataclass

from wechat_agent_poc.models import Decision, Event

PRICE_RE = re.compile(r"(?:USD|CNY|RMB|EUR|HKD|\$|¥)\s?\d+(?:\.\d+)?|\d+(?:\.\d+)?\s?(?:USD|CNY|RMB|EUR|HKD|元)", re.I)
DATE_RE = re.compile(r"\d{1,2}/\d{1,2}|\d{4}-\d{2}-\d{2}")
LEAD_RE = re.compile(r"\d+\s*个工作日|\d+\s*天|\d+\s*小时")
WEIGHT_RE = re.compile(r"\d+(?:\.\d+)?\s?(?:kg|KG|公斤)")
VOLUME_RE = re.compile(r"\d+(?:\.\d+)?\s?(?:cbm|CBM|m3|立方米)")
NUMBER_RE = re.compile(r"\d+(?:\.\d+)?")
UNITISH = re.compile(r"(USD|CNY|RMB|EUR|kg|CBM|立方米|工作日|小时|天|/kg)", re.I)


@dataclass
class FactCheck:
    ok: bool
    reason: str


def collect_source_text(event: Event, context: list[Event]) -> str:
    parts = [item.text or "" for item in context]
    parts.append(event.text or "")
    return "\n".join(parts)


def validate_decision(decision: Decision, event: Event, context: list[Event], max_chars: int) -> FactCheck:
    allowed_keys = {item.event_key for item in context}
    allowed_keys.add(event.event_key)
    if decision.action not in ("draft", "ignore", "needs_review"):
        return FactCheck(False, "invalid_action")
    if decision.conversation_key != event.conversation_key:
        return FactCheck(False, "model_routed_conversation")
    for key in decision.evidence_keys:
        if key not in allowed_keys:
            return FactCheck(False, "evidence_outside_context")
    if decision.action != "draft":
        return FactCheck(True, "non_draft")
    if not decision.text or not decision.text.strip():
        return FactCheck(False, "empty_draft")
    if len(decision.text) > max_chars:
        return FactCheck(False, "draft_too_long")
    source = collect_source_text(event, context)
    invented = invented_claims(decision.text, source)
    if invented:
        return FactCheck(False, invented)
    if not decision.evidence_keys:
        return FactCheck(False, "missing_evidence")
    return FactCheck(True, "ok")


def invented_claims(draft: str, source: str) -> str:
    for pattern, label in (
        (PRICE_RE, "price"),
        (DATE_RE, "date"),
        (LEAD_RE, "lead_time"),
        (WEIGHT_RE, "weight"),
        (VOLUME_RE, "volume"),
    ):
        for match in pattern.findall(draft):
            token = match if isinstance(match, str) else match[0]
            if token and token not in source:
                return f"invented_{label}"
    for match in NUMBER_RE.findall(draft):
        if match not in source:
            if UNITISH.search(draft):
                return "invented_number"
    return ""


def looks_like_untrusted_instruction(text: str) -> bool:
    lowered = text.lower()
    needles = (
        "忽略规则",
        "忽略以上",
        "改发其他群",
        "改发到",
        "读取本地",
        "读取 c:",
        "ignore the rules",
        "send to another group",
        "read local file",
    )
    return any(item in text or item in lowered for item in needles)
