@echo off
setlocal

echo ============================================
echo   DEPLOY TERMINOLOGUE TO FLY.IO
echo ============================================
echo.

set APP_DIR=%~dp0
set TOOLS=%APP_DIR%tools
set FLY=%TOOLS%\flyctl.exe

cd /d "%APP_DIR%"

REM Download flyctl if not exists
if not exist "%FLY%" (
    echo [1/5] Downloading Fly.io CLI...
    if not exist "%TOOLS%" mkdir "%TOOLS%"
    powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/superfly/flyctl/releases/download/v0.4.69/flyctl_0.4.69_Windows_x86_64.zip' -OutFile '%TEMP%\fly_dl.zip'"
    powershell -Command "$ProgressPreference='SilentlyContinue'; Expand-Archive -Path '%TEMP%\fly_dl.zip' -DestinationPath '%TEMP%\fly_dl' -Force"
    for /f "delims=" %%a in ('dir /s /b "%TEMP%\fly_dl\flyctl.exe"') do copy "%%a" "%FLY%" >nul
    if not exist "%FLY%" (
        echo ERROR: Failed to download flyctl
        pause
        exit /b 1
    )
)
echo   OK
echo.

REM Check Fly.io login
echo [2/5] Checking Fly.io login...
"%FLY%" auth whoami >nul 2>&1
if errorlevel 1 (
    echo.
    echo ============================================
    echo   LOGIN TO FLY.IO REQUIRED
    echo ============================================
    echo   You need a Fly.io account.
    echo   Sign up at: https://fly.io/app/sign-up
    echo.
    echo   A browser will open for login.
    echo   Follow the instructions.
    echo ============================================
    echo.
    pause
    "%FLY%" auth login
    if errorlevel 1 (
        echo Login failed.
        pause
        exit /b 1
    )
)
echo   Logged in
echo.

REM Launch the app
echo [3/5] Launching app on Fly.io...
"%FLY%" launch --name terminologue --region cdg --no-deploy --yes 2>nul
if errorlevel 1 (
    echo   App may already exist, continuing...
)
echo   OK
echo.

REM Create volume for data persistence
echo [4/5] Creating persistent volume for data...
"%FLY%" volumes create terminologue_data --size 1 --region cdg --yes 2>nul
echo   OK
echo.

REM Deploy
echo [5/5] Deploying Terminologue...
"%FLY%" deploy --remote-only
echo.

echo ============================================
echo   DEPLOYMENT COMPLETE
echo ============================================
echo.
echo Your Terminologue is now live at:
echo   https://terminologue.fly.dev
echo.
echo Admin login:
echo   Email: h.darir@uca.ac.ma
echo   Password: admin
echo.
echo NOTE: First startup may take 1-2 minutes.
echo.

pause
