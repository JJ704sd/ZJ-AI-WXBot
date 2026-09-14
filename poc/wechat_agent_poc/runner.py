from __future__ import annotations

import time

from wechat_agent_poc.config import AppConfig
from wechat_agent_poc.models import Event, Halt, HaltError
from wechat_agent_poc.responder import Responder
from wechat_agent_poc.store import Store

HALT_ON = {
    "VERIFY_PROMPT",
    "ACCOUNT_LIMIT",
    "DISCONNECT",
    "ACCOUNT_UNKNOWN",
    "GROUP_UNKNOWN",
    "READ_FAILURE",
    "DB_LOCK",
    "NON_TEST_CONTENT",
    "WINDOW_MISMATCH",
}


class Runner:
    def __init__(self, config: AppConfig, store: Store, reader, responder: Responder | None):
        self.config = config
        self.store = store
        self.reader = reader
        self.responder = responder

    def recover(self) -> list[str]:
        return self.store.recover_sending()

    def run_bounded(self, *, max_cycles: int = 1, max_seconds: float = 30, sleep_s: float = 0.0) -> dict:
        recovered = self.recover()
        started = time.monotonic()
        cycles = 0
        ingested = 0
        drafts = 0
        halted = None
        try:
            while cycles < max_cycles and (time.monotonic() - started) < max_seconds:
                if self.store.paused():
                    halted = self.store.runtime_get("pause_reason") or "PAUSED"
                    break
                events = self.reader.read_new_messages(self.config.binding, self.store)
                cycles += 1
                ingested += len(events)
                for event in events:
                    self._check_halt(event)
                    if self.config.mode == "read_only":
                        continue
                    if self.responder is None:
                        continue
                    decision = self.responder.decide_reply(event)
                    created = self.store.create_draft(
                        event,
                        decision.action,
                        decision.text,
                        decision.evidence_keys,
                        decision.reason,
                        self.config.binding.binding_version,
                    )
                    if created is not None:
                        drafts += 1
                if sleep_s:
                    time.sleep(sleep_s)
        except HaltError as exc:
            self.store.set_halt(exc.halt.reason, exc.halt.message)
            halted = exc.halt.reason
        return {
            "cycles": cycles,
            "ingested": ingested,
            "drafts": drafts,
            "recovered_sending": recovered,
            "halted": halted,
            "paused": self.store.paused(),
            "mode": self.config.mode,
        }

    def _check_halt(self, event: Event) -> None:
        if event.halt_reason in HALT_ON:
            raise HaltError(Halt(event.halt_reason, event.halt_reason))
        text = event.text or ""
        if "验证" in text and "限制" in text:
            raise HaltError(Halt("VERIFY_PROMPT", "verification or restriction prompt observed"))
        if looks_like_customer_content(text):
            raise HaltError(Halt("NON_TEST_CONTENT", "possible real customer content; not uploaded"))


def looks_like_customer_content(text: str) -> bool:
    markers = ("真实客户", "生产运单", "LIVE-CUSTOMER")
    return any(marker in text for marker in markers)


def inject_halt(store: Store, reason: str) -> None:
    store.set_halt(reason, f"injected:{reason}")
