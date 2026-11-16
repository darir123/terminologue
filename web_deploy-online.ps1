#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Déploie automatiquement Terminologue + site web personnel en ligne
    
.DESCRIPTION
    Ce script PowerShell automatise le déploiement sur:
    - GitHub Pages (site web)
    - Fly.io (Terminologue)
    
    PRÉREQUIS:
    1. Compte GitHub (https://github.com/signup)
    2. Compte Fly.io (https://fly.io/app/sign-up)
    
    L'utilisateur doit se connecter manuellement aux deux services.
#>

param(
    [string]$GitHubUsername = "",
    [string]$GitHubRepo = "terminologue",
    [string]$FlyAppName = "terminologue"
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "Continue"

$AppDir = Split-Path -Parent $PSScriptRoot
$ToolsDir = Join-Path $AppDir "tools"

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "  Déploiement Terminologue en ligne" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================================
# ÉTAPE 1: Vérifier les outils
# ============================================================================
Write-Host "[1/6] Vérification des outils..." -ForegroundColor Yellow

$gh = Join-Path $ToolsDir "gh.exe"
$flyctl = Join-Path $ToolsDir "flyctl.exe"

if (-not (Test-Path $gh)) {
    Write-Host "Téléchargement de GitHub CLI..." -ForegroundColor Gray
    $ghUrl = "https://github.com/cli/cli/releases/download/v2.62.0/gh_2.62.0_windows_amd64.zip"
    $ghZip = Join-Path $env:TEMP "gh.zip"
    Invoke-WebRequest -Uri $ghUrl -OutFile $ghZip
    Expand-Archive -Path $ghZip -DestinationPath $env:TEMP -Force
    $ghBin = Get-ChildItem -Path $env:TEMP -Recurse -Filter "gh.exe" | Select-Object -First 1
    Copy-Item $ghBin.FullName $gh -Force
}

if (-not (Test-Path $flyctl)) {
    Write-Host "Téléchargement de Fly.io CLI..." -ForegroundColor Gray
    $flyUrl = "https://github.com/superfly/flyctl/releases/download/v0.3.39/flyctl_0.3.39_Windows_x86_64.exe"
    Invoke-WebRequest -Uri $flyUrl -OutFile $flyctl
}

Write-Host "  ✓ Outils prêts" -ForegroundColor Green
Write-Host ""

# ============================================================================
# ÉTAPE 2: Connexion GitHub
# ============================================================================
Write-Host "[2/6] Connexion à GitHub..." -ForegroundColor Yellow
Write-Host ""

$ghAuth = & $gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Vous devez vous connecter à GitHub." -ForegroundColor Red
    Write-Host "Exécution de: gh auth login" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Suivez les instructions à l'écran :" -ForegroundColor White
    Write-Host "  - Choisir 'HTTPS'" -ForegroundColor Gray
    Write-Host "  - Choisir 'Login with a web browser'" -ForegroundColor Gray
    Write-Host "  - Copier le code et ouvrir le navigateur" -ForegroundColor Gray
    Write-Host ""
    & $gh auth login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERREUR: Connexion GitHub échouée." -ForegroundColor Red
        exit 1
    }
}

Write-Host "  ✓ Connecté à GitHub" -ForegroundColor Green
Write-Host ""

# ============================================================================
# Étape 3: Créer le repo et pousser le code
# ============================================================================
Write-Host "[3/6] Création du repo GitHub..." -ForegroundColor Yellow

if (-not $GitHubUsername) {
    $GitHubUsername = (& $gh api user -q '.login' 2>$null)
    if (-not $GitHubUsername) {
        Write-Host "Impossible de détecter votre nom d'utilisateur GitHub." -ForegroundColor Red
        $GitHubUsername = Read-Host "Entrez votre nom d'utilisateur GitHub"
    }
}

Write-Host "  Utilisateur: $GitHubUsername" -ForegroundColor Gray
Write-Host "  Repo: $GitHubRepo" -ForegroundColor Gray

# Initialiser le repo
Set-Location $AppDir

# Vérifier si c'est déjà un repo git
if (-not (Test-Path .git)) {
    & git init
    & git branch -M main
}

# Configurer remote
$remoteUrl = "https://github.com/$GitHubUsername/$GitHubRepo.git"
$remotes = (& git remote -v 2>$null) | Out-String
if ($remotes -notmatch "origin") {
    & git remote add origin $remoteUrl
} else {
    & git remote set-url origin $remoteUrl
}

# Créer le repo sur GitHub (s'il n'existe pas)
$repoExists = & $gh repo view "$GitHubUsername/$GitHubRepo" --json name 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "  Création du repo '$GitHubRepo' sur GitHub..." -ForegroundColor Gray
    & $gh repo create "$GitHubRepo" --public --source=. --remote=origin --push
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Le repo existe déjà ou erreur. Tentative de push..." -ForegroundColor Yellow
    }
} else {
    Write-Host "  Repo déjà existant. Push..." -ForegroundColor Gray
}

# Commit et push
& git add .
& git commit -m "Deploy: add personal website + Terminologue online" --allow-empty 2>$null
& git push -u origin main

Write-Host "  ✓ Code poussé sur GitHub" -ForegroundColor Green
Write-Host ""

# ============================================================================
# Étape 4: Activer GitHub Pages
# ============================================================================
Write-Host "[4/6] Configuration de GitHub Pages..." -ForegroundColor Yellow

# Activer GitHub Pages via l'API (source = GitHub Actions)
Write-Host "  Activation de GitHub Pages..." -ForegroundColor Gray
$pagesPayload = '{"source":{"branch":"main","path":"/"}}'
& $gh api -X PUT "repos/$GitHubUsername/$GitHubRepo/pages" --input - <<< $pagesPayload 2>$null

Write-Host "  ✓ GitHub Pages activé" -ForegroundColor Green
Write-Host "  Le workflow se déploiera automatiquement sur le push." -ForegroundColor Gray
Write-Host "  URL: https://$GitHubUsername.github.io/$GitHubRepo" -ForegroundColor Cyan
Write-Host ""

# ============================================================================
# Étape 5: Connexion Fly.io
# ============================================================================
Write-Host "[5/6] Connexion à Fly.io..." -ForegroundColor Yellow

$flyAuth = & $flyctl auth whoami 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Vous devez vous connecter à Fly.io." -ForegroundColor Red
    Write-Host "Exécution de: flyctl auth login" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Suivez les instructions à l'écran :" -ForegroundColor White
    Write-Host "  - Ouvrir le lien dans le navigateur" -ForegroundColor Gray
    Write-Host "  - Se connecter à votre compte Fly.io" -ForegroundColor Gray
    Write-Host ""
    & $flyctl auth login
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERREUR: Connexion Fly.io échouée." -ForegroundColor Red
        exit 1
    }
}

Write-Host "  ✓ Connecté à Fly.io" -ForegroundColor Green
Write-Host ""

# ============================================================================
# Étape 6: Déployer sur Fly.io
# ============================================================================
Write-Host "[6/6] Déploiement de Terminologue sur Fly.io..." -ForegroundColor Yellow

Set-Location $AppDir

# Vérifier si l'app existe déjà
$appExists = & $flyctl apps list 2>$null | Select-String $FlyAppName
if (-not $appExists) {
    Write-Host "  Création de l'application '$FlyAppName'..." -ForegroundColor Gray
    # Lancer l'app
    & $flyctl launch --name $FlyAppName --no-deploy --region cdg
    
    # Créer le volume pour les données
    Write-Host "  Création du volume persistant..." -ForegroundColor Gray
    & $flyctl volumes create terminologue_data --size 1 --region cdg --yes
} else {
    Write-Host "  Application existante. Déploiement..." -ForegroundColor Gray
}

# Déployer
& $flyctl deploy --remote-only

Write-Host "  ✓ Déploiement Fly.io terminé" -ForegroundColor Green
Write-Host ""

# ============================================================================
# RÉSULTAT
# ============================================================================
Write-Host "===========================================" -ForegroundColor Green
Write-Host "  DÉPLOIEMENT TERMINÉ !" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Site web personnel:" -ForegroundColor Cyan
Write-Host "  https://$GitHubUsername.github.io/$GitHubRepo" -ForegroundColor White
Write-Host ""
Write-Host "Terminologue:" -ForegroundColor Cyan
Write-Host "  https://$FlyAppName.fly.dev" -ForegroundColor White
Write-Host ""
Write-Host "Identifiants Terminologue:" -ForegroundColor Cyan
Write-Host "  Email: h.darir@uca.ac.ma" -ForegroundColor White
Write-Host "  Password: admin" -ForegroundColor White
Write-Host ""
Write-Host "Note: GitHub Pages peut prendre 2-5 minutes" -ForegroundColor Yellow
Write-Host "      pour être actif la première fois." -ForegroundColor Yellow
Write-Host ""
Write-Host "Appuyez sur une touche pour fermer..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
