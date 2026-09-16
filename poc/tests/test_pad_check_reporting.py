import json
from pathlib import Path

from wechat_agent_poc.pad_cli import _check
from wechat_agent_poc.pad_config import parse_pad_config, parse_pad_provider_profile


def test_legacy_check_does_not_apply_max_vectors_or_deny_recorded_hash(tmp_path, capsys):
    root = Path(__file__).resolve().parents[1]
    raw = json.loads((root / "pad-provider-profile.legacy.example.json").read_text(encoding="utf-8"))
    raw["product"]["binary_sha256_or_digest"] = {"status": "observed", "value": "sha256:" + "a" * 64}
    config = parse_pad_config({"config_version": "pad-config/1", "api_flavor": "legacy",
                               "observation_store_path": str(tmp_path / "observe.sqlite"),
                               "agent_state_path": str(tmp_path / "agent.sqlite")},
                              profile=parse_pad_provider_profile(raw))
    assert _check(config, probe=False) == 0
    report = json.loads(capsys.readouterr().out)
    assert report["hmac"]["status"] == "unknown"
    assert report["build_evidence"]["binary_sha256_or_digest"]["value"] == "sha256:" + "a" * 64
    assert "not locked" not in report["note"]
    assert "no locked build/hash" not in json.dumps(report)
    assert report["p0_closed"] is False
    assert report["network"] is report["model"] is report["send"] is False
