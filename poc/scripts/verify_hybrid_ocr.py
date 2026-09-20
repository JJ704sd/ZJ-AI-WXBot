"""Local synthetic OCR verification; never discovers or accesses Weixin."""
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from PIL import Image, ImageDraw, ImageFont
from wechat_agent_poc.hybrid_observer import HybridSessionObserver, Layout
from wechat_agent_poc.local_ocr import ImageBackend, WindowsOcr


def main():
    output = Path(__file__).resolve().parents[1] / '.local/hybrid-ocr-synthetic'
    output.mkdir(parents=True, exist_ok=True)
    image = Image.new('RGB', (800, 600), 'white')
    draw = ImageDraw.Draw(image)
    font = ImageFont.truetype('C:/Windows/Fonts/msyh.ttc', 26)
    draw.text((320, 20), 'OCR Test Group', fill='black', font=font)
    draw.text((320, 120), 'Hello world 12345', fill='black', font=font)
    draw.text((320, 180), '中文测试 请回复', fill='black', font=font)
    image.save(output / 'fixture.png')
    image.close()
    layout = Layout(800, 600, (300, 0, 800, 80), (300, 80, 800, 500), 'OCR Test Group')
    (output / 'layout.json').write_text(json.dumps(vars(layout)), encoding='utf-8')
    backend = ImageBackend(output / 'fixture.png')
    try:
        snapshot = HybridSessionObserver(backend, WindowsOcr(), layout).poll()
        (output / 'snapshot.json').write_text(json.dumps(snapshot, ensure_ascii=False, indent=2), encoding='utf-8')
        texts = [row['text'] for row in snapshot['messages']]
        compact = ''.join(texts).replace(' ', '')
        passed = 'Hello world 12345' in texts and '中文测试请回复' in compact
        report = {'status': 'PASS' if passed else 'FAIL', 'wechat_access': False,
                  'capture_kind': snapshot['capture_kind'], 'source': snapshot['source'],
                  'english_spaces_preserved': 'Hello world 12345' in texts,
                  'chinese_recognized': '中文测试请回复' in compact,
                  'line_count': len(texts), 'agent_enabled': False}
        (output / 'report.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
        print(json.dumps(report))
        return 0 if passed else 1
    finally:
        backend.close()


if __name__ == '__main__':
    raise SystemExit(main())
