import pytest

from wechat_agent_poc.numbered_read_check import evaluate_numbered


def snapshot(texts):
    return {'capture_kind': 'offline_image', 'snapshot_id': 'synthetic',
            'messages': [{'text': text} for text in texts]}


@pytest.mark.parametrize('before,after,matched', [
    ([], ['UIA-READ-001 测试消息一'], True),
    (['UIA-READ-001'], ['UIA-READ-001 测试消息一'], False),
    ([], ['UIA-READ-001 测试消息一'] * 2, False),
    ([], ['UIA-READ-001 错误内容'], False),
])
def test_only_absent_to_single_complete_line_qualifies(before, after, matched):
    result = evaluate_numbered(snapshot(before), snapshot(after), ['UIA-READ-001 测试消息一'])
    assert result['expected_strings_newly_visible'] == matched
    assert not result['new_messages_verified'] and not result['native_mentions_verified']
