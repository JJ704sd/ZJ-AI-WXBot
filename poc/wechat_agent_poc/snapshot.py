"""Copy a live DB and WAL without modifying the source, retrying if the source changes."""

from __future__ import annotations

import hashlib
import time
from dataclasses import dataclass
from pathlib import Path

from wechat_agent_poc.models import Halt, HaltError

DEFAULT_ATTEMPTS = 5
DEFAULT_SLEEP_S = 0.05


@dataclass(frozen=True)
class CopiedFile:
    source: Path
    size: int
    sha256: str
    data: bytes


@dataclass(frozen=True)
class ConsistentSnapshot:
    db: CopiedFile
    wal: CopiedFile | None
    attempts: int
    source_unchanged: bool


def capture_consistent_snapshot(
    db_path: Path,
    wal_path: Path | None = None,
    *,
    attempts: int = DEFAULT_ATTEMPTS,
    sleep_s: float = DEFAULT_SLEEP_S,
) -> ConsistentSnapshot:
    wal = Path(str(db_path) + "-wal") if wal_path is None else wal_path
    last_error: HaltError | None = None
    for attempt in range(1, attempts + 1):
        try:
            db_copy = _read_stable(db_path)
            wal_copy = _read_stable(wal) if wal.exists() else None
            db_again = _stat_sig(db_path)
            if db_again != (len(db_copy.data), _mtime_ns(db_path)):
                raise HaltError(Halt("READ_FAILURE", "database changed during snapshot copy", {"phase": "SNAPSHOT"}))
            if wal_copy is not None:
                if not wal.exists():
                    raise HaltError(Halt("READ_FAILURE", "WAL disappeared during snapshot copy", {"phase": "SNAPSHOT"}))
                if _stat_sig(wal) != (len(wal_copy.data), _mtime_ns(wal)):
                    raise HaltError(Halt("READ_FAILURE", "WAL changed during snapshot copy", {"phase": "SNAPSHOT"}))
            elif wal.exists():
                raise HaltError(Halt("READ_FAILURE", "WAL appeared during snapshot copy", {"phase": "SNAPSHOT"}))
            return ConsistentSnapshot(db=db_copy, wal=wal_copy, attempts=attempt, source_unchanged=True)
        except HaltError as exc:
            last_error = exc
            if attempt < attempts:
                time.sleep(sleep_s)
                continue
            raise HaltError(
                Halt(
                    "READ_FAILURE",
                    "could not prove a consistent DB/WAL snapshot",
                    {"phase": "SNAPSHOT", "attempts": attempts, "cause": exc.halt.message},
                )
            ) from exc
    raise last_error or HaltError(Halt("READ_FAILURE", "snapshot failed", {"phase": "SNAPSHOT"}))


def _read_stable(path: Path) -> CopiedFile:
    before = _stat_sig(path)
    data = path.read_bytes()
    after = _stat_sig(path)
    if before != after or before[0] != len(data):
        raise HaltError(Halt("READ_FAILURE", f"{path.name} changed while reading", {"phase": "SNAPSHOT"}))
    digest = hashlib.sha256(data).hexdigest()
    return CopiedFile(source=path, size=len(data), sha256=digest, data=data)


def _stat_sig(path: Path) -> tuple[int, int]:
    stat = path.stat()
    return stat.st_size, _mtime_ns(path)


def _mtime_ns(path: Path) -> int:
    stat = path.stat()
    return int(getattr(stat, "st_mtime_ns", int(stat.st_mtime * 1e9)))
