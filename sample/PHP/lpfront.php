<?php
define(RETURN_DAYS,7);			//광고 인정 기간(쿠키 유효기간)

$lpinfo = $_REQUEST["lpinfo"];	//Affiliate 정보
$url = $_REQUEST["url"];		//이동할 페이지

if ($lpinfo == "" ||  $url == "")  {
    // alert: LPMS: Parameter Error
    echo "<html><head><script type=\"text/javascript\">
	    alert('LPMS: 연결할 수 없습니다. 사이트 담당자에게 문의하시기 바랍니다.');
	    history.go(-1);
        </script></head></html>";
    exit;
}

Header("P3P:CP=\"NOI DEVa TAIa OUR BUS UNI\"");

if (RETURN_DAYS == 0) {
    SetCookie("LPINFO", $lpinfo, 0, "/", ".example.com");
} else {
    SetCookie("LPINFO", $lpinfo, time() + (RETURN_DAYS * 24 * 60 * 60), "/", ".example.com");
}

Header("Location: ".$url);
?>