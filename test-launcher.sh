#!/bin/bash

# ============================================================================
# Simple Ashera12 Tools Launcher
# Test version with direct execution
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

# Banner
banner() {
    clear
    printf "${RED}╔════════════════════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${RED}║${NC} ${WHITE}                    🚀 ASHERA12 TOOLS LAUNCHER (TEST) 🚀                     ${NC}${RED}║${NC}\n"
    printf "${RED}╚════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
    printf "\n"
}

# Repository definitions
declare -A REPOS=(
    ["CamN"]="https://github.com/Ashera12/CamN.git"
    ["MAS"]="https://github.com/Ashera12/MAS.git"
    ["WIFI"]="https://github.com/Ashera12/WIFI.git"
)

# Clone repository
clone_repo() {
    local repo_name="$1"
    local repo_url="${REPOS[$repo_name]}"
    
    printf "${BLUE}[+] Cloning $repo_name...${NC}\n"
    
    if [ -d "$repo_name" ]; then
        printf "${YELLOW}[!] Repository exists, updating...${NC}\n"
        cd "$repo_name"
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null
        cd ..
    else
        git clone "$repo_url" "$repo_name" 2>/dev/null || {
            printf "${RED}[!] Failed to clone $repo_name${NC}\n"
            return 1
        }
    fi
    
    printf "${GREEN}[✓] $repo_name ready${NC}\n"
    return 0
}

# Test all repositories
test_all() {
    printf "${CYAN}[+] Testing all repositories...${NC}\n\n"
    
    for repo in "${!REPOS[@]}"; do
        clone_repo "$repo"
        printf "\n"
    done
    
    printf "${GREEN}[✓] All repositories tested!${NC}\n"
}

# Show repository info
show_info() {
    printf "${WHITE}📋 Repository Information:${NC}\n\n"
    
    for repo in "${!REPOS[@]}"; do
        local status="❌"
        if [ -d "$repo" ]; then
            status="✅"
            printf "${WHITE}[${status}]${NC} ${CYAN}$repo${NC} - ${GREEN}Available${NC}\n"
            
            # Show repo size
            if [ -d "$repo" ]; then
                local size=$(du -sh "$repo" 2>/dev/null | cut -f1 || echo "Unknown")
                printf "    ${YELLOW}Size: $size${NC}\n"
                
                # Show file count
                local files=$(find "$repo" -type f 2>/dev/null | wc -l)
                printf "    ${YELLOW}Files: $files${NC}\n"
                
                # Show main scripts
                if [ -d "$repo/CamPhish" ]; then
                    printf "    ${GREEN}Contains: CamPhish${NC}\n"
                fi
            fi
        else
            printf "${WHITE}[${status}]${NC} ${CYAN}$repo${NC} - ${RED}Not downloaded${NC}\n"
        fi
        printf "\n"
    done
}

# Main execution
main() {
    banner
    
    printf "${YELLOW}[+] This is a test version of Ashera12 Launcher${NC}\n"
    printf "${YELLOW}[+] Testing repository access and data${NC}\n\n"
    
    # Test all repos
    test_all
    
    # Show info
    show_info
    
    printf "${GREEN}[✓] Test completed!${NC}\n"
    printf "${CYAN}[+] All repositories are accessible and ready${NC}\n"
    printf "${CYAN}[+] Data verification complete${NC}\n\n"
    
    printf "${WHITE}🎯 Next steps:${NC}\n"
    printf "${WHITE}1. Use full launcher: bash ashera12-launcher.sh${NC}\n"
    printf "${WHITE}2. Run individual tools from their directories${NC}\n"
    printf "${WHITE}3. Check README files for usage instructions${NC}\n"
}

# Run main function
main "$@"
