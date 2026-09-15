"""G-KEY: obtain DB key material without returning values to logs or the model."""

from __future__ import annotations

import os
from dataclasses import dataclass, field
from pathlib import Path
from typing import Callable

from wechat_agent_poc.account_scope import (
    excluded_wxids,
    list_message_shards,
    metadata_db_candidates,
    resolve_config_account_dir,
)
from wechat_agent_poc.config import AppConfig
from wechat_agent_poc.keys import resolve_authorized_key
from wechat_agent_poc.live_guard import assert_live_key_permitted
from wechat_agent_poc.models import Halt, HaltError
from wechat_agent_poc.process_own import resolve_owned_weixin_pid
from wechat_agent_poc.weixin_cipher_scan import scan_owned_process

IN_PROCESS_ENV_NAME = "WXBOT_R0_DB_KEY"


@dataclass
class KeyMaterial:
    key_hex: str
    salt_hex: str = ""

    def __repr__(self) -> str:
        salt_state = "present" if self.salt_hex else "absent"
        return f"KeyMaterial(key=redacted, salt={salt_state}, key_bytes={len(self.key_hex) // 2})"

    __str__ = __repr__

    def derived_key(self) -> bytes:
        return bytes.fromhex(self.key_hex)


@dataclass
class KeyBundle:
    items: list[KeyMaterial]
    source: str
    ref_name: str
    ownership: dict[str, object] = field(default_factory=dict)
    env_name: str = IN_PROCESS_ENV_NAME
    _installed: bool = False

    def __repr__(self) -> str:
        return f"KeyBundle(source={self.source!r}, ref={self.ref_name!r}, count={len(self.items)})"

    __str__ = __repr__

    def install_env(self) -> str:
        if not self.items:
            raise HaltError(Halt("READ_FAILURE", "key bundle is empty"))
        os.environ[self.env_name] = self.items[0].key_hex
        self._installed = True
        return f"env:{self.env_name}"

    def clear_env(self) -> None:
        if self._installed:
            os.environ.pop(self.env_name, None)
            self._installed = False


def material_from_env(ref: str) -> KeyBundle:
    value = resolve_authorized_key(ref)
    hex_text = value.strip()
    if hex_text.lower().startswith("x'") and hex_text.endswith("'"):
        hex_text = hex_text[2:-1]
    if len(hex_text) % 2 == 0 and all(ch in "0123456789abcdefABCDEF" for ch in hex_text):
        item = KeyMaterial(key_hex=hex_text.lower())
    else:
        item = KeyMaterial(key_hex=value.encode("utf-8").hex())
    return KeyBundle(items=[item], source="env", ref_name=ref)


def obtain_live_client_material(
    config: AppConfig,
    *,
    pid_resolver: Callable[..., dict[str, object]] | None = None,
    scanner: Callable[[int], list[tuple[str, str]]] | None = None,
) -> KeyBundle:
    assert_live_key_permitted(config)
    account_dir = resolve_config_account_dir(config)
    shards = list_message_shards(account_dir)
    files = [Path(str(row["path"])) for row in shards]
    for row in shards:
        wal = Path(str(row["path"]) + "-wal")
        shm = Path(str(row["path"]) + "-shm")
        if wal.exists():
            files.append(wal)
        if shm.exists():
            files.append(shm)
    files.extend(metadata_db_candidates(account_dir))
    banned = excluded_wxids(config)
    excluded_files = [
        account_dir.parent / wxid / "db_storage" / "message" / "message_0.db" for wxid in banned
    ]
    ownership = (pid_resolver or resolve_owned_weixin_pid)(files, excluded_files=excluded_files)
    pid = int(ownership["pid"])
    pairs = (scanner or scan_owned_process)(pid)
    items = [KeyMaterial(key_hex=key_hex, salt_hex=salt_hex) for key_hex, salt_hex in pairs]
    return KeyBundle(
        items=items,
        source="live_client_readonly_memory",
        ref_name=f"env:{IN_PROCESS_ENV_NAME}",
        ownership={key: value for key, value in ownership.items() if key != "pid"} | {"pid_recorded": True},
    )


def obtain_key_bundle(config: AppConfig, **kwargs) -> KeyBundle:
    """Explicit G-KEY or existing env:VAR. Never an implicit fallback from a later open failure."""
    if config.allow_key_material_from_live_client:
        return obtain_live_client_material(config, **kwargs)
    if config.authorized_key_ref not in ("", "none"):
        return material_from_env(config.authorized_key_ref)
    raise HaltError(
        Halt(
            "READ_FAILURE",
            "no authorized key reference and live client material is not enabled",
            {"phase": "G-KEY"},
        )
    )
