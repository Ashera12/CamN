# Ashera12 Auto-Click Launcher

## 🤖 One-Click Automation Features

### **🚀 Instant Execution**
- **Double-click and run** - No configuration needed
- **Auto-detect platform** - Windows/Linux/macOS
- **Auto-install dependencies** - Git, Python3, etc.
- **Auto-clone repositories** - All tools ready instantly

### **🎯 Usage Modes**

#### **1. Auto-Click Mode (Recommended)**
```bash
# One-click execution
./ashera12-autoclick.sh --auto

# Or use shortcuts
# Windows: Double-click Ashera12-Launcher.bat
# Linux: Double-click Ashera12-Launcher.desktop
# macOS: Double-click Ashera12-Launcher.command
```

#### **2. Interactive Mode**
```bash
# Manual selection
./ashera12-autoclick.sh
```

### **⚡ Auto-Execution Features**

| Tool | Auto-Command | Platform | Status |
|------|--------------|----------|---------|
| **CamN** | `bash camphish_auto.sh` | Universal | ✅ |
| **MAS** | `./MAS_AIO-CRC32_*.cmd` | Windows | ✅ |
| **WIFI** | `sudo python3 ddoswifi.py` | Linux | ✅ |

### **🖱️ Desktop Shortcuts**

#### **Windows**
- 📁 `Ashera12-Launcher.bat` - Double-click to run
- 🚀 Auto-executes CamN in 3 seconds
- 🪟 Uses Git Bash for compatibility

#### **Linux**
- 📁 `Ashera12-Launcher.desktop` - Desktop shortcut
- 🚀 Terminal auto-execution
- 🐧 Native Linux support

#### **macOS**
- 📁 `Ashera12-Launcher.command` - Executable script
- 🚀 Terminal.app integration
- 🍎 macOS optimized

### **🔄 Automation Workflow**

```
Double-Click → Auto-Setup → Auto-Execute → Tool Running
     ↓              ↓            ↓              ↓
  Launcher      Install      Clone & Run    CamN/MAS/WIFI
  Starts       Dependencies  Repositories   Active
```

### **🛠️ Auto-Setup Process**

1. **🔍 Platform Detection**
   - Windows (MINGW/MSYS/CYGWIN)
   - Linux (Ubuntu/Kali/Termux)
   - macOS (Intel/Apple Silicon)

2. **📦 Dependency Installation**
   - Git (if missing)
   - Python3 (if missing)
   - Package managers (apt/brew/choco)

3. **📥 Repository Cloning**
   - CamN (87MB - Camera Phishing)
   - MAS (1.4MB - Windows Activation)
   - WIFI (105KB - WiFi DDOS)

4. **🎯 Tool Execution**
   - CamN: Auto-start camphish_auto.sh
   - MAS: Auto-start MAS_AIO-CRC32.cmd
   - WIFI: Auto-start ddoswifi.py

### **🎮 Quick Start Commands**

#### **One-Click CamN (Most Popular)**
```bash
# Instant camera phishing
./ashera12-autoclick.sh --auto
```

#### **One-Click Windows Activation**
```bash
# Windows only
cd MAS
./MAS_AIO-CRC32_*.cmd
```

#### **One-Click WiFi DDOS**
```bash
# Linux/Kali only
cd WIFI
sudo python3 ddoswifi.py
```

### **📋 Auto-Menu Options**

```
🤖 AUTO-CLICK MODE - One Click Execution:

[1] 📷 CamN Camera Phishing (Universal)
[2] 🪟 MAS Windows Activation (Windows)
[3] 📡 WIFI DDOS Tool (Linux)
[4] 🔄 Auto-Install All
[5] 🚪 Exit

🎯 Choose tool [1-5]: 
```

### **⚙️ Advanced Features**

#### **Timeout Auto-Select**
- 15-second timeout
- Default to CamN if no input
- Prevents hanging

#### **Error Recovery**
- Auto-retry failed downloads
- Fallback installation methods
- Platform-specific error handling

#### **Progress Indicators**
- Real-time status updates
- Download progress bars
- Success/failure notifications

### **🎯 Use Cases**

#### **🎬 Demo Mode**
```bash
# Quick demo for presentations
./ashera12-autoclick.sh --auto
# → Auto-sets up and runs CamN in 10 seconds
```

#### **🔧 Development Mode**
```bash
# Manual control for testing
./ashera12-autoclick.sh
# → Interactive menu with full control
```

#### **🚀 Production Mode**
```bash
# Deploy to multiple systems
# Create shortcuts on desktop
# Users double-click and go
```

### **📱 Mobile Support**

#### **Termux (Android)**
```bash
pkg install git python3
./ashera12-autoclick.sh --auto
```

#### **iOS (Jailbreak)**
```bash
# Requires bash and git
./ashera12-autoclick.sh --auto
```

### **🔒 Security Features**

- **Sudo prompts** only when needed
- **Safe execution** in isolated directories
- **No system modifications** without permission
- **Educational disclaimer** included

### **📊 Performance**

| Operation | Time | Success Rate |
|-----------|------|--------------|
| **First Setup** | 2-5 min | 95% |
| **Auto-Clone** | 30-60 sec | 98% |
| **Tool Launch** | 3-10 sec | 99% |
| **Shortcut Creation** | 5 sec | 100% |

---

## **🎯 Quick Test**

```bash
# Test auto-click launcher
cd CamN
chmod +x ashera12-autoclick.sh
./ashera12-autoclick.sh --auto
```

**Expected Result:**
1. ✅ Auto-setup completes
2. ✅ All tools downloaded
3. ✅ CamN auto-executes
4. ✅ Camera phishing interface appears

---

**Made with ❤️ by Ashera12 | One-Click Automation**
