"""Compare exact code windows offline; matches never authorize a runtime hook."""
import argparse
import hashlib
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.hook_target_analysis import PEImage
from scripts.analyze_hook_target import LEGACY_RVAS


def compare(reference, target, rvas):
    old, new = PEImage(reference), PEImage(target)
    rows = []
    for name, rva in rvas.items():
        source = old.audit_legacy_rva(name, rva)
        row = {'name': name, 'reference_rva': hex(rva), 'reference_audit': source,
               'windows': [], 'usable_for_hook': False}
        if source['executable']:
            for width in (16, 32, 64):
                try:
                    needle = old.read(old.rva_offset(rva, width), width)
                except ValueError:
                    continue
                hits, count = [], 0
                for section in new.sections:
                    if not section['executable']:
                        continue
                    block = new.read(section['raw_offset'], section['raw_size'])
                    position = 0
                    while (position := block.find(needle, position)) >= 0:
                        count += 1
                        if len(hits) < 20:
                            hit = section['rva'] + position
                            hits.append({'rva': hex(hit), 'runtime_function': new.function_at(hit)})
                        position += 1
                row['windows'].append({'bytes': width, 'count': count, 'matches': hits,
                                       'truncated': count > len(hits)})
        rows.append(row)
    return {'schema_version': 'windows-hook-reference-comparison.v1',
            'reference_sha256': hashlib.sha256(reference).hexdigest(),
            'target_sha256': hashlib.sha256(target).hexdigest(), 'results': rows,
            'runtime_offsets_verified': False,
            'limitations': ['Exact byte matches are leads, not semantic or instruction-boundary proof.',
                           'Zero matches do not prove absence; relative addresses and compiler changes affect bytes.',
                           'Reference RVA semantics require independent validation.']}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('reference', 'target', 'output'):
        parser.add_argument('--' + name, type=Path, required=True)
    for name in ('reference-sha256', 'target-sha256'):
        parser.add_argument('--' + name, required=True)
    args = parser.parse_args()
    reference, target = args.reference.read_bytes(), args.target.read_bytes()
    for data, expected in ((reference, args.reference_sha256), (target, args.target_sha256)):
        if hashlib.sha256(data).hexdigest() != expected.lower():
            raise ValueError('input hash mismatch')
    result = compare(reference, target, LEGACY_RVAS)
    with args.output.open('x', encoding='utf-8') as stream:
        json.dump(result, stream, indent=2)
        stream.write('\n')
    print('offline comparison complete; runtime_offsets_verified=false')


if __name__ == '__main__':
    main()
