from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Any, Mapping
import hashlib
import hmac
import json

DOCUMENT_HMAC_FIXTURE = Path(__file__).resolve().parents[1] / "fixtures" / "pad" / "document_hmac_vectors.json"
HMAC_SECRET_EXAMPLE = "your-signature-secret"
HMAC_WXID_EXAMPLE = "wxid_xxxxxxxxxxxxxxxx"
HMAC_MESSAGE_TYPE_EXAMPLE = "sync_message"
LOCAL_COMPUTED_VECTORS = {
    1757156304: "699e83ec24d08e47974a3b51c2d7d961cc584b2dccc26added40524d662e68aa",
    1757156307: "550a69a5420c5e82000ad954e7f944fd11e729db04efd5cae763a4a1202a0876",
}


@dataclass(frozen=True)
class PeerEvidence:
    private_gateway_transport_verified: bool
    source: str
    remote: str = "loopback"


@dataclass(frozen=True)
class MetadataSignatureResult:
    checked: bool
    valid: bool | None
    covers_data: bool = False
    payload_integrity_verified: bool = False
    formula: str = "HMAC-SHA256 hex of Wxid:MessageType:Timestamp"


def pad_metadata_hmac(secret: str, wxid: str, message_type: str, timestamp: Any) -> str:
    """Documented envelope metadata HMAC. Does not cover Data."""
    payload = f"{wxid}:{message_type}:{timestamp}".encode("utf-8")
    return hmac.new(secret.encode("utf-8"), payload, hashlib.sha256).hexdigest()


def verify_metadata_signature(
    *,
    secret: str,
    wxid: str,
    message_type: str,
    timestamp: Any,
    signature: str,
) -> MetadataSignatureResult:
    if not secret or not signature:
        return MetadataSignatureResult(checked=False, valid=None)
    expected = pad_metadata_hmac(secret, wxid, message_type, timestamp)
    try:
        valid = hmac.compare_digest(expected, str(signature).strip().lower())
    except ValueError:
        valid = False
    return MetadataSignatureResult(checked=True, valid=valid, covers_data=False, payload_integrity_verified=False)


def business_trigger_allowed(peer: PeerEvidence, signature: MetadataSignatureResult) -> bool:
    """Metadata HMAC never grants business persist permission by itself."""
    del signature
    return bool(peer.private_gateway_transport_verified) and peer.source in {"synthetic", "private_gateway"}


def official_hmac_vector_report() -> dict[str, Any]:
    computed = {str(ts): pad_metadata_hmac(HMAC_SECRET_EXAMPLE, HMAC_WXID_EXAMPLE, HMAC_MESSAGE_TYPE_EXAMPLE, ts) for ts in LOCAL_COMPUTED_VECTORS}
    fixture = {}
    if DOCUMENT_HMAC_FIXTURE.is_file():
        fixture = json.loads(DOCUMENT_HMAC_FIXTURE.read_text(encoding="utf-8"))
    return {
        "kind": "document_fixture",
        "not_observed": True,
        "formula": "HMAC-SHA256 lowercase hex of UTF-8 Wxid:MessageType:Timestamp",
        "covers_data": False,
        "local_computed": computed,
        "matches_embedded_vectors": computed == {str(k): v for k, v in LOCAL_COMPUTED_VECTORS.items()},
        "document_page_vectors_match_formula": False,
        "algorithm_modified_to_match_page": False,
        "page_listed_hex": (fixture.get("page_listed_hex") if fixture else {"status": "documented_mismatch"}),
        "payload_integrity_verified": False,
    }


def data_tamper_leaves_metadata_signature(secret: str, envelope: Mapping[str, Any], tampered_envelope: Mapping[str, Any]) -> bool:
    original = pad_metadata_hmac(secret, str(envelope.get("Wxid") or ""), str(envelope.get("MessageType") or ""), envelope.get("Timestamp"))
    tampered = pad_metadata_hmac(
        secret,
        str(tampered_envelope.get("Wxid") or ""),
        str(tampered_envelope.get("MessageType") or ""),
        tampered_envelope.get("Timestamp"),
    )
    return original == tampered


def peer_from_local_request(*, remote: str, ingress_mode: str) -> PeerEvidence:
    """Never trust client-supplied identity headers. Loopback synthetic mode is explicit."""
    loopback = remote in {"127.0.0.1", "localhost", "::1", "loopback"}
    if ingress_mode == "synthetic_private" and loopback:
        return PeerEvidence(True, "synthetic", remote)
    if ingress_mode == "private_gateway" and loopback:
        return PeerEvidence(True, "private_gateway", remote)
    return PeerEvidence(False, "untrusted", remote)
