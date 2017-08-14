<?php
$order_code = "order code"; // order code from complete payment page

// 주문 정보 가져오기
$lp_order_data = lpGetOrder($conn, $order_code);

// 실적 전송
if (!empty($lp_order_data)) {
    $result = lpSend($lp_order_data);
}

function lpGetOrder($conn, $order_code) {
    $network_name = "linkprice";

//        'lpinfo' => 'LPINFO 쿠키정보',
//        'merchant_id' => '계약시 제공 받은 머천트 아이디',
//        'order_code' => '주문 코드',
//        'product_code' => '상품 코드',
//        'product_name' => '상품명',
//        'count' => '상품 개수',
//        'sales' => '금액',
//        'category' => '계약시 협의',       // 없으면 공백 처리
//        'user_id' => 'user_id',            // 없으면 공백 처리
//        'remote_address' => '사용자의 IP', // $_SERVER["REMOTE_ADDR"]
//        'user_agent' => '유저 에이전트',   // $_SERVER["HTTP_USER_AGENT"]

    $sql = "
        select	network_value 	lpinfo,
				'계약시 제공 받은 머천트 아이디' 	merchant_id,
				order_code,
				product_code,
				product_name,
				count,
				sales,
				category,
				user_id,
				remote_address,
				user_agent
		from your_order_table
		where order_code = ?
		and	  network_name = ?
	";
    $stmt = mysqli_stmt_init($conn);

    if(!mysqli_stmt_prepare($stmt,$sql)) return false;
    mysqli_stmt_bind_param($stmt,"ss", $order_code, $network_name);
    mysqli_stmt_execute($stmt);
    $stmt_result = mysqli_stmt_get_result($stmt);

    $result = array();
    while ($row = mysqli_fetch_assoc($stmt_result)) {
        $result[] = $row;
    }
    mysqli_stmt_close($stmt);

    return $result;
}

function lpSend($order_data) {
    if (empty($order_data)) return false;

    $lp_url = "https://service.linkprice.com/lppurchase_v3.php";

    $options = array(
        'http' => array(
            'method'  => 'POST',
            'content' => json_encode($order_data),
            'header'=>  "Content-type: application/json\r\n"
        )
    );
    $context = stream_context_create($options);

    return file_get_contents($lp_url, false, $context);
}
