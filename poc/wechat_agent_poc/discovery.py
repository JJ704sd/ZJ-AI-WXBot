"""Account-scoped shard and WAL rediscovery.

Never selects the first discovered storage directory. Each poll re-lists
message_N.db and sibling WAL files so a WAL created after startup is seen.
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import re

from wechat_agent_poc.hashes import fingerprint_stat
from wechat_agent_poc.models import Halt, HaltError

SHARD_NAME = re.compile(r"^message_(\d+)\.db$", re.IGNORECASE)


@dataclass(frozen=True)
class ShardSnapshot:
    account_wxid: str
    shard_name: str
    db_path: Path
    wal_path: Path | None
    fingerprint: str

    @property
    def source_shard(self) -> str:
        return self.shard_name


def discover_account_shards(data_root: Path, account_wxid: str) -> list[ShardSnapshot]:
    if not account_wxid:
        raise HaltError(Halt("ACCOUNT_UNKNOWN", "account_wxid is not configured"))
    files_root = _xwechat_files(data_root)
    accounts = sorted(path.name for path in files_root.glob("wxid_*") if path.is_dir())
    if not accounts:
        # also allow a direct account directory layout used by fixtures
        direct = data_root / account_wxid
        if direct.is_dir():
            return _shards_for_account(direct, account_wxid)
        raise HaltError(Halt("ACCOUNT_UNKNOWN", "no wxid_* account directories found", {"root": str(data_root)}))
    if account_wxid not in accounts:
        raise HaltError(
            Halt(
                "ACCOUNT_UNKNOWN",
                "configured account is not among discovered storages",
                {"configured": account_wxid, "discovered": accounts, "would_have_picked_first": accounts[0]},
            )
        )
    return _shards_for_account(files_root / account_wxid, account_wxid)


def list_account_directories(data_root: Path) -> list[str]:
    files_root = _xwechat_files(data_root)
    return sorted(path.name for path in files_root.glob("wxid_*") if path.is_dir())


def _xwechat_files(data_root: Path) -> Path:
    nested = data_root / "xwechat_files"
    return nested if nested.is_dir() else data_root


def _shards_for_account(account_dir: Path, account_wxid: str) -> list[ShardSnapshot]:
    message_dir = account_dir / "db_storage" / "message"
    if not message_dir.is_dir():
        message_dir = account_dir / "message"
    if not message_dir.is_dir():
        raise HaltError(Halt("READ_FAILURE", "message directory missing", {"account": account_wxid, "path": str(account_dir)}))
    snapshots: list[ShardSnapshot] = []
    for db_path in sorted(message_dir.glob("message_*.db")):
        if "fts" in db_path.name.lower() or "resource" in db_path.name.lower():
            continue
        match = SHARD_NAME.match(db_path.name)
        if not match:
            continue
        wal_path = Path(str(db_path) + "-wal")
        wal = wal_path if wal_path.exists() else None
        fingerprint = _fingerprint(db_path, wal)
        snapshots.append(
            ShardSnapshot(
                account_wxid=account_wxid,
                shard_name=db_path.stem,
                db_path=db_path,
                wal_path=wal,
                fingerprint=fingerprint,
            )
        )
    return snapshots


def _fingerprint(db_path: Path, wal_path: Path | None) -> str:
    stat = db_path.stat()
    parts = [fingerprint_stat(stat.st_size, getattr(stat, "st_mtime_ns", int(stat.st_mtime * 1e9)))]
    if wal_path is not None and wal_path.exists():
        wal_stat = wal_path.stat()
        parts.append("wal:" + fingerprint_stat(wal_stat.st_size, getattr(wal_stat, "st_mtime_ns", int(wal_stat.st_mtime * 1e9))))
    else:
        parts.append("wal:absent")
    return ",".join(parts)
