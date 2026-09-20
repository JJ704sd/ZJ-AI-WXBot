import pytest

from wechat_agent_poc.m3_ocr import build_body, parse_lines


def response(finish='stop', tool_calls=None):
    return {'model': 'MiniMax-M3', 'choices': [{'finish_reason': finish,
        'message': {'content': '{"lines":["literal text"]}', 'tool_calls': tool_calls}}]}


def test_image_payload_has_no_expected_answer_or_tools():
    body = build_body(b'example')
    assert body['messages'][1]['content'][1]['image_url']['url'].startswith('data:image/png;base64,')
    assert 'tools' not in body
    assert body['thinking']['type'] == 'disabled'


@pytest.mark.parametrize('raw', [response('length'), response(tool_calls=[{'id': 'x'}])])
def test_incomplete_or_tool_response_not_accepted_as_ocr(raw):
    with pytest.raises(ValueError):
        parse_lines(raw)


def test_transcription_is_not_normalized_or_corrected():
    raw = response()
    raw['choices'][0]['message']['content'] = '{"lines":["AI Al I1 0O"]}'
    assert parse_lines(raw) == ['AI Al I1 0O']
