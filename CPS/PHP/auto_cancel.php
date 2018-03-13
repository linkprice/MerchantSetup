<?php
$auto_cancel = array();

$db_ip = "DATABASE IP";
$db_id = "DATABASE ID";
$db_pw = "DATABASE PASSWORD";
$db_nm = "DATABASE NAME";
$conn = mysqli_connect($db_ip, $db_id, $db_pw, $db_nm);

$sql = "select	'order_status' = 
                CASE 
                when order_status = '미입급' then 0 
                when order_status = '확정' then 1
                when order_status = '주문취소' then 2
                when order_status = '주문없음' then 3
                else 9
                END,
                'reason' = 
                CASE
                when order_status = '미입급' then '미입금' 
                when order_status = '확정' then '주문 최종 확정'
                when order_status = '주문취소' then '주문 취소'
                when order_status = '주문없음' then '주문 없음'
                else '확인요망(예외상황')
                END          
		from your_order_table
		where order_code = ?
		and	  product_code = ?";

$stmt = mysqli_stmt_init($conn);
if(mysqli_stmt_prepare($stmt,$sql)){
    mysqli_stmt_bind_param($stmt,"ss",$_GET["order_code"],$_GET["product_code"]);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    $auto_cancel = mysqli_fetch_assoc($result);
    mysqli_stmt_close($stmt);
}

header('Content-Type: application/json');
echo json_encode($auto_cancel);

?>
