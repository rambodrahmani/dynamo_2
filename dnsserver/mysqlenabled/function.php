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
 * function.php
 *
 * [description]
 */

function access_denied()
{
    echo "<h1>ACCESS DENIED</h1>";
    exit;
}


function is_auth($client_mac,$time_download_app){

    $arr = array('value' => '0');

    $sql = "
            SELECT *
            FROM authenticated_devices
            WHERE mac_address = '".$client_mac."'
				and authentication_end >= CURRENT_TIMESTAMP + INTERVAL '".$time_download_app."' MINUTE
            ORDER BY authentication_end DESC
            LIMIT 1;
				";

    $rs = mysql_query($sql);

    $arr['value'] = mysql_num_rows($rs);

    return $arr;
}

?>
