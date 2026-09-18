import importlib.util
from pathlib import Path

import pytest


spec = importlib.util.spec_from_file_location(
    'owned_fixture', Path(__file__).resolve().parents[1]/'scripts/verify_hook_attach_fixture.py')
fixture = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fixture)


def snapshots():
    return [dict(ok=True, resume_ok=True, dr=[0x1000, 0x2000, 0x3000, 0], dr7=0x15)
            for _ in range(3)]


def test_three_snapshots_match_only_enabled_execution_slots():
    assert fixture.register_snapshot_matches(snapshots(), {0x1000, 0x2000, 0x3000})
    rows = snapshots()
    for row in rows:
        row['dr7'] = 0
    assert fixture.register_snapshot_matches(rows, set())
    assert not fixture.register_snapshot_matches(rows, {0x1000, 0x2000, 0x3000})


@pytest.mark.parametrize('change', [dict(ok=False), dict(resume_ok=False), dict(dr7=0x10015),
                                   dict(dr=[0x1000, 0x2000, 0x9999, 0]), dict(dr7=True),
                                   dict(dr=[0x1000, 0x2000]), dict(dr7=0x5)])
def test_one_bad_thread_prevents_coverage_claim(change):
    rows = snapshots()
    rows[1].update(change)
    assert not fixture.register_snapshot_matches(rows, {0x1000, 0x2000, 0x3000})


def test_missing_thread_prevents_coverage_claim():
    assert not fixture.register_snapshot_matches(snapshots()[:2], {0x1000, 0x2000, 0x3000})
