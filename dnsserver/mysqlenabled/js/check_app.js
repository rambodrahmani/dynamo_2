
var url_android_code = "boccaccioclubandroid://?code=boccaccioAndroidAppVerified";
var url_android_market = "market://details?id=com.boccaccioclub.samantha";
var url_android_intent = "intent://scan/?code=boccaccioAndroidAppVerified#Intent;scheme=boccaccioclubandroid;package=com.boccaccioclub.samantha;S.browser_fallback_url=market://details?id=com.boccaccioclub.samantha;end";
var url_ios_code = "iOSBoccaccioApp://?boccaccioIosAppVerified";
var url_ios_market = "https://itunes.apple.com/it/app/id950398450";

function check_ios_app()
{
    window.location.replace(url_ios_code);
    window.setTimeout(
        function(){
            window.location.replace(url_ios_market);
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
            document.location = url_android_market;
        };
        iframe.src = url_android_code;
        document.body.appendChild(iframe);
    }

    function tryWebkitApproach() {
        document.location = url_android_code;
        console.log("WebKit Custom");
        timer = setTimeout(function () {
            document.location = url_android_market;
            console.log("WebKit Alt");
        }, 2500);
    }

    function useIntent() {
        document.location = url_android_intent;
        console.log("Intent");
        forceInterval2 = setTimeout(function () {
            document.location = url_android_market;
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
    document.location = url_android_market;
}
