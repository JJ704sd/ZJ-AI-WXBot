"""Offline compatibility evidence only; never loads DLLs or accesses processes."""
from __future__ import annotations

import hashlib
import re
import struct
from datetime import datetime, timezone
from pathlib import Path

SCHEMA = "windows-hook-round1.v1"
SHA256 = re.compile(r"[0-9a-fA-F]{64}\Z")
VERSION = re.compile(r"\d+\.\d+\.\d+\.\d+\Z")
ARCHES = {"x86", "x64", "arm64"}


def inspect_pe(path: Path) -> dict:
    """Read an explicitly selected executable file without loading it."""
    with path.open("rb") as stream:
        if stream.read(2) != b"MZ":
            raise ValueError("not a PE file")
        stream.seek(0x3C)
        offset = stream.read(4)
        if len(offset) != 4:
            raise ValueError("truncated DOS header")
        stream.seek(struct.unpack("<I", offset)[0])
        header = stream.read(6)
        if len(header) != 6 or header[:4] != b"PE\0\0":
            raise ValueError("invalid PE header")
        architecture = {0x14C: "x86", 0x8664: "x64", 0xAA64: "arm64"}.get(
            struct.unpack("<H", header[4:])[0]
        )
        stream.seek(0)
        digest = hashlib.file_digest(stream, "sha256").hexdigest()
    return {"sha256": digest, "arch": architecture}


def _version(value):
    return isinstance(value, str) and VERSION.fullmatch(value) is not None


def _hash(value):
    return isinstance(value, str) and SHA256.fullmatch(value) is not None


def check_compatibility(observed: dict, candidate: dict) -> dict:
    """Compare supplied evidence. Provenance must still be independently reviewed."""
    conflicts, missing, checks = [], [], []
    if not isinstance(observed, dict) or not isinstance(candidate, dict):
        raise ValueError("inputs must be JSON objects")
    if observed.get("schema_version") != SCHEMA or candidate.get("schema_version") != SCHEMA:
        raise ValueError("unsupported schema_version")
    for key, valid in (("client_version", _version), ("client_arch", lambda x: isinstance(x, str) and x in ARCHES)):
        expected, actual = candidate.get(key), observed.get(key)
        if not valid(expected) or not valid(actual):
            missing.append(f"{key}_unknown")
        elif expected != actual:
            conflicts.append(f"{key}_mismatch")
    for key in ("candidate_ref", "repository", "commit"):
        if not isinstance(candidate.get(key), str) or not candidate[key].strip():
            missing.append(f"{key}_missing")
    if not re.fullmatch(r"[0-9a-fA-F]{40}", str(candidate.get("commit", ""))):
        missing.append("commit_not_pinned")
    if candidate.get("target_evidence_reviewed") is not True:
        missing.append("target_evidence_not_reviewed")
    refs = candidate.get("evidence_refs")
    if not isinstance(refs, list) or not refs or any(not isinstance(x, str) or not x.strip() for x in refs):
        missing.append("evidence_refs_missing")
    required, modules = candidate.get("required_modules"), observed.get("modules")
    if not isinstance(required, list) or not required:
        missing.append("required_modules_unknown")
        required = []
    if not isinstance(modules, dict):
        missing.append("observed_modules_unknown")
        modules = {}
    names = set()
    for entry in required:
        if not isinstance(entry, dict) or not isinstance(entry.get("name"), str) or not entry["name"].strip():
            missing.append("invalid_module_contract")
            continue
        name = entry["name"]
        if name.casefold() in names:
            missing.append("duplicate_module_contract")
        names.add(name.casefold())
        actual = modules.get(name)
        reasons, mismatch = [], False
        if not isinstance(actual, dict):
            actual = {}
        hashes = entry.get("allowed_sha256")
        if not isinstance(hashes, list) or not hashes or not all(_hash(x) for x in hashes) or not _hash(actual.get("sha256")):
            reasons.append("module_hash_unknown")
        elif actual["sha256"].lower() not in [x.lower() for x in hashes]:
            reasons.append("module_hash_mismatch")
            mismatch = True
        for key, valid in (("version", _version), ("arch", lambda x: isinstance(x, str) and x in ARCHES)):
            if not valid(entry.get(key)) or not valid(actual.get(key)):
                reasons.append(f"module_{key}_unknown")
            elif entry[key] != actual[key]:
                reasons.append(f"module_{key}_mismatch")
                mismatch = True
        status = "mismatch" if mismatch else "unknown" if reasons else "match"
        checks.append({"name": name, "status": status, "reason_codes": reasons})
        for reason in reasons:
            (conflicts if reason.endswith("_mismatch") else missing).append(f"{name}:{reason}")
    return {
        "schema_version": SCHEMA,
        "checked_at": datetime.now(timezone.utc).isoformat(),
        "candidate_ref": candidate.get("candidate_ref"),
        "client_version": observed.get("client_version"),
        "client_arch": observed.get("client_arch"),
        "module_checks": checks,
        "compatibility_status": "mismatch" if conflicts else "unknown" if missing else "match",
        "reason_codes": sorted(set(conflicts + missing)),
        "source_complete": candidate.get("source_complete") is True,
        "build_verified": candidate.get("build_verified") is True,
        "live_receive_verified": False,
        "mixed_group_verified": False,
        "send_delivery_verified": False,
    }
