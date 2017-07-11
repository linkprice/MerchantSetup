<%
    ' DataBase 접속

    ' LINKPRICE 를 통해서 구매된 주문내역 QUERY
    ' 	QUERY 조건  : 구매일자=yyyymmdd and 제휴사=링크프라이스
    ' 	SELECT 컬럼 : 구매시간, LPINFO 쿠키, 구매자ID, 구매자이름, 주문번호, 상품코드, 주문수량, 상품단가, 구매자IP

    ' QUERY 결과가 Rs 라는 변수에 저장되었다고 가정

    Do until Rs.EOF
        line = Rs("HHMISS") & chr(9)
        line = line & Rs("LPINFO") & chr(9)
        line = line & Rs("ID") & "(" & Rs("NAME") & ")" & chr(9)
        line = line & Rs("ORDER_NO") & chr(9)
        line = line & Rs("PRODUCT_CODE") & chr(9)
        line = line & Rs("ITEM_COUNT") & chr(9)
        line = line & Rs("PRICE") & chr(9)
        line = line & Rs("CATEGORY_CODE") & chr(9) & chr(9)
        line = line & Rs("PRODUCT_NAME") & chr(9)
        line = line & Rs("REMOTE_ADDR")

        Rs.MoveNext

        if Rs.EOF = false then
            line = line & chr(13) & chr(10)
        end if

        Response.write line
    Loop

    ' DataBase 접속 끊기
%>