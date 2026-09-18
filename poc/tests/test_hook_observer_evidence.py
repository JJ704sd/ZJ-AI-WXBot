import pytest

from wechat_agent_poc.hook_observer_evidence import (
    thread_inventory,
    verify_breakpoint_readback,
)


def breakpoint_response(body: str) -> str:
    return (
        '7^done,BreakpointTable={nr_rows="2",nr_cols="6",'
        'hdr=[{width="4",alignment="-1",col_name="number",colhdr="Num"}],'
        f'body=[{body}]}}'
    )


def breakpoint(number: str, address: str, *, kind: str = "hw breakpoint", enabled: str = "y") -> str:
    return (
        f'bkpt={{number="{number}",type="{kind}",enabled="{enabled}",'
        f'addr="{address}",func="fixture_marker"}}'
    )


def test_breakpoint_readback_requires_the_expected_flat_records():
    response = breakpoint_response(
        breakpoint("1", "0x1000") + "," + breakpoint("2", "0x2000")
    )
    assert verify_breakpoint_readback(response, {"1": 0x1000, "2": 0x2000})


@pytest.mark.parametrize(
    ("body", "expected"),
    [
        (breakpoint("1", "0x1000") + "," + breakpoint("2", "0x2000"), {"1": 0x1000}),
        (breakpoint("1", "0x1000"), {"1": 0x1000, "2": 0x2000}),
    ],
)
def test_breakpoint_readback_requires_strict_set_equality(body, expected):
    assert not verify_breakpoint_readback(breakpoint_response(body), expected)


def test_breakpoint_readback_rejects_duplicate_number_and_malformed_record():
    duplicate = breakpoint_response(
        breakpoint("1", "0x1000") + "," + breakpoint("1", "0x1000")
    )
    malformed = breakpoint_response(breakpoint("1", "0x1000") + ",not-a-breakpoint")
    assert not verify_breakpoint_readback(duplicate, {"1": 0x1000})
    assert not verify_breakpoint_readback(malformed, {"1": 0x1000})


@pytest.mark.parametrize(
    "record",
    [
        breakpoint("1", "0x1000", enabled="n"),
        breakpoint("1", "0x1000", kind="software breakpoint"),
        breakpoint("1", "not-an-address"),
    ],
)
def test_breakpoint_readback_rejects_unsafe_record_fields(record):
    assert not verify_breakpoint_readback(breakpoint_response(record), {"1": 0x1000})


def test_breakpoint_readback_rejects_multi_location_records():
    record = breakpoint("1", "0x1000").replace(
        'func="fixture_marker"',
        'func="fixture_marker",locations=[{number="1.1",enabled="y"}]',
    )
    assert not verify_breakpoint_readback(breakpoint_response(record), {"1": 0x1000})


def test_breakpoint_readback_accepts_an_empty_flat_table_for_empty_expectation():
    assert verify_breakpoint_readback(breakpoint_response(""), {})


def test_breakpoint_readback_requires_a_done_response_and_body():
    assert not verify_breakpoint_readback(
        '7^error,msg="break-list failed"', {"1": 0x1000}
    )
    assert not verify_breakpoint_readback('7^done,BreakpointTable={body=[]}', {"1": 0x1000})


def test_thread_inventory_returns_unique_nonempty_ids_with_matching_count():
    response = '3^done,thread-ids={thread-id="1",thread-id="2"},number-of-threads="2"'
    assert thread_inventory(response) == {"1", "2"}


@pytest.mark.parametrize(
    "response",
    [
        '3^done,thread-ids={thread-id="1"},number-of-threads="2"',
        '3^done,thread-ids={},number-of-threads="0"',
        '3^done,thread-ids={thread-id="1",thread-id="1"},number-of-threads="2"',
        '3^error,msg="thread listing failed"',
    ],
)
def test_thread_inventory_rejects_count_empty_duplicate_or_failed_responses(response):
    with pytest.raises(ValueError):
        thread_inventory(response)
