"""Build an isolated, pinned pyweixin source copy. Does not install or import it."""
import argparse
import hashlib
import json
import shutil
from pathlib import Path

OLD = '''            if is_group and groupMembers:
                for text in texts:
                    for groupMember in groupMembers:
                        search_result=re.search(rf'^({groupMember})\\s',text)
                        if search_result is not None:
                            sender=search_result.group(1)
                    content=re.sub(rf'^{sender}\\s','',text)
                    senders.append(sender)
                    contents.append(content)
'''
NEW = '''            if is_group and groupMembers:
                for text in texts:
                    # Local patch: a display-name match is not a stable identity.
                    # Preserve unknown/ambiguous input instead of guessing a sender.
                    matches = [member for member in groupMembers
                               if member and re.search(rf'^{re.escape(member)}\\s', text)]
                    sender = matches[0] if len(matches) == 1 else None
                    content = re.sub(rf'^{re.escape(sender)}\\s', '', text) if sender else text
                    senders.append(sender)
                    contents.append(content)
'''


def prepare(source, destination, expected_upstream_sha256):
    if not expected_upstream_sha256:
        raise ValueError('expected_upstream_digest_required')
    source, destination = Path(source).resolve(), Path(destination).resolve()
    if source == destination or source in destination.parents or destination in source.parents:
        raise ValueError('source and destination must be separate sibling trees')
    if destination.exists():
        raise ValueError('destination already exists; refusing overwrite')
    target = source / 'src/pyweixin/WeChatAuto.py'
    original = target.read_bytes()
    if hashlib.sha256(original).hexdigest() != expected_upstream_sha256:
        raise ValueError('source digest mismatch; review the new source before patching')
    text = original.decode('utf-8-sig').replace('\r\n', '\n')
    if text.count(OLD) != 1:
        raise ValueError('parser patch context mismatch')
    text = text.replace(OLD, NEW, 1)
    # Restrict this change to the audited send_messages_to_friend implementation.
    start = text.index('    def send_messages_to_friend(')
    end = text.index('    def reply_with_quote(', start)
    segment = text[start:end]
    if segment.count('if 0<len(message)<2000:') != 1:
        raise ValueError('send patch context mismatch')
    text = text[:start] + segment.replace('if 0<len(message)<2000:', 'if 0<len(message)<=2000:', 1) + text[end:]
    compile(text, str(target), 'exec')
    shutil.copytree(source, destination, ignore=shutil.ignore_patterns('.git', '__pycache__'))
    output = destination / 'src/pyweixin/WeChatAuto.py'
    output.write_text(text, encoding='utf-8', newline='\n')
    manifest = {'upstream_commit': 'ebe8d4be9347816d221c38843e5b9e5e480bd8fb',
                'original_sha256': expected_upstream_sha256,
                'patched_sha256': hashlib.sha256(output.read_bytes()).hexdigest(),
                'modified': ['src/pyweixin/WeChatAuto.py'],
                'installed': False, 'live_read_verified': False, 'send_enabled': False,
                'license_note': 'Upstream LICENSE retained; LGPL metadata discrepancy unresolved.'}
    (destination / 'LOCAL-PATCH.json').write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8')
    return manifest


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', required=True)
    parser.add_argument('--destination', required=True)
    parser.add_argument('--expected-upstream-sha256', required=True,
                        help='local digest supplied out of band; never commit it with evidence')
    args = parser.parse_args()
    print(json.dumps(prepare(args.source, args.destination,
                             args.expected_upstream_sha256)))
