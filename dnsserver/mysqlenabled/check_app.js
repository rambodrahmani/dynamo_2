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
 * check_app.js
 *
 * [description]
 */

var custom = "boccaccioclubandroid://?code=boccaccioAndroidAppVerified";
var alt = "market://details?id=com.boccaccioclub.samantha";
var g_intent = "intent://scan/#Intent;scheme=boccaccioclubandroid;package=com.boccaccioclub.samantha;end";

function check_ios_app()
{
    window.location.replace("iOSBoccaccioApp://?boccaccioIosAppVerified");
    window.setTimeout(
        function(){
            window.location.replace("https://itunes.apple.com/it/app/id950398450");
        }
        ,5000);
}

function check_android_app() {
    var timer;
    var heartbeat;
    var iframe_timer;
    var forceInterval2;

    function clearTimers() {
        clearTimeout(timer);
        clearTimeout(heartbeat);
        clearTimeout(iframe_timer);
        clearTimeout(forceInterval2);
        console.log("cancel timers");
    }

    function intervalHeartbeat() {
        if (document.webkitHidden || document.hidden) {
            clearTimers();
        }
    }

    function tryIframeApproach() {
        var iframe = document.createElement("iframe");
        iframe.style.border = "none";
        iframe.style.width = "1px";
        iframe.style.height = "1px";
        iframe.onload = function () {
            document.location = alt;
            console.log("Iframe Alt");
        };
        iframe.src = custom;
        document.body.appendChild(iframe);
    }

    function tryWebkitApproach() {
        document.location = custom;
        console.log("WebKit Custom");
        timer = setTimeout(function () {
            document.location = alt;
            console.log("WebKit Alt");
        }, 2500);
    }

    function useIntent() {
        document.location = g_intent;
        console.log("Intent");
        forceInterval2 = setTimeout(function () {
            document.location = alt;
            console.log("forceOpen Alt");
        },3000);
    }


    heartbeat = setInterval(intervalHeartbeat, 200);
    if (navigator.userAgent.match(/Chrome/)) {
        useIntent();
    } else if (navigator.userAgent.match(/Firefox/)) {
        tryWebkitApproach();
        iframe_timer = setTimeout(function () {
            tryIframeApproach();
        }, 1500);
    } else {
        tryIframeApproach();
    }
}


function click_android_redirect_market(){
    document.location = alt;
}
