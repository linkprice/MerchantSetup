<%@ page language="java" contentType="application/json; charset=euc-kr" %>

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

/*
Change filed name to your field name

'event_code' => '이벤트 코드(Event code that is used for purchase)',
'promo_code' => '할인 코드(promotion code that is used for purchase)',
'order_code' => '주문 코드(Order code)',
'order_time' => '주문시간의 시,분,초',
'product_code' => '상품 코드(Product code)',
'product_name' => '상품명(Product name)',
'item_count' => '상품 개수(Quantity of product)',
'sales' => '금액(Total price)',
'member_id' => 'user_id',				// 회원 ID
'remote_addr' => '사용자의 IP(User IP)'		// $_SERVER["REMOTE_ADDR"]
'user_agent' => '유저 에이전트(User agent)',	        // $_SERVER["HTTP_USER_AGENT"]
'device_type' => '실적 발생한 디바이스 타입' // PC웹 실적 - "PC" / 모바일 웹 실적 - "MOBILE" / 모바일 앱 실적 - "APP"
*/

String sql = new String();
String yyyymmdd = request.getParameter("yyyymmdd");
String NWNAME = "linkprice";                   //network name for linkprice

sql = "SELECT	event_code 		event_code,"
		+"promo_code 		promo_code,"
	 	+"order_time 		order_time,"
	 	+"user_id 		member_id,"
	 	+"order_code 		order_code,"
		+"product_code 		product_code,"
	 	+"price 		sales,"
	 	+"product_name		product_name,"
	 	+"count 		item_count,"
	 	+"remote_address 	remote_addr,"
	 	+"u_agent 		user_agent,"
		+"device_type 		device_type"
	+" FROM your_order_table"
	+" WHERE yyyymmdd = ?";

Connection conn = null;
PreparedStatement stmt = null;
ResultSet result = null;

stmt = conn.prepareStatement(sql);
stmt.setString(1, yyyymmdd);
result = stmt.executeQuery();

JSONArray daily_fix = new JSONArray();
while(result.next()){
	JSONObject json = new JSONObject();

	int total_rows = result.getMetaData().getColumnCount();
	for(int i = 0; i < total_rows; i++){
		json.put(result.getMetaData().getColumnLabel(i + 1).toLowerCase(), result.getObject(i+1));
	}
	daily_fix.add(json);
}

	out.println(daily_fix.toString());
	out.flush();
%>
