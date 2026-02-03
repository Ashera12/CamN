# ⚡ QUICK TEST GUIDE - Camera Capture & IP Detection

## 🚀 Quick Start Test

### Step 1: Start System
```bash
cd c:\Users\Irga\git irga\CamN\CamPhish
bash camphish_auto.sh
```

### Step 2: Select Template
Choose: **3** (Online Meeting - Recommended)

### Step 3: Get Public Link
Copy the URL shown in the box

### Step 4: Open Link on Target Device
- Use **real device** (phone, laptop, etc.)
- NOT localhost (127.0.0.1)
- Must be different network/device

### Step 5: Allow Camera Permission
- Click "Allow" when browser asks for camera
- Wait 3-5 seconds for capture

### Step 6: Check Monitor Output
Watch for:
```
✅ TARGET DETECTED
   IP: [actual IP address]
   
📷 CAMERA CAPTURED
   File: cam_*.png
```

---

## ✅ Verification Checklist

### IP Detection
- [ ] IP shows in monitor (not blank)
- [ ] IP is NOT 127.0.0.1 or ::1
- [ ] IP is actual target device
- [ ] Check: `cat CamPhish/ip.txt`

### Camera Capture
- [ ] Monitor shows "CAMERA CAPTURED"
- [ ] File exists: `ls -la cam_*.png`
- [ ] File size > 100KB
- [ ] File is readable image

### Log Files
- [ ] `CamPhish/ip.txt` - IP log exists
- [ ] `CamPhish/ip.json` - IP data exists
- [ ] `CamPhish/Log.log` - Camera log exists
- [ ] `CamPhish/captures.json` - Capture data exists

### Image Files
- [ ] `cam_*.png` in parent CamN folder
- [ ] Multiple images if waited longer
- [ ] Images are valid PNG files

---

## 🔍 Quick Diagnostics

### Check IP Detection
```bash
cat CamPhish/ip.txt
cat CamPhish/ip.json
```

### Check Camera Capture
```bash
cat CamPhish/Log.log
cat CamPhish/captures.json
ls -lh cam_*.png
```

### Check File Permissions
```bash
ls -la CamPhish/
ls -la ../
```

### Check PHP Errors
```bash
tail -f php.log
```

---

## ⚠️ Common Issues & Fixes

### Issue: IP Showing Blank
**Fix**:
1. Use real device (not localhost)
2. Check: `cat CamPhish/ip.txt`
3. Verify IP is not 127.0.0.1

### Issue: Camera Not Detected
**Fix**:
1. Wait 5+ seconds after allowing camera
2. Check: `ls -la cam_*.png`
3. Check: `cat CamPhish/Log.log`
4. Verify file permissions: `chmod 777 CamPhish/`

### Issue: File Not Saving
**Fix**:
1. Check permissions: `chmod 777 ../`
2. Check disk space: `df -h`
3. Check PHP errors: `tail php.log`

### Issue: Monitor Not Showing Notifications
**Fix**:
1. Verify Log.log is created
2. Check monitor is running
3. Try Ctrl+C and restart

---

## 📊 Expected Output

### Monitor Display - IP Detection
```
���═════════════��══════════════════════════════════════════════╗
║                    ✅ TARGET DETECTED ✅                    ║
║                                                            ║
║  [+] TARGET IP: 192.168.1.100                             ║
║  [+] Timestamp: 2024-01-29 17:56:53                       ║
║  [+] Status: Link Opened - Waiting for Camera             ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

### Monitor Display - Camera Capture
```
╔════════════════════════════════════════════════════════════╗
║                  📷 CAMERA CAPTURED 📷                    ║
║                                                            ║
║  [✓] File: cam_29Jan2026175653.png                        ║
║  [✓] Size: 245KB                                          ║
║  [✓] Location: ../cam_*.png (Parent CamN folder)          ║
║  [✓] Timestamp: 2024-01-29 17:56:53                       ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
```

### File Structure After Test
```
CamN/
├── CamPhish/
│   ├── ip.txt (IP log)
│   ├── ip.json (IP data)
│   ├── Log.log (Camera log)
│   └── captures.json (Capture data)
├── cam_29Jan2026175653.png ✅
├── cam_29Jan2026175655.png ✅
└── cam_29Jan2026175657.png ✅
```

---

## 🎯 Success Criteria

✅ **IP Detection Working**
- IP shows in monitor
- IP is real target device
- IP is not localhost

✅ **Camera Capture Working**
- Monitor shows "CAMERA CAPTURED"
- Image file exists in CamN folder
- File size > 100KB
- Image is valid PNG

✅ **Logging Working**
- All log files created
- JSON data properly formatted
- Timestamps accurate

---

## 📝 Test Report Template

```
Test Date: _______________
Target Device: _______________
Network: _______________

IP Detection:
  - IP Shown: _______________
  - Is Real IP: YES / NO
  - Is Localhost: YES / NO

Camera Capture:
  - Monitor Notification: YES / NO
  - File Created: YES / NO
  - File Size: _______________
  - File Valid: YES / NO

Logs:
  - ip.txt: YES / NO
  - ip.json: YES / NO
  - Log.log: YES / NO
  - captures.json: YES / NO

Overall Status: ✅ PASS / ❌ FAIL
```

---

## 🚨 Emergency Troubleshooting

### If Nothing Works
1. Stop system: `Ctrl+C`
2. Clear logs: `rm -f CamPhish/ip.* CamPhish/Log.log CamPhish/captures.json`
3. Check permissions: `chmod 777 CamPhish/ ../`
4. Restart: `bash camphish_auto.sh`

### If Still Not Working
1. Check PHP: `php -v`
2. Check SSH: `ssh -V`
3. Check curl: `curl --version`
4. Check permissions: `ls -la CamPhish/`

---

**System Ready for Testing!** 🎉
