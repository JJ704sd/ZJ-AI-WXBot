from __future__ import annotations

from dataclasses import dataclass, field, replace
from datetime import datetime, timezone
from typing import Any, Mapping
from urllib.parse import urlsplit
import asyncio
import hashlib
import hmac
import json
import threading

from wechat_agent_poc.api_channel import MAX_CALLBACK_BYTES, ChannelError
from wechat_agent_poc.api_config import isoformat
from wechat_agent_poc.clock import Clock, SystemClock
from wechat_agent_poc.gewe_channel import (
    HTTP_TIMEOUT_SECONDS,
    PATH_CHECK_ONLINE,
    PATH_MEMBER_DETAIL,
    PATH_POST_TEXT,
    PATH_PROFILE,
    TOKEN_HEADER,
    GeweTransport,
    _path_of,
    gewe_id_as_str,
    resolve_env_ref,
)
from wechat_agent_poc.gewe_observe_store import ObserveStore, PersistResult
from wechat_agent_poc.observer_config import (
    MIN_SECRET_BYTES,
    ObserverConfig,
    observe_blockers,
    resolve_secret_ref,
)

READ_PATHS = frozenset({PATH_CHECK_ONLINE, PATH_PROFILE, PATH_MEMBER_DETAIL})
FIXED_OK = "ok"
BRIDGE_HEADER = "X-Wechat-Bridge-Token"
STRIP_HEADER_PREFIXES = ("x-wechat-bridge-", "x-wechat-source-", "x-source-level")


@dataclass(frozen=True)
class VerifiedIngress:
    source_level: str
    bridge_token: str
    remote: str = "loopback"
    handshake: bool = False


@dataclass(frozen=True)
class Ack:
    http_status: int
    body: str
    code: str
    stored: bool = False
    details: dict[str, Any] = field(default_factory=dict)


@dataclass(frozen=True)
class ObserveStatus:
    run_id: str | None
    status: str
    observe_epoch: str | None
    source_level: str
    sample_count: int
    counters: dict[str, int]
    send_calls: int
    model_calls: int
    task_creates: int
    readonly_calls: tuple[str, ...]
    network: bool
    listening: bool


class IngressError(Exception):
    def __init__(self, http_status: int, code: str):
        super().__init__(code)
        self.http_status = http_status
        self.code = code


class ReadOnlyGeweClient:
    """Only the three documented metadata POSTs. Constructor does not send."""

    def __init__(
        self,
        *,
        base_url: str,
        token: str,
        app_id: str,
        transport: GeweTransport | None = None,
        allow_network: bool = False,
        allow_loopback_http: bool = False,
    ):
        self.base_url = (base_url or "").rstrip("/")
        self._token = token
        self.app_id = app_id
        self.transport = transport or GeweTransport()
        self.allow_network = allow_network
        self.allow_loopback_http = allow_loopback_http
        self.calls: list[str] = []
        self.rejected_writes = 0

    def check_online(self) -> dict[str, Any]:
        return self._post(PATH_CHECK_ONLINE, {"appId": self.app_id})

    def get_profile(self) -> dict[str, Any]:
        body = self._post(PATH_PROFILE, {"appId": self.app_id})
        data = body.get("data") if isinstance(body.get("data"), dict) else {}
        return {"ret": body.get("ret"), "wxid": str(data.get("wxid") or "")}

    def get_member_detail(self, chatroom_id: str, member_wxids: list[str]) -> dict[str, Any]:
        return self._post(
            PATH_MEMBER_DETAIL,
            {"appId": self.app_id, "chatroomId": chatroom_id, "memberWxids": list(member_wxids)},
        )

    def _post(self, path: str, payload: dict[str, Any]) -> dict[str, Any]:
        if path == PATH_POST_TEXT or path not in READ_PATHS:
            self.rejected_writes += 1
            raise ChannelError("write_forbidden", f"readonly client rejected {path}")
        self._assert_url(self.base_url + path, path)
        if not self.allow_network and getattr(self.transport, "_opener", None) is None:
            raise ChannelError("network_disabled", "readonly GeWe HTTP is disabled")
        headers = {TOKEN_HEADER: self._token, "Content-Type": "application/json"}
        self.calls.append(path)
        status, body, reason = self.transport.post(self.base_url + path, headers, payload, timeout=HTTP_TIMEOUT_SECONDS)
        if body is None or status != 200:
            raise ChannelError("probe_failed", reason or f"http_{status}", status or 502)
        return body

    def _assert_url(self, url: str, path: str) -> None:
        parsed = urlsplit(url)
        if _path_of(url) != path or parsed.query or parsed.fragment:
            raise ChannelError("path_forbidden", "readonly URL must use an exact metadata path")
        host = (parsed.hostname or "").lower()
        if parsed.scheme == "https":
            return
        loopback = host in {"127.0.0.1", "localhost"}
        if self.allow_loopback_http and loopback and getattr(self.transport, "_opener", None) is not None:
            return
        raise ChannelError("https_required", "live GeWe API root must be HTTPS")


class PublicIngress:
    """Public callback_bearer check. Does not prove vendor identity."""

    def __init__(self, config: ObserverConfig, *, callback_secret: str, bridge_token: str):
        self.config = config
        self.callback_secret = callback_secret
        self.bridge_token = bridge_token

    def verify(self, *, method: str, path: str, query: str, headers: Mapping[str, str], raw_header_list: list[tuple[bytes, bytes]] | None = None) -> VerifiedIngress:
        if method.upper() != "POST":
            raise IngressError(405, "method_not_allowed")
        if query:
            raise IngressError(400, "secret_query_forbidden")
        if self.config.ingress.mode == "none":
            raise IngressError(403, "live_sampling_forbidden")
        if self.config.ingress.mode != "callback_bearer":
            raise IngressError(403, "ingress_mode_unsupported")
        encoding = _header(headers, "content-encoding")
        if encoding:
            raise IngressError(415, "compression_rejected")
        content_type = _header(headers, "content-type")
        if not _is_json_content_type(content_type):
            raise IngressError(415, "unsupported_media_type")
        prefix = self.config.ingress.path_prefix.rstrip("/")
        expected = prefix + "/" + self.callback_secret
        try:
            path_ok = hmac.compare_digest(path, expected)
        except ValueError:
            path_ok = False
        if not path.startswith(prefix + "/") or not path_ok:
            raise IngressError(401, "auth_failed")
        _assert_no_forged_internal(headers, raw_header_list)
        if _duplicate_internal_headers(raw_header_list, headers):
            raise IngressError(400, "duplicate_internal_header")
        return VerifiedIngress(source_level="callback_bearer", bridge_token=self.bridge_token, remote="loopback")


class GeweObserver:
    def __init__(
        self,
        config: ObserverConfig,
        store: ObserveStore,
        *,
        clock: Clock | None = None,
        environ: Mapping[str, str] | None = None,
        readonly_client: ReadOnlyGeweClient | None = None,
    ):
        self.config = config
        self.store = store
        self.clock = clock or SystemClock()
        self.environ = environ
        self.readonly_client = readonly_client
        self.send_calls = 0
        self.model_calls = 0
        self.task_creates = 0
        self.listening = False
        self._run: dict[str, Any] | None = None
        self._bucket = _TokenBucket(config.rate_limit_per_second, config.burst, self.clock)
        self._member_cache: frozenset[str] = frozenset()
        self.callback_secret = resolve_secret_ref(config.ingress.callback_secret_ref, environ)
        self.bridge_token = resolve_secret_ref(config.ingress.bridge_token_ref, environ)
        self.ingress = PublicIngress(config, callback_secret=self.callback_secret, bridge_token=self.bridge_token)

    def start(self, *, status: str = "observing") -> str:
        if self.config.allow_live_send or self.config.allow_model:
            raise ChannelError("send_forbidden", "observer cannot start with send or model enabled")
        blockers = observe_blockers(self.config, environ=self.environ)
        if blockers:
            raise ChannelError("observe_blocked", "; ".join(blockers))
        if self.readonly_client is None:
            readonly_calls: tuple[str, ...] = ()
        else:
            readonly_calls = tuple(self.readonly_client.calls)
            if readonly_calls:
                raise ChannelError("probe_on_construct_forbidden", "readonly client must not request before start")
        source_level = "synthetic" if self.config.ingress.mode == "none" else "callback_bearer"
        app_id = resolve_secret_ref(self.config.channel.app_id_ref, self.environ)
        if self.config.allow_network:
            if self.readonly_client is None:
                raise ChannelError("probe_required", "live observe requires a readonly client")
            evidence = self._probe_identity()
            if evidence.get("wxid") != self.config.binding.account_key:
                raise ChannelError("account_mismatch", "getProfile wxid does not match binding")
            if not evidence.get("conversation_exists"):
                status = "awaiting_binding"
            else:
                self._member_cache = frozenset(evidence.get("members") or ())
        run = self.store.create_run(
            account_key=self.config.binding.account_key,
            conversation_key=self.config.binding.conversation_key,
            binding_version=self.config.binding.binding_version,
            app_id=app_id,
            source_level=source_level,
            authorization_ref=self.config.authorization_ref,
            max_seconds=self.config.max_seconds,
            max_samples=self.config.max_samples,
            max_body_bytes=self.config.max_body_bytes,
            status=status,
        )
        self._run = run
        return str(run["run_id"])

    def accept(self, verified: VerifiedIngress, raw: bytes) -> Ack:
        if self.send_calls or self.model_calls or self.task_creates:
            return Ack(500, "denied", "internal_spy")
        try:
            self._authenticate_internal(verified)
        except IngressError as exc:
            self.store.bump_counter("auth_failed")
            return Ack(exc.http_status, "denied", exc.code)
        source_level = verified.source_level
        if source_level == "vendor_verified":
            self.store.bump_counter("forged_vendor_verified")
            return Ack(401, "denied", "vendor_verified_unsupported")
        if self.config.ingress.mode == "none" and source_level != "synthetic":
            return Ack(403, "denied", "live_sampling_forbidden")
        if self.config.ingress.mode == "callback_bearer" and source_level != "callback_bearer":
            return Ack(401, "denied", "source_level_mismatch")
        run = self.store.current_run() or self._run
        if run is None or run.get("status") in {"stopped", "stopping", "failed"}:
            return Ack(503, "denied", "not_armed")
        if run.get("status") == "paused":
            return Ack(503, "denied", "paused")
        if run.get("status") == "awaiting_binding":
            self.store.bump_counter("awaiting_binding_drop")
            return Ack(200, FIXED_OK, "awaiting_binding")
        if not self._bucket.allow():
            self.store.bump_counter("rate_limited")
            return Ack(503, "denied", "rate_limited")
        if len(raw) > MAX_CALLBACK_BYTES:
            self.store.bump_counter("payload_too_large")
            return Ack(413, "denied", "payload_too_large")
        if raw.lstrip().startswith(b"<"):
            self.store.bump_counter("xml_rejected")
            return Ack(415, "denied", "xml_rejected")
        try:
            parsed = json.loads(raw.decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError):
            self.store.bump_counter("invalid_json")
            return Ack(400, "denied", "invalid_json")
        if not isinstance(parsed, dict):
            self.store.bump_counter("invalid_json")
            return Ack(400, "denied", "invalid_json")
        if parsed.get("callbackTest") is True:
            if source_level != "synthetic":
                self.store.bump_counter("synthetic_fixture_rejected")
                return Ack(400, "denied", "callback_test_not_vendor_handshake")
            self.store.bump_counter("handshake")
            return Ack(200, FIXED_OK, "handshake", details={"handshake": True})
        record = self._sample_record(parsed, raw, source_level=source_level, received_at=isoformat(self.clock.now()))
        if record is None:
            return Ack(200, FIXED_OK, "dropped")
        try:
            result = self.store.persist_sample(
                run_id=str(run["run_id"]),
                expected_epoch=str(run["observe_epoch"]),
                expected_generation=int(run["permit_generation"]),
                record=record,
            )
        except Exception:  # noqa: BLE001
            self.store.bump_counter("persist_error")
            return Ack(503, "denied", "persist_error")
        self._run = self.store.current_run()
        return _ack_from_persist(result)

    def status(self) -> ObserveStatus:
        run = self.store.current_run() or {}
        return ObserveStatus(
            run_id=run.get("run_id"),
            status=str(run.get("status") or "stopped"),
            observe_epoch=run.get("observe_epoch"),
            source_level=str(run.get("source_level") or "none"),
            sample_count=int(run.get("sample_count") or 0),
            counters=self.store.counters(),
            send_calls=self.send_calls,
            model_calls=self.model_calls,
            task_creates=self.task_creates,
            readonly_calls=tuple(self.readonly_client.calls) if self.readonly_client else (),
            network=False,
            listening=self.listening,
        )

    def stop(self, reason: str) -> dict[str, Any]:
        self.listening = False
        result = self.store.stop(reason)
        self._run = self.store.current_run()
        return result | {"send_calls": self.send_calls, "model_calls": self.model_calls, "task_creates": self.task_creates}

    def _authenticate_internal(self, verified: VerifiedIngress) -> None:
        try:
            ok = bool(verified.bridge_token) and hmac.compare_digest(verified.bridge_token, self.bridge_token)
        except ValueError:
            ok = False
        if not self.bridge_token or not ok:
            raise IngressError(401, "bridge_auth_failed")

    def _probe_identity(self) -> dict[str, Any]:
        assert self.readonly_client is not None
        online = self.readonly_client.check_online()
        profile = self.readonly_client.get_profile()
        members = []
        conversation_exists = False
        if self.config.binding.conversation_key and profile.get("wxid"):
            detail = self.readonly_client.get_member_detail(
                self.config.binding.conversation_key,
                [profile["wxid"], *self.config.binding.candidate_member_keys],
            )
            data = detail.get("data") if detail.get("ret") == 200 else None
            if isinstance(data, list):
                members = [str(item.get("userName") or "") for item in data if isinstance(item, dict)]
                conversation_exists = profile["wxid"] in members
        return {
            "online": online.get("data") is True,
            "wxid": profile.get("wxid") or "",
            "conversation_exists": conversation_exists,
            "members": members,
        }

    def _sample_record(self, parsed: dict[str, Any], raw: bytes, *, source_level: str, received_at: str) -> dict[str, Any] | None:
        if parsed.get("TypeName") is not None or (isinstance(parsed.get("Data"), dict) and parsed.get("Appid")):
            self.store.bump_counter("unsupported_version")
            return None
        account = str(parsed.get("wxid") or "")
        app_id = str(parsed.get("appid") or "")
        expected_app = resolve_secret_ref(self.config.channel.app_id_ref, self.environ)
        bound_account = self.config.binding.account_key
        bound_room = self.config.binding.conversation_key
        from_user = str(parsed.get("fromUser") or "")
        to_user = str(parsed.get("toUser") or "")
        if expected_app and app_id and app_id != expected_app:
            self.store.bump_counter("app_id_mismatch")
            return None
        if account and bound_account and account != bound_account:
            self.store.bump_counter("account_mismatch_drop")
            return None
        conversation, sender = _route_bound_room(from_user, to_user, bound_room)
        if conversation is None:
            if from_user or to_user:
                self.store.bump_counter("out_of_scope")
            else:
                self.store.bump_counter("structure_error")
            return None
        native = None
        parse_status = "ok"
        try:
            if parsed.get("newMsgId") not in (None, ""):
                native = gewe_id_as_str(parsed.get("newMsgId"), field="newMsgId")
        except ChannelError as exc:
            if exc.code == "invalid_native_id":
                self.store.bump_counter("invalid_native_id")
                parse_status = "error"
            else:
                parse_status = "unknown"
        body_hash = hashlib.sha256(raw).hexdigest()
        if native:
            sample_key = f"geweapi|{bound_account}|{bound_room}|{native}"
        else:
            sample_key = f"diag|{body_hash}"
            parse_status = "unknown" if parse_status == "ok" else parse_status
            self.store.bump_counter("diagnostic_sample")
        identity = "unknown"
        if sender and sender in self._member_cache:
            identity = "resolved"
        is_self = "unknown"
        if sender and bound_account:
            is_self = "true" if sender == bound_account else "false"
        kind = "text" if str(parsed.get("msgType") or "") == "TEXT" else "other"
        text = None if parsed.get("content") is None else str(parsed.get("content"))
        occurred_at = None
        try:
            if parsed.get("createTime") not in (None, ""):
                occurred_at = _unix_to_iso(parsed.get("createTime"))
        except ChannelError:
            parse_status = "unknown"
        restricted = _restricted_raw(parsed)
        return {
            "sample_key": sample_key,
            "native_message_id": native,
            "body_hash": body_hash,
            "account_key": bound_account,
            "conversation_key": bound_room,
            "sender_key": sender,
            "identity_status": identity,
            "is_self": is_self,
            "kind": kind,
            "mention_status": "unknown",
            "history_status": "unknown",
            "parse_status": parse_status,
            "source_level": source_level,
            "restricted_raw": restricted,
            "text": text,
            "occurred_at": occurred_at,
            "received_at": received_at,
        }


def build_callback_app(observer: GeweObserver, *, max_concurrent: int = 8, body_read_timeout: float = 1.0):
    from starlette.applications import Starlette
    from starlette.requests import Request
    from starlette.responses import PlainTextResponse
    from starlette.routing import Route

    sem = asyncio.Semaphore(max(max_concurrent, 1))

    async def callback(request: Request):
        raw_headers = list(request.scope.get("headers") or [])
        try:
            verified = observer.ingress.verify(
                method=request.method,
                path=request.url.path,
                query=request.url.query,
                headers=request.headers,
                raw_header_list=raw_headers,
            )
        except IngressError as exc:
            return PlainTextResponse("denied", status_code=exc.http_status)
        if sem.locked():
            return PlainTextResponse("denied", status_code=503)
        await sem.acquire()
        try:
            raw = await asyncio.wait_for(_read_limited(request, MAX_CALLBACK_BYTES), timeout=body_read_timeout)
            ack = await asyncio.to_thread(observer.accept, verified, raw)
            return PlainTextResponse(ack.body, status_code=ack.http_status)
        except _TooLarge:
            return PlainTextResponse("denied", status_code=413)
        except TimeoutError:
            return PlainTextResponse("denied", status_code=503)
        finally:
            sem.release()

    async def reject(_request: Request):
        return PlainTextResponse("denied", status_code=404)

    routes = [
        Route(observer.config.ingress.path_prefix.rstrip("/") + "/{secret}", callback, methods=["POST"]),
        Route("/", reject, methods=["GET", "POST"]),
        Route("/internal/{rest:path}", reject, methods=["GET", "POST"]),
    ]
    return Starlette(routes=routes, debug=False)


class _TooLarge(Exception):
    pass


async def _read_limited(request, limit: int) -> bytes:
    chunks: list[bytes] = []
    size = 0
    async for chunk in request.stream():
        size += len(chunk)
        if size > limit:
            raise _TooLarge()
        chunks.append(chunk)
    return b"".join(chunks)


class _TokenBucket:
    def __init__(self, rate: int, burst: int, clock: Clock):
        self.rate = max(rate, 1)
        self.burst = max(burst, 1)
        self.clock = clock
        self.tokens = float(burst)
        self.updated = clock.now()
        self._lock = threading.Lock()

    def allow(self) -> bool:
        with self._lock:
            now = self.clock.now()
            elapsed = max((now - self.updated).total_seconds(), 0.0)
            self.tokens = min(self.burst, self.tokens + elapsed * self.rate)
            self.updated = now
            if self.tokens < 1:
                return False
            self.tokens -= 1
            return True


def _ack_from_persist(result: PersistResult) -> Ack:
    if result.http_status == 200:
        return Ack(200, FIXED_OK, result.action, stored=result.action == "stored")
    return Ack(result.http_status, "denied", result.reason or result.action)


def _route_bound_room(from_user: str, to_user: str, bound_room: str) -> tuple[str | None, str]:
    if not bound_room:
        return None, ""
    if from_user == bound_room:
        return bound_room, to_user
    if to_user == bound_room:
        return bound_room, from_user
    return None, ""


def _restricted_raw(parsed: dict[str, Any]) -> str:
    blocked = {"mobile", "phoneNumList", "bigHeadImgUrl", "smallHeadImgUrl", "snsBgImg", "alias"}
    cleaned = {key: value for key, value in parsed.items() if key not in blocked}
    return json.dumps(cleaned, ensure_ascii=False, separators=(",", ":"))


def _unix_to_iso(value: Any) -> str:
    if isinstance(value, bool) or not isinstance(value, (int, str)):
        raise ChannelError("invalid_field", "createTime must be a unix timestamp")
    if isinstance(value, str):
        if not value.isdigit():
            raise ChannelError("invalid_field", "createTime must be a unix timestamp")
        value = int(value)
    return isoformat(datetime.fromtimestamp(int(value), tz=timezone.utc))


def _header(headers: Mapping[str, str], name: str) -> str:
    for key, value in headers.items():
        if key.lower() == name.lower():
            return value
    return ""


def _is_json_content_type(value: str) -> bool:
    mime = value.split(";", 1)[0].strip().lower()
    if mime != "application/json":
        return False
    if ";" not in value:
        return True
    params = value.split(";", 1)[1].strip().lower().replace(" ", "")
    return params in {"", "charset=utf-8"}


def _assert_no_forged_internal(headers: Mapping[str, str], raw_header_list: list[tuple[bytes, bytes]] | None) -> None:
    items = list(raw_header_list or [])
    if not items:
        items = [(str(key).encode("latin-1"), str(value).encode("latin-1")) for key, value in headers.items()]
    for key, _value in items:
        name = key.decode("latin-1").lower()
        if any(name.startswith(prefix) for prefix in STRIP_HEADER_PREFIXES):
            continue


def _duplicate_internal_headers(raw_header_list: list[tuple[bytes, bytes]] | None, headers: Mapping[str, str]) -> bool:
    items = list(raw_header_list or [])
    if not items:
        items = [(str(key).encode("latin-1"), str(value).encode("latin-1")) for key, value in headers.items()]
    seen: dict[str, int] = {}
    for key, _value in items:
        name = key.decode("latin-1").lower()
        if any(name.startswith(prefix) for prefix in STRIP_HEADER_PREFIXES):
            seen[name] = seen.get(name, 0) + 1
            if seen[name] > 1:
                return True
    return False


def strip_external_bridge_headers(raw_header_list: list[tuple[bytes, bytes]]) -> list[tuple[bytes, bytes]]:
    kept = []
    for key, value in raw_header_list:
        name = key.decode("latin-1").lower()
        if any(name.startswith(prefix) for prefix in STRIP_HEADER_PREFIXES):
            continue
        kept.append((key, value))
    return kept
