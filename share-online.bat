@echo off
setlocal

echo ============================================
echo   SHARE TERMINOLOGUE ONLINE (Temporary)
echo ============================================
echo.

set APP_DIR=%~dp0
set TOOLS=%APP_DIR%tools
set CF=%TOOLS%\cloudflared.exe

cd /d "%APP_DIR%"

REM Download cloudflared if not exists
if not exist "%CF%" (
    echo [1/2] Downloading Cloudflare Tunnel...
    if not exist "%TOOLS%" mkdir "%TOOLS%"
    powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe' -OutFile '%CF%'"
    if not exist "%CF%" (
        echo ERROR: Failed to download cloudflared
        pause
        exit /b 1
    )
)
echo   OK
echo.

echo [2/2] Starting tunnel to Terminologue...
echo.
echo ============================================
echo   Your Terminologue will be available at:
echo   a temporary public URL (shown below)
echo ============================================
echo.
echo Press Ctrl+C to stop the tunnel
echo.

"%CF%" tunnel --url http://localhost:3000

echo.
echo Tunnel closed.
pause
