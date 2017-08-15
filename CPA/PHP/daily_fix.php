<?php

define(NWNAME, "linkprice"); // network name value
$daily_fix = array();

//Do not change alias name
$sql = "select	network_value 		a_id,
                order_time          order_time,
				user_id 			member_id,
				order_code 			order_code,
				'member' 		    product_code,
				'FREE' 			    category_code,
				remote_address 		remote_addr,
				u_agent 			user_agent
		from your_order_table
		where yyyymmdd = ?
		and	  network_name = ?";

$stmt = mysqli_stmt_init($conn);
if(mysqli_stmt_prepare($stmt,$sql)){
    mysqli_stmt_bind_param($stmt,"ss",$_REQUEST["yyyymmdd"],NWNAME);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    $daily_fix = mysqli_fetch_assoc($result);
    mysqli_stmt_close($stmt);
}

echo json_encode($daily_fix);

// DataBase Á¢¼Ó ²÷±â
?>