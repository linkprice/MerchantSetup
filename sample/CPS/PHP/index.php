<?php
$send_data = array();
$search_order_code = "order code";	// order code from complete payment page
define(LPINFO, "linkprice");	        // network name value from complete payment page

//sql to bring your order that will be sent to linkprice.
//change filed name to your field name
$sql = "select	network_value 		a_id,
				'your merchant id' 	merchant_id,
				user_id 			member_id,
				order_code 			order_code,
				product_code 		product_code,
				price 				sales,
				product_name		product_name,
				count 				item_count,
				category 			category_code,
				remote_address 		remote_addr,
				u_agent 			user_agent
		from your_order_table
		where order_code = ?
		and	  network_name = ?";

$stmt = mysqli_stmt_init($conn);
if(mysqli_stmt_prepare($stmt,$sql)){
    mysqli_stmt_bind_param($stmt,"ss",$search_order_code,LPINFO);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    $send_data = mysqli_fetch_assoc($result);
    mysqli_stmt_close($stmt);
}

//data send
if (!empty($send_data)) {
    define("LP_URL","https://service.linkprice.com/lppurchase_new.php");

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