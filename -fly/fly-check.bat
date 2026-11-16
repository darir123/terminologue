@echo off
setlocal

echo ============================================
echo   FIX: Fly.io Account Check
echo ============================================
echo.

set APP_DIR=%~dp0
set TOOLS=%APP_DIR%tools
set FLY=%TOOLS%\flyctl.exe

cd /d "%APP_DIR%"

if not exist "%FLY%" (
    echo ERROR: flyctl not found
    pause
    exit /b 1
)

echo Current Fly.io user:
"%FLY%" auth whoami
echo.

echo.
echo ============================================
echo   IMPORTANT: Account Verification Required
echo ============================================
echo.
echo The error "Not authorized to access this organization"
echo means your Fly.io account needs to be fully set up.
echo.
echo STEP 1: Visit https://fly.io/dashboard
echo STEP 2: Complete your profile and add a payment method
echo        (Even the free tier requires a card on file)
echo STEP 3: Return here and run this script again
echo.
echo Would you like to open the dashboard now? (y/n)
set /p OPEN=Choice: 
if /i "%OPEN%"=="y" (
    start https://fly.io/dashboard
    echo.
    echo Browser opened. After setup, close this and run again.
) else (
    echo.
    echo Please visit https://fly.io/dashboard manually,
    echo then run this script again.
)

echo.
pause
