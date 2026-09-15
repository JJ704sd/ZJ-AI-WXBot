from __future__ import annotations

from wechat_agent_poc.probe import file_version, first_existing, probe_machine
from wechat_agent_poc.probe import WEIXIN_EXE_CANDIDATES


def test_probe_does_not_open_chat_data():
    report = probe_machine()
    assert report["accounts_listed"] is False
    assert report["chat_databases_opened"] is False
    assert report["process_memory_read"] is False
    assert report["key_extraction"] is False
    assert "data_roots" in report
    exe = first_existing(WEIXIN_EXE_CANDIDATES)
    if exe is not None:
        version = file_version(exe)
        assert version
        assert version.count(".") == 3
        assert report["weixin_file_version"] == version
