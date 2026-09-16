from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any, Mapping
from urllib import error, request
import hmac
import json
import os

from wechat_agent_poc.api_channel import (
    MAX_CALLBACK_BYTES,
    ApiMessageV1,
    ChannelError,
    ChannelEvidence,
    MemberMap,
    OutboundCommand,
    SubmitResult,
    event_key,
    native_id_as_str,
)
from wechat_agent_poc.api_config import ApiConfig, BindingSettings, isoformat
from wechat_agent_poc.clock import Clock, SystemClock
from wechat_agent_poc.general_qa import NoRedirect

GEWE_PROVIDER = "geweapi"
GEWE_PROVIDER_VERSION = "gewe-v2/doc-2026-09-16"
GEWE_CALLBACK_VERSION = "gewe-callback/2"
TOKEN_HEADER = "X-GEWE-TOKEN"
BRIDGE_HEADER = "X-Wechat-Bridge-Token"
PATH_POST_TEXT = "/gewe/v2/api/message/postText"
PATH_CHECK_ONLINE = "/gewe/v2/api/login/checkOnline"
PATH_PROFILE = "/gewe/v2/api/personal/getProfile"
PATH_MEMBER_DETAIL = "/gewe/v2/api/group/getChatroomMemberDetail"
WRITE_PATHS = frozenset({PATH_POST_TEXT})
ROOM_SUFFIXES = ("@chatroom",)
SYSTEM_PAUSE = {
    "LOGOUT": "logged_out",
    "LOGIN_ERROR": "logged_out",
    "RECONNECT_FAIL": "offline",
}
HTTP_TIMEOUT_SECONDS = 8.0


def resolve_env_ref(ref: str, environ: Mapping[str, str] | None = None) -> str:
    env = environ if environ is not None else os.environ
    text = (ref or "").strip()
    if not text:
        return ""
    if text.startswith("value:") or text.startswith("literal:"):
        raise ChannelError("inline_secret_forbidden", "credentials must come from env refs, not inline config")
    if text.startswith("env:"):
        return str(env.get(text[4:], "") or "")
    return str(env.get(text, "") or "")


def gewe_id_as_str(value: Any, *, field: str) -> str:
    if value is None or value is True or value is False:
        raise ChannelError("missing_field", f"{field} is required")
    if isinstance(value, float):
        raise ChannelError("invalid_native_id", f"{field} must not pass through float conversion")
    if isinstance(value, int):
        return str(value)
    return native_id_as_str(value)


@dataclass
class RecordedCall:
    path: str
    payload: dict[str, Any]
    header_names: tuple[str, ...]
    token_present: bool


class GeweTransport:
    """One-shot HTTP POST. No retries, no credentialed redirects."""

    def __init__(self, opener=None, clock=None):
        self._opener = opener
        self._clock = clock
        self.calls: list[RecordedCall] = []

    def post(self, url: str, headers: Mapping[str, str], payload: dict[str, Any], *, timeout: float) -> tuple[int, dict[str, Any] | None, str]:
        token_present = bool(headers.get(TOKEN_HEADER))
        self.calls.append(
            RecordedCall(
                path=_path_of(url),
                payload=dict(payload),
                header_names=tuple(headers),
                token_present=token_present,
            )
        )
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        req = request.Request(url, data=body, headers=dict(headers), method="POST")
        opener = self._opener or request.build_opener(NoRedirect())
        try:
            with opener.open(req, timeout=timeout) as response:
                raw = response.read(MAX_CALLBACK_BYTES + 1)
                status = getattr(response, "status", 200)
        except error.HTTPError as exc:
            return exc.code, None, "http_error"
        except (error.URLError, TimeoutError, OSError):
            return 0, None, "timeout"
        finally:
            if hasattr(req, "remove_header"):
                try:
                    req.remove_header(TOKEN_HEADER)
                except KeyError:
                    pass
        if len(raw) > MAX_CALLBACK_BYTES:
            return status, None, "payload_too_large"
        try:
            parsed = json.loads(raw.decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError):
            return status, None, "invalid_json"
        if not isinstance(parsed, dict):
            return status, None, "invalid_json"
        return int(status), parsed, "ok"


def _path_of(url: str) -> str:
    if "://" not in url:
        return url
    host_and_path = url.split("://", 1)[1]
    slash = host_and_path.find("/")
    return host_and_path[slash:] if slash >= 0 else "/"


class GeweChannel:
    """GeWe API v2 adapter. Documented HTTP fields only; no live login in __init__."""

    provider = GEWE_PROVIDER
    provider_version = GEWE_PROVIDER_VERSION

    def __init__(
        self,
        *,
        base_url: str,
        token: str,
        app_id: str,
        bridge_token: str,
        clock: Clock | None = None,
        transport: GeweTransport | None = None,
        allow_network: bool = False,
    ):
        self.base_url = base_url.rstrip("/")
        self._token = token
        self.app_id = app_id
        self.bridge_token = bridge_token
        self.clock = clock or SystemClock()
        self.transport = transport or GeweTransport()
        self.allow_network = allow_network
        self.write_calls: list[OutboundCommand] = []
        self.write_counts: dict[str, int] = {}
        self.capabilities = {
            "receive_text": True,
            "send_text": True,
            "native_mention_send": True,
            "native_mention_receive": False,
            "group_members_scoped": True,
            "callback_ack": True,
            "callback_signature": False,
            "replay_cursor": False,
            "mixed_group_openim": False,
            "history_flag": False,
        }

    @classmethod
    def from_config(
        cls,
        config: ApiConfig,
        *,
        clock: Clock | None = None,
        transport: GeweTransport | None = None,
        environ: Mapping[str, str] | None = None,
        allow_network: bool = False,
    ) -> GeweChannel:
        return cls(
            base_url=resolve_env_ref(config.channel.base_url_ref, environ),
            token=resolve_env_ref(config.channel.credential_ref, environ),
            app_id=resolve_env_ref(config.channel.app_id_ref, environ),
            bridge_token=resolve_env_ref(config.channel.callback_bridge_token_ref, environ),
            clock=clock,
            transport=transport,
            allow_network=allow_network,
        )

    def authenticate_callback(self, headers: Mapping[str, str], body: bytes) -> None:
        """Internal loopback bridge authentication only. This is not vendor_verified."""
        if len(body) > MAX_CALLBACK_BYTES:
            raise ChannelError("payload_too_large", "callback exceeds 256 KiB", 413)
        if body.lstrip().startswith(b"<"):
            raise ChannelError("xml_rejected", "XML callbacks are rejected", 415)
        if not self.bridge_token:
            raise ChannelError(
                "auth_failed",
                "internal bridge token is required; this check does not prove GeWe origin",
                401,
            )
        supplied = headers.get(BRIDGE_HEADER) or headers.get("x-wechat-bridge-token") or ""
        try:
            ok = bool(supplied) and hmac.compare_digest(supplied, self.bridge_token)
        except ValueError:
            ok = False
        if not ok:
            raise ChannelError("auth_failed", "callback bridge authentication failed", 401)

    def normalize(self, raw: Mapping[str, Any], *, received_at: str) -> ApiMessageV1:
        if not isinstance(raw, Mapping):
            raise ChannelError("invalid_json", "event must be a JSON object")
        if raw.get("TypeName") is not None or (isinstance(raw.get("Data"), Mapping) and raw.get("Appid")):
            raise ChannelError("unsupported_version", "gewe-callback/1 is rejected; use gewe-callback/2 flat fields")
        required = ("appid", "wxid", "newMsgId", "msgType", "fromUser", "toUser", "createTime")
        missing = [name for name in required if raw.get(name) in (None, "")]
        if missing:
            raise ChannelError("missing_field", f"missing {','.join(missing)}")
        native = gewe_id_as_str(raw.get("newMsgId"), field="newMsgId")
        account = str(raw["wxid"])
        to_user = str(raw["toUser"])
        from_user = str(raw["fromUser"])
        conversation = to_user if _is_room(to_user) else (from_user if _is_room(from_user) else to_user)
        sender = from_user
        if _is_room(from_user) and not _is_room(to_user):
            conversation = from_user
            sender = to_user
        msg_type = str(raw["msgType"])
        kind, parse_status, text = _classify_msg(msg_type, raw.get("content"))
        is_self_raw = raw.get("isSelf")
        if is_self_raw is True:
            is_self = "true"
        elif is_self_raw is False:
            is_self = "false"
        else:
            is_self = "unknown"
        occurred_at = _unix_to_iso(raw.get("createTime"))
        session_epoch = "unbound"
        identity = "unknown"
        return ApiMessageV1(
            schema_version="wechat-api-event/1",
            provider=self.provider,
            account_key=account,
            conversation_key=conversation,
            native_message_id=native,
            event_key=event_key(self.provider, account, conversation, native),
            session_epoch=session_epoch,
            occurred_at=occurred_at,
            received_at=received_at,
            sender_key=sender,
            identity_status=identity,
            is_self=is_self,
            kind=kind,
            text=text,
            mention_status="unknown",
            mention_keys=(),
            mention_all=False,
            reply_to_message_id=None,
            history_status="unknown",
            parse_status=parse_status,
        )

    def probe(self, binding: BindingSettings) -> ChannelEvidence:
        body = self._read(PATH_CHECK_ONLINE, {"appId": self.app_id})
        online = bool(body.get("data") is True)
        profile = self._read(PATH_PROFILE, {"appId": self.app_id})
        data = profile.get("data") if isinstance(profile.get("data"), dict) else {}
        account = str(data.get("wxid") or "")
        conversation_exists = False
        if binding.conversation_key and account:
            detail = self._read(
                PATH_MEMBER_DETAIL,
                {"appId": self.app_id, "chatroomId": binding.conversation_key, "memberWxids": [account]},
            )
            data = detail.get("data") if detail.get("ret") == 200 else None
            if isinstance(data, list):
                conversation_exists = any(
                    isinstance(item, dict) and str(item.get("userName") or "") == account for item in data
                )
        return ChannelEvidence(
            provider=self.provider,
            provider_version=self.provider_version,
            account_key=account,
            session_epoch="unbound",
            online=online,
            conversation_exists=conversation_exists,
            member_maps=(),
            observed_at=isoformat(self.clock.now()),
            capabilities=dict(self.capabilities),
            unique_account=bool(account) and (not binding.account_key or binding.account_key == account),
            unique_conversation=conversation_exists,
        )

    def resolve_members(self, binding: BindingSettings, candidate_refs: tuple[str, ...]) -> tuple[MemberMap, ...]:
        if not candidate_refs:
            return ()
        if not binding.conversation_key:
            return tuple(MemberMap(ref, None, "out_of_scope") for ref in candidate_refs)
        body = self._read(
            PATH_MEMBER_DETAIL,
            {
                "appId": self.app_id,
                "chatroomId": binding.conversation_key,
                "memberWxids": list(candidate_refs),
            },
        )
        found: dict[str, str] = {}
        data = body.get("data") if body.get("ret") == 200 else None
        if isinstance(data, list):
            for item in data:
                if isinstance(item, dict) and item.get("userName"):
                    found[str(item["userName"])] = str(item["userName"])
        result: list[MemberMap] = []
        for ref in candidate_refs:
            if ref in found:
                result.append(MemberMap(ref, found[ref], "resolved"))
            else:
                result.append(MemberMap(ref, None, "not_found"))
        return tuple(result)

    def submit(self, command: OutboundCommand) -> SubmitResult:
        count = self.write_counts.get(command.action_id, 0) + 1
        self.write_counts[command.action_id] = count
        self.write_calls.append(command)
        if count > 1:
            return SubmitResult("unknown", "duplicate_write_forbidden", write_calls=count)
        content, ats = _ats_payload(command.text, command.mention_keys, command.native_mention)
        payload = {"appId": self.app_id, "toWxid": command.conversation_key, "content": content}
        if ats:
            payload["ats"] = ats
        status, body, reason = self._post(PATH_POST_TEXT, payload, write=True)
        if reason in {"timeout", "http_error"} and status >= 500:
            return SubmitResult("unknown", "http_5xx", write_calls=count)
        if reason == "timeout" or status == 0:
            return SubmitResult("unknown", "timeout", write_calls=count)
        if status >= 500:
            return SubmitResult("unknown", "http_5xx", write_calls=count)
        if body is None:
            return SubmitResult("unknown", reason or "invalid_response", write_calls=count)
        ret = body.get("ret")
        if status == 200 and ret != 200:
            return SubmitResult("not_submitted", f"business_ret_{ret}", write_calls=count)
        if status == 200 and ret == 200:
            data = body.get("data") if isinstance(body.get("data"), dict) else {}
            new_id = data.get("newMsgId")
            if isinstance(new_id, float):
                return SubmitResult("unknown", "float_message_id", write_calls=count)
            provider_message_id = None if new_id in (None, "") else gewe_id_as_str(new_id, field="newMsgId")
            return SubmitResult(
                "accepted",
                "accepted",
                provider_request_id=command.action_id,
                provider_message_id=provider_message_id,
                write_calls=count,
            )
        return SubmitResult("unknown", f"http_{status}", write_calls=count)

    def _read(self, path: str, payload: dict[str, Any]) -> dict[str, Any]:
        status, body, reason = self._post(path, payload, write=False)
        if body is None:
            raise ChannelError("probe_failed", reason, 502)
        if status != 200:
            raise ChannelError("probe_failed", f"http_{status}", status or 502)
        return body

    def _post(self, path: str, payload: dict[str, Any], *, write: bool) -> tuple[int, dict[str, Any] | None, str]:
        if not self.allow_network and getattr(self.transport, "_opener", None) is None:
            raise ChannelError("network_disabled", "live GeWe HTTP is disabled in this round")
        if not self.base_url or not self._token or not self.app_id:
            raise ChannelError("missing_credential", "base_url, token, and app_id are required")
        headers = {TOKEN_HEADER: self._token, "Content-Type": "application/json"}
        return self.transport.post(self.base_url + path, headers, payload, timeout=HTTP_TIMEOUT_SECONDS)


def _is_room(value: str) -> bool:
    return value.endswith(ROOM_SUFFIXES)


def _classify_msg(msg_type: str, content: Any) -> tuple[str, str, str | None]:
    text = None if content is None else str(content)
    if msg_type == "TEXT":
        return "text", "ok", text
    if msg_type in SYSTEM_PAUSE or msg_type in {"SYSTEM", "LOGIN_SUCCESS", "RECONNECT_SUCCESS"}:
        mapped = SYSTEM_PAUSE.get(msg_type, msg_type)
        return "system", "ok", mapped
    return "other", "unknown", text


def _unix_to_iso(value: Any) -> str:
    if isinstance(value, bool) or not isinstance(value, (int, str)):
        raise ChannelError("invalid_field", "createTime must be a unix timestamp")
    if isinstance(value, str):
        if not value.isdigit():
            raise ChannelError("invalid_field", "createTime must be a unix timestamp")
        value = int(value)
    return isoformat(datetime.fromtimestamp(int(value), tz=timezone.utc))


def _ats_payload(text: str, mention_keys: tuple[str, ...], native_mention: bool) -> tuple[str, str]:
    if not native_mention or not mention_keys:
        return text, ""
    ats = ",".join(mention_keys)
    missing = max(0, len(mention_keys) - text.count("@"))
    if missing:
        text = ("@ " * missing) + text
    return text, ats
