#!/usr/bin/env python3
"""Install the bridge without restarting or logging out the test client."""
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[1]
CONTAINER='wechat-lab-linux'
DEST='/opt/wechat-lab-mvp'


def docker(*args):
    return subprocess.run(['docker',*args],check=True,text=True,capture_output=True).stdout


def main():
    source=ROOT/'execution/linux/native_completion.c'
    digest=hashlib.sha256(source.read_bytes()).hexdigest()[:16]
    library=f'libcompletion-{digest}.so'
    docker('exec',CONTAINER,'mkdir','-p',DEST)
    paths=[ROOT/'web_mvp'/name for name in ('container_bridge.py','rich_content.py','media_container.py','video_download.py')]+[ROOT/'execution/linux'/name for name in (
        'db_probe.py','wal_snapshot_probe.py','native_object_roundtrip.py','native_send_once.py','native_send_once.js')]
    for path in paths:docker('cp',str(path),f'{CONTAINER}:{DEST}/{path.name}')
    docker('cp',str(source),f'{CONTAINER}:{DEST}/native_completion.c')
    # Content-addressed library is never overwritten while the client maps it.
    exists=subprocess.run(['docker','exec',CONTAINER,'test','-f',DEST+'/'+library]).returncode==0
    if not exists:
        docker('exec',CONTAINER,'cc','-std=c11','-O2','-fPIC','-shared','-pthread','-Wall','-Wextra','-Werror',
            '-o',DEST+'/'+library,DEST+'/native_completion.c')
    sha=docker('exec',CONTAINER,'sha256sum',DEST+'/'+library).split()[0]
    with tempfile.TemporaryDirectory(prefix='wechat-mvp-install-') as directory:
        path=Path(directory)/'bridge-manifest.json'
        path.write_text(json.dumps({'library':library,'librarySha256':sha,'sourceSha256':hashlib.sha256(source.read_bytes()).hexdigest()}))
        docker('cp',str(path),f'{CONTAINER}:{DEST}/bridge-manifest.json')
    print(json.dumps({'installed':True,'library':library,'clientRestarted':False}))


if __name__=='__main__':main()
