"""Inventory disk-only protocol strings and tentative RIP-relative LEA references."""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.hook_target_analysis import PEImage

KEYWORDS = ('longlink', 'shortlink', 'Req2Buf', 'Buf2Resp', 'OnPush',
            'new_sync', 'newsendmsg', 'AddMsg', 'SyncKey', 'SyncCheck',
            'protobuf', '/cgi-bin/micromsg-bin/')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--module', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    image = PEImage(args.module.read_bytes())
    targets, rows = {}, []
    for keyword in KEYWORDS:
        count, string_starts = 0, set()
        for section in image.sections:
            if section['executable']:
                continue
            data = image.read(section['raw_offset'], section['raw_size'])
            pos = 0
            while (pos := data.find(keyword.encode(), pos)) >= 0:
                count += 1
                start = data.rfind(b'\0', max(0, pos-512), pos) + 1
                # Only bounded printable ASCII strings; substring counts remain separate.
                if pos-start < 512 and all(32 <= c < 127 for c in data[start:pos]):
                    string_starts.add(section['rva'] + start)
                pos += len(keyword)
        rows.append({'keyword': keyword, 'substring_count': count,
                     'bounded_ascii_string_count': len(string_starts)})
        for address in string_starts:
            targets.setdefault(address, set()).add(keyword)
    refs = {key: set() for key in KEYWORDS}
    for section in image.sections:
        if not section['executable']:
            continue
        data = image.read(section['raw_offset'], section['raw_size'])
        for prefix in (b'\x48\x8d', b'\x4c\x8d'):
            pos = 0
            while (pos := data.find(prefix, pos)) >= 0:
                if pos+7 <= len(data) and data[pos+2] & 0xc7 == 5:
                    rva = section['rva']+pos
                    target = rva+7+struct.unpack_from('<i', data, pos+3)[0]
                    for key in targets.get(target, ()):
                        refs[key].add(rva)
                pos += 1
    for row in rows:
        locations = refs[row['keyword']]
        functions = {image.function_at(r)['begin_rva'] for r in locations if image.function_at(r)}
        row.update(tentative_lea_reference_count=len(locations),
                   enclosing_runtime_function_count=len(functions))
    report = {'schema_version': 'hook-protocol-anchor-audit.v1',
              'module_sha256': hashlib.sha256(image.data).hexdigest(),
              'live_process_accessed': False, 'protocol_verified': False, 'anchors': rows,
              'limitations': ['Case-sensitive ASCII substrings in non-executable sections only.',
                             'LEA byte matches are tentative, not disassembly-validated cross references.',
                             'Strings and reference counts do not prove executed routes or message schemas.']}
    with args.output.open('x', encoding='utf-8') as stream:
        json.dump(report, stream, indent=2)
        stream.write('\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
