from __future__ import annotations

from pathlib import Path

import pytest

from wechat_agent_poc.api_cli import build_parser, main
from wechat_agent_poc.api_config import ConfigError, load_api_config, parse_api_config
from wechat_agent_poc.config import parse_config


def test_example_api_config_is_offline():
    config = load_api_config(Path(__file__).resolve().parents[1] / "config.api.example.toml")
    assert config.config_version == "api-config/1"
    assert config.profile == "offline"
    assert config.allow_live_read is False
    assert config.allow_live_send is False
    assert config.inquiry.enabled is False
    assert config.inquiry.target_keys == ()
    assert config.channel.provider == "fake"


def test_old_config_rejected_by_api_parser(tmp_path: Path):
    with pytest.raises(ConfigError, match="old PoC config"):
        parse_api_config({"mode": "offline", "data_dir": str(tmp_path)})


def test_old_parser_still_accepts_old_modes_only():
    config = parse_config(
        {
            "mode": "offline",
            "data_dir": ".local/poc",
            "account": {"alias": "a"},
            "group": {"alias": "g"},
            "model": {"provider": "mock", "credential_source": "none"},
            "adapters": {"reader": "mock", "sender": "mock"},
        }
    )
    assert config.mode == "offline"


def test_recurring_rejected():
    with pytest.raises(ConfigError, match="recurring"):
        parse_api_config(_raw(inquiry={"enabled": False, "schedule_kind": "recurring", "target_keys": []}))


def test_unknown_provider_rejected():
    with pytest.raises(ConfigError, match="unverified provider"):
        parse_api_config(_raw(channel={"provider": "wcferry", "contract_version": "wechat-api-event/1"}))


def test_geweapi_provider_parses_without_arming():
    config = parse_api_config(
        _raw(
            channel={
                "provider": "geweapi",
                "contract_version": "wechat-api-event/1",
                "base_url_ref": "env:WECHAT_GATEWAY_BASE_URL",
                "credential_ref": "env:WECHAT_GATEWAY_TOKEN",
                "app_id_ref": "env:WECHAT_GATEWAY_APP_ID",
                "callback_bridge_token_ref": "env:WECHAT_CALLBACK_BRIDGE_TOKEN",
            }
        )
    )
    assert config.channel.provider == "geweapi"
    from wechat_agent_poc.api_config import live_arm_blockers

    blockers = live_arm_blockers(config)
    assert "profile=offline cannot arm live" in blockers
    assert any("mixed-group" in item for item in blockers)


def test_legacy861_provider_parses_without_arming():
    config = parse_api_config(
        _raw(
            channel={
                "provider": "wechatpadpro_legacy",
                "contract_version": "wechat-api-event/1",
                "base_url_ref": "env:WECHAT_GATEWAY_BASE_URL",
                "credential_ref": "env:WECHAT_PAD_DEVICE_KEY",
            }
        )
    )
    assert config.channel.provider == "wechatpadpro_legacy"
    from wechat_agent_poc.api_config import live_arm_blockers

    blockers = live_arm_blockers(config)
    assert "profile=offline cannot arm live" in blockers
    assert any("device key issuance is blocked" in item for item in blockers)
    assert any("real @ receive is unobserved" in item for item in blockers)


def test_unknown_field_and_nested_allow_rejected():
    with pytest.raises(ConfigError, match="unknown field"):
        parse_api_config(_raw() | {"extra": 1})
    raw = _raw()
    raw["run"] = dict(raw["run"], allow_live_send=True)
    with pytest.raises(ConfigError, match="misplaced"):
        parse_api_config(raw)


def test_empty_targets_cannot_enable_inquiry_or_live():
    with pytest.raises(ConfigError, match="target_keys"):
        parse_api_config(_raw(run={"stage": "A4", "max_seconds": 1800, "member_cooldown_seconds": 10}, inquiry={"enabled": True, "target_keys": []}))
    config = parse_api_config(_raw(profile="bounded_agent", allow_live_send=False, authorization_ref="x"))
    from wechat_agent_poc.api_config import live_arm_blockers

    assert "binding.account_key missing" in live_arm_blockers(config)


def test_cli_help_lists_fixed_commands():
    text = build_parser().format_help()
    for command in (
        "api-check",
        "api-observe",
        "api-ack",
        "api-mention-test",
        "api-run",
        "api-status",
        "api-stop",
        "api-verify",
    ):
        assert command in text


def test_api_check_and_live_commands_do_not_arm(tmp_path: Path, capsys):
    example = Path(__file__).resolve().parents[1] / "config.api.example.toml"
    cfg = tmp_path / "config.api.example.toml"
    text = example.read_text(encoding="utf-8")
    text = text.replace('state_path = ".local/api-agent/state.sqlite"', f'state_path = "{(tmp_path / "state.sqlite").as_posix()}"')
    text = text.replace('evidence_root = ".local/api-agent/runs"', f'evidence_root = "{(tmp_path / "runs").as_posix()}"')
    cfg.write_text(text, encoding="utf-8")
    assert main(["--config", str(cfg), "api-check"]) == 0
    out = capsys.readouterr().out
    assert "api-config/1" in out
    assert "4.1.13.65" in out or "weixin_file_version" in out
    assert "wcferry_compatible_with_current_weixin" in out
    assert main(["--config", str(cfg), "api-observe"]) == 2
    assert main(["--config", str(cfg), "api-ack"]) == 2
    assert main(["--config", str(cfg), "api-status"]) == 0
    assert "未执行" in capsys.readouterr().out


def _raw(**overrides):
    data = {
        "config_version": "api-config/1",
        "profile": "offline",
        "allow_live_read": False,
        "allow_live_send": False,
        "authorization_ref": "",
        "state_path": ".local/api-agent/state.sqlite",
        "evidence_root": ".local/api-agent/runs",
        "channel": {"provider": "fake", "contract_version": "wechat-api-event/1"},
        "binding": {"account_key": "", "conversation_key": "", "binding_version": ""},
        "agent": {"model_provider": "mock"},
        "run": {"stage": "A1", "max_seconds": 1800, "member_cooldown_seconds": 10},
        "inquiry": {"enabled": False, "target_keys": []},
    }
    data.update(overrides)
    return data
