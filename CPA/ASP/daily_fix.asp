<!--#include virtual="jsonObject.asp"-->

<%
Response.LCID = 1042

Const NWNAME = "linkprice"           'network name value
Dim yyyymmdd

set yyyymmdd = request.QueryString("yyyymmdd")

set dail_fix = New JSONarray

Dim conn, result, sql, command

set conn = CreateObject("ADODB.Connection")
conn.Open "your connection string"

Set command = Server.CreateObject("ADODB.Command")
Set command.ActiveConnection = conn
command.CommandType = adCmdText

command.CommandText = "SELECT	network_value 		lpinfo," + _
	 		        "order_time 	        order_time,"+ _
	 		        "user_id 		member_id,"+ _
	 		        "order_code 		unique_id,"+ _
			        "'registration' 	action,"+ _
	 		        "'FREE' 		category_code,"+ _
				"'무료 회원 가입' 	action_name,"+ _
	 		        "remote_address 	remote_addr,"+ _
	 		        "u_agent 		user_agent"+ _
			" FROM your_order_table"+ _
	 		" WHERE yyyymmdd = ?"+ _
	 		" AND network_name =?"

command.Parameters.Append(command.CreateParameter("order_code", adchar, adParamInput, Len(yyyymmdd), yyyymmdd))
command.Parameters.Append(command.CreateParameter("network_value", adchar, adParamInput, Len(NWNAME), NWNAME))

set result = command.execute
dail_fix.LoadRecordset result

result.Close
conn.Close

response.ContentType = "application/json;charset=euc-kr"
response.Write(dail_fix.Serialize())

%>
