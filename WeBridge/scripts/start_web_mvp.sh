#!/bin/sh
set -eu
ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUNDLED_PYTHON="$HOME/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3"
if [ -n "${WECHAT_MVP_PYTHON:-}" ]; then
  MVP_PYTHON="$WECHAT_MVP_PYTHON"
elif [ -x "$BUNDLED_PYTHON" ]; then
  MVP_PYTHON="$BUNDLED_PYTHON"
else
  MVP_PYTHON=python3
fi
"$MVP_PYTHON" -c 'import websockets' || { echo '请先安装依赖：python3 -m pip install -r web_mvp/requirements.txt'; exit 1; }
"$MVP_PYTHON" "$ROOT_DIR/web_mvp/install_bridge.py"
exec "$MVP_PYTHON" "$ROOT_DIR/web_mvp/server.py" "$@"
