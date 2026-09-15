from __future__ import annotations

import json
from pathlib import Path
from typing import Protocol

from wechat_agent_poc.models import Binding, Halt, HaltError, WindowState

FORBIDDEN_LOCATED_BY = {"binding_map", "config_synthetic", "name_search_only"}


class WindowObserver(Protocol):
    def observe(self, binding: Binding) -> WindowState: ...


class ManualFileWindowObserver:
    """Operator-supplied observation JSON. This is not a live UI scrape."""

    def __init__(self, path: Path):
        self.path = path

    def observe(self, binding: Binding) -> WindowState:
        if not self.path.is_file():
            raise HaltError(
                Halt(
                    "WINDOW_MISMATCH",
                    "window observation file is missing",
                    {"path": str(self.path), "submit_stage": "not_sent"},
                )
            )
        data = json.loads(self.path.read_text(encoding="utf-8"))
        located_by = str(data.get("located_by") or "")
        if located_by in FORBIDDEN_LOCATED_BY or not located_by:
            raise HaltError(
                Halt(
                    "WINDOW_MISMATCH",
                    "observation file must come from a real window check, not config/binding/name search",
                    {"located_by": located_by, "submit_stage": "not_sent"},
                )
            )
        features = data.get("member_features") or []
        if isinstance(features, str):
            features = [features]
        return WindowState(
            account_alias=str(data.get("account_alias") or binding.account_alias),
            account_wxid=str(data.get("account_wxid") or binding.account_wxid),
            display_name=str(data.get("display_name") or ""),
            conversation_key=str(data.get("conversation_key") or ""),
            details=str(data.get("details") or ""),
            member_features=tuple(str(item) for item in features),
            focus=bool(data.get("focus", True)),
            rebuilt=bool(data.get("rebuilt", False)),
            located_by=located_by,
        )


def load_window_observer(observer: str, path: Path | None) -> WindowObserver | None:
    if observer in ("", "none"):
        return None
    if observer == "manual_file":
        if path is None:
            raise HaltError(Halt("WINDOW_MISMATCH", "window.observation_path is required", {"submit_stage": "not_sent"}))
        return ManualFileWindowObserver(path)
    if observer == "weixin_ui":
        from wechat_agent_poc.wechat_ui import WeixinUiWindowObserver

        return WeixinUiWindowObserver()
    raise HaltError(
        Halt(
            "WINDOW_MISMATCH",
            f"unsupported window observer {observer!r}",
            {"submit_stage": "not_sent"},
        )
    )
