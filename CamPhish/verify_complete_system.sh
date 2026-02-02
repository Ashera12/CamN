#!/bin/bash

# COMPREHENSIVE CAMN TEST SUITE
# Tests: Syntax, Structure, PHP, Paths, Complete Workflow

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         CAMN PROJECT - COMPLETE VERIFICATION TEST              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

PASS=0
FAIL=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

test_check() {
    local name=$1
    local result=$2
    
    if [ $result -eq 0 ]; then
        echo -e "${GREEN}✅ PASS${NC} - $name"
        ((PASS++))
    else
        echo -e "${RED}❌ FAIL${NC} - $name"
        ((FAIL++))
    fi
}

echo -e "${BLUE}[1/5] Testing Bash Script Syntax${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1: camphish.sh syntax
if bash -n camphish.sh 2>/dev/null; then
    test_check "camphish.sh syntax valid" 0
else
    test_check "camphish.sh syntax valid" 1
fi

echo ""
echo -e "${BLUE}[2/5] Testing File Structure${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 2: Required files exist
files=("camphish.sh" "ip.php" "post.php" "index.php" "template.php" "festivalwishes.html" "LiveYTTV.html" "OnlineMeeting.html")
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        test_check "File exists: $file" 0
    else
        test_check "File exists: $file" 1
    fi
done

echo ""
echo -e "${BLUE}[3/5] Testing PHP Syntax${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 3: PHP syntax check
php_files=("ip.php" "post.php" "index.php" "template.php")
for php_file in "${php_files[@]}"; do
    if php -l "$php_file" >/dev/null 2>&1; then
        test_check "PHP syntax: $php_file" 0
    else
        test_check "PHP syntax: $php_file" 1
    fi
done

echo ""
echo -e "${BLUE}[4/5] Testing Dependencies${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 4: Required commands available
commands=("bash" "php" "curl" "wget" "unzip")
for cmd in "${commands[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        test_check "Command available: $cmd" 0
    else
        test_check "Command available: $cmd" 1
    fi
done

echo ""
echo -e "${BLUE}[5/5] Testing Code Logic${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 5: Check critical functions exist in camphish.sh
functions=("ngrok_server" "server" "banner" "dependencies")
for func in "${functions[@]}"; do
    if grep -q "^${func}()" camphish.sh || grep -q "^${func} ()" camphish.sh; then
        test_check "Function defined: $func" 0
    else
        test_check "Function defined: $func" 1
    fi
done

# Test 6: Check key features in PHP files
if grep -q "base64_decode" post.php; then
    test_check "post.php - Camera capture handling" 0
else
    test_check "post.php - Camera capture handling" 1
fi

if grep -q "REMOTE_ADDR" ip.php || grep -q "HTTP_CLIENT_IP" ip.php; then
    test_check "ip.php - IP detection" 0
else
    test_check "ip.php - IP detection" 1
fi

if grep -q "json_encode" post.php && grep -q "json_encode" ip.php; then
    test_check "JSON logging enabled" 0
else
    test_check "JSON logging enabled" 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${BLUE}TEST SUMMARY${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

TOTAL=$((PASS + FAIL))
echo -e "${GREEN}✅ Passed: $PASS${NC}"
echo -e "${RED}❌ Failed: $FAIL${NC}"
echo "Total:  $TOTAL"

echo ""
if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}[✅] ALL TESTS PASSED - SYSTEM READY${NC}"
    echo ""
    echo -e "${YELLOW}Quick Start:${NC}"
    echo "  1. bash camphish.sh"
    echo "  2. Choose tunnel: 1 (Ngrok) or 2 (Serveo)"
    echo "  3. Enter ngrok token when prompted"
    echo "  4. Choose template (1-3)"
    echo "  5. Get link and share with targets"
    echo ""
    echo -e "${YELLOW}Complete Workflow:${NC}"
    echo "  User ➜ Setup ngrok/serveo ➜ PHP server starts"
    echo "  ➜ Link generated ➜ Share with target ➜ Target opens"
    echo "  ➜ IP captured (ip.txt, ip.json) ➜ Camera request shown"
    echo "  ➜ Target grants permission ➜ Photo captured (cam_*.png)"
    echo "  ➜ Data logged (Log.log, captures.json)"
    exit 0
else
    echo -e "${RED}[❌] SOME TESTS FAILED - PLEASE FIX ISSUES${NC}"
    exit 1
fi
