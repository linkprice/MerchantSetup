<!--#include virtual="jsonObject.asp"-->

<%
Response.LCID = 1042

Const LP_URL  = "http://service.linkprice.com/lppurchase_discount.php"
Const NWNAME = "linkprice"
Dim search_order_code               	'order code from complete payment page
search_order_code = "order_code"

set send_data = New JSONarray

Dim conn, result, sql, command

set conn = CreateObject("ADODB.Connection")
conn.Open "your connection string"\

Set command = Server.CreateObject("ADODB.Command")
Set command.ActiveConnection = conn
command.CommandType = adCmdText

' Change filed name to your field name
' 
' 'event_code' => '이벤트 코드(Event code that is used for purchase)',
' 'promo_code' => '할인 코드(promotion code that is used for purchase)',
' 'member_id' => 'user_id',					// 회원 ID
' 'order_code' => '주문 코드(Order code)',
' 'product_code' => '상품 코드(Product code)',
' 'product_name' => '상품명(Product name)',
' 'sales' => '금액(Total price)',
' 'item_count' => '상품 개수(Quantity of product)',
' 'remote_addr' => '사용자의 IP(User IP)',			// $_SERVER["REMOTE_ADDR"]
' 'user_agent' => '유저 에이전트(User agent)',	        	// $_SERVER["HTTP_USER_AGENT"]
' 'device_type' => '실적 발생한 디바이스 타입'	        	// PC웹 실적 - "PC" / 모바일 웹 실적 - "MOBILE" / 모바일 앱 실적 - "APP"


command.CommandText = "SELECT	event_code 		event_code," + _
				"promo_code 		promo_code," + _
				"user_id 			member_id,"+ _
				"order_code 			order_code,"+ _
				"product_code 		    	product_code,"+ _
				"product_name			product_name,"+ _
				"price 				sales,"+ _
				"count 				item_count,"+ _
				"remote_address 		remote_addr,"+ _
				"u_agent 			user_agent,"+ _
				"device_type 			device_type"+ _
			" FROM your_order_table"+ _
			" WHERE order_code = ?"

command.Parameters.Append(command.CreateParameter("order_code", adchar, adParamInput, Len(search_order_code), search_order_code))

set result = command.execute
send_data.LoadRecordset result

result.Close
conn.Close

set con = Server.CreateObject("Msxml2.ServerXMLHTTP")
con.open "POST", LP_URL, false
con.setRequestHeader "Content-Type", "application/json"
con.send send_data.Serialize()

%>
