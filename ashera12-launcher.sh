#!/bin/bash

# ============================================================================
# Universal Ashera12 Tools Launcher
# Auto-clone and run all Ashera12 GitHub repositories
# ============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

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

# Banner
banner() {
    clear
    printf "${RED}╔════════════════════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${RED}║${NC} ${WHITE}                    🚀 ASHERA12 UNIVERSAL TOOLS LAUNCHER 🚀                    ${NC}${RED}║${NC}\n"
    printf "${RED}╚════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
    printf "\n"
    printf "${CYAN}📦 Auto-clone and run all Ashera12 GitHub repositories${NC}\n"
    printf "${CYAN}🌐 Universal support: Windows/Linux/macOS/Termux${NC}\n"
    printf "${CYAN}⚡ One-click installation and execution${NC}\n"
    printf "\n"
}

# Check dependencies
check_deps() {
    printf "${YELLOW}[+] Checking dependencies...${NC}\n"
    
    local missing=()
    
    if ! command -v git >/dev/null 2>&1; then
        missing+=("git")
    fi
    
    if ! command -v python3 >/dev/null 2>&1 && ! command -v python >/dev/null 2>&1; then
        missing+=("python3")
    fi
    
    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
        missing+=("curl/wget")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        printf "${RED}[!] Missing dependencies: ${missing[*]}${NC}\n"
        printf "${YELLOW}[+] Installing dependencies...${NC}\n"
        
        # Install based on platform
        if $IS_LINUX; then
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get update && sudo apt-get install -y git python3 python3-pip curl wget
            elif command -v yum >/dev/null 2>&1; then
                sudo yum install -y git python3 python3-pip curl wget
            elif command -v pkg >/dev/null 2>&1; then
                pkg install -y git python3 curl wget
            fi
        elif $IS_MACOS; then
            if command -v brew >/dev/null 2>&1; then
                brew install git python3 curl wget
            fi
        elif $IS_WINDOWS; then
            if command -v choco >/dev/null 2>&1; then
                choco install git python curl wget
            else
                printf "${RED}[!] Please install Git and Python manually on Windows${NC}\n"
                printf "${YELLOW}[!] Download Git: https://git-scm.com/download/win${NC}\n"
                printf "${YELLOW}[!] Download Python: https://www.python.org/downloads/${NC}\n"
            fi
        fi
    else
        printf "${GREEN}[✓] All dependencies OK${NC}\n"
    fi
}

# Repository definitions (only verified repositories)
declare -A REPOS=(
    ["CamN"]="https://github.com/Ashera12/CamN.git"
    ["MAS"]="https://github.com/Ashera12/MAS.git"
    ["WIFI"]="https://github.com/Ashera12/WIFI.git"
)

# Clone or update repository
manage_repo() {
    local repo_name="$1"
    local repo_url="${REPOS[$repo_name]}"
    local target_dir="$repo_name"
    
    printf "${BLUE}[+] Processing $repo_name...${NC}\n"
    
    if [ -d "$target_dir" ]; then
        printf "${YELLOW}[!] Repository exists, updating...${NC}\n"
        cd "$target_dir" 2>/dev/null || return 1
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || printf "${YELLOW}[!] Could not update${NC}\n"
        cd ..
    else
        printf "${CYAN}[+] Cloning $repo_name...${NC}\n"
        git clone "$repo_url" "$target_dir" 2>/dev/null || {
            printf "${RED}[!] Failed to clone $repo_name${NC}\n"
            return 1
        }
    fi
    
    printf "${GREEN}[✓] $repo_name ready${NC}\n"
    return 0
}

# Run specific tool
run_tool() {
    local repo_name="$1"
    local target_dir="$repo_name"
    
    if [ ! -d "$target_dir" ]; then
        printf "${RED}[!] Repository $repo_name not found${NC}\n"
        return 1
    fi
    
    printf "\n${PURPLE}🚀 Launching $repo_name...${NC}\n"
    cd "$target_dir" || return 1
    
    case "$repo_name" in
        "CamN")
            printf "${CYAN}[+] CamPhish Auto Mode${NC}\n"
            if [ -f "CamPhish/camphish_auto.sh" ]; then
                cd CamPhish
                bash camphish_auto.sh
            elif [ -f "camphish_auto.sh" ]; then
                bash camphish_auto.sh
            else
                printf "${RED}[!] CamN script not found${NC}\n"
            fi
            ;;
        "MAS")
            printf "${CYAN}[+] Microsoft Activation Scripts${NC}\n"
            if [ -f "MAS/Auto-Click.ps1" ]; then
                if $IS_WINDOWS; then
                    powershell -ExecutionPolicy Bypass -File "MAS/Auto-Click.ps1"
                else
                    printf "${YELLOW}[!] MAS requires Windows${NC}\n"
                fi
            else
                printf "${CYAN}[+] Opening MAS directory${NC}\n"
                ls -la
            fi
            ;;
        "WIFI")
            printf "${CYAN}[+] WiFi DDOS Tool${NC}\n"
            if [ -f "ddoswifi.py" ]; then
                python3 ddoswifi.py
            elif [ -f "wifi.py" ]; then
                python3 wifi.py
            else
                printf "${CYAN}[+] Opening WIFI directory${NC}\n"
                ls -la
            fi
            ;;
        "Termux-UX")
            printf "${CYAN}[+] Termux UX Tools${NC}\n"
            if [ -f "termux-ux.sh" ]; then
                bash termux-ux.sh
            else
                ls -la
            fi
            ;;
        "ShellPhish"|"SocialPhish"|"Zphisher")
            printf "${CYAN}[+] Phishing Tool: $repo_name${NC}\n"
            if [ -f "$repo_name.sh" ]; then
                bash "$repo_name.sh"
            elif [ -f "start.sh" ]; then
                bash start.sh
            else
                ls -la
            fi
            ;;
        *)
            printf "${CYAN}[+] Opening $repo_name directory${NC}\n"
            ls -la
            printf "${YELLOW}[!] Look for README.md or main script files${NC}\n"
            ;;
    esac
    
    cd ..
}

# Main menu
main_menu() {
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
        read -t 10 -r choice || choice=""
        
        # Debug output
        printf "${YELLOW}[DEBUG] Choice: '$choice', Total repos: ${#REPOS[@]}${NC}\n"
        
        local total_repos=${#REPOS[@]}
        local update_option=$((total_repos + 1))
        local exit_option=$((total_repos + 2))
        
        printf "${YELLOW}[DEBUG] Update option: $update_option, Exit option: $exit_option${NC}\n"
        
        # Validate choice is numeric
        if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
            printf "${RED}[!] Please enter a number${NC}\n"
            sleep 1
            continue
        fi
        
        if [ "$choice" -ge 1 ] && [ "$choice" -le "$total_repos" ]; then
            local repo_index=1
            for repo in "${!REPOS[@]}"; do
                if [ "$repo_index" -eq "$choice" ]; then
                    manage_repo "$repo"
                    run_tool "$repo"
                    break
                fi
                ((repo_index++))
            done
        elif [ "$choice" -eq "${update_option}" ]; then
            printf "\n${YELLOW}[+] Updating all repositories...${NC}\n"
            for repo in "${!REPOS[@]}"; do
                manage_repo "$repo"
            done
            printf "${GREEN}[✓] All tools updated${NC}\n"
            printf "${YELLOW}[!] Press Enter to continue...${NC}"
            read
        elif [ "$choice" -eq "${exit_option}" ]; then
            printf "${GREEN}[+] Goodbye! 👋${NC}\n"
            exit 0
        else
            printf "${RED}[!] Invalid choice. Please enter 1-$exit_option${NC}\n"
            sleep 1
        fi
    done
}

# Quick install all
install_all() {
    printf "${YELLOW}[+] Installing all Ashera12 tools...${NC}\n"
    
    for repo in "${!REPOS[@]}"; do
        manage_repo "$repo"
    done
    
    printf "${GREEN}[✓] All tools installed successfully!${NC}\n"
    printf "${YELLOW}[!] Press Enter to continue to main menu...${NC}"
    read
}

# Setup workspace
setup_workspace() {
    printf "${CYAN}[+] Setting up Ashera12 workspace...${NC}\n"
    
    # Create workspace directory
    local workspace="Ashera12-Tools"
    if [ ! -d "$workspace" ]; then
        mkdir -p "$workspace"
    fi
    
    cd "$workspace" || exit 1
    
    # Check if first run
    if [ ! -f ".setup_complete" ]; then
        check_deps
        install_all
        touch ".setup_complete"
    fi
}

# Main execution
main() {
    setup_workspace
    main_menu
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
