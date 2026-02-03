# CamN v1.8 - Full Setup & Usage Guide

## Overview

**CamN v1.8** is a fully automatic, cross-platform tool that works on:
- **Windows (Git Bash, Termux, WSL)**
- **Linux (Ubuntu, Kali, Debian, Raspberry Pi)**
- **macOS (Intel & Apple Silicon)**
- **Android (Termux)**

**Two modes:**
1. **AUTO mode** (`camphish_auto.sh`) - **Recommended for beginners**
   - Auto-detects your device
   - Auto-downloads correct ngrok binary
   - Auto-configures tools
   - Auto-falls back from ngrok → Serveo if ngrok fails
   - Ideal for Termux/mobile + hotspot

2. **MANUAL mode** (`camphish.sh`) - For advanced users
   - More control, step-by-step

---

## Quick Start (AUTO Mode - Easiest!)

### Windows (Git Bash or Termux)

```bash
cd CamN
python launcher.py
# Choose option [1] - CamPhish AUTO mode
# Follow on-screen prompts
```

If you're on Windows **native** (not Git Bash), use **Termux for Windows** or **WSL2** for best results.

### Linux / Kali / Ubuntu

```bash
sudo apt-get update
sudo apt-get install -y python3 php git curl wget
git clone https://github.com/Ashera12/CamN
cd CamN
python3 launcher.py
# Choose [1] - AUTO mode
```

### macOS

```bash
brew install php git
git clone https://github.com/Ashera12/CamN
cd CamN
python3 launcher.py
# Choose [1] - AUTO mode
```

### Android (Termux)

```bash
# Install Termux (from F-Droid preferred)
# Inside Termux:
pkg update && pkg install -y python php git curl wget openssh
git clone https://github.com/Ashera12/CamN
cd CamN
python launcher.py
# Choose [1] - AUTO mode
# Share your mobile hotspot; remote users connect to the public ngrok/Serveo link
```

---

## AUTO Mode Features

### What AUTO mode does automatically:

1. **Platform Detection**
   - Detects Windows, Linux, macOS, Termux
   - Detects CPU architecture (Intel, ARM, ARM64)

2. **Tool Download & Setup**
   - If `ngrok` binary not found → auto-downloads correct version
   - ngrok for Windows → downloads `.exe`
   - ngrok for macOS ARM64 (Apple Silicon) → downloads M1/M2/M3 version
   - ngrok for Linux amd64/arm64/armv7 → downloads correct build
   - Uses unzip, 7z, or PowerShell depending on what's available

3. **Ngrok Configuration**
   - Asks for your ngrok authtoken (from https://dashboard.ngrok.com)
   - Remembers it for future runs
   - Can reuse or update token

4. **PHP Server with Smart Binding**
   - On Windows/Termux: binds to `0.0.0.0` so mobile hotspot devices can access it
   - On Linux: binds to `127.0.0.1` (locally)
   - All public tunnel links (ngrok/Serveo) expose the server publicly

5. **Automatic Fallback**
   - Tries ngrok first
   - If ngrok fails/times out → automatically tries Serveo (SSH tunnel)
   - If both fail → clear error message

6. **Logging**
   - Saves logs to:
     - `CamPhish/ngrok.log` - ngrok startup messages
     - `CamPhish/php.log` - PHP server output
     - `CamPhish/sendlink` - Serveo connection info

7. **Template Selection**
   - Festival Wishing
   - Live YouTube TV
   - Online Meeting

---

## Troubleshooting

### "ngrok authorization error" or "authtoken invalid"

**Fix:**
1. Go to https://dashboard.ngrok.com/auth/your-authtoken
2. Copy your token
3. When the script asks, paste it and press Enter
4. If it still fails, delete `~/.ngrok2/ngrok.yml` and try again

### "Serveo failed" / "ssh not found"

**On Windows (Git Bash):**
- Install OpenSSH: included with modern Windows / Git Bash
- If missing: `choco install openssh` or use Termux instead

**On Linux/macOS:**
```bash
sudo apt install openssh-client  # Debian/Ubuntu/Kali
brew install openssh              # macOS
```

### "PHP server won't start"

**Check:**
1. Is port 3333 in use? Run: `lsof -i :3333` (Linux/macOS) or `netstat -ano | find ":3333"` (Windows)
2. If in use, kill the process or choose a different port (modify script)
3. Is PHP installed? Run `php -v`

### "Link never appears in terminal"

**Check logs:**
```bash
cd CamPhish
tail -20 ngrok.log
tail -20 php.log
tail -20 sendlink  # if using Serveo
```

**Common reasons:**
- Internet connection blocked/firewall
- ngrok/Serveo servers unreachable
- Invalid ngrok token

**Fallback:** Try choosing Serveo (ngrok fails → Serveo should work)

### "Works on Linux but not Windows"

**Try (in order):**
1. Use Git Bash instead of PowerShell (Git Bash is better for bash scripts)
2. Use Termux for Windows (from Microsoft Store)
3. Use WSL2 with Ubuntu

### "Android Termux: Can't share hotspot link"

**Why it works:**
- Your Termux runs on Android
- PHP server binds to `0.0.0.0:3333`
- ngrok/Serveo tunnels create a **public URL**
- Share the public URL with targets on any network/device
- They open link → request camera permission → photo captured

**If link doesn't appear:**
- Ensure WiFi hotspot is enabled
- Ensure your Android phone has internet
- Check `CamPhish/ngrok.log` for errors

---

## Platform-Specific Recommended Setup

### Windows Users - RECOMMENDED: Termux or Git Bash

```bash
# Option 1: Termux for Windows (Microsoft Store)
# Just run: python launcher.py > choose [1]

# Option 2: Git Bash
# - Download Git for Windows (includes bash)
# - Extract tools if needed, or use AUTO mode to auto-download
# - Run: bash launcher.sh (or use python launcher.py)
```

### Linux / Raspberry Pi / VPS

```bash
# Minimal install
sudo apt-get install -y php curl git

# Run
python3 launcher.py
# Choose [1] AUTO
```

### macOS (Intel & Apple Silicon)

```bash
# Install dependencies
brew install php

# Run
python3 launcher.py
# Choose [1] AUTO
```

### Android (Termux - BEST for mobile phishing)

```bash
pkg install -y php git curl python
git clone https://github.com/Ashera12/CamN
cd CamN
python launcher.py
# [1] AUTO
# Enable WiFi hotspot, share public link with targets
```

---

## File Structure

```
CamN/
├── launcher.py                  # Menu launcher
├── README.md                    # Original readme
├── CamPhish/
│   ├── camphish_auto.sh        # ⭐ NEW: Fully automatic (recommended)
│   ├── camphish.sh             # Manual mode (advanced)
│   ├── index.php               # Landing page handler
│   ├── ip.php                  # IP logger
│   ├── post.php                # Camera photo receiver
│   ├── template.php            # Redirect template
│   ├── festivalwishes.html     # Festival template
│   ├── LiveYTTV.html           # YouTube template
│   ├── OnlineMeeting.html      # Meeting template
│   ├── ngrok                   # ngrok binary (auto-downloaded on first run)
│   ├── ngrok.exe               # ngrok Windows binary (auto-downloaded on Windows)
│   ├── ngrok.log               # ngrok output log
│   ├── php.log                 # PHP server log
│   ├── sendlink                # Serveo connection details
│   ├── ip.json                 # IP log (JSON format)
│   ├── captures/               # Camera photo directory
│   └── Log.log                 # Execution log
```

---

## What Happens When You Run

1. **AUTO mode starts**
2. **Checks platform** → detects Windows/Linux/macOS/Termux/CPU arch
3. **Downloads ngrok** (if missing, auto-detected for your platform)
4. **Asks for template** → Festival / YouTube / Meeting
5. **Starts PHP server** → binds smartly (0.0.0.0 on Termux/Windows, 127.0.0.1 elsewhere)
6. **Tries ngrok**
   - If authtoken exists → uses it
   - If not → asks you to enter one
   - Waits for tunnel → displays public URL
7. **If ngrok fails** → auto-tries Serveo (SSH tunnel)
8. **Generates public link** → displays in terminal
9. **Waits for targets**
   - When target opens link → IP captured
   - When target allows camera → photo saved

---

## Example Workflow

```
$ python launcher.py
[Menu shows]
Pilih opsi: 1

[AUTO mode loads]
[*] Auto-setup mode
[✓] ngrok already available
[?] Existing ngrok token detected. Use it? [Y/n]: y
[✓] Using existing token

-----Choose template----
[01] Festival Wishing
[02] Live Youtube TV
[03] Online Meeting
[+] Choose: [Default 1] 2
[+] YouTube video ID: dQw4w9WgXcQ

[+] Starting PHP server on 127.0.0.1:3333
[+] Polling ngrok API...
[✓] ngrok tunnel ready
[✓] Public link: https://a1b2c3d4.ngrok.io

[*] Waiting for targets...
	Press Ctrl+C to exit
	
	[target opens link...]
	
[+] Target opened link! IP logged.
[TARGET IP: 203.0.113.42]

[+] Camera photo captured!
[Cam file received!]
```

---

## Features Summary

| Feature | AUTO | MANUAL |
|---------|------|--------|
| Auto-download ngrok | ✅ | ❌ |
| Auto-detect platform | ✅ | ❌ |
| Fallback ngrok → Serveo | ✅ | ❌ |
| PHP hotspot binding | ✅ | ✅ |
| Logging (ngrok/php) | ✅ | ✅ |
| IP + Camera capture | ✅ | ✅ |
| Works Windows/Linux/macOS/Termux | ✅ | Partial |
| Works Raspberry Pi | ✅ | ✅ |
| Works Android (Termux) | ✅ | ✅ |

---

## Support & Issues

If something fails:

1. **Check logs**
   ```bash
   cd CamPhish
   cat ngrok.log
   cat php.log
   cat sendlink
   ```

2. **Ensure dependencies**
   ```bash
   php -v          # PHP installed?
   curl --version  # curl installed?
   which ssh       # SSH installed?
   ```

3. **Check internet**
   ```bash
   ping google.com
   # or on Windows: ping 8.8.8.8
   ```

4. **Force clean start**
   ```bash
   cd CamPhish
   rm -f ngrok.log php.log sendlink
   # Re-run: python launcher.py [1]
   ```

---

## License

Educational purpose only. See LICENSE file.

---

**Last Updated:** 2026-02-03  
**Version:** 1.8 AUTO
