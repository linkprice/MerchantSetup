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
String LP_URL = "https://service.linkprice.com/lppurchase_cps_v3.php";

/**
Change filed name to your field name
'lpinfo' => 'LPINFO 쿠키정보(LPINFO cookie value)',
'merchant_id' => '계약시 제공 받은 머천트 아이디(Merchant ID from Linkprice)',
'order_code' => '주문 코드(Order code)',
'product_code' => '상품 코드(Product code)',
'product_name' => '상품명(Product name)',
'item_count' => '상품 개수(Quantity of product)',
'sales' => '금액(Total price)',
'category_code' => '계약시 협의(Category in Contract)',	// 카테고리 코드
'member_id' => 'user_id',				// 회원 ID
'remote_address' => '사용자의 IP(User IP)'		// $_SERVER["REMOTE_ADDR"]
'user_agent' => '유저 에이전트(User agent)',	        // $_SERVER["HTTP_USER_AGENT"]
'sales_type' => '실적 구분값(Sales type)',	        // PC, MOBILE, IOS, AND, APP (choose 1)
**/

sql = "SELECT	network_value 		lpinfo,"
		+"'your merchant id' 	merchant_id,"
	 	+"user_id 		member_id,"
	 	+"order_code 		order_code,"
		+"product_code 		product_code,"
	 	+"price 		sales,"
	 	+"product_name		product_name,"
	 	+"count 		item_count,"
	 	+"category 		category_code,"
	 	+"remote_address 	remote_addr,"
	 	+"u_agent 		user_agent,"
		+"sales_type	sales_type"
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
os.flush();
os.close();

BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));

String line;
StringBuffer response_data = new StringBuffer();
while ((line = in.readLine()) != null) {
	response_data.append(line);
}

//json request
out.println(send_data.toString());

//json response
out.println(response_data.toString());

%>
