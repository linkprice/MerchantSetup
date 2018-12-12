<!--#include virtual="jsonObject.asp"-->

<%
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
	 		        "u_agent 		user_agent"+ _
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
