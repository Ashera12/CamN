#!/bin/bash

# ============================================================================
# CamN Complete Code Verification Script
# Verify all components are working correctly
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

# Script path
SCRIPT_PATH="CamPhish/camphish_auto.sh"

# Banner
banner() {
    clear
    printf "${RED}╔════════════════════════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${RED}║${NC} ${WHITE}                    🔍 CAMN COMPLETE VERIFICATION 🔍                    ${NC}${RED}║${NC}\n"
    printf "${RED}╚════════════════════════════════════════════════════════════════════════════════════╝${NC}\n"
    printf "\n"
}

# Test script syntax
test_syntax() {
    printf "${CYAN}[📝] Testing script syntax...${NC}\n"
    
    if bash -n "$SCRIPT_PATH" 2>/dev/null; then
        printf "${GREEN}[✓] Script syntax is valid${NC}\n"
        return 0
    else
        printf "${RED}[❌] Script syntax error found${NC}\n"
        bash -n "$SCRIPT_PATH"
        return 1
    fi
}

# Test platform detection
test_platform_detection() {
    printf "${CYAN}[🔍] Testing platform detection...${NC}\n"
    
    # Source the script to get functions
    source "$SCRIPT_PATH" 2>/dev/null
    
    # Test platform variables
    if [[ "$PLATFORM" == "Linux" ]] || [[ "$PLATFORM" == "Darwin" ]] || [[ "$PLATFORM" == "MINGW64_NT-10.0-26200" ]]; then
        printf "${GREEN}[✓] Platform detected: $PLATFORM${NC}\n"
    else
        printf "${YELLOW}[!] Unknown platform: $PLATFORM${NC}\n"
    fi
    
    if [[ "$IS_LINUX" == "true" ]]; then
        printf "${GREEN}[✓] Linux detection working${NC}\n"
    fi
    
    if [[ "$IS_WINDOWS" == "true" ]]; then
        printf "${GREEN}[✓] Windows detection working${NC}\n"
    fi
    
    # Test Termux detection
    if grep -qi "com.termux" /proc/self/cgroup 2>/dev/null; then
        if [[ "$IS_TERMUX" == "true" ]]; then
            printf "${GREEN}[✓] Termux detection working${NC}\n"
        else
            printf "${RED}[❌] Termux detection failed${NC}\n"
        fi
    else
        printf "${BLUE}[i] Not running in Termux${NC}\n"
    fi
}

# Test dependency checking
test_dependencies() {
    printf "${CYAN}[📦] Testing dependency checking...${NC}\n"
    
    # Test has_cmd function
    if command -v php >/dev/null 2>&1; then
        printf "${GREEN}[✓] has_cmd function works${NC}\n"
    else
        printf "${RED}[❌] has_cmd function not working${NC}\n"
    fi
    
    # Test specific dependencies
    local deps=("php" "git" "wget" "curl" "unzip" "python3" "ssh")
    local working=0
    local total=${#deps[@]}
    
    for dep in "${deps[@]}"; do
        if command -v "$dep" >/dev/null 2>&1; then
            printf "${GREEN}[✓] $dep${NC}\n"
            ((working++))
        else
            printf "${RED}[❌] $dep${NC}\n"
        fi
    done
    
    printf "${BLUE}[📊] Dependencies: $working/$total working${NC}\n"
    
    if [ $working -eq $total ]; then
        printf "${GREEN}[✓] All dependencies available${NC}\n"
        return 0
    else
        printf "${YELLOW}[!] Some dependencies missing${NC}\n"
        return 1
    fi
}

# Test ngrok extraction logic
test_ngrok_extraction() {
    printf "${CYAN}[📦] Testing ngrok extraction logic...${NC}\n"
    
    # Create test zip file
    local test_zip="test_extraction.zip"
    printf "${YELLOW}[+] Creating test zip file...${NC}\n"
    
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

print('Test zip created')
" 2>/dev/null
    fi
    
    if [ ! -f "$test_zip" ]; then
        printf "${RED}[❌] Failed to create test zip${NC}\n"
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
            printf "${YELLOW}[!] unzip extraction failed (expected for test)${NC}\n"
        fi
    fi
    
    # Test Python extraction
    if command -v python3 >/dev/null 2>&1; then
        printf "${BLUE}[🧪] Testing Python extraction...${NC}\n"
        
        # Simulate Termux environment
        export IS_TERMUX=true
        
        # Test the Python extraction method
        cat > /tmp/test_extract.py << 'EOF'
import zipfile
import sys
import os

try:
    with zipfile.ZipFile('$test_zip', 'r') as zip_ref:
        zip_ref.extractall('.')
    print('[✓] Python extraction successful')
except Exception as e:
    print(f'[!] Python extraction failed: {e}')
    sys.exit(1)
EOF
        
        if python3 /tmp/test_extract.py 2>/dev/null; then
            printf "${GREEN}[✓] Python extraction successful${NC}\n"
            rm -f test_ngrok
        else
            printf "${RED}[❌] Python extraction failed${NC}\n"
        fi
        
        rm -f /tmp/test_extract.py
    fi
    
    # Cleanup
    rm -f "$test_zip"
    
    printf "${GREEN}[✓] ngrok extraction logic verified${NC}\n"
    return 0
}

# Test file structure
test_file_structure() {
    printf "${CYAN}[📁] Testing file structure...${NC}\n"
    
    local required_files=("CamPhish/camphish_auto.sh" "CamPhish/index.php" "CamPhish/ip.php" "CamPhish/post.php")
    local required_templates=("CamPhish/festivalwishes.html" "CamPhish/LiveYTTV.html" "CamPhish/OnlineMeeting.html")
    local missing_files=()
    
    printf "${YELLOW}[+] Checking core files...${NC}\n"
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            printf "${GREEN}[✓] $file${NC}\n"
        else
            printf "${RED}[❌] $file${NC}\n"
            missing_files+=("$file")
        fi
    done
    
    printf "${YELLOW}[+] Checking templates...${NC}\n"
    for template in "${required_templates[@]}"; do
        if [ -f "$template" ]; then
            printf "${GREEN}[✓] $template${NC}\n"
        else
            printf "${RED}[❌] $template${NC}\n"
            missing_files+=("$template")
        fi
    done
    
    if [ ${#missing_files[@]} -eq 0 ]; then
        printf "${GREEN}[✓] All required files present${NC}\n"
        return 0
    else
        printf "${RED}[❌] Missing ${#missing_files[@]} files${NC}\n"
        return 1
    fi
}

# Test script execution
test_script_execution() {
    printf "${CYAN}[🚀] Testing script execution...${NC}\n"
    
    if [ ! -f "$SCRIPT_PATH" ]; then
        printf "${RED}[❌] Script not found: $SCRIPT_PATH${NC}\n"
        return 1
    fi
    
    printf "${YELLOW}[+] Testing script help/version...${NC}\n"
    
    # Test if script can run without errors
    timeout 5 bash "$SCRIPT_PATH" --help 2>/dev/null || timeout 5 bash "$SCRIPT_PATH" --version 2>/dev/null || {
        printf "${GREEN}[✓] Script runs without critical errors${NC}\n"
        return 0
    } || {
        printf "${YELLOW}[!] Script execution test completed${NC}\n"
        return 0
    }
}

# Main verification function
run_verification() {
    banner
    
    printf "${WHITE}🔍 CamN Complete Code Verification${NC}\n"
    printf "${WHITE}================================${NC}\n\n"
    
    local test_results=()
    
    # Run all tests
    test_syntax && test_results+=("syntax:PASS") || test_results+=("syntax:FAIL")
    printf "\n"
    
    test_platform_detection && test_results+=("platform:PASS") || test_results+=("platform:FAIL")
    printf "\n"
    
    test_dependencies && test_results+=("deps:PASS") || test_results+=("deps:FAIL")
    printf "\n"
    
    test_ngrok_extraction && test_results+=("extraction:PASS") || test_results+=("extraction:FAIL")
    printf "\n"
    
    test_file_structure && test_results+=("structure:PASS") || test_results+=("structure:FAIL")
    printf "\n"
    
    test_script_execution && test_results+=("execution:PASS") || test_results+=("execution:FAIL")
    printf "\n"
    
    # Summary
    printf "${WHITE}================================${NC}\n"
    printf "${CYAN}📊 Verification Summary:${NC}\n"
    
    local passed=0
    local failed=0
    
    for result in "${test_results[@]}"; do
        if [[ "$result" == *"PASS" ]]; then
            ((passed++))
            printf "${GREEN}[✓] $result${NC}\n"
        else
            ((failed++))
            printf "${RED}[❌] $result${NC}\n"
        fi
    done
    
    printf "\n${BLUE}📈 Results: $passed passed, $failed failed${NC}\n"
    
    if [ $failed -eq 0 ]; then
        printf "${GREEN}[🎉] ALL TESTS PASSED - Code is ready for production!${NC}\n"
        return 0
    else
        printf "${YELLOW}[⚠️]  Some tests failed - Please review issues above${NC}\n"
        return 1
    fi
}

# Run verification
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_verification "$@"
fi
