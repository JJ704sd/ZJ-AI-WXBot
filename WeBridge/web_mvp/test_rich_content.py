import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from rich_content import parse_content, xml_root
from media_host import byte_range, MediaCache
from backend import Engine, Store
from test_backend import FakeAdapter
from server import LoginFlow


class RichTests(unittest.TestCase):
    def test_revoke_keeps_client_notice(self):
        message=parse_content('<?xml version="1.0"?><sysmsg type="revokemsg"><revokemsg><content>测试人 撤回了一条消息</content></revokemsg></sysmsg>',10000)
        self.assertEqual(message['kind'],'revoke');self.assertIn('测试人',message['text'])

    def test_forwarded_records_expand_without_leaking_attachment_credentials(self):
        xml='sender@openim:\n<msg><appmsg><title>群聊</title><type>19</type><recorditem><![CDATA[<recordinfo><title>群聊</title><datalist count="2"><dataitem datatype="1"><sourcename>甲</sourcename><sourcetime>12:01</sourcetime><datadesc>hello &lt;script&gt;</datadesc></dataitem><dataitem datatype="8"><datatitle>test.pdf</datatitle><datasize>1234</datasize><cdnattachurl>secret-url</cdnattachurl><aeskey>secret-key</aeskey></dataitem></datalist></recordinfo>]]></recorditem></appmsg></msg>'
        result=parse_content(xml,(19<<32)|49)
        self.assertEqual(result['record']['count'],2)
        self.assertEqual(result['record']['items'][0]['text'],'hello <script>')
        self.assertEqual(result['record']['items'][1]['media']['part'],'1')
        self.assertNotIn('secret-',json.dumps(result))

    def test_file_name_size_and_quoted_message(self):
        result=parse_content('<msg><appmsg><type>6</type><title>test.pdf</title><appattach><totallen>1234</totallen><aeskey>secret</aeskey></appattach></appmsg></msg>',(6<<32)|49)
        self.assertEqual(result['media']['size'],1234);self.assertNotIn('secret',str(result))
        result=parse_content('<msg><appmsg><type>57</type><title>reply</title><refermsg><type>1</type><displayname>A</displayname><content>original</content></refermsg></appmsg></msg>',(57<<32)|49)
        self.assertEqual(result['quote'],{'sender':'A','text':'original'})

    def test_entities_and_bad_xml_fail_closed(self):
        self.assertIsNone(xml_root('<!DOCTYPE x [<!ENTITY e "many">]><x>&e;</x>'))
        self.assertEqual(parse_content('未识别系统通知',10000)['text'],'未识别系统通知')

    def test_video_ranges_include_suffix_and_reject_multiple_ranges(self):
        self.assertEqual(byte_range('bytes=5-15',10),(5,9))
        self.assertEqual(byte_range('bytes=-3',10),(7,9))
        self.assertEqual(byte_range('bytes=3-',10),(3,9))
        for value in ['bytes=10-','bytes=-0','bytes=1-2,4-5','bytes=-','bytes=8-3']:
            with self.assertRaises(ValueError):byte_range(value,10)

    def test_attachment_access_requires_current_account_and_reading_scope(self):
        with tempfile.TemporaryDirectory() as directory:
            engine=Engine(Store(Path(directory)/'state.db'),FakeAdapter());engine.refresh_connection()
            engine.store.ingest('account-a','group-a',[{'id':'1','kind':'image'}]);cache=MediaCache(engine,Path(directory)/'media')
            with self.assertRaises(ValueError):cache.message('account-a','group-a','1')
            engine.set_watched('account-a',['group-a']);self.assertEqual(cache.message('account-a','group-a','1')['id'],'1')
            with self.assertRaises(ValueError):cache.message('account-b','group-a','1')

    def test_login_requests_qr_and_relay_only_public_states(self):
        with tempfile.TemporaryDirectory() as directory:
            adapter=FakeAdapter();engine=Engine(Store(Path(directory)/'state.db'),adapter);flow=LoginFlow(engine);seen=[]
            def events():
                yield json.dumps({'type':'qr','qrDataUrl':'data:image/png;base64,dGVzdA==','qrData':'private-login-url'})
                seen.append(flow.snapshot())
                yield json.dumps({'type':'phone_confirm','message':'confirm'})
                seen.append(flow.snapshot())
                yield json.dumps({'type':'login_success','userId':'account-a'})
            with patch('pathlib.Path.read_text',return_value='fake-token'),patch('websockets.sync.client.connect') as connect:
                connect.return_value.__enter__.return_value=events();flow.run()
                self.assertIn('newAccount=true',connect.call_args.args[0])
            self.assertEqual([s['type'] for s in seen],['qr','phone_confirm'])
            self.assertNotIn('private-login-url',str(seen));self.assertEqual(flow.snapshot()['type'],'login_success')


if __name__=='__main__':unittest.main()
