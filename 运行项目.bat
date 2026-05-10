@echo off
setlocal
cd /d "%~dp0"

set "SPRING_PROFILES_ACTIVE=local"

if not exist "tools\project-cli.js" (
  echo [ERROR] tools\project-cli.js was not found.
  pause
  exit /b 1
)

echo [INFO] Starting backend window...
start "project-backend" cmd /k "cd /d \"%~dp0\" && set SPRING_PROFILES_ACTIVE=local && node tools\project-cli.js backend:run"

if not exist "frontend\admin\node_modules" (
  echo [INFO] Starting admin window with dependency install...
  start "project-admin" cmd /k "cd /d \"%~dp0frontend\admin\" && npm install --legacy-peer-deps && npm run dev"
) else (
  echo [INFO] Starting admin window...
  start "project-admin" cmd /k "cd /d \"%~dp0frontend\admin\" && npm run dev"
)

if not exist "frontend\home\node_modules" (
  echo [INFO] Starting home window with dependency install...
  start "project-home" cmd /k "cd /d \"%~dp0frontend\home\" && npm install --legacy-peer-deps && npm run dev"
) else (
  echo [INFO] Starting home window...
  start "project-home" cmd /k "cd /d \"%~dp0frontend\home\" && npm run dev"
)

echo [INFO] Startup commands have been sent.
echo Backend profile: local
echo If this is your first run, run the database init batch once before using the system.
pause
