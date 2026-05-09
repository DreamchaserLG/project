@echo off
setlocal
cd /d "%~dp0"

set "MYSQL_HOST=127.0.0.1"
set "MYSQL_PORT=3306"
set "MYSQL_USER=root"
set "MYSQL_PASSWORD="
set "MYSQL_EXE="

for /f "delims=" %%I in ('where mysql.exe 2^>nul') do (
  set "MYSQL_EXE=%%I"
  goto :mysql_found
)

:mysql_found
if not defined MYSQL_EXE (
  set "MYSQL_EXE=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
)

if not exist "%MYSQL_EXE%" (
  echo [ERROR] mysql.exe was not found.
  echo Please install MySQL client or update MYSQL_EXE in this file.
  pause
  exit /b 1
)

if "%MYSQL_PASSWORD%"=="" (
  set /p MYSQL_PASSWORD=Please input MySQL password: 
)

echo [INFO] Importing project.sql...
"%MYSQL_EXE%" -h %MYSQL_HOST% -P %MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASSWORD% --default-character-set=utf8mb4 < "%~dp0project.sql"
if errorlevel 1 (
  echo [ERROR] Failed to import project.sql.
  echo Please verify the MySQL username and password in this file.
  pause
  exit /b 1
)

echo [INFO] Importing project_patch_local.sql...
"%MYSQL_EXE%" -h %MYSQL_HOST% -P %MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASSWORD% --default-character-set=utf8mb4 < "%~dp0project_patch_local.sql"
if errorlevel 1 (
  echo [ERROR] Failed to import project_patch_local.sql.
  echo Please verify the MySQL username and password in this file.
  pause
  exit /b 1
)

echo [INFO] Database import completed.
pause
