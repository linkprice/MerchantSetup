<?php
$send_data = array();
$search_order_code = "order code";		// order code from payment complete page

if(in_array($search_coupon_code, $linpric_coupon_list)) {

	$db_ip = "DATABASE IP";
	$db_id = "DATABASE ID";
	$db_pw = "DATABASE PASSWORD";
	$db_nm = "DATABASE NAME";
	$conn = mysqli_connect($db_ip, $db_id, $db_pw, $db_nm);
	
	/*
	Change filed name to your field name

	'event_code' => '이벤트 코드(Event code that is used for purchase)',
	'promo_code' => '할인 코드(promotion code that is used for purchase)',
	'order_code' => '주문 코드(Order code)',
	'product_code' => '상품 코드(Product code)',
	'product_name' => '상품명(Product name)',
	'item_count' => '상품 개수(Quantity of product)',
	'sales' => '금액(Total price)',
	'member_id' => 'user_id',				// 회원 ID
	'remote_address' => '사용자의 IP(User IP)'		// $_SERVER["REMOTE_ADDR"]
	'user_agent' => '유저 에이전트(User agent)',	        // $_SERVER["HTTP_USER_AGENT"]

	*/
	$sql = "select	event_code 		event_code,
			promo_code 		promo_code,
			'your merchant id' 	merchant_id,
			user_id 		member_id,
			order_code 		order_code,
			product_code 		product_code,
			price 			sales,
			product_name		product_name,
			count 			item_count,
			remote_address 		remote_addr,
			u_agent 		user_agent
		from your_order_table
		where order_code = ?";

	$stmt = mysqli_stmt_init($conn);
	if(mysqli_stmt_prepare($stmt,$sql)){
		mysqli_stmt_bind_param($stmt,"s",$search_order_code);
		mysqli_stmt_execute($stmt);
		$result = mysqli_stmt_get_result($stmt);
	 
		$send_data = array();
		while ($row = mysqli_fetch_assoc($result)) {
			if ( !empty($row['promo_code']) && !empty($row['event_code'])) {
				$send_data[] = $row;
			}
			
		}	
		
		mysqli_stmt_close($stmt);
	}

	//data send
	if (!empty($send_data)) {
		define("LP_URL","http://service.linkprice.com/lppurchase_discount.php");

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
	
}


