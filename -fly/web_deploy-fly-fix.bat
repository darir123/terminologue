@echo off
setlocal

echo ============================================
echo   FIX FLY.IO DEPLOYMENT
echo ============================================
echo.

set APP_DIR=%~dp0
set TOOLS=%APP_DIR%tools
set FLY=%TOOLS%\flyctl.exe

cd /d "%APP_DIR%"

REM Check flyctl
if not exist "%FLY%" (
    echo ERROR: flyctl not found
    pause
    exit /b 1
)

echo [1/3] Checking Fly.io authentication...
"%FLY%" auth whoami >nul 2>&1
if errorlevel 1 (
    echo.
    echo You need to login to Fly.io.
    echo.
    pause
    "%FLY%" auth login
    if errorlevel 1 (
        echo Login failed.
        pause
        exit /b 1
    )
)
echo   Authenticated
echo.

echo [2/3] Destroying old app (if exists)...
"%FLY%" apps destroy terminologue-evergreen-forest-1800 --yes 2>nul
echo   Cleaned up
echo.

echo [3/3] Creating new app and deploying...

REM Remove old fly.toml to create fresh app
del fly.toml 2>nul

REM Launch with new name
"%FLY%" launch --name terminologue-darir --region cdg --no-deploy --yes
if errorlevel 1 (
    echo ERROR: Failed to create app
    pause
    exit /b 1
)

REM Update fly.toml to keep machine running
powershell -Command "(Get-Content fly.toml) -replace 'auto_stop_machines = true', 'auto_stop_machines = false' | Set-Content fly.toml"

REM Create volume
"%FLY%" volumes create terminologue_data --size 1 --region cdg --yes --app terminologue-darir

REM Deploy
"%FLY%" deploy --app terminologue-darir

echo.
echo ============================================
echo   DEPLOYMENT COMPLETE
echo ============================================
echo.
echo Your Terminologue is now live at:
echo   https://terminologue-darir.fly.dev
echo.
echo Admin login:
echo   Email: h.darir@uca.ac.ma
echo   Password: admin
echo.

pause
