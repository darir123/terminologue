@echo off
setlocal

echo ============================================
echo   DEPLOY SITE WEB TO NETLIFY (Free)
echo ============================================
echo.

echo WHY NETLIFY?
echo   - Completely FREE for static sites
echo   - NO credit card required
echo   - NO sleep mode (always fast)
echo   - Custom domain: yourname.netlify.app
echo   - Auto-deploy from GitHub
echo.

echo ============================================
echo   STEP-BY-STEP GUIDE
echo ============================================
echo.
echo STEP 1: Create a Netlify account
echo   Go to: https://app.netlify.com/signup
echo   Sign up with GitHub (easiest)
echo.
echo STEP 2: Add new site
echo   Click "Add new site" --^> "Import an existing project"
echo   Connect your GitHub account
echo   Select repo: darir123/terminologue
echo.
echo STEP 3: Configure build settings
echo   Branch to deploy: master
echo   Base directory: (leave empty)
echo   Build command: (leave empty)
echo   Publish directory: docs
echo   Click "Deploy site"
echo.
echo STEP 4: Wait 1 minute
echo   Your site will be live at:
echo   https://terminologue-darir.netlify.app
echo   (or similar URL)
echo.
echo ============================================
echo   ADVANTAGES OVER GITHUB PAGES
echo ============================================
echo   - Faster loading
echo   - Better SEO
echo   - Form handling
echo   - Redirects/rewrites
echo   - Password protection
echo   - No Jekyll processing issues
echo.

echo Would you like to open Netlify signup now? (y/n)
set /p OPEN=Choice: 
if /i "%OPEN%"=="y" (
    start https://app.netlify.com/signup
    echo.
    echo Browser opened. After signup, follow steps above.
)

echo.
pause
