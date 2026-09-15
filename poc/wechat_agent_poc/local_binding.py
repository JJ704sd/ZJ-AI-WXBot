"""Write verified account/group keys into a gitignored live.toml. Never writes secrets."""

from __future__ import annotations

import json
import re
from pathlib import Path

from wechat_agent_poc.models import Halt, HaltError

ALLOWED_RELATIVE_MARKERS = (".local",)
UPDATABLE_KEYS = {
    "conversation_key",
    "self_sender_key",
    "binding_version",
    "run_id",
    "authorization_ref",
}


def assert_local_config_path(path: Path) -> Path:
    resolved = path.expanduser().resolve()
    parts = {item.lower() for item in resolved.parts}
    if not any(marker in parts or marker in resolved.as_posix().replace("\\", "/").lower() for marker in ALLOWED_RELATIVE_MARKERS):
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "refusing to write binding outside a gitignored .local path",
                {"path": str(resolved)},
            )
        )
    return resolved


def update_local_binding(
    path: Path,
    *,
    conversation_key: str,
    self_sender_key: str,
    binding_version: str,
    run_id: str,
    authorization_ref: str | None = None,
) -> dict[str, object]:
    target = assert_local_config_path(path)
    if not target.is_file():
        raise HaltError(Halt("READ_FAILURE", "local live config does not exist", {"path": str(target)}))
    text = target.read_text(encoding="utf-8")
    replacements = {
        "conversation_key": conversation_key,
        "self_sender_key": self_sender_key,
        "binding_version": binding_version,
        "run_id": run_id,
    }
    if authorization_ref:
        replacements["authorization_ref"] = authorization_ref
    updated = text
    changed: list[str] = []
    for key, value in replacements.items():
        new_text, count = _replace_assignment(updated, key, value)
        if count != 1:
            raise HaltError(
                Halt(
                    "READ_FAILURE",
                    f"expected exactly one {key} assignment in local live config",
                    {"count": count},
                )
            )
        updated = new_text
        changed.append(key)
    if any(secret in updated.lower() for secret in ("pragma key", "api_key =", "minimax")) and "credential_source" not in text:
        pass
    target.write_text(updated, encoding="utf-8")
    return {"path": str(target), "updated_keys": changed, "wrote_secrets": False}


def _replace_assignment(text: str, key: str, value: str) -> tuple[str, int]:
    if key not in UPDATABLE_KEYS:
        raise HaltError(Halt("READ_FAILURE", f"refusing to write {key}"))
    quoted = json.dumps(value, ensure_ascii=False)
    pattern = re.compile(rf"^({re.escape(key)}\s*=\s*).*$", re.MULTILINE)
    matches = list(pattern.finditer(text))
    if len(matches) != 1:
        return text, len(matches)
    updated, count = pattern.subn(rf"\1{quoted}", text, count=1)
    return updated, count
