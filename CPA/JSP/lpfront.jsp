<%
    String lp_info = request.getParameter("lpinfo");
    String url = request.getParameter("url");
    Int RETURN_DAYS = 7;

    if (lp_info == null || url == null) {
        out.print("<html><head><script type=\"text/javascript\"> alert('LPMS: Parameter Error'); history.go(-1);</script></head></html>");
    } else {
        response.setHeader("P3P", "CP=\"NOI DEVa TAIa OUR BUS UNI\"");

        Cookie lpinfo = new Cookie("LPINFO", lp_info);

        lpinfo.setDomain(".example.com");
        lpinfo.setPath("/");

        if (RETURN_DAYS != 0) {
            lpinfo.setMaxAge(60 * 60 * 24 * RETURN_DAYS);
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