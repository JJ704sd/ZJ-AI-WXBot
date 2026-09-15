"""T4 fixed-text send prep. Does not call M3 or pick native @ targets."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any
from uuid import uuid4

from wechat_agent_poc.config import AppConfig, load_config
from wechat_agent_poc.live_guard import live_send_blockers
from wechat_agent_poc.t0_check import t0_report

ACK_BUDGET = 3


def new_t4_run_id() -> str:
    return "t4-20260915-" + uuid4().hex[:8]


def ack_text(run_id: str, index: int) -> str:
    if index < 1 or index > ACK_BUDGET:
        raise ValueError("T4 ACK index is outside the authorized budget")
    return f"POC-ACK-{run_id}-{index:03d}"


class AtomicSendBudget:
    def __init__(self, path: Path, *, total: int = ACK_BUDGET):
        self.path = path
        self.total = total
        if not path.exists():
            self._write({"total": total, "consumed": 0, "uncertain": False})

    def remaining(self) -> int:
        data = self._read()
        if data.get("uncertain"):
            return 0
        return max(0, int(data["total"]) - int(data["consumed"]))

    def try_consume(self) -> int | None:
        data = self._read()
        if data.get("uncertain"):
            return None
        consumed = int(data["consumed"])
        if consumed >= int(data["total"]):
            return None
        index = consumed + 1
        data["consumed"] = index
        self._write(data)
        return index

    def refund_last(self) -> None:
        data = self._read()
        consumed = int(data["consumed"])
        if consumed > 0 and not data.get("uncertain"):
            data["consumed"] = consumed - 1
            self._write(data)

    def mark_uncertain(self) -> None:
        data = self._read()
        data["uncertain"] = True
        self._write(data)

    def _read(self) -> dict[str, Any]:
        return json.loads(self.path.read_text(encoding="utf-8"))

    def _write(self, data: dict[str, Any]) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.path.with_suffix(self.path.suffix + ".tmp")
        tmp.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        tmp.replace(self.path)


def t4_report(config: AppConfig) -> dict[str, object]:
    run_id = new_t4_run_id()
    blockers = list(live_send_blockers(config))
    if not str(config.window.observation_path or "").strip() and config.window.observer != "weixin_ui":
        blockers.append("window.observation_path is empty")
    if config.adapters.sender == "desktop_observed" and not config.allow_live_send:
        blockers.append("ObservedDesktopSender does not drive WeChat UI")
    if config.model.provider not in {"mock", "none", ""}:
        blockers.append("T4 refuses a live model provider")
    unique = list(dict.fromkeys(blockers))
    ready = not unique
    return {
        "stage": "T4",
        "spec_version": "v0.4",
        "run_id": run_id,
        "authorization_ref": config.authorization_ref,
        "mode": config.mode,
        "allow_live_send": config.allow_live_send,
        "model_called": 0,
        "native_mention": "deferred_not_selected",
        "budget_total": ACK_BUDGET,
        "send_attempts": 0,
        "send_confirmed": 0,
        "send_uncertain": 0,
        "ack_texts": [ack_text(run_id, index) for index in range(1, ACK_BUDGET + 1)],
        "t0": t0_report(config),
        "g_send_blockers": unique,
        "ui_send_implemented": bool(config.allow_live_send and config.adapters.sender == "desktop_observed"),
        "window_top_level_title_note": "Weixin top-level HWND title is not the group name; title-only matching is refused",
        "prior_stages": {
            "T1": "部分通过且有限制",
            "T2": "部分通过且有限制",
            "T2-03": "未执行",
            "T2-03_reason": "operator has no native @all permission in this group",
            "T3": "独立完成；T4 does not call M3",
        },
        "missing_live_inputs": _missing_live_inputs(config),
        "verdict": "通过当前限定场景" if ready else "未执行",
        "note": "T4 live ACKs use weixin_ui selected-chat title; local bubbles are not receive proof",
    }


def t4_from_path(path: str | Path) -> dict[str, object]:
    return t4_report(load_config(path))


def assert_t4_send_permitted(config: AppConfig) -> None:
    from wechat_agent_poc.models import Halt, HaltError

    report = t4_report(config)
    blockers = list(report["g_send_blockers"])
    if blockers:
        raise HaltError(
            Halt(
                "WINDOW_MISMATCH",
                "T4 live send is blocked",
                {"blockers": blockers, "submit_stage": "not_sent"},
            )
        )


def _missing_live_inputs(config: AppConfig) -> list[str]:
    missing: list[str] = []
    if len(config.receivers) < 2:
        missing.append("name wecom and wechat receive verifiers")
    if not str(config.window.observation_path or "").strip() and config.window.observer != "weixin_ui":
        missing.append("foreground window observation of 示例混合群")
    if config.mode != "manual_send" or not config.allow_live_send:
        missing.append("gitignored T4 config with mode=manual_send and top-level allow_live_send=true")
    missing.append("operator confirm after ACK 1 before ACK 2 and 3")
    return missing


def execute_t4_send(
    config: AppConfig,
    index: int,
    *,
    observe=None,
    send=None,
) -> dict[str, Any]:
    from wechat_agent_poc.models import Halt, HaltError
    from wechat_agent_poc.sender import ObservedDesktopSender
    from wechat_agent_poc.wechat_ui import observe_selected_chat, send_observed_text, window_from_observation

    assert_t4_send_permitted(config)
    if index != 1:
        raise HaltError(
            Halt(
                "WINDOW_MISMATCH",
                "ACK 2 and 3 wait for dual-end confirmation of ACK 1",
                {"submit_stage": "not_sent", "index": index},
            )
        )
    state_path = config.data_dir / "t4-state.json"
    if state_path.exists():
        state = json.loads(state_path.read_text(encoding="utf-8"))
    else:
        run_id = new_t4_run_id()
        state = {
            "run_id": run_id,
            "ack1_receive_confirmed": False,
            "authorization_ref": config.authorization_ref,
        }
        state_path.parent.mkdir(parents=True, exist_ok=True)
        state_path.write_text(json.dumps(state, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    run_id = str(state["run_id"])
    text = ack_text(run_id, index)
    observe_fn = observe or observe_selected_chat
    payload = observe_fn(expected_display_name=config.binding.display_name)
    window = window_from_observation(config.binding, payload)
    ok, why = config.binding.matches_window(window.as_mapping())
    if not ok:
        raise HaltError(Halt("WINDOW_MISMATCH", why, {"submit_stage": "not_sent"}))
    budget = AtomicSendBudget(config.data_dir / "t4-budget.json")
    consumed = budget.try_consume()
    if consumed != index:
        if consumed is not None:
            budget.refund_last()
        raise HaltError(
            Halt(
                "WINDOW_MISMATCH",
                "T4 send budget rejected this index",
                {"submit_stage": "not_sent", "index": index, "consumed": consumed, "remaining": budget.remaining()},
            )
        )
    sender = ObservedDesktopSender(ui_send=send or send_observed_text)
    try:
        result = sender.send_text(config.binding, text, window)
    except HaltError as exc:
        if exc.halt.details.get("submit_stage") == "not_sent":
            budget.refund_last()
        else:
            budget.mark_uncertain()
        raise
    record = {
        "stage": "T4",
        "run_id": run_id,
        "index": index,
        "text": text,
        "model_called": 0,
        "native_mention": "deferred_not_selected",
        "submit_stage": "submitted",
        "result": result.status,
        "note": result.note,
        "receivers": list(config.receivers),
        "verdict": "部分通过且有限制",
        "receive_confirmed": False,
    }
    dest = config.data_dir / "runs" / run_id
    dest.mkdir(parents=True, exist_ok=True)
    (dest / f"ack-{index:03d}.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return record
