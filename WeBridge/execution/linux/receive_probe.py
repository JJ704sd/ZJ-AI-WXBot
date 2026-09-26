#!/usr/bin/env python3
"""Bounded, group-scoped receive acceptance; no live SQLite connections/UI.

Queries temporary copies with SQLCipher's normal WAL handling. It does not
force-merge frames, disable checksums, or claim an atomic production backup.
Only the user's two numbered incoming test messages are emitted.
"""
import argparse
import json
from pathlib import Path
import tempfile
import time
import xml.etree.ElementTree as ET
from db_probe import context, query, TABLE
from wal_snapshot_probe import decode

SELF='wxid_c1wz4p7o4yg529'


def signature(path):
    if not path.exists(): return None
    stat=path.stat()
    return stat.st_size,stat.st_mtime_ns


def read_copy(source,key):
    wal=Path(str(source)+'-wal')
    before=signature(source),signature(wal)
    db_bytes=source.read_bytes()
    wal_bytes=wal.read_bytes() if wal.exists() else None
    if before!=(signature(source),signature(wal)):
        return None
    if wal_bytes is not None and wal_bytes!=wal.read_bytes():
        return None
    with tempfile.TemporaryDirectory(prefix='wechat-lab-receive-') as folder:
        copied=Path(folder)/source.name;copied.write_bytes(db_bytes)
        if wal_bytes is not None:Path(str(copied)+'-wal').write_bytes(wal_bytes)
        exists=query(copied,key,f"SELECT name FROM sqlite_master WHERE name='{TABLE}';")
        if not exists:return []
        rows=query(copied,key,f'''SELECT m.local_id,m.server_id,m.local_type,m.create_time,
            hex(m.message_content) AS content_hex,hex(m.source) AS source_hex,
            n.user_name AS sender FROM "{TABLE}" m
            LEFT JOIN Name2Id n ON m.real_sender_id=n.rowid
            ORDER BY m.local_id DESC LIMIT 30;''')
    result=[]
    for row in rows:
        content=decode(row.pop('content_hex'));source_xml=decode(row.pop('source_hex'))
        if '[接入测试]' not in content or not any(x in content for x in ('RECV-001','RECV-002')):continue
        at_list=[]
        if source_xml:
            at=ET.fromstring(source_xml).find('atuserlist')
            at_list=[x.strip() for x in (at.text or '').split(',')] if at is not None else []
        result.append({**row,'content':content,'mentionSelf':SELF in at_list,
            'mentionEveryone':'notify@all' in at_list,'isSelf':row['sender']==SELF,
            'observedAtUnixMs':round(time.time()*1000),'source':source_xml})
    return result


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--seconds',type=int,default=55)
    args=parser.parse_args()
    if not 1<=args.seconds<=55:parser.error('Duration must be 1..55 seconds')
    root,keys=context()
    deadline=time.monotonic()+args.seconds
    fingerprints={};found={};errors=0
    while time.monotonic()<deadline:
        for source in sorted((root/'message').glob('message_*.db')):
            if not source.stem[len('message_'):].isdigit() or source.name not in keys:continue
            current=(signature(source),signature(Path(str(source)+'-wal')))
            if fingerprints.get(source)==current:continue
            try:rows=read_copy(source,keys[source.name])
            except (RuntimeError,ValueError,ET.ParseError):
                errors+=1;continue
            if rows is None:continue
            fingerprints[source]=current
            for row in rows:
                identity=str(row['server_id']) if row['server_id'] else source.name+':'+str(row['local_id'])
                if identity not in found:
                    found[identity]=row
                    print(json.dumps({'event':'incomingTest','message':row},ensure_ascii=False),flush=True)
        ordinary=any('RECV-001' in r['content'] and not r['isSelf'] for r in found.values())
        mentioned=any('RECV-002' in r['content'] and not r['isSelf'] and r['mentionSelf'] for r in found.values())
        if ordinary and mentioned:break
        time.sleep(.75)
    result={'ordinaryReceiveVerified':ordinary,'selfMentionVerified':mentioned,
        'readMethod':'SQLCipher on temporary DB+WAL copies','forcedFrameMerge':False,
        'uiOperations':0,'snapshotErrors':errors,'messages':list(found.values())}
    target=Path('/tmp/wechat-lab-receive-result.json')
    target.write_text(json.dumps(result,ensure_ascii=False,indent=2));target.chmod(0o600)
    print(json.dumps({k:v for k,v in result.items() if k!='messages'},ensure_ascii=False),flush=True)


if __name__=='__main__':main()
