<?php
define(NWNAME, "linkprice"); // network name value
$daily_fix = array();

$db_ip = "DATABASE IP";
$db_id = "DATABASE ID";
$db_pw = "DATABASE PASSWORD";
$db_nm = "DATABASE NAME";
$conn = mysqli_connect($db_ip, $db_id, $db_pw,$db_nm);

//Do not change alias name
$sql = "select	network_value		lpinfo,
                order_time		order_time,
		user_id			member_id,
		order_code 		unique_id,
		'registration'		action,
		'FREE'			category_code,
		'무료 회원 가입'	        action_name,
		remote_address 		remote_addr,
		u_agent			user_agent
	from your_order_table
	where yyyymmdd = ?
	and network_name = ?";

$stmt = mysqli_stmt_init($conn);
if(mysqli_stmt_prepare($stmt,$sql)){
    $yyyymmdd = trim($_REQUEST["yyyymmdd"]);
    mysqli_stmt_bind_param($stmt, "ss", $yyyymmdd, NWNAME);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    
    while ($row = mysqli_fetch_assoc($result)) {
        $daily_fix[] = $row;
    }
    	
    mysqli_stmt_close($stmt);
}

echo json_encode($daily_fix);

// DataBase Close
?>
