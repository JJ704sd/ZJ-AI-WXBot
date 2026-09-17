import struct

import pytest

from wechat_agent_poc.hook_target_analysis import PEImage, analyze_target


def synthetic_pe():
    data = bytearray(0x800)
    data[:2] = b"MZ"
    struct.pack_into("<I", data, 0x3C, 0x80)
    data[0x80:0x84] = b"PE\0\0"
    struct.pack_into("<HHIIIHH", data, 0x84, 0x8664, 3, 0, 0, 0, 240, 0)
    opt = 0x98
    struct.pack_into("<H", data, opt, 0x20B)
    struct.pack_into("<Q", data, opt + 24, 0x180000000)
    struct.pack_into("<I", data, opt + 60, 0x200)
    struct.pack_into("<I", data, opt + 108, 16)
    struct.pack_into("<II", data, opt + 112 + 3 * 8, 0x3000, 12)
    for i, (name, rva, raw, flags) in enumerate(((b'.text', 0x1000, 0x200, 0x20000000), (b'.rdata', 0x2000, 0x400, 0), (b'.pdata', 0x3000, 0x600, 0))):
        off = opt + 240 + i * 40
        data[off:off + len(name)] = name
        struct.pack_into("<IIII", data, off + 8, 0x300, rva, 0x200, raw)
        struct.pack_into("<I", data, off + 36, flags)
    struct.pack_into("<III", data, 0x600, 0x1010, 0x1040, 0x2080)
    data[0x400:0x409] = b"SendText\0"
    return bytes(data)


def test_sections_and_function_boundaries_never_prove_semantics():
    report = analyze_target(synthetic_pe(), {'entry': 0x1010, 'middle': 0x1020, 'end': 0x1040})
    rows = report['legacy_rva_audit']
    assert rows[0]['runtime_function']['at_begin'] is True
    assert rows[1]['runtime_function']['at_begin'] is False
    assert rows[2]['runtime_function'] is None
    assert all(x['usable_for_hook'] is False for x in rows)
    assert report['runtime_offsets_verified'] is False
    anchor = next(x for x in report['string_anchors'] if x['keyword'] == 'SendText')
    assert anchor['matches'][0]['rva'] == '0x2000'


def test_virtual_tail_is_not_file_backed():
    image = PEImage(synthetic_pe())
    assert image.rva_offset(0x1010) == 0x210
    with pytest.raises(ValueError):
        image.rva_offset(0x1200)
    assert image.audit_legacy_rva('missing', 0x9999)['file_offset'] is None


@pytest.mark.parametrize('cut', [0, 63, 130, 512, 1600])
def test_truncated_file_is_rejected(cut):
    with pytest.raises(ValueError):
        PEImage(synthetic_pe()[:cut])


def test_invalid_architecture_and_exception_table():
    data = bytearray(synthetic_pe())
    struct.pack_into('<H', data, 0x84, 0x14C)
    with pytest.raises(ValueError):
        PEImage(bytes(data))
    data = bytearray(synthetic_pe())
    struct.pack_into('<I', data, 0x98 + 112 + 3 * 8 + 4, 11)
    with pytest.raises(ValueError):
        PEImage(bytes(data))
