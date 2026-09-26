#!/bin/sh
set -eu
ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PID_FILE="$ROOT_DIR/.runtime/web_mvp/server.pid"
if [ ! -f "$PID_FILE" ]; then
  echo '未找到正在运行的 MVP 服务。'
  exit 0
fi
MVP_PID=$(cat "$PID_FILE")
case "$MVP_PID" in ''|*[!0-9]*) echo 'PID 文件无效，未停止任何进程。'; exit 1;; esac
MVP_COMMAND=$(ps -p "$MVP_PID" -o command= || true)
case "$MVP_COMMAND" in
  *"$ROOT_DIR/web_mvp/server.py"*) kill -TERM "$MVP_PID"; echo '已停止网页后台；微信客户端仍在运行。';;
  *) echo 'PID 对应的不是本项目服务，未停止任何进程。'; exit 1;;
esac
