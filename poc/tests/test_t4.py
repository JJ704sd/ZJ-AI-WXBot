from __future__ import annotations

from pathlib import Path

import pytest

from wechat_agent_poc.cli import main
from wechat_agent_poc.config import parse_config
from wechat_agent_poc.models import Binding, Halt, HaltError, SendResult, WindowState
from wechat_agent_poc.sender import ObservedDesktopSender
from wechat_agent_poc.t4_pipeline import (
    AtomicSendBudget,
    ack_text,
    assert_t4_send_permitted,
    execute_t4_send,
    t4_from_path,
    t4_report,
)
from wechat_agent_poc.wechat_ui import observe_selected_chat, titles_match
from wechat_agent_poc.window_observer import load_window_observer


def _offline_config(tmp_path: Path):
    return parse_config(
        {
            "mode": "offline",
            "data_dir": str(tmp_path / "st").replace("\\", "/"),
            "account": {"alias": "a"},
            "group": {"alias": "g", "display_name": "示例混合群"},
            "model": {"provider": "mock", "credential_source": "none"},
            "adapters": {"reader": "mock", "sender": "mock"},
        }
    )


def test_ack_text_includes_run_id_and_stays_in_budget():
    run_id = "t4-20260915-test"
    assert ack_text(run_id, 1) == "POC-ACK-t4-20260915-test-001"
    assert ack_text(run_id, 3).endswith("-003")
    with pytest.raises(ValueError):
        ack_text(run_id, 4)


def test_atomic_budget_stops_at_three_and_uncertain_blocks_retry(tmp_path: Path):
    budget = AtomicSendBudget(tmp_path / "budget.json")
    assert [budget.try_consume() for _ in range(3)] == [1, 2, 3]
    assert budget.try_consume() is None
    budget.mark_uncertain()
    other = AtomicSendBudget(tmp_path / "u.json")
    other.try_consume()
    other.mark_uncertain()
    assert other.remaining() == 0
    assert other.try_consume() is None


def test_t4_check_does_not_send_or_call_model(tmp_path: Path, capsys):
    cfg = tmp_path / "cfg.toml"
    cfg.write_text(
        """
mode = "offline"
data_dir = "{data}"
allow_live_send = false
[account]
alias = "a"
[group]
alias = "g"
display_name = "示例混合群"
[model]
provider = "mock"
credential_source = "none"
[adapters]
reader = "mock"
sender = "mock"
""".format(data=str(tmp_path / "st").replace("\\", "/")),
        encoding="utf-8",
    )
    assert main(["--config", str(cfg), "t4-check"]) == 0
    out = capsys.readouterr().out
    assert '"model_called": 0' in out
    assert "deferred_not_selected" in out
    assert "未执行" in out


def test_t4_report_lists_live_blockers_without_arming_adapters():
    config = parse_config(
        {
            "mode": "read_only",
            "data_dir": ".local/poc",
            "account": {"alias": "a"},
            "group": {"alias": "g", "display_name": "示例混合群"},
            "model": {"provider": "mock", "credential_source": "none"},
            "adapters": {
                "reader": "mock",
                "sender": "desktop_observed",
                "allow_live_send": True,
            },
        }
    )
    report = t4_report(config)
    assert config.allow_live_send is False
    assert report["verdict"] == "未执行"
    assert report["model_called"] == 0
    joined = " ".join(str(item) for item in report["g_send_blockers"])
    assert "manual_send" in joined
    assert "allow_live_send is false" in joined


def test_t4_send_halts_without_conditions(tmp_path: Path):
    with pytest.raises(HaltError) as caught:
        assert_t4_send_permitted(_offline_config(tmp_path))
    assert caught.value.halt.details.get("submit_stage") == "not_sent"


def test_observed_sender_still_does_not_type(tmp_path: Path):
    from wechat_agent_poc.models import Binding, WindowState

    sender = ObservedDesktopSender()
    binding = Binding(
        account_alias="a",
        account_wxid="wxid_example",
        group_alias="g",
        conversation_key="room@chatroom",
        binding_version="bv",
        member_features=(),
        display_name="示例混合群",
        required_detail_tokens=(),
    )
    window = WindowState(
        account_alias="a",
        account_wxid="wxid_example",
        display_name="示例混合群",
        conversation_key="room@chatroom",
        details="示例混合群",
        member_features=(),
        focus=True,
        rebuilt=False,
        located_by="operator_foreground_check",
    )
    with pytest.raises(HaltError) as caught:
        sender.send_text(binding, ack_text("t4-x", 1), window)
    assert caught.value.halt.details.get("submit_stage") == "not_sent"


def _manual_send_config(tmp_path: Path):
    return parse_config(
        {
            "mode": "manual_send",
            "data_dir": str(tmp_path / "st").replace("\\", "/"),
            "allow_live_send": True,
            "receivers": ["local-operator-wecom", "local-operator-wechat"],
            "account": {"alias": "a", "wxid": "wxid_example"},
            "group": {
                "alias": "g",
                "display_name": "示例混合群",
                "conversation_key": "room@chatroom",
                "member_features": ["someone"],
                "required_detail_tokens": ["示例混合群", "示例群主"],
            },
            "model": {"provider": "mock", "credential_source": "none"},
            "adapters": {"reader": "mock", "sender": "desktop_observed"},
            "window": {"observer": "weixin_ui"},
        }
    )


def test_weixin_ui_observer_loads():
    observer = load_window_observer("weixin_ui", None)
    assert observer.__class__.__name__ == "WeixinUiWindowObserver"


def test_titles_match_strips_unread_count():
    assert titles_match("示例混合群 (2)", "示例混合群")
    assert not titles_match("其他群", "示例混合群")


def test_matches_window_uia_title_skips_member_features():
    binding = Binding(
        account_alias="a",
        account_wxid="wxid_example",
        group_alias="g",
        conversation_key="room@chatroom",
        binding_version="bv",
        member_features=("someone",),
        display_name="示例混合群",
        required_detail_tokens=("示例混合群", "示例群主"),
    )
    ok, why = binding.matches_window(
        {
            "account_alias": "a",
            "account_wxid": "wxid_example",
            "display_name": "示例混合群 (3)",
            "conversation_key": "room@chatroom",
            "details": "",
            "member_features": [],
            "focus": True,
            "rebuilt": False,
            "located_by": "uia_selected_chat_title",
        }
    )
    assert ok and why == "ok"


def test_observe_wrong_title_does_not_send():
    def runner(params):
        return {"selected": "其他群", "status": "observed"}

    with pytest.raises(HaltError) as caught:
        observe_selected_chat(expected_display_name="示例混合群", runner=runner)
    assert caught.value.halt.details.get("submit_stage") == "not_sent"


def test_execute_t4_send_index_2_blocked(tmp_path: Path):
    config = _manual_send_config(tmp_path)
    with pytest.raises(HaltError) as caught:
        execute_t4_send(
            config,
            2,
            observe=lambda **_: {"selected": "示例混合群"},
            send=lambda *_: SendResult("local_ok", "no", local_bubble=True),
        )
    assert "ACK 2 and 3" in caught.value.halt.message
    assert caught.value.halt.details.get("submit_stage") == "not_sent"
    assert not (tmp_path / "st" / "t4-budget.json").exists()


def test_execute_t4_send_ack1_with_injected_ui(tmp_path: Path):
    config = _manual_send_config(tmp_path)
    sent: list[str] = []

    def send(binding, text, window):
        sent.append(text)
        assert window.located_by == "uia_selected_chat_title"
        return SendResult("local_ok", "injected", local_bubble=True)

    record = execute_t4_send(
        config,
        1,
        observe=lambda **_: {"selected": "示例混合群 (1)"},
        send=send,
    )
    assert record["index"] == 1
    assert record["model_called"] == 0
    assert record["native_mention"] == "deferred_not_selected"
    assert record["receive_confirmed"] is False
    assert sent[0].endswith("-001")
    budget = AtomicSendBudget(tmp_path / "st" / "t4-budget.json")
    assert budget.remaining() == 2


def test_execute_t4_send_refunds_when_not_sent(tmp_path: Path):
    config = _manual_send_config(tmp_path)

    def send(binding, text, window):
        raise HaltError(Halt("WINDOW_MISMATCH", "ui refused", {"submit_stage": "not_sent"}))

    with pytest.raises(HaltError):
        execute_t4_send(
            config,
            1,
            observe=lambda **_: {"selected": "示例混合群"},
            send=send,
        )
    budget = AtomicSendBudget(tmp_path / "st" / "t4-budget.json")
    assert budget.remaining() == 3


def test_t4_send_cli_offline_not_sent(tmp_path: Path, capsys):
    cfg = tmp_path / "cfg.toml"
    cfg.write_text(
        """
mode = "offline"
data_dir = "{data}"
allow_live_send = false
[account]
alias = "a"
[group]
alias = "g"
display_name = "示例混合群"
[model]
provider = "mock"
credential_source = "none"
[adapters]
reader = "mock"
sender = "mock"
""".format(data=str(tmp_path / "st").replace("\\", "/")),
        encoding="utf-8",
    )
    assert main(["--config", str(cfg), "t4-send", "--index", "1"]) == 2
    out = capsys.readouterr().out
    assert "not_sent" in out
    assert "model_called" in out
