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
String LP_URL = "http://service.linkprice.com/lppurchase_discount.php";

/**
Change filed name to your field name
'event_code' => '이벤트 코드(Event code that is used for purchase)',
'promo_code' => '할인 코드(promotion code that is used for purchase)',
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
**/

sql = "SELECT	event_code 		event_code,
		+"promo_code 		promo_code,"
		+"'your merchant id' 	merchant_id,"
	 	+"user_id 		member_id,"
	 	+"order_code 		order_code,"
		+"product_code 		product_code,"
	 	+"price 		sales,"
	 	+"product_name		product_name,"
	 	+"count 		item_count,"
	 	+"category 		category_code,"
	 	+"remote_address 	remote_addr,"
	 	+"u_agent 		user_agent"
	 	+" FROM your_order_table"
	 	+" WHERE order_code = ?";

Connection conn = null;
PreparedStatement stmt = null;
ResultSet result = null;

stmt = conn.prepareStatement(sql);
stmt.setString(1, search_order_code);
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
