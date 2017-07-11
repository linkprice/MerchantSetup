Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq
Imports lpEncryption

Public Class WebForm1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim lpenc As New lpEncrypt("./public.pem")

        Dim lpInfo = Request.Cookies("LPINFO").Value

        Dim p_nm = New JArray()				'여러상품 구매시 array을 이용하여 초기화 할수있습니다. 
        Dim p_cd = New JArray()				'예)  p_nm_arr이라는 상품이름 array가 있을때
        Dim c_cd = New JArray()				'     Dim p_nm = New JArray(p_nm_arr)
        Dim sales = New JArray()
        Dim it_cnt = New JArray()

        If lpInfo <> "" Then
            lpenc.setJson("a_id", lpInfo)							'LPINFO 쿠키정보 (Cookie named LPINFO)
            lpenc.setJson("m_id", merchant_id)						'머천트 ID(Merchant ID in Linkprice system)
            lpenc.setJson("mbr_id", user_id)						'실적 발생 회원 ID(User ID who make business recorde in merchant system )
            lpenc.setJson("o_cd", order_code)						'주문코드(Order number)
            lpenc.setJson("p_cd", p_cd)								'상품코드(Product code)
            lpenc.setJson("it_cnt", it_cnt)							'상품개수(Number of product)
            lpenc.setJson("sales", sales)							'판매액(Sales amount)
            lpenc.setJson("c_cd", c_cd)								'카테고릐 코드(Category code)
            lpenc.setJson("p_nm", p_nm)								'상품이름	(Name of product)
            lpenc.setJson("user_agent", Request.ServerVariables("HTTP_USER_AGENT"))		'접속 디바이스 정보(Device infomation)
            lpenc.setJson("ip", Request.ServerVariables("REMOTE_ADDR"))			'실적 발생 회원 IP(User IP)

            lpenc.submit()
        End If

    End Sub

End Class
