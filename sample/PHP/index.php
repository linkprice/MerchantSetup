<?php
	require_once "./lpEncrypt.php";

	header("Content-Type: text/html; charset=UTF-8");

	$lpenc = new lpEncrypt("./public.pem");		//public.pem 경로 확인

	$LPINFO = $_COOKIE["LPINFO"];
	
	$p_nm_arr[] = $product_name;			//여럭 상품 구매시 arrayList를 통하여 한번에 넘겨줍니다.
	$p_cd_arr[] = $product_code;
	$c_cd_arr[] = $catecode_code;
	$sales_arr[] = $sales_amount;
	$it_cnt_arr[] = $item_count;
 
	if(isset($LPINFO)) {
		$lpenc->set("a_id", $LPINFO);					//LPINFO 쿠키정보 (Cookie named LPINFO)
		$lpenc->set("m_id", merchant_id);			//머천트 ID(Merchant ID in Linkprice system)
		$lpenc->set("mbr_id", user_id);				//실적 발생 회원 ID(User ID who make business recorde in merchant system )
		$lpenc->set("o_cd", order_code);			//주문코드(Order number)
		$lpenc->set("p_cd", $p_cd_arr);				//상품코드(Product code)
		$lpenc->set("it_cnt", $it_cnt_arr);			//상품개수(Number of product)
		$lpenc->set("sales", $sales_arr);				//판매액(Sales amount)
		$lpenc->set("c_cd", $c_cd_arr);				//카테고릐 코드(Category code)
		$lpenc->set("p_nm", $p_nm_arr);				//상품이름	(Name of product)
		$lpenc->set("user_agent", $_SERVER["HTTP_USER_AGENT"]);		//접속 디바이스 정보(Device infomation)
		$lpenc->set("ip", $_SERVER["REMOTE_ADDR"]);							//실적 발생 회원 IP(User IP)

		echo $lpenc->submit();

	}