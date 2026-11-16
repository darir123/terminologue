@echo off
setlocal

echo ============================================
echo   DOCKER TERMINOLOGUE LAUNCHER
echo ============================================
echo.

set APP_DIR=%~dp0
cd /d "%APP_DIR%"

REM Check Docker
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is NOT installed.
    echo.
    echo Please install Docker Desktop:
    echo   https://www.docker.com/products/docker-desktop/
    echo.
    echo Download and install Docker Desktop for Windows.
    echo After installation, restart your computer.
    echo.
    start https://www.docker.com/products/docker-desktop/
    pause
    exit /b 1
)
echo [OK] Docker found
echo.

REM Check docker-compose
REM Try 'docker compose' (v2) first, then 'docker-compose' (v1)
docker compose version >nul 2>&1
if errorlevel 1 (
    docker-compose version >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] docker-compose not found.
        echo Please install Docker Desktop (includes compose).
        pause
        exit /b 1
    )
    set COMPOSE_CMD=docker-compose
) else (
    set COMPOSE_CMD=docker compose
)
echo [OK] Docker Compose found
echo.

echo ============================================
echo   BUILDING AND STARTING CONTAINERS
echo   This will take 5-10 minutes the first time
echo ============================================
echo.

%COMPOSE_CMD% up --build -d

if errorlevel 1 (
    echo.
    echo [ERROR] Docker compose failed.
    echo Try: docker compose down
    echo Then run this script again.
    pause
    exit /b 1
)

echo.
echo ============================================
echo   CONTAINERS ARE RUNNING!
echo ============================================
echo.
echo Opening services in browser...
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
echo   DOCKER COMMANDS
echo ============================================
echo.
echo View logs:     docker compose logs -f
echo Stop:          docker compose down
echo Restart:       docker compose restart
echo Rebuild:       docker compose up --build -d
echo.

pause
