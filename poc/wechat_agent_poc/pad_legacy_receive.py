"""Single-consumer bounded HttpSyncMsg receiver. Observe-only; no webhook/WS."""
from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Callable
import json
import time

from wechat_agent_poc.api_channel import ChannelError
from wechat_agent_poc.api_config import isoformat
from wechat_agent_poc.clock import Clock, SystemClock
from wechat_agent_poc.pad_legacy_decoder import DecodeItem, decode_gateway_items
from wechat_agent_poc.pad_legacy_transport import (
    DEFAULT_TIMEOUT_SECONDS,
    PATH_HTTP_SYNC,
    PATH_WS_SYNC,
    Legacy861Transport,
    classify_gateway_response,
    select_receive_channel,
    sync_count_body,
)

DEFAULT_COUNT = 10
DEFAULT_MAX_SECONDS = 120.0
DEFAULT_INTERVAL_SECONDS = 2.5
WATERMARK_KIND = "id_set"
FORBIDDEN_CURSOR_KEYS = frozenset({"max_native_id", "last_id", "cursor", "high_water", "max_id"})


@dataclass
class FileWatermark:
    """Seen-id set. Native IDs are not a monotonic or time-ordered cursor."""

    path: Path
    ids: set[str] = field(default_factory=set)

    @classmethod
    def load(cls, path: Path) -> FileWatermark:
        if not path.is_file():
            return cls(path=path, ids=set())
        raw = json.loads(path.read_text(encoding="utf-8"))
        if not isinstance(raw, dict):
            raise ChannelError("watermark_invalid", "watermark file must be a JSON object")
        forbidden = FORBIDDEN_CURSOR_KEYS.intersection(raw)
        if forbidden:
            raise ChannelError(
                "max_id_cursor_forbidden",
                "native message IDs are not assumed ordered; max-id cursors are refused",
            )
        kind = raw.get("kind")
        if kind not in (None, WATERMARK_KIND):
            raise ChannelError("watermark_invalid", f"unsupported watermark kind {kind!r}")
        ordering = raw.get("ordering")
        if ordering not in (None, "unknown"):
            raise ChannelError("watermark_invalid", "watermark ordering must stay unknown")
        ids = {str(item) for item in (raw.get("native_message_ids") or [])}
        return cls(path=path, ids=ids)

    def seen(self, native_id: str) -> bool:
        return native_id in self.ids

    def remember(self, native_id: str) -> None:
        self.ids.add(native_id)
        self.path.parent.mkdir(parents=True, exist_ok=True)
        payload = {
            "kind": WATERMARK_KIND,
            "ordering": "unknown",
            "monotonic_id": False,
            "native_message_ids": sorted(self.ids),
        }
        self.path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


@dataclass(frozen=True)
class PullResult:
    classified: str
    http_status: int
    items: tuple[DecodeItem, ...]
    duplicates: tuple[str, ...]
    stored: tuple[str, ...]
    count: int


class Legacy861Receiver:
    """Observe-only HttpSync. Dedup is an ID set; IDs are not a time or max-id cursor."""

    def __init__(
        self,
        *,
        transport: Legacy861Transport,
        base_url: str,
        device_key: str,
        bound_account: str,
        bound_conversation: str,
        session_epoch: str = "unknown",
        self_key: str = "",
        watermark: FileWatermark | None = None,
        clock: Clock | None = None,
        sleep: Callable[[float], None] | None = None,
        receive_channels: tuple[str, ...] = ("http_sync",),
    ):
        self.transport = transport
        self.base_url = base_url.rstrip("/")
        self._device_key = device_key
        self.bound_account = bound_account
        self.bound_conversation = bound_conversation
        self.session_epoch = session_epoch
        self.self_key = self_key
        self.watermark = watermark
        self.clock = clock or SystemClock()
        self.sleep = sleep or time.sleep
        self.receive_channel = select_receive_channel(receive_channels)
        self.pulls = 0

    def pull_once(self, count: int = DEFAULT_COUNT) -> PullResult:
        body = sync_count_body(count)
        if not self._device_key:
            raise ChannelError("missing_credential", "device key is required for HttpSyncMsg")
        result = self.transport.request(
            "POST",
            self.base_url + PATH_HTTP_SYNC,
            payload=body,
            query_key=self._device_key,
            timeout=DEFAULT_TIMEOUT_SECONDS,
        )
        self.pulls += 1
        classified = classify_gateway_response(result.http_status, result.body, result.reason)
        _schema, items = decode_gateway_items(
            result.http_status,
            result.body,
            result.reason,
            received_at=isoformat(self.clock.now()),
            bound_account=self.bound_account,
            bound_conversation=self.bound_conversation,
            session_epoch=self.session_epoch,
            self_key=self.self_key,
        )
        duplicates: list[str] = []
        stored: list[str] = []
        kept: list[DecodeItem] = []
        for item in items:
            native = item.native_message_id
            if native and self.watermark is not None and self.watermark.seen(native):
                duplicates.append(native)
                kept.append(item)
                continue
            if native and self.watermark is not None and item.action in {"ok", "isolated", "dropped_unbound"}:
                self.watermark.remember(native)
                stored.append(native)
            kept.append(item)
        return PullResult(classified, result.http_status, tuple(kept), tuple(duplicates), tuple(stored), count)

    def run_bounded(
        self,
        *,
        max_seconds: float = DEFAULT_MAX_SECONDS,
        count: int = DEFAULT_COUNT,
        interval_seconds: float = DEFAULT_INTERVAL_SECONDS,
    ) -> list[PullResult]:
        if max_seconds <= 0 or max_seconds > DEFAULT_MAX_SECONDS:
            raise ChannelError("observe_window_invalid", "observe window must be in (0, 120] seconds")
        started = self.clock.now()
        results: list[PullResult] = []
        while _elapsed(self.clock.now(), started) < max_seconds:
            results.append(self.pull_once(count))
            if _elapsed(self.clock.now(), started) >= max_seconds:
                break
            self.sleep(interval_seconds)
        return results

    def refuse_other_channels(self) -> None:
        raise ChannelError("receive_channel_unavailable", f"{PATH_WS_SYNC} is not selected")


def _elapsed(now: datetime, started: datetime) -> float:
    return (now - started).total_seconds()
