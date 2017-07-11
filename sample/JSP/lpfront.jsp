<%
    String a_id = request.getParameter("a_id");
    String m_id = request.getParameter("m_id");
    String p_id = request.getParameter("p_id");
    String l_id = request.getParameter("l_id");
    String l_cd1 = request.getParameter("l_cd1");
    String l_cd2 = request.getParameter("l_cd2");
    String rd = request.getParameter("rd");
    String url = request.getParameter("url");

    if (a_id == null || m_id == null || p_id == null || l_id == null || l_cd1 == null || l_cd2 == null || url == null)
    {
        out.print("<html><head><script type=\"text/javascript\"> alert('LPMS: Parameter Error'); history.go(-1);</script></head></html>");
    }
    else
    {
        response.setHeader("P3P", "CP=\"NOI DEVa TAIa OUR BUS UNI\"");

        Cookie lpinfo = new Cookie("LPINFO", a_id + "|" + p_id + "|" + l_id + "|" + l_cd1 + "|" + l_cd2);

        lpinfo.setDomain(".yoursite.com");
        lpinfo.setPath("/");

        if (Integer.parseInt(rd) != 0)
        {
            lpinfo.setMaxAge(60 * 60 * 24 * Integer.parseInt(rd));
        }

        response.addCookie(lpinfo);
    }
%>
<html>
<head>
<script type="text/javascript">
document.location.replace("<%=url%>");
</script>
</head>
</html>