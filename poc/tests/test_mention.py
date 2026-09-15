from __future__ import annotations

import sqlite3
from pathlib import Path

from wechat_agent_poc.cli import main
from wechat_agent_poc.mention import classify_mention
from wechat_agent_poc.mocking import make_event
from wechat_agent_poc.reader import SqlitePlainReader
from wechat_agent_poc.store import Store

from conftest import ACCOUNT, CONVERSATION, TIME, account_dir, make_config, table_for, write_db

SELF = "wxid_example_account"
OTHER = "10000000000000001@openim"


def test_structured_self_only_is_true():
    decision = classify_mention(
        self_sender_key=SELF,
        fields={"atuserlist": SELF},
        text="@示例本人 你好",
    )
    assert decision.mention_self == "true"
    assert decision.mentioned_keys == (SELF,)
    ok, reason = make_event(
        conversation=CONVERSATION,
        message_id=10,
        text="@示例本人 现在几点",
        sender=OTHER,
    ).eligible_for_mention_reply()
    # default event mention_self is unknown
    assert ok is False
    assert reason == "mention_unknown"


def test_nickname_text_without_field_is_unknown():
    decision = classify_mention(self_sender_key=SELF, fields={}, text="@示例本人 请回答")
    assert decision.mention_self == "unknown"
    assert decision.reason == "mention_field_absent"


def test_mention_all_and_mixed_and_other_are_false():
    assert classify_mention(self_sender_key=SELF, fields={"atuserlist": "notify@all"}).mention_all is True
    mixed = classify_mention(self_sender_key=SELF, fields={"atuserlist": f"{SELF},{OTHER}"})
    assert mixed.mention_self == "false"
    other = classify_mention(self_sender_key=SELF, fields={"atuserlist": OTHER})
    assert other.mention_self == "false"


def test_quote_embedded_at_does_not_trigger():
    xml = (
        "<msgsource></msgsource><refermsg><atuserlist>"
        f"{SELF}</atuserlist></refermsg>"
    )
    decision = classify_mention(self_sender_key=SELF, fields={"source": xml}, text="quoting you")
    assert decision.mention_self != "true"


def test_parse_failure_is_unknown_not_nickname():
    decision = classify_mention(
        self_sender_key=SELF,
        fields={"packed_info": b"\xff\x00not-a-mention-field"},
        text="@示例本人",
    )
    assert decision.mention_self == "unknown"


def test_live_packed_info_without_member_ids_is_false_not_unknown():
    decision = classify_mention(
        self_sender_key=SELF,
        fields={"packed_info_data": bytes.fromhex("081010025800")},
        text="@示例本人 看起来像@",
    )
    assert decision.mention_self == "false"
    assert decision.reason in {"protobuf_no_mention_ids", "structured_empty"}
    assert decision.source_field == "packed_info_data"
    decision = classify_mention(self_sender_key=SELF, fields={"at_list": []}, text="@示例本人")
    assert decision.mention_self == "false"


def test_empty_packed_info_does_not_hide_source_atuserlist():
    decision = classify_mention(
        self_sender_key=SELF,
        fields={
            "packed_info_data": bytes.fromhex("081010025800"),
            "source": f"<msgsource><atuserlist>{SELF}</atuserlist></msgsource>",
        },
        text="@示例本人 收到请回复",
    )
    assert decision.mention_self == "true"
    assert decision.source_field == "source"
    assert decision.mentioned_keys == (SELF,)
    fake = classify_mention(
        self_sender_key=SELF,
        fields={
            "packed_info_data": bytes.fromhex("081010025800"),
            "source": "<msgsource></msgsource>",
        },
        text="@示例本人 收到请回复",
    )
    assert fake.mention_self == "false"


def test_unescaped_msgsource_still_reads_atuserlist():
    messy = (
        "<msgsource><signature>a & b</signature>"
        f"<atuserlist>{SELF}</atuserlist></msgsource>"
    )
    decision = classify_mention(
        self_sender_key=SELF,
        fields={"packed_info_data": bytes.fromhex("081010025800"), "source": messy},
        text="@示例本人 示例文本，收到请回复，over",
    )
    assert decision.mention_self == "true"
    assert decision.mentioned_keys == (SELF,)
    assert decision.source_field == "source"


def test_zstd_source_atuserlist_is_true():
    import zstandard

    xml = f"<msgsource>\n\t<atuserlist>{SELF}</atuserlist>\n</msgsource>".encode("utf-8")
    blob = zstandard.ZstdCompressor().compress(xml)
    assert blob.startswith(b"\x28\xb5\x2f\xfd")
    decision = classify_mention(
        self_sender_key=SELF,
        fields={"packed_info_data": bytes.fromhex("081010025800"), "source": blob},
        text="@示例本人 示例文本，收到请回复，over",
    )
    assert decision.mention_self == "true"
    assert decision.mentioned_keys == (SELF,)
    assert decision.source_field == "source"


def test_reader_uses_packed_info_not_body(tmp_path: Path):
    config = make_config(tmp_path, account={"self_sender_key": SELF, "wxid": ACCOUNT})
    message_dir = account_dir(tmp_path / "data", ACCOUNT)
    db = message_dir / "message_0.db"
    write_db(db, CONVERSATION, [], self_wxid=SELF)
    table = table_for(CONVERSATION)
    conn = sqlite3.connect(db)
    conn.execute(f'ALTER TABLE "{table}" ADD COLUMN packed_info TEXT')
    conn.commit()
    conn.close()
    store = Store(tmp_path / "s.sqlite")
    reader = SqlitePlainReader(config, store)
    assert reader.read_new_messages() == []
    conn = sqlite3.connect(db)
    conn.execute(
        f'INSERT INTO "{table}" VALUES (20, ?, ?, NULL, 9, 1, 0, ?)',
        (TIME + 10, "@示例本人 现在几点", SELF),
    )
    conn.commit()
    conn.close()
    events = reader.read_new_messages()
    assert len(events) == 1
    assert events[0].mention_self == "true"
    assert events[0].mentioned_keys == (SELF,)
    assert events[0].eligible_for_mention_reply()[0] is True


def test_t2_scan_cli_does_not_send(tmp_path: Path, capsys):
    cfg = tmp_path / "cfg.toml"
    cfg.write_text(
        f"""
mode = "offline"
data_dir = "{str(tmp_path / "st").replace(chr(92), "/")}"
[account]
alias = "a"
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
    assert main(
        [
            "--config",
            str(cfg),
            "t2-scan",
            "--self-sender-key",
            SELF,
            "--field",
            f"atuserlist={SELF}",
            "--text",
            "@示例本人 现在几点",
        ]
    ) == 0
    out = capsys.readouterr().out
    assert '"mention_self": "true"' in out
    fake = main(
        [
            "--config",
            str(cfg),
            "t2-scan",
            "--self-sender-key",
            SELF,
            "--text",
            "@示例本人 现在几点",
        ]
    )
    assert fake == 0
    out = capsys.readouterr().out
    assert "unknown" in out
