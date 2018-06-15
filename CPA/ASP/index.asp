<!--#include virtual="jsonObject.asp"-->

<%
Response.LCID = 1042

Const LP_URL  = "https://service.linkprice.com/lppurchase_cpa_v3.php"
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
' 'lpinfo' => 'LPINFO 쿠키정보(LPINFO cookie value)'
' 'merchant_id' => '계약시 제공 받은 머천트 아이디(Merchant ID from Linkprice)'
' 'member_id' => 'User id'
' 'unique_id' => '회원번호(User number)'
' 'action' => '액션 코드(Action type - ex:"member", "apply")'
' 'category_code' => '회원가입 종류(Type of registration - ex: "member", "apply")'
' 'action_name' => '액션 이름(Name of registration)'
' 'remote_address' => '사용자의 IP(User IP)'		// $_SERVER["REMOTE_ADDR"]
' 'user_agent' => '유저 에이전트(User agent)',	        // $_SERVER["HTTP_USER_AGENT"]
' 'sales_type' => '실적 구분값(Sales type)',	        // PC, MOBILE, IOS, AND, APP (choose 1)


command.CommandText = "SELECT	network_value 		lpinfo," + _
	 		        "'your merchant id' 	merchant_id,"+ _
	 		        "user_id 		member_id,"+ _
	 		        "order_code 		unique_id,"+ _
			        "'member' 		action,"+ _
	 		        "'member' 		category_code,"+ _
				"'회원 가입' 	 	action_name,"+ _
	 		        "remote_address 	remote_addr,"+ _
	 		        "u_agent 		user_agent"+ _
					"sales_type		sales_type"+ _
			" FROM your_order_table"+ _
	 		" WHERE order_code = ?"+ _
	 		" AND network_name =?"

command.Parameters.Append(command.CreateParameter("order_code", adchar, adParamInput, Len(search_order_code), search_order_code))
command.Parameters.Append(command.CreateParameter("network_value", adchar, adParamInput, Len(NWNAME), NWNAME))

set result = command.execute
send_data.LoadRecordset result

result.Close
conn.Close

set con = Server.CreateObject("Msxml2.ServerXMLHTTP")
con.open "POST", LP_URL, false
con.setRequestHeader "Content-Type", "application/json"
con.send send_data.Serialize()

%>
