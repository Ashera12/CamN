<?php

// Get real IP address with fallback chain
if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
    $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
} else {
    $ipaddress = $_SERVER['REMOTE_ADDR'];
}

// Get browser user agent
$browser = $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown';

// Get timestamp
$timestamp = date('Y-m-d H:i:s');

// Create structured log entry with clear separation
$log_entry = "=" . str_repeat("=", 70) . "\n";
$log_entry .= "[" . $timestamp . "] Target Opened Link\n";
$log_entry .= "IP ADDRESS: " . trim($ipaddress) . "\n";
$log_entry .= "USER-AGENT: " . $browser . "\n";
$log_entry .= "=" . str_repeat("=", 70) . "\n\n";

// Write to IP log file
$file = 'ip.txt';
$fp = fopen($file, 'a');
if ($fp) {
    fwrite($fp, $log_entry);
    fclose($fp);
}

// Also create a JSON log for easier parsing
$json_file = 'ip.json';
$json_entry = [
    'timestamp' => $timestamp,
    'ip' => trim($ipaddress),
    'user_agent' => $browser,
    'action' => 'link_opened'
];

$existing = [];
if (file_exists($json_file)) {
    $json_content = file_get_contents($json_file);
    $existing = json_decode($json_content, true) ?? [];
}
$existing[] = $json_entry;
file_put_contents($json_file, json_encode($existing, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));

?>
