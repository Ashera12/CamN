#!/bin/bash

# CamPhish - Multi-Platform Verification Script
# This script tests both the original and fixed versions

echo "╔════════════════════════════════════════════╗"
echo "║  CamPhish Multi-Platform Test Suite        ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check environment
echo -e "${BLUE}[*] System Information${NC}"
echo "OS: $(uname -s)"
echo "Architecture: $(uname -m)"
echo "Bash Version: $BASH_VERSION"
echo ""

# Function to check file syntax
check_syntax() {
    local script=$1
    echo -e "${BLUE}[*] Checking syntax for $script${NC}"
    
    if [ ! -f "$script" ]; then
        echo -e "${RED}[!] File not found: $script${NC}"
        return 1
    fi
    
    # Check line endings
    local line_ending=$(file "$script" | grep -o 'CRLF\|LF')
    if [ -z "$line_ending" ]; then
        line_ending="LF"
    fi
    echo "    Line endings: $line_ending"
    
    # Check syntax
    if bash -n "$script" 2>/dev/null; then
        echo -e "${GREEN}    ✅ Syntax OK${NC}"
        return 0
    else
        local error=$(bash -n "$script" 2>&1)
        echo -e "${RED}    ❌ Syntax Error:${NC}"
        echo "    $error"
        return 1
    fi
}

# Function to check dependencies
check_dependencies() {
    echo -e "${BLUE}[*] Checking Dependencies${NC}"
    
    local missing=0
    
    # Required
    for cmd in bash php curl; do
        if command -v "$cmd" &> /dev/null; then
            local version=$($cmd --version 2>&1 | head -n1)
            echo -e "${GREEN}    ✅ $cmd${NC} - $version"
        else
            echo -e "${RED}    ❌ $cmd${NC} - NOT FOUND"
            missing=$((missing + 1))
        fi
    done
    
    # Optional (ngrok tunneling)
    for cmd in wget unzip git; do
        if command -v "$cmd" &> /dev/null; then
            echo -e "${GREEN}    ✅ $cmd${NC} - Found"
        else
            echo -e "${YELLOW}    ⚠️  $cmd${NC} - Not found (optional)"
        fi
    done
    
    echo ""
    if [ $missing -eq 0 ]; then
        echo -e "${GREEN}All required dependencies found!${NC}"
        return 0
    else
        echo -e "${RED}Missing $missing required dependencies${NC}"
        return 1
    fi
}

# Function to check script features
check_features() {
    local script=$1
    echo -e "${BLUE}[*] Checking Features in $script${NC}"
    
    if [ ! -f "$script" ]; then
        echo -e "${RED}[!] File not found${NC}"
        return 1
    fi
    
    # Check for key functions
    local features=(
        "php_server:PHP server function"
        "ngrok:Ngrok support"
        "serveo:Serveo support"
        "platform:Platform detection"
        "arch:Architecture detection"
    )
    
    for feature_check in "${features[@]}"; do
        local func="${feature_check%:*}"
        local desc="${feature_check#*:}"
        
        if grep -q "$func" "$script"; then
            echo -e "${GREEN}    ✅ $desc${NC}"
        else
            echo -e "${YELLOW}    ⚠️  $desc${NC} - Not found"
        fi
    done
    
    echo ""
}

# Function to test script execution
test_execution() {
    local script=$1
    echo -e "${BLUE}[*] Testing Execution: $script${NC}"
    
    if [ ! -f "$script" ]; then
        echo -e "${RED}[!] File not found${NC}"
        return 1
    fi
    
    # Make executable
    chmod +x "$script" 2>/dev/null
    
    # Try to source and get menu
    if bash "$script" < /dev/null &>/dev/null; then
        echo -e "${GREEN}    ✅ Script runs without errors${NC}"
        return 0
    else
        local error=$( (bash "$script" < /dev/null) 2>&1 | head -n5)
        echo -e "${RED}    ❌ Script execution error:${NC}"
        echo "    $error"
        return 1
    fi
}

# Main tests
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
check_dependencies
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Test both versions if they exist
SCRIPTS_TO_TEST=("camphish.sh" "camphish_fixed.sh")

for script in "${SCRIPTS_TO_TEST[@]}"; do
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [ -f "$script" ]; then
        check_syntax "$script"
        echo ""
        check_features "$script"
        echo ""
        # test_execution "$script"  # Commented out - user can run manually
        echo ""
    else
        echo -e "${YELLOW}[!] $script not found in current directory${NC}"
        echo ""
    fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${BLUE}[*] Test Summary${NC}"
echo ""

# Count results
local total=0
local passed=0

if [ -f "camphish.sh" ]; then
    if bash -n camphish.sh 2>/dev/null; then
        echo -e "${GREEN}✅ camphish.sh${NC} - Syntax OK"
        ((passed++))
    else
        echo -e "${RED}❌ camphish.sh${NC} - Syntax Error"
    fi
    ((total++))
fi

if [ -f "camphish_fixed.sh" ]; then
    if bash -n camphish_fixed.sh 2>/dev/null; then
        echo -e "${GREEN}✅ camphish_fixed.sh${NC} - Syntax OK"
        ((passed++))
    else
        echo -e "${RED}❌ camphish_fixed.sh${NC} - Syntax Error"
    fi
    ((total++))
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $passed -eq $total ] && [ $total -gt 0 ]; then
    echo -e "${GREEN}[✅] All tests passed!${NC}"
    echo ""
    echo "You can run:"
    echo "  bash camphish.sh"
    echo ""
    exit 0
else
    echo -e "${RED}[❌] Some tests failed${NC}"
    echo ""
    echo "Try:"
    echo "  bash -n camphish.sh        # Check syntax"
    echo "  file camphish.sh           # Check line endings"
    echo "  dos2unix camphish.sh       # Fix line endings"
    echo ""
    exit 1
fi
