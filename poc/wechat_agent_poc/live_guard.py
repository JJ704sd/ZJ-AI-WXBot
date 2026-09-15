from __future__ import annotations

from pathlib import Path

from wechat_agent_poc.config import AppConfig
from wechat_agent_poc.models import Halt, HaltError


def default_live_roots() -> tuple[Path, ...]:
    home = Path.home()
    return (
        home / "Documents" / "xwechat_files",
        home / "Documents" / "WeChat Files",
    )


def is_live_wechat_root(path: Path | None, live_roots: tuple[Path, ...] | None = None) -> bool:
    if path is None:
        return False
    try:
        resolved = path.expanduser().resolve()
    except OSError:
        return False
    roots = live_roots if live_roots is not None else default_live_roots()
    for root in roots:
        try:
            if not root.exists():
                continue
            root_resolved = root.resolve()
        except OSError:
            continue
        try:
            resolved.relative_to(root_resolved)
            return True
        except ValueError:
            continue
    return False


def key_extraction_status(config: AppConfig) -> str:
    if config.allow_key_material_from_live_client:
        return "gated_g_key"
    return "not_authorized"


def live_key_blockers(config: AppConfig) -> list[str]:
    blockers: list[str] = []
    if config.mode == "offline":
        blockers.append("mode=offline cannot obtain live client key material")
    if not config.allow_key_material_from_live_client:
        blockers.append("allow_key_material_from_live_client is false")
    if not config.binding.account_wxid:
        blockers.append("account.wxid missing")
    if config.data_root is None:
        blockers.append("account.data_root missing")
    if not (config.authorization_ref or "").strip():
        blockers.append("authorization_ref missing")
    return blockers


def live_open_blockers(config: AppConfig, *, has_in_process_key: bool = False) -> list[str]:
    blockers: list[str] = []
    if config.mode == "offline":
        blockers.append("mode=offline cannot open live WeChat databases")
    if not config.allow_live_read:
        blockers.append("allow_live_read is false")
    if not config.binding.account_wxid:
        blockers.append("account.wxid missing")
    if config.data_root is None:
        blockers.append("account.data_root missing")
    if not config.wechat_version_recorded:
        blockers.append("wechat_version_recorded missing")
    if config.adapters.reader != "sqlcipher_readonly":
        blockers.append("live WeChat DBs require adapters.reader=sqlcipher_readonly")
    if config.authorized_key_ref in ("", "none") and not has_in_process_key:
        blockers.append("no authorized key reference or in-process key handle")
    return blockers


def live_discovery_blockers(config: AppConfig, *, has_in_process_key: bool = False) -> list[str]:
    blockers = live_open_blockers(config, has_in_process_key=has_in_process_key)
    if not config.allow_live_discovery:
        blockers.append("allow_live_discovery is false")
    if not config.binding.display_name:
        blockers.append("group.display_name missing")
    if not config.binding.member_features:
        blockers.append("group.member_features missing")
    return blockers


def live_ingest_blockers(config: AppConfig, *, has_in_process_key: bool = False) -> list[str]:
    blockers = live_open_blockers(config, has_in_process_key=has_in_process_key)
    if not config.binding.conversation_key:
        blockers.append("group.conversation_key missing")
    if not config.configured_self_sender_key:
        blockers.append("account.self_sender_key missing")
    if not config.binding.member_features:
        blockers.append("group.member_features missing")
    return blockers


def live_read_blockers(config: AppConfig) -> list[str]:
    """Ingest-path blockers. Opening for metadata locate uses live_open_blockers / live_discovery_blockers."""
    return live_ingest_blockers(config)


def live_send_blockers(config: AppConfig) -> list[str]:
    blockers: list[str] = []
    if config.mode != "manual_send":
        blockers.append("live send requires mode=manual_send")
    if not config.allow_live_send:
        blockers.append("allow_live_send is false")
    if config.adapters.sender in {"mock", "desktop_stub"}:
        blockers.append("sender adapter is not a live UI sender")
    if config.window.observer in ("", "none"):
        blockers.append("window.observer is none")
    if len(config.receivers) < 2:
        blockers.append("need wecom + wechat receivers")
    return blockers


def assert_plaintext_fixture_only(config: AppConfig, live_roots: tuple[Path, ...] | None = None) -> None:
    if config.adapters.reader != "sqlite_plain":
        return
    if is_live_wechat_root(config.data_root, live_roots):
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "sqlite_plain cannot open live WeChat databases; they are not treated as plaintext fixtures",
                {"data_root": str(config.data_root), "process_key_extraction": "not_authorized"},
            )
        )


def assert_live_open_permitted(
    config: AppConfig,
    live_roots: tuple[Path, ...] | None = None,
    *,
    has_in_process_key: bool = False,
) -> None:
    if not is_live_wechat_root(config.data_root, live_roots):
        return
    blockers = live_open_blockers(config, has_in_process_key=has_in_process_key)
    if blockers:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "live WeChat database open is blocked",
                {"blockers": blockers, "process_key_extraction": key_extraction_status(config), "phase": "G-OPEN"},
            )
        )


def assert_live_read_permitted(config: AppConfig, live_roots: tuple[Path, ...] | None = None) -> None:
    if not is_live_wechat_root(config.data_root, live_roots):
        return
    blockers = live_ingest_blockers(config)
    if blockers:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "live WeChat database ingest is blocked",
                {"blockers": blockers, "process_key_extraction": key_extraction_status(config), "phase": "G-INGEST"},
            )
        )


def assert_live_key_permitted(config: AppConfig) -> None:
    blockers = live_key_blockers(config)
    if blockers:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "live client key material is blocked",
                {"blockers": blockers, "process_key_extraction": key_extraction_status(config), "phase": "G-KEY"},
            )
        )


def assert_live_discovery_permitted(config: AppConfig, *, has_in_process_key: bool = False) -> None:
    blockers = live_discovery_blockers(config, has_in_process_key=has_in_process_key)
    if blockers:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "live metadata discovery is blocked",
                {"blockers": blockers, "process_key_extraction": key_extraction_status(config), "phase": "G-DISCOVERY"},
            )
        )
