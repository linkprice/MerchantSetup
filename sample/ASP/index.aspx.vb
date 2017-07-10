Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports lpEncryption

Public Class WebForm1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim test As New lpEncrypt("./public.pem")

        'Dim lpInfo = Request.Cookies("LPINFO").Value
        Dim jarray = New JArray()
        Dim strArray() As String = {"mango", "melon"}

        jarray.Add("apple")
        jarray.Add("banana")

        'test.setJson("a_id", "lpInfo")
        test.setJson("m_id", "lastsave4")
        'test.setJson("mr_id", "lp_asp_test")
        test.setJson("o_cd", "shji")
        test.setJson("p_cd", String.Join("||", strArray))
        test.setJson("it_cnt", 1)
        test.setJson("sales", 100)
        test.setJson("c_cd", "mobile")
        'test.setJson("p_nm", "jordan11")

        Response.Write(test.encrypt)

        'test.submit()

    End Sub

End Class
