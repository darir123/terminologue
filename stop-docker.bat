@echo off
setlocal

echo ============================================
echo   STOP DOCKER TERMINOLOGUE
echo ============================================
echo.

cd /d "%~dp0"

REM Detect docker compose command
docker compose version >nul 2>&1
if errorlevel 1 (
    docker-compose version >nul 2>&1
    if errorlevel 1 (
        echo Docker Compose not found.
        pause
        exit /b 1
    )
    set COMPOSE_CMD=docker-compose
) else (
    set COMPOSE_CMD=docker compose
)

echo Stopping containers...
%COMPOSE_CMD% down

echo.
echo Containers stopped.
echo To start again, run: start-docker.bat
echo.

pause
