from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from wechat_agent_poc.config import ConfigError, load_config, missing_live_fields
from wechat_agent_poc.gates import assert_mode_lock, evaluate_gates, evidence_kinds, state_namespace
from wechat_agent_poc.mocking import MockReader
from wechat_agent_poc.mention import classify_mention
from wechat_agent_poc.models import HaltError, ReceiverEvidence
from wechat_agent_poc.live_guard import key_extraction_status, live_ingest_blockers, live_send_blockers
from wechat_agent_poc.r0_pipeline import execute_r0
from wechat_agent_poc.secrets_out import scrub_json
from wechat_agent_poc.t0_check import t0_from_path
from wechat_agent_poc.t1_pipeline import execute_t1
from wechat_agent_poc.probe import probe_machine
from wechat_agent_poc.reader import SqlcipherReader, SqlitePlainReader
from wechat_agent_poc.responder import Responder, load_model_client
from wechat_agent_poc.review import approve, format_draft, reject
from wechat_agent_poc.runner import Runner
from wechat_agent_poc.sender import DesktopStubSender, MockSender, ObservedDesktopSender, attach_receiver_evidence, send_text
from wechat_agent_poc.store import Store
from wechat_agent_poc.window_observer import load_window_observer


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="wechat-agent-poc", description="Human-approved personal WeChat text PoC")
    parser.add_argument("--config", default="config.example.toml")
    sub = parser.add_subparsers(dest="cmd", required=True)
    sub.add_parser("status")
    sub.add_parser("r0-check")
    sub.add_parser("r0-run")
    sub.add_parser("t0-check")
    t1 = sub.add_parser("t1-read")
    t1.add_argument("--write-binding", action="store_true")
    t2 = sub.add_parser("t2-scan")
    t2.add_argument("--self-sender-key", required=True)
    t2.add_argument("--field", action="append", default=[], help="name=value structured mention field")
    t2.add_argument("--text", default="")
    run = sub.add_parser("run")
    run.add_argument("--cycles", type=int, default=1)
    run.add_argument("--seconds", type=float, default=30)
    sub.add_parser("pause")
    sub.add_parser("resume")
    lst = sub.add_parser("review")
    review_sub = lst.add_subparsers(dest="review_cmd", required=True)
    review_sub.add_parser("list")
    show = review_sub.add_parser("show")
    show.add_argument("draft_id")
    appr = review_sub.add_parser("approve")
    appr.add_argument("draft_id")
    appr.add_argument("--text-hash", required=True)
    appr.add_argument("--binding-version", required=True)
    appr.add_argument("--operator", required=True)
    rej = review_sub.add_parser("reject")
    rej.add_argument("draft_id")
    rej.add_argument("--operator", required=True)
    send = sub.add_parser("send-once")
    send.add_argument("approval_id")
    verify = sub.add_parser("verify")
    verify.add_argument("draft_id")
    verify.add_argument("--wecom", action="store_true")
    verify.add_argument("--wechat", action="store_true")
    verify.add_argument("--operator", required=True)
    verify.add_argument("--note", default="")
    gc = sub.add_parser("evidence-list")
    gc.add_argument("--days", type=int, default=7)
    args = parser.parse_args(argv)
    config = load_config(args.config)
    assert_mode_lock(config)
    store = None
    if args.cmd not in {"t0-check", "t2-scan", "t1-read"}:
        store = Store(config.store_path)
        store.bind_namespace(state_namespace(config))
    if args.cmd == "status":
        print(
            json.dumps(
                {
                    "mode": config.mode,
                    "paused": store.paused(),
                    "halt_reason": store.halt_reason(),
                    "uncertain": store.has_uncertain_send(),
                    "in_flight": None if store.in_flight() is None else store.in_flight().draft_id,
                    "store": str(config.store_path),
                    "plaintext_state_db": True,
                    "namespace": state_namespace(config),
                    "evidence_kinds": evidence_kinds(config, model_called=False),
                    "coverage": config.coverage_note,
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 0
    if args.cmd == "r0-check":
        missing = missing_live_fields(config)
        machine = probe_machine()
        print(
            json.dumps(
                {
                    "missing": missing,
                    "reader": config.adapters.reader,
                    "sender": config.adapters.sender,
                    "model": config.model.provider,
                    "run_id": config.run_id or None,
                    "allow_live_read": config.allow_live_read,
                    "allow_live_discovery": config.allow_live_discovery,
                    "allow_key_material_from_live_client": config.allow_key_material_from_live_client,
                    "allow_live_send": config.allow_live_send,
                    "authorization_ref": config.authorization_ref or None,
                    "live_db_attempted": False,
                    "process_key_extraction": key_extraction_status(config),
                    "key_potential_scope": "material may unlock more than the bound group; program queries only the bound conversation plus identity maps",
                    "ui_route_status": "not_started_until_route_A_r0_fails",
                    "recorded_wechat_version_in_docs": "4.1.13.65 (2026-09-12 document baseline)",
                    "configured_wechat_version": config.wechat_version_recorded or None,
                    "machine": machine,
                    "gates": evaluate_gates(config),
                    "evidence_kinds": evidence_kinds(config, model_called=False),
                    "route_a": "blocked_pending_binding_and_authorized_key",
                    "route_b": "not_started",
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        r0_blocking = [item for item in missing if item in {"account.wxid", "account.data_root"}]
        return 0 if not r0_blocking or config.mode == "offline" else 2
    if args.cmd == "r0-run":
        if config.mode != "read_only":
            print("r0-run requires mode=read_only", file=sys.stderr)
            return 2
        if config.allow_live_send:
            print("r0-run refuses allow_live_send", file=sys.stderr)
            return 2
        record = execute_r0(config)
        print(json.dumps(scrub_json(record), ensure_ascii=False, indent=2))
        return 0 if record.get("r0_verdict") in {"通过当前限定场景", "部分通过且有限制"} and "halt" not in record else 2
    if args.cmd == "t0-check":
        report = t0_from_path(args.config)
        print(json.dumps(scrub_json(report), ensure_ascii=False, indent=2))
        return 0 if report.get("verdict") in {"通过当前限定场景", "部分通过且有限制"} else 2
    if args.cmd == "t1-read":
        if config.mode != "read_only":
            print("t1-read requires mode=read_only", file=sys.stderr)
            return 2
        if config.allow_live_send:
            print("t1-read refuses allow_live_send", file=sys.stderr)
            return 2
        record = execute_t1(config, write_binding=args.write_binding, live_config_path=Path(args.config))
        print(json.dumps(scrub_json(record), ensure_ascii=False, indent=2))
        return 0 if record.get("verdict") in {"通过当前限定场景", "部分通过且有限制"} and "halt" not in record else 2
    if args.cmd == "t2-scan":
        fields = {}
        for item in args.field:
            if "=" not in item:
                print("t2-scan --field needs name=value", file=sys.stderr)
                return 2
            name, value = item.split("=", 1)
            fields[name] = value
        decision = classify_mention(self_sender_key=args.self_sender_key, fields=fields, text=args.text)
        print(json.dumps(scrub_json(decision.as_dict()), ensure_ascii=False, indent=2))
        return 0
    if args.cmd == "pause":
        store.pause("operator")
        return 0
    if args.cmd == "resume":
        try:
            store.resume()
        except HaltError as exc:
            print(exc.halt.message, file=sys.stderr)
            return 2
        return 0
    if args.cmd == "run":
        if config.mode != "offline":
            blockers = live_ingest_blockers(config)
            if blockers:
                print(json.dumps({"blocked": True, "phase": "G-INGEST", "blockers": blockers}, ensure_ascii=False, indent=2))
                return 2
        reader = _reader(config, store)
        model, model_kind = load_model_client(config)
        responder = None if config.mode == "read_only" else Responder(config, store, model)
        result = Runner(config, store, reader, responder).run_bounded(max_cycles=args.cycles, max_seconds=args.seconds)
        result["model_kind"] = model_kind
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 0 if result["halted"] is None else 2
    if args.cmd == "review":
        if args.review_cmd == "list":
            for draft in store.list_drafts(("draft", "needs_review", "approved", "sending")):
                print(f"{draft.draft_id}\t{draft.status}\t{draft.event_key}\t{draft.text_hash or ''}")
            return 0
        if args.review_cmd == "show":
            draft = store.get_draft(args.draft_id)
            if draft is None:
                print("draft not found", file=sys.stderr)
                return 2
            print(format_draft(store, draft))
            return 0
        if args.review_cmd == "approve":
            try:
                approval_id = approve(store, config, args.draft_id, args.text_hash, args.binding_version, args.operator)
            except HaltError as exc:
                print(exc.halt.message, file=sys.stderr)
                return 2
            print(approval_id)
            return 0
        if args.review_cmd == "reject":
            reject(store, args.draft_id, args.operator)
            return 0
    if args.cmd == "send-once":
        if config.mode not in {"offline", "manual_send"}:
            print("send-once is blocked outside offline mock drill and manual_send", file=sys.stderr)
            return 2
        if config.mode == "manual_send":
            blockers = live_send_blockers(config)
            if blockers:
                print(json.dumps({"blocked": True, "phase": "G-SEND", "blockers": blockers}, ensure_ascii=False, indent=2))
                return 2
        sender = _sender(config)
        window = None
        if config.mode != "offline":
            observer = load_window_observer(config.window.observer, config.window.observation_path)
            if observer is None:
                print("manual_send requires window.observer", file=sys.stderr)
                return 2
            try:
                window = observer.observe(config.binding)
            except HaltError as exc:
                print(exc.halt.message, file=sys.stderr)
                return 2
        try:
            status = send_text(store, config, sender, args.approval_id, window)
        except HaltError as exc:
            print(exc.halt.message, file=sys.stderr)
            return 2
        print(status)
        return 0
    if args.cmd == "verify":
        status = attach_receiver_evidence(
            store,
            args.draft_id,
            ReceiverEvidence(args.wecom, args.wechat, args.note, args.operator),
        )
        print(status)
        return 0 if status == "verified" else 2
    if args.cmd == "evidence-list":
        print(json.dumps(store.evidence_inventory(args.days), ensure_ascii=False, indent=2))
        print("# This command lists local PoC evidence. It does not delete source WeChat databases.")
        return 0
    return 2


def _sender(config):
    if config.adapters.sender == "mock":
        return MockSender()
    if config.adapters.sender == "desktop_stub":
        return DesktopStubSender()
    if config.adapters.sender == "desktop_observed":
        return ObservedDesktopSender()
    raise ConfigError(f"unsupported sender {config.adapters.sender}")


def _reader(config, store):
    if config.adapters.reader == "mock":
        return MockReader()
    if config.adapters.reader == "sqlite_plain":
        return SqlitePlainReader(config, store)
    if config.adapters.reader == "sqlcipher_readonly":
        return SqlcipherReader(config, store)
    raise ConfigError(f"unsupported reader {config.adapters.reader}")


if __name__ == "__main__":
    raise SystemExit(main())
