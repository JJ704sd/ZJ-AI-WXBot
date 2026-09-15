"""Redact secret-shaped values before any user-visible output."""

from __future__ import annotations

import re
from typing import Any

_LONG_HEX = re.compile(r"\b[0-9a-fA-F]{64,}\b")
_PRAGMA_KEY = re.compile(r"""PRAGMA\s+key\s*=\s*["'][^"']+["']""", re.IGNORECASE)


def scrub_text(value: str) -> str:
    text = _PRAGMA_KEY.sub("PRAGMA key = [redacted]", value)
    return _LONG_HEX.sub("[redacted-hex]", text)


def scrub_json(value: Any) -> Any:
    if isinstance(value, str):
        return scrub_text(value)
    if isinstance(value, dict):
        return {str(key): scrub_json(item) for key, item in value.items()}
    if isinstance(value, list):
        return [scrub_json(item) for item in value]
    if isinstance(value, tuple):
        return [scrub_json(item) for item in value]
    return value
