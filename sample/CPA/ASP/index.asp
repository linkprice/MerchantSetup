<!--#include virtual="jsonObject.asp"-->

<%
Response.LCID = 1043

Const LP_URL  = "https://service.linkprice.com/lppurchase_new.php"
Const LPINFO = "lpinfo value"           'network_value from complete payment page
Dim search_order_code               	'order code from complete payment page
search_order_code = "order_code"

set send_data = New JSONarray

Dim conn, result, sql, command

set conn = CreateObject("ADODB.Connection")
conn.Open "your connection string"\

Set command = Server.CreateObject("ADODB.Command")
Set command.ActiveConnection = conn
command.CommandType = adCmdText

command.CommandText = "SELECT	network_value 		a_id," + _
	 		                "'your merchant id' 	merchant_id,"+ _
	 		                "user_id 				member_id,"+ _
	 		                "order_code 			order_code,"+ _
			                "'member' 		        product_code,"+ _
	 		                "'FREE' 			    category_code,"+ _
	 		                "remote_address 		remote_addr,"+ _
	 		                "u_agent 				user_agent"+ _
	 		                " FROM your_order_table"+ _
	 		                " WHERE order_code = ?"+ _
	 		                " AND	  network_value =?"

command.Parameters.Append(command.CreateParameter("order_code", adchar, adParamInput, Len(search_order_code), search_order_code))
command.Parameters.Append(command.CreateParameter("network_value", adchar, adParamInput, Len(LPINFO), LPINFO))

set result = command.execute
send_data.LoadRecordset result

result.Close
conn.Close

set con = Server.CreateObject("Msxml2.ServerXMLHTTP")
con.open "POST", LP_URL, false
con.setRequestHeader "Content-Type", "application/json"
con.send Server.UrlEncode(send_data.Serialize())

%>
