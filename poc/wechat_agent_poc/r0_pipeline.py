"""Bounded R0 pipeline: key, open, locate, baseline, cleanup. No send, no body ingest."""

from __future__ import annotations

import json
import os
import sqlite3
from pathlib import Path
from typing import Any, Callable
from uuid import uuid4

from wechat_agent_poc.account_scope import (
    list_message_shards,
    metadata_db_candidates,
    resolve_config_account_dir,
)
from wechat_agent_poc.config import AppConfig, isoformat
from wechat_agent_poc.key_material import KeyBundle, obtain_key_bundle
from wechat_agent_poc.live_guard import (
    assert_live_discovery_permitted,
    assert_live_open_permitted,
    key_extraction_status,
    live_ingest_blockers,
)
from wechat_agent_poc.locator import baseline_metadata, load_chat_rooms, load_contacts, load_name2id, load_sessions, locate_group, map_self
from wechat_agent_poc.models import Halt, HaltError
from wechat_agent_poc.page_cipher import decrypt_database
from wechat_agent_poc.probe import probe_machine
from wechat_agent_poc.secrets_out import scrub_json

ADAPTER_VERSION = "page_cipher_sqlcipher4_layout/v0.3"


def new_run_id() -> str:
    return "r0-20260915-" + uuid4().hex[:8]


def run_dir(config: AppConfig, run_id: str) -> Path:
    return config.data_dir / "runs" / run_id


def _write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(scrub_json(payload), ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def _derived_keys(bundle: KeyBundle) -> list[bytes]:
    keys: list[bytes] = []
    seen: set[bytes] = set()
    for item in bundle.items:
        raw = item.derived_key()
        if len(raw) >= 32:
            raw = raw[:32]
        if raw not in seen:
            seen.add(raw)
            keys.append(raw)
    return keys


def _integrity(path: Path) -> dict[str, object]:
    conn = sqlite3.connect(f"file:{path.as_posix()}?mode=ro", uri=True)
    try:
        conn.execute("PRAGMA query_only = ON")
        row = conn.execute("PRAGMA integrity_check").fetchone()
        tables = [
            str(item[0])
            for item in conn.execute("SELECT name FROM sqlite_master WHERE type='table' LIMIT 200").fetchall()
        ]
        return {"integrity_check": None if row is None else str(row[0]), "table_count": len(tables)}
    finally:
        conn.close()


def _cleanup(paths: list[Path], root: Path) -> dict[str, object]:
    deleted = []
    remaining = []
    root_resolved = root.resolve()
    for path in paths:
        resolved = path.resolve()
        try:
            resolved.relative_to(root_resolved)
        except ValueError:
            remaining.append({"path": str(path), "reason": "outside_run_dir"})
            continue
        if resolved.is_file():
            resolved.unlink()
            deleted.append(str(resolved.name))
        elif resolved.exists():
            remaining.append({"path": str(resolved.name), "reason": "not_a_file"})
    leftovers = [item.name for item in root_resolved.rglob("*") if item.is_file() and item.suffix == ".db"]
    return {"deleted": deleted, "remaining_blocked": remaining, "decrypted_db_leftovers": leftovers}


def execute_r0(
    config: AppConfig,
    *,
    key_factory: Callable[..., KeyBundle] | None = None,
) -> dict[str, Any]:
    if config.mode == "read_only" and config.allow_live_send:
        raise HaltError(Halt("READ_FAILURE", "read_only cannot set allow_live_send"))
    run_id = config.run_id or new_run_id()
    dest_root = run_dir(config, run_id)
    dest_root.mkdir(parents=True, exist_ok=True)
    record: dict[str, Any] = {
        "run_id": run_id,
        "spec_version": "v0.3",
        "authorization_ref": config.authorization_ref,
        "mode": config.mode,
        "allow_live_read": config.allow_live_read,
        "allow_live_discovery": config.allow_live_discovery,
        "allow_key_material_from_live_client": config.allow_key_material_from_live_client,
        "allow_live_send": config.allow_live_send,
        "account_wxid": config.binding.account_wxid,
        "process_key_extraction": key_extraction_status(config),
        "stages": {},
        "created_at": isoformat(),
    }
    bundle: KeyBundle | None = None
    created_files: list[Path] = []
    try:
        account_dir = resolve_config_account_dir(config)
        shards = list_message_shards(account_dir)
        meta_dbs = metadata_db_candidates(account_dir)
        record["account_dir_name"] = account_dir.name
        record["shards"] = shards
        record["metadata_db_names"] = [path.name for path in meta_dbs]
        machine = probe_machine()
        record["client"] = {
            "weixin_file_version": machine.get("weixin_file_version"),
            "configured_wechat_version": config.wechat_version_recorded,
            "weixin_process_running": machine.get("weixin_process_running"),
        }
        bundle = (key_factory or obtain_key_bundle)(config)
        record["stages"]["G-KEY"] = {
            "verdict": "通过当前限定场景",
            "source": bundle.source,
            "ref_name": bundle.ref_name,
            "material_count": len(bundle.items),
            "ownership": bundle.ownership,
        }
        has_key = True
        assert_live_open_permitted(config, has_in_process_key=has_key)
        keys = _derived_keys(bundle)
        decrypt_root = dest_root / "decrypted"
        open_results = []
        message_copy: Path | None = None
        contact_copy: Path | None = None
        session_copy: Path | None = None
        for shard in shards:
            src = Path(str(shard["path"]))
            dest = decrypt_root / "message" / src.name
            info = decrypt_database(src, dest, keys, allow_live=True)
            created_files.append(dest)
            check = _integrity(dest)
            wal_note = "wal_unapplied_committed_pages_in_main_file_only" if shard.get("wal_present") else "wal_absent"
            if int(shard.get("wal_size") or 0) > 32:
                wal_consistency = "部分通过且有限制"
            elif shard.get("wal_present") and int(shard.get("wal_size") or 0) > 0:
                wal_consistency = "部分通过且有限制"
            else:
                wal_consistency = "通过当前限定场景"
            if check.get("integrity_check") != "ok":
                wal_consistency = "未通过"
            open_results.append(
                {
                    "file": src.name,
                    "adapter": info.get("adapter"),
                    "adapter_version": ADAPTER_VERSION,
                    "pages": info.get("pages"),
                    "integrity_check": check.get("integrity_check"),
                    "table_count": check.get("table_count"),
                    "wal_present": shard.get("wal_present"),
                    "wal_size": shard.get("wal_size"),
                    "wal_handling": wal_note,
                    "wal_consistency": wal_consistency,
                    "source_not_written": True,
                }
            )
            if src.name == "message_0.db":
                message_copy = dest
        for meta in meta_dbs:
            dest = decrypt_root / meta.parent.name / meta.name
            info = decrypt_database(meta, dest, keys, allow_live=True)
            created_files.append(dest)
            check = _integrity(dest)
            open_results.append(
                {
                    "file": meta.name,
                    "adapter": info.get("adapter"),
                    "integrity_check": check.get("integrity_check"),
                    "table_count": check.get("table_count"),
                    "source_not_written": True,
                }
            )
            if meta.name == "contact.db":
                contact_copy = dest
            if meta.name == "session.db":
                session_copy = dest
        record["stages"]["G-OPEN"] = {
            "verdict": "通过当前限定场景"
            if open_results and all(item.get("integrity_check") == "ok" for item in open_results if item.get("file") == "message_0.db")
            else "未通过",
            "files": open_results,
        }
        if message_copy is None:
            raise HaltError(Halt("READ_FAILURE", "message_0.db was not opened"))
        wal_limited = any(item.get("wal_consistency") == "部分通过且有限制" for item in open_results)
        if record["stages"]["G-OPEN"]["verdict"] == "通过当前限定场景" and wal_limited:
            record["stages"]["G-OPEN"]["verdict"] = "部分通过且有限制"
        assert_live_discovery_permitted(config, has_in_process_key=True)
        contacts = load_contacts(contact_copy)
        sessions = load_sessions(session_copy)
        name2id = load_name2id(message_copy)
        chat_rooms = load_chat_rooms(contact_copy)
        group = locate_group(
            display_name=config.binding.display_name,
            member_features=config.binding.member_features,
            contacts=contacts,
            sessions=sessions,
            chat_rooms=chat_rooms,
        )
        self_map = map_self(account_wxid=config.binding.account_wxid, contacts=contacts, name2id=name2id)
        record["stages"]["G-DISCOVERY"] = {
            "verdict": "通过当前限定场景" if group.get("bindable") and self_map.get("bindable") else "部分通过且有限制",
            "group": group,
            "self": self_map,
        }
        if not group.get("bindable"):
            record["stages"]["G-DISCOVERY"]["verdict"] = "未通过" if group.get("status") == "none" else "部分通过且有限制"
            record["stages"]["baseline"] = {"verdict": "未执行", "reason": "group binding not unique"}
        elif not self_map.get("bindable"):
            record["stages"]["G-DISCOVERY"]["verdict"] = "部分通过且有限制"
            record["stages"]["baseline"] = {"verdict": "未执行", "reason": "self mapping not unique"}
        else:
            base = baseline_metadata(message_copy, str(group["conversation_key"]))
            record["stages"]["baseline"] = {"verdict": "通过当前限定场景", **base}
            record["binding"] = {
                "conversation_key": group["conversation_key"],
                "self_sender_key": self_map["self_sender_key"],
                "display_name": config.binding.display_name,
            }
        ingest_blockers = live_ingest_blockers(config, has_in_process_key=True)
        if group.get("bindable") and self_map.get("bindable"):
            ingest_blockers = [item for item in ingest_blockers if item not in {"group.conversation_key missing", "account.self_sender_key missing"}]
            if not ingest_blockers:
                ingest_blockers.append("R0 stops before ingest; no new-message read task in this run")
        record["stages"]["G-INGEST"] = {"verdict": "未执行", "blockers": ingest_blockers}
        record["stages"]["R1-R4"] = {"verdict": "未执行"}
        r0_pass = (
            record["stages"]["G-KEY"]["verdict"] == "通过当前限定场景"
            and record["stages"]["G-OPEN"]["verdict"] in {"通过当前限定场景", "部分通过且有限制"}
            and bool(group.get("bindable"))
            and bool(self_map.get("bindable"))
            and record["stages"].get("baseline", {}).get("verdict") == "通过当前限定场景"
        )
        if r0_pass and record["stages"]["G-OPEN"]["verdict"] == "部分通过且有限制":
            record["r0_verdict"] = "部分通过且有限制"
        elif r0_pass:
            record["r0_verdict"] = "通过当前限定场景"
        else:
            record["r0_verdict"] = "部分通过且有限制"
        return record
    except HaltError as exc:
        record["halt"] = {"reason": exc.halt.reason, "message": exc.halt.message, "details": exc.halt.details}
        record["r0_verdict"] = "未通过"
        if "G-KEY" not in record.get("stages", {}):
            record.setdefault("stages", {})["G-KEY"] = {
                "verdict": "未通过",
                "phase": (exc.halt.details or {}).get("phase"),
            }
        elif record["stages"]["G-KEY"].get("verdict") == "通过当前限定场景" and "G-OPEN" not in record["stages"]:
            record["stages"]["G-OPEN"] = {"verdict": "未通过", "phase": (exc.halt.details or {}).get("phase")}
        return record
    except Exception as exc:
        record["halt"] = {
            "reason": "READ_FAILURE",
            "message": "unhandled error during R0",
            "details": {"exc_type": type(exc).__name__},
        }
        record["r0_verdict"] = "未通过"
        return record
    finally:
        if bundle is not None:
            bundle.clear_env()
        cleanup = _cleanup(created_files, dest_root)
        record["cleanup"] = cleanup
        _write_json(dest_root / "r0-record.json", record)
        os.environ.pop("WXBOT_R0_DB_KEY", None)
