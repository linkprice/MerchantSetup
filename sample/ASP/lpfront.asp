<%
    Dim lpinfo, url
    Const RETURN_DAYS = 7

    lpinfo = Request("lpinfo")
    url = Request("url")

    If IsEmpty(lpinfo) or IsEmpty(url) Then
%>
<html>
<head>
<script type="text/javascript">
<!--
	// alert: LPMS: Parameter Error
    alert('LPMS: 연결할 수 없습니다. 사이트 담당자에게 문의하시기 바랍니다.');
    history.go(-1);
//-->
</script>
</head>
</html>
<%
    Else
        Response.AddHeader "P3P", "CP=" & chr(34) & "NOI DEVa TAIa OUR BUS UNI" & chr(34)
        Response.Cookies("LPINFO") = lpinfo
        Response.Cookies("LPINFO").path = "/"
        Response.Cookies("LPINFO").domain = ".example.com"

        If RETURN_DAYS <> 0 Then
            Response.Cookies("LPINFO").expires = Date + RETURN_DAYS
        End If

        Response.Redirect(url)
    End If
%>