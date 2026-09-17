import json
from pathlib import Path
import struct
import subprocess
import sys

import pytest

from wechat_agent_poc.hook_compatibility import SCHEMA, check_compatibility, inspect_pe


def inputs():
    module = {"version": "4.1.13.65", "arch": "x64", "sha256": "a" * 64}
    observed = {"schema_version": SCHEMA, "client_version": module["version"], "client_arch": "x64", "modules": {"synthetic.dll": module}}
    candidate = {"schema_version": SCHEMA, "candidate_ref": "synthetic-test-only", "repository": "synthetic", "commit": "b" * 40, "target_evidence_reviewed": True, "evidence_refs": ["synthetic fixture, not observed"], "client_version": module["version"], "client_arch": "x64", "required_modules": [{"name": "synthetic.dll", "version": module["version"], "arch": "x64", "allowed_sha256": [module["sha256"]]}]}
    return observed, candidate


def test_match_does_not_grant_live_or_build_status():
    result = check_compatibility(*inputs())
    assert result["compatibility_status"] == "match"
    assert all(result[key] is False for key in ("build_verified", "source_complete", "live_receive_verified", "mixed_group_verified", "send_delivery_verified"))


@pytest.mark.parametrize("key,value", [("client_version", "4.1.11.52"), ("client_arch", "arm64")])
def test_known_conflicts_override_missing_evidence(key, value):
    observed, candidate = inputs()
    candidate[key] = value
    candidate["required_modules"] = []
    assert check_compatibility(observed, candidate)["compatibility_status"] == "mismatch"


@pytest.mark.parametrize("key,value", [("sha256", "c" * 64), ("version", "4.1.13.64"), ("arch", "x86")])
def test_module_mismatch(key, value):
    observed, candidate = inputs()
    observed["modules"]["synthetic.dll"][key] = value
    assert check_compatibility(observed, candidate)["compatibility_status"] == "mismatch"


@pytest.mark.parametrize("key,value", [("required_modules", []), ("required_modules", None), ("target_evidence_reviewed", "true"), ("commit", "main"), ("evidence_refs", []), ("client_version", None), ("client_arch", [])])
def test_missing_or_malformed_contract_never_matches(key, value):
    observed, candidate = inputs()
    candidate[key] = value
    assert check_compatibility(observed, candidate)["compatibility_status"] == "unknown"


def test_missing_module_and_invalid_hash():
    observed, candidate = inputs()
    observed["modules"] = {}
    candidate["required_modules"][0]["allowed_sha256"] = ["invalid"]
    assert check_compatibility(observed, candidate)["compatibility_status"] == "unknown"


def test_duplicate_contract_is_unknown():
    observed, candidate = inputs()
    candidate["required_modules"] *= 2
    assert check_compatibility(observed, candidate)["compatibility_status"] == "unknown"


def test_unsupported_schema():
    observed, candidate = inputs()
    candidate["schema_version"] = "future"
    with pytest.raises(ValueError):
        check_compatibility(observed, candidate)


def test_pe_inspection_and_truncation(tmp_path):
    path = tmp_path / "synthetic.exe"
    data = bytearray(134)
    data[:2] = b"MZ"
    data[60:64] = struct.pack("<I", 128)
    data[128:] = b"PE\0\0" + struct.pack("<H", 0x8664)
    path.write_bytes(data)
    assert inspect_pe(path)["arch"] == "x64"
    assert len(inspect_pe(path)["sha256"]) == 64
    path.write_bytes(b"MZ")
    with pytest.raises(ValueError):
        inspect_pe(path)


def test_cli_preserves_existing_evidence(tmp_path):
    observed, candidate = inputs()
    paths = [tmp_path / name for name in ("observed.json", "candidate.json", "result.json")]
    for path, value in zip(paths, (observed, candidate)):
        path.write_text(json.dumps(value), encoding="utf-8")
    script = Path(__file__).resolve().parents[1] / "scripts" / "check_hook_compatibility.py"
    command = [sys.executable, str(script), "--observed", str(paths[0]), "--candidate", str(paths[1]), "--output", str(paths[2])]
    assert subprocess.run(command, capture_output=True).returncode == 0
    original = paths[2].read_bytes()
    assert subprocess.run(command, capture_output=True).returncode == 2
    assert paths[2].read_bytes() == original
