from wechat_agent_poc import local_env


def test_fixed_file_loads_only_model_key(tmp_path, monkeypatch):
    monkeypatch.delenv('MINIMAX_API_KEY', raising=False)
    monkeypatch.delenv('UNRELATED_TEST_SECRET', raising=False)
    monkeypatch.setattr(local_env, '__file__', str(tmp_path / 'package' / 'local_env.py'))
    (tmp_path / '.env').write_text(
        '# comment\nMINIMAX_API_KEY="synthetic-key"\nUNRELATED_TEST_SECRET=no\n', encoding='utf-8-sig'
    )
    local_env.load_minimax_env()
    assert local_env.os.environ['MINIMAX_API_KEY'] == 'synthetic-key'
    assert 'UNRELATED_TEST_SECRET' not in local_env.os.environ


def test_process_environment_wins(tmp_path, monkeypatch):
    monkeypatch.setenv('MINIMAX_API_KEY', 'existing-synthetic')
    monkeypatch.setattr(local_env, '__file__', str(tmp_path / 'package' / 'local_env.py'))
    (tmp_path / '.env').write_text('MINIMAX_API_KEY=file-synthetic', encoding='utf-8')
    local_env.load_minimax_env()
    assert local_env.os.environ['MINIMAX_API_KEY'] == 'existing-synthetic'


def test_missing_file_is_optional(tmp_path, monkeypatch):
    monkeypatch.delenv('MINIMAX_API_KEY', raising=False)
    monkeypatch.setattr(local_env, '__file__', str(tmp_path / 'package' / 'local_env.py'))
    local_env.load_minimax_env()
    assert 'MINIMAX_API_KEY' not in local_env.os.environ
