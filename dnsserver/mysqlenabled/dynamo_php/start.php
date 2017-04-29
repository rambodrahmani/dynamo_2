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

foreach($ipsA as $domain=>$ip) {
	$ipsA['www.' . $domain]['A'] = $ip['A'];
}
foreach($ipsB as $domain=>$ip) {
	$ipsB['www.' . $domain]['A'] = $ip['A'];
}

function dnshandler($dominio, $tipo, $client_ip)
{

	echo "\n";

	include 'config.php';

	$arp = "/usr/sbin/arp";
	$client_mac = shell_exec("sudo $arp -an " . $client_ip);
	preg_match('/..:..:..:..:..:../', $client_mac , $matches);
	$client_mac = @$matches[0];

	if ($debugMode) {
		echo "New Request\n";
		echo "Type: " . $tipo . "\n";
		echo "Client IP: " . $client_ip . "\n";
		echo "Client MAC: " . $client_mac . "\n";
		echo "Domain: " . $dominio . "\n";
	}

	$sql = "
			SELECT *
			FROM authenticated_devices
			WHERE mac_address = '".$client_mac."'
				and authentication_end >= CURRENT_TIMESTAMP
			LIMIT 1;
			";

	$rs = mysql_query($sql);

	/*
     * CHECK IF DEVICE IS AUTHENTICATED
     */
	if(mysql_num_rows($rs) == 0)
	{
		/************************* NOT AUTHENTICATED **********************************/

		echo "Not authenticated ";

		global $ipsB;
		if (isset($ipsB[$dominio][$tipo]))
		{
			echo "Redirect cached internal. \n";
			// RETURN IP
			return $ipsB[$dominio][$tipo];
		}

		return BASE_URL;

		/************************* END NOT AUTHENTICATED ******************************/
	}
	else
	{
		caching:
		/*
         * CACHING DNS
         */

		global $ipsA;
		if (isset($ipsA[$dominio][$tipo]))
		{
			echo "Redirect cached internal. \n";
			/* RETURN IP */
			return $ipsA[$dominio][$tipo];
		}
		else
		{
			$dominio = mysql_real_escape_string($dominio);

			$sql = "
						SELECT *
						FROM cached_records
						WHERE domain = '".$dominio."';
						";
			$rs = mysql_query($sql);

			if ($rs->num_rows == 0)
			{
				if ($debugMode)
				{
					echo "Not cached. Resolving... ";
				}

				$result = gethostbyname($dominio);
				$result = mysql_real_escape_string($result);

				$sql = "
							INSERT INTO cached_records (domain,ip)
						  	VALUES('".$dominio."', '".$result."');
							";

				$rs = mysql_query($sql);
				echo ($rs)? "cached.\n":"error caching.\n";

				/* RETURN IP */
				return $result;
			}
			else
			{
				if ($debugMode)
				{
					echo "Just cached.\n";
				}

				$obj = mysql_fetch_object($rs);

				/* RETURN IP */
				return $obj->ip;
			}
		}
	}
}

$dns = new DNServer("dnshandler" /* callback function */, BASE_URL);

?>
