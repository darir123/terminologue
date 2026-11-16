@echo off
chcp 65001 >nul
title Déploiement Terminologue en ligne
color 0B

echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                                                               ║
echo ║    DÉPLOIEMENT EN LIGNE - TERMINOLOGUE + SITE WEB            ║
echo ║                                                               ║
echo ║    Utilisateur: hassane-darir                                ║
echo ║                                                               ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.

set "APP_DIR=%~dp0"
cd /d "%APP_DIR%"

REM =========================================================================
REM ÉTAPE 1: Vérifier git
REM =========================================================================
echo [1/5] Vérification de git...
git --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERREUR: Git n'est pas installé.
    echo Téléchargez-le ici: https://git-scm.com/download/win
    pause
    exit /b 1
)
echo   OK
echo.

REM =========================================================================
REM ÉTAPE 2: Vérifier GitHub CLI
echo [2/5] Vérification de GitHub CLI...
if exist "%APP_DIR%tools\gh.exe" (
    set "GH=%APP_DIR%tools\gh.exe"
) else (
    echo Téléchargement de GitHub CLI...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/cli/cli/releases/download/v2.62.0/gh_2.62.0_windows_amd64.zip' -OutFile '%TEMP%\gh.zip'"
    powershell -Command "Expand-Archive -Path '%TEMP%\gh.zip' -DestinationPath '%TEMP%\gh' -Force"
    mkdir "%APP_DIR%tools" 2>nul
    for /f "delims=" %%i in ('dir /s /b "%TEMP%\gh\gh.exe"') do copy "%%i" "%APP_DIR%tools\gh.exe"
    set "GH=%APP_DIR%tools\gh.exe"
)
echo   OK
echo.

REM =========================================================================
REM ÉTAPE 3: Connexion GitHub
echo [3/5] Connexion à GitHub (hassane-darir)...
"%GH%" auth status >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo.
    echo ╔═══════════════════════════════════════════════════════════════╗
    echo ║  VOUS DEVEZ VOUS CONNECTER À GITHUB                         ║
    echo ║                                                             ║
    echo ║  Une fenêtre de navigateur va s'ouvrir.                   ║
    echo ║  Suivez les instructions pour vous connecter.               ║
    echo ╚═══════════════════════════════════════════════════════════════╝
    echo.
    pause
    "%GH%" auth login
    if %ERRORLEVEL% neq 0 (
        echo ERREUR: Connexion GitHub échouée.
        pause
        exit /b 1
    )
)
echo   Connecté
echo.

REM =========================================================================
REM ÉTAPE 4: Créer le repo et pousser le code
echo [4/5] Création du repo et push du code...

REM Configurer le remote
git remote remove origin 2>nul
git remote add origin https://github.com/hassane-darir/terminologue.git

REM Commit des changements
git add .
git commit -m "Deploy: Terminologue + personal website" --allow-empty 2>nul

REM Créer le repo sur GitHub (public)
"%GH%" repo create hassane-darir/terminologue --public --source=. --remote=origin --push 2>nul
if %ERRORLEVEL% neq 0 (
    echo   Le repo existe déjà, tentative de push...
    git push -u origin main 2>nul || git push -u origin master 2>nul
)

echo   Code poussé sur GitHub
echo.

REM =========================================================================
REM ÉTAPE 5: Activer GitHub Pages
echo [5/5] Activation de GitHub Pages...
echo   Le workflow GitHub Actions déploiera automatiquement le site.
echo   Cela peut prendre 2-5 minutes.
echo.

REM =========================================================================
REM RÉSULTAT
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                                                               ║
echo ║  SITE WEB PERSONNEL                                           ║
echo ║  https://hassane-darir.github.io/terminologue              ║
echo ║                                                               ║
echo ║  (Actif dans 2-5 minutes)                                     ║
echo ║                                                               ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.

REM =========================================================================
REM FLY.IO - Instructions
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║  POUR DÉPLOYER TERMINOLOGUE SUR FLY.IO (gratuit):           ║
echo ║                                                               ║
echo ║  1. Allez sur https://fly.io/app/sign-up et créez un compte ║
echo ║  2. Téléchargez flyctl:                                     ║
echo ║     https://github.com/superfly/flyctl/releases            ║
echo ║  3. Ouvrez un terminal et exécutez:                         ║
echo ║                                                               ║
echo ║     flyctl auth login                                       ║
echo ║     cd "%APP_DIR%"                                          ║
echo ║     flyctl launch --name terminologue                       ║
echo ║     flyctl volumes create terminologue_data --size 1       ║
echo ║     flyctl deploy                                           ║
echo ║                                                               ║
echo ║  4. Votre Terminologue sera à:                              ║
echo ║     https://terminologue.fly.dev                            ║
echo ║                                                               ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.

pause
