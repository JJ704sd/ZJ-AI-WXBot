"""Structural admission for the pinned pyweixin source, never live approval."""
VERSION = '4.1.13.65'
REQUIRED = ('sessions', 'messages', 'input')


def assess(observation):
    missing = [name for name in REQUIRED if observation.get(name) is not True]
    if observation.get('complete') is not True:
        status = 'incomplete_observation'
    elif observation.get('binding_stable') is not True:
        status = 'window_binding_changed'
    elif observation.get('version') != VERSION:
        status = 'unreviewed_client_version'
    elif observation.get('root_class') == 'mmui::LoginWindow':
        status = 'login_required'
    elif observation.get('root_class') != 'mmui::MainWindow':
        status = 'upstream_entry_blocked'
    elif missing:
        status = 'missing_semantic_controls'
    else:
        status = 'structure_candidate_only'
    return dict(status=status, missing=missing, account_verified=False,
                group_verified=False, read_verified=False, mention_status='unknown',
                send_enabled=False, agent_enabled=False)
