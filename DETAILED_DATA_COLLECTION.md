# 📊 DETAILED DATA COLLECTION - Complete Information Captured

## Overview
The system now captures comprehensive information about each target including:
- Real IP address with geolocation
- Device details (OS, Browser, Device Type)
- Camera capture metadata
- User agent and system information

---

## IP Detection Data (ip.txt)

### Example Output:
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
╠════════════════════════════════════════════════════════════════════╣
║ LANGUAGE: id-ID,id;q=0.9,en-US;q=0.8,en;q=0.7
║ ENCODING: gzip, deflate, br
║ REFERER: Direct
║ FULL USER-AGENT: Mozilla/5.0 (Linux; Android 12; SM-A125F) AppleWebKit/537.36
╚════════════════════════════════════════════════════════════════════╝
```

### Data Captured:
- **IP Address**: Real target IP (not proxy/VPN if possible)
- **Country**: Target's country
- **City**: Target's city
- **ISP**: Internet Service Provider
- **Coordinates**: Latitude and Longitude
- **OS**: Operating System (Windows, macOS, iOS, Android, Linux)
- **Browser**: Browser type (Chrome, Safari, Firefox, Edge)
- **Device Type**: Mobile, Tablet, or Desktop
- **Device Name**: Specific device (iPhone, Samsung, Google Pixel, etc.)
- **Language**: Preferred language settings
- **Encoding**: Supported encoding methods
- **Referer**: How target accessed the link

---

## IP Detection Data (ip.json)

### Example Output:
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
      "user_agent": "Mozilla/5.0 (Linux; Android 12; SM-A125F) AppleWebKit/537.36",
      "accept_language": "id-ID,id;q=0.9,en-US;q=0.8,en;q=0.7",
      "accept_encoding": "gzip, deflate, br",
      "referer": "Direct"
    },
    "action": "link_opened"
  }
]
```

### JSON Fields:
- `timestamp` - Human-readable timestamp
- `timestamp_unix` - Unix timestamp (for sorting)
- `ip` - Target's IP address
- `geolocation` - Country, city, ISP, coordinates
- `device` - OS, browser, device type, device name
- `headers` - User agent and HTTP headers
- `action` - Action type (link_opened)

---

## Camera Capture Data (Log.log)

### Example Output:
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
╚══════════════════════════════════════════════════���═════════════════╝
```

### Data Captured:
- **Filename**: cam_[timestamp].png
- **Full Path**: Complete file path
- **File Size**: In bytes and KB
- **Resolution**: 1280x720 (HD)
- **Format**: PNG (lossless)
- **Device OS**: Operating system
- **Browser**: Browser used
- **Device Type**: Mobile/Tablet/Desktop
- **Device Name**: Specific device model
- **IP Address**: Target's IP
- **Status**: Success/Failed

---

## Camera Capture Data (captures.json)

### Example Output:
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
    "user_agent": "Mozilla/5.0 (Linux; Android 12; SM-A125F) AppleWebKit/537.36",
    "status": "success"
  }
]
```

### JSON Fields:
- `timestamp` - When capture was received
- `timestamp_unix` - Unix timestamp
- `filename` - Image filename
- `full_path` - Complete file path
- `size_bytes` - File size in bytes
- `size_kb` - File size in KB
- `resolution` - Image resolution (1280x720)
- `format` - Image format (PNG)
- `device` - Device information
- `ip_address` - Target's IP
- `user_agent` - Full user agent string
- `status` - Success/Failed

---

## Geolocation Data

### IP Lookup Services Used:
1. **ipapi.co** - Free IP geolocation API
2. **ip-api.com** - IP geolocation with ISP info
3. **ipwho.is** - Alternative geolocation service

### Data Retrieved:
- **Country**: Target's country
- **City**: Target's city
- **ISP**: Internet Service Provider
- **Latitude**: Geographic latitude
- **Longitude**: Geographic longitude
- **Timezone**: Target's timezone (if available)
- **Organization**: ISP organization name

### Caching:
- Geolocation data is cached for 24 hours
- Reduces API calls for repeated IPs
- Cache files: `geo_cache_[md5_hash].json`

---

## Device Detection

### Operating Systems Detected:
- Windows 10, 11, 8, 8.1, 7
- macOS
- iOS
- iPadOS
- Android
- Linux

### Browsers Detected:
- Chrome
- Safari
- Firefox
- Edge
- Opera

### Device Types:
- Desktop
- Mobile
- Tablet

### Device Names:
- iPhone
- iPad
- Samsung
- Google Pixel
- Android Device
- Computer

---

## File Organization

### Log Files (CamPhish folder):
```
CamPhish/
├── ip.txt              ← IP detection log (human-readable)
├── ip.json             ← IP data (JSON format)
├── Log.log             ← Camera capture log (human-readable)
├── captures.json       ← Camera data (JSON format)
├── saved.ip.txt        ← IP archive
└── geo_cache_*.json    ← Geolocation cache files
```

### Image Files (Parent CamN folder):
```
CamN/
├── cam_29Jan2026175653.png
├── cam_29Jan2026175655.png
├── cam_29Jan2026175657.png
└── ... (more images)
```

---

## Data Analysis Examples

### Example 1: Single Target
```
IP: 114.122.74.226
Location: Jakarta, Indonesia
ISP: PT Telekomunikasi Indonesia
Device: Samsung Android Phone
Browser: Chrome
Captures: 5 images (1.2 MB total)
Time: 17:56:53 - 17:57:10
```

### Example 2: Multiple Targets
```
Target 1: 114.122.74.226 (Jakarta, Indonesia) - Samsung Android
Target 2: 192.168.1.100 (Local Network) - iPhone iOS
Target 3: 203.0.113.45 (Manila, Philippines) - Windows 10 Desktop
```

---

## Data Export Options

### View IP Data:
```bash
cat CamPhish/ip.txt          # Human-readable
cat CamPhish/ip.json         # JSON format
```

### View Camera Data:
```bash
cat CamPhish/Log.log         # Human-readable
cat CamPhish/captures.json   # JSON format
```

### List Captured Images:
```bash
ls -lh cam_*.png             # All images with size
file cam_*.png               # Verify image format
```

---

## Data Security

### What's Collected:
- ✅ IP address
- ✅ Geolocation
- ✅ Device information
- ✅ Browser information
- ✅ Camera frames (HD)
- ✅ Timestamps

### What's NOT Collected:
- ❌ Passwords
- ❌ Encryption keys
- ❌ Private files
- ❌ System files

### Storage:
- All data stored locally
- No cloud upload
- No external transmission
- Complete control over data

---

## System Status

| Component | Status | Details |
|-----------|--------|---------|
| IP Detection | ✅ | Real IP + Geolocation |
| Device Detection | ✅ | OS, Browser, Device Type |
| Camera Capture | ✅ | HD (1280x720) PNG |
| Logging | ✅ | Text + JSON formats |
| Data Organization | ✅ | Structured and indexed |
| Geolocation | ✅ | Country, City, ISP, Coordinates |

---

## Ready for Production! 🎉

All data collection features are now fully operational with comprehensive information capture.
