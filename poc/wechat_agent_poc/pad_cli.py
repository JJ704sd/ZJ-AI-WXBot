from __future__ import annotations

import argparse
import json
import sys
from typing import Any

from wechat_agent_poc.config import ConfigError
from wechat_agent_poc.pad_auth import official_hmac_vector_report
from wechat_agent_poc.pad_config import load_pad_config, pad_observe_blockers, pad_p0_gaps
from wechat_agent_poc.pad_observer import PadObserver, describe_pad_status
from wechat_agent_poc.pad_store import PadStore

PROG = "wechat-agent-pad"
COMMANDS = ("check", "observe", "status", "stop", "verify")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog=PROG,
        description="Independent WeChatPadPro P1 offline observer CLI. No send, no live WeChat, no gateway download.",
    )
    parser.add_argument("--config", default="config.pad.example.toml")
    sub = parser.add_subparsers(dest="cmd", required=True)
    check = sub.add_parser("check", help="Validate pad-config/1 and pad-provider-profile/1 locally; default no network")
    check.add_argument("--probe", action="store_true", help="Refused in P1; does not call a gateway")
    observe = sub.add_parser("observe", help="Independent Pad read-only observer; does not start ApiRuntime")
    observe.add_argument("action", nargs="?", default="start", choices=("start", "status", "stop", "export"))
    observe.add_argument("--serve", action="store_true", help="Start the bounded loopback listener")
    observe.add_argument("--reason", default="operator_stop")
    sub.add_parser("status", help="Read observer sqlite status; no gateway, model, or send")
    stop = sub.add_parser("stop", help="Stop the current pad observer run; no gateway or model")
    stop.add_argument("--reason", default="operator_stop")
    sub.add_parser("verify", help="P1 refuses; receipt verify is a send-stage command")
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    if args.cmd == "verify":
        print(_dumps({"command": "verify", "verdict": "未执行", "reason": "P1 has no send receipts; verify is refused"}))
        return 2
    try:
        config = load_pad_config(args.config)
    except ConfigError as exc:
        print(str(exc), file=sys.stderr)
        return 2
    except Exception as exc:  # noqa: BLE001
        print(str(exc), file=sys.stderr)
        return 2
    if args.cmd == "check":
        return _check(config, probe=args.probe)
    store = PadStore(config.observation_store_path)
    if args.cmd == "status" or (args.cmd == "observe" and args.action == "status"):
        print(
            _dumps(
                describe_pad_status(store)
                | {
                    "command": "status" if args.cmd == "status" else "observe",
                    "observe_blockers": pad_observe_blockers(config),
                    "p0_closed": config.profile.p0_closed,
                    "network": False,
                    "model": False,
                    "send": False,
                }
            )
        )
        return 0
    if args.cmd == "stop" or (args.cmd == "observe" and args.action == "stop"):
        reason = getattr(args, "reason", "operator_stop")
        requested = store.request_stop(reason)
        confirmed = (store.current_run() or {}).get("status") in {"stopped", "failed"}
        if not confirmed:
            store.stop(reason)
            confirmed = True
        print(
            _dumps(
                {
                    "target": "pad-observer",
                    "stop_requested": True,
                    "stopped_confirmed": confirmed,
                    "listen_state": "stopped",
                    "network": False,
                    "model": False,
                    "send": False,
                    **requested,
                }
            )
        )
        return 0
    if args.cmd == "observe" and args.action == "export":
        print(_dumps({"command": "observe", "action": "export", "samples": store.export_desensitized()}))
        return 0
    if args.cmd == "observe" and args.action == "start":
        blockers = pad_observe_blockers(config)
        if getattr(args, "serve", False):
            if blockers:
                print(_dumps({"command": "observe", "verdict": "未执行", "reason": "; ".join(blockers)}))
                return 2
            observer = PadObserver(config, store)
            started = observer.serve_http()
            print(_dumps(started | {"command": "observe", "action": "serve", "network": False, "model": False, "send": False}))
            if observer._thread is not None:
                observer._thread.join()
            return 0
        print(
            _dumps(
                {
                    "command": "observe",
                    "action": "start",
                    "status": "prepared" if not blockers else "blocked",
                    "active_permit": False,
                    "run_id": None,
                    "listen_state": "stopped",
                    "observe_blockers": blockers,
                    "p0_closed": config.profile.p0_closed,
                    "p0_gaps": pad_p0_gaps(config.profile),
                    "serve": False,
                    "send_calls": 0,
                    "model_calls": 0,
                    "network": False,
                    "note": "without --serve this only validates; it does not create a sampling permit",
                }
            )
        )
        return 0 if not blockers else 2
    parser.error("unknown command")
    return 2


def _check(config, *, probe: bool) -> int:
    hmac_report = (
        official_hmac_vector_report()
        if config.api_flavor == "MAX"
        else {"status": "unknown", "reason": "MAX vectors do not establish legacy authentication"}
    )
    report = {
        "config_version": config.config_version,
        "api_flavor": config.api_flavor,
        "provider": config.profile.provider,
        "live": config.live,
        "p0_closed": config.profile.p0_closed,
        "network": False,
        "model": False,
        "send": False,
        "observation_store_path": str(config.observation_store_path),
        "agent_state_path": str(config.agent_state_path),
        "provider_profile": str(config.provider_profile_path),
        "observe_blockers": pad_observe_blockers(config),
        "p0_gaps": pad_p0_gaps(config.profile),
        "capabilities": {
            name: item.get("status")
            for name, item in config.profile.capabilities.items()
        },
        "hmac": hmac_report,
        "document_fixtures_not_observed": True,
        "legacy_max_mixed": False,
        "remaining_gaps": pad_p0_gaps(config.profile),
        "build_evidence": {
            name: config.profile.product.get(name, {})
            for name in ("build_id", "binary_sha256_or_digest", "docs_export_sha256")
        },
        "note": "Offline profile validation only; build evidence is profile-reported, not rehashed by this command. P0 and live capabilities are separate.",
    }
    if probe:
        report["probe"] = {
            "verdict": "未执行",
            "reason": "P1 check --probe does not call a gateway, download a binary, or open WeChat",
        }
    print(_dumps(report))
    return 0


def _dumps(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, indent=2, default=str)


if __name__ == "__main__":
    raise SystemExit(main())
