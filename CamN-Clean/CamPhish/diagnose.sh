#!/bin/bash
# CamPhish Diagnostic Tool - Debug ngrok and network issues

printf "\e[1;92m╔════════════════════════════════════════════════════════════╗\e[0m\n"
printf "\e[1;92m║\e[0m\e[1;77m            CAMPHISH DIAGNOSTIC TOOL                       \e[0m\e[1;92m║\e[0m\n"
printf "\e[1;92m╚════════════════════════════════════════════════════════════╝\e[0m\n"
printf "\n"

# Platform detection
PLATFORM="$(uname -s 2>/dev/null || echo Unknown)"
IS_WINDOWS=false
IS_WSL=false

case "$PLATFORM" in
	MINGW*|MSYS*|CYGWIN*) IS_WINDOWS=true ;;
	Linux*) 
		if grep -qi microsoft /proc/version 2>/dev/null || grep -qi wsl /proc/version 2>/dev/null; then
			IS_WSL=true
		fi
		;;
esac

printf "\e[1;92m[*] Platform Detection\e[0m\n"
printf "  Platform: $PLATFORM\n"
printf "  Is Windows: $IS_WINDOWS\n"
printf "  Is WSL: $IS_WSL\n"
printf "\n"

# Check dependencies
printf "\e[1;92m[*] Checking Dependencies\e[0m\n"
for cmd in php curl wget ssh unzip git; do
	if command -v $cmd > /dev/null 2>&1; then
		printf "\e[1;92m[✓]\e[0m $cmd\n"
	else
		printf "\e[1;31m[✗]\e[0m $cmd (missing)\n"
	fi
done
printf "\n"

# Check ngrok
printf "\e[1;92m[*] Checking ngrok\e[0m\n"
if [[ -x ./ngrok ]]; then
	printf "\e[1;92m[✓]\e[0m ./ngrok exists and is executable\n"
	if ./ngrok version 2>&1 | head -1; then
		printf "\e[1;92m[✓]\e[0m ngrok version check passed\n"
	else
		printf "\e[1;31m[✗]\e[0m ngrok version check failed\n"
	fi
elif [[ -x ./ngrok.exe ]]; then
	printf "\e[1;92m[✓]\e[0m ./ngrok.exe exists and is executable\n"
	if ./ngrok.exe version 2>&1 | head -1; then
		printf "\e[1;92m[✓]\e[0m ngrok.exe version check passed\n"
	else
		printf "\e[1;31m[✗]\e[0m ngrok.exe version check failed\n"
	fi
else
	printf "\e[1;31m[✗]\e[0m ngrok binary not found\n"
fi
printf "\n"

# Check ngrok config
printf "\e[1;92m[*] Checking ngrok Configuration\e[0m\n"
if [[ -f ~/.ngrok2/ngrok.yml ]]; then
	printf "\e[1;92m[✓]\e[0m ~/.ngrok2/ngrok.yml exists\n"
else
	printf "\e[1;93m[!]\e[0m ~/.ngrok2/ngrok.yml not found (will prompt on first run)\n"
fi
printf "\n"

# Test PHP server
printf "\e[1;92m[*] Testing PHP Server\e[0m\n"
printf "\e[1;92m[+] Starting PHP on 127.0.0.1:3333...\e[0m\n"
php -S 127.0.0.1:3333 > php_test.log 2>&1 &
php_pid=$!
sleep 2

if kill -0 $php_pid 2>/dev/null; then
	printf "\e[1;92m[✓]\e[0m PHP server started (PID: $php_pid)\n"
	
	# Test connection
	sleep 1
	if curl -s --max-time 2 http://127.0.0.1:3333/ > /dev/null 2>&1; then
		printf "\e[1;92m[✓]\e[0m PHP server is reachable on 127.0.0.1:3333\n"
	else
		printf "\e[1;93m[!]\e[0m PHP server not responding to curl\n"
	fi
	
	kill $php_pid 2>/dev/null || true
	sleep 1
else
	printf "\e[1;31m[✗]\e[0m PHP server failed to start\n"
	cat php_test.log
fi
rm -f php_test.log
printf "\n"

# Test network connectivity
printf "\e[1;92m[*] Testing Network Connectivity\e[0m\n"
if curl -s --connect-timeout 3 --max-time 5 https://api.ipify.org?format=json 2>/dev/null | grep -q "ip"; then
	printf "\e[1;92m[✓]\e[0m Internet connection: OK\n"
else
	printf "\e[1;31m[✗]\e[0m Internet connection: FAILED (cannot reach api.ipify.org)\n"
fi
printf "\n"

# Test ngrok startup (optional - skip for now)
printf "\e[1;92m[*] Test Results Summary\e[0m\n"
printf "\e[1;92m[✓] = OK  |  \e[1;93m[!] = Warning  |  \e[1;31m[✗] = Error\e[0m\n"
printf "\n"

printf "\e[1;92m[*] Recommendations\e[0m\n"
if $IS_WSL; then
	printf "  • Running in WSL - this may cause ngrok issues\n"
	printf "  • Try using Git Bash (Windows native) instead\n"
	printf "  • Or use Termux for Android/Windows\n"
fi
if ! [[ -f ~/.ngrok2/ngrok.yml ]]; then
	printf "  • ngrok token not configured - will prompt when running script\n"
fi
printf "\n"

printf "\e[1;92m[✓] Diagnostic complete!\e[0m\n"
printf "  Run: python launcher.py [1]\n"
printf "\n"
