from __future__ import annotations

from pathlib import Path

import pytest

from wechat_agent_poc.models import Halt, HaltError
from wechat_agent_poc.process_own import resolve_owned_weixin_pid

from test_v03_gates import AUTHORIZED, EXCLUDED, _live_cfg
from wechat_agent_poc.key_material import obtain_live_client_material


def test_target_query_error_blocks_even_if_holders_returned():
    def lookup(paths):
        return [101], "RmGetList failed winerror=5"

    with pytest.raises(HaltError) as caught:
        resolve_owned_weixin_pid(
            [Path("target.db")],
            excluded_files=[Path("excluded.db")],
            pid_lookup=lambda: [101],
            holders_lookup=lookup,
        )
    assert caught.value.halt.details.get("reason") == "ownership_query_unknown"
    assert caught.value.halt.details.get("query") == "target"


def test_excluded_query_error_blocks_unique_target():
    def lookup(paths):
        names = [Path(item).name for item in paths]
        if any("excluded" in name for name in names):
            return [], "RmGetList failed winerror=5"
        return [202], None

    with pytest.raises(HaltError) as caught:
        resolve_owned_weixin_pid(
            [Path("target.db")],
            excluded_files=[Path("excluded.db")],
            pid_lookup=lambda: [202],
            holders_lookup=lookup,
        )
    assert caught.value.halt.details.get("reason") == "ownership_query_unknown"
    assert caught.value.halt.details.get("query") == "excluded"


def test_excluded_holder_on_other_pid_is_not_automatic_failure():
    def lookup(paths):
        names = [Path(item).name for item in paths]
        if any("excluded" in name for name in names):
            return [303], None
        return [202], None

    result = resolve_owned_weixin_pid(
        [Path("target.db")],
        excluded_files=[Path("excluded.db")],
        pid_lookup=lambda: [202, 303],
        holders_lookup=lookup,
    )
    assert result["candidate_count"] == 1
    assert result["pid"] == 202
    assert result["excluded_holder_count"] == 1
    assert result["overlap_pid_count"] == 0
    assert result["target_query_ok"] is True
    assert result["excluded_query_ok"] is True


def test_overlap_still_blocks():
    def lookup(paths):
        return [202], None

    with pytest.raises(HaltError) as caught:
        resolve_owned_weixin_pid(
            [Path("target.db")],
            excluded_files=[Path("excluded.db")],
            pid_lookup=lambda: [202],
            holders_lookup=lookup,
        )
    assert caught.value.halt.details.get("reason") == "process_account_not_unique"


def test_obtain_still_queries_missing_excluded_path(tmp_path: Path):
    config = _live_cfg(tmp_path, allow_key_material_from_live_client=True)
    (tmp_path / "xwechat_files" / AUTHORIZED).mkdir(parents=True)
    seen: dict[str, list[Path]] = {}

    def resolver(files, excluded_files=None, **_kwargs):
        seen["excluded"] = list(excluded_files or [])
        raise HaltError(
            Halt(
                "READ_FAILURE",
                "stop after capturing excluded paths",
                {"phase": "G-KEY", "reason": "authorized_account_not_live"},
            )
        )

    with pytest.raises(HaltError):
        obtain_live_client_material(config, pid_resolver=resolver, scanner=lambda _pid: [])
    assert seen["excluded"]
    assert any(EXCLUDED in str(path) for path in seen["excluded"])
    assert not any(path.exists() for path in seen["excluded"])
