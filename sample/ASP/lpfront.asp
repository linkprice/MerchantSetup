<%
    Dim a_id, m_id, p_id, l_id, l_cd1, l_cd2, rd, url

    a_id = Request("a_id")
    m_id = Request("m_id")
    p_id = Request("p_id")
    l_id = Request("l_id")
    l_cd1 = Request("l_cd1")
    l_cd2 = Request("l_cd2")
    rd = Request("rd")
    url = Request("url")

    If len(p_id) = 0 Then
        ctime = Int((datediff("s", "01/01/1970 00:00:00", now()) - (9*60*60))/ 60)
        new_seq = Int((Rnd * 99) + 1)
        p_id = ctime &  "FFFF" &  hex(new_seq)
    End If

    If IsEmpty(a_id) or IsEmpty(m_id) or IsEmpty(p_id) or IsEmpty(l_id) or IsEmpty(l_cd1) or IsEmpty(l_cd2) or IsEmpty(rd) or IsEmpty(url) Then
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
        Response.Cookies("LPINFO") = a_id & "|" & p_id & "|" & l_id & "|" & l_cd1 & "|" & l_cd2
        Response.Cookies("LPINFO").path = "/"
        Response.Cookies("LPINFO").domain = ".yoursite.com"

        If rd = 0 Then
            ' Response.Cookies("LPINFO").expires = 0
        Else
            Response.Cookies("LPINFO").expires = Date + rd
        End If

        Response.Redirect(url)
    End If
%>