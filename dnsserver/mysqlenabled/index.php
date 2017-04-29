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
 * index.php
 *
 * [description]
 */

require_once('config_redirect.php');

/* get info device */
$device = getBrowser();

?>

<html>
    <head>
        <script type="text/javascript" src="js/check_app.js"></script>
        <link rel="stylesheet" href="css/login_style.css" type="text/css">
    </head>
    <body>
        <div class="image_logo"></div>
        <h1>Benvenuto nella rete Wifi Boccaccio Club</h1>

        <h3><i>Reindirizzamento in corso...</i></h3>

        <h1>Scarica l'app Boccaccio Club direttamente dallo store per poter accedere al WiFi.</h1>

        <img src="css/img/play.png" class="button_play" onclick="click_android_redirect_market();"/>

    <script type="text/javascript">
        <?php
        switch ($device['platform']) {
            case "iOS":
                ?>
        check_ios_app();
        <?php
            break;

        case "Android":
        $client_type = "Android";
        $client_ip = mysql_real_escape_string($_SERVER['REMOTE_ADDR']);
        $client_mac = shell_exec("$arp -an " . $client_ip);
        preg_match('/..:..:..:..:..:../', $client_mac , $matches);
        $client_mac = mysql_real_escape_string(@$matches[0]);

		$sql = "
                INSERT INTO	authenticated_devices(ip_address, mac_address, device_type, authentication_end)
                VALUES('$client_ip', '$client_mac', '$client_type', CURRENT_TIMESTAMP + INTERVAL ".$time_download_app." MINUTE);
               ";
		if (mysql_query($sql) !== TRUE) {
			echo "ERROR: " . $sql . "<br>" . mysql_error();
		}

            ?>
        check_android_app();
        <?php
            break;
        default:
            ?>
        window.location.replace("http://www.boccaccio.it/");
        <?php
            break;
        }
        ?>
    </script>
</body>
</html>

