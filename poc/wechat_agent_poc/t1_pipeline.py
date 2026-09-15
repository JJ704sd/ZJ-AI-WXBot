"""Bounded T1 read: consistent WAL view, chat_room locate, local binding, no send, no M3."""

from __future__ import annotations

import re
import sqlite3
from pathlib import Path
from typing import Any, Callable
from uuid import uuid4

from wechat_agent_poc.account_scope import list_message_shards, metadata_db_candidates, resolve_config_account_dir
from wechat_agent_poc.config import AppConfig, isoformat
from wechat_agent_poc.key_material import KeyBundle, obtain_key_bundle
from wechat_agent_poc.live_guard import assert_live_discovery_permitted, assert_live_open_permitted, key_extraction_status
from wechat_agent_poc.local_binding import update_local_binding
from wechat_agent_poc.locator import (
    baseline_metadata,
    load_chat_rooms,
    load_contacts,
    load_name2id,
    load_sessions,
    locate_group,
    map_self,
)
from wechat_agent_poc.mention import STRUCTURED_FIELD_NAMES, classify_mention
from wechat_agent_poc.models import Halt, HaltError, event_key
from wechat_agent_poc.text_decode import decode_sqlite_text
from wechat_agent_poc.page_cipher import apply_encrypted_wal, decrypt_bytes
from wechat_agent_poc.r0_pipeline import _cleanup, _derived_keys, _integrity, _write_json
from wechat_agent_poc.session_map import quoted_ident, resolve_msg_table
from wechat_agent_poc.snapshot import capture_consistent_snapshot
from wechat_agent_poc.t0_check import t0_report
from wechat_agent_poc.text_decode import decode_message_text

ADAPTER_VERSION = "page_cipher_sqlcipher4_layout/v0.4-wal"
TARGET_MESSAGE = "message_0.db"


def new_t1_run_id() -> str:
    return "t1-20260915-" + uuid4().hex[:8]


def execute_t1(
    config: AppConfig,
    *,
    key_factory: Callable[..., KeyBundle] | None = None,
    write_binding: bool = False,
    live_config_path: Path | None = None,
) -> dict[str, Any]:
    if config.mode != "read_only":
        raise HaltError(Halt("READ_FAILURE", "t1-read requires mode=read_only"))
    if config.allow_live_send:
        raise HaltError(Halt("READ_FAILURE", "t1-read refuses allow_live_send"))
    run_id = new_t1_run_id()
    dest_root = config.data_dir / "runs" / run_id
    dest_root.mkdir(parents=True, exist_ok=True)
    record: dict[str, Any] = {
        "stage": "T1",
        "run_id": run_id,
        "spec_version": "v0.4",
        "authorization_ref": config.authorization_ref,
        "mode": config.mode,
        "allow_live_send": config.allow_live_send,
        "t0": t0_report(config),
        "process_key_extraction": key_extraction_status(config),
        "created_at": isoformat(),
        "stages": {},
    }
    bundle: KeyBundle | None = None
    created_files: list[Path] = []
    try:
        account_dir = resolve_config_account_dir(config)
        shards = [item for item in list_message_shards(account_dir) if item.get("name") == TARGET_MESSAGE]
        if not shards:
            raise HaltError(Halt("READ_FAILURE", "message_0.db was not found for the bound account"))
        bundle = (key_factory or obtain_key_bundle)(config)
        record["stages"]["G-KEY"] = {
            "verdict": "通过当前限定场景",
            "source": bundle.source,
            "ref_name": bundle.ref_name,
            "material_count": len(bundle.items),
            "ownership": bundle.ownership,
        }
        assert_live_open_permitted(config, has_in_process_key=True)
        keys = _derived_keys(bundle)
        decrypt_root = dest_root / "decrypted"
        copies: dict[str, Path] = {}
        wal_reports: list[dict[str, object]] = []
        wanted = {TARGET_MESSAGE, "contact.db", "session.db"}
        sources = {TARGET_MESSAGE: Path(str(shards[0]["path"]))}
        for meta in metadata_db_candidates(account_dir):
            if meta.name in wanted:
                sources[meta.name] = meta
        for name, src in sources.items():
            snap = capture_consistent_snapshot(src)
            plaintext, info, derived_key, salt = decrypt_bytes(snap.db.data, keys, source_name=src.name)
            wal_info: dict[str, object] = {
                "file": name,
                "wal_present": snap.wal is not None,
                "wal_size": snap.wal.size if snap.wal is not None else 0,
                "snapshot_attempts": snap.attempts,
                "source_not_written": True,
            }
            if snap.wal is not None and derived_key is not None and not info.get("already_plaintext"):
                wal_info.update(apply_encrypted_wal(plaintext, snap.wal.data, derived_key, salt))
                wal_info["wal_handling"] = "readonly_committed_frames_merged"
            elif snap.wal is not None and info.get("already_plaintext"):
                from wechat_agent_poc.wal_view import merge_wal_into_db

                merged, parsed = merge_wal_into_db(plaintext, snap.wal.data)
                plaintext = merged
                wal_info.update(
                    {
                        "committed_frames": len(parsed.committed_frames),
                        "truncated_uncommitted": parsed.truncated_uncommitted,
                        "truncated_invalid": parsed.truncated_invalid,
                        "previous_generation_frames": parsed.previous_generation_frames,
                        "last_commit_page_count": parsed.last_commit_page_count,
                        "wal_handling": "plaintext_committed_frames_merged",
                    }
                )
            elif snap.wal is None:
                wal_info["wal_handling"] = "wal_absent"
            dest = decrypt_root / src.parent.name / src.name
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_bytes(bytes(plaintext))
            created_files.append(dest)
            check = _integrity(dest)
            wal_info.update({"adapter": info.get("adapter"), "pages": info.get("pages"), "integrity_check": check.get("integrity_check")})
            if check.get("integrity_check") != "ok":
                wal_info["wal_consistency"] = "未通过"
            elif int(wal_info.get("wal_size") or 0) > 0 and int(wal_info.get("committed_frames") or 0) == 0:
                wal_info["wal_consistency"] = "部分通过且有限制"
            elif int(wal_info.get("committed_frames") or 0) > 0:
                wal_info["wal_consistency"] = "通过当前限定场景"
            else:
                wal_info["wal_consistency"] = "通过当前限定场景"
            wal_reports.append(wal_info)
            copies[name] = dest
        message_ok = all(item.get("integrity_check") == "ok" for item in wal_reports if item.get("file") == TARGET_MESSAGE)
        wal_ok = all(item.get("wal_consistency") == "通过当前限定场景" for item in wal_reports if item.get("file") == TARGET_MESSAGE)
        record["stages"]["G-OPEN"] = {
            "verdict": "通过当前限定场景" if message_ok and wal_ok else ("部分通过且有限制" if message_ok else "未通过"),
            "adapter_version": ADAPTER_VERSION,
            "files": wal_reports,
        }
        assert_live_discovery_permitted(config, has_in_process_key=True)
        contacts = load_contacts(copies.get("contact.db"))
        sessions = load_sessions(copies.get("session.db"))
        name2id = load_name2id(copies[TARGET_MESSAGE])
        chat_rooms = load_chat_rooms(copies.get("contact.db"))
        group = locate_group(
            display_name=config.binding.display_name,
            member_features=config.binding.member_features,
            contacts=contacts,
            sessions=sessions,
            chat_rooms=chat_rooms,
        )
        self_map = map_self(account_wxid=config.binding.account_wxid, contacts=contacts, name2id=name2id)
        record["stages"]["G-DISCOVERY"] = {
            "verdict": "通过当前限定场景"
            if group.get("bindable") and self_map.get("bindable") and not group.get("missing_member_features")
            else "部分通过且有限制",
            "group": group,
            "self": self_map,
        }
        if not group.get("bindable") or not self_map.get("bindable"):
            record["stages"]["G-INGEST"] = {"verdict": "未执行", "reason": "binding not unique"}
            record["verdict"] = "部分通过且有限制"
            return record
        conversation_key = str(group["conversation_key"])
        self_key = str(self_map["self_sender_key"])
        base = baseline_metadata(copies[TARGET_MESSAGE], conversation_key)
        record["stages"]["baseline"] = {"verdict": "通过当前限定场景", **base}
        binding_version = run_id
        record["binding"] = {
            "conversation_key": conversation_key,
            "self_sender_key": self_key,
            "binding_version": binding_version,
            "written": False,
        }
        if write_binding:
            target = live_config_path or config.source_path
            if target is None:
                raise HaltError(Halt("READ_FAILURE", "no local live.toml path to write binding"))
            auth = config.authorization_ref
            if "spec-v0.4" not in auth:
                auth = (auth + " + spec-v0.4-T1").strip(" +")
            record["binding"]["write"] = update_local_binding(
                Path(target),
                conversation_key=conversation_key,
                self_sender_key=self_key,
                binding_version=binding_version,
                run_id=run_id,
                authorization_ref=auth,
            )
            record["binding"]["written"] = True
        bound_key = str(config.binding.conversation_key or "")
        prior_watermark = 5 if conversation_key and conversation_key == bound_key else 0
        rows = _read_bound_messages(
            copies[TARGET_MESSAGE],
            conversation_key,
            self_key,
            account_alias=config.binding.account_alias,
        )
        new_rows = [
            item
            for item in rows
            if int(item["source_message_id"] or 0) > prior_watermark
        ]
        wal_visible = any(
            int(item.get("committed_frames") or 0) > 0 and item.get("file") == TARGET_MESSAGE for item in wal_reports
        )
        visible_ids = [int(item["source_message_id"]) for item in rows if item["source_message_id"] is not None]
        new_ids = [int(item["source_message_id"]) for item in new_rows if item["source_message_id"] is not None]
        ingest_verdict = "通过当前限定场景" if len(new_rows) >= 20 and len(set(new_ids)) == 20 else "部分通过且有限制"
        record["stages"]["G-INGEST"] = {
            "verdict": ingest_verdict,
            "prior_watermark_local_id": prior_watermark or None,
            "visible_row_count": len(rows),
            "visible_max_local_id": max(visible_ids) if visible_ids else None,
            "new_events": len(new_rows),
            "unique_native_ids": sorted(set(new_ids)),
            "events": new_rows,
            "mention_scan": rows,
            "wal_committed_frames_visible": wal_visible,
            "numbered_sample_count": 0,
            "note": "numbered T1 20/20 requires participant samples; this run does not mint collection rows",
        }
        record["verdict"] = (
            "通过当前限定场景"
            if record["stages"]["G-OPEN"]["verdict"] == "通过当前限定场景"
            and record["stages"]["G-DISCOVERY"]["verdict"] == "通过当前限定场景"
            and record["stages"]["G-INGEST"]["verdict"] == "通过当前限定场景"
            else "部分通过且有限制"
        )
        return record
    except HaltError as exc:
        record["halt"] = {"reason": exc.halt.reason, "message": exc.halt.message, "details": exc.halt.details}
        record["verdict"] = "未通过"
        return record
    finally:
        if bundle is not None:
            bundle.clear_env()
        record["cleanup"] = _cleanup(created_files, dest_root)
        _write_json(dest_root / "t1-record.json", record)


def _read_bound_messages(
    message_db: Path,
    conversation_key: str,
    self_sender_key: str,
    *,
    account_alias: str,
) -> list[dict[str, Any]]:
    conn = sqlite3.connect(f"file:{message_db.as_posix()}?mode=ro", uri=True)
    conn.execute("PRAGMA query_only = ON")
    conn.text_factory = bytes
    try:
        table = resolve_msg_table(conn, conversation_key)
        if table is None:
            return []
        quoted = quoted_ident(table)
        columns = {
            str(row[1].decode() if isinstance(row[1], bytes) else row[1]).lower()
            for row in conn.execute(f"PRAGMA table_info({quoted})")
        }
        mention_cols = [name for name in STRUCTURED_FIELD_NAMES if name in columns]
        mention_sql = "".join(f", m.{quoted_ident(name)}" for name in mention_cols)
        compress = ", m.compress_content" if "compress_content" in columns else ", NULL"
        sql = (
            f"SELECT m.local_id, m.create_time, m.real_sender_id, m.message_content{compress}, "
            f"n.user_name{mention_sql} FROM {quoted} m LEFT JOIN Name2Id n ON m.real_sender_id = n.rowid "
            "ORDER BY m.create_time ASC, m.local_id ASC"
        )
        rows = []
        for item in conn.execute(sql).fetchall():
            local_id = int(item[0]) if item[0] is not None else None
            if local_id is None:
                continue
            sender = item[5].decode("utf-8") if isinstance(item[5], bytes) else (str(item[5]) if item[5] is not None else None)
            decoded = decode_message_text(item[3], item[4])
            fields = {name: item[6 + offset] for offset, name in enumerate(mention_cols)}
            mention = classify_mention(self_sender_key=self_sender_key, fields=fields, text=decoded.text)
            is_self = "unknown"
            if self_sender_key and sender:
                is_self = "true" if sender == self_sender_key else "false"
            blob = _as_blob(fields.get("packed_info_data") or fields.get("packed_info"))
            source_blob = _as_blob(fields.get("source") or fields.get("msgsource") or fields.get("message_source"))
            proto_ids = []
            if blob:
                from wechat_agent_poc.chat_room_codec import MEMBER_KEY_RE, extract_protobuf_strings

                extracted = extract_protobuf_strings(blob) or []
                proto_ids = [item for item in extracted if MEMBER_KEY_RE.fullmatch(item)]
            source_text = decode_sqlite_text(source_blob).text or "" if source_blob else ""
            shape = _source_shape(source_text, self_sender_key)
            rows.append(
                {
                    "event_key": event_key(account_alias, "message_0", table, local_id, conversation_key),
                    "source_message_id": local_id,
                    "create_time": int(item[1]) if item[1] is not None else None,
                    "sender_key": sender,
                    "is_self": is_self,
                    "mention_self": mention.mention_self,
                    "mention_reason": mention.reason,
                    "mention_field": mention.source_field,
                    "mentioned_keys": list(mention.mentioned_keys),
                    "mention_all": mention.mention_all,
                    "text_len": len(decoded.text or "") if decoded.sendable else 0,
                    "parse_status": decoded.status,
                    "mention_columns_present": mention_cols,
                    "packed_info_bytes": len(blob),
                    "packed_info_prefix": blob[:12].hex() if blob else "",
                    "packed_info_member_ids": proto_ids[:8],
                    "packed_info_fields": _protobuf_varints(blob)[:12],
                    "source_bytes": len(source_blob),
                    "source_has_atuserlist": "atuserlist" in source_text.lower(),
                    "source_has_atuserlist_tag": bool(re.search(r"<atuserlist\b", source_text, flags=re.I)),
                    "source_has_self_key": bool(self_sender_key) and self_sender_key in source_text,
                    "source_has_notify_all": "notify@all" in source_text.lower(),
                    "body_has_display_at": "@" in (decoded.text or ""),
                    **shape,
                }
            )
        return rows
    finally:
        conn.close()


def _as_blob(value: Any) -> bytes:
    if isinstance(value, memoryview):
        value = bytes(value)
    if isinstance(value, (bytes, bytearray)):
        return bytes(value)
    if isinstance(value, str) and value:
        return value.encode("utf-8")
    return b""


def _mask_ids(text: str, self_sender_key: str) -> str:
    masked = text
    if self_sender_key:
        masked = masked.replace(self_sender_key, "{self}")
    masked = re.sub(r"wxid_[A-Za-z0-9_-]+", "{wxid}", masked)
    masked = re.sub(r"\d+@openim", "{openim}", masked)
    masked = re.sub(r"[0-9a-fA-F]{16,}", "{hex}", masked)
    return masked


def _classify_inner(inner: str, self_sender_key: str) -> str:
    token = (inner or "").strip()
    if not token:
        return "empty"
    if self_sender_key and token == self_sender_key:
        return "self"
    if token.lower() in {"notify@all", "@all", "all"}:
        return "all"
    if re.fullmatch(r"(wxid_[A-Za-z0-9_-]+|\d+@openim)", token):
        return "other_member"
    return f"unparsed_len_{len(token)}"


def _source_shape(source_text: str, self_sender_key: str) -> dict[str, Any]:
    tags = list(dict.fromkeys(re.findall(r"<([A-Za-z_][\w:.-]*)", source_text)))[:24]
    idx = source_text.lower().find("atuserlist")
    window = ""
    if idx >= 0:
        window = _mask_ids(source_text[max(0, idx - 24) : idx + 80], self_sender_key)
    inners = re.findall(r"<atuserlist\b[^>]*>(.*?)</atuserlist>", source_text, flags=re.I | re.S)
    attrs = re.findall(r"\batuserlist\s*=\s*[\"']([^\"']+)[\"']", source_text, flags=re.I)
    return {
        "source_tags": tags,
        "source_atuserlist_window": window,
        "source_atuserlist_inners": [_classify_inner(item, self_sender_key) for item in inners[:4]],
        "source_atuserlist_attrs": [_classify_inner(item, self_sender_key) for item in attrs[:4]],
    }


def _protobuf_varints(blob: bytes) -> list[dict[str, int]]:
    from wechat_agent_poc.chat_room_codec import _read_varint

    index = 0
    fields: list[dict[str, int]] = []
    while index < len(blob) and len(fields) < 16:
        tag, index = _read_varint(blob, index)
        if tag is None:
            break
        field_num = tag >> 3
        wire = tag & 7
        if wire == 0:
            value, index = _read_varint(blob, index)
            if value is None:
                break
            fields.append({"field": field_num, "wire": wire, "value": value})
        elif wire == 2:
            length, index = _read_varint(blob, index)
            if length is None or index + length > len(blob):
                break
            fields.append({"field": field_num, "wire": wire, "length": length})
            index += length
        elif wire == 1:
            if index + 8 > len(blob):
                break
            fields.append({"field": field_num, "wire": wire})
            index += 8
        elif wire == 5:
            if index + 4 > len(blob):
                break
            fields.append({"field": field_num, "wire": wire})
            index += 4
        else:
            break
    return fields
