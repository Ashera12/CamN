@echo off
echo [*] CamPhish Launcher
echo [*] Using MSYS2 Bash...

cd /d "%~dp0"
"C:\msys64\usr\bin\bash.exe" -c "bash camphish_auto.sh"

pause