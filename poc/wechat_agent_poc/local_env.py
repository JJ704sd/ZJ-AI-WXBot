"""Read only the M3 key from the fixed project-local .env file."""
import os
from pathlib import Path


def load_minimax_env() -> None:
    if 'MINIMAX_API_KEY' in os.environ:
        return
    path = Path(__file__).resolve().parents[1] / '.env'
    if not path.is_file():
        return
    for line in path.read_text(encoding='utf-8-sig').splitlines():
        name, sep, value = line.strip().partition('=')
        if sep and name.strip() == 'MINIMAX_API_KEY':
            value = value.strip()
            if len(value) >= 2 and value[0] == value[-1] and value[0] in ('"', "'"):
                value = value[1:-1]
            if value:
                os.environ.setdefault('MINIMAX_API_KEY', value)
            return
