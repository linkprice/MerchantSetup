<?php
define("RETURN_DAYS", 7);       // 광고 인정 기간(쿠키 유효기간)

$lpinfo = $_REQUEST["lpinfo"];  // Affiliate 정보
$url = $_REQUEST["url"];        // 이동할 페이지

// 유효성 체크
if ("" == $lpinfo ||  "" == $url)  {
    echo "<html><head><script type=\"text/javascript\">
	    alert('LPMS: 연결할 수 없습니다. 사이트 담당자에게 문의하시기 바랍니다.');
	    history.go(-1);
        </script></head></html>";
    exit;
}
// 쿠키 저장
header("P3P:CP=\"NOI DEVa TAIa OUR BUS UNI\"");

if (RETURN_DAYS == 0) $lpinfo_expire = 0;
else $lpinfo_expire = time() + (RETURN_DAYS * 24 * 60 * 60);

setcookie("LPINFO", $lpinfo, $lpinfo_expire, "/", ".example.com");
// 사이트 이동
header("Location: ".$url);
?>
