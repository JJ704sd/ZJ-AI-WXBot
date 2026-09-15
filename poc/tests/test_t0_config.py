from __future__ import annotations

from pathlib import Path

import pytest

from wechat_agent_poc.cli import main
from wechat_agent_poc.config import ConfigError, load_config, parse_config
from wechat_agent_poc.local_binding import update_local_binding
from wechat_agent_poc.t0_check import adapters_true_does_not_arm, t0_report


def test_example_live_flags_are_top_level_false():
    config = load_config(Path(__file__).resolve().parents[1] / "config.example.toml")
    assert config.mode == "offline"
    assert config.allow_live_read is False
    assert config.allow_live_send is False
    assert config.allow_live_discovery is False
    assert config.allow_key_material_from_live_client is False
    assert config.adapters_allow_flags == ()


def test_allow_flags_under_adapters_do_not_arm():
    assert adapters_true_does_not_arm() is True
    config = parse_config(
        {
            "mode": "read_only",
            "data_dir": ".local/poc",
            "account": {"alias": "a"},
            "group": {"alias": "g"},
            "model": {"provider": "mock", "credential_source": "none"},
            "adapters": {"reader": "mock", "sender": "mock", "allow_live_read": True, "allow_live_send": True},
        }
    )
    assert config.allow_live_read is False
    assert config.allow_live_send is False
    report = t0_report(config)
    assert report["live_switches_from_adapters_do_not_arm"] is True
    assert "allow_live_read" in report["adapters_allow_flags_ignored"]


def test_new_modes_are_not_aliases_of_old_modes():
    for mode in ("auto_reply_test", "scheduled_mention_test", "auto_send"):
        with pytest.raises(ConfigError, match="unsupported mode"):
            parse_config(
                {
                    "mode": mode,
                    "data_dir": ".local/poc",
                    "account": {"alias": "a"},
                    "group": {"alias": "g"},
                    "model": {"provider": "mock", "credential_source": "none"},
                    "adapters": {"reader": "mock", "sender": "mock"},
                }
            )


def test_t0_check_cli_offline_passes(tmp_path: Path, capsys):
    cfg = tmp_path / "cfg.toml"
    cfg.write_text(
        f"""
mode = "offline"
data_dir = "{str(tmp_path / "st").replace(chr(92), "/")}"
[account]
alias = "a"
authorized_key_ref = "none"
[group]
alias = "g"
conversation_key = "synthetic_group@openim"
[model]
provider = "mock"
credential_source = "none"
[adapters]
reader = "mock"
sender = "mock"
""",
        encoding="utf-8",
    )
    assert main(["--config", str(cfg), "t0-check"]) == 0
    out = capsys.readouterr().out
    assert "T0" in out
    assert "auto_reply_test" in out


def test_local_binding_write_stays_in_dot_local(tmp_path: Path):
    local = tmp_path / ".local" / "live.toml"
    local.parent.mkdir(parents=True)
    local.write_text(
        'conversation_key = ""\nself_sender_key = ""\nbinding_version = "old"\nrun_id = "old"\nauthorization_ref = "spec-v0.3"\n',
        encoding="utf-8",
    )
    update_local_binding(
        local,
        conversation_key="example_group@chatroom",
        self_sender_key="wxid_example_account",
        binding_version="t1-test",
        run_id="t1-test",
        authorization_ref="spec-v0.4",
    )
    text = local.read_text(encoding="utf-8")
    assert "example_group@chatroom" in text
    assert "wxid_example_account" in text
    outside = tmp_path / "live.toml"
    outside.write_text('conversation_key = ""\nself_sender_key = ""\nbinding_version = "x"\nrun_id = "x"\n', encoding="utf-8")
    with pytest.raises(Exception):
        update_local_binding(
            outside,
            conversation_key="nope",
            self_sender_key="nope",
            binding_version="x",
            run_id="x",
        )
