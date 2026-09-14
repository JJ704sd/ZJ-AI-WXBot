from __future__ import annotations

import hashlib
from typing import Any


def sha256_text(value: str) -> str:
    digest = hashlib.sha256(value.encode("utf-8")).hexdigest()
    return f"sha256:{digest}"


def fingerprint_stat(size: int, mtime_ns: int) -> str:
    raw = f"{size}:{mtime_ns}".encode("ascii")
    return hashlib.sha256(raw).hexdigest()[:16]


def stable_json_hash(value: Any) -> str:
    import json

    encoded = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    return sha256_text(encoded)
