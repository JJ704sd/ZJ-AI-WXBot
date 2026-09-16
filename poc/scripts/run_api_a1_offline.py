"""Run the A1 offline closed loop against fake channel + mock model + temp SQLite."""
from __future__ import annotations

import json
from datetime import datetime, timezone
from pathlib import Path

from wechat_agent_poc.agent_policy import AgentPolicy, ScriptedCompleter
from wechat_agent_poc.api_channel import FAKE_CALLBACK_HEADER, FakeChannel
from wechat_agent_poc.api_config import parse_api_config
from wechat_agent_poc.api_runtime import ApiRuntime
from wechat_agent_poc.api_store import ApiStore
from wechat_agent_poc.clock import FrozenClock

ROOT = Path(__file__).resolve().parents[1]
NOW = datetime(2026, 9, 16, 4, 0, tzinfo=timezone.utc)


def main() -> int:
    clock = FrozenClock(NOW)
    raw = {
        "config_version": "api-config/1",
        "profile": "offline",
        "allow_live_read": False,
        "allow_live_send": False,
        "authorization_ref": "",
        "state_path": str(ROOT / ".local" / "api-agent" / "demo-state.sqlite"),
        "evidence_root": str(ROOT / ".local" / "api-agent" / "runs"),
        "channel": {"provider": "fake", "contract_version": "wechat-api-event/1"},
        "binding": {
            "account_key": "acct_test",
            "conversation_key": "conv_test",
            "binding_version": "fake-offline",
        },
        "agent": {"model_provider": "mock"},
        "run": {"stage": "A3", "max_seconds": 1800, "member_cooldown_seconds": 10},
        "inquiry": {"enabled": False, "target_keys": []},
    }
    config = parse_api_config(raw, source_path=ROOT / "config.api.example.toml")
    store = ApiStore(config.state_path, clock=clock)
    channel = FakeChannel(clock=clock)
    policy = AgentPolicy(
        ScriptedCompleter(
            [
                {
                    "action": "reply",
                    "relation": "unrelated",
                    "text": "这是一条离线闭环回复。",
                    "slot_updates": {},
                    "reason_code": "answer",
                }
            ]
        )
    )
    runtime = ApiRuntime(config, store, channel, policy, clock)
    run_id = runtime.start(stage="A3")
    events = json.loads((ROOT / "samples" / "api_a1_offline_events.json").read_text(encoding="utf-8"))["events"]
    clock.advance(1)
    ack = runtime.ingest_callback({FAKE_CALLBACK_HEADER: channel.token}, json.dumps(events[0]).encode("utf-8"))
    runtime.tick()
    status = runtime.status().as_dict()
    print(json.dumps({"run_id": run_id, "ack": ack.__dict__, "status": status, "writes": len(channel.write_calls)}, ensure_ascii=False, indent=2))
    runtime.stop("demo_done")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
