"""Observe the selected Weixin chat title and submit text only to that session."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

from wechat_agent_poc.models import Binding, Halt, HaltError, SendResult, WindowState

SCRIPT = Path(__file__).with_name("weixin_uia.ps1")
COUNT_SUFFIX = re.compile(r"\s*\(\d+\)\s*$")


def normalize_chat_title(name: str) -> str:
    return COUNT_SUFFIX.sub("", (name or "").strip())


def titles_match(observed: str, expected: str) -> bool:
    left = normalize_chat_title(observed)
    right = normalize_chat_title(expected)
    return bool(left) and left == right


def observe_selected_chat(*, expected_display_name: str, runner=None) -> dict[str, object]:
    payload = _run_uia({"Action": "observe"}, runner=runner)
    selected = str(payload.get("selected") or "")
    if not titles_match(selected, expected_display_name):
        raise HaltError(
            Halt(
                "WINDOW_MISMATCH",
                "selected Weixin chat is not the bound group",
                {
                    "submit_stage": "not_sent",
                    "observed_title": normalize_chat_title(selected),
                    "expected": expected_display_name,
                },
            )
        )
    return payload


def send_observed_text(binding: Binding, text: str, window: WindowState | None) -> SendResult:
    if window is None:
        raise HaltError(Halt("WINDOW_MISMATCH", "send requires observed window", {"submit_stage": "not_sent"}))
    if window.located_by != "uia_selected_chat_title":
        raise HaltError(Halt("WINDOW_MISMATCH", "Weixin UI send requires uia_selected_chat_title", {"submit_stage": "not_sent"}))
    if not titles_match(window.display_name, binding.display_name):
        raise HaltError(Halt("WINDOW_MISMATCH", "observed title does not match binding", {"submit_stage": "not_sent"}))
    payload = _run_uia({"Action": "send", "Text": text, "Expect": binding.display_name})
    status = str(payload.get("status") or "unknown")
    if status == "not_sent":
        raise HaltError(
            Halt(
                "WINDOW_MISMATCH",
                str(payload.get("message") or "Weixin UI did not submit"),
                {"submit_stage": "not_sent"},
            )
        )
    if status != "submitted":
        raise HaltError(
            Halt(
                "SENDING_UNCERTAIN",
                str(payload.get("message") or "Weixin UI submit was not confirmed"),
                {"submit_stage": "unknown"},
            )
        )
    return SendResult("local_ok", "weixin_ui submitted; local bubble is not receive proof", local_bubble=True)


def window_from_observation(binding: Binding, payload: dict[str, object]) -> WindowState:
    selected = str(payload.get("selected") or binding.display_name)
    return WindowState(
        account_alias=binding.account_alias,
        account_wxid=binding.account_wxid,
        display_name=normalize_chat_title(selected),
        conversation_key=binding.conversation_key,
        details=normalize_chat_title(selected),
        member_features=(),
        focus=True,
        rebuilt=False,
        located_by="uia_selected_chat_title",
    )


class WeixinUiWindowObserver:
    def observe(self, binding: Binding) -> WindowState:
        payload = observe_selected_chat(expected_display_name=binding.display_name)
        return window_from_observation(binding, payload)


def _run_uia(params: dict[str, str], runner=None) -> dict[str, object]:
    if runner is not None:
        return runner(params)
    if not SCRIPT.is_file():
        raise HaltError(Halt("WINDOW_MISMATCH", "weixin_uia.ps1 is missing", {"submit_stage": "not_sent"}))
    command = [
        "powershell",
        "-NoProfile",
        "-STA",
        "-ExecutionPolicy",
        "Bypass",
        "-File",
        str(SCRIPT),
    ]
    for key, value in params.items():
        command.extend([f"-{key}", str(value)])
    try:
        completed = subprocess.run(command, check=False, capture_output=True)
    except OSError as exc:
        raise HaltError(Halt("WINDOW_MISMATCH", f"cannot start Weixin UI helper: {exc}", {"submit_stage": "not_sent"})) from exc
    stdout = (completed.stdout or b"").decode("utf-8", errors="replace")
    stderr = (completed.stderr or b"").decode("utf-8", errors="replace")
    body = stdout.strip().splitlines()
    json_line = next((line for line in reversed(body) if line.startswith("{")), "")
    if not json_line:
        raise HaltError(
            Halt(
                "WINDOW_MISMATCH",
                "Weixin UI helper failed",
                {"submit_stage": "not_sent", "stderr": stderr[-300:]},
            )
        )
    try:
        payload = json.loads(json_line)
    except json.JSONDecodeError as exc:
        raise HaltError(Halt("WINDOW_MISMATCH", "Weixin UI helper returned non-JSON", {"submit_stage": "not_sent"})) from exc
    if not isinstance(payload, dict):
        raise HaltError(Halt("WINDOW_MISMATCH", "Weixin UI helper returned an unexpected payload", {"submit_stage": "not_sent"}))
    return payload
