"""Offline audit of an existing address-only capture; never opens a process."""
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from wechat_agent_poc.hook_target_analysis import PEImage


def imports(image):
    """Resolve normal PE imports by IAT RVA; delay imports remain unresolved."""
    result = {}
    rva, size = image.directories[1]
    for offset in range(0, size - 19, 20):
        original, _, _, name, first = image.unpack('<IIIII', image.rva_offset(rva + offset, 20))
        if not any((original, name, first)):
            break
        def cstring(at):
            off = image.rva_offset(at)
            return image.read(off, min(512, len(image.data) - off)).split(b'\0', 1)[0].decode('ascii', 'replace')
        module = cstring(name)
        for index in range(65536):
            value = image.unpack('<Q', image.rva_offset((original or first) + 8 * index, 8))[0]
            if not value:
                break
            symbol = f'ordinal:{value & 0xffff}' if value >> 63 else cstring(value + 2)
            result[first + 8 * index] = f'{module}!{symbol}'
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('dll', 'metadata', 'capture', 'objdump', 'output'):
        parser.add_argument('--' + name, required=True, type=Path)
    parser.add_argument('--expected-sha256', required=True)
    args = parser.parse_args()
    data = args.dll.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    if digest != args.expected_sha256.lower():
        raise ValueError('DLL hash mismatch')
    image = PEImage(data)
    symbols = imports(image)
    module = json.loads(args.metadata.read_text())['modules'][0]
    capture = json.loads(args.capture.read_text())
    occurrences = {}
    for snapshot in capture['snapshots']:
        for thread in snapshot['threads']:
            for depth, address in enumerate(thread['frame_addresses']):
                rva = int(address, 16) - module['base_address']
                if 0 <= rva < module['size']:
                    occurrences.setdefault(rva, []).append({'snapshot': snapshot['index'], 'depth': depth})
    rows = []
    for rva, observations in sorted(occurrences.items()):
        row = image.audit_legacy_rva('sampled_frame', rva)
        row['rva'] = row.pop('legacy_rva')
        row['observations'] = observations
        row['present_in_baseline'] = any(x['snapshot'] == 0 for x in observations)
        row['instruction_boundary'] = None
        row['previous_instruction'] = None
        row['import_calls_in_range'] = []
        function = row['runtime_function']
        if row['executable'] and function:
            start, end = (image.image_base + int(function[k], 16) for k in ('begin_rva', 'end_rva'))
            output = subprocess.run([str(args.objdump), '-d', '-M', 'intel', '--insn-width=16',
                                     f'--start-address={start}', f'--stop-address={end}', str(args.dll)],
                                    capture_output=True, text=True, check=True, timeout=30).stdout
            instructions = []
            for line in output.splitlines():
                match = re.match(r'^\s*([0-9a-f]+):\s*((?:[0-9a-f]{2}\s+)+)\s*(.*)$', line)
                if match:
                    address, raw, asm = match.groups()
                    instructions.append((int(address, 16), len(raw.split()), asm))
                    target = re.search(r'#\s*0x([0-9a-f]+)', asm)
                    if asm.startswith('call') and target:
                        symbol = symbols.get(int(target[1], 16) - image.image_base)
                        if symbol:
                            row['import_calls_in_range'].append(symbol)
            row['instruction_boundary'] = any(a == image.image_base + rva for a, _, _ in instructions)
            for address, length, asm in instructions:
                if address + length == image.image_base + rva:
                    row['previous_instruction'] = asm
        rows.append(row)
    report = {'schema_version': 'windows-hook-stack-audit.v1', 'module_sha256': digest,
              'capture_sha256': hashlib.sha256(args.capture.read_bytes()).hexdigest(),
              'mode': 'offline_existing_capture', 'process_access': False,
              'receive_entry_verified': False, 'candidates': rows,
              'limitations': ['Return addresses are not hook entry points.',
                              'Different thread subsets prevent before/after causality claims.',
                              'PE boundaries and import names cannot prove receive semantics.']}
    with args.output.open('x', encoding='utf-8') as stream:
        json.dump(report, stream, indent=2)
        stream.write('\n')
    print(json.dumps({'candidate_count': len(rows), 'receive_entry_verified': False}))


if __name__ == '__main__':
    main()
