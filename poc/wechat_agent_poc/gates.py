from __future__ import annotations

from wechat_agent_poc.config import AppConfig, ConfigError, missing_live_fields, missing_open_fields
from wechat_agent_poc.live_guard import (
    key_extraction_status,
    live_discovery_blockers,
    live_ingest_blockers,
    live_key_blockers,
    live_open_blockers,
    live_send_blockers,
)


def state_namespace(config: AppConfig) -> str:
    return "synthetic" if config.mode == "offline" else "live"


def evidence_kinds(config: AppConfig, *, model_called: bool | None = None) -> dict[str, str]:
    source = "synthetic" if config.mode == "offline" or config.adapters.reader == "mock" else "live"
    if config.model.provider == "mock":
        model = "mock"
    elif model_called is False:
        model = "not_called"
    elif config.model.provider == "http":
        model = "real"
    else:
        model = "not_called"
    if config.adapters.sender == "mock":
        sender = "mock"
    else:
        sender = "desktop"
    receiver = "simulated" if sender == "mock" else "none"
    return {
        "source_kind": source,
        "model_kind": model,
        "sender_kind": sender,
        "receiver_kind": receiver,
    }


def _verdict(blockers: list[str], *, attempted: bool = False) -> str:
    if blockers:
        return "未执行" if not attempted else "未通过"
    return "未执行"


def evaluate_gates(config: AppConfig) -> dict[str, dict[str, object]]:
    missing = missing_live_fields(config)
    key_blockers = live_key_blockers(config)
    open_blockers = live_open_blockers(config)
    discovery_blockers = live_discovery_blockers(config)
    ingest_blockers = live_ingest_blockers(config)
    send_blockers = live_send_blockers(config)
    sqlcipher_named = config.adapters.reader == "sqlcipher_readonly"
    g0_blockers: list[str] = []
    if sqlcipher_named and config.authorized_key_ref in ("", "none") and not config.allow_key_material_from_live_client:
        g0_blockers.append("sqlcipher_readonly has no authorized_key_ref")
    if config.adapters.sender == "desktop_stub":
        g0_blockers.append("DesktopStubSender is not a live window observer")
    if config.mode == "manual_send" and config.adapters.sender == "mock":
        g0_blockers.append("manual_send with mock sender cannot mint live send evidence")
    g_read_missing = [
        item
        for item in missing
        if item
        not in {
            "receivers (wecom + wechat verifiers)",
            "model.endpoint",
            "model.model_name",
            "model.credential_source",
        }
    ]
    return {
        "G0": {
            "verdict": "部分通过且有限制",
            "blockers": g0_blockers,
            "allows": "offline development and environment probe; not live DB open",
        },
        "G-KEY": {
            "verdict": _verdict(key_blockers),
            "blockers": key_blockers,
            "requires_existing_key_ref": False,
            "process_key_extraction": key_extraction_status(config),
        },
        "G-OPEN": {
            "verdict": _verdict(open_blockers),
            "blockers": open_blockers,
            "missing": missing_open_fields(config),
            "requires_conversation_key": False,
            "adapter_named_sqlcipher": sqlcipher_named,
            "sqlcipher_name_is_not_compatibility": True,
        },
        "G-DISCOVERY": {
            "verdict": _verdict(discovery_blockers),
            "blockers": discovery_blockers,
            "requires_conversation_key": False,
        },
        "G-INGEST": {
            "verdict": _verdict(ingest_blockers),
            "blockers": ingest_blockers,
            "requires_verified_binding": True,
        },
        "G-READ": {
            "verdict": "未执行",
            "missing": g_read_missing,
            "blockers": ingest_blockers,
            "note": "v0.3 splits G-READ into G-KEY / G-OPEN / G-DISCOVERY / G-INGEST; ingest still requires verified binding",
            "adapter_ready": sqlcipher_named and (
                config.authorized_key_ref not in ("", "none") or config.allow_key_material_from_live_client
            ),
            "sqlcipher_live_enabled": False,
            "plaintext_live_open": False,
        },
        "G-SEND": {
            "verdict": "未执行",
            "missing": [
                item
                for item in missing
                if item
                in {
                    "receivers (wecom + wechat verifiers)",
                    "group.conversation_key",
                    "group.member_features",
                }
            ],
            "blockers": send_blockers,
            "adapter_ready": False,
            "observation_ready": config.window.observer == "manual_file" and config.window.observation_path is not None,
            "ui_send_implemented": False,
        },
        "G-MODEL": {
            "verdict": "未执行",
            "missing": [item for item in missing if item.startswith("model.")],
            "adapter_ready": (
                config.model.provider == "http"
                and bool(config.model.endpoint)
                and bool(config.model.model_name)
                and config.model.credential_source not in ("", "none")
            ),
        },
    }


def assert_mode_lock(config: AppConfig) -> None:
    if config.mode == "offline" and config.model.provider != "mock":
        raise ConfigError("offline mode cannot perform network model calls")
    if config.mode == "offline" and config.allow_live_read:
        raise ConfigError("offline mode cannot set allow_live_read")
    if config.mode == "offline" and config.allow_live_send:
        raise ConfigError("offline mode cannot set allow_live_send")
    if config.mode == "offline" and config.allow_live_discovery:
        raise ConfigError("offline mode cannot set allow_live_discovery")
    if config.mode == "offline" and config.allow_key_material_from_live_client:
        raise ConfigError("offline mode cannot set allow_key_material_from_live_client")
    if config.allow_live_send and config.mode != "manual_send":
        raise ConfigError("allow_live_send requires mode=manual_send")
