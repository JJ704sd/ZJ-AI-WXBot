"""Validation for the small GDB/MI observations used by the hook fixture."""

import re


_DONE_LINE = re.compile(r"(?m)^\s*(?:\d+)?\^done(?:,|$)[^\r\n]*")
_FIELD = re.compile(
    r'(?:^|,)\s*{name}="((?:\\.|[^"\\])*)"'
)


def _done_line(mi_text: str) -> str | None:
    if not isinstance(mi_text, str):
        return None
    matches = list(_DONE_LINE.finditer(mi_text))
    if len(matches) != 1:
        return None
    return matches[0].group(0).strip()


def _balanced_end(text: str, start: int, opening: str, closing: str) -> int | None:
    depth = 0
    quoted = False
    escaped = False
    for index in range(start, len(text)):
        char = text[index]
        if escaped:
            escaped = False
            continue
        if quoted and char == "\\":
            escaped = True
            continue
        if char == '"':
            quoted = not quoted
            continue
        if quoted:
            continue
        if char == opening:
            depth += 1
        elif char == closing:
            depth -= 1
            if depth == 0:
                return index
            if depth < 0:
                return None
    return None


def _body_records(body: str) -> list[str] | None:
    records: list[str] = []
    index = 0
    while True:
        while index < len(body) and body[index].isspace():
            index += 1
        if index == len(body):
            return records
        marker = "bkpt={"
        if not body.startswith(marker, index):
            return None
        record_start = index + len(marker) - 1
        record_end = _balanced_end(body, record_start, "{", "}")
        if record_end is None:
            return None
        record = body[record_start + 1 : record_end]
        if "locations=" in record or "{" in record or "}" in record:
            return None
        records.append(record)
        index = record_end + 1
        while index < len(body) and body[index].isspace():
            index += 1
        if index == len(body):
            return records
        if body[index] != ",":
            return None
        index += 1
        if not body[index:].strip():
            return None


def _field(record: str, name: str) -> str | None:
    matches = re.findall(_FIELD.pattern.format(name=re.escape(name)), record)
    if len(matches) != 1:
        return None
    return matches[0]


def verify_breakpoint_readback(mi_text: str, expected: dict[str, int]) -> bool:
    """Return whether a flat ``-break-list`` body exactly matches ``expected``."""
    if not isinstance(expected, dict) or any(
        not isinstance(number, str)
        or not number
        or not isinstance(address, int)
        or isinstance(address, bool)
        or address < 0
        for number, address in expected.items()
    ):
        return False
    done = _done_line(mi_text)
    if done is None:
        return False
    body_marker = "body=["
    body_start = done.find(body_marker)
    if body_start < 0:
        return False
    body_start += len(body_marker) - 1
    body_end = _balanced_end(done, body_start, "[", "]")
    if body_end is None:
        return False
    records = _body_records(done[body_start + 1 : body_end])
    if records is None:
        return False

    observed: dict[str, int] = {}
    for record in records:
        number = _field(record, "number")
        kind = _field(record, "type")
        enabled = _field(record, "enabled")
        address = _field(record, "addr")
        if (
            number is None
            or not re.fullmatch(r"\d+", number)
            or kind != "hw breakpoint"
            or enabled != "y"
            or address is None
            or not re.fullmatch(r"0x[0-9a-fA-F]+", address)
        ):
            return False
        if number in observed:
            return False
        observed[number] = int(address, 16)
    return observed == expected


def thread_inventory(mi_text: str) -> set[str]:
    """Read and validate the flat ``-thread-list-ids`` response."""
    done = _done_line(mi_text)
    if done is None:
        raise ValueError("expected one ^done response")
    ids_matches = re.findall(r"thread-ids=\{([^{}]*)\}", done)
    count_matches = re.findall(r'number-of-threads="(\d+)"', done)
    if len(ids_matches) != 1 or len(count_matches) != 1:
        raise ValueError("malformed thread inventory")
    fields = [field.strip() for field in ids_matches[0].split(",") if field.strip()]
    ids: list[str] = []
    for field in fields:
        match = re.fullmatch(r'thread-id="([^"]+)"', field)
        if match is None:
            raise ValueError("malformed thread id")
        ids.append(match.group(1))
    if not ids or len(ids) != len(set(ids)):
        raise ValueError("thread inventory must contain unique ids")
    count = int(count_matches[0])
    if count != len(ids):
        raise ValueError("thread inventory count mismatch")
    return set(ids)
