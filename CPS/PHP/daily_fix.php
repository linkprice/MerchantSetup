<?php

define(NWNAME, "linkprice"); // network name value
$daily_fix = array();

/*
Change filed name to your field name
Do not change alias name

'lpinfo' => 'LPINFO 쿠키정보(LPINFO cookie value)'
'order_time' => '주문시간(Order time - EX: 160745)'
'order_code' => '주문 코드(Order code)'
'product_code' => '상품 코드(Product code)'
'product_name' => '상품명(Product name)'
'item_count' => '상품 개수(Quantity of product)'
'sales' => '금액(Total price)'
'category' => '계약시 협의(Category in Contract)'	// 없으면 공백 처리
'member_id' => 'user_id'				// 없으면 공백 처리
'remote_address' => '사용자의 IP(User IP)'		// $_SERVER["REMOTE_ADDR"]
'user_agent' => '유저 에이전트(User agent)',	        // $_SERVER["HTTP_USER_AGENT"]

*/
$sql = "select	network_value 		lpinfo,
                order_time          	order_time,
		user_id 		member_id,
		order_code 		order_code,
		product_code 		product_code,
		price 			sales,
		product_name		product_name,
		product_count 		item_count,
		category 		category_code,
		remote_address 		remote_addr,
		u_agent 		user_agent
	from your_order_table
	where yyyymmdd = ?
	and	  network_name = ?";

$stmt = mysqli_stmt_init($conn);
if(mysqli_stmt_prepare($stmt,$sql)){
    mysqli_stmt_bind_param($stmt,"ss",$_REQUEST["yyyymmdd"],NWNAME);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
	
    while ($row = mysqli_fetch_assoc($result)) {
        $daily_fix[] = $row;
    }
	
    mysqli_stmt_close($stmt);
}

echo json_encode($daily_fix);

// DataBase Á¢¼Ó ²÷±â
?>
