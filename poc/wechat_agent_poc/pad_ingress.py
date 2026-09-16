from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Mapping
import json

from wechat_agent_poc.api_channel import MAX_CALLBACK_BYTES, ChannelError
from wechat_agent_poc.api_config import isoformat
from wechat_agent_poc.clock import Clock, SystemClock
from wechat_agent_poc.pad_auth import (
    MetadataSignatureResult,
    PeerEvidence,
    business_trigger_allowed,
    verify_metadata_signature,
)
from wechat_agent_poc.pad_config import PadConfig
from wechat_agent_poc.pad_decoder import decode_v1_envelope
from wechat_agent_poc.pad_store import ItemRecord, PadStore


@dataclass(frozen=True)
class PadAck:
    http_status: int
    accepted: bool
    code: str
    metadata_signature_valid: bool | None
    private_gateway_transport_verified: bool
    payload_integrity_verified: bool
    items: tuple[ItemRecord, ...] = field(default_factory=tuple)
    paused: bool = False
    details: dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> dict[str, Any]:
        return {
            "http_status": self.http_status,
            "accepted": self.accepted,
            "code": self.code,
            "metadata_signature_valid": self.metadata_signature_valid,
            "private_gateway_transport_verified": self.private_gateway_transport_verified,
            "payload_integrity_verified": self.payload_integrity_verified,
            "paused": self.paused,
            "items": [
                {
                    "index": item.index,
                    "action": item.action,
                    "reason": item.reason,
                    "native_message_id": item.native_message_id,
                    "stored_text": item.stored_text,
                }
                for item in self.items
            ],
            "details": self.details,
        }


class PadIngress:
    """Batch callback boundary. Does not call models or send."""

    def __init__(
        self,
        config: PadConfig,
        store: PadStore,
        *,
        clock: Clock | None = None,
        signature_secret: str = "",
    ):
        self.config = config
        self.store = store
        self.clock = clock or SystemClock()
        self.signature_secret = signature_secret
        self.send_calls = 0
        self.model_calls = 0
        self.task_creates = 0

    def accept(self, headers: Mapping[str, str], raw_bytes: bytes, peer_evidence: PeerEvidence) -> PadAck:
        del headers
        if self.send_calls or self.model_calls or self.task_creates:
            return self._deny(500, "internal_spy", peer_evidence, None)
        signature = MetadataSignatureResult(checked=False, valid=None)
        if len(raw_bytes) > min(MAX_CALLBACK_BYTES, self.config.max_body_bytes):
            self.store.bump_counter("payload_too_large")
            return self._deny(413, "payload_too_large", peer_evidence, signature)
        if raw_bytes.lstrip().startswith(b"<"):
            self.store.bump_counter("xml_rejected")
            return self._deny(415, "xml_rejected", peer_evidence, signature)
        try:
            parsed = json.loads(raw_bytes.decode("utf-8"))
        except (UnicodeDecodeError, json.JSONDecodeError):
            self.store.bump_counter("invalid_json")
            return self._deny(400, "invalid_json", peer_evidence, signature)
        if not isinstance(parsed, dict):
            self.store.bump_counter("invalid_json")
            return self._deny(400, "invalid_json", peer_evidence, signature)
        signature = verify_metadata_signature(
            secret=self.signature_secret,
            wxid=str(parsed.get("Wxid") or ""),
            message_type=str(parsed.get("MessageType") or ""),
            timestamp=parsed.get("Timestamp"),
            signature=str(parsed.get("Signature") or ""),
        )
        if not business_trigger_allowed(peer_evidence, signature):
            self.store.bump_counter("untrusted_peer")
            code = "hmac_insufficient_for_trigger" if signature.valid else "untrusted_peer"
            return self._deny(401, code, peer_evidence, signature)
        data = parsed.get("Data")
        if isinstance(data, dict) and isinstance(data.get("messages"), list):
            if len(data["messages"]) > self.config.max_batch_messages:
                self.store.bump_counter("batch_too_large")
                return self._deny(413, "batch_too_large", peer_evidence, signature)
        received_at = isoformat(self.clock.now())
        prefix_ok = self.config.profile.capability_status("group_text_sender_prefix") == "observed"
        decoded = decode_v1_envelope(
            parsed,
            received_at=received_at,
            bound_account=self.config.binding.account_key,
            bound_conversation=self.config.binding.conversation_key,
            session_epoch="unknown",
            prefix_split_confirmed=prefix_ok,
        )
        if decoded.action == "isolated":
            self.store.bump_counter(decoded.reason)
            run = self.store.current_run()
            if run and decoded.reason in {"v2_unsupported", "schema_drift"}:
                self.store.request_stop(decoded.reason, run_id=str(run["run_id"]))
                paused = self.store.stop(decoded.reason)
                del paused
            return PadAck(
                409,
                False,
                decoded.reason,
                signature.valid if signature.checked else None,
                peer_evidence.private_gateway_transport_verified,
                False,
                details={"version": decoded.version},
            )
        records = [
            ItemRecord(
                index=item.index,
                action="ok" if item.action == "ok" else item.action,
                reason=item.reason,
                native_message_id=item.native_message_id,
                stored_text=item.stored_text,
                event=item.event,
            )
            for item in decoded.items
        ]
        try:
            result = self.store.persist_batch(
                items=records,
                metadata_signature_valid=signature.valid if signature.checked else None,
                private_gateway_transport_verified=peer_evidence.private_gateway_transport_verified,
                received_at=received_at,
            )
        except Exception:  # noqa: BLE001
            self.store.bump_counter("persist_error")
            return self._deny(503, "persist_error", peer_evidence, signature)
        if result.http_status >= 400:
            return PadAck(
                result.http_status,
                False,
                result.reason,
                signature.valid if signature.checked else None,
                peer_evidence.private_gateway_transport_verified,
                False,
                result.items,
                paused=result.paused,
            )
        return PadAck(
            200,
            True,
            result.action if result.action != "stored" else "accepted",
            signature.valid if signature.checked else None,
            peer_evidence.private_gateway_transport_verified,
            False,
            result.items,
            paused=result.paused,
        )

    def _deny(
        self,
        status: int,
        code: str,
        peer: PeerEvidence,
        signature: MetadataSignatureResult | None,
    ) -> PadAck:
        valid = None
        if signature is not None and signature.checked:
            valid = signature.valid
        return PadAck(
            status,
            False,
            code,
            valid,
            peer.private_gateway_transport_verified,
            False,
        )


def decode_pad_body(body: bytes) -> dict[str, Any]:
    if len(body) > MAX_CALLBACK_BYTES:
        raise ChannelError("payload_too_large", "callback exceeds 256 KiB", 413)
    if body.lstrip().startswith(b"<"):
        raise ChannelError("xml_rejected", "XML callbacks are rejected", 415)
    try:
        raw = json.loads(body.decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise ChannelError("invalid_json", "callback is not JSON") from exc
    if not isinstance(raw, dict):
        raise ChannelError("invalid_json", "callback JSON must be an object")
    return raw
