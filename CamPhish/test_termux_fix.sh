#!/bin/bash

# ============================================================================
# CamN Termux Test Script
# Verify all fixes are working
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
    printf "${RED}║${NC} ${WHITE}                    🧪 CAMN TERMUX TEST SCRIPT 🧪                    ${NC}${RED}║${NC}\n"
    printf "${RED}╚════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
    printf "\n"
}

# Test Termux detection
test_termux_detection() {
    printf "${CYAN}[🔍] Testing Termux detection...${NC}\n"
    
    if grep -qi "com.termux" /proc/self/cgroup 2>/dev/null; then
        printf "${GREEN}[✓] Termux detected correctly${NC}\n"
        IS_TERMUX=true
    else
        printf "${YELLOW}[!] Not running in Termux${NC}\n"
        IS_TERMUX=false
    fi
}

# Test dependencies
test_dependencies() {
    printf "${CYAN}[📦] Testing dependencies...${NC}\n"
    
    local deps=("php" "git" "wget" "curl" "unzip" "python3" "ssh")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            printf "${GREEN}[✓] $dep${NC}\n"
        else
            printf "${RED}[❌] $dep${NC}\n"
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -eq 0 ]; then
        printf "${GREEN}[✓] All dependencies available${NC}\n"
        return 0
    else
        printf "${RED}[!] Missing dependencies: ${missing[*]}${NC}\n"
        printf "${YELLOW}[!] Install: pkg install ${missing[*]}${NC}\n"
        return 1
    fi
}

# Test ngrok extraction
test_ngrok_extraction() {
    printf "${CYAN}[📦] Testing ngrok extraction...${NC}\n"
    
    # Create test zip file
    local test_zip="test_ngrok.zip"
    printf "${YELLOW}[+] Creating test zip file...${NC}\n"
    
    # Create a simple test zip
    if command -v python3 >/dev/null 2>&1; then
        python3 -c "
import zipfile
import os

# Create test files
with open('test_ngrok', 'w') as f:
    f.write('#!/bin/bash\necho \"Test ngrok binary\"')

# Create zip
with zipfile.ZipFile('$test_zip', 'w') as zipf:
    zipf.write('test_ngrok')

print('Test zip created successfully')
" 2>/dev/null
    fi
    
    if [ ! -f "$test_zip" ]; then
        printf "${RED}[!] Failed to create test zip${NC}\n"
        return 1
    fi
    
    printf "${GREEN}[✓] Test zip created${NC}\n"
    
    # Test extraction methods
    printf "${YELLOW}[+] Testing extraction methods...${NC}\n"
    
    # Test unzip
    if command -v unzip >/dev/null 2>&1; then
        printf "${BLUE}[🧪] Testing unzip extraction...${NC}\n"
        if unzip -q "$test_zip" 2>/dev/null; then
            printf "${GREEN}[✓] unzip extraction successful${NC}\n"
            rm -f test_ngrok
        else
            printf "${RED}[❌] unzip extraction failed${NC}\n"
        fi
    fi
    
    # Test Python extraction
    if command -v python3 >/dev/null 2>&1; then
        printf "${BLUE}[🧪] Testing Python extraction...${NC}\n"
        if python3 -c "
import zipfile
import sys
try:
    with zipfile.ZipFile('$test_zip', 'r') as zip_ref:
        zip_ref.extractall('.')
    print('[✓] Python extraction successful')
except Exception as e:
    print(f'[❌] Python extraction failed: {e}')
    sys.exit(1)
" 2>/dev/null; then
            printf "${GREEN}[✓] Python extraction successful${NC}\n"
            rm -f test_ngrok
        else
            printf "${RED}[❌] Python extraction failed${NC}\n"
        fi
    fi
    
    # Cleanup
    rm -f "$test_zip" test_ngrok
}

# Test main script
test_main_script() {
    printf "${CYAN}[🚀] Testing main script...${NC}\n"
    
    if [ ! -f "camphish_auto.sh" ]; then
        printf "${RED}[!] camphish_auto.sh not found${NC}\n"
        return 1
    fi
    
    printf "${GREEN}[✓] camphish_auto.sh found${NC}\n"
    
    # Check script syntax
    if bash -n camphish_auto.sh 2>/dev/null; then
        printf "${GREEN}[✓] Script syntax valid${NC}\n"
    else
        printf "${RED}[❌] Script syntax error${NC}\n"
        return 1
    fi
    
    # Test script execution (dry run)
    printf "${YELLOW}[+] Testing script execution...${NC}\n"
    timeout 5 bash camphish_auto.sh --help 2>/dev/null || printf "${YELLOW}[!] Script execution test completed${NC}\n"
}

# Test file permissions
test_permissions() {
    printf "${CYAN}[🔐] Testing file permissions...${NC}\n"
    
    if [ -x "camphish_auto.sh" ]; then
        printf "${GREEN}[✓] camphish_auto.sh is executable${NC}\n"
    else
        printf "${YELLOW}[!] Making camphish_auto.sh executable...${NC}\n"
        chmod +x camphish_auto.sh
    fi
    
    # Check PHP files
    local php_files=("index.php" "ip.php" "post.php")
    for file in "${php_files[@]}"; do
        if [ -f "$file" ]; then
            printf "${GREEN}[✓] $file exists${NC}\n"
        else
            printf "${RED}[❌] $file missing${NC}\n"
        fi
    done
}

# Test templates
test_templates() {
    printf "${CYAN}[🎨] Testing templates...${NC}\n"
    
    local templates=("festivalwishes.html" "LiveYTTV.html" "OnlineMeeting.html")
    for template in "${templates[@]}"; do
        if [ -f "$template" ]; then
            printf "${GREEN}[✓] $template exists${NC}\n"
        else
            printf "${RED}[❌] $template missing${NC}\n"
        fi
    done
}

# Main test function
run_tests() {
    banner
    
    printf "${WHITE}🧪 CamN Termux Compatibility Test${NC}\n"
    printf "${WHITE}================================${NC}\n\n"
    
    test_termux_detection
    printf "\n"
    
    test_dependencies
    printf "\n"
    
    test_ngrok_extraction
    printf "\n"
    
    test_permissions
    printf "\n"
    
    test_templates
    printf "\n"
    
    test_main_script
    printf "\n"
    
    printf "${WHITE}================================${NC}\n"
    printf "${CYAN}📊 Test Summary:${NC}\n"
    printf "${GREEN}[✓] All tests completed${NC}\n"
    printf "${YELLOW}[!] Check results above for any issues${NC}\n"
    printf "${BLUE}[🚀] Ready to run camphish_auto.sh${NC}\n\n"
}

# Run tests
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_tests "$@"
fi
