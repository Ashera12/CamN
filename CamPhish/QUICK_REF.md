# CamPhish Quick Reference Card

## 🚀 Quick Start (30 Seconds)

```bash
cd CamPhish
chmod +x camphish.sh
./camphish.sh
```

Then follow the prompts.

---

## 📋 Authtoken Handling

### Option 1: Ngrok (First Time)
```
[+] Enter your ngrok authtoken: [PASTE_YOUR_TOKEN]
↓
Token saved to ~/.ngrok2/ngrok.yml automatically
↓
Continue
```

### Option 2: Ngrok (Subsequent Runs)
```
[*] ngrok authtoken already configured.
[+] Use existing token or enter new one? (E=existing / N=new) [Default: E]: 
↓
Press Enter → Use existing token
Type "N" → Enter new token
```

### Option 3: Serveo (No Authtoken Needed!)
```
Select Option 2 → No token needed!
Optional: Custom subdomain or use random
```

---

## 🔑 Getting Your Ngrok Authtoken (FREE)

1. **Go to**: https://dashboard.ngrok.com/auth/your-authtoken
2. **Sign up** with Google or GitHub (free, no credit card)
3. **Copy** your authtoken (looks like: `abcd1234efgh5678...`)
4. **Paste** when script prompts

Your token is saved automatically for future runs.

---

## 📱 Platform Shortcuts

### Linux / WSL / Cygwin
```bash
chmod +x camphish.sh
./camphish.sh
```

### Termux (Android)
```bash
pkg install php curl wget unzip openssh lsof
cd CamPhish
chmod +x camphish.sh
./camphish.sh
```

### macOS
```bash
brew install php curl wget unzip
cd CamPhish
chmod +x camphish.sh
./camphish.sh
```

---

## 🔧 Troubleshooting

### "Ngrok link not generating"
```bash
# Solution 1: Check authtoken validity
# Solution 2: Enable hotspot (if on mobile)
# Solution 3: Kill existing ngrok
killall ngrok
./camphish.sh

# Solution 4: Check internet connection
ping google.com
```

### "Port 3333 already in use"
```bash
# Kill the process using port 3333
lsof -i :3333
kill -9 [PID]
./camphish.sh
```

### "PHP: command not found"
```bash
# Install PHP
sudo apt install php-cli          # Linux
brew install php                  # macOS
pkg install php                   # Termux
```

---

## 📂 Output Files

After capture:
```
ip.txt              → Latest victim's IP & User-Agent
saved.ip.txt        → All captured IPs (appended)
cam*.png            → Screenshots (timestamped)
  Example: cam29Jan2026175653.png
```

---

## 🎯 Template Selection

| Option | Theme | Best For |
|--------|-------|----------|
| 1 | Festival Wishing | Generic themed page |
| 2 | Live YouTube TV | Video/media interest |
| 3 | Online Meeting | Zoom/Teams lookalike |

---

## 🔒 Security & Legal

⚠️ **Use Only With Permission**
- This tool is for authorized security testing
- Unauthorized access is ILLEGAL
- Use responsibly and ethically
- Test only on systems you own or have permission to test

---

## 📊 Features At A Glance

✅ Multi-platform (Linux, macOS, Termux, WSL, Windows)  
✅ Two tunnel options (Ngrok + Serveo)  
✅ Three templates (Festival, YouTube, Meeting)  
✅ Automatic IP logging  
✅ Camera screenshot capture  
✅ User-supplied authtoken (no hardcoding)  
✅ Flexible configuration  
✅ Automatic dependency detection  

---

## 📞 Need Help?

| Topic | Resource |
|-------|----------|
| Ngrok Help | https://ngrok.com/docs |
| Serveo Help | https://serveo.net |
| PHP Docs | https://www.php.net/docs.php |
| Bash Help | https://www.gnu.org/software/bash/manual/ |

---

**Version**: CamPhish v1.7 (Production Ready)  
**Status**: ✅ All Features Working  
**Last Updated**: January 30, 2026
