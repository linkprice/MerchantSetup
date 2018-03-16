<!--#include virtual="jsonObject.asp"-->

<%
Response.LCID = 1042

Dim order_code, product_code

set order_code = request.QueryString("order_code")
set product_code = request.QueryString("product_code")

set auto_cancel = New JSONarray

Dim conn, result, sql, command

set conn = CreateObject("ADODB.Connection")
conn.Open "your connection string"

Set command = Server.CreateObject("ADODB.Command")
Set command.ActiveConnection = conn
command.CommandType = adCmdText

command.CommandText = "SELECT	" + _
			"CASE "+ _
			"when order_status = '미입급' then 0 "+ _
			"when order_status = '확정' then 1 "+ _
			"when order_status = '주문취소' then 2 "+ _
			"when order_status = '주문없음' then 3 "+ _
			"else 9 "+ _
			"END AS `order_status`, "+ _
			"CASE "+ _
			"when order_status = '미입급' then '미입금' "+ _
			"when order_status = '확정' then '주문 최종 확정' "+ _
			"when order_status = '주문취소' then '주문 취소' "+ _
			"when order_status = '주문없음' then '주문 없음' "+ _
			"else '확인요망(예외상황)' "+ _
			"END AS `reason`"+ _
			"from your_order_table "+_
			"where order_code = ? "+_
			"and product_code = ?"

command.Parameters.Append(command.CreateParameter("order_code", adchar, adParamInput, Len(order_code), order_code))
command.Parameters.Append(command.CreateParameter("product_code", adchar, adParamInput, Len(product_code), product_code))

set result = command.execute
auto_cancel.LoadRecordset result

result.Close
conn.Close

response.ContentType = "application/json;charset=euc-kr"
response.Write(auto_cancel.Serialize())

%>
