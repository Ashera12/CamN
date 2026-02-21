#!/bin/bash

# ============================================================================
# Ashera12 Universal Auto-Click Launcher
# One-click automation for all tools
# ============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Platform Detection
PLATFORM="$(uname -s 2>/dev/null || echo Unknown)"
IS_WINDOWS=false
IS_LINUX=false
IS_MACOS=false

case "$PLATFORM" in
    MINGW*|MSYS*|CYGWIN*) IS_WINDOWS=true ;;
    Linux*) IS_LINUX=true ;;
    Darwin*) IS_MACOS=true ;;
    *) ;;
esac

# Auto-click mode
AUTO_MODE=false
if [[ "$1" == "--auto" ]] || [[ "$1" == "-a" ]]; then
    AUTO_MODE=true
fi

# Banner
banner() {
    clear
    printf "${RED}╔════════════════════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${RED}║${NC} ${WHITE}                🚀 ASHERA12 AUTO-CLICK UNIVERSAL LAUNCHER 🚀                ${NC}${RED}║${NC}\n"
    printf "${RED}╚════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
    printf "\n"
    printf "${CYAN}🤖 One-Click Automation Mode: ${GREEN}$([ "$AUTO_MODE" = true ] && echo "ENABLED" || echo "DISABLED")${NC}\n"
    printf "${CYAN}🌐 Platform: ${GREEN}$PLATFORM${NC}\n"
    printf "${CYAN}⚡ Auto-Execute: ${GREEN}$([ "$AUTO_MODE" = true ] && echo "YES" || echo "NO")${NC}\n"
    printf "\n"
}

# Repository definitions
declare -A REPOS=(
    ["CamN"]="https://github.com/Ashera12/CamN.git"
    ["MAS"]="https://github.com/Ashera12/MAS.git"
    ["WIFI"]="https://github.com/Ashera12/WIFI.git"
)

# Tool execution commands
declare -A EXEC_CMDS=(
    ["CamN"]="cd CamN/CamPhish && bash camphish_auto.sh"
    ["MAS"]="cd MAS && ./MAS_AIO-CRC32_*.cmd"
    ["WIFI"]="cd WIFI && sudo python3 ddoswifi.py"
)

# Auto-install dependencies
auto_install_deps() {
    printf "${YELLOW}[+] Auto-installing dependencies...${NC}\n"
    
    # Check and install git
    if ! command -v git >/dev/null 2>&1; then
        printf "${YELLOW}[!] Installing git...${NC}\n"
        if $IS_LINUX; then
            sudo apt-get update && sudo apt-get install -y git
        elif $IS_MACOS; then
            brew install git
        elif $IS_WINDOWS; then
            printf "${YELLOW}[!] Please install Git from https://git-scm.com${NC}\n"
        fi
    fi
    
    # Check and install python3
    if ! command -v python3 >/dev/null 2>&1; then
        printf "${YELLOW}[!] Installing python3...${NC}\n"
        if $IS_LINUX; then
            sudo apt-get install -y python3
        elif $IS_MACOS; then
            brew install python3
        elif $IS_WINDOWS; then
            printf "${YELLOW}[!] Please install Python from https://python.org${NC}\n"
        fi
    fi
    
    printf "${GREEN}[✓] Dependencies ready${NC}\n"
}

# Auto-clone all repositories
auto_clone_all() {
    printf "${CYAN}[+] Auto-cloning all repositories...${NC}\n"
    
    for repo in "${!REPOS[@]}"; do
        printf "${BLUE}[+] Processing $repo...${NC}\n"
        
        if [ -d "$repo" ]; then
            printf "${YELLOW}[!] Repository exists, updating...${NC}\n"
            cd "$repo" 2>/dev/null && git pull origin main 2>/dev/null && cd ..
        else
            git clone "${REPOS[$repo]}" "$repo" 2>/dev/null && printf "${GREEN}[✓] $repo cloned${NC}\n"
        fi
    done
    
    printf "${GREEN}[✓] All repositories ready${NC}\n"
}

# Auto-execute tool
auto_execute() {
    local tool="$1"
    
    if [ ! -d "$tool" ]; then
        printf "${RED}[!] Tool $tool not found${NC}\n"
        return 1
    fi
    
    printf "${PURPLE}[🚀] Auto-executing $tool...${NC}\n"
    
    case "$tool" in
        "CamN")
            if [ -f "CamN/CamPhish/camphish_auto.sh" ]; then
                cd CamN/CamPhish
                printf "${GREEN}[+] Starting CamN Camera Phishing...${NC}\n"
                sleep 2
                bash camphish_auto.sh
                cd ../..
            else
                printf "${RED}[!] CamN script not found${NC}\n"
            fi
            ;;
        "MAS")
            if [ -f "MAS/MAS_AIO-CRC32_"*.cmd ]; then
                cd MAS
                printf "${GREEN}[+] Starting Microsoft Activation...${NC}\n"
                sleep 2
                if $IS_WINDOWS; then
                    ./MAS_AIO-CRC32_*.cmd
                else
                    printf "${YELLOW}[!] MAS requires Windows${NC}\n"
                fi
                cd ..
            else
                printf "${RED}[!] MAS script not found${NC}\n"
            fi
            ;;
        "WIFI")
            if [ -f "WIFI/ddoswifi.py" ]; then
                cd WIFI
                printf "${GREEN}[+] Starting WiFi DDOS...${NC}\n"
                sleep 2
                if $IS_LINUX; then
                    sudo python3 ddoswifi.py
                else
                    printf "${YELLOW}[!] WIFI requires Linux/Kali${NC}\n"
                fi
                cd ..
            else
                printf "${RED}[!] WIFI script not found${NC}\n"
            fi
            ;;
    esac
}

# Quick auto menu (one-click)
quick_auto_menu() {
    printf "${WHITE}🤖 AUTO-CLICK MODE - One Click Execution:${NC}\n\n"
    
    printf "${WHITE}[1]${NC} ${CYAN}📷 CamN Camera Phishing${NC} ${GREEN}(Universal)${NC}\n"
    printf "${WHITE}[2]${NC} ${CYAN}🪟 MAS Windows Activation${NC} ${GREEN}(Windows)${NC}\n"
    printf "${WHITE}[3]${NC} ${CYAN}📡 WIFI DDOS Tool${NC} ${GREEN}(Linux)${NC}\n"
    printf "${WHITE}[4]${NC} ${YELLOW}🔄 Auto-Install All${NC}\n"
    printf "${WHITE}[5]${NC} ${RED}🚪 Exit${NC}\n"
    
    if [ "$AUTO_MODE" = true ]; then
        printf "\n${GREEN}[🤖] Auto-mode: Executing CamN in 3 seconds...${NC}\n"
        sleep 3
        auto_execute "CamN"
        return
    fi
    
    printf "\n${PURPLE}🎯 Choose tool [1-5]: ${NC}"
    read -t 15 -r choice || choice="1"
    
    case "$choice" in
        1) auto_execute "CamN" ;;
        2) auto_execute "MAS" ;;
        3) auto_execute "WIFI" ;;
        4) auto_install_deps && auto_clone_all ;;
        5) exit 0 ;;
        *) printf "${RED}[!] Invalid choice${NC}\n" ;;
    esac
}

# Interactive menu
interactive_menu() {
    while true; do
        banner
        printf "${WHITE}📋 Available Tools:${NC}\n\n"
        
        local i=1
        for repo in "${!REPOS[@]}"; do
            local status="❌"
            if [ -d "$repo" ]; then
                status="✅"
            fi
            printf "${WHITE}[${i}]${NC} ${CYAN}$repo${NC} ${GREEN}$status${NC}\n"
            ((i++))
        done
        
        printf "\n${WHITE}[${i}]${NC} ${YELLOW}🔄 Update All Tools${NC}\n"
        ((i++))
        printf "${WHITE}[${i}]${NC} ${RED}🚪 Exit${NC}\n"
        
        printf "\n${PURPLE}🎯 Choose tool [1-$i]: ${NC}"
        read -r choice
        
        local total_repos=${#REPOS[@]}
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$total_repos" ]; then
            local repo_index=1
            for repo in "${!REPOS[@]}"; do
                if [ "$repo_index" -eq "$choice" ]; then
                    auto_execute "$repo"
                    break
                fi
                ((repo_index++))
            done
        elif [ "$choice" -eq "$((total_repos + 1))" ]; then
            auto_install_deps
            auto_clone_all
        elif [ "$choice" -eq "$((total_repos + 2))" ]; then
            exit 0
        else
            printf "${RED}[!] Invalid choice${NC}\n"
            sleep 1
        fi
    done
}

# Create desktop shortcuts
create_shortcuts() {
    printf "${CYAN}[+] Creating desktop shortcuts...${NC}\n"
    
    if $IS_WINDOWS; then
        # Windows shortcut
        cat > "Ashera12-Launcher.bat" << 'EOF'
@echo off
cd /d "%~dp0"
powershell -Command "& 'C:\Program Files\Git\bin\bash.exe' -c './ashera12-autoclick.sh --auto'"
EOF
        printf "${GREEN}[✓] Windows shortcut created: Ashera12-Launcher.bat${NC}\n"
        
    elif $IS_LINUX; then
        # Linux desktop shortcut
        cat > "Ashera12-Launcher.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Ashera12 Launcher
Comment=Universal Ashera12 Tools Launcher
Exec=bash %CD%/ashera12-autoclick.sh --auto
Icon=applications-system
Terminal=true
Categories=System;
EOF
        chmod +x "Ashera12-Launcher.desktop"
        printf "${GREEN}[✓] Linux shortcut created: Ashera12-Launcher.desktop${NC}\n"
        
    elif $IS_MACOS; then
        # macOS script
        cat > "Ashera12-Launcher.command" << EOF
#!/bin/bash
cd "$(dirname "$0")"
bash ashera12-autoclick.sh --auto
EOF
        chmod +x "Ashera12-Launcher.command"
        printf "${GREEN}[✓] macOS script created: Ashera12-Launcher.command${NC}\n"
    fi
}

# One-click setup
one_click_setup() {
    printf "${CYAN}[+] One-Click Setup Starting...${NC}\n"
    
    # Auto-install dependencies
    auto_install_deps
    
    # Auto-clone repositories
    auto_clone_all
    
    # Create shortcuts
    create_shortcuts
    
    printf "${GREEN}[✓] Setup complete!${NC}\n"
    printf "${YELLOW}[!] Double-click the shortcut to launch any tool${NC}\n"
    
    if [ "$AUTO_MODE" = true ]; then
        printf "${GREEN}[🤖] Auto-executing CamN...${NC}\n"
        sleep 2
        auto_execute "CamN"
    fi
}

# Main execution
main() {
    banner
    
    # Check if first run
    if [ ! -f ".setup_complete" ]; then
        printf "${YELLOW}[+] First-time setup detected${NC}\n"
        one_click_setup
        touch ".setup_complete"
        return
    fi
    
    if [ "$AUTO_MODE" = true ]; then
        quick_auto_menu
    else
        interactive_menu
    fi
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
