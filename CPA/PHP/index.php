<?php
$send_data = array();
$search_order_code = "User number";	// User number from complete registration page
define(NWNAME,"linkprice");	        // network name value to recognize linkprice

$db_ip = "DATABASE IP";
$db_id = "DATABASE ID";
$db_pw = "DATABASE PASSWORD";
$db_nm = "DATABASE NAME";
$conn = mysqli_connect($db_ip, $db_id, $db_pw, $db_nm);

/*
Change filed name to your field name

'lpinfo' => 'LPINFO 쿠키정보(LPINFO cookie value)'
'merchant_id' => '계약시 제공 받은 머천트 아이디(Merchant ID from Linkprice)'
'member_id' => 'User id'
'unique_id' => '회원번호(User number)'
'action' => '종류(Action type - ex:"member", "apply")'
'category_code' => '회원가입 종류(Type of registration - ex: "member", "apply")'
'action_name' => '회원가입 종류명(Name of registration)'
'remote_address' => '사용자의 IP(User IP)'		// $_SERVER["REMOTE_ADDR"]
'user_agent' => '사용자 에이전트(User agent)',	        // $_SERVER["HTTP_USER_AGENT"]


*/
$sql = "select	network_value 		lpinfo,
		'your merchant id' 	merchant_id,
		user_id 		member_id,
		order_code 		unique_id,
		'member' 		action,
		'member' 		category_code,
		'회원 가입'	   	action_name,
		remote_address 		remote_address,
		u_agent 		user_agent
	from your_member_table
	where order_code = ?
	and network_name = ?";

$stmt = mysqli_stmt_init($conn);
if(mysqli_stmt_prepare($stmt,$sql)){
    mysqli_stmt_bind_param($stmt, "ss", $search_order_code, NWNAME);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    
    while ($row = mysqli_fetch_assoc($result)) {
        $send_data[] = $row;
    }
	
    mysqli_stmt_close($stmt);
}

//data send
if (!empty($send_data)) {
    define("LP_URL","https://service.linkprice.com/lppurchase_cpa_v3.php");

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
