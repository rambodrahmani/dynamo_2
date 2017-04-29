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
 * DNServer.php
 *
 * [description]
 */

class DNServer
{
    var $func;
    var $socket;
    var $types;
    var $localip;

    /*
    **    Function Constructor.
    **    The argument is the name of a function that became
    **     a callback function. See the example
    */
    function DNServer($callback, $ip = NULL)
    {
        //Here we get the local IP
        $this->localip = $ip;

        //Here we get the function name that resolves the IP
        $this->func = $callback;

        //The script should not expire 
        set_time_limit(0);

        //Here we list the types of the Adresses
        $this->types = array(
            "A" => 1,
            "NS" => 2,
            "CNAME" => 5,
            "SOA" => 6,
            "WKS" => 11,
            "PTR" => 12,
            "HINFO" => 13,
            "MX" => 15,
            "TXT" => 16,
            "RP" => 17,
            "SIG" => 24,
            "KEY" => 25,
            "LOC" => 29,
            "NXT" => 30,
            "AAAA" => 28,
            "CERT" => 37,
            "A6" => 38,
            "AXFR" => 252,
            "IXFR" => 251,
            "*" => 255
        );
 
        $this->Begin();
    }
    
    function Begin()
    {
        //Creating the socket
        $this->socket = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);

        //Checking for errors
        if ($this->socket < 0)
        {
        
            printf("Error in line %d", __LINE__ - 3);
            exit();
        }

        if (socket_bind($this->socket, $this->localip, "53") == false)
        {
            printf("Error in line %d", __LINE__ - 2);
            exit();
        }

        //Reading the socket
        while(1)
        {

            $len = socket_recvfrom($this->socket, $buf, 1024 * 4, 0, $ip, $port);
            if ($len > 0)
            {
                $this->HandleQuery($buf, $ip, $port);        
            }    
        }
    }
    
    function HandleQuery($buf, $clientip, $clientport)
    {
        //Here we handle the requests 
        $dominio = "";
        $tmp = substr($buf, 12);
        $e = strlen($tmp);

        for($i = 0; $i < $e; $i++)
        {
            $len = ord($tmp[$i]);
            if ($len == 0)
                break;
            $dominio .= substr($tmp, $i + 1, $len) . ".";
            $i += $len;
        }

        // move two char
        $i++;
        $i++;

        /* Saving the domain name as queried*/
        print $DomainAsQueried;

        //Searching ...
        $querytype = array_search((string)ord($tmp[$i]), $this->types) ;

        //Getting all the domain but last character
        $dominio = substr($dominio, 0, strlen($dominio) - 1);
        $callback = $this->func;
        $ips = $callback($dominio, $querytype, $clientip);

        //Generate the answer
        $answ = $buf[0].$buf[1].chr(129).chr(128).$buf[4].$buf[5].$buf[4].$buf[5].chr(0).chr(0).chr(0).chr(0);
        $answ .= $tmp;
        $answ .= chr(192).chr(12);
        $answ .= chr(0).chr(1).chr(0).chr(1).chr(0).chr(0).chr(0).chr(60).chr(0).chr(4);
        $answ .= $this->TransformIP($ips);

             //Check if tehre is some error

        if (socket_sendto($this->socket,$answ, strlen($answ), 0, $clientip, $clientport) === false)
            printf("Error in socket\n");             
    }
    
    function TransformIP($ip)
    {
        //Transforms the IP
        $nip = "";
        foreach(explode(".",$ip) as $pip)
            $nip .= chr($pip);

        return $nip;
    }
}

?>
