@echo off
REM CamPhish Launcher - CMD batch version
REM Usage: run-camphish.bat

setlocal enabledelayedexpansion

echo.
echo [*] CamPhish Launcher
echo [*] Detecting bash...
echo.

REM Try Git Bash paths
set GIT_BASH_PATHS=C:\Program Files\Git\bin\bash.exe C:\Program Files (x86)\Git\bin\bash.exe C:\tools\git\bin\bash.exe

set BASH_FOUND=

for %%B in (%GIT_BASH_PATHS%) do (
    if exist "%%B" (
        set BASH_FOUND=%%B
        echo [+] Found Git Bash: !BASH_FOUND!
        goto found_bash
    )
)

REM Fallback to system bash
for /f "delims=" %%A in ('where bash 2^>nul') do (
    set BASH_FOUND=%%A
    echo [*] Using system bash: !BASH_FOUND!
    goto found_bash
)

echo [!] ERROR: bash not found!
echo [!] Please install Git Bash from: https://git-scm.com/download/win
pause
exit /b 1

:found_bash
echo [+] Starting CamPhish...
echo.

REM Set environment to avoid WSL
set NO_WSL=1
set FORCE_WINDOWS=1

REM Run camphish
cd /d "%~dp0"
"%BASH_FOUND%" -c "bash camphish_auto.sh"

if errorlevel 1 (
    echo.
    echo [!] Script exited with error code: %errorlevel%
    pause
    exit /b %errorlevel%
)

pause
