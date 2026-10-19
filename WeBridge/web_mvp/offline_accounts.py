"""Match discovered databases to live client file owners without reading memory."""
from collections import Counter
import ctypes
from ctypes import wintypes
import os
from pathlib import Path


def same_account_source(left, right, client='wechat'):
    """Compare a selected account folder with its actual database-folder alias.

    Names and account IDs are not identity evidence. Only paths resolving to
    the same database directory match; different accounts remain distinct.
    """
    if not left or not right:
        return False
    def database_root(value):
        path = Path(value).expanduser().resolve()
        child = path / ('Data' if client == 'wecom' else 'db_storage')
        return child.resolve() if child.is_dir() else path
    try:
        return database_root(left) == database_root(right)
    except (OSError, ValueError, RuntimeError):
        return False


def _windows_owners(paths, client):
    if os.name != 'nt':
        raise OSError('process_metadata_unavailable')
    from acquire_database_keys import WindowsDependencies, declare_windows_apis
    kernel = declare_windows_apis()
    allowed = {'wxwork.exe'} if client == 'wecom' else {'weixin.exe', 'wechat.exe'}
    found = []
    for pid, expected_start in WindowsDependencies._file_owners(paths):
        handle = kernel.OpenProcess(0x1000, False, pid)  # Query metadata only.
        if not handle:
            raise OSError('process_metadata_unavailable')
        try:
            created, ended, used, user = (wintypes.FILETIME() for _ in range(4))
            size = wintypes.DWORD(32768)
            name = ctypes.create_unicode_buffer(size.value)
            if not kernel.QueryFullProcessImageNameW(handle, 0, name, ctypes.byref(size)):
                raise OSError('process_metadata_unavailable')
            if Path(name.value).name.lower() not in allowed:
                continue
            if not kernel.GetProcessTimes(handle, ctypes.byref(created), ctypes.byref(ended), ctypes.byref(used), ctypes.byref(user)):
                raise OSError('process_metadata_unavailable')
            actual = (created.dwHighDateTime << 32) | created.dwLowDateTime
            if actual != expected_start or ended.dwHighDateTime or ended.dwLowDateTime:
                raise OSError('process_changed')
            found.append((int(pid), actual))
        finally:
            kernel.CloseHandle(handle)
    return sorted(set(found))


def identify_accounts(discovery, client='wechat', *, ownership=None):
    """Return current file-owner evidence and a unique running-account suggestion.

    Discovery remains directory metadata. A suggestion needs one verified live
    owner and never authenticates an account or retrieves a decryption key.
    """
    lookup = ownership or _windows_owners
    rows, seen = [], set()
    for account in discovery.get('accounts', []):
        row = {**account, 'processState': 'unavailable', 'processIds': [], 'processIdentities': [], 'processIssue': 'no_database_files'}
        try:
            original = Path(account['sourceRoot'])
            if original.is_symlink():
                raise OSError('redirected_source')
            source = original.resolve()
            child = source / ('Data' if client == 'wecom' else 'db_storage')
            root = child if child.is_dir() else source
            if root.is_symlink():
                raise OSError('redirected_source')
            if root in seen:
                continue
            seen.add(root)
            paths = []
            complete = True
            for database in account.get('databases', []):
                relative = Path(database['path'])
                path = root / relative
                if (relative.is_absolute() or '..' in relative.parts or path.is_symlink()
                        or not path.resolve().is_relative_to(root.resolve()) or path.suffix.lower() != '.db'):
                    complete = False
                    continue
                if path.is_file():
                    paths.append(path)
                    wal = Path(str(path) + '-wal')
                    if wal.exists():
                        if wal.is_file() and not wal.is_symlink() and wal.resolve().is_relative_to(root.resolve()):
                            paths.append(wal)
                        else:
                            complete = False
                else:
                    complete = False
                if len(paths) > 32:
                    complete = False
                    break
            if paths and len(rows) < 32:
                owners = sorted(set(lookup(paths[:32], client)))
                row['processIds'] = [int(pid) for pid, _created in owners]
                row['processIdentities'] = [{'pid': int(pid), 'created': int(created)} for pid, created in owners]
                if complete:
                    row['processState'] = 'active' if len(owners) == 1 else ('ambiguous' if owners else 'inactive')
                    row['processIssue'] = 'multiple_owners' if len(owners) > 1 else None
                else:
                    row['processIssue'] = 'probe_incomplete'
            elif len(rows) >= 32:
                row['processIssue'] = 'probe_limit'
        except (OSError, ValueError, KeyError):
            row['processIssue'] = 'metadata_unavailable'
        rows.append(row)
    rows.sort(key=lambda row: (row['processState'] != 'active', row.get('directoryLabel', '').casefold(), row['sourceRoot']))
    active = [row for row in rows if row['processState'] == 'active']
    incomplete = bool(discovery.get('issues')) or any(row['processState'] not in ('active', 'inactive') for row in rows)
    recommended = active[0]['sourceRoot'] if len(active) == 1 and not incomplete else None
    return {**discovery, 'accounts': rows, 'activeAccountCount': len(active),
            'scanIncomplete': incomplete, 'recommendedSourceRoot': recommended}


def group_choices(groups, query='', last_chat=None):
    """Search actual names/IDs, put the remembered group first, distinguish names."""
    needle = query.strip().casefold()
    duplicates = Counter(row['name'] for row in groups)
    choices = []
    for row in groups:
        if needle and needle not in (row['name'] + ' ' + row['id']).casefold():
            continue
        name = row['name'] + (' · ' + row['id'] if duplicates[row['name']] > 1 else '')
        choices.append({**row, 'choiceLabel': name, 'recent': row['id'] == last_chat})
    return sorted(choices, key=lambda row: (not row['recent'], row['name'].casefold(), row['id']))
