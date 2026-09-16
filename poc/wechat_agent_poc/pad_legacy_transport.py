"""Loopback HTTP transport for non-MAX Windows 861. No retries, no credential logs."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Mapping
from urllib import error, parse, request
import json

from wechat_agent_poc.api_channel import MAX_CALLBACK_BYTES, ChannelError
from wechat_agent_poc.general_qa import NoRedirect

LEGACY_PROVIDER = "wechatpadpro_legacy"
LEGACY_PROVIDER_VERSION = "legacy-861/20250822"
PATH_HTTP_SYNC = "/message/HttpSyncMsg"
PATH_SEND_TEXT = "/message/SendTextMessage"
PATH_LOGIN_STATUS = "/login/GetLoginStatus"
PATH_ONLINE_INFO = "/equipment/GetOnlineInfo"
PATH_CHATROOM_INFO = "/group/GetChatRoomInfo"
PATH_CHATROOM_MEMBERS = "/group/GetChatroomMemberDetail"
PATH_QW_CHATROOM = "/qy/QWGetChatroomInfo"
PATH_WS_SYNC = "/ws/GetSyncMsg"
PATH_GEN_AUTH = "/admin/GenAuthKey1"
WRITE_PATHS = frozenset({PATH_SEND_TEXT, PATH_GEN_AUTH})
LOOPBACK_HOSTS = frozenset({"127.0.0.1", "localhost", "::1"})
DEFAULT_TIMEOUT_SECONDS = 8.0
RECEIVE_CHANNELS = ("http_sync", "websocket", "webhook")


@dataclass(frozen=True)
class RecordedCall:
    method: str
    path: str
    payload: dict[str, Any] | None
    query_key_present: bool
    header_names: tuple[str, ...]
    timeout: float


@dataclass(frozen=True)
class TransportResult:
    http_status: int
    body: dict[str, Any] | None
    reason: str
    elapsed_hint: str = ""


@dataclass(frozen=True)
class AuthGenerateVerdict:
    http_200: bool
    business_ok: bool
    device_key_issued: bool
    outcome: str
    business_code: Any = None


def require_loopback_base(base_url: str) -> parse.ParseResult:
    parsed = parse.urlparse(base_url)
    host = (parsed.hostname or "").lower()
    if parsed.scheme not in {"http", "https"}:
        raise ChannelError("invalid_base_url", "legacy 861 base_url must be http(s)")
    if host not in LOOPBACK_HOSTS:
        raise ChannelError("non_loopback_forbidden", "legacy 861 transport is loopback-only in this round")
    return parsed


def select_receive_channel(selected: tuple[str, ...]) -> str:
    if len(selected) != 1:
        raise ChannelError("multiple_receive_channels", "enable exactly one receive channel")
    channel = selected[0]
    if channel not in RECEIVE_CHANNELS:
        raise ChannelError("unknown_receive_channel", f"unsupported receive channel {channel!r}")
    if channel != "http_sync":
        raise ChannelError(
            "receive_channel_unavailable",
            "websocket and webhook are not selected; HttpSyncMsg is the only receive path this round",
        )
    return channel


def sync_count_body(count: int) -> dict[str, int]:
    if isinstance(count, bool) or not isinstance(count, int) or count < 1:
        raise ChannelError(
            "unbounded_sync_forbidden",
            "HttpSyncMsg requires an explicit positive Count; empty body and Count=0 are refused",
        )
    return {"Count": count}


def business_code(body: Mapping[str, Any] | None) -> Any:
    if not isinstance(body, Mapping):
        return None
    if "Code" in body:
        return body.get("Code")
    return body.get("code")


def classify_gateway_response(http_status: int, body: Mapping[str, Any] | None, reason: str) -> str:
    if reason == "timeout" or http_status == 0:
        return "timeout"
    if reason in {"invalid_json", "payload_too_large"}:
        return reason
    if http_status != 200:
        return "http_error"
    if not isinstance(body, Mapping):
        return "unknown_envelope"
    code = business_code(body)
    if code is None:
        return "unknown_envelope"
    if code == 200:
        return "business_ok"
    return "business_error"


def device_key_issued(data: Any) -> bool:
    """True when a non-empty device key exists. Never returns the value."""
    if isinstance(data, str):
        return bool(data.strip())
    if isinstance(data, list):
        return any(isinstance(item, str) and bool(item.strip()) for item in data) or any(
            device_key_issued(item) for item in data if isinstance(item, dict)
        )
    if isinstance(data, dict):
        for key, value in data.items():
            lower = str(key).lower()
            if lower in {"authkey", "auth_key", "license", "devicekey", "device_key"} and isinstance(value, str):
                return bool(value.strip())
            if device_key_issued(value):
                return True
    return False


def classify_auth_generate(http_status: int, body: Mapping[str, Any] | None, *, reason: str = "ok") -> AuthGenerateVerdict:
    """HTTP 200 is not success. Observed failure: code=1 and no device key."""
    http_ok = http_status == 200
    code = business_code(body)
    data = body.get("Data") if isinstance(body, Mapping) else None
    if data is None and isinstance(body, Mapping):
        data = body.get("data")
    issued = device_key_issued(data)
    classified = classify_gateway_response(http_status, body, reason)
    if classified == "timeout":
        outcome = "timeout"
    elif classified == "business_ok" and issued:
        outcome = "issued"
    elif classified == "business_ok" and not issued:
        outcome = "http_200_without_key"
    elif classified == "business_error":
        outcome = "business_error"
    else:
        outcome = classified
    return AuthGenerateVerdict(
        http_200=http_ok,
        business_ok=classified == "business_ok" and issued,
        device_key_issued=issued,
        outcome=outcome,
        business_code=code,
    )


def redact_mapping(raw: Mapping[str, Any] | None) -> dict[str, Any] | None:
    if raw is None:
        return None
    out: dict[str, Any] = {}
    for key, value in raw.items():
        lower = str(key).lower()
        if any(token in lower for token in ("key", "token", "secret", "password", "auth", "license")):
            if isinstance(value, str):
                out[key] = {"present": bool(value.strip()), "len": len(value)}
            else:
                out[key] = {"present": value not in (None, "", [], {})}
        elif isinstance(value, dict):
            out[key] = redact_mapping(value)
        else:
            out[key] = value
    return out


class Legacy861Transport:
    """One-shot loopback HTTP. Timeouts stay unknown; callers must not retry writes."""

    def __init__(self, opener=None):
        self._opener = opener
        self.calls: list[RecordedCall] = []

    def request(
        self,
        method: str,
        url: str,
        *,
        payload: dict[str, Any] | None = None,
        query_key: str = "",
        timeout: float = DEFAULT_TIMEOUT_SECONDS,
        extra_headers: Mapping[str, str] | None = None,
    ) -> TransportResult:
        require_loopback_base(url)
        parsed = parse.urlparse(url)
        path = parsed.path or "/"
        headers = {"Content-Type": "application/json", **dict(extra_headers or {})}
        self.calls.append(
            RecordedCall(
                method=method.upper(),
                path=path,
                payload=redact_mapping(payload),
                query_key_present=bool(query_key),
                header_names=tuple(headers),
                timeout=timeout,
            )
        )
        if query_key:
            query = parse.parse_qsl(parsed.query, keep_blank_values=True)
            query = [(name, value) for name, value in query if name != "key"]
            query.append(("key", query_key))
            url = parse.urlunparse(parsed._replace(query=parse.urlencode(query)))
        body = None if payload is None else json.dumps(payload, ensure_ascii=False).encode("utf-8")
        req = request.Request(url, data=body, headers=headers, method=method.upper())
        opener = self._opener or request.build_opener(NoRedirect())
        try:
            with opener.open(req, timeout=timeout) as response:
                raw = response.read(MAX_CALLBACK_BYTES + 1)
                status = int(getattr(response, "status", 200))
        except error.HTTPError as exc:
            return TransportResult(int(exc.code), None, "http_error")
        except (error.URLError, TimeoutError, OSError):
            return TransportResult(0, None, "timeout")
        if len(raw) > MAX_CALLBACK_BYTES:
            return TransportResult(status, None, "payload_too_large")
        try:
            parsed_body = json.loads(raw.decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError):
            return TransportResult(status, None, "invalid_json")
        if not isinstance(parsed_body, dict):
            return TransportResult(status, None, "invalid_json")
        return TransportResult(status, parsed_body, "ok")
