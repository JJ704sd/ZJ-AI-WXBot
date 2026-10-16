@echo off
setlocal
cd /d "%~dp0"
if exist "%~dp0build\local-chat\local-chat.exe" (
  "%~dp0build\local-chat\local-chat.exe" %*
  exit /b
)
where py.exe >nul 2>nul
if not errorlevel 1 (
  py.exe -3 "%~dp0scripts\local_chat.py" %*
  exit /b
)
python.exe "%~dp0scripts\local_chat.py" %*
