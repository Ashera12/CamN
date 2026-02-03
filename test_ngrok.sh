#!/bin/bash
cd "c:\Users\Irga\git irga\CamN\CamPhish"

echo "[+] Setting up ngrok with token..."
./ngrok.exe authtoken "398ehVXPaY93sAWM4gPqJTVTFCP_6p34c1nsf2LbgoQK9Bcnp" 2>&1 | head -1

echo "[+] Starting ngrok on port 3333..."
./ngrok.exe http 3333 > ngrok_test.log 2>&1 &
NGROK_PID=$!
echo "[+] ngrok PID: $NGROK_PID"

echo "[+] Waiting 2 seconds for startup..."
sleep 2

echo "[+] Checking ngrok API at 127.0.0.1:4040..."
if curl -s --max-time 2 http://127.0.0.1:4040/api/tunnels 2>/dev/null | grep -q "public_url"; then
    echo "[✓] ngrok API responding with tunnels!"
    echo "[✓] Public URL:"
    curl -s --max-time 2 http://127.0.0.1:4040/api/tunnels 2>/dev/null | grep -o '"public_url":"https://[^"]*' | cut -d'"' -f4
else
    echo "[!] ngrok API not responding or no tunnels"
    echo "[DEBUG] ngrok.log:"
    head -20 ngrok_test.log
fi

echo "[+] Killing ngrok..."
kill $NGROK_PID 2>/dev/null
wait $NGROK_PID 2>/dev/null
echo "[✓] Test complete"
