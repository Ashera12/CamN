#!/bin/bash

# ============================================================================
# Ashera12 Universal Complete Launcher
# Full-featured with direct tool access and cloning
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
IS_TERMUX=false

case "$PLATFORM" in
    MINGW*|MSYS*|CYGWIN*) IS_WINDOWS=true ;;
    Linux*) 
        IS_LINUX=true
        if grep -qi "com.termux" /proc/self/cgroup 2>/dev/null; then
            IS_TERMUX=true
        fi
        ;;
    Darwin*) IS_MACOS=true ;;
    *) ;;
esac

# Workspace setup
WORKSPACE_DIR="Ashera12-Tools"
if [ ! -d "$WORKSPACE_DIR" ]; then
    mkdir -p "$WORKSPACE_DIR"
fi
cd "$WORKSPACE_DIR" || exit 1

# Banner
banner() {
    clear
    printf "${RED}╔════════════════════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${RED}║${NC} ${WHITE}                🚀 ASHERA12 COMPLETE UNIVERSAL LAUNCHER 🚀                ${NC}${RED}║${NC}\n"
    printf "${RED}╚════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
    printf "\n"
    printf "${CYAN}🌐 Platform: ${GREEN}$PLATFORM${NC}\n"
    printf "${CYAN}📁 Workspace: ${GREEN}$PWD${NC}\n"
    printf "${CYAN}📦 Available Tools: ${GREEN}${#REPOS[@]}${NC}\n"
    printf "\n"
}

# Repository definitions (verified working)
declare -A REPOS=(
    ["CamN"]="https://github.com/Ashera12/CamN.git"
    ["MAS"]="https://github.com/Ashera12/MAS.git"
    ["WIFI"]="https://github.com/Ashera12/WIFI.git"
)

# Tool information
declare -A TOOL_INFO=(
    ["CamN"]="Camera Phishing Tool - Universal Platform"
    ["MAS"]="Microsoft Activation Scripts - Windows Only"
    ["WIFI"]="WiFi DDOS Tool - Linux/Kali Only"
)

# Tool main scripts
declare -A MAIN_SCRIPTS=(
    ["CamN"]="CamPhish/camphish_auto.sh"
    ["MAS"]="MAS_AIO-CRC32_*.cmd"
    ["WIFI"]="ddoswifi.py"
)

# Tool platforms
declare -A TOOL_PLATFORMS=(
    ["CamN"]="Universal"
    ["MAS"]="Windows"
    ["WIFI"]="Linux"
)

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
        printf "${RED}[!] Missing: ${missing[*]}${NC}\n"
        printf "${YELLOW}[+] Auto-installing...${NC}\n"
        
        if $IS_LINUX; then
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get update && sudo apt-get install -y git python3 python3-pip curl wget
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
                printf "${RED}[!] Please install Git and Python manually${NC}\n"
                printf "${YELLOW}[!] Git: https://git-scm.com${NC}\n"
                printf "${YELLOW}[!] Python: https://python.org${NC}\n"
            fi
        fi
    else
        printf "${GREEN}[✓] All dependencies OK${NC}\n"
    fi
}

# Clone or update repository
manage_repo() {
    local repo_name="$1"
    local repo_url="${REPOS[$repo_name]}"
    
    printf "${BLUE}[+] Processing $repo_name...${NC}\n"
    
    if [ -d "$repo_name" ]; then
        printf "${YELLOW}[!] Repository exists, updating...${NC}\n"
        cd "$repo_name" 2>/dev/null || return 1
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || printf "${YELLOW}[!] Could not update${NC}\n"
        cd ..
    else
        printf "${CYAN}[+] Cloning $repo_name...${NC}\n"
        git clone "$repo_url" "$repo_name" 2>/dev/null || {
            printf "${RED}[!] Failed to clone $repo_name${NC}\n"
            return 1
        }
    fi
    
    printf "${GREEN}[✓] $repo_name ready${NC}\n"
    return 0
}

# Clone all repositories
clone_all() {
    printf "${CYAN}[+] Cloning all repositories...${NC}\n\n"
    
    local success_count=0
    local total_count=${#REPOS[@]}
    
    for repo in "${!REPOS[@]}"; do
        if manage_repo "$repo"; then
            ((success_count++))
        fi
        printf "\n"
    done
    
    printf "${GREEN}[✓] Cloned $success_count/$total_count repositories${NC}\n"
}

# Navigate to tool directory
navigate_to_tool() {
    local tool="$1"
    
    if [ ! -d "$tool" ]; then
        printf "${RED}[!] Tool $tool not found${NC}\n"
        printf "${YELLOW}[!] Cloning $tool first...${NC}\n"
        manage_repo "$tool" || return 1
    fi
    
    printf "${GREEN}[+] Launching $tool...${NC}\n"
    cd "$tool" || return 1
    
    # Show tool info
    printf "${CYAN}📋 Tool Information:${NC}\n"
    printf "${WHITE}Name:${NC} $tool\n"
    printf "${WHITE}Platform:${NC} ${TOOL_PLATFORMS[$tool]}\n"
    printf "${WHITE}Description:${NC} ${TOOL_INFO[$tool]}\n"
    printf "${WHITE}Main Script:${NC} ${MAIN_SCRIPTS[$tool]}\n"
    printf "\n"
    
    # Auto-execute main script based on tool
    case "$tool" in
        "CamN")
            printf "${PURPLE}[🚀] Starting CamN Camera Phishing...${NC}\n"
            if [ -f "CamPhish/camphish_auto.sh" ]; then
                cd CamPhish
                printf "${GREEN}[+] Found: camphish_auto.sh${NC}\n"
                printf "${YELLOW}[!] Executing CamN...${NC}\n"
                sleep 2
                bash camphish_auto.sh
                cd ..
            else
                printf "${RED}[!] CamN script not found${NC}\n"
                printf "${CYAN}[!] Available files:${NC}\n"
                ls -la
            fi
            ;;
        "MAS")
            printf "${PURPLE}[🚀] Starting Microsoft Activation Scripts...${NC}\n"
            if $IS_WINDOWS; then
                if ls MAS_AIO-CRC32_*.cmd >/dev/null 2>&1; then
                    printf "${GREEN}[+] Found: MAS_AIO-CRC32_*.cmd${NC}\n"
                    printf "${YELLOW}[!] Executing MAS...${NC}\n"
                    sleep 2
                    ./MAS_AIO-CRC32_*.cmd
                else
                    printf "${YELLOW}[!] MAS script not found, using PowerShell method...${NC}\n"
                    printf "${CYAN}[!] Starting PowerShell with MAS command...${NC}\n"
                    sleep 2
                    powershell -Command "irm https://get.activated.win | iex"
                fi
            else
                printf "${YELLOW}[!] MAS requires Windows${NC}\n"
                printf "${CYAN}[!] On Windows, use PowerShell:${NC}\n"
                printf "${WHITE}irm https://get.activated.win | iex${NC}\n"
            fi
            ;;
        "WIFI")
            printf "${PURPLE}[🚀] Starting WiFi DDOS Tool...${NC}\n"
            if $IS_LINUX; then
                if [ -f "ddoswifi.py" ]; then
                    printf "${GREEN}[+] Found: ddoswifi.py${NC}\n"
                    printf "${YELLOW}[!] Executing WIFI DDOS...${NC}\n"
                    printf "${WHITE}[!] Requires sudo for network access${NC}\n"
                    sleep 2
                    sudo python3 ddoswifi.py
                else
                    printf "${RED}[!] WIFI script not found${NC}\n"
                    printf "${CYAN}[!] Available files:${NC}\n"
                    ls -la
                fi
            else
                printf "${YELLOW}[!] WIFI requires Linux/Kali${NC}\n"
                printf "${CYAN}[!] This tool is for Linux systems only${NC}\n"
            fi
            ;;
    esac
    
    cd ..
}

# Show repository status
show_status() {
    printf "${WHITE}📊 Repository Status:${NC}\n\n"
    
    printf "${WHITE}┌─────────────────────────────────────────────────────────────┐${NC}\n"
    printf "${WHITE}│ ${CYAN}TOOL    │ STATUS   │ SIZE   │ PLATFORM    │ DESCRIPTION${NC}    │${NC}\n"
    printf "${WHITE}├─────────────────────────────────────────────────────────────┤${NC}\n"
    
    for repo in "${!REPOS[@]}"; do
        local status="❌ Missing"
        local size="Unknown"
        
        if [ -d "$repo" ]; then
            status="✅ Ready"
            size=$(du -sh "$repo" 2>/dev/null | cut -f1 || echo "Unknown")
        fi
        
        printf "${WHITE}│ ${CYAN}%-7s${NC} │ ${GREEN}%-9s${NC} │ ${YELLOW}%-6s${NC} │ ${BLUE}%-11s${NC} │ ${WHITE}%-30s${NC} │${NC}\n" \
            "$repo" "$status" "$size" "${TOOL_PLATFORMS[$repo]}" "${TOOL_INFO[$repo]}"
    done
    
    printf "${WHITE}└─────────────────────────────────────────────────────────────┘${NC}\n"
    printf "\n"
}

# Main menu
main_menu() {
    while true; do
        banner
        show_status
        
        printf "${WHITE}🎯 Main Options:${NC}\n\n"
        
        local i=1
        for repo in "${!REPOS[@]}"; do
            local status="❌"
            if [ -d "$repo" ]; then
                status="✅"
            fi
            printf "${WHITE}[${i}]${NC} ${CYAN}$repo${NC} ${GREEN}$status${NC} - ${YELLOW}${TOOL_INFO[$repo]}${NC}\n"
            ((i++))
        done
        
        printf "\n${WHITE}[${i}]${NC} ${YELLOW}🔄 Clone All Tools${NC}\n"
        ((i++))
        printf "${WHITE}[${i}]${NC} ${BLUE}📊 Check Dependencies${NC}\n"
        ((i++))
        printf "${WHITE}[${i}]${NC} ${PURPLE}📁 Navigate to Tool Directory${NC}\n"
        ((i++))
        printf "${WHITE}[${i}]${NC} ${RED}🚪 Exit${NC}\n"
        
        printf "\n${PURPLE}🎯 Choose option [1-$i]: ${NC}"
        read -r choice
        
        # Validate input
        if [[ -z "$choice" ]]; then
            printf "${RED}[!] No input provided${NC}\n"
            sleep 1
            continue
        fi
        
        if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
            printf "${RED}[!] Please enter a number${NC}\n"
            sleep 1
            continue
        fi
        
        local total_repos=${#REPOS[@]}
        local clone_option=$((total_repos + 1))
        local deps_option=$((total_repos + 2))
        local nav_option=$((total_repos + 3))
        local exit_option=$((total_repos + 4))
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$total_repos" ]; then
            local repo_index=1
            for repo in "${!REPOS[@]}"; do
                if [ "$repo_index" -eq "$choice" ]; then
                    navigate_to_tool "$repo"
                    break
                fi
                ((repo_index++))
            done
        elif [ "$choice" -eq "$clone_option" ]; then
            clone_all
            printf "${YELLOW}[!] Press Enter to continue...${NC}"
            read
        elif [ "$choice" -eq "$deps_option" ]; then
            check_deps
            printf "${YELLOW}[!] Press Enter to continue...${NC}"
            read
        elif [ "$choice" -eq "$nav_option" ]; then
            printf "\n${CYAN}📁 Available Tool Directories:${NC}\n\n"
            
            local j=1
            for repo in "${!REPOS[@]}"; do
                if [ -d "$repo" ]; then
                    printf "${WHITE}[${j}]${NC} ${CYAN}$repo${NC} - ${GREEN}Available${NC}\n"
                    ((j++))
                fi
            done
            
            printf "\n${PURPLE}🎯 Navigate to [1-$j]: ${NC}"
            read -r nav_choice
            
            if [[ "$nav_choice" =~ ^[0-9]+$ ]]; then
                local k=1
                for repo in "${!REPOS[@]}"; do
                    if [ -d "$repo" ]; then
                        if [ "$k" -eq "$nav_choice" ]; then
                            printf "${GREEN}[+] Opening $repo directory...${NC}\n"
                            cd "$repo"
                            printf "${CYAN}[!] You are now in: $PWD${NC}\n"
                            printf "${CYAN}[!] Type 'exit' to return to launcher${NC}\n"
                            printf "${CYAN}[!] Available files:${NC}\n"
                            ls -la
                            printf "\n"
                            
                            # Interactive shell in tool directory
                            while true; do
                                printf "${PURPLE}$repo>${NC} "
                                read -r tool_cmd
                                
                                case "$tool_cmd" in
                                    "exit"|"quit"|"q") 
                                        printf "${YELLOW}[+] Returning to launcher...${NC}\n"
                                        cd ..
                                        break
                                        ;;
                                    "ls"|"ll") 
                                        ls -la 
                                        ;;
                                    "help"|"?") 
                                        printf "${CYAN}Commands:${NC}\n"
                                        printf "${WHITE}  ls/ll     - List files${NC}\n"
                                        printf "${WHITE}  exit/quit - Return to launcher${NC}\n"
                                        printf "${WHITE}  help/?    - Show help${NC}\n"
                                        printf "${WHITE}  *         - Execute any shell command${NC}\n"
                                        ;;
                                    "") 
                                        ;;
                                    *) 
                                        eval "$tool_cmd" 2>/dev/null || printf "${RED}[!] Command failed${NC}\n"
                                        ;;
                                esac
                            done
                            break
                        fi
                        ((k++))
                    fi
                done
            fi
        elif [ "$choice" -eq "$exit_option" ]; then
            printf "${GREEN}[+] Goodbye! 👋${NC}\n"
            exit 0
        else
            printf "${RED}[!] Invalid choice${NC}\n"
            sleep 1
        fi
    done
}

# First-time setup
first_time_setup() {
    printf "${YELLOW}[+] First-time setup detected${NC}\n"
    printf "${YELLOW}[+] Setting up Ashera12 workspace...${NC}\n"
    
    check_deps
    clone_all
    
    printf "${GREEN}[✓] Setup complete!${NC}\n"
    printf "${YELLOW}[!] Press Enter to continue to main menu...${NC}"
    read
    
    touch ".setup_complete"
}

# Main execution
main() {
    # Check if first run
    if [ ! -f ".setup_complete" ]; then
        first_time_setup
    fi
    
    main_menu
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
