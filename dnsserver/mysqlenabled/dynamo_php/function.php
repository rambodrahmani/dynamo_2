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

function redirect($url){
    header("Location: ".$url, TRUE, 302); 
    exit;
}

function getBrowser()
{
    $u_agent = $_SERVER['HTTP_USER_AGENT'];
    $bname = 'Unknown';
    $platform = 'Unknown';
    $version = "";
    $family = "Unknown";
    $model = "Unknown";
    $build = "Unknown";
    $ub = "Unknown";

    if (preg_match('/Android/i', $u_agent)) {
        $platform = 'Android';
    } elseif (preg_match('/iPod/i', $u_agent)) {
        $platform = 'iOS';
    } elseif (preg_match('/iPhone/i', $u_agent)) {
        $platform = 'iOS';
    } elseif (preg_match('/iPad/i', $u_agent)) {
        $platform = 'iOS';
    } elseif (preg_match('/linux/i', $u_agent)) {
        $platform = 'linux';
    } elseif (preg_match('/macintosh|mac os x/i', $u_agent)) {
        $platform = 'mac';
    }

    if (preg_match('/MSIE/i', $u_agent) && !preg_match('/Opera/i', $u_agent)) {
        $bname = 'Internet Explorer';
        $ub = "MSIE";
    } elseif (preg_match('/Firefox/i', $u_agent)) {
        $bname = 'Mozilla Firefox';
        $ub = "Firefox";
    } elseif (preg_match('/Chrome/i', $u_agent)) {
        $bname = 'Google Chrome';
        $ub = "Chrome";
    } elseif (preg_match('/Safari/i', $u_agent)) {
        $bname = 'Apple Safari';
        $ub = "Safari";
    } elseif (preg_match('/Opera/i', $u_agent)) {
        $bname = 'Opera';
        $ub = "Opera";
    } elseif (preg_match('/Netscape/i', $u_agent)) {
        $bname = 'Netscape';
        $ub = "Netscape";
    } else {
        $bname = 'App';
    }

    $a = explode(")", $u_agent);
    $b = explode("(", $a[0]);
    $c = explode(";", $b[1]);
    $family = $c[0];
    if ($bname == 'App') {
        $d = explode(" ", $c[2]);
        $version = $d[2];
        $e = explode(" ", $c[3]);
        $model = $e[1];
        $f = explode("/", $e[2]);
        $build = $f[1];
    } else {
        $model = $c[1];
        $known = array('Version', $ub, 'other');
        $pattern = '#(?<browser>' . join('|', $known) . ')[/ ]+(?<version>[0-9.|a-zA-Z.]*)#';
        if (!preg_match_all($pattern, $u_agent, $matches)) {
            // we have no matching number just continue
        }

        // see how many we have
        $i = count($matches['browser']);
        if ($i != 1) {
            //we will have two since we are not using 'other' argument yet
            //see if version is before or after the name
            if (strripos($u_agent, "Version") < strripos($u_agent, $ub)) {
                $version = $matches['version'][0];
            } else {
                $version = $matches['version'][1];
            }
        } else {
            $version = $matches['version'][0];
        }

        // check if we have a number
        if ($version == null || $version == "") {
            $version = "?";
        }
    }

    return array(
        'browser_name' => $bname,
        'family' => $family,
        'platform' => $platform,
        'version' => $version,
        'model' => $model,
        'build' => $build
    );
}

?>
