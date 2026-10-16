"""Package only the portable runtime, skill instructions and redistribution licenses."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import zipfile

from local_chat_distribution import copy_public_guide, write_quick_start, complete_metadata, verified_desktop_inputs


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--desktop-package', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--shareable', action='store_true', help='Include public documentation and package checksums')
    args = parser.parse_args()
    project = Path(__file__).resolve().parents[1]
    source = project / 'skills/local-wechat-archive'
    desktop = args.desktop_package.resolve()
    output = args.output.resolve()
    archive = output.parent / (output.name + '.zip')
    if output.exists() or archive.exists():
        raise SystemExit('Choose a new package path.')
    binary = desktop / '本地聊天解析.exe'
    if not binary.is_file():
        binary = desktop / 'local-chat-desktop.exe'
    if not binary.is_file() or not (desktop / 'licenses').is_dir():
        raise SystemExit('A complete desktop distribution is required.')
    licenses = verified_desktop_inputs(desktop, binary)
    # Metadata is promoted for WorkBuddy, whose import schema requires these fields.
    skill = (source / 'SKILL.md').read_text(encoding='utf-8')
    header, body = skill.split('\n---\n', 1)
    lines = header.splitlines()[1:]
    top, vendor = [], []
    for line in lines:
        if line == 'metadata:':
            continue
        if line.startswith('  '):
            vendor.append(line[2:])
        else:
            top.append(line)
    version = json.loads(next(line.split(':', 1)[1].strip() for line in vendor if line.startswith('version:')))
    output.mkdir(parents=True)
    (output / 'SKILL.md').write_text('---\n' + '\n'.join(top + vendor) + '\n---\n' + body, encoding='utf-8')
    for relative in ('scripts/run.ps1', 'Start.cmd', 'references/input-and-errors.md', 'agents/openai.yaml'):
        target = output / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source / relative, target)
    (output / 'bin').mkdir()
    binary_relative = 'bin/local-chat-desktop-' + version + '.exe'
    shutil.copyfile(binary, output / binary_relative)
    for relative, path in licenses:
        target = output / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(path, target)
    runtime = {'version': version, 'platform': 'Windows 10/11 x64',
               'exeRelativePath': binary_relative,
               'exeSha256': hashlib.sha256(binary.read_bytes()).hexdigest(),
               'requiresPythonInstallation': False, 'containsKeys': False, 'containsChatData': False}
    (output / 'runtime.json').write_text(json.dumps(runtime, indent=2), encoding='utf-8')
    copy_public_guide(project, output, 'skill')
    write_quick_start(output, 'skill')
    complete_metadata(output, {'platform': 'Windows 10/11 x64', 'interface': 'skill', 'version': version})
    with zipfile.ZipFile(archive, 'x', zipfile.ZIP_DEFLATED) as bundle:
        for path in sorted(output.rglob('*')):
            if path.is_file():
                bundle.write(path, path.relative_to(output).as_posix())
    print(json.dumps({'directory': str(output), 'archive': str(archive), 'bytes': archive.stat().st_size,
                      'sha256': hashlib.sha256(archive.read_bytes()).hexdigest(), **runtime}))


if __name__ == '__main__':
    main()
