# 📋 DATA VIEWING GUIDE - How to Access Collected Information

## Quick Commands

### View IP Detection Log (Human-Readable)
```bash
cat CamPhish/ip.txt
```

**Output Example:**
```
╔════════════════════════════════════════════════════════════════════╗
║ [2024-01-29 17:56:53] TARGET LINK OPENED
╠════════════════════════════════════════════════════════════════════╣
║ IP ADDRESS: 114.122.74.226
║ GEOLOCATION: Indonesia | Jakarta | PT Telekomunikasi Indonesia
║ COORDINATES: Lat -6.2088 | Lon 106.8456
╠════════════════════════════════════════════════════════════════════╣
║ DEVICE INFO:
║   OS: Android
║   BROWSER: Chrome
║   DEVICE TYPE: Mobile
║   DEVICE NAME: Samsung
╠═══════════════════���════════════════════════════════════════════════╣
║ LANGUAGE: id-ID,id;q=0.9
║ ENCODING: gzip, deflate, br
║ REFERER: Direct
║ FULL USER-AGENT: Mozilla/5.0 (Linux; Android 12; SM-A125F)
╚════════════════════════════════════════════════════════════════════╝
```

---

### View IP Detection Data (JSON Format)
```bash
cat CamPhish/ip.json
```

**Output Example:**
```json
[
  {
    "timestamp": "2024-01-29 17:56:53",
    "timestamp_unix": 1706547413,
    "ip": "114.122.74.226",
    "geolocation": {
      "country": "Indonesia",
      "city": "Jakarta",
      "isp": "PT Telekomunikasi Indonesia",
      "latitude": "-6.2088",
      "longitude": "106.8456"
    },
    "device": {
      "os": "Android",
      "browser": "Chrome",
      "device_type": "Mobile",
      "device_name": "Samsung"
    },
    "headers": {
      "user_agent": "Mozilla/5.0 (Linux; Android 12; SM-A125F)",
      "accept_language": "id-ID,id;q=0.9",
      "accept_encoding": "gzip, deflate, br",
      "referer": "Direct"
    },
    "action": "link_opened"
  }
]
```

---

### View Camera Capture Log (Human-Readable)
```bash
cat CamPhish/Log.log
```

**Output Example:**
```
╔════════════════════════════════════════════════════════════════════╗
║ [2024-01-29 17:56:58] CAMERA CAPTURE RECEIVED
╠════════════════════════════════════════════════════════════════════╣
║ FILE: cam_29Jan2026175658.png
║ PATH: c:\Users\Irga\git irga\CamN\cam_29Jan2026175658.png
║ SIZE: 245632 bytes (239.88 KB)
║ RESOLUTION: 1280x720 (HD)
║ FORMAT: PNG (Lossless)
╠════════════════════════════════════════════════════════════════════╣
║ DEVICE INFO:
║   OS: Android
║   BROWSER: Chrome
║   DEVICE TYPE: Mobile
║   DEVICE NAME: Samsung
║ IP ADDRESS: 114.122.74.226
║ STATUS: SUCCESS
╚══════════════════════════════════════════════════════════════��═════╝
```

---

### View Camera Capture Data (JSON Format)
```bash
cat CamPhish/captures.json
```

**Output Example:**
```json
[
  {
    "timestamp": "2024-01-29 17:56:58",
    "timestamp_unix": 1706547418,
    "filename": "cam_29Jan2026175658.png",
    "full_path": "c:\\Users\\Irga\\git irga\\CamN\\cam_29Jan2026175658.png",
    "size_bytes": 245632,
    "size_kb": 239.88,
    "resolution": "1280x720",
    "format": "PNG",
    "device": {
      "os": "Android",
      "browser": "Chrome",
      "device_type": "Mobile",
      "device_name": "Samsung"
    },
    "ip_address": "114.122.74.226",
    "user_agent": "Mozilla/5.0 (Linux; Android 12; SM-A125F)",
    "status": "success"
  }
]
```

---

### List All Captured Images
```bash
ls -lh cam_*.png
```

**Output Example:**
```
-rw-r--r-- 1 user group 239K Jan 29 17:56 cam_29Jan2026175653.png
-rw-r--r-- 1 user group 241K Jan 29 17:56 cam_29Jan2026175655.png
-rw-r--r-- 1 user group 238K Jan 29 17:56 cam_29Jan2026175657.png
-rw-r--r-- 1 user group 240K Jan 29 17:56 cam_29Jan2026175659.png
-rw-r--r-- 1 user group 239K Jan 29 17:56 cam_29Jan2026175661.png
```

---

### Verify Image Format
```bash
file cam_*.png
```

**Output Example:**
```
cam_29Jan2026175653.png: PNG image data, 1280 x 720, 8-bit/color RGBA, non-interlaced
cam_29Jan2026175655.png: PNG image data, 1280 x 720, 8-bit/color RGBA, non-interlaced
cam_29Jan2026175657.png: PNG image data, 1280 x 720, 8-bit/color RGBA, non-interlaced
```

---

### Count Total Captures
```bash
ls -1 cam_*.png | wc -l
```

**Output Example:**
```
5
```

---

### Calculate Total Data Size
```bash
du -sh cam_*.png
```

**Output Example:**
```
1.2M    total
```

---

## Data Summary Commands

### Get Latest IP Entry
```bash
tail -20 CamPhish/ip.txt
```

### Get Latest Camera Capture
```bash
tail -20 CamPhish/Log.log
```

### Count Total Targets
```bash
grep -c "TARGET LINK OPENED" CamPhish/ip.txt
```

### Count Total Captures
```bash
grep -c "CAMERA CAPTURE RECEIVED" CamPhish/Log.log
```

---

## Data Analysis

### Extract All IPs
```bash
grep "IP ADDRESS:" CamPhish/ip.txt | cut -d' ' -f3
```

### Extract All Countries
```bash
grep "GEOLOCATION:" CamPhish/ip.txt | cut -d'|' -f1 | cut -d' ' -f3-
```

### Extract All Devices
```bash
grep "DEVICE NAME:" CamPhish/ip.txt | cut -d' ' -f4-
```

### Extract All Operating Systems
```bash
grep "OS:" CamPhish/ip.txt | cut -d' ' -f3-
```

---

## JSON Data Processing

### Pretty Print IP JSON
```bash
python3 -m json.tool CamPhish/ip.json
```

### Pretty Print Captures JSON
```bash
python3 -m json.tool CamPhish/captures.json
```

### Extract All IPs from JSON
```bash
python3 -c "import json; data=json.load(open('CamPhish/ip.json')); print('\n'.join([d['ip'] for d in data]))"
```

### Extract All Countries from JSON
```bash
python3 -c "import json; data=json.load(open('CamPhish/ip.json')); print('\n'.join([d['geolocation']['country'] for d in data]))"
```

---

## Data Organization

### All Log Files
```
CamPhish/
├── ip.txt              ← All IP detections (human-readable)
├── ip.json             ← All IP detections (JSON)
├── Log.log             ← All camera captures (human-readable)
├── captures.json       ← All camera captures (JSON)
├── saved.ip.txt        ← IP archive
└── geo_cache_*.json    ← Geolocation cache
```

### All Image Files
```
CamN/
├── cam_29Jan2026175653.png
├── cam_29Jan2026175655.png
├── cam_29Jan2026175657.png
└── ... (more images)
```

---

## Data Backup

### Backup All Data
```bash
tar -czf backup_$(date +%Y%m%d_%H%M%S).tar.gz CamPhish/ cam_*.png
```

### Backup Only Logs
```bash
tar -czf logs_$(date +%Y%m%d_%H%M%S).tar.gz CamPhish/*.txt CamPhish/*.json
```

### Backup Only Images
```bash
tar -czf images_$(date +%Y%m%d_%H%M%S).tar.gz cam_*.png
```

---

## Data Cleanup

### Remove Old Logs (Keep Last 7 Days)
```bash
find CamPhish/ -name "*.log" -mtime +7 -delete
```

### Remove Old Images (Keep Last 7 Days)
```bash
find . -name "cam_*.png" -mtime +7 -delete
```

### Clear All Data
```bash
rm -f CamPhish/ip.txt CamPhish/ip.json CamPhish/Log.log CamPhish/captures.json cam_*.png
```

---

## Data Export

### Export to CSV (IPs)
```bash
echo "IP,Country,City,ISP,OS,Browser,Device" > targets.csv
python3 -c "import json; data=json.load(open('CamPhish/ip.json')); [print(f\"{d['ip']},{d['geolocation']['country']},{d['geolocation']['city']},{d['geolocation']['isp']},{d['device']['os']},{d['device']['browser']},{d['device']['device_name']}\") for d in data]" >> targets.csv
```

### Export to CSV (Captures)
```bash
echo "Timestamp,Filename,Size_KB,OS,Browser,Device,IP" > captures.csv
python3 -c "import json; data=json.load(open('CamPhish/captures.json')); [print(f\"{d['timestamp']},{d['filename']},{d['size_kb']},{d['device']['os']},{d['device']['browser']},{d['device']['device_name']},{d['ip_address']}\") for d in data]" >> captures.csv
```

---

## Real-Time Monitoring

### Watch IP Log Updates
```bash
tail -f CamPhish/ip.txt
```

### Watch Camera Log Updates
```bash
tail -f CamPhish/Log.log
```

### Monitor New Images
```bash
watch -n 1 'ls -lh cam_*.png | tail -5'
```

---

## System Status

| Data Type | Location | Format | Status |
|-----------|----------|--------|--------|
| IP Detection | ip.txt | Text | ✅ |
| IP Data | ip.json | JSON | ✅ |
| Camera Log | Log.log | Text | ✅ |
| Camera Data | captures.json | JSON | ✅ |
| Images | cam_*.png | PNG | ✅ |
| Geolocation | geo_cache_*.json | JSON | ✅ |

---

**All data collection and viewing features are fully operational!** 🎉
