"""Small redacted lifecycle log for diagnosing portable Windows startup."""
from datetime import datetime, timedelta, timezone
import json
import os
from pathlib import Path
import tempfile
import traceback

_path=None


def begin(directory,client):
    global _path
    if _path is not None:return _path
    name='startup-'+datetime.now(timezone(timedelta(hours=8))).strftime('%Y%m%d-%H%M%S')+'-'+str(os.getpid())+'.jsonl'
    # Never create logs in a caller-supplied account/data directory before its
    # source binding has been validated. Keep diagnostics in a separate store.
    diagnostic_root=Path(os.environ.get('LOCALAPPDATA') or tempfile.gettempdir())/'LocalChatArchiveDiagnostics'/client
    for folder in (diagnostic_root,Path(tempfile.gettempdir())/'LocalChatArchive-logs'):
        try:
            folder.mkdir(parents=True,exist_ok=True);_path=folder/name
            with _path.open('x',encoding='utf8'):pass
            break
        except OSError:_path=None
    record('process_started',client=client,frozen=bool(getattr(__import__('sys'),'frozen',False)))
    return _path


def path():return _path


def record(event,**fields):
    if _path is None:return
    value={'time':datetime.now(timezone(timedelta(hours=8))).isoformat(timespec='seconds'),
           'pid':os.getpid(),'event':event,**fields}
    try:
        with _path.open('a',encoding='utf8') as stream:stream.write(json.dumps(value,ensure_ascii=False)+'\n')
    except OSError:pass


def error(event,kind,tb):
    # Never serialize exception messages, locals, command lines, proxy URLs or keys.
    frames=[{'file':Path(f.filename).name,'line':f.lineno,'function':f.name} for f in traceback.extract_tb(tb)]
    record(event,exceptionType=kind.__name__,frames=frames)
