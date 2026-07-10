@echo off
setlocal

echo ============================================
echo   STOP TERMINOLOGUE VM
echo ============================================
echo.

cd /d "%~dp0"

echo Stopping VM...
vagrant halt

echo.
echo VM stopped.
echo To start again, run: start-vm.bat
echo.

pause
