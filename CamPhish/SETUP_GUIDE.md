# CamPhish Setup Guide

## Prerequisites

### Required Tools
- `php` (PHP CLI)
- `curl`
- `ssh` (for Serveo option)
- `wget` & `unzip` (for Ngrok auto-install)
- One of: `fuser`, `lsof`, or `netstat` (for port management)

### Installation by Platform

#### **Linux (Ubuntu/Debian)**
```bash
sudo apt update
sudo apt install -y php-cli curl ssh wget unzip lsof
```

#### **Termux (Android)**
```bash
pkg update
pkg install -y php curl wget unzip openssh lsof
```

#### **macOS**
```bash
brew install php curl wget unzip
# lsof and ssh should be pre-installed
```

#### **Windows (WSL/Git-Bash)**
Follow Linux instructions in your WSL/Git-Bash terminal.

---

## Getting Started

### 1. Make Script Executable
```bash
chmod +x camphish.sh
```

### 2. Run the Script
```bash
./camphish.sh
```

### 3. Choose Tunnel Server
```
[01] Ngrok        (Recommended for reliability)
[02] Serveo.net   (Alternative, doesn't require authtoken)
```

### 4. Choose Template
```
[01] Festival Wishing   (Generic phishing page)
[02] Live Youtube TV    (YouTube video embed)
[03] Online Meeting     (Zoom/Teams look-alike)
```

---

## Ngrok Setup (Recommended)

### Get Free Authtoken
1. Visit: https://dashboard.ngrok.com/auth/your-authtoken
2. Sign up or log in with Google/GitHub
3. Copy your **Authtoken** (looks like: `xxxxxxxxxxxxxxxxxxxxxx`)

### First Time Setup
When you run `./camphish.sh` and select Ngrok:
```
[+] Configuring ngrok authtoken...
[*] No ngrok authtoken found. Getting one from https://dashboard.ngrok.com/auth/your-authtoken
[+] Enter your ngrok authtoken: [PASTE YOUR TOKEN HERE]
[*] Authtoken configured.
```

### Subsequent Runs
```
[*] ngrok authtoken already configured.
[+] Use existing token or enter new one? (E=existing / N=new) [Default: E]:
```
- Press `Enter` to use existing token
- Type `N` to enter a new token

---

## Serveo Setup (Alternative)

### No Setup Required!
Serveo doesn't require authentication. Just select option `[02]` when prompted.

**Note**: Serveo requires SSH to be installed (`apt install openssh-client` on Linux).

### Custom Subdomain (Optional)
```
[+] Choose subdomain? (Default: [Y/n] ): Y
[+] Subdomain: (Default: saycheese12345 ): mycustomname
```

This will generate: `https://mycustomname.serveo.net`

---

## File Structure

```
CamPhish/
├── camphish.sh           # Main launcher script
├── index.php             # Redirect to index2.html
├── index2.html           # Camera page (getUserMedia)
├── post.php              # Receives and saves camera captures
├── ip.php                # Logs visitor IP
├── template.php          # PHP template for URL injection
├── festivalwishes.html   # Festival theme
├── LiveYTTV.html         # YouTube theme
├── OnlineMeeting.html    # Meeting theme
└── SETUP_GUIDE.md        # This file
```

---

## Output Files

After a successful capture, you'll find:
- `ip.txt` - Latest victim's IP and User-Agent
- `saved.ip.txt` - All captured IPs (appended)
- `cam*.png` - Camera screenshots (timestamped)
  - Example: `cam29Jan2026175653.png`

---

## Troubleshooting

### Ngrok Link Not Generating
```
[!] Direct link is not generating, check following possible reason lahh
[*] Ngrok authtoken is not valid lu mah
[*] If you are using android, turn hotspot on alamakkk
[*] Ngrok is already running, run this command killall ngrok lah lumah
[*] Check your internet connection Modal Dulu Bos
```

**Solutions:**
1. Check your authtoken at https://dashboard.ngrok.com
2. Enable mobile hotspot (if on mobile)
3. Run `killall ngrok` to kill existing ngrok processes
4. Verify internet connection

### PHP Server Won't Start
```bash
# Port 3333 might be in use, kill it:
kill_port 3333
# Or manually find and kill:
lsof -i :3333
# Then run ./camphish.sh again
```

### SSH Connection Error (Serveo)
```bash
# Install OpenSSH client:
sudo apt install openssh-client  # Linux
pkg install openssh              # Termux
```

### Permission Denied
```bash
chmod +x camphish.sh
```

---

## Platform Compatibility

| Platform | Status | Notes |
|----------|--------|-------|
| Linux | ✅ Full Support | All features working |
| Termux/Android | ✅ Full Support | Tested and verified |
| macOS | ✅ Full Support | Use `brew install` |
| Windows (WSL) | ✅ Full Support | Recommended approach |
| Windows (Git-Bash) | ✅ Full Support | Alternative |
| Windows (native CMD) | ⚠️ Not Recommended | Use WSL/Git-Bash instead |

---

## Security Notes

⚠️ **Legal Warning**
- This tool is for educational purposes only
- Only use with explicit permission from target
- Unauthorized access to cameras is illegal
- Use responsibly and ethically

🔒 **Best Practices**
- Use HTTPS tunnels (Ngrok does this automatically)
- Don't share your ngrok authtoken
- Delete captured files after testing
- Run on secure networks

---

## Features

✅ Multi-platform support (Linux, macOS, Termux, WSL)  
✅ Two tunnel options (Ngrok + Serveo)  
✅ Three phishing templates (Festival, YouTube, Meeting)  
✅ Automatic IP & User-Agent logging  
✅ Camera screenshot capture (720p or higher)  
✅ Portable port management (fuser/lsof/netstat)  
✅ Flexible authtoken handling (save or change)  
✅ No hardcoded values  
✅ Automatic dependency detection  

---

## Support

For issues with:
- **Ngrok**: Visit https://ngrok.com/docs
- **Serveo**: Visit https://serveo.net
- **PHP**: Visit https://www.php.net/docs.php

---

Generated: January 30, 2026  
Version: CamPhish v1.7 (Fixed & Portable Edition)
