<? header('Content-Type: application/json; charset=utf-8'); ?>

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
 * dynamo.php
 *
 * [description]
 */

define('TOKEN_ACCESS_INFORMATION', 'DyNaMoApp63t3663');
define('IS_AUTH','IS_AUTH');

error_reporting(E_ALL);

require_once("dynamo_php/config.php");
require_once("function.php");

$token_access = mysql_real_escape_string($_REQUEST['token_access']);
$request_info = mysql_real_escape_string($_REQUEST['request_info']);

$mac = mysql_real_escape_string($_REQUEST['client_mac']);

$arr = array('request' => $request_info, 'result' => NULL , 'status' => 'OK');

if($token_access!=TOKEN_ACCESS_INFORMATION)
    access_denied();

switch ($request_info) {

    case IS_AUTH:
        $arr['result'] = is_auth($mac, $time_download_app);
        break;

    default:
        $arr = array('request' => "NOT_DEFINED", 'result' => NULL , 'status' => 'ERROR');
        break;

}

if($arr!=null)echo json_encode($arr,JSON_UNESCAPED_SLASHES);

?>
