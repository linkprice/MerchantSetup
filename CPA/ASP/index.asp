<!--#include virtual="jsonObject.asp"-->

<%
Response.LCID = 1043

Const LP_URL  = "https://service.linkprice.com/lppurchase_cpa_v3.php"
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

' Change filed name to your field name
'
' 'lpinfo' => 'LPINFO 쿠키정보(LPINFO cookie value)'
' 'merchant_id' => '계약시 제공 받은 머천트 아이디(Merchant ID from Linkprice)'
' 'member_id' => 'User id'
' 'unique_id' => '회원번호(User number)'
' 'action' => '종류(Action type - ex:"Registration", "Poll", "Participation")'
' 'category_code' => '회원가입 종류(Type of registration - ex: "FREE", "Paid")'
' 'action_name' => '회원가입 종류명(Name of registration)'
' 'remote_address' => '사용자의 IP(User IP)'		// $_SERVER["REMOTE_ADDR"]
' 'user_agent' => '유저 에이전트(User agent)',	        // $_SERVER["HTTP_USER_AGENT"]


command.CommandText = "SELECT	network_value 		lpinfo," + _
	 		        "'your merchant id' 	merchant_id,"+ _
	 		        "user_id 		member_id,"+ _
	 		        "order_code 		unique_id,"+ _
			        "'registration' 	action,"+ _
	 		        "'FREE' 		category_code,"+ _
				"'무료 회원 가입' 	action_name,"+ _
	 		        "remote_address 	remote_addr,"+ _
	 		        "u_agent 		user_agent"+ _
			" FROM your_order_table"+ _
	 		" WHERE order_code = ?"+ _
	 		" AND network_name =?"

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
