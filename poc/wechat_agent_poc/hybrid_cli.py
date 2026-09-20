"""One-shot observer. Text is written only to an explicitly selected local file."""
import argparse
import json
from pathlib import Path

from .hybrid_observer import HybridSessionObserver, Layout, ObservationBlocked
from .local_ocr import ImageBackend, WindowsOcr


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument('--image', type=Path, help='Offline image; never a live acceptance result')
    source.add_argument('--hwnd', type=lambda x: int(x, 0), help='Pinned foreground Weixin HWND')
    parser.add_argument('--layout', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path, help='Private JSON; includes visible text')
    parser.add_argument('--language', default='zh-Hans')
    parser.add_argument('--ocr-engine', choices=['windows', 'rapidocr'], default='windows')
    parser.add_argument('--review-unconfirmed-title', action='store_true',
                        help='Save an explicitly unbound review snapshot if OCR title differs')
    parser.add_argument('--capture-method', choices=['window', 'screen_region'], default='window')
    parser.add_argument('--wait-for-foreground', type=int, choices=range(31), default=0, metavar='0..30')
    args = parser.parse_args()
    backend = None
    try:
        if args.output.exists():
            raise ObservationBlocked('output_already_exists')
        layout = Layout.from_dict(json.loads(args.layout.read_text(encoding='utf-8-sig')))
        if args.image:
            backend = ImageBackend(args.image)
        else:
            from .hybrid_windows import wait_for_window
            backend = wait_for_window(args.hwnd, args.capture_method, args.wait_for_foreground)
        if args.ocr_engine == 'rapidocr':
            from .rapid_ocr import RapidOcr
            ocr = RapidOcr()
        else:
            ocr = WindowsOcr(args.language)
        result = HybridSessionObserver(backend, ocr, layout,
                    review_unconfirmed_title=args.review_unconfirmed_title).poll()
        result['ocr_engine'] = args.ocr_engine if result['source'] == 'ocr' else None
        args.output.parent.mkdir(parents=True, exist_ok=True)
        with args.output.open('x', encoding='utf-8') as stream:
            json.dump(result, stream, ensure_ascii=False, indent=2)
        print(json.dumps({'status': 'REVIEW_REQUIRED' if result['review_required'] else 'OBSERVED',
                          'source': result['source'],
                          'capture_kind': result['capture_kind'],
                          'visible_lines': len(result['messages']),
                          'agent_enabled': False, 'send_enabled': False}))
        return 0
    except ObservationBlocked as exc:
        print(json.dumps({'status': 'BLOCKED', 'reason': str(exc)}))
        return 2
    except Exception:
        print(json.dumps({'status': 'ERROR', 'reason': 'invalid_input_or_backend_error'}))
        return 2
    finally:
        if backend is not None and hasattr(backend, 'close'):
            backend.close()


if __name__ == '__main__':
    raise SystemExit(main())
