import pytest
from scripts.audit_hook_control_flow import audit, graph, parse, path


def test_optional_site_and_optional_join_are_not_mandatory():
    rows=[(0,2,'je 0xa'),(2,2,'je 0x6'),(4,2,'mov eax,1'),
          (6,2,'mov ecx,2'),(8,2,'call 0x100'),(10,1,'ret')]
    report=audit(rows,4,6,8)
    assert report['entry_to_join_avoiding_previous_site']
    assert report['join_to_call']
    assert report['entry_to_return_avoiding_join']
    assert report['runtime_path_verified'] is False


def test_indirect_jump_not_fabricated_and_loops_terminate():
    edges, unresolved=graph([(0,2,'je 0x0'),(2,2,'jmp rax'),(4,1,'ret')])
    assert path(edges,0,4) is None
    assert unresolved == [2]


def test_parser_and_missing_boundaries_fail_closed():
    assert parse('  1000: 90 nop\n  1001: c3 ret')[1][0] == 0x1001
    with pytest.raises(ValueError):parse('  1000: 90 nop\n  1002: c3 ret')
    with pytest.raises(ValueError):audit([(0,1,'ret')],1,0,0)
