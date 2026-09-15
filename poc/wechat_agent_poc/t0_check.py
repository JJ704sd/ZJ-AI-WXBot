"""T0 local contract checks. Does not take keys, call models, or send."""

from __future__ import annotations

from pathlib import Path

from wechat_agent_poc.config import AppConfig, load_config, missing_live_fields, parse_config
from wechat_agent_poc.gates import evaluate_gates
from wechat_agent_poc.live_guard import (
    key_extraction_status,
    live_ingest_blockers,
    live_key_blockers,
    live_open_blockers,
    live_send_blockers,
)

OLD_MODES = ("offline", "read_only", "draft_only", "manual_send")
NOT_ALIASES = ("auto_reply_test", "scheduled_mention_test", "auto_send")


def t0_report(config: AppConfig) -> dict[str, object]:
    key_blockers = live_key_blockers(config)
    open_blockers = live_open_blockers(config)
    ingest_blockers = live_ingest_blockers(config)
    send_blockers = live_send_blockers(config)
    adapters_flags = list(config.adapters_allow_flags)
    top_level_armed = any(
        [
            config.allow_live_read,
            config.allow_live_discovery,
            config.allow_key_material_from_live_client,
            config.allow_live_send,
        ]
    )
    verdict = "通过当前限定场景"
    limits: list[str] = []
    if adapters_flags:
        limits.append("allow_* under [adapters] is ignored by the parser")
        verdict = "部分通过且有限制"
    if config.mode == "offline" and top_level_armed:
        verdict = "未通过"
        limits.append("offline mode has live switches armed")
    missing = missing_live_fields(config)
    return {
        "stage": "T0",
        "spec_version": "v0.4",
        "mode": config.mode,
        "old_modes_preserved": list(OLD_MODES),
        "rejected_mode_aliases": list(NOT_ALIASES),
        "allow_live_read": config.allow_live_read,
        "allow_live_discovery": config.allow_live_discovery,
        "allow_key_material_from_live_client": config.allow_key_material_from_live_client,
        "allow_live_send": config.allow_live_send,
        "adapters_allow_flags_ignored": adapters_flags,
        "live_switches_from_adapters_do_not_arm": True,
        "process_key_extraction": key_extraction_status(config),
        "low_level_key_blocked": bool(key_blockers),
        "low_level_open_blocked": bool(open_blockers),
        "low_level_ingest_blocked": bool(ingest_blockers),
        "low_level_send_blocked": bool(send_blockers),
        "model_provider": config.model.provider,
        "reader": config.adapters.reader,
        "sender": config.adapters.sender,
        "missing": missing,
        "gates": evaluate_gates(config),
        "limits": limits,
        "verdict": verdict,
        "source_path": str(config.source_path) if config.source_path else None,
    }


def t0_from_path(path: str | Path) -> dict[str, object]:
    return t0_report(load_config(path))


def adapters_true_does_not_arm() -> bool:
    config = parse_config(
        {
            "mode": "read_only",
            "data_dir": ".local/poc",
            "account": {"alias": "a", "wxid": "wxid_example_account_dir"},
            "group": {"alias": "g"},
            "model": {"provider": "mock", "credential_source": "none"},
            "adapters": {
                "reader": "mock",
                "sender": "mock",
                "allow_live_read": True,
                "allow_live_send": True,
                "allow_live_discovery": True,
                "allow_key_material_from_live_client": True,
            },
        }
    )
    return (
        config.allow_live_read is False
        and config.allow_live_send is False
        and config.allow_live_discovery is False
        and config.allow_key_material_from_live_client is False
        and "allow_live_read" in config.adapters_allow_flags
    )
