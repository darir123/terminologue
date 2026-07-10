@echo off
setlocal

echo ============================================
echo   DEPLOY TERMINOLOGUE TO RENDER.COM
echo ============================================
echo.

echo IMPORTANT NOTES:
echo - Render.com is free and NO credit card required
echo - Your app will sleep after 15 min of inactivity
echo - It wakes up automatically on next request
echo - SQLite data will NOT persist between restarts
echo   (Use local Terminologue for permanent data)
echo.

echo ============================================
echo   STEP-BY-STEP GUIDE
echo ============================================
echo.
echo STEP 1: Create a Render.com account
echo   Go to: https://dashboard.render.com/register
echo   Sign up with GitHub (recommended)
echo.
echo STEP 2: Connect your GitHub repo
echo   In Render dashboard, click "New +"
echo   Choose "Web Service"
echo   Connect your GitHub account
echo   Select repo: darir123/terminologue
echo.
echo STEP 3: Configure the service
echo   Name: terminologue
echo   Runtime: Docker
echo   Branch: master
echo   Root Directory: (leave empty)
echo   Dockerfile Path: ./Dockerfile
echo   Plan: Free
echo.
echo STEP 4: Deploy
echo   Click "Create Web Service"
echo   Wait for deployment (2-3 minutes)
echo.
echo ============================================
echo   RESULT
echo ============================================
echo.
echo Your Terminologue will be at:
echo   https://terminologue.onrender.com
echo   (or similar URL assigned by Render)
echo.
echo.

echo Would you like to open the Render dashboard now? (y/n)
set /p OPEN=Choice: 
if /i "%OPEN%"=="y" (
    start https://dashboard.render.com/register
    echo.
    echo Browser opened. After signup, follow steps above.
)

echo.
pause
