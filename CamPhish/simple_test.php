<?php
require 'ip.php';

$test_ip = "114.122.74.226";
echo "Testing IP: $test_ip\n";

$geo = get_ip_geolocation($test_ip);

echo "Country: " . $geo['country'] . "\n";
echo "City: " . $geo['city'] . "\n";
echo "ISP: " . $geo['isp'] . "\n";
echo "Org: " . $geo['organization'] . "\n";
echo "Lat: " . $geo['latitude'] . "\n";
echo "Lon: " . $geo['longitude'] . "\n";
?>
