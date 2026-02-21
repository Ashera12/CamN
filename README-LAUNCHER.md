# Ashera12 Universal Tools Launcher

## 🚀 Features

- **Auto-clone** all Ashera12 GitHub repositories
- **Universal support** for Windows/Linux/macOS/Termux
- **One-click installation** and execution
- **Smart dependency management**
- **Auto-update** functionality
- **Interactive menu** with status indicators

## 📦 Supported Tools

| Tool | Description | Status |
|------|-------------|--------|
| **CamN** | Camera Phishing Tool | ✅ Auto-run |
| **MAS** | Microsoft Activation Scripts | ✅ Windows |
| **WIFI** | WiFi DDOS Tool | ✅ Python3 |
| **Termux-UX** | Termux UX Enhancement | ✅ Termux |
| **ShellPhish** | Shell Phishing | ✅ Auto-run |
| **SocialPhish** | Social Media Phishing | ✅ Auto-run |
| **Zphisher** | Advanced Phishing | ✅ Auto-run |
| **Black-Box** | Penetration Testing | ✅ Tools |
| **LazyKali** | Kali Linux Tools | ✅ Scripts |
| **Hax-Windows** | Windows Hacking | ✅ Windows |
| **Android-Hacking** | Android Security | ✅ Mobile |
| **Instagram-Hack** | Instagram Security | ✅ Demo |
| **Facebook-Hack** | Facebook Security | ✅ Demo |
| **Wifi-Hack** | WiFi Security | ✅ Tools |
| **Kali-Tools** | Kali Tool Collection | ✅ Scripts |

## 🛠️ Installation

### Quick Start
```bash
# Download and run
git clone https://github.com/Ashera12/CamN.git
cd CamN
bash ashera12-launcher.sh
```

### Manual Setup
```bash
# Download launcher
curl -O https://raw.githubusercontent.com/Ashera12/CamN/main/ashera12-launcher.sh
chmod +x ashera12-launcher.sh
./ashera12-launcher.sh
```

## 🎯 Usage

### First Run
1. Launcher auto-detects your platform
2. Installs dependencies (git, python3, curl)
3. Clones all repositories
4. Creates workspace directory

### Main Menu
```
🚀 ASHERA12 UNIVERSAL TOOLS LAUNCHER 🚀

📋 Available Tools:

[1] CamN ✅
[2] MAS ✅  
[3] WIFI ✅
[4] Termux-UX ✅
[5] ShellPhish ✅
[6] SocialPhish ✅
[7] Zphisher ✅
[8] Black-Box ✅
[9] LazyKali ✅
[10] Hax-Windows ✅
[11] Android-Hacking ✅
[12] Instagram-Hack ✅
[13] Facebook-Hack ✅
[14] Wifi-Hack ✅
[15] Kali-Tools ✅
[16] 🔄 Update All Tools
[17] 🚪 Exit

🎯 Choose tool [1-17]:
```

### Features

#### ✅ Status Indicators
- **✅** = Tool installed and ready
- **❌** = Tool not yet downloaded

#### 🔄 Auto-Update
- Option 16 updates all tools automatically
- Individual tools update when launched

#### 🌐 Platform Support
- **Windows**: Git Bash, PowerShell, CMD
- **Linux**: All distributions (Ubuntu, Kali, Termux)
- **macOS**: Intel and Apple Silicon
- **Termux**: Android devices

## 🔧 Advanced Usage

### Custom Workspace
```bash
# Set custom workspace directory
export ASHERA12_WORKSPACE="/path/to/tools"
./ashera12-launcher.sh
```

### Add Custom Repositories
Edit the `REPOS` array in the script:
```bash
declare -A REPOS=(
    ["MyTool"]="https://github.com/user/repo.git"
    # ... existing repos
)
```

### Batch Operations
```bash
# Install all tools non-interactively
./ashera12-launcher.sh --install-all

# Update specific tool
./ashera12-launcher.sh --update CamN

# Run specific tool directly
./ashera12-launcher.sh --run CamN
```

## 📁 Directory Structure

```
Ashera12-Tools/
├── CamN/                 # Camera phishing
│   └── CamPhish/
├── MAS/                  # Microsoft Activation
├── WIFI/                 # WiFi DDOS
├── Termux-UX/           # Termux enhancement
├── ShellPhish/          # Shell phishing
├── SocialPhish/         # Social media phishing
├── Zphisher/            # Advanced phishing
├── Black-Box/           # Pen testing
├── LazyKali/            # Kali tools
├── Hax-Windows/         # Windows hacking
├── Android-Hacking/     # Android security
├── Instagram-Hack/      # Instagram demo
├── Facebook-Hack/       # Facebook demo
├── Wifi-Hack/           # WiFi security
├── Kali-Tools/          # Kali collection
└── .setup_complete      # Setup marker
```

## 🐛 Troubleshooting

### Common Issues

#### Git Not Found
```bash
# Install git
sudo apt-get install git           # Linux
brew install git                   # macOS
choco install git                  # Windows
pkg install git                    # Termux
```

#### Python3 Missing
```bash
# Install python3
sudo apt-get install python3       # Linux
brew install python3                # macOS
choco install python                # Windows
pkg install python3                 # Termux
```

#### Permission Denied
```bash
# Make executable
chmod +x ashera12-launcher.sh
```

#### Network Issues
```bash
# Use proxy if needed
export https_proxy=http://proxy:port
./ashera12-launcher.sh
```

### Debug Mode
```bash
# Enable debug logging
DEBUG=1 ./ashera12-launcher.sh
```

## 🤝 Contributing

1. Fork the repository
2. Add your tool to the `REPOS` array
3. Test on multiple platforms
4. Submit pull request

## 📄 License

This project is for educational purposes only. Use responsibly and legally.

## ⚡ Quick Commands

```bash
# Download and run in one command
curl -sSL https://raw.githubusercontent.com/Ashera12/CamN/main/ashera12-launcher.sh | bash

# Or with wget
wget -qO- https://raw.githubusercontent.com/Ashera12/CamN/main/ashera12-launcher.sh | bash
```

## 🎯 One-Click Setup

For instant setup, run:
```bash
bash <(curl -sSL https://raw.githubusercontent.com/Ashera12/CamN/main/ashera12-launcher.sh)
```

This will:
- ✅ Auto-detect your system
- ✅ Install dependencies  
- ✅ Clone all tools
- ✅ Launch interactive menu

---

**Made with ❤️ by Ashera12 | Universal Tool Launcher**
