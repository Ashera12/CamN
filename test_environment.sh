#!/bin/bash
# Test suite for CamPhish improvements

clear
printf "\e[1;94m╔════════════════════════════════════════════════════════════╗\e[0m\n"
printf "\e[1;94m║         CamPhish Diagnostics & Quick Test Suite           ║\e[0m\n"
printf "\e[1;94m╚════════════════════════════════════════════════════════════╝\e[0m\n\n"

PASS=0
FAIL=0
WARN=0

# Helper functions
test_pass() {
    printf "\e[1;92m[✓] $1\e[0m\n"
    ((PASS++))
}

test_fail() {
    printf "\e[1;31m[✗] $1\e[0m\n"
    ((FAIL++))
}

test_warn() {
    printf "\e[1;93m[!] $1\e[0m\n"
    ((WARN++))
}

# ============================================================================
# Test 1: Check PHP
# ============================================================================
printf "\e[1;92m[1/6] PHP Installation\e[0m\n"
if php --version >/dev/null 2>&1; then
    test_pass "PHP is installed"
    PHP_VER=$(php -v | head -1)
    printf "     $PHP_VER\n"
else
    test_fail "PHP not found"
fi

# ============================================================================
# Test 2: Check curl
# ============================================================================
printf "\n\e[1;92m[2/6] curl/wget Available\e[0m\n"
if curl --version >/dev/null 2>&1; then
    test_pass "curl available"
elif wget --version >/dev/null 2>&1; then
    test_pass "wget available"
else
    test_fail "Neither curl nor wget found"
fi

# ============================================================================
# Test 3: Check SSH (for Serveo)
# ============================================================================
printf "\n\e[1;92m[3/6] SSH Available (for Serveo fallback)\e[0m\n"
if ssh -V >/dev/null 2>&1; then
    test_pass "SSH is installed"
else
    test_warn "SSH not available (Serveo will fail)"
fi

# ============================================================================
# Test 4: Start PHP and test connectivity
# ============================================================================
printf "\n\e[1;92m[4/6] PHP Server Startup\e[0m\n"

# Kill existing PHP
pkill -f "php -S 0.0.0.0:3333" 2>/dev/null || true
sleep 1

# Create test file
cat > _test.php << 'EOF'
<?php
if ($_SERVER['REQUEST_URI'] === '/status') {
    echo "OK";
} else {
    echo file_get_contents('index.php');
}
?>
EOF

# Start PHP
printf "Starting PHP on 0.0.0.0:3333... "
php -S 0.0.0.0:3333 < /dev/null > _php_test.log 2>&1 &
PHP_PID=$!
sleep 2

if kill -0 $PHP_PID 2>/dev/null; then
    test_pass "PHP process started (PID: $PHP_PID)"
else
    test_fail "PHP process died"
    printf "\n\e[1;93m[DEBUG] PHP log:\e[0m\n"
    cat _php_test.log | head -10
    rm -f _test.php _php_test.log
    exit 1
fi

# ============================================================================
# Test 5: Test PHP connectivity
# ============================================================================
printf "\n\e[1;92m[5/6] PHP Connectivity\e[0m\n"

CONNECTED=0
for i in 1 2 3; do
    if curl -s --max-time 1 http://127.0.0.1:3333/_test.php >/dev/null 2>&1; then
        test_pass "PHP responds on 127.0.0.1:3333 (attempt $i)"
        CONNECTED=1
        break
    fi
    sleep 1
done

if [[ $CONNECTED -eq 0 ]]; then
    test_fail "PHP not responding on 127.0.0.1:3333"
    printf "\n\e[1;93m[DEBUG] PHP log:\e[0m\n"
    cat _php_test.log | head -10
fi

# ============================================================================
# Test 6: Internet connectivity
# ============================================================================
printf "\n\e[1;92m[6/6] Internet Connectivity\e[0m\n"

if curl -s --max-time 3 https://www.google.com >/dev/null 2>&1; then
    test_pass "Internet connectivity OK"
else
    test_warn "No internet or very slow (ngrok/Serveo may timeout)"
fi

# ============================================================================
# Summary
# ============================================================================
printf "\n\e[1;94m╔════════════════════════════════════════════════════════════╗\e[0m\n"
printf "\e[1;92m[PASS: $PASS/6] \e[0m"
if [[ $FAIL -gt 0 ]]; then
    printf "\e[1;31m[FAIL: $FAIL] \e[0m"
fi
if [[ $WARN -gt 0 ]]; then
    printf "\e[1;93m[WARN: $WARN]\e[0m"
fi
printf "\n\e[1;94m╚════════════════════════════════════════════════════════════╝\e[0m\n\n"

# Cleanup
printf "\e[1;92m[+] Cleaning up test process (PID $PHP_PID)...\e[0m\n"
kill $PHP_PID 2>/dev/null || true
wait $PHP_PID 2>/dev/null || true
rm -f _test.php _php_test.log

if [[ $FAIL -gt 0 ]]; then
    printf "\e[1;31m[!] Some tests failed. Fix these issues before running camphish_auto.sh\e[0m\n\n"
    exit 1
fi

if [[ $WARN -gt 0 ]]; then
    printf "\e[1;93m[!] Warnings detected. Some features may not work.\e[0m\n"
fi

printf "\e[1;92m[✓] Environment ready! You can now run:\e[0m\n"
printf "\e[1;93m    python launcher.py\e[0m\n\n"
