"""Account path jail for the single authorized test wxid."""

from __future__ import annotations

from pathlib import Path

from wechat_agent_poc.config import AppConfig
from wechat_agent_poc.models import Halt, HaltError

DEFAULT_EXCLUDED_WXIDS = frozenset({"wxid_example_excluded_dir"})
SHARD_SKIP_TOKENS = ("fts", "resource")


def excluded_wxids(config: AppConfig | None = None) -> frozenset[str]:
    extra = frozenset(config.excluded_wxids) if config is not None else frozenset()
    return DEFAULT_EXCLUDED_WXIDS | extra


def _assert_wxid_allowed(wxid: str, banned: frozenset[str]) -> None:
    if not wxid or not wxid.startswith("wxid_"):
        raise HaltError(Halt("ACCOUNT_UNKNOWN", "account.wxid is missing or not a wxid_* directory name"))
    if wxid in banned:
        raise HaltError(Halt("ACCOUNT_UNKNOWN", "account is excluded from this PoC", {"wxid": wxid}))


def resolve_account_dir(data_root: Path, wxid: str, *, extra_excluded: tuple[str, ...] = ()) -> Path:
    banned = DEFAULT_EXCLUDED_WXIDS | frozenset(extra_excluded)
    _assert_wxid_allowed(wxid, banned)
    raw = str(data_root)
    if ".." in Path(raw).parts:
        raise HaltError(Halt("READ_FAILURE", "data_root must not contain parent-directory segments"))
    try:
        root = data_root.expanduser().resolve()
    except OSError as exc:
        raise HaltError(Halt("READ_FAILURE", f"cannot resolve data_root: {exc}")) from exc
    candidates = []
    if root.name == wxid:
        candidates.append(root)
    candidates.extend(
        [
            root / wxid,
            root / "xwechat_files" / wxid,
        ]
    )
    chosen: Path | None = None
    for item in candidates:
        if item.is_dir():
            chosen = item
            break
    if chosen is None:
        raise HaltError(
            Halt(
                "ACCOUNT_UNKNOWN",
                "configured account directory is not present",
                {"configured": wxid, "enumerated_siblings": False},
            )
        )
    try:
        resolved = chosen.resolve()
    except OSError as exc:
        raise HaltError(Halt("READ_FAILURE", f"cannot resolve account directory: {exc}")) from exc
    if resolved.name != wxid:
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "account path resolved outside the configured wxid",
                {"configured": wxid, "resolved_name": resolved.name},
            )
        )
    if resolved.name in banned:
        raise HaltError(Halt("ACCOUNT_UNKNOWN", "resolved account path is excluded", {"wxid": resolved.name}))
    return resolved


def resolve_config_account_dir(config: AppConfig) -> Path:
    if config.data_root is None:
        raise HaltError(Halt("READ_FAILURE", "account.data_root is not configured"))
    return resolve_account_dir(config.data_root, config.binding.account_wxid, extra_excluded=config.excluded_wxids)


def list_message_shards(account_dir: Path) -> list[dict[str, str | int | bool]]:
    message_dir = account_dir / "db_storage" / "message"
    if not message_dir.is_dir():
        message_dir = account_dir / "message"
    rows: list[dict[str, str | int | bool]] = []
    if not message_dir.is_dir():
        return rows
    for db_path in sorted(message_dir.glob("message_*.db")):
        lowered = db_path.name.lower()
        if any(token in lowered for token in SHARD_SKIP_TOKENS):
            continue
        wal = Path(str(db_path) + "-wal")
        shm = Path(str(db_path) + "-shm")
        header = _header_hex(db_path)
        rows.append(
            {
                "name": db_path.name,
                "path": str(db_path),
                "size": db_path.stat().st_size,
                "wal_present": wal.exists(),
                "wal_size": wal.stat().st_size if wal.exists() else 0,
                "shm_present": shm.exists(),
                "shm_size": shm.stat().st_size if shm.exists() else 0,
                "plaintext_sqlite_header": header == "53514c69746520666f726d61742033",
                "header16_hex": header,
            }
        )
    return rows


def metadata_db_candidates(account_dir: Path) -> list[Path]:
    storage = account_dir / "db_storage"
    found: list[Path] = []
    for relative in (
        Path("session") / "session.db",
        Path("contact") / "contact.db",
        Path("session.db"),
        Path("contact.db"),
    ):
        path = storage / relative if storage.is_dir() else account_dir / relative
        if path.is_file():
            found.append(path)
    return found


def _header_hex(path: Path) -> str:
    try:
        with path.open("rb") as handle:
            return handle.read(16).hex()
    except OSError:
        return ""
