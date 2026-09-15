import io
import json
import pytest
from wechat_agent_poc.general_qa import GeneralQA


class Transport:
    def __init__(self, content='答案', **message):
        self.calls = []
        self.raw = {'model': 'MiniMax-M3', 'choices': [{'finish_reason': 'stop',
                    'message': {'content': content, **message}}]}

    def open(self, req, timeout):
        self.calls.append(json.loads(req.data))
        return io.BytesIO(json.dumps(self.raw).encode())


def test_minimal_payload():
    transport = Transport()
    result = GeneralQA('synthetic', opener=transport).answer('问题')
    assert result['status'] == 'ok'
    assert transport.calls[0]['messages'][1] == {'role': 'user', 'content': '问题'}
    assert len(transport.calls[0]['messages']) == 2
    assert 'tools' not in transport.calls[0]


@pytest.mark.parametrize('text', ['', '字' * 301, '<think>秘密</think>答案'])
def test_invalid_answers(text):
    assert GeneralQA('synthetic', opener=Transport(text)).answer('问题')['text'] is None


def test_tool_rejected():
    assert GeneralQA('synthetic', opener=Transport(tool_calls=[{}])).answer('问题')['text'] is None


def test_late_response_discarded_without_retry():
    transport = Transport()
    ticks = iter([0, 13])
    result = GeneralQA('synthetic', opener=transport, clock=lambda: next(ticks)).answer('问题')
    assert result['status'] == 'timeout' and result['text'] is None
    assert len(transport.calls) == 1


def test_invalid_input_no_request():
    transport = Transport()
    assert GeneralQA('synthetic', opener=transport).answer({'event': 'no'})['status'] == 'invalid_input'
    assert transport.calls == []
