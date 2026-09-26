#!/usr/bin/env python3
"""One previously authorized native send, hard-limited to the test group/member."""
import hashlib
import json
import os
from pathlib import Path
import secrets
import subprocess
import time
import typing
import typing_extensions
if not hasattr(typing,'NotRequired'): typing.NotRequired=typing_extensions.NotRequired
import frida
from native_object_roundtrip import integer, blob

EXPECTED='e40116597803a5e0d9fc4a2b727df4b8f7a3dd6de1c336140ea373be2b6626e9'
GROUP='48437025209@chatroom'
MEMBER='25984984017034815@openim'
TEXT='[接入测试] NATIVE-005 无界面原生接口发送验证。  @陈佳豪'
ATTEMPT=Path('/tmp/wechat-lab-native-005-attempt.json')
RESULT=Path('/tmp/wechat-lab-native-005-result.json')


def fields(data):
    data=bytes(data);pos=0;out={}
    def varint():
        nonlocal pos
        value=0
        for shift in range(0,70,7):
            if pos>=len(data): raise ValueError('Truncated varint')
            b=data[pos];pos+=1;value|=(b&127)<<shift
            if b<128:return value
        raise ValueError('Invalid varint')
    while pos<len(data):
        tag=varint();number=tag>>3;wire=tag&7
        if wire==0:value=varint()
        elif wire==2:
            size=varint()
            if size>len(data)-pos:raise ValueError('Truncated field')
            value=data[pos:pos+size];pos+=size
        else:raise ValueError('Unexpected response wire type')
        out.setdefault(number,[]).append(value)
    return out


def signed(value):
    value &= 0xffffffff
    return value-(1<<32) if value&(1<<31) else value


def decode_ack(raw, client_id):
    top=fields(raw)
    base=fields(top.get(1,[b''])[0])
    result={'baseRet':signed(base[1][0]) if 1 in base else None,'count':top.get(2,[0])[0]}
    responses=[]
    for child in top.get(3,[]):
        message=fields(child)
        to=fields(message.get(2,[b''])[0]).get(1,[b''])[0].decode('utf-8')
        responses.append({'ret':signed(message[1][0]) if 1 in message else None,'to':to,
            'clientMsgId':message.get(4,[None])[0],'newMsgId':message.get(8,[0])[0]})
    result['messages']=responses
    result['serverAccepted']=result['baseRet']==0 and result['count']==1 and len(responses)==1 and \
        responses[0]['ret']==0 and responses[0]['to']==GROUP and \
        responses[0]['clientMsgId']==client_id and responses[0]['newMsgId']>0
    return result


def main():
    if ATTEMPT.exists():raise SystemExit('Native-005 already attempted; no automatic retry')
    binary=Path('/opt/wechat/wechat')
    if hashlib.sha256(binary.read_bytes()).hexdigest()!=EXPECTED:raise SystemExit('Binary mismatch')
    pids=subprocess.check_output(['pgrep','-x','wechat'],text=True).split()
    if len(pids)!=1 or Path('/proc/'+pids[0]+'/exe').resolve()!=binary:raise SystemExit('Test client mismatch')
    # Reuse the existing local lab's session binding only to ensure login.
    from db_probe import context
    context()
    client_id=secrets.randbelow(0x7ffffffe)+1
    source=f'<msgsource><atuserlist>{MEMBER}</atuserlist><alnode><fr>1</fr></alnode></msgsource>'
    child=blob(1,blob(1,GROUP))+blob(2,TEXT)+integer(3,1)+integer(4,int(time.time()))+integer(5,client_id)+blob(6,source)
    request=integer(1,1)+blob(2,child)
    session=frida.attach(int(pids[0]))
    result={'marker':'NATIVE-005','clientMsgId':client_id,'pid':int(pids[0]),'uiOperations':0}
    try:
        script=session.create_script(Path('/tmp/native_send_once.js').read_text());script.load()
        fd=os.open(str(ATTEMPT),os.O_WRONLY|os.O_CREAT|os.O_EXCL,0o600)
        with os.fdopen(fd,'w') as output:json.dump(result,output)
        start=time.monotonic()
        result['submission']=script.exports_sync.sendonce(list(request))
        print(json.dumps({'submission':result['submission']},ensure_ascii=False),flush=True)
        deadline=start+55
        while time.monotonic()<deadline:
            status=script.exports_sync.status()
            if status.get('invoked',0)>0 and status.get('liveCallbacks')==0:break
            time.sleep(.2)
        result['elapsedMs']=round((time.monotonic()-start)*1000)
        raw=status.pop('responseBytes',[])
        result['completion']=status
        result['ack']=decode_ack(raw,client_id) if raw else {'serverAccepted':False,'reason':'No response payload yet'}
        # Native callbacks/code/state remain loaded through RTLD_NODELETE even
        # if the server has not answered before this bounded observation ends.
        script.unload()
    finally:
        session.detach()
    fd=os.open(str(RESULT),os.O_WRONLY|os.O_CREAT|os.O_TRUNC,0o600)
    with os.fdopen(fd,'w') as output:json.dump(result,output,ensure_ascii=False,indent=2)
    print(json.dumps(result,ensure_ascii=False,indent=2),flush=True)


if __name__=='__main__':main()
