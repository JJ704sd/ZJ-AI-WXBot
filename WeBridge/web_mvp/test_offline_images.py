"""Picture browsing must include forwards/quotes and preserve source navigation."""
import hashlib
from html.parser import HTMLParser
from io import BytesIO
import json
from pathlib import Path
import tempfile
import unittest

from offline_chat import _html_start, _message_html
from offline_image_html import gallery_body, image_card
from offline_images import image_references, message_anchor
from offline_view import ConversationView


class Markup(HTMLParser):
    def __init__(self, content):
        super().__init__()
        self.links, self.ids, self.tags = [], [], []
        self.feed(content)

    def handle_starttag(self, tag, attributes):
        attributes = dict(attributes)
        self.tags.append(tag)
        if 'id' in attributes:
            self.ids.append(attributes['id'])
        if tag == 'a':
            self.links.append(attributes.get('href', ''))


def fixture():
    return {'id': 'original:<&>', 'kind': 'record', 'senderName': '外层发送人', 'time': '2026-10-16 10:00:00',
            'text': '', 'provenance': {'file': 'message_0.db', 'table': 'Msg_fixture', 'localId': 7},
            'record': {'status': 'ok', 'items': [
                {'kind': 'record', 'record': {'status': 'ok', 'items': [
                    {'kind': 'image', 'senderName': '原发送人', 'time': '2026-10-15 09:00:00', 'part': '1.1',
                     'asset': {'status': 'pending', 'reason': '本地未缓存'}}]}},
                {'kind': 'image', 'part': '2', 'asset': {'status': 'ready', 'previewOnly': True,
                    'path': 'assets/thumb.png'}}]},
            'quote': {'senderName': '被引用人', 'message': {'kind': 'image', 'senderName': '被引用人',
                       'asset': {'status': 'ready', 'path': 'assets/original.png'}}}}


class ImageReferenceTests(unittest.TestCase):
    def test_deep_forward_and_quote_keep_both_source_levels(self):
        images = list(image_references(fixture()))
        self.assertEqual(len(images), 3)
        self.assertEqual(images[0]['senderName'], '原发送人')
        self.assertEqual(images[0]['time'], '2026-10-15 09:00:00')
        self.assertEqual(images[0]['part'], '1.1')
        self.assertEqual(len(images[0]['trail']), 2)
        self.assertEqual(images[-1]['trail'], ['引用来源'])
        self.assertTrue(all(image['rootMessageId'] == fixture()['id'] for image in images))
        self.assertEqual(images[0]['provenance']['localId'], 7)

    def test_all_images_paginate_independently_of_visible_messages(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'manifest.json').write_text('{}', encoding='utf-8')
            rows = [{'id': str(i), 'kind': 'text'} for i in range(150)]
            rows.insert(30, fixture())
            rows.extend({'id': f'image{i}', 'kind': 'image', 'asset': {'status': 'pending'}} for i in range(30))
            (root / 'messages.jsonl').write_text(''.join(json.dumps(row) + '\n' for row in rows), encoding='utf-8')
            view = ConversationView(root)
            self.assertNotIn(fixture()['id'], [row['id'] for row in view.page()['messages']])
            first, second = view.image_page(), view.image_page(24)
            self.assertEqual((len(first['images']), len(second['images'])), (24, 9))
            self.assertEqual(first['counts'], {'missing': 31, 'preview': 1, 'original': 1})
            source = view.page_for_message(first['images'][0]['rootMessageId'])
            self.assertEqual(source['messages'][0]['id'], fixture()['id'])
            self.assertEqual(first['images'][0]['part'], '1.1')

    def test_html_gallery_has_complete_source_links_and_safe_zoom_targets(self):
        row = fixture()
        entries = list(image_references(row))
        page = _html_start('合成群', gallery=True) + gallery_body(entries)
        gallery = Markup(page)
        chat = Markup(_message_html(row))
        source_links = [link for link in gallery.links if link.startswith('chat.html#')]
        self.assertEqual(len(source_links), 3)
        self.assertTrue(all(link.split('#')[1] in chat.ids for link in source_links))
        for link in gallery.links:
            if link.startswith('#'):
                self.assertIn(link[1:], gallery.ids)
        self.assertEqual(len(gallery.ids), len(set(gallery.ids)))
        self.assertNotIn('script', gallery.tags)
        self.assertIn('仅缩略图', page)
        self.assertIn('图片缺失', page)
        self.assertIn('原图可查看', page)
        self.assertIn('original:&lt;&amp;&gt;', page)
        self.assertEqual(chat.ids, [message_anchor(row['id'])])

    def test_image_path_or_reason_cannot_inject_markup_or_link_outside_assets(self):
        for relative in ('javascript:alert(1)', 'assets/../../secret.png', 'assets\\secret.png'):
            page = image_card({'status': 'ready', 'path': relative, 'reason': '<script>bad</script>'})
            markup = Markup(page)
            self.assertEqual(markup.links, [])
            self.assertNotIn('script', markup.tags)
            self.assertIn('&lt;script&gt;', page)

    def test_unloaded_media_is_not_reported_as_a_missing_original(self):
        page = gallery_body(list(image_references({'id': 'not-loaded', 'kind': 'image'})))
        self.assertIn('未加载 1', page)
        self.assertIn('图片缺失 0', page)
        self.assertNotIn('本地没有可显示的文件', page)


class NativeGalleryTests(unittest.TestCase):
    def test_visible_cards_decode_pictures_zoom_and_navigate_to_nested_source(self):
        import tkinter as tk
        from PIL import Image
        from offline_widgets import MessageBrowser
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'assets').mkdir()
            buffer = BytesIO()
            Image.new('RGB', (600, 360), '#2d7e9e').save(buffer, 'PNG')
            data = buffer.getvalue()
            row = fixture()
            for image in (row['record']['items'][1], row['quote']['message']):
                asset = image['asset']
                (root / asset['path']).write_bytes(data)
                asset.update(size=len(data), digest=hashlib.sha256(data).hexdigest(), mime='image/png')
            (root / 'manifest.json').write_text('{}', encoding='utf-8')
            (root / 'messages.jsonl').write_text(json.dumps(row), encoding='utf-8')
            window = tk.Tk()
            self.addCleanup(window.destroy)
            window.geometry('900x700')
            view = ConversationView(root)
            def reveal(entry):
                browser.load(view.page_for_message(entry['rootMessageId']))
                browser.reveal(entry)
            browser = MessageBrowser(window, show_source=reveal)
            browser.pack(fill='both', expand=True)
            browser.load(view.page())
            browser.set_gallery(view)
            browser.tabs.select(browser.gallery)
            window.update()
            self.assertEqual(browser.gallery.card_count, 3)
            self.assertEqual(len(browser.gallery.photos), 2)
            self.assertTrue(all(photo.width() > 0 for photo in browser.gallery.photos))
            entry = browser.gallery.page['images'][0]
            reveal(entry)
            self.assertEqual(browser.rows[browser.tree.selection()[0]]['part'], '1.1')
            reveal(browser.gallery.page['images'][-1])
            self.assertEqual(browser.rows[browser.tree.selection()[0]]['senderName'], '被引用人')
            popup = browser.image_window(browser.gallery.page['images'][1]['asset'])
            self.assertIsNotNone(popup)
            popup.update()
            self.assertTrue(popup.winfo_ismapped())
            popup.destroy()


if __name__ == '__main__':
    unittest.main()
