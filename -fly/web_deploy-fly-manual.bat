@echo off
setlocal

echo ============================================
echo   DEPLOY TERMINOLOGUE TO FLY.IO (Manual)
echo ============================================
echo.

set APP_DIR=%~dp0
set TOOLS=%APP_DIR%tools
set FLY=%TOOLS%\flyctl.exe
set APP_NAME=terminologue-darir

cd /d "%APP_DIR%"

if not exist "%FLY%" (
    echo ERROR: flyctl not found
    pause
    exit /b 1
)

echo [1/4] Checking Fly.io login...
"%FLY%" auth whoami
if errorlevel 1 (
    echo.
    echo Please login:
    "%FLY%" auth login
    if errorlevel 1 (
        echo Login failed
        pause
        exit /b 1
    )
)
echo   OK
echo.

echo [2/4] Destroying old app if exists...
"%FLY%" apps destroy %APP_NAME% --yes 2>nul
echo   Done
echo.

echo [3/4] Creating app manually...

REM Create app with basic command (no org query)
"%FLY%" apps create %APP_NAME% --machines
if errorlevel 1 (
    echo Retrying with org flag...
    "%FLY%" apps create %APP_NAME% --org personal --machines
)
if errorlevel 1 (
    echo Trying different approach...
    echo {"name":"%APP_NAME%","network":"default","organization":null} > "%TEMP%\app.json"
    "%FLY%" api apps -X POST --input "%TEMP%\app.json" 2>nul
)
if errorlevel 1 (
    echo ERROR: Could not create app. Your Fly.io account may not be fully activated.
    echo.
    echo Please visit https://fly.io/dashboard and verify your account is active.
    echo Then try again.
    pause
    exit /b 1
)
echo   App created
echo.

echo [4/4] Deploying...
REM Create fly.toml if not exists
if not exist fly.toml (
    echo app = "%APP_NAME%" > fly.toml
    echo primary_region = "cdg" >> fly.toml
    echo. >> fly.toml
    echo [build] >> fly.toml
    echo   dockerfile = "Dockerfile" >> fly.toml
    echo. >> fly.toml
    echo [env] >> fly.toml
    echo   PORT = "3000" >> fly.toml
    echo   NODE_ENV = "production" >> fly.toml
    echo. >> fly.toml
    echo [http_service] >> fly.toml
    echo   internal_port = 3000 >> fly.toml
    echo   force_https = true >> fly.toml
    echo   auto_stop_machines = false >> fly.toml
    echo   auto_start_machines = true >> fly.toml
    echo   min_machines_running = 1 >> fly.toml
    echo. >> fly.toml
    echo [[mounts]] >> fly.toml
    echo   source = "terminologue_data" >> fly.toml
    echo   destination = "/data" >> fly.toml
)

"%FLY%" deploy --app %APP_NAME% --build-only 2>nul
if errorlevel 1 (
    echo Trying direct deploy...
    "%FLY%" deploy --app %APP_NAME%
)
if errorlevel 1 (
    echo Trying with --local-only...
    "%FLY%" deploy --app %APP_NAME% --local-only
)

echo.
echo ============================================
echo   DEPLOYMENT ATTEMPTED
echo ============================================
echo.
echo If successful, your app is at:
echo   https://%APP_NAME%.fly.dev
echo.
echo If it failed, check:
echo   1. Your account is verified at https://fly.io/dashboard
echo   2. You have a payment method on file (even free tier)
echo   3. Try: flyctl status --app %APP_NAME%
echo.

pause
