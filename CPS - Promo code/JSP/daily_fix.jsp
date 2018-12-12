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
String sql = new String();
String yyyymmdd = request.getParameter("yyyymmdd");
String NWNAME = "linkprice";                   //network name for linkprice

sql = "SELECT	event_code 		event_code,"
		+"promo_code			promo_code,"
	 	+"order_time 		order_time,"
	 	+"user_id 		member_id,"
	 	+"order_code 		order_code,"
		+"product_code 		product_code,"
	 	+"price 		sales,"
	 	+"product_name		product_name,"
	 	+"count 		item_count,"
	 	+"remote_address 	remote_addr,"
	 	+"u_agent 		user_agent"
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
