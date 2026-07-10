@echo off
setlocal

echo ============================================
echo   TERMINOLOGUE VM LAUNCHER
echo ============================================
echo.

set VM_DIR=%~dp0
set VAGRANT_URL=https://developer.hashicorp.com/vagrant/downloads
set VBOX_URL=https://www.virtualbox.org/wiki/Downloads

cd /d "%VM_DIR%"

REM Check VirtualBox
where VBoxManage >nul 2>&1
if errorlevel 1 (
    echo [ERROR] VirtualBox is NOT installed.
    echo.
    echo Please install VirtualBox:
    echo   %VBOX_URL%
    echo.
    echo Download: VirtualBox 7.0 for Windows
echo.
    start %VBOX_URL%
    pause
    exit /b 1
)
echo [OK] VirtualBox found
echo.

REM Check Vagrant
where vagrant >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Vagrant is NOT installed.
    echo.
    echo Please install Vagrant:
    echo   %VAGRANT_URL%
    echo.
    echo Download: Windows AMD64
echo.
    start %VAGRANT_URL%
    pause
    exit /b 1
)
echo [OK] Vagrant found
echo.

REM Check Vagrantfile exists
if not exist "%VM_DIR%Vagrantfile" (
    echo [ERROR] Vagrantfile not found in:
    echo   %VM_DIR%
    echo.
    pause
    exit /b 1
)
echo [OK] Vagrantfile found
echo.

REM Start VM
echo ============================================
echo   STARTING VIRTUAL MACHINE
echo   This will take 5-10 minutes the first time
echo ============================================
echo.
echo Downloading Ubuntu 22.04 (approx 500 MB)...
echo Installing Node.js, dependencies, and services...
echo.

vagrant up

if errorlevel 1 (
    echo.
    echo [ERROR] Failed to start VM.
    echo Try: vagrant destroy -f
    echo Then run this script again.
    pause
    exit /b 1
)

echo.
echo ============================================
echo   VM IS RUNNING!
echo ============================================
echo.
echo Opening services in browser...
echo.

start http://localhost:3000/
timeout /t 2 >nul
start http://localhost:8080/

echo.
echo ============================================
echo   SERVICES
echo ============================================
echo.
echo Terminologue TMS:  http://localhost:3000/
echo Personal Website:  http://localhost:8080/
echo.
echo Admin Login:
echo   Email:    h.darir@uca.ac.ma
echo   Password: admin
echo.
echo ============================================
echo   VM COMMANDS
echo ============================================
echo.
echo Stop VM:    vagrant halt
echo Start VM:   vagrant up
echo Restart:    vagrant reload
echo Destroy:    vagrant destroy -f
echo SSH into:   vagrant ssh
echo.

pause
