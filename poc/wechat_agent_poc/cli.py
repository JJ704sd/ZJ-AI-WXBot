from __future__ import annotations

import argparse
import json
import sys
from wechat_agent_poc.config import ConfigError, load_config, missing_live_fields
from wechat_agent_poc.mocking import MockReader
from wechat_agent_poc.models import HaltError, ReceiverEvidence
from wechat_agent_poc.reader import SqlcipherReader, SqlitePlainReader
from wechat_agent_poc.responder import Responder, load_model_client
from wechat_agent_poc.review import approve, format_draft, reject
from wechat_agent_poc.runner import Runner
from wechat_agent_poc.sender import DesktopStubSender, MockSender, attach_receiver_evidence, send_text
from wechat_agent_poc.store import Store


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="wechat-agent-poc", description="Human-approved personal WeChat text PoC")
    parser.add_argument("--config", default="config.example.toml")
    sub = parser.add_subparsers(dest="cmd", required=True)
    sub.add_parser("status")
    sub.add_parser("r0-check")
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
    store = Store(config.store_path)
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
                    "coverage": config.coverage_note,
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 0
    if args.cmd == "r0-check":
        missing = missing_live_fields(config)
        print(
            json.dumps(
                {
                    "missing": missing,
                    "reader": config.adapters.reader,
                    "sender": config.adapters.sender,
                    "model": config.model.provider,
                    "live_db_attempted": False,
                    "process_key_extraction": "not_authorized",
                    "key_potential_scope": "material may unlock more than the bound group; program queries only the bound conversation plus identity maps",
                    "ui_route_status": "not_started_until_route_A_r0_fails",
                    "recorded_wechat_version_in_docs": "4.1.13.65 (2026-09-12 baseline, not re-measured here)",
                    "configured_wechat_version": config.wechat_version_recorded or None,
                },
                ensure_ascii=False,
                indent=2,
            )
        )
        return 0 if not missing or config.mode == "offline" else 2
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
        sender = MockSender() if config.adapters.sender == "mock" else DesktopStubSender()
        try:
            status = send_text(store, config, sender, args.approval_id)
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
