from scripts.compare_hook_reference_windows import compare
from test_hook_target_analysis import synthetic_pe


def test_unique_and_duplicate_windows_never_become_trusted_offsets():
    old = bytearray(synthetic_pe())
    old[0x210:0x250] = bytes(range(64))
    new = bytearray(old)
    new[0x280:0x2c0] = bytes(range(64))
    row = compare(bytes(old), bytes(new), {'example': 0x1010})['results'][0]
    assert [w['count'] for w in row['windows']] == [2, 2, 2]
    assert row['usable_for_hook'] is False
    assert row['windows'][2]['matches'][1]['rva'] == '0x1080'


def test_nonexecutables_are_not_searched_as_code_and_mismatch_is_not_a_match():
    old = bytearray(synthetic_pe())
    old[0x210:0x250] = bytes(range(64))
    new = bytearray(synthetic_pe())
    new[0x480:0x4c0] = bytes(range(64))
    report = compare(bytes(old), bytes(new), {'code': 0x1010, 'data': 0x2000})
    assert all(w['count'] == 0 for w in report['results'][0]['windows'])
    assert report['results'][1]['windows'] == []
    assert report['runtime_offsets_verified'] is False
