"""Find syntactic paths in saved disassembly; not a live-path feasibility proof."""
import argparse
from collections import deque
import hashlib
import json
from pathlib import Path
import re


def parse(text):
    rows = []
    for line in text.splitlines():
        match = re.match(r'^\s*([0-9a-f]+):\s*((?:[0-9a-f]{2}\s+)+)\s*(.*)$', line)
        if match:
            rows.append((int(match[1],16), len(match[2].split()), match[3].split('#')[0].strip()))
    if not rows:
        raise ValueError('no instructions')
    if any(a+size != b for (a,size,_),(b,_,_) in zip(rows,rows[1:])):
        raise ValueError('non-contiguous disassembly')
    return rows


def graph(rows):
    addresses = {x[0] for x in rows}
    edges, unresolved = {}, []
    for address, size, assembly in rows:
        mnemonic = assembly.split()[0]
        next_address = address + size
        successors = []
        if mnemonic.startswith('ret') or mnemonic in ('int3','ud2','hlt'):
            pass
        elif mnemonic.startswith('j') or mnemonic.startswith('loop'):
            target = re.fullmatch(r'\w+\s+0x([0-9a-f]+)',assembly)
            if target and int(target[1],16) in addresses:
                successors.append(int(target[1],16))
            else:
                unresolved.append(address)
            if mnemonic != 'jmp' and next_address in addresses:
                successors.append(next_address)
        elif next_address in addresses:
            successors.append(next_address)  # Calls modeled as returning normally.
        edges[address] = successors
    return edges, unresolved


def path(edges, start, goal, forbidden=()):
    blocked = set(forbidden)
    if start in blocked or goal in blocked:
        return None
    pending, previous = deque([start]), {start:None}
    while pending:
        node = pending.popleft()
        if node == goal:
            result=[]
            while node is not None:
                result.append(node);node=previous[node]
            return result[::-1]
        for other in edges.get(node,[]):
            if other not in blocked and other not in previous:
                previous[other]=node;pending.append(other)
    return None


def audit(rows, site, join, call):
    edges, unresolved = graph(rows)
    if any(x not in edges for x in (site,join,call)):
        raise ValueError('candidate is not an instruction boundary')
    entry=rows[0][0]
    bypass=path(edges,entry,join,[site])
    onward=path(edges,join,call)
    exits=[a for a,_,asm in rows if asm.split()[0].startswith('ret')]
    skip_join=next((p for e in exits if (p:=path(edges,entry,e,[join]))),None)
    # Export ordinal indices, not reusable process addresses.
    indices={a:i for i,(a,_,_) in enumerate(rows)}
    return {'entry_to_join_avoiding_previous_site': bypass is not None,
            'join_to_call': onward is not None,
            'entry_to_return_avoiding_join': skip_join is not None,
            'bypass_instruction_indices':[indices[a] for a in bypass] if bypass else None,
            'join_to_call_instruction_indices':[indices[a] for a in onward] if onward else None,
            'skip_join_instruction_indices':[indices[a] for a in skip_join] if skip_join else None,
            'unresolved_branch_count':len(unresolved),'instruction_count':len(rows),
            'runtime_path_verified':False,
            'limitations':['Syntactic reachability only; branch conditions may be infeasible together.',
                           'Calls assumed to return; exceptions, indirect targets and external jumps not modeled.',
                           'Absence of a discovered bypass would not prove a mandatory runtime path.']}


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--disassembly',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    for name in ('site','join','call'):
        parser.add_argument('--'+name,type=lambda x:int(x,0),required=True)
    args=parser.parse_args()
    report=audit(parse(args.disassembly.read_text()),args.site,args.join,args.call)
    report['schema_version']='windows-hook-control-flow.v1'
    report['disassembly_sha256']=hashlib.sha256(args.disassembly.read_bytes()).hexdigest()
    with args.output.open('x',encoding='utf-8') as stream:
        json.dump(report,stream,indent=2);stream.write('\n')
    print(json.dumps({k:v for k,v in report.items() if not k.endswith('_indices')}))


if __name__=='__main__':
    main()
