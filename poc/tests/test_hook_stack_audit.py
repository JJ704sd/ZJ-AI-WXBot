import struct

from scripts.audit_hook_stack_candidates import imports
from test_hook_target_analysis import synthetic_pe
from wechat_agent_poc.hook_target_analysis import PEImage


def test_import_names_and_ordinals_are_mapped_to_iat_slots():
    data = bytearray(synthetic_pe())
    struct.pack_into('<II', data, 0x98 + 112 + 8, 0x2020, 40)
    struct.pack_into('<IIIII', data, 0x420, 0x2080, 0, 0, 0x2060, 0x20a0)
    data[0x460:0x46d] = b'KERNEL32.dll\0'
    struct.pack_into('<QQQ', data, 0x480, 0x20c0, (1 << 63) | 7, 0)
    data[0x4c2:0x4dc] = b'TryAcquireSRWLockExclusive\0'
    result = imports(PEImage(bytes(data)))
    assert result[0x20a0] == 'KERNEL32.dll!TryAcquireSRWLockExclusive'
    assert result[0x20a8] == 'KERNEL32.dll!ordinal:7'


def test_empty_import_directory_has_no_symbols():
    assert imports(PEImage(synthetic_pe())) == {}
