from wechat_agent_poc.uia_profile import assess_structure, REQUIRED


def test_current_shell_does_not_mean_success():
    result = assess_structure('4.1.13.65', 'Qt51514QWindowIcon', ['MMUIRenderSubWindowHW'], complete=True)
    assert result['status'] == 'missing_semantic_controls'
    assert len(result['missing']) == 4
    assert not result['read_verified']


def test_shell_variant_with_controls_is_candidate_only():
    result = assess_structure('4.1.13.65', 'Qt51514QWindowIcon', REQUIRED.values(), complete=True)
    assert result['status'] == 'structural_candidate'
    assert not result['binding_verified'] and not result['send_enabled']


def test_unknown_version_not_silently_supported():
    assert assess_structure('4.9', 'mmui::MainWindow', REQUIRED.values(), complete=True)['status'] == 'unprofiled_client_version'


def test_incomplete_scan_not_definitive_absence():
    assert assess_structure('4.1.13.65', 'Qt51514QWindowIcon', [], complete=False)['status'] == 'incomplete_structure'


def test_login_controls_do_not_admit_chat_reader():
    result = assess_structure('4.1.13.65', 'mmui::LoginWindow', REQUIRED.values(), complete=True)
    assert result['status'] == 'login_required'
    assert not result['binding_verified'] and not result['read_verified']
    assert not result['send_enabled']
