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
String LPINFO = "lpinfo";
String LP_URL = "https://service.linkprice.com/lppurchase_new.php";

sql = "SELECT	network_value 		a_id,"
	 		 +"'your merchant id' 	merchant_id,"
	 		 +"user_id 				member_id,"
	 		 +"order_code 			order_code,"
			 +"product_code 		    product_code,"
	 		 +"price 				    sales,"
	 		 +"product_name			product_name,"
	 		 +"count 				    item_count,"
	 		 +"category 			    category_code,"
	 		 +"remote_address 		remote_addr,"
	 		 +"u_agent 				user_agent"
	 		 +" FROM your_order_table"
	 		 +" WHERE order_code = ?"
	 		 +" AND	  network_name =?";

Connection conn = null;
PreparedStatement stmt = null;
ResultSet result = null;

stmt = conn.prepareStatement(sql);
stmt.setString(1, LPINFO);
stmt.setString(2, search_order_code);
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
OutputStream os = con.getOutputStream();
os.write(send_data.toString().getBytes());
os.flush();
os.close();

%>
