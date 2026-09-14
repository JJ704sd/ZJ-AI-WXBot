from __future__ import annotations

from pathlib import Path

from wechat_agent_poc.cli import main
from wechat_agent_poc.config import missing_live_fields

from conftest import make_config


def test_missing_live_fields_listed():
    config = make_config(Path("."), wechat_version_recorded="", receivers=[])
    missing = missing_live_fields(config)
    assert "wechat_version_recorded" in missing
    assert "receivers (wecom + wechat verifiers)" in missing


def test_cli_status_and_r0(tmp_path: Path, capsys):
    config_path = tmp_path / "config.toml"
    config_path.write_text(
        """
mode = "offline"
data_dir = "{data}"
lookback_seconds = 120
context_limit = 20
max_draft_chars = 500
approval_ttl_seconds = 300

[account]
alias = "test-wechat-a"
wxid = ""
data_root = ""
authorized_key_ref = "none"

[group]
alias = "g"
conversation_key = "synthetic_group@openim"
binding_version = "bv-1"
member_features = []
display_name = ""
required_detail_tokens = []

[model]
provider = "mock"
credential_source = "none"

[adapters]
reader = "mock"
sender = "mock"
""".format(data=str(tmp_path / "state").replace("\\", "/")),
        encoding="utf-8",
    )
    assert main(["--config", str(config_path), "status"]) == 0
    assert main(["--config", str(config_path), "r0-check"]) == 0
    out = capsys.readouterr().out
    assert "offline" in out
    assert "process_key_extraction" in out
