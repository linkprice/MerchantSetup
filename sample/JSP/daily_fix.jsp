<%
    /*
    # DataBase 접속

    # LINKPRICE 를 통해서 구매된 주문내역 QUERY
    # 	QUERY 조건  : 구매일자=yyyymmdd and 제휴사=링크프라이스
    # 	SELECT 컬럼 : 구매시간, LPINFO 쿠키, 구매자ID, 구매자이름, 주문번호, 상품코드, 주문수량, 상품단가
    #ex) query = "select * from 링크프라이스 실적테이블 where 날짜 = 'yyyymmdd' and 제휴사 = 'LINKPRICE'";
    */
    String connInfo = "jdbc:oracle:thin:@localhost:1521:orcl";
    java.sql.Connection conn = null;
    java.sql.Statement stmt = null;
    java.sql.ResultSet rs = null;

    Class.forName("oracle.jdbc.driver.OracleDriver");
    /*============================================*/
    //Properties 설정
    java.util.Properties props = new java.util.Properties();
    props.put("user","user");
    props.put("password","password");
    props.put("CHARSET","eucksc");

    conn = java.sql.DriverManager.getConnection(connInfo,props);

    // QUERY 결과가 $row 라는 변수에 저장되었다고 가정

    StringBuffer sb = new StringBuffer();
    int index = 0;
    String sql = "select * from 링크프라이스 실적테이블 where 날짜 = 'yyyymmdd'";
    try {
        stmt = conn.createStatement();
        stmt.executeQuery(sql);
        rs = stmt.getResultSet();

        while (rs.next())
        {
            sb = new StringBuffer();
            if (index > 0)	sb.append("\r\n");

            sb.append(rs.getString("HHMISS") + "\t");
            sb.append(rs.getString("LPINFO") + "\t");
            sb.append(rs.getString("ID") + "(" + rs.getString("NAME") + ")" + "\t");
            sb.append(rs.getString("ORDER_CODE") + "\t");
            sb.append(rs.getString("PRODUCT_CODE") + "\t");
            sb.append(rs.getString("ITEM_COUNT") + "\t");
            sb.append(rs.getString("PRICE") + "\t");
            sb.append(rs.getString("CATEGORY_CODE") + "\t\t");
            sb.append(rs.getString("PRODUCT_NAME") + "\t");
            sb.append(rs.getString("REMOTE_IP"));
            out.print (sb.toString());
            index++;
        }
    }
    catch(Exception e)
    {
        out.println (e.getMessage());
    }
    finally
    {
        if (rs != null) try {rs.close();} catch (Exception e) {}
        if (stmt != null) try {stmt.close();} catch (Exception e) {}
        if (conn != null)
        {
            try	{conn.close();}	catch (Exception e)	{}
        }
    }
%>