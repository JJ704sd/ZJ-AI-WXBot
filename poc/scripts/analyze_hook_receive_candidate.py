"""Reproduce a fixed, offline 4.1.11.52 -> 4.1.13.65 receive-site hypothesis."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.hook_target_analysis import PEImage

def normalize(assembly, start, end):
    assembly = assembly.split('#')[0].strip()
    assembly = re.sub(r'\[rip[+-]0x[0-9a-f]+\]', '[rip+REL]', assembly)
    # Retain internal branch topology and ordinary immediates/field offsets.
    match = re.match(r'^(call|j\w+)\s+0x([0-9a-f]+)$', assembly)
    if match:
        address = int(match[2], 16)
        operand = f'FUNCTION+{hex(address-start)}' if start <= address < end else 'EXTERNAL'
        assembly = f'{match[1]} {operand}'
    return assembly


def disassemble(tool, path, image, function):
    start = image.image_base + int(function['begin_rva'], 16)
    end = image.image_base + int(function['end_rva'], 16)
    output = subprocess.run([str(tool), '-d', '-M', 'intel', '--insn-width=16',
                             f'--start-address={start}', f'--stop-address={end}', str(path)],
                            check=True, capture_output=True, text=True, timeout=30).stdout
    instructions = []
    for line in output.splitlines():
        match = re.match(r'^\s*([0-9a-f]+):\s*((?:[0-9a-f]{2}\s+)+)\s*(.*)$', line)
        if match:
            address, raw, assembly = match.groups()
            instructions.append({'rva': hex(int(address, 16)-image.image_base),
                                 'size': len(raw.split()),
                                 'normalized': normalize(assembly, start, end)})
    cursor = start - image.image_base
    for instruction in instructions:
        if int(instruction['rva'], 16) != cursor:
            raise ValueError('disassembly coverage gap')
        cursor += instruction['size']
    if cursor != end - image.image_base:
        raise ValueError('disassembly incomplete')
    return instructions


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('reference', 'target', 'objdump', 'output'):
        parser.add_argument('--' + name, type=Path, required=True)
    parser.add_argument('--reference-sha256', required=True)
    parser.add_argument('--target-sha256', required=True)
    args = parser.parse_args()
    images = []
    for path, expected in ((args.reference, args.reference_sha256), (args.target, args.target_sha256)):
        data = path.read_bytes()
        if hashlib.sha256(data).hexdigest() != expected:
            raise ValueError('unreviewed module hash')
        images.append(PEImage(data))
    old, new = images
    anchor_rva = 0x8837328  # RIP-relative LEA at old site + 10, reviewed in full function.
    offset = old.rva_offset(anchor_rva)
    anchor = old.read(offset, 512).split(b'\0', 1)[0] + b'\0'
    anchors = []
    for section in new.sections:
        if section['executable']:
            continue
        block = new.read(section['raw_offset'], section['raw_size'])
        position = 0
        while (position := block.find(anchor, position)) >= 0:
            anchors.append(section['rva'] + position)
            position += 1
    references = []
    for section in new.sections:
        if not section['executable']:
            continue
        block = new.read(section['raw_offset'], section['raw_size'])
        for prefix in (b'\x48\x8d', b'\x4c\x8d'):
            position = 0
            while (position := block.find(prefix, position)) >= 0:
                if position + 7 <= len(block) and block[position+2] & 0xc7 == 5:
                    rva = section['rva'] + position
                    destination = rva + 7 + struct.unpack_from('<i', block, position+3)[0]
                    if destination in anchors:
                        references.append(rva)
                position += 1
    if len(anchors) != 1 or len(references) != 1:
        raise ValueError('anchor/reference no longer unique')
    old_function, new_function = old.function_at(0x179d6ef), new.function_at(references[0])
    old_code = disassemble(args.objdump, args.reference, old, old_function)
    new_code = disassemble(args.objdump, args.target, new, new_function)
    if references[0] not in [int(x['rva'], 16) for x in new_code]:
        raise ValueError('reference is not an instruction boundary')
    old_index = next(i for i, x in enumerate(old_code) if x['rva'] == '0x179d6ef')
    candidate = new_code[old_index]
    differences = [{'index': i, 'reference': a, 'target': b}
                   for i, (a, b) in enumerate(zip(old_code, new_code))
                   if a['normalized'] != b['normalized']]
    report = {'schema_version': 'windows-hook-receive-hypothesis.v1',
              'reference_sha256': None, 'target_sha256': None,
              'reference_site_rva': None, 'candidate_site_rva': None,
              'reference_function': None, 'target_function': None,
              'anchor': {'reference_rva': None, 'target_rva': None,
                         'length': len(anchor), 'sha256': None,
                         'target_xref_rva': None, 'unique': True},
              'instruction_counts': [len(old_code), len(new_code)],
              'same_instruction_sizes': [x['size'] for x in old_code] == [x['size'] for x in new_code],
              'same_relative_positions': [int(x['rva'],16)-int(old_function['begin_rva'],16) for x in old_code]
                == [int(x['rva'],16)-int(new_function['begin_rva'],16) for x in new_code],
              'normalized_difference_count': len(differences),
              'normalized_differences': None,
              'reference_site_context': None,
              'target_site_context': None,
              'status': 'static_candidate_only', 'usable_for_hook': False,
              'message_layout_verified': False, 'live_receive_verified': False,
              'limitations': ['External call and RIP targets normalized; their semantic equivalence is unproven.',
                             'Changed non-address immediates and field offsets prohibit inheriting old object layout.',
                             'This is a mid-function site, not a function entry. No target process accessed.']}
    with args.output.open('x', encoding='utf-8') as stream:
        json.dump(report, stream, indent=2)
        stream.write('\n')
    print(json.dumps({'candidate': 'redacted', 'differences': len(differences), 'usable_for_hook': False}))


if __name__ == '__main__':
    main()
