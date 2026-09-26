#!/usr/bin/env python3
"""Read-only delivery check for one received video; never prints credentials."""
import argparse
import json
import urllib.parse
import urllib.request


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--group',default='48437025209@chatroom')
    parser.add_argument('--message',default='5450782503465515206')
    args=parser.parse_args()
    base='http://127.0.0.1:8787'
    opener=urllib.request.build_opener(urllib.request.ProxyHandler({}))
    with opener.open(base+'/api/state',timeout=15) as response:state=json.load(response)
    payload={'account':state['account'],'groupId':args.group,'messageId':args.message}
    request=urllib.request.Request(base+'/api/media',data=json.dumps(payload).encode(),headers={
        'Content-Type':'application/json','Origin':base,'X-CSRF-Token':state['csrfToken']})
    with opener.open(request,timeout=100) as response:media=json.load(response)
    print(json.dumps({k:media[k] for k in ('status','kind','mime','size','previewOnly','reason') if k in media},ensure_ascii=False))
    if media.get('status')!='ready' or not media.get('mime','').startswith('video/') or media.get('previewOnly'):
        raise SystemExit('FAIL: this video resolves to a cover or unavailable attachment, not playable video bytes')
    url=base+'/api/asset?'+urllib.parse.urlencode({'id':media['assetId'],'account':state['account']})
    with opener.open(urllib.request.Request(url,headers={'Range':'bytes=0-31'}),timeout=15) as response:
        header=response.read();content_type=response.headers['Content-Type']
        if response.status!=206 or not content_type.startswith('video/') or header[4:8]!=b'ftyp':
            raise SystemExit('FAIL: video delivery or seek response is invalid')
    print('PASS: video media plus playable MP4 bytes and HTTP Range')


if __name__=='__main__':main()
