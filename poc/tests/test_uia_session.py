import pytest
from wechat_agent_poc.uia_session import UiaSessionReader, UiaReadBlocked


class Backend:
    def __init__(self):
        self.state = dict(title='synthetic', generation='g1', account_verified=True,
                          group_verified=True, locked=False)
        self.rows = []
        self.reads = 0

    def observe(self):
        return self.state

    def read_visible(self):
        self.reads += 1
        return self.rows


def row(key, text='same', attr='friend'):
    return dict(ui_id=key, text=text, type='text', attr=attr)


def reader(backend):
    return UiaSessionReader(backend, expected_title='synthetic', generation='g1')


def test_baseline_and_identical_content_distinct_ids():
    backend = Backend()
    backend.rows = [row('1')]
    subject = reader(backend)
    assert subject.poll() == []
    backend.rows.append(row('2'))
    assert [r['ui_id'] for r in subject.poll()] == ['2']
    assert subject.poll() == []


@pytest.mark.parametrize('field,value', [('title', ''), ('account_verified', False),
                         ('group_verified', False), ('locked', True), ('generation', 'new')])
def test_unverified_snapshot_no_read(field, value):
    backend = Backend()
    backend.state[field] = value
    with pytest.raises(UiaReadBlocked):
        reader(backend).poll()
    assert backend.reads == 0


def test_missing_identity_and_no_retry():
    backend = Backend()
    backend.rows = [row('')]
    subject = reader(backend)
    with pytest.raises(UiaReadBlocked):
        subject.poll()
    with pytest.raises(UiaReadBlocked):
        subject.poll()
    assert backend.reads == 1


def test_self_ignored_mention_not_guessed():
    backend = Backend()
    subject = reader(backend)
    subject.poll()
    backend.rows = [row('1', attr='self'), row('2', '@nickname question')]
    result = subject.poll()
    assert len(result) == 1 and result[0]['mention_status'] == 'unknown'


def test_lost_overlap_blocks():
    backend = Backend()
    backend.rows = [row('1')]
    subject = reader(backend)
    subject.poll()
    backend.rows = [row('2')]
    with pytest.raises(UiaReadBlocked):
        subject.poll()
