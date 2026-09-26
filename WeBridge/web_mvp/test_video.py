"""Video cache/download regression, with real files and a fake official HTTP server."""
from datetime import datetime
import hashlib
import io
from pathlib import Path
import tempfile
from types import SimpleNamespace
import unittest
import urllib.error
from unittest.mock import patch

from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.padding import PKCS7
import media_container


class VideoTests(unittest.TestCase):
    def setUp(self):
        self.directory=tempfile.TemporaryDirectory();self.addCleanup(self.directory.cleanup)
        self.base=Path(self.directory.name);self.root=self.base/'account'/'db_storage';self.root.mkdir(parents=True)
        self.stamp=1789991495;self.month=datetime.fromtimestamp(self.stamp).strftime('%Y-%m')
        self.video_dir=self.root.parent/'msg/video'/self.month;self.video_dir.mkdir(parents=True)
        self.stem='c'*32;self.cover=self.video_dir/(self.stem+'_thumb.jpg');self.cover.write_bytes(b'\xff\xd8\xffcover\xff\xd9')
        self.video=b'\x00\x00\x00\x18ftypisom'+b'video-regression-payload'*4
        self.md5=hashlib.md5(self.video).hexdigest();self.key=bytes.fromhex('0123456789abcdef0123456789abcdef')
        pad=PKCS7(128).padder();data=pad.update(self.video)+pad.finalize()
        cipher=Cipher(algorithms.AES(self.key),modes.ECB()).encryptor();self.encrypted=cipher.update(data)+cipher.finalize()
        self.hardlinks=[];self.requests=[]
        self.row={'kind':'video','raw':f'<msg><videomsg length="{len(self.video)}" md5="{self.md5}" aeskey="{self.key.hex()}" tpvideourl="https://wwfile.work.weixin.qq.com/test-video" tpauthkey="test-only-ticket" /></msg>',
            'localId':56,'serverId':'90001','timestamp':self.stamp,'media':{'filename':'视频'}}
        bridge=SimpleNamespace(copied_query=self.query,quote=lambda text:"'"+text+"'",fields=lambda data:{2:[b'entry']} if data==b'packed' else {1:[self.stem.encode()]})
        for target,value in [('CACHE_DIRECTORY',self.base/'media'),('VIDEO_CACHE_DIRECTORY',self.base/'videos')]:
            patcher=patch.object(media_container,target,value);patcher.start();self.addCleanup(patcher.stop)
        patcher=patch.dict('sys.modules',{'container_bridge':bridge});patcher.start();self.addCleanup(patcher.stop)
        patcher=patch('urllib.request.build_opener',return_value=SimpleNamespace(open=self.http));patcher.start();self.addCleanup(patcher.stop)

    def query(self,path,key,sql):
        if path.name=='message_resource.db':return [{'data':b'packed'.hex()}]
        if 'video_hardlink_info' in sql:return self.hardlinks
        return [{'id':1,'username':self.month}]

    def http(self,request,timeout):
        self.requests.append(request)
        start=int(request.headers.get('Range','bytes=0-').split('=')[1].split('-')[0]);end=min(start+31,len(self.encrypted)-1)
        stream=io.BytesIO(self.encrypted[start:end+1]);stream.status=206
        stream.headers={'Content-Range':f'bytes {start}-{end}/{len(self.encrypted)}','Content-Length':str(end-start+1)}
        return stream

    def resolve(self):
        return media_container.resolve_media(self.root,{'message_resource.db':'unused','hardlink.db':'unused'},'test@chatroom',self.row)

    def test_cover_only_video_downloads_all_encrypted_ranges_before_playback(self):
        result=self.resolve()
        self.assertEqual(result['mime'],'video/mp4')
        self.assertFalse(result['previewOnly'])
        self.assertGreater(len(self.requests),1)
        self.assertEqual((self.base/'media'/(result['digest']+'.blob')).read_bytes(),self.video)
        calls=len(self.requests);self.assertEqual(self.resolve()['mime'],'video/mp4');self.assertEqual(len(self.requests),calls)

    def test_hardlink_video_wins_over_earlier_resource_cover(self):
        (self.video_dir/'complete.mp4').write_bytes(self.video)
        self.hardlinks=[{'file_name':'complete.mp4','dir1':1,'dir2':0}]
        result=self.resolve()
        self.assertEqual(result['mime'],'video/mp4');self.assertFalse(result['previewOnly']);self.assertEqual(self.requests,[])

    def test_auth_failure_keeps_cover_with_a_clear_reason(self):
        with patch('urllib.request.build_opener') as build:
            build.return_value.open.side_effect=urllib.error.HTTPError('private-url',403,'denied',{},None)
            result=self.resolve()
        self.assertTrue(result['previewOnly']);self.assertIn('授权已失效',result['reason'])
        self.assertNotIn('test-only-ticket',str(result));self.assertNotIn('private-url',str(result))

    def test_official_host_allowlist_rejects_untrusted_media_locations(self):
        from video_download import fetch_wecom_video
        from rich_content import xml_root
        attributes=xml_root(self.row['raw']).find('videomsg').attrib
        for url in ('http://wwfile.work.weixin.qq.com/file','https://wwfile.work.weixin.qq.com.evil.example/file',
                    'https://wwfile.work.weixin.qq.com:444/file','https://user@wwfile.work.weixin.qq.com/file'):
            with self.assertRaises(ValueError):fetch_wecom_video({**attributes,'tpvideourl':url})
        self.assertEqual(self.requests,[])

    def test_truncated_or_corrupt_video_is_never_served_as_playable(self):
        def broken_response(request,timeout):
            stream=io.BytesIO(self.encrypted[:16]);stream.status=206
            stream.headers={'Content-Range':f'bytes 0-31/{len(self.encrypted)}'}
            return stream
        with patch('urllib.request.build_opener',return_value=SimpleNamespace(open=broken_response)):
            result=self.resolve()
        self.assertTrue(result['previewOnly']);self.assertIn('分段',result['reason'])
        self.encrypted=self.encrypted[:-1]+bytes([self.encrypted[-1]^1])
        result=self.resolve();self.assertTrue(result['previewOnly']);self.assertIn('校验失败',result['reason'])


if __name__=='__main__':unittest.main()
