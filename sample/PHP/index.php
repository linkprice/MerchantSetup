<?php
/**
 * LINKPRICE PHP용 실적 전송
 * @date : 2017-06-08
 * @mail : kimjs@linkprice.com
 */

require_once "./lpEncrypt.php";

header("Content-Type: text/html; charset=UTF-8");

$e = new lpEncrypt("./public.pem");

$cookie = "A100538694%7C24928375000001%7C0000%7C9%7C1%7Clsweb";

//$e->set("a_id", $cookie);
$e->set("m_id", "lastsave4");
//$e->set("mbr_id", "김진섭");
$e->set("o_cd", "kjs503");
$e->set("p_cd", "member");
//$e->set("it_cnt", "1");
$e->set("sales", "100");
//$e->set("c_cd", "mobile");
//$e->set("p_nm", "무료회원가입");
//$e->set("remote_addr", $_SERVER["REMOTE_ADDR"]);

echo $e->submit();