"""Version-specific structural admission; no fabricated live capabilities."""
PROFILES = {
    '4.1.8.107': {'root_classes': {'mmui::MainWindow'}, 'evidence': 'upstream_claim'},
    '4.1.13.65': {'root_classes': {'mmui::MainWindow', 'Qt51514QWindowIcon'},
                  'evidence': 'local_shell_only'},
}
REQUIRED = {'navigation': 'mmui::MainTabBar', 'sessions': 'mmui::ChatMasterView',
            'chat_page': 'mmui::ChatMessagePage', 'chat_splitter': 'mmui::XSplitterView'}


def assess_structure(version, root_class, classes, *, complete):
    profile = PROFILES.get(version)
    missing = [key for key, value in REQUIRED.items() if value not in set(classes)]
    if profile is None:
        status = 'unprofiled_client_version'
    elif root_class == 'mmui::LoginWindow':
        status = 'login_required'
    elif root_class not in profile['root_classes']:
        status = 'unknown_window_shell'
    elif missing:
        status = 'missing_semantic_controls' if complete else 'incomplete_structure'
    else:
        status = 'structural_candidate'
    return {'status': status, 'client_version': version, 'missing': missing,
            'binding_verified': False, 'read_verified': False,
            'send_enabled': False, 'profile_evidence': profile['evidence'] if profile else 'none'}
