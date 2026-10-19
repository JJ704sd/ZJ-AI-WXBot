"""WeCom quote envelopes use invented payloads matching the observed field layout."""
from contextlib import closing
import json
from pathlib import Path
import sqlite3
import tempfile
import unittest

from offline_desktop import DesktopSession
from test_wecom_archive import fixture, pb


def quote_extra(kind, body=b'', *, token='', stamp=1700000001):
    field={0:101,2:101,14:103}.get(kind)
    entry=pb(1,11)+pb(2,stamp)+pb(5,kind)+pb(11,'合成发送人')
    if field and body:entry+=pb(field,body)
    if token:entry+=pb(17,pb(3045,pb(1,token)))
    return pb(1002,pb(1,entry)+pb(4,1))


class WeComQuoteTests(unittest.TestCase):
    def test_reply_keeps_its_text_and_exact_same_group_quote_source(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-wecom-quote-') as folder:
            base=Path(folder);source=base/'source';fixture(source)
            token='a'*32
            origin_extra=pb(3045,pb(1,token))
            with closing(sqlite3.connect(source/'message.db')) as db,db:
                body=db.execute('SELECT content FROM message_table WHERE message_id=1').fetchone()[0]
                db.execute('UPDATE message_table SET extra_content=? WHERE message_id=1',(origin_extra,))
                entry=(pb(1,11)+pb(2,1700000001)+pb(5,2)+pb(11,'合成发送人')+
                       pb(17,origin_extra)+pb(101,body))
                reply=pb(1,pb(1,0)+pb(2,pb(1,'采用以上合成方案')))
                db.execute('INSERT INTO message_table VALUES(?,?,?,?,?,?,?,?,?,?,?)',
                           (3,13,3,11,'R:synthetic',0,1700000003,0,reply,pb(1002,pb(1,entry)+pb(4,1)),b''))
            session=DesktopSession(base/'profile',client='wecom')
            session.open_source({'sourceRoot':str(source)})
            parsed=session.prepare_review('R:synthetic',copy_media=False)
            rows=json.loads((Path(parsed['view']['viewRoot'])/'messages.json').read_text(encoding='utf8'))
            reply=rows[-1]
            self.assertEqual(reply['kind'],'quote')
            self.assertEqual(reply['text'],'采用以上合成方案')
            self.assertEqual(reply['quote']['message']['text'],rows[0]['text'])
            self.assertEqual(reply['quote']['sourceMessageId'],rows[0]['id'])
            self.assertEqual(reply['quote']['sourceLinkStatus'],'matched_local_source')
            self.assertIn('引用来源', (Path(parsed['view']['viewRoot'])/'业务阅读.txt').read_text(encoding='utf-8-sig'))
            self.assertFalse((session.directory/'exports').exists())

    def test_quoted_images_and_unsupported_sources_keep_separate_gap_statuses(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-quote-gaps-') as folder:
            base=Path(folder);source=base/'source';fixture(source)
            image=pb(10,'a'*32)+pb(4,123)
            text=pb(1,pb(1,0)+pb(2,pb(1,'合成回复正文')))
            with closing(sqlite3.connect(source/'message.db')) as db,db:
                for mid,kind,body,extra in ((3,14,image,b''),(4,0,text,quote_extra(14,image,stamp=1700000003)),
                                            (5,2,text,quote_extra(999))):
                    db.execute('INSERT INTO message_table VALUES(?,?,?,?,?,?,?,?,?,?,?)',
                        (mid,mid+10,mid,11,'R:synthetic',kind,1700000000+mid,0,body,extra,b''))
            session=DesktopSession(base/'profile',client='wecom');session.open_source({'sourceRoot':str(source)})
            result=session.prepare_review('R:synthetic',copy_media=True)
            rows=json.loads((Path(result['view']['viewRoot'])/'messages.json').read_text(encoding='utf8'))
            self.assertEqual(result['report']['mediaSummary']['images']['total'],2)
            self.assertEqual(session.views['R:synthetic'].page(kind='missing_images')['total'],2)
            self.assertEqual(session.views['R:synthetic'].page(kind='quote')['total'],2)
            self.assertEqual(rows[-1]['text'],'合成回复正文')
            self.assertEqual(rows[-1]['parseStatus'],'partial_quote')
            self.assertEqual(rows[-1]['quote']['message']['kind'],'unknown')

    def test_quote_source_never_links_to_another_group_with_the_same_token(self):
        with tempfile.TemporaryDirectory(prefix='synthetic-quote-scope-') as folder:
            base=Path(folder);source=base/'source';fixture(source)
            token='b'*32
            with closing(sqlite3.connect(source/'message.db')) as db,db:
                body=db.execute('SELECT content FROM message_table WHERE message_id=1').fetchone()[0]
                db.execute('INSERT INTO message_table VALUES(?,?,?,?,?,?,?,?,?,?,?)',
                    (3,13,3,11,'R:another-group',2,1700000001,0,body,pb(3045,pb(1,token)),b''))
                db.execute('INSERT INTO message_table VALUES(?,?,?,?,?,?,?,?,?,?,?)',
                    (4,14,4,11,'R:synthetic',2,1700000004,0,body,quote_extra(2,body,token=token),b''))
            session=DesktopSession(base/'profile',client='wecom');session.open_source({'sourceRoot':str(source)})
            result=session.prepare_review('R:synthetic',copy_media=False)
            rows=json.loads((Path(result['view']['viewRoot'])/'messages.json').read_text(encoding='utf8'))
            self.assertEqual(rows[-1]['quote']['resolutionStatus'],'embedded')
            self.assertEqual(rows[-1]['quote']['sourceLinkStatus'],'source_not_found')
            self.assertNotIn('sourceMessageId',rows[-1]['quote'])


if __name__=='__main__':unittest.main()
