#!/usr/bin/env pwsh
# CamPhish Launcher - PowerShell version
# Usage: pwsh -File run-camphish.ps1
# Or:    .\run-camphish.ps1

$ErrorActionPreference = "Continue"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$camphishScript = Join-Path $scriptPath "camphish_auto.sh"

Write-Host "`n[*] CamPhish Launcher" -ForegroundColor Cyan
Write-Host "[*] Script path: $camphishScript`n" -ForegroundColor Gray

# Try to find Git Bash first (Windows native)
$gitBashPaths = @(
    "C:\Program Files\Git\bin\bash.exe",
    "C:\Program Files (x86)\Git\bin\bash.exe",
    "C:\tools\git\bin\bash.exe"
)

$bashFound = $null
foreach ($path in $gitBashPaths) {
    if (Test-Path $path) {
        $bashFound = $path
        Write-Host "[+] Found Git Bash: $bashFound" -ForegroundColor Green
        break
    }
}

# Fallback to system bash if Git Bash not found
if ($null -eq $bashFound) {
    Write-Host "[!] Git Bash not found in standard paths" -ForegroundColor Yellow
    $bashCmd = (Get-Command bash -ErrorAction SilentlyContinue).Source
    if ($bashCmd) {
        $bashFound = $bashCmd
        Write-Host "[*] Using system bash: $bashFound" -ForegroundColor Yellow
    }
}

if ($null -eq $bashFound) {
    Write-Host "[!] ERROR: bash not found anywhere!" -ForegroundColor Red
    Write-Host "[!] Please install Git Bash from: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

# Prepare environment to avoid WSL issues
$env:NO_WSL = "1"
$env:FORCE_WINDOWS = "1"

# Run camphish with the found bash
Write-Host "[+] Starting CamPhish with: $bashFound`n" -ForegroundColor Green

& $bashFound -c "cd '$scriptPath' && bash camphish_auto.sh"

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[!] Script exited with error code: $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}
