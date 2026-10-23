"""Regression fixtures for original-media omissions; no account data."""
from pathlib import Path
import hashlib
import json
import tempfile
import unittest
from unittest.mock import patch

from wecom_media import WeComMedia
from offline_documents import AttachmentExtractor
from offline_media_search import LocalMediaSearch
from test_group_auto_content48 import picture


class Gaps49Tests(unittest.TestCase):
    def setUp(self):
        temp=tempfile.TemporaryDirectory(prefix='synthetic-gaps49-');self.addCleanup(temp.cleanup)
        self.root=Path(temp.name).resolve()

    def test_wecom_original_larger_than_decode_limit_is_streamed(self):
        cache=self.root/'Cache';cache.mkdir();out=self.root/'out';out.mkdir()
        data=b'synthetic original document';(cache/'opaque').write_bytes(data)
        node={'kind':'file','media':{'filename':'original.bin','md5':hashlib.md5(data).hexdigest()}}
        with patch('wecom_media.LIMIT',4):result=WeComMedia({'sourceRoot':str(self.root)}).attach(node,out)
        self.assertEqual(result['status'],'ready')
        self.assertEqual((out/result['path']).read_bytes(),data)
        self.assertFalse(result['previewOnly'])

    def test_wechat_plain_file_above_decode_limit_is_indexed_and_reused(self):
        source=self.root/'db_storage';source.mkdir();folder=self.root/'msg/file';folder.mkdir(parents=True)
        path=folder/'opaque';data=b'synthetic plaintext';path.write_bytes(data)
        search=LocalMediaSearch({'sourceRoot':str(source)})
        with patch('offline_media_search.MAX_FILE_BYTES',4):
            self.assertEqual(search.paths_for(hashlib.md5(data).hexdigest()),[path])
        search.begin_export()
        self.assertEqual(search.paths_for(hashlib.md5(data).hexdigest()),[path])
        self.assertEqual(search.report()['bytesScanned'],0)
        self.assertEqual(search.report()['hashCacheReused'],1)
        path.write_bytes(b'changed');search.begin_export()
        self.assertEqual(search.paths_for(hashlib.md5(data).hexdigest()),[])

    def test_wechat_large_original_export_has_asset_path_without_memory_body(self):
        from test_database_adapter import GROUP,STAMP
        from windows_media import resolve_local
        source=self.root/'db_storage';source.mkdir();cache=self.root/'msg/file/2023-11';cache.mkdir(parents=True)
        data=b'synthetic big attachment';(cache/'quote.txt').write_bytes(data)
        snapshot=self.root/'snapshot';snapshot.mkdir();out=self.root/'out';out.mkdir()
        row={'kind':'file','media':{'filename':'quote.txt'},'localId':1,'serverId':'10','timestamp':STAMP,
            '_raw':'<msg><appmsg><appattach><md5>'+hashlib.md5(data).hexdigest()+'</md5></appattach></appmsg></msg>'}
        with patch('windows_media.LIMIT',4):
            asset,body=resolve_local(snapshot,{'sourceRoot':str(source)},GROUP,row,destination=out)
        self.assertIsNone(body);self.assertEqual(asset['status'],'ready')
        self.assertEqual((out/asset['path']).read_bytes(),data)

    def test_preview_ocr_keeps_original_missing_and_labels_source(self):
        assets=self.root/'assets';assets.mkdir();path=assets/'preview.png';picture().save(path)
        data=path.read_bytes();row={'id':'synthetic-message','chatId':'synthetic-group','chatName':'合成群','kind':'image',
            'asset':{'status':'ready','path':'assets/preview.png','filename':'preview.png','previewOnly':True,
                     'previewVariant':'local_converted','size':len(data),'digest':hashlib.sha256(data).hexdigest()}}
        extractor=AttachmentExtractor({'ocrImages':True});extractor.attach(row,self.root,True)
        text=row['attachmentContent']
        self.assertIn('7455',text['text'])
        self.assertEqual(text['fileStatus'],'preview_only');self.assertTrue(row['asset']['previewOnly'])
        self.assertEqual(text['extractionStatus'],'partial');self.assertTrue(text['requiresReview'])
        self.assertEqual(text['sourceQuality'],'preview')
        self.assertIn('预览',text['text']);self.assertEqual(extractor.summary()['previewOCRReferences'],1)

    def test_recovery_queue_merges_digest_across_groups_but_not_same_filename(self):
        from offline_quality import ContentQuality
        def row(mid,chat,digest):
            return {'id':mid,'chatId':chat,'chatName':chat,'kind':'file','time':'2026-10-23T10:00:00+08:00',
                'media':{'filename':'same.pdf','md5':digest},'asset':{'status':'unavailable'}}
        with ContentQuality(self.root) as quality:
            for value in (row('1','synthetic-a','a'*32),row('2','synthetic-b','a'*32),row('3','synthetic-a','b'*32),row('4','synthetic-a','')):
                quality.add(value)
            summary=quality.finish()
        queue=summary['recoveryQueue']
        self.assertEqual((queue['uniqueItems'],queue['references'],queue['withoutDigest']),(3,4,1))
        entries=[json.loads(line) for line in (self.root/queue['jsonlFile']).read_text(encoding='utf8').splitlines()]
        self.assertEqual(entries[0]['references'],2)
        self.assertEqual(len(entries[0]['groups']),2)
        self.assertTrue((self.root/queue['csvFile']).is_file())

    def test_streamed_video_without_filename_extension_retains_mp4_type(self):
        from offline_media_copy import copy_original
        path=self.root/'opaque';data=b'\0\0\0\x18ftypmp42'+b'synthetic';path.write_bytes(data)
        result=copy_original(path,self.root,hashlib.md5(data).hexdigest(),'video','video')
        self.assertEqual(result['mime'],'video/mp4');self.assertTrue(result['path'].endswith('.mp4'))


if __name__=='__main__':unittest.main()
