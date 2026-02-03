#!/bin/bash
# Quick diagnostic test for PHP and network

echo "[*] Testing PHP and network..."
echo

# Test 1: Check if PHP is installed
if ! command -v php &>/dev/null; then
    echo "[✗] PHP not found"
    exit 1
fi
echo "[✓] PHP installed: $(php -v | head -1)"
echo

# Test 2: Start PHP on port 3333
echo "[+] Starting PHP test server..."
cat > _test.php << 'EOF'
<?php echo "PHP WORKS"; ?>
EOF

php -S 0.0.0.0:3333 < /dev/null > _php.log 2>&1 &
PHP_PID=$!
echo "[+] PHP PID: $PHP_PID"
sleep 2

# Test 3: Test PHP connectivity
echo "[+] Testing PHP connectivity on 127.0.0.1:3333: " 
if curl -s --max-time 2 http://127.0.0.1:3333/_test.php | grep -q "PHP WORKS"; then
    echo "✓ Success"
else
    echo "✗ Failed"
    echo
    echo "[DEBUG] PHP log:"
    cat _php.log
    kill $PHP_PID 2>/dev/null || true
    rm -f _test.php _php.log
    exit 1
fi
echo

# Test 4: Test internet
echo "[+] Testing internet connectivity: " 
if curl -s --max-time 3 https://www.google.com >/dev/null 2>&1; then
    echo "✓ Good"
else
    echo "✗ No internet or slow"
fi
echo

# Cleanup
echo "[+] Cleaning up..."
kill $PHP_PID 2>/dev/null || true
sleep 1
rm -f _test.php _php.log

echo "[✓] All checks passed! PHP and network are ready."
echo
echo "Now run: python launcher.py"
echo
