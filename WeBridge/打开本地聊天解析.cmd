@echo off
setlocal
cd /d "%~dp0"
if exist "%~dp0build\local-chat-desktop-v11\local-chat-desktop.exe" (
  start "" "%~dp0build\local-chat-desktop-v11\local-chat-desktop.exe"
  exit /b
)
if exist "%~dp0build\local-chat-desktop-v10\local-chat-desktop.exe" (
  start "" "%~dp0build\local-chat-desktop-v10\local-chat-desktop.exe"
  exit /b
)
if exist "%~dp0build\local-chat-desktop-v9\local-chat-desktop.exe" (
  start "" "%~dp0build\local-chat-desktop-v9\local-chat-desktop.exe"
  exit /b
)
if exist "%~dp0build\local-chat-desktop-v8\local-chat-desktop.exe" (
  start "" "%~dp0build\local-chat-desktop-v8\local-chat-desktop.exe"
  exit /b
)
if exist "%~dp0build\local-chat-desktop-v7\local-chat-desktop.exe" (
  start "" "%~dp0build\local-chat-desktop-v7\local-chat-desktop.exe"
  exit /b
)
if exist "%~dp0build\local-chat-desktop-v6\local-chat-desktop.exe" (
  start "" "%~dp0build\local-chat-desktop-v6\local-chat-desktop.exe"
  exit /b
)
if exist "%~dp0build\local-chat-desktop-v5\local-chat-desktop.exe" (
  start "" "%~dp0build\local-chat-desktop-v5\local-chat-desktop.exe"
  exit /b
)
if exist "%~dp0build\local-chat-desktop-v4\local-chat-desktop.exe" (
  start "" "%~dp0build\local-chat-desktop-v4\local-chat-desktop.exe"
  exit /b
)
if exist "%~dp0build\local-chat-desktop-v3\local-chat-desktop.exe" (
  start "" "%~dp0build\local-chat-desktop-v3\local-chat-desktop.exe"
  exit /b
)
if exist "%~dp0build\local-chat-desktop\local-chat-desktop.exe" (
  start "" "%~dp0build\local-chat-desktop\local-chat-desktop.exe"
  exit /b
)
echo Please use the portable desktop package, or build it with scripts\build_local_chat.ps1 -Desktop.
pause
