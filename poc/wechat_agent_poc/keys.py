from __future__ import annotations

import os

from wechat_agent_poc.models import Halt, HaltError


def resolve_authorized_key(ref: str) -> str:
    """Return key material from an explicit authorized reference only.

    Process memory is not an implicit fallback from this helper. G-KEY uses
    wechat_agent_poc.key_material.obtain_live_client_material instead.
    The returned value must not be logged.
    """
    text = (ref or "").strip()
    if text in ("", "none"):
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "sqlcipher_readonly requires an authorized key reference; process key extraction is not a fallback",
                {"potential_key_scope": "all databases protected by the same material, not single-group"},
            )
        )
    if text.startswith("env:"):
        name = text[4:]
        if not name:
            raise HaltError(Halt("READ_FAILURE", "authorized_key_ref env: name is empty"))
        value = os.environ.get(name)
        if not value:
            raise HaltError(
                Halt(
                    "READ_FAILURE",
                    f"environment variable {name} is not set",
                    {"ref_kind": "env"},
                )
            )
        return value
    raise HaltError(
        Halt(
            "READ_FAILURE",
            "unsupported authorized_key_ref; only env:VAR is implemented",
            {"ref_kind": text.split(":", 1)[0] if ":" in text else "literal"},
        )
    )
