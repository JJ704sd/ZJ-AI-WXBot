"""Fixed user profiles and safe legacy configuration migration, synthetic data only."""
import json
import os
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch


class ProfileMigrationTests(unittest.TestCase):
    def test_generic_skill_can_still_select_client_explicitly(self):
        import hashlib
        from local_chat_app import main
        with tempfile.TemporaryDirectory() as folder:
            base=Path(folder)
            exe=base/'package/bin/local-chat-desktop-1.15.1.exe'
            exe.parent.mkdir(parents=True)
            exe.write_bytes(b'synthetic generic executable')
            (exe.parent.parent/'runtime.json').write_text(json.dumps({'clientBinding':'selectable',
                'exeRelativePath':'bin/'+exe.name,'exeSha256':hashlib.sha256(exe.read_bytes()).hexdigest()}),encoding='utf8')
            for client in ('wechat','wecom'):
                with self.subTest(client=client), patch.object(sys,'frozen',True,create=True), \
                        patch.object(sys,'executable',str(exe)), patch('offline_batch.run_file',return_value=0) as batch:
                    main(['--client',client,'--task-json',str(base/'request.json'),'--result-json',str(base/'result.json')])
                    self.assertEqual(batch.call_args.kwargs['client'],client)

    def test_broken_or_conflicting_skill_binding_never_opens_another_profile(self):
        import hashlib
        import io
        from contextlib import redirect_stderr
        from local_chat_app import main
        with tempfile.TemporaryDirectory() as folder:
            base=Path(folder)
            exe=base/'package/bin/local-chat-desktop-1.15.1.exe'
            exe.parent.mkdir(parents=True)
            exe.write_bytes(b'synthetic executable')
            manifest=exe.parent.parent/'runtime.json'
            valid={'client':'wecom','exeRelativePath':'bin/'+exe.name,
                   'exeSha256':hashlib.sha256(exe.read_bytes()).hexdigest()}
            cases=[(valid,['--client','wechat']), (None,[]), ({**valid,'client':'unknown'},[]),
                   ({**valid,'exeSha256':'0'*64},[]), ({**valid,'exeRelativePath':'../outside.exe'},[])]
            for value, extra in cases:
                if value is None:
                    manifest.unlink(missing_ok=True)
                else:
                    manifest.write_text(json.dumps(value),encoding='utf8')
                with self.subTest(value=value,extra=extra), redirect_stderr(io.StringIO()), \
                        patch.dict(os.environ, {'LOCALAPPDATA':str(base/'user')}), \
                        patch.object(sys,'frozen',True,create=True), patch.object(sys,'executable',str(exe)), \
                        patch('offline_batch.run_file') as batch:
                    with self.assertRaises(SystemExit) as raised:
                        main(extra+['--task-json',str(base/'task.json'),'--result-json',str(base/'result.json')])
                    self.assertEqual(raised.exception.code,2)
                    batch.assert_not_called()
                    self.assertFalse((base/'user').exists())

    def test_double_clicked_skill_exe_selects_packaged_client_before_profile(self):
        import hashlib
        from local_chat_app import main
        with tempfile.TemporaryDirectory() as folder:
            base = Path(folder)
            # Random package names prove binding does not depend on folder labels.
            for client, name in (('wechat', 'LocalWechatArchive'), ('wecom', 'LocalWeComArchive')):
                package = base/client/'arbitrary-renamed-folder'
                exe = package/'bin/local-chat-desktop-1.15.1.exe'
                exe.parent.mkdir(parents=True)
                exe.write_bytes(b'synthetic executable')
                (package/'runtime.json').write_text(json.dumps({'client': client,
                    'exeRelativePath': 'bin/'+exe.name,
                    'exeSha256': hashlib.sha256(exe.read_bytes()).hexdigest()}), encoding='utf8')
                with self.subTest(client=client), patch.dict(os.environ, {'LOCALAPPDATA': str(base/'user')}), \
                        patch.object(sys, 'frozen', True, create=True), patch.object(sys, 'executable', str(exe)), \
                        patch('offline_batch.run_file', return_value=0) as batch:
                    self.assertEqual(main(['--task-json', str(base/'request.json'),
                                           '--result-json', str(base/'result.json')]), 0)
                    self.assertEqual(batch.call_args.kwargs['client'], client)
                    self.assertEqual(Path(batch.call_args.args[2]).resolve(), (base/'user'/name).resolve())

    def test_desktop_and_skill_use_same_profile_after_executable_moves(self):
        from local_chat_app import main
        with tempfile.TemporaryDirectory() as folder:
            base = Path(folder)
            for client, name in (('wechat', 'LocalWechatArchive'), ('wecom', 'LocalWeComArchive')):
                for release in ('old-release', 'new-release'):
                    with self.subTest(client=client, release=release), patch.dict(os.environ, {'LOCALAPPDATA': str(base/'user')}), \
                            patch.object(sys, 'frozen', True, create=True), \
                            patch.object(sys, 'executable', str(base/release/'reader.exe')), \
                            patch('offline_batch.run_file', return_value=0) as batch:
                        self.assertEqual(main(['--client', client, '--task-json', str(base/'request.json'),
                                               '--result-json', str(base/'result.json')]), 0)
                        self.assertEqual(Path(batch.call_args.args[2]).resolve(), (base/'user'/name).resolve())
                        custom = base/'custom'
                        main(['--client', client, '--data-dir', str(custom), '--task-json', str(base/'request.json'),
                              '--result-json', str(base/'result.json')])
                        self.assertEqual(Path(batch.call_args.args[2]), custom)

    def legacy(self, base, client, release='old-release', *, source=None):
        from test_wecom_archive import fixture
        from test_database_adapter import create_metadata, create_shard
        source = source or base/('account-'+client)/('Data' if client == 'wecom' else 'db_storage')
        if not source.exists():
            source.parent.mkdir(parents=True)
            if client == 'wecom':
                fixture(source)
            else:
                source.mkdir()
                create_metadata(source)
                create_shard(source, rows=[{'text': '配置迁移合成记录'}])
        old = base/release/('local-chat-data-wecom' if client == 'wecom' else 'local-chat-data')
        (old/'keys').mkdir(parents=True)
        key = {'wecomKeys': [{'database': '*', 'key_hex': bytes(range(16)).hex()}]} if client == 'wecom' else {'keys': []}
        (old/'keys/provided.json').write_text(json.dumps(key), encoding='utf8')
        (old/'keys/image.json').write_text(json.dumps({'keys': []}), encoding='utf8')
        settings = old/'settings.local.json'
        settings.write_text(json.dumps({'version': 1, 'client': client, 'lastChat': 'R:synthetic' if client == 'wecom' else 'synthetic@chatroom',
            'source': {'sourceRoot': str(source), 'keyFile': 'keys/provided.json', 'imageKeyFile': 'keys/image.json',
                       'includeMedia': True, 'includeVoice': False}}), encoding='utf8')
        return settings

    def test_migrates_both_clients_preserves_keys_and_reuses_after_move(self):
        from offline_desktop import DesktopSession
        from offline_profiles import default_directory
        with tempfile.TemporaryDirectory() as folder:
            base = Path(folder).resolve()
            for client in ('wechat', 'wecom'):
                old = self.legacy(base, client)
                original = old.read_bytes()
                with patch.dict(os.environ, {'LOCALAPPDATA': str(base/'user')}), \
                        patch('offline_profiles.application_directory', return_value=base/'new-release'), \
                        patch('offline_profiles.Path.cwd', return_value=base):
                    target = default_directory(client)
                    session = DesktopSession(target, client=client)
                    self.assertEqual(session.bootstrap()['status'], 'ready')
                    self.assertIn('已迁移', session.source_status)
                    settings = json.loads(session.settings_path.read_text(encoding='utf8'))
                    self.assertEqual(settings['client'], client)
                    self.assertEqual(settings['lastChat'], json.loads(original)['lastChat'])
                    for name in ('keyFile', 'imageKeyFile'):
                        copied = Path(settings['source'][name])
                        self.assertEqual(copied.parent, target/'keys')
                        self.assertEqual(copied.read_bytes(), (old.parent/json.loads(original)['source'][name]).read_bytes())
                    self.assertEqual(old.read_bytes(), original)
                    # A later upgrade can reuse the profile with no legacy directory present.
                    with patch('offline_profiles.legacy_settings', side_effect=AssertionError('must not rediscover existing profile')):
                        fresh = DesktopSession(target, client=client)
                        self.assertEqual(fresh.bootstrap()['status'], 'ready')
                        self.assertEqual(fresh.settings, settings)

    def test_conflicting_accounts_require_selection_and_explicit_import_continues(self):
        from offline_desktop import DesktopSession
        from offline_profiles import default_directory
        with tempfile.TemporaryDirectory() as folder:
            base = Path(folder).resolve()
            first = self.legacy(base, 'wecom')
            self.legacy(base, 'wecom', 'another-release', source=base/'different-account'/'Data')
            with patch.dict(os.environ, {'LOCALAPPDATA': str(base/'user')}), \
                    patch('offline_profiles.application_directory', return_value=base/'new-release'), \
                        patch('offline_profiles.Path.cwd', return_value=base):
                session = DesktopSession(default_directory('wecom'), client='wecom')
                result = session.bootstrap()
                self.assertEqual(result['status'], 'needs_source')
                self.assertIn('多个不同账号', result['message'])
                self.assertFalse(session.settings_path.exists())
                self.assertFalse((session.directory/'snapshots').exists(), 'must not read any conflicting account')
                self.assertEqual(session.import_settings(first)['status'], 'ready')
                self.assertEqual(session.settings['source']['sourceRoot'], str(base/'account-wecom/Data'))

    def test_invalid_or_wrong_client_does_not_overwrite_and_custom_profile_does_not_search(self):
        from offline_desktop import DesktopSession
        from offline_profiles import default_directory
        with tempfile.TemporaryDirectory() as folder:
            base = Path(folder).resolve()
            old = self.legacy(base, 'wecom')
            with patch.dict(os.environ, {'LOCALAPPDATA': str(base/'user')}), \
                    patch('offline_profiles.application_directory', return_value=base/'new-release'), \
                        patch('offline_profiles.Path.cwd', return_value=base):
                custom = DesktopSession(base/'custom', client='wecom')
                self.assertEqual(custom.bootstrap()['status'], 'needs_source')
                with self.assertRaises(ValueError):
                    DesktopSession(base/'personal').import_settings(old)
                target = default_directory('wecom')
                target.mkdir(parents=True)
                existing = target/'settings.local.json'
                existing.write_bytes(b'{broken')
                result = DesktopSession(target, client='wecom').bootstrap()
                self.assertEqual(result['status'], 'needs_source')
                self.assertEqual(existing.read_bytes(), b'{broken')
                existing.unlink()
                value = json.loads(old.read_text())
                value['source']['keyFile'] = 'not-present.json'
                old.write_text(json.dumps(value))
                result = DesktopSession(target, client='wecom').bootstrap()
                self.assertEqual(result['status'], 'needs_source')
                self.assertFalse(existing.exists())

    def test_interrupted_key_copy_retries_without_modifying_original(self):
        from offline_desktop import DesktopSession
        from offline_profiles import default_directory
        with tempfile.TemporaryDirectory() as folder:
            base = Path(folder).resolve()
            old = self.legacy(base, 'wecom')
            original = old.read_bytes()
            with patch.dict(os.environ, {'LOCALAPPDATA': str(base/'user')}), \
                    patch('offline_profiles.application_directory', return_value=base/'new-release'), \
                        patch('offline_profiles.Path.cwd', return_value=base):
                target = default_directory('wecom')
                with patch('offline_profiles.publish_settings', side_effect=PermissionError()):
                    self.assertEqual(DesktopSession(target, client='wecom').bootstrap()['status'], 'needs_source')
                self.assertFalse((target/'settings.local.json').exists())
                self.assertEqual(DesktopSession(target, client='wecom').bootstrap()['status'], 'ready')
                self.assertEqual(old.read_bytes(), original)

    def test_other_client_task_cannot_write_to_default_personal_profile(self):
        from local_chat_app import main
        with tempfile.TemporaryDirectory() as folder:
            base = Path(folder).resolve()
            request, result = base/'task.json', base/'result.json'
            request.write_text(json.dumps({'version': 1, 'client': 'wecom', 'action': 'groups'}))
            with patch.dict(os.environ, {'LOCALAPPDATA': str(base/'user')}):
                self.assertEqual(main(['--task-json', str(request), '--result-json', str(result)]), 2)
            self.assertFalse(json.loads(result.read_text(encoding='utf8'))['ok'])
            self.assertFalse((base/'user/LocalWechatArchive/settings.local.json').exists())


if __name__ == '__main__':
    unittest.main()
