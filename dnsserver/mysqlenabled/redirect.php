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
 * redirect.php
 *
 * [description]
 */

require_once('config_redirect.php');

/* Check if device have Android 5 and return Android 5 login page */
if (strpos($device['model'], "Android 5") !== FALSE) {
    include 'login_page_android_5.php';
} else {
    header("Location: index.php", TRUE, 302);
}
exit;

?>