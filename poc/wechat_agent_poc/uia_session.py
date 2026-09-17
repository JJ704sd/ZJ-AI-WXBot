"""Single-thread, selected-session UIA read foundation. No send operations.

Backend identifiers are only valid within the current UI session. They are not
server IDs and must never be promoted into the API/database event namespace.
"""
from threading import get_ident


class UiaReadBlocked(RuntimeError):
    pass


class UiaSessionReader:
    def __init__(self, backend, *, expected_title, generation, max_items=200):
        if not expected_title or not generation or max_items < 1:
            raise ValueError('explicit session binding and limit required')
        self.backend = backend
        self.expected_title = expected_title
        self.generation = generation
        self.max_items = max_items
        self.thread = get_ident()
        self.seen = set()
        self.ready = False
        self.paused = False

    def poll(self):
        if get_ident() != self.thread:
            raise UiaReadBlocked('wrong_ui_thread')
        if self.paused:
            raise UiaReadBlocked('session_paused')
        try:
            before = self.backend.observe()
            self._check(before)
            rows = self.backend.read_visible()
            self._check(self.backend.observe())
            if not isinstance(rows, list) or len(rows) > self.max_items:
                raise UiaReadBlocked('invalid_or_oversized_snapshot')
            keys = []
            for row in rows:
                key = row.get('ui_id')
                if not isinstance(key, str) or not key:
                    raise UiaReadBlocked('missing_ui_identity')
                keys.append(key)
            if len(set(keys)) != len(keys):
                raise UiaReadBlocked('duplicate_ui_identity')
            if self.ready and self.seen and not self.seen.intersection(keys):
                raise UiaReadBlocked('viewport_continuity_unknown')
            fresh = [] if not self.ready else [
                dict(row, source_kind='uia', session_generation=self.generation,
                     mention_status='unknown')
                for row in rows if row['ui_id'] not in self.seen
                and row.get('attr') == 'friend' and row.get('type') == 'text'
            ]
            self.seen.update(keys)
            self.ready = True
            return fresh
        except Exception:
            self.paused = True
            # Avoid leaking backend exceptions containing titles or message text.
            raise UiaReadBlocked('read_failed_or_binding_changed') from None

    def _check(self, observed):
        if (not isinstance(observed, dict)
                or observed.get('title') != self.expected_title
                or observed.get('generation') != self.generation
                or observed.get('account_verified') is not True
                or observed.get('group_verified') is not True
                or observed.get('locked') is not False):
            raise UiaReadBlocked('unverified_session')
