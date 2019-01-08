<!--#include virtual="jsonObject.asp"-->

<%

' Change filed name to your field name
' 
' 'event_code' => '이벤트 코드(Event code that is used for purchase)',
' 'promo_code' => '할인 코드(promotion code that is used for purchase)',
' 'order_time' => '주문 시간의 시분초',
' 'member_id' => 'user_id',					// 회원 ID
' 'order_code' => '주문 코드(Order code)',
' 'product_code' => '상품 코드(Product code)',
' 'product_name' => '상품명(Product name)',
' 'sales' => '금액(Total price)',
' 'product_name' => '상품명(Product name)',
' 'item_count' => '상품 개수(Quantity of product)',
' 'remote_addr' => '사용자의 IP(User IP)',			// $_SERVER["REMOTE_ADDR"]
' 'user_agent' => '유저 에이전트(User agent)',	        	// $_SERVER["HTTP_USER_AGENT"]
' 'device_type' => '실적 발생한 디바이스 타입'	        	// PC웹 실적 - "PC" / 모바일 웹 실적 - "MOBILE" / 모바일 앱 실적 - "APP"

Response.LCID = 1043

Dim yyyymmdd

set yyyymmdd = request.QueryString("yyyymmdd")

set dail_fix = New JSONarray

Dim conn, result, sql, command

set conn = CreateObject("ADODB.Connection")
conn.Open "your connection string"

Set command = Server.CreateObject("ADODB.Command")
Set command.ActiveConnection = conn
command.CommandType = adCmdText

command.CommandText = "SELECT	event_code 		event_code," + _
	 		        "promo_code 		promo_code,"+ _
	 		        "order_time 	        order_time,"+ _
	 		        "user_id 		member_id,"+ _
	 		        "order_code 		order_code,"+ _
			        "product_code 		product_code,"+ _
	 		        "price 			sales,"+ _
	 		        "product_name		product_name,"+ _
	 		        "count 			item_count,"+ _
	 		        "remote_address 	remote_addr,"+ _
	 		        "u_agent 		user_agent,"+ _
				"device_type 		device_type"+ _
			" FROM your_order_table"+ _
	 		" WHERE yyyymmdd = ?"+ _
	 		" AND	  network_name =?"

command.Parameters.Append(command.CreateParameter("order_code", adchar, adParamInput, Len(yyyymmdd), yyyymmdd))

set result = command.execute
dail_fix.LoadRecordset result

result.Close
conn.Close

response.ContentType = "application/json;charset=euc-kr"
response.Write(dail_fix.Serialize())

%>
