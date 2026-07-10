@echo off
echo ============================================
echo  Terminologue TMS (Portable)
echo ============================================
echo.

REM Get the directory where this batch file is located
set "APP_DIR=%~dp0"
set "NODE_DIR=%APP_DIR%node"
set "WEBSITE_DIR=%APP_DIR%website"

REM Verify bundled Node.js exists
if not exist "%NODE_DIR%\node.exe" (
    echo ERROR: Bundled Node.js not found at %NODE_DIR%\node.exe
    echo Please make sure the 'node' folder is present.
    pause
    exit /b 1
)

echo Using bundled Node.js: %NODE_DIR%\node.exe
echo Website folder: %WEBSITE_DIR%
echo.
cd /d "%WEBSITE_DIR%"
echo Starting server on http://localhost:3000/
echo.
echo Press Ctrl+C to stop the server.
echo ============================================
echo.
"%NODE_DIR%\node.exe" terminologue.js
