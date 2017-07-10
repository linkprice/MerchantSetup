<%--
 LINKPRICE JSP용 실적 전송
 @date : 2017-06-08
 @mail : kimjs@linkprice.com
--%>

<%@ page import="lpEncrypt.*" %>
<%
lpEncrypt lpenc = new lpEncrypt("C:\\public.pem");
String cookie = "A100538694%7C24928375000001%7C0000%7C9%7C1%7Clsweb";
String ip = "211.211.211.221";

lpenc.set("a_id", cookie);
lpenc.set("m_id", "lastsave4");
lpenc.set("mbr_id", lpenc.escape("가나다라"));
lpenc.set("o_cd", "kjs503");
lpenc.set("p_cd", "member");
lpenc.set("it_cnt", "1");
lpenc.set("sales", "100");
lpenc.set("c_cd", "mobile");
lpenc.set("p_nm", lpenc.escape("가나다라"));
lpenc.set("remote_addr", ip);

lpenc.submit();
%>