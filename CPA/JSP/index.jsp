<%@ page import="java.util.ArrayList"%>
<%@ page import="org.json.simple.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.*"%>
<%@page import="java.io.*" %>

<%
String sql = new String();
String search_order_code = "order code";
String NWNAME = "linkprice";
String LP_URL = "https://service.linkprice.com/lppurchase_cpa_v3.php";

/**
Change filed name to your field name

'lpinfo' => 'LPINFO 쿠키정보(LPINFO cookie value)'
'merchant_id' => '계약시 제공 받은 머천트 아이디(Merchant ID from Linkprice)'
'member_id' => 'User id'
'unique_id' => '회원번호(User number)'
'action' => '액션 코드(Action type - ex:"member", "apply")'
'category_code' => '회원가입 종류(Type of registration - ex: "member", "apply")'
'action_name' => '액션 이름(Name of registration)'
'remote_address' => '사용자의 IP(User IP)'		// $_SERVER["REMOTE_ADDR"]
'user_agent' => '유저 에이전트(User agent)',	        // $_SERVER["HTTP_USER_AGENT"]

**/
sql = "SELECT	network_value 		lpinfo,"
	 	+"'your merchant id' 	merchant_id,"
	 	+"'member' 		member_id,"
	 	+"order_code 		unique_id,"
		+"'member' 		action,"
	 	+"'member' 		category_code,"
		+"'회원 가입' 	     	action_name,"
	 	+"remote_address 	remote_addr,"
	 	+"u_agent 		user_agent"
	+" FROM your_order_table"
	+" WHERE order_code = ?"
	+" AND	  network_name =?";

Connection conn = null;
PreparedStatement stmt = null;
ResultSet result = null;

stmt = conn.prepareStatement(sql);
stmt.setString(1, search_order_code);
stmt.setString(2, NWNAME);
result = stmt.executeQuery();

JSONArray send_data = new JSONArray();
while(result.next()){
	JSONObject json = new JSONObject();

	int total_rows = result.getMetaData().getColumnCount();
	for(int i = 0; i < total_rows; i++){
		json.put(result.getMetaData().getColumnLabel(i + 1).toLowerCase(), result.getObject(i+1));
	}
	send_data.add(json);
}

HttpURLConnection con = (HttpURLConnection)new URL(LP_URL).openConnection();
con.setRequestMethod("POST");
con.setRequestProperty("Content-Type", "application/json");
con.setDoOutput(true);
con.setDoInput(true);
con.setUseCaches(false);
con.setDefaultUseCaches(false);
OutputStream os = con.getOutputStream();
os.write(send_data.toString().getBytes("UTF-8"));

%>
