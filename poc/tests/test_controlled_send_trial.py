import json
from pathlib import Path
from types import SimpleNamespace

import pytest

from wechat_agent_poc import controlled_send_trial as trial


def _plan():
    return {
        "hwnd": 123,
        "expected_window_observation": {
            "kind": "live_window", "available": True, "hwnd": 123,
            "capture_method": "screen_region", "pid": 456, "created": 1.0,
            "rect": [0, 0, 900, 700], "size": [900, 700], "dpi": 96,
        },
        "text": "UIA-ACK-001",
        "compose_point": [400, 600],
        "send_point": [850, 600],
    }


def test_plan_rejects_control_characters_and_wrong_prefix():
    value = _plan()
    value["text"] = "hello\n"
    with pytest.raises(ValueError, match="invalid_text_prefix"):
        trial.validate_plan(value)
    value["text"] = "UIA-ACK-\t001"
    with pytest.raises(ValueError, match="text_contains_control_character"):
        trial.validate_plan(value)


def test_submit_marks_attempt_and_never_retries(monkeypatch, tmp_path):
    plan = _plan()
    plan_path = tmp_path / "plan.json"
    plan_path.write_text(json.dumps(plan), encoding="utf-8")
    run_dir = tmp_path / "trial"
    run_dir.mkdir()
    digest = trial.plan_sha256(plan)
    (run_dir / "state.json").write_text(json.dumps({
        "status": "staged", "plan_sha256": digest, "retry_allowed": False,
    }), encoding="utf-8")

    class Image:
        def save(self, path, format=None):
            Path(path).write_bytes(b"png")
        def close(self):
            pass

    class Backend:
        def __init__(self, hwnd, method):
            assert (hwnd, method) == (123, "screen_region")
        def observe(self):
            return plan["expected_window_observation"]
        def capture(self):
            return Image()

    monkeypatch.setattr(trial, "_foreground_hwnd", lambda: 123)
    monkeypatch.setattr(trial, "click_window_point", lambda *args: None)
    monkeypatch.setattr(trial, "type_unicode", lambda *args: None)
    monkeypatch.setattr("wechat_agent_poc.hybrid_windows.WindowsBackend", Backend)

    assert trial.run(plan_path, run_dir, "submit") == 0
    assert json.loads((run_dir / "state.json").read_text(encoding="utf-8"))["status"] == "submitted_unverified"
    assert trial.run(plan_path, run_dir, "submit") == 2
    assert json.loads((run_dir / "state.json").read_text(encoding="utf-8"))["status"] == "submitted_unverified"
    assert json.loads((run_dir / "failure.json").read_text(encoding="utf-8"))["reason"] == "attempt_already_recorded"
