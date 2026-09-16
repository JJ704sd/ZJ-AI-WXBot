from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

from wechat_agent_poc.api_channel import FAKE_CALLBACK_HEADER, ChannelError, FakeChannel
from wechat_agent_poc.api_config import load_api_config, live_arm_blockers
from wechat_agent_poc.api_runtime import ApiRuntime
from wechat_agent_poc.api_store import ApiStore
from wechat_agent_poc.clock import SystemClock
from wechat_agent_poc.probe import probe_machine

PROG = "wechat-agent-api"
COMMANDS = (
    "api-check",
    "api-observe",
    "api-ack",
    "api-mention-test",
    "api-run",
    "api-status",
    "api-stop",
    "api-verify",
)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog=PROG,
        description="Independent v0.5 API Agent CLI. Old PoC configs and UIA send paths are rejected.",
    )
    parser.add_argument("--config", default="config.api.example.toml")
    parser.add_argument(
        "--observer-config",
        default="",
        help="observer-config/1 path; required for api-observe, optional for observer status/stop",
    )
    sub = parser.add_subparsers(dest="cmd", required=True)
    check = sub.add_parser("api-check", help="Validate api-config/1 locally; does not open WeChat DBs or call M3")
    check.add_argument("--probe", action="store_true", help="Probe the configured channel; fake only unless observer start")
    observe = sub.add_parser("api-observe", help="Independent GeWe read-only observer; does not start ApiRuntime")
    observe.add_argument("action", nargs="?", default="start", choices=("start", "status", "stop", "export"))
    observe.add_argument("--serve", action="store_true", help="Start the bounded loopback listener; requires --deployment-config")
    observe.add_argument("--deployment-config", default="", help="observer-deploy/1 path used only with --serve")
    observe.add_argument("--reason", default="operator_stop")
    sub.add_parser("api-ack", help="A2b fixed ACK send; refuses unless A2a identity evidence exists")
    sub.add_parser("api-mention-test", help="A2c native @ test; refuses unless mapped targets exist")
    run = sub.add_parser("api-run", help="Start A3 or A4. Offline fake+mock may process a local events file")
    run.add_argument("--stage", required=True, choices=("A3", "A4"))
    run.add_argument("--events-file", default="")
    sub.add_parser("api-status", help="Read run/outbox status; no network, model, or send")
    sub.add_parser("api-stop", help="Revoke the current permit and cancel unsent reserved actions")
    verify = sub.add_parser("api-verify", help="Record human receipt evidence only; does not resume or resend")
    verify.add_argument("action_id")
    verify.add_argument("--wecom", action="store_true")
    verify.add_argument("--wechat", action="store_true")
    verify.add_argument("--operator", required=True)
    verify.add_argument("--note", default="")
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    if args.cmd in {"api-observe", "api-status", "api-stop"} and args.observer_config:
        return _observer_command(args)
    try:
        config = load_api_config(args.config)
    except Exception as exc:  # noqa: BLE001
        print(str(exc), file=sys.stderr)
        return 2
    if args.cmd == "api-check":
        return _api_check(config, probe=args.probe)
    store = ApiStore(config.state_path, clock=SystemClock())
    if args.cmd == "api-status":
        runtime = _offline_runtime(config, store)
        print(_dumps(runtime.status().as_dict() | {"store": str(config.state_path), "network": False, "model": False, "send": False}))
        return 0
    if args.cmd == "api-stop":
        runtime = _offline_runtime(config, store)
        print(_dumps(runtime.stop("operator_stop")))
        return 0
    if args.cmd == "api-verify":
        runtime = _offline_runtime(config, store)
        print(_dumps(runtime.verify_receipt(args.action_id, wecom=args.wecom, wechat=args.wechat, operator=args.operator, note=args.note)))
        return 0
    if args.cmd == "api-observe":
        print(
            _dumps(
                {
                    "command": "api-observe",
                    "verdict": "未执行",
                    "reason": "api-observe requires --observer-config <observer-config/1>; it does not start ApiRuntime",
                    "provider": config.channel.provider,
                    "live_blockers": live_arm_blockers(config),
                    "agent_blockers": live_arm_blockers(config),
                    "real_wechat": False,
                    "real_m3": False,
                    "adapter_initialized": False,
                }
            )
        )
        return 2
    if args.cmd in {"api-ack", "api-mention-test"}:
        print(
            _dumps(
                {
                    "command": args.cmd,
                    "verdict": "未执行",
                    "reason": (
                        "A2b/A2c remain blocked; observer samples cannot arm send. "
                        "agent_blockers still include undocumented mixed-group @ receive and history flags"
                    ),
                    "provider": config.channel.provider,
                    "live_blockers": live_arm_blockers(config),
                    "agent_blockers": live_arm_blockers(config),
                    "real_wechat": False,
                    "real_m3": False,
                    "adapter_initialized": False,
                }
            )
        )
        return 2
    if args.cmd == "api-run":
        if config.live_requested or live_arm_blockers(config) == [] and config.profile != "offline":
            print(_dumps({"command": "api-run", "verdict": "未执行", "reason": "live A3/A4 is outside A1"}))
            return 2
        if config.profile != "offline" or config.channel.provider != "fake" or config.agent.model_provider != "mock":
            print(
                _dumps(
                    {
                        "command": "api-run",
                        "verdict": "未执行",
                        "reason": "A1 api-run only processes offline fake+mock; live WeChat/M3 were not called",
                        "live_blockers": live_arm_blockers(config),
                    }
                )
            )
            return 2
        if args.stage == "A4" and not config.inquiry.enabled:
            print("A4 requires inquiry.enabled and mapped target_keys", file=sys.stderr)
            return 2
        runtime = _fake_runtime(config, store)
        run_id = runtime.start(stage=args.stage)
        ingested = []
        if args.events_file:
            payload = json.loads(Path(args.events_file).read_text(encoding="utf-8"))
            events = payload if isinstance(payload, list) else payload.get("events") or []
            token = getattr(runtime.channel, "token", "fake-offline")
            for raw in events:
                body = json.dumps(raw, ensure_ascii=False).encode("utf-8")
                ingested.append(runtime.ingest_callback({FAKE_CALLBACK_HEADER: token}, body).__dict__)
            runtime.tick()
        status = runtime.status().as_dict()
        print(_dumps({"run_id": run_id, "stage": args.stage, "offline": True, "ingested": ingested, "status": status}))
        return 0
    parser.error("unknown command")
    return 2


def _api_check(config, *, probe: bool) -> int:
    machine = probe_machine()
    profile = _load_profile(config.channel.provider_profile_path)
    report = {
        "config_version": config.config_version,
        "profile": config.profile,
        "stage": config.run.stage,
        "provider": config.channel.provider,
        "live_switches": {"allow_live_read": config.allow_live_read, "allow_live_send": config.allow_live_send},
        "live_blockers": live_arm_blockers(config),
        "live_armed": False,
        "old_mode_enum_unchanged": True,
        "weixin_file_version": machine.get("weixin_file_version"),
        "wxwork_file_version": machine.get("wxwork_file_version"),
        "doc_baseline_wechat": machine.get("doc_baseline_wechat"),
        "wcferry_paired_wechat": "3.9.12.51",
        "wcferry_compatible_with_current_weixin": False,
        "chat_databases_opened": False,
        "process_memory_read": False,
        "real_m3_called": False,
        "real_wechat_send": False,
        "machine": machine,
        "provider_profile_summary": profile,
        "remaining_gaps": [
            "no local hook documents Weixin 4.1.13.65",
            "GeWe SaaS/private trial, scan login, and callback reachability are not started",
            "callback_bearer proves secret possession only; vendor signature protocol is unsupported",
            "mixed-group WeCom native @ receive fields are undocumented",
            "account/group/member API keys are not mapped on this machine",
        ],
        "recommended_provider": "geweapi",
        "selection_status": "adapter_development_only",
        "agent_blockers": live_arm_blockers(config),
        "observe_note": "api-observe requires --observer-config; mention/history gaps remain in agent_blockers",
    }
    if probe:
        if config.channel.provider == "geweapi":
            report["probe"] = {
                "verdict": "未执行",
                "reason": "GeWe probe would call checkOnline/getProfile; live HTTP is disabled this round",
            }
        elif config.channel.provider != "fake":
            report["probe"] = {"verdict": "未执行", "reason": "non-fake probe is not authorized"}
        else:
            channel = FakeChannel()
            evidence = channel.probe(config.binding)
            report["probe"] = {
                "provider": evidence.provider,
                "online": evidence.online,
                "conversation_exists": evidence.conversation_exists,
                "capabilities": dict(evidence.capabilities),
                "observed_at": evidence.observed_at,
            }
    print(_dumps(report))
    return 0


def _observer_command(args) -> int:
    from wechat_agent_poc.gewe_observe_store import ObserveStore
    from wechat_agent_poc.observer_config import load_observer_config, observe_blockers
    from wechat_agent_poc.observer_deploy_config import load_observer_deploy_config
    from wechat_agent_poc.observer_service import ObserverService, describe_observer_status

    try:
        config = load_observer_config(args.observer_config)
    except Exception as exc:  # noqa: BLE001
        print(str(exc), file=sys.stderr)
        return 2
    action = args.cmd
    if args.cmd == "api-observe":
        action = args.action
    elif args.cmd == "api-status":
        action = "status"
    elif args.cmd == "api-stop":
        action = "stop"
    deploy = None
    deploy_path = getattr(args, "deployment_config", "") or ""
    if deploy_path:
        try:
            deploy = load_observer_deploy_config(deploy_path)
        except Exception as exc:  # noqa: BLE001
            print(str(exc), file=sys.stderr)
            return 2
    store = ObserveStore(config.store_path)
    if action == "start":
        if getattr(args, "serve", False):
            if deploy is None:
                print(_dumps({"command": "api-observe", "verdict": "未执行", "reason": "--serve requires --deployment-config observer-deploy/1"}))
                return 2
            service = ObserverService(config, deploy)
            result = service.serve_forever()
            print(_dumps(result | {"command": "api-observe", "action": "serve"}))
            return 0
        from wechat_agent_poc.observer_deploy_config import parse_observer_deploy_config

        dummy = parse_observer_deploy_config(
            {
                "config_version": "observer-deploy/1",
                "mode": "synthetic",
                "bind_host": "127.0.0.1",
                "bind_port": 8765,
                "lock_path": str(config.store_path.with_name("observer.lock")),
            },
            source_path=config.source_path or Path.cwd(),
        )
        prepared = ObserverService(config, dummy).prepare()
        print(
            _dumps(
                {
                    "command": "api-observe",
                    "action": "start",
                    "status": prepared.status,
                    "active_permit": False,
                    "run_id": None,
                    "listen_state": "stopped",
                    "observe_blockers": list(prepared.blockers) or observe_blockers(config),
                    "serve": False,
                    "send_calls": 0,
                    "model_calls": 0,
                    "network": False,
                    "note": "without --serve this only validates; it does not create a sampling permit",
                }
            )
        )
        return 0 if prepared.status == "prepared" else 2
    if action == "status":
        lock_path = deploy.lock_path if deploy else config.store_path.with_name("observer.lock")
        print(
            _dumps(
                describe_observer_status(store, lock_path=lock_path)
                | {
                    "command": "api-observe" if args.cmd == "api-observe" else "api-status",
                    "observe_blockers": observe_blockers(config),
                }
            )
        )
        return 0
    if action == "stop":
        reason = getattr(args, "reason", "operator_stop")
        if deploy is None:
            requested = store.request_stop(reason)
            confirmed = (store.current_run() or {}).get("status") in {"stopped", "failed"}
            if not confirmed:
                store.stop(reason)
                confirmed = True
            print(
                _dumps(
                    {
                        "target": "observer",
                        "stop_requested": True,
                        "stopped_confirmed": confirmed,
                        "listen_state": "stopped" if confirmed else "unknown/stale",
                        **requested,
                    }
                )
            )
            return 0
        service = ObserverService(config, deploy, store=store)
        print(_dumps(service.stop(reason) | {"target": "observer"}))
        return 0
    if action == "export":
        print(_dumps({"command": "api-observe", "action": "export", "samples": store.export_desensitized()}))
        return 0
    print(_dumps({"verdict": "未执行", "reason": f"unknown observer action {action}"}))
    return 2


class _StatusOnlyChannel:
    """Used by api-status/stop/verify so a real adapter is never constructed."""

    provider = "status-only"

    def authenticate_callback(self, headers, body):
        raise ChannelError("status_only", "status commands must not ingest callbacks")

    def normalize(self, raw, *, received_at):
        raise ChannelError("status_only", "status commands must not normalize")

    def probe(self, binding):
        raise ChannelError("status_only", "status commands must not probe")

    def resolve_members(self, binding, candidate_refs):
        raise ChannelError("status_only", "status commands must not resolve members")

    def submit(self, command):
        raise ChannelError("status_only", "status commands must not submit")


def _offline_runtime(config, store: ApiStore) -> ApiRuntime:
    from wechat_agent_poc.agent_policy import AgentPolicy, ScriptedCompleter

    policy = AgentPolicy(ScriptedCompleter([]))
    return ApiRuntime(config, store, _StatusOnlyChannel(), policy, SystemClock())


def _fake_runtime(config, store: ApiStore) -> ApiRuntime:
    from wechat_agent_poc.agent_policy import AgentPolicy, ScriptedCompleter

    channel = FakeChannel(
        account_key=config.binding.account_key or "acct_test",
        conversation_key=config.binding.conversation_key or "conv_test",
    )
    policy = AgentPolicy(ScriptedCompleter([]))
    return ApiRuntime(config, store, channel, policy, SystemClock())


def _load_profile(path: Path | None) -> dict[str, Any]:
    if path is None or not path.is_file():
        return {"status": "missing"}
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {"status": "unreadable"}
    current = data.get("current_client") or {}
    return {
        "schema_version": data.get("schema_version"),
        "weixin_file_version": (current.get("weixin_file_version") or {}).get("value"),
        "wcferry_compatible": (current.get("wcferry_compatible_with_current_weixin") or {}).get("value"),
        "required_before_a2": data.get("required_before_a2") or [],
    }


def _dumps(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, indent=2, default=str)


if __name__ == "__main__":
    raise SystemExit(main())
