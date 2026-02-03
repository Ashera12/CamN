# CamN v1.8 - Troubleshooting: Script Stuck at PHP Server

## Quick Diagnosis

**If you see:**
```
[+] Starting PHP server on 0.0.0.0:3333
[+] PHP PID: 410
```
And nothing more → the script is stuck waiting for ngrok.

---

## Diagnostic Steps

### 1. Run the Diagnostic Tool First

```bash
cd CamPhish
bash diagnose.sh
```

This will show you:
- Platform (Windows, Linux, WSL, Termux)
- Available tools (PHP, curl, wget, ssh, unzip)
- ngrok status
- Network connectivity
- Recommendations

---

## Common Issues & Fixes

### Issue 1: "Running in WSL2" Warning

**Problem:** WSL networking is restricted, ngrok can't establish tunnel.

**Solutions (in order of preference):**
1. **Use Git Bash** (Windows native)
   - Download: https://git-scm.com/download/win
   - Much more reliable than WSL

2. **Use Termux for Windows**
   - Download: Microsoft Store → "Termux"
   - Works perfectly

3. **Use Termux on Android**
   - Best option for mobile phishing
   - Native networking

---

### Issue 2: "curl: timeout" or "API not responding"

**Problem:** curl can't reach `http://127.0.0.1:4040/api/tunnels`

**Check:**
```bash
# Is ngrok actually running?
ps aux | grep ngrok | grep -v grep

# Check ngrok.log for errors
tail -50 ngrok.log

# Try manual curl
curl -v http://127.0.0.1:4040/api/tunnels
```

**Fix:**
- Ensure firewall allows localhost:4040
- Restart: `pkill -f ngrok` then re-run
- Check if port 4040 is in use: `netstat -an | grep 4040`

---

### Issue 3: ngrok process dies immediately

**Symptoms:**
```
[+] ngrok spawned with PID: 1234
[!] ngrok process died immediately
[DEBUG] ngrok.log output:
[empty or error message]
```

**Causes:**
- Invalid authtoken
- Port 3333 already in use
- ngrok binary corrupted

**Fix:**
```bash
# Check authtoken
cat ~/.ngrok2/ngrok.yml

# If invalid, delete and re-run (will prompt for new token)
rm ~/.ngrok2/ngrok.yml

# Kill any existing PHP/ngrok on port 3333
pkill -f "php -S"
pkill -f ngrok

# Wait and retry
sleep 2
python launcher.py  # Choose [1] AUTO
```

---

### Issue 4: PHP server won't start

**Symptoms:**
```
[+] Starting PHP server on 0.0.0.0:3333
[+] PHP PID: 410
[!] PHP failed to start
```

**Check:**
```bash
# Is PHP installed?
php -v

# Is port 3333 in use?
lsof -i :3333          # macOS/Linux
netstat -ano | grep :3333  # Windows

# Try starting PHP manually
php -S 0.0.0.0:3333
# or
php -S 127.0.0.1:3333
```

**Fix:**
```bash
# Kill whatever is using port 3333
lsof -i :3333 | awk 'NR>1 {print $2}' | xargs kill -9
# or Windows:
netstat -ano | find ":3333" | awk '{print $5}' | xargs taskkill /PID

# Try different port (requires script modification)
```

---

### Issue 5: Network is blocked (no internet)

**Symptoms:**
```
[!] All tunneling methods failed
[!] Possible reasons:
  - No internet connection
  - Firewall blocking
```

**Check:**
```bash
# Can you reach external servers?
curl https://api.ipify.org?format=json

# Ping test
ping 8.8.8.8
```

**Fix:**
- Ensure WiFi/Ethernet is connected
- Check firewall settings for ngrok/curl
- If on corporate network: may need VPN
- Use personal hotspot instead of corporate network

---

### Issue 6: Serveo fallback also fails

**Problem:** Both ngrok AND Serveo fail.

**Check Serveo:**
```bash
# Test SSH to serveo
ssh -R 80:localhost:3333 serveo.net

# Check sendlink file
cat sendlink
```

**If SSH doesn't work:**
- Ensure SSH is installed
- On Windows: use Git Bash (includes SSH)
- On macOS/Linux: `sudo apt-get install openssh-client`

---

## What to Collect for Debugging

When reporting issues, run this and share output:

```bash
cd CamPhish

echo "=== Platform ==="
uname -a

echo "=== Diagnostic ==="
bash diagnose.sh

echo "=== ngrok version ==="
./ngrok version || ./ngrok.exe version

echo "=== ngrok.log ==="
tail -100 ngrok.log

echo "=== php.log ==="
tail -50 php.log

echo "=== sendlink (if Serveo) ==="
cat sendlink

echo "=== Port status ==="
netstat -an | grep -E ":3333|:4040"
```

---

## Recommended Setup (Priority Order)

| Rank | Platform | Reliability | Setup |
|------|----------|-------------|-------|
| 1 | Android Termux | ★★★★★ | `pkg install -y php; python launcher.py [1]` |
| 2 | Windows Git Bash | ★★★★★ | Download Git for Windows, then `python launcher.py [1]` |
| 3 | Termux Windows Store | ★★★★★ | Install from Microsoft Store, same as Linux |
| 4 | macOS (Intel/M1) | ★★★★☆ | `brew install php; python3 launcher.py [1]` |
| 5 | Linux/Kali | ★★★★☆ | `apt-get install php; python3 launcher.py [1]` |
| 6 | WSL2 (Ubuntu) | ★★☆☆☆ | Works but may have networking issues |
| 7 | Native Windows CMD | ✗ | NOT SUPPORTED - use Git Bash instead |

---

## Force Clean Start

If everything is stuck:

```bash
cd CamPhish

# Kill all processes
pkill -f ngrok
pkill -f php
pkill -f ssh

# Clean logs
rm -f ngrok.log php.log sendlink sendlink.txt

# Wait
sleep 2

# Try again
python launcher.py
# Choose [1] AUTO mode
```

---

## Still Not Working?

1. **Run diagnostic:** `bash diagnose.sh`
2. **Check your environment:** Git Bash or Termux? (preferred over WSL)
3. **Ensure internet:** Test with `ping 8.8.8.8`
4. **Check ngrok status:** Go to https://dashboard.ngrok.com - is your authtoken valid?
5. **Try Serveo-only:** Delete ngrok, script will auto-fallback to Serveo

---

**Last Updated:** 2026-02-03  
**Version:** CamN v1.8
