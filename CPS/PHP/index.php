<?php
$send_data = array();
$search_order_code = "order code";	// order code from complete payment page
define(LPINFO, "linkprice");	        // network name value from complete payment page

/*
Change filed name to your field name

'lpinfo' => 'LPINFO 쿠키정보(LPINFO cookie value)',
'merchant_id' => '계약시 제공 받은 머천트 아이디(Merchant ID from Linkprice)',
'order_code' => '주문 코드(Order code)',
'product_code' => '상품 코드(Product code)',
'product_name' => '상품명(Product name)',
'count' => '상품 개수(Quantity of product)',
'sales' => '금액(Total price)',
'category' => '계약시 협의(Category in Contract)',	// 없으면 공백 처리
'user_id' => 'user_id',				// 없으면 공백 처리
'remote_address' => '사용자의 IP(User IP)'		// $_SERVER["REMOTE_ADDR"]
'user_agent' => '유저 에이전트(User agent)',	        // $_SERVER["HTTP_USER_AGENT"]

*/
$sql = "select	network_value 		lpinfo,
		'your merchant id' 	merchant_id,
		user_id 		member_id,
		order_code 		order_code,
		product_code 		product_code,
		price 			sales,
		product_name		product_name,
		count 			item_count,
		category 		category_code,
		remote_address 		remote_addr,
		u_agent 		user_agent
	from your_order_table
	where order_code = ?
	and	  network_name = ?";

$stmt = mysqli_stmt_init($conn);
if(mysqli_stmt_prepare($stmt,$sql)){
    mysqli_stmt_bind_param($stmt,"ss",$search_order_code,LPINFO);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
 
    $send_data = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $send_data[] = $row;
    }	
	
    mysqli_stmt_close($stmt);
}

//data send
if (!empty($send_data)) {
    define("LP_URL","https://service.linkprice.com/lppurchase_cps_v3.php");

    $options = array(
        'http' => array(
            'method'  => 'POST',
            'content' => json_encode($send_data),
            'header'=>  "Content-type: application/json\r\n"
        )
    );

    $context = stream_context_create($options);
    $result = file_get_contents(LP_URL, false, $context);
}
