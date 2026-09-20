"""Isolated, local CPU OCR. Only local crop files are accepted by the worker."""
import json
from pathlib import Path
import sys
import tempfile

from .hybrid_observer import ObservationBlocked


class RapidOcr:
    def __init__(self, timeout=25):
        self.timeout = timeout

    def recognize(self, image):
        import psutil
        with tempfile.TemporaryDirectory(prefix='wechat-rapidocr-') as directory:
            source, output = Path(directory) / 'crop.png', Path(directory) / 'result.json'
            image.save(source)
            process = psutil.Popen([sys.executable, '-m', 'wechat_agent_poc.rapid_ocr',
                                    str(source), str(output)],
                                   cwd=str(Path(__file__).resolve().parents[1]),
                                   stdout=-3, stderr=-3, creationflags=0x08000000)
            try:
                code = process.wait(self.timeout)
            except psutil.TimeoutExpired:
                owned = process.children(recursive=True) + [process]
                for child in reversed(owned):
                    try:
                        child.kill()
                    except psutil.NoSuchProcess:
                        pass
                _, alive = psutil.wait_procs(owned, timeout=3)
                raise ObservationBlocked('rapidocr_cleanup_incomplete' if alive else 'rapidocr_timeout') from None
            if code != 0 or not output.exists():
                raise ObservationBlocked('rapidocr_failed')
            return json.loads(output.read_text(encoding='utf-8'))


def recognize_file(source):
    import numpy as np
    from PIL import Image
    from rapidocr_onnxruntime import RapidOCR
    # Open locally ourselves. Never pass URLs or untrusted path text to OCR.
    with Image.open(source) as image:
        pixels = np.asarray(image.convert('RGB'))[:, :, ::-1].copy()
    engine = RapidOCR(intra_op_num_threads=2, inter_op_num_threads=1)
    result, _ = engine(pixels)
    rows = []
    for polygon, text, score in result or []:
        xs, ys = [p[0] for p in polygon], [p[1] for p in polygon]
        rows.append({'text': text, 'box': [max(0, min(xs)), max(0, min(ys)),
                                         min(pixels.shape[1], max(xs)), min(pixels.shape[0], max(ys))],
                     'confidence': float(score)})
    return rows


if __name__ == '__main__':
    try:
        Path(sys.argv[2]).write_text(json.dumps(recognize_file(sys.argv[1]), ensure_ascii=False), encoding='utf-8')
    except Exception:
        sys.exit(2)
