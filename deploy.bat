@echo off
setlocal

echo ============================================
echo   DEPLOY TERMINOLOGUE ONLINE
echo   User: hassane-darir
echo ============================================
echo.

set REPO=hassane-darir/terminologue
set APP_DIR=%~dp0
set TOOLS=%APP_DIR%tools
set GIT=%TOOLS%\mingit\cmd\git.exe
set GH=%TOOLS%\gh.exe

cd /d "%APP_DIR%"

REM Check portable git
if not exist "%GIT%" (
    echo Downloading portable Git...
    powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.51.0.windows.1/MinGit-2.51.0-64-bit.zip' -OutFile '%TEMP%\mingit.zip'"
    powershell -Command "$ProgressPreference='SilentlyContinue'; Expand-Archive -Path '%TEMP%\mingit.zip' -DestinationPath '%TOOLS%\mingit' -Force"
)

echo [1/5] Checking tools...
"%GIT%" --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git not available
    pause
    exit /b 1
)
echo   OK
echo.

echo [2/5] Checking GitHub CLI...
if not exist "%GH%" (
    echo   Downloading GitHub CLI...
    if not exist "%TOOLS%" mkdir "%TOOLS%"
    powershell -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://github.com/cli/cli/releases/download/v2.62.0/gh_2.62.0_windows_amd64.zip' -OutFile '%TEMP%\gh_dl.zip'"
    powershell -Command "$ProgressPreference='SilentlyContinue'; Expand-Archive -Path '%TEMP%\gh_dl.zip' -DestinationPath '%TEMP%\gh_dl' -Force"
    for /f "delims=" %%a in ('dir /s /b "%TEMP%\gh_dl\gh.exe"') do copy "%%a" "%GH%" >nul
)
echo   OK
echo.

echo [3/5] GitHub Login Check...
"%GH%" auth status >nul 2>&1
if errorlevel 1 (
    echo.
    echo ============================================
    echo   LOGIN TO GITHUB REQUIRED
    echo ============================================
    echo   A browser window will open.
    echo   Follow the instructions to login.
    echo   Choose: HTTPS + Login with web browser
    echo ============================================
    echo.
    pause
    "%GH%" auth login
    if errorlevel 1 (
        echo Login failed.
        pause
        exit /b 1
    )
)
echo   Logged in
echo.

echo [4/5] Creating repo and pushing code...
"%GIT%" remote remove origin 2>nul
"%GIT%" remote add origin https://github.com/%REPO%.git
"%GIT%" add .
"%GIT%" commit -m "Deploy Terminologue online" --allow-empty 2>nul

echo   Creating repo if not exists...
"%GH%" repo create %REPO% --public --source=. --remote=origin --push 2>nul
if errorlevel 1 (
    echo   Repo exists, pushing to existing...
    "%GIT%" push -u origin main 2>nul || "%GIT%" push -u origin master 2>nul
)
echo   Done
echo.

echo [5/5] Checking GitHub Pages...
"%GH%" api repos/%REPO%/pages 2>nul >nul
if errorlevel 1 (
    echo   Enabling GitHub Pages...
    echo   {"source":{"branch":"main","path":"/"}} > "%TEMP%\pages.json"
    "%GH%" api repos/%REPO%/pages -X PUT --input "%TEMP%\pages.json" 2>nul
)
echo   OK
echo.

echo ============================================
echo   DEPLOYMENT COMPLETE
echo ============================================
echo.
echo Your personal website will be live at:
echo   https://hassane-darir.github.io/terminologue
echo.
echo (It may take 2-5 minutes to appear)
echo.
echo ============================================
echo NEXT STEP: Deploy Terminologue on Fly.io
echo ============================================
echo 1. Create account: https://fly.io/app/sign-up
echo 2. Download flyctl: https://github.com/superfly/flyctl/releases
echo 3. Open terminal and run:
echo.
echo   flyctl auth login
echo   cd "%APP_DIR%"
echo   flyctl launch --name terminologue
echo   flyctl volumes create terminologue_data --size 1
echo   flyctl deploy
echo.
echo Your Terminologue will be at:
echo   https://terminologue.fly.dev
echo.

pause
