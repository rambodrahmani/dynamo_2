<?php

/*
 * This file is part of DYNAMO.
 *
 * Rambod Rahmani <rambodrahmani@autistici.org>
 * Giacomo Taormina <taorminagiacomo@gmail.com>
 *
 * Copyright (c) DYNAMO 2016. All rights reserved.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

/*
 * auth.php
 *
 * [description]
 */

error_reporting(E_ALL);

require_once('config_redirect.php');

$authentication_type = null;
$client_type = null;
$client_ip = null;
$arp = null;
$client_mac = null;

$authentication_type = mysql_real_escape_string($_GET['authentication_type']);
$client_type = mysql_real_escape_string($_GET['client_type']);
$client_mac = mysql_real_escape_string($_GET['mac_address']);

if($client_mac != null) {
    $client_ip = mysql_real_escape_string($_GET['ip']);
}else{
    $client_ip = mysql_real_escape_string($_SERVER['REMOTE_ADDR']);
    $client_mac = shell_exec("$arp -an " . $client_ip);
    preg_match('/..:..:..:..:..:../', $client_mac , $matches);
    $client_mac = mysql_real_escape_string(@$matches[0]);
}

if ($debugMode == true) {
    echo "Authenticating Client:<br>";
    echo "Client IP: " . $client_ip . "<br>";
    echo "Client MAC: " . $client_mac . "<br>";
    echo "Device Type: " . $client_type . "<br>";
    echo "Authentication Type: " . $authentication_type . "<br>";
}

if($authentication_type == "full"){
   $time = $time_full;
}else{
    $time = $time_download_app;
}

$sql = "
        INSERT INTO	authenticated_devices(ip_address, mac_address, device_type, authentication_end)
		VALUES('$client_ip', '$client_mac', '$client_type', CURRENT_TIMESTAMP + INTERVAL ".$time." MINUTE);
		";

if (mysql_query($sql) !== TRUE) {
    echo "ERROR: " . $sql . "<br>" . mysql_error();
}

mysql_close();

?>
<!DOCTYPE html>
<html lang="eng">
<head>
    <meta charset="UTF-8">
    <title>Boccaccio Club Wi-Fi</title>
</head>

<body>
<header>
</header>

<section>
    <h1>Autenticazione avvenuta con successo.</h1>
</section>

<footer>
    <p>Copyright (c) 2015 Rambod Rahmani - Giacomo Taormina - Leonardo Pellinacci</p>
    <script>window.close();</script>
</footer>
</body>
</html>
