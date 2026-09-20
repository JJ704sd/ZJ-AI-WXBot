"""Read-only UIA/OCR snapshots. Deliberately not an Agent message source."""
from dataclasses import dataclass
import hashlib
import json
import math
import re
from uuid import uuid4
from datetime import datetime, timezone


class ObservationBlocked(RuntimeError):
    pass


def label_key(text):
    """OCR often inserts spaces around Han characters; never rewrite body text.

    This deliberately weak label comparison is NOT an identity binding.
    English word separators, punctuation and member counts remain significant.
    """
    return re.sub(r'(?<=[\u3400-\u9fff])\s+|\s+(?=[\u3400-\u9fff])', '', text.strip())


@dataclass(frozen=True)
class Layout:
    width: int
    height: int
    header: tuple
    messages: tuple
    expected_title: str

    def __post_init__(self):
        if (type(self.width) is not int or type(self.height) is not int
                or not 1 <= self.width <= 10000 or not 1 <= self.height <= 10000
                or not isinstance(self.expected_title, str) or not self.expected_title.strip()):
            raise ValueError('invalid_layout')
        for box in (self.header, self.messages):
            if (len(box) != 4 or any(type(v) is not int for v in box)
                    or not 0 <= box[0] < box[2] <= self.width
                    or not 0 <= box[1] < box[3] <= self.height):
                raise ValueError('invalid_roi')
        a, b = self.header, self.messages
        if max(a[0], b[0]) < min(a[2], b[2]) and max(a[1], b[1]) < min(a[3], b[3]):
            raise ValueError('overlapping_rois')

    @classmethod
    def from_dict(cls, value):
        return cls(value['width'], value['height'], tuple(value['header']),
                   tuple(value['messages']), value['expected_title'])


def checked_lines(lines, width, height):
    if not isinstance(lines, list) or len(lines) > 500:
        raise ObservationBlocked('invalid_lines')
    clean = []
    for row in lines:
        text, box = row.get('text'), row.get('box')
        if (not isinstance(text, str) or len(text) > 10000
                or not isinstance(box, (tuple, list)) or len(box) != 4
                or any(type(v) not in (int, float) or not math.isfinite(v) for v in box)
                or not 0 <= box[0] < box[2] <= width
                or not 0 <= box[1] < box[3] <= height):
            raise ObservationBlocked('invalid_line')
        confidence = row.get('confidence')
        if confidence is not None and (type(confidence) not in (int, float)
                                       or not math.isfinite(confidence) or not 0 <= confidence <= 1):
            raise ObservationBlocked('invalid_confidence')
        clean.append({'text': text, 'box': list(box), 'confidence': confidence,
                      'sender': None, 'message_id': None, 'mention_status': 'unknown'})
    return clean


class HybridSessionObserver:
    """backend.observe/uia/capture and ocr.recognize are caller-owned ports.

    Only explicit semantic_unavailable permits fallback. Exceptions, identity
    changes and traversal truncation never silently become OCR success.
    """
    def __init__(self, backend, ocr, layout, *, review_unconfirmed_title=False):
        self.backend, self.ocr, self.layout = backend, ocr, layout
        self.previous = None
        self.paused = False
        self.review_unconfirmed_title = review_unconfirmed_title

    def poll(self):
        if self.paused:
            raise ObservationBlocked('observer_paused')
        try:
            return self._poll()
        except ObservationBlocked:
            self.paused = True
            raise
        except Exception:
            self.paused = True
            raise ObservationBlocked('backend_error') from None

    def _poll(self):
        before = self.backend.observe()
        if (before.get('available') is not True
                or before.get('size') != [self.layout.width, self.layout.height]):
            raise ObservationBlocked('window_or_layout_unavailable')
        result = self.backend.uia(self.layout)
        uia_status = result.get('status')
        uia_node_count = result.get('node_count')
        source = 'uia'
        if result.get('status') == 'semantic_unavailable':
            source = 'ocr'
            image = self.backend.capture()
            try:
                if image.size != (self.layout.width, self.layout.height):
                    raise ObservationBlocked('capture_size_changed')
                result = {}
                for name in ('header', 'messages'):
                    with image.crop(getattr(self.layout, name)) as crop:
                        result[name] = self.ocr.recognize(crop)
            finally:
                image.close()
        elif result.get('status') != 'readable':
            raise ObservationBlocked('uia_incomplete_or_failed')
        regions = {}
        for name in ('header', 'messages'):
            box = getattr(self.layout, name)
            regions[name] = checked_lines(result[name], box[2] - box[0], box[3] - box[1])
        if self.backend.observe() != before:
            raise ObservationBlocked('binding_changed')
        # A whitespace-normalized label is only a weak selection check.
        label_matched = label_key(self.layout.expected_title) in [label_key(r['text']) for r in regions['header']]
        if not label_matched and not self.review_unconfirmed_title:
            raise ObservationBlocked('target_label_unconfirmed')
        digest = hashlib.sha256(json.dumps(regions, ensure_ascii=False,
                                          sort_keys=True).encode()).hexdigest()
        key = (source, digest)
        baseline = self.previous is None or self.previous[0] != source
        changed = None if baseline else key != self.previous
        self.previous = key
        return {'schema': 'uia-ocr-observation/1', 'snapshot_id': str(uuid4()),
                'observed_at': datetime.now(timezone.utc).isoformat(),
                'uia_status': uia_status, 'uia_node_count': uia_node_count,
                'window_observation': before,
                'capture_kind': before['kind'], 'source': source,
                'capture_method': getattr(self.backend, 'capture_method', 'offline_image') if source == 'ocr' else None,
                'baseline': baseline, 'visible_text_changed': changed,
                'target_label_match': label_matched, 'review_required': not label_matched,
                'label_match_method': 'han_space_normalized',
                'account_verified': False,
                'group_verified': False, 'new_messages_verified': False,
                'native_mentions_verified': False, 'agent_enabled': False,
                'send_enabled': False, **regions}
