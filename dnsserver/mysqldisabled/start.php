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
 * start.php
 *
 * [description]
 */

error_reporting(E_ERROR | E_WARNING | E_PARSE);

require_once('DNServer.php');
require_once('function.php');
require_once('config.php');

foreach($ips as $domain=>$ip)
{
	$ips['www.' . $domain]['A'] = $ip['A'];
}

function dnshandler($dominio, $tipo, $client_ip)
{

	$arp = null;
	$client_mac = null;

	echo "\n";

	include 'config.php';

	$arp = "/usr/sbin/arp";
	$client_mac = shell_exec("sudo $arp -an " . $client_ip);
	preg_match('/..:..:..:..:..:../', $client_mac , $matches);
	$client_mac = @$matches[0];

	if ($debugMode) {
		echo "New Request\n";
		echo "Client IP: " . $client_ip . "\n";
	    echo "Client MAC: " . $client_mac . "\n";
	    echo "Domain: " . $dominio . "\n";
	}

	/*
	 * CHECK IF DEVICE IS AUTHENTICATED
	 */
	{

		/* REDIRECT */
		echo "Not authenticated. Redirecting.\n";

		if($dominio == BASE_URL_DYNAMO_DOMAIN)
		{
			return BASE_URL_DYNAMO_SERVER;
		}

		/* RETURN IP */
		return BASE_URL;
	}


	{
		/*
		 * CACHING DNS
		 */

		global $ips;
		if (isset($ips[$dominio][$tipo]))
		{
			echo "Redirect cached internal. \n";
			/* RETURN IP */
			return $ips[$dominio][$tipo];
		}
		else 
		{
			if ($debugMode)
			{
				echo "Not cached. Resolving... ";
			}

			$result = gethostbyname($dominio);

			/* RETURN IP */
			return $result;
		}
	}

	return null;
}

$dns = new DNServer("dnshandler" /* callback function */, BASE_URL);

?>