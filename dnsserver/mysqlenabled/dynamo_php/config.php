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
 * config.php
 *
 * [description]
 */

$debugMode = true;
$test = true;

$arp = "/usr/sbin/arp";

$time_download_app = 4;
$time_full = 350;

/* DYNAMO LOCAL IP */
define('BASE_URL', '192.168.2.50');

$ipsB['clients3.google.com']['A'] = BASE_URL;
$ipsB['boccaccio.dynamo.ovh']['A'] = BASE_URL;
$ipsB['app.boccaccio.it']['A'] = BASE_URL;
$ipsB['boccaccio.it']['A'] = '213.158.71.126';

$ipsA['boccaccio.dynamo.ovh']['A'] = BASE_URL;

/* DATABASE */
define('DB_SERVER', "localhost");
define('DB_USER', "root");
define('DB_PASSWORD', "raspjack");
define('DB_DATABASE', "dynamo");

$conn = mysql_connect(DB_SERVER, DB_USER, DB_PASSWORD);
if (!$conn) {
	die('Could not connect to MySQL server: ' . mysql_error());
}
$db_selected = mysql_select_db(DB_DATABASE, $conn);
if (!$db_selected) {
	die("Could not set " . DB_DATABASE . mysql_error());
}
mysql_set_charset("utf8");

?>
