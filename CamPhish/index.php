<?php
include 'ip.php';

// Check if page is being viewed vs redirecting
$debug_mode = isset($_GET['debug']) ? true : false;

if (!$debug_mode) {
    // Normal flow: redirect to the actual page
    header('Location: index2.html');
    exit;
} else {
    // Debug mode: show information about the redirect
    echo "<html><head><title>Link Preview</title><style>";
    echo "body { font-family: Arial, sans-serif; padding: 20px; background-color: #f0f0f0; }";
    echo ".container { background-color: white; padding: 20px; border-radius: 5px; max-width: 600px; margin: 0 auto; }";
    echo "h1 { color: #333; }";
    echo ".info { background-color: #e8f4f8; padding: 10px; border-left: 4px solid #0066cc; margin: 10px 0; }";
    echo "code { background-color: #f5f5f5; padding: 2px 6px; border-radius: 3px; font-family: 'Courier New', monospace; }";
    echo ".success { color: #008000; font-weight: bold; }";
    echo "</style></head><body>";
    echo "<div class='container'>";
    echo "<h1><span class='success'>✓ Link Active</span></h1>";
    echo "<div class='info'>";
    echo "<strong>Status:</strong> Link berhasil dibuat dan siap digunakan<br>";
    echo "<strong>IP Tracker:</strong> Active<br>";
    echo "<strong>Timestamp:</strong> " . date('Y-m-d H:i:s') . "<br>";
    echo "</div>";
    echo "<p><strong>Halaman akan redirect dalam 3 detik...</strong></p>";
    echo "<p>Jika tidak redirect, <a href='index2.html'>klik di sini</a></p>";
    echo "<script>setTimeout(function() { window.location.href='index2.html'; }, 3000);</script>";
    echo "</div></body></html>";
}

?>
