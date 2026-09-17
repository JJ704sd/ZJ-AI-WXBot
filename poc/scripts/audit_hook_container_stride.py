"""Audit saved disassembly arithmetic offline; never interprets live messages."""
import argparse
import hashlib
import json
from pathlib import Path
import re


def exact_multiple_stride(multiplier, shift):
    if multiplier <= 0 or multiplier >= 1 << 64 or multiplier % 2 == 0:
        raise ValueError('expected odd 64-bit multiplier')
    if not 0 <= shift < 64:
        raise ValueError('invalid shift')
    return pow(multiplier, -1, 1 << 64) * (1 << shift)


def instructions(path):
    rows = []
    for line in path.read_text().splitlines():
        match = re.match(r'^\s*([0-9a-f]+):\s*((?:[0-9a-f]{2}\s+)+)\s*(.*)$', line)
        if match:
            rows.append(match[3].split('#')[0].strip())
    return rows


def inspect(path):
    rows = instructions(path)
    arithmetic = []
    for i in range(len(rows)-2):
        shift = re.fullmatch(r'sar\s+(r\w+),0x([0-9a-f]+)', rows[i])
        multiplier = re.fullmatch(r'movabs\s+(r\w+),0x([0-9a-f]+)', rows[i+1])
        product = re.fullmatch(r'imul\s+(r\w+),(r\w+)', rows[i+2])
        if not (shift and multiplier and product):
            continue
        if set(product.groups()) != {shift[1], multiplier[1]}:
            continue
        stride = exact_multiple_stride(int(multiplier[2], 16), int(shift[2], 16))
        # Avoid claiming an arbitrary modular inverse as a plausible allocation size.
        if stride > 65536:
            continue
        counts = [0, 1, 2, 3, 17, 128, 1024, 65535, 1000000]
        modulus = 1 << 64
        valid = all((((n*stride) >> int(shift[2],16)) * int(multiplier[2],16)) % modulus == n
                    for n in counts)
        arithmetic.append({'stride_bytes': stride, 'positive_exact_multiple_examples_pass': valid,
                           'example_counts': counts})
    return {'disassembly_sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
            'arithmetic': arithmetic,
            'direct_add_immediates': [int(m[1],16) for x in rows
                                     if (m := re.fullmatch(r'add\s+r\w+,0x([0-9a-f]+)', x))]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('old-main', 'new-main', 'old-callee', 'new-callee', 'output'):
        parser.add_argument('--'+name, required=True, type=Path)
    args = parser.parse_args()
    evidence = {name: inspect(getattr(args, name)) for name in ('old_main','new_main','old_callee','new_callee')}
    strides = {}
    for version in ('old', 'new'):
        main, callee = evidence[version+'_main'], evidence[version+'_callee']
        values = {x['stride_bytes'] for x in main['arithmetic']+callee['arithmetic']}
        if len(values) != 1 or len(main['arithmetic']) != 2 or len(callee['arithmetic']) != 1:
            raise ValueError('unexpected arithmetic evidence')
        stride = values.pop()
        if stride not in callee['direct_add_immediates']:
            raise ValueError('no matching direct pointer increment')
        strides[version] = stride
    result = {'schema_version': 'windows-hook-container-stride.v1', 'mode': 'offline_disassembly',
              'element_stride_hypothesis': strides, 'delta_bytes': strides['new']-strides['old'],
              'evidence': evidence, 'message_fields_verified': False, 'live_receive_verified': False,
              'limitations': ['Inference applies to this container path, not all message objects.',
                             'Arithmetic assumes nonnegative exact multiples without signed overflow.',
                             'A changed stride does not identify inserted fields or justify shifting every offset.']}
    with args.output.open('x', encoding='utf-8') as stream:
        json.dump(result, stream, indent=2)
        stream.write('\n')
    print(json.dumps({'stride_hypothesis':strides,'message_fields_verified':False}))


if __name__ == '__main__':
    main()
