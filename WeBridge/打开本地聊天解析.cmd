@echo off
setlocal
cd /d "%~dp0"
if exist "%~dp0build\local-chat-desktop-v21\local-chat-desktop.exe" (
  start "" "%~dp0build\local-chat-desktop-v21\local-chat-desktop.exe" --client wechat
  exit /b
)
echo Please build v21 with scripts\build_local_chat.ps1 -Desktop -OutputDirectory build/local-chat-desktop-v21
pause
