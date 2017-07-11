<?php
	// DataBase 접속

	// LINKPRICE 를 통해서 신청된 접수내역 QUERY
	// QUERY 조건  : 구매일자=yyyymmdd and 제휴사=링크프라이스
	// SELECT 컬럼 : 구매시간, LPINFO, 구매자ID, 구매자이름, 주문번호, 상품코드, 주문수량, 결제금액
	// ex) $sql = "select * from 링크프라이스_실적테이블 where 날짜 like '$yyyymmdd%' and LPINFO is not null";

	$sql = "
		select hhmiss, lpinfo, id, name, order_code, product_code, item_count, price, category_code, product_name, remote_addr
		from tlinkprice
		where yyyymmdd = '".$yyyymmdd."'
	";

	$result = mysql_query($query, $connect);
	$total = mysql_num_rows($result);

	while ($total > 0)
	{
		$row = mysql_fetch_array($result);

		$line  = $row["HHMISS"]."\t";
		$line .= $row["LPINFO"]."\t";
		$line .= $row["ID"]."(".$row["NAME"].")"."\t";
		$line .= $row["ORDER_CODE"]."\t";
		$line .= $row["PRODUCT_CODE"]."\t";
		$line .= $row["ITEM_COUNT"]."\t";
		$line .= $row["PRICE"]."\t";
		$line .= $row["CATEGORY_CODE"]."\t\t";
		$line .= $row["PRODUCT_NAME"]."\t";

		// 만약 데이터의 마지막 값이 아니면 줄 바꿈(\n)을 한다.
		if ($total != 1)
			$line .= $row["REMOTE_ADDR"]."\n";
		else
			$line .= $row["REMOTE_ADDR"];

		echo $line;

		$total--;
	}

	// DataBase 접속 끊기
?>