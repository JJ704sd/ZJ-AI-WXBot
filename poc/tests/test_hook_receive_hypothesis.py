from scripts.analyze_hook_receive_candidate import normalize


def test_normalization_preserves_layout_and_internal_branch_topology():
    assert normalize('mov rcx,[rax-0x2d8]', 0x1000, 0x1100) != normalize('mov rcx,[rax-0x2e8]', 0x1000, 0x1100)
    assert normalize('je 0x1020', 0x1000, 0x1100) == 'je FUNCTION+0x20'
    assert normalize('je 0x1030', 0x1000, 0x1100) != 'je FUNCTION+0x20'
    assert normalize('call 0x2000', 0x1000, 0x1100) == 'call EXTERNAL'


def test_normalization_masks_only_address_dependent_operands():
    assert normalize('lea rdx,[rip+0x1234] # 0x2345', 0x1000, 0x1100) == 'lea rdx,[rip+REL]'
    assert normalize('mov eax,0x708', 0x1000, 0x1100) == 'mov eax,0x708'
