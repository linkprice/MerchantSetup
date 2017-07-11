<%@ page import="lpEncrypt.*" %>
<%@ page import="java.util.ArrayList"%>

<%
	lpEncrypt lpenc = new lpEncrypt("./public.pem");			//public.pem 경로 확인

	Cookie[] cookies = request.getCookies();
	Cookie cookie = null;
	String lpInfo = null;
	
	for (int i = 0; i < cookies.length; i++) {
		cookie = cookies[i];
		if (cookie.getName().equals("LPINFO")) {
			lpInfo = cookie.getValue();
		}
	}
	
	ArrayList<String> p_nm_list = new ArrayList<String>();			//여럭 상품 구매시 arrayList를 통하여 한번에 넘겨줍니다.
	ArrayList<String> c_cd_list = new ArrayList<String>();
	ArrayList<String> p_cd_list = new ArrayList<String>();
	ArrayList<Integer> it_cnt_list = new ArrayList<Integer>();
	ArrayList<Integer> sales_list = new ArrayList<Integer>();

	if (lpInfo != null) {
		lpenc.set("a_id", lpInfo);						//LPINFO 쿠키정보 (Cookie named LPINFO)
		lpenc.set("m_id", merchant_id);					//머천트 ID(Merchant ID in Linkprice system)
		lpenc.set("mbr_id", user_id);					//실적 발생 회원 ID(User ID who make business recorde in merchant system )
		lpenc.set("o_cd", order_code);					//주문코드(Order number)
		lpenc.set("p_cd", p_cd_list);					//상품코드(Product code)
		lpenc.set("it_cnt", it_cnt_list);				//상품개수(Number of product)
		lpenc.set("sales", sales_list);					//판매액(Sales amount)
		lpenc.set("c_cd", c_cd_list);					//카테고릐 코드(Category code)
		lpenc.set("p_nm", p_nm_list);					//상품이름	(Name of product)
		lpenc.set("user_agent", request.getHeader("User-Agent"));	//접속 디바이스 정보(Device infomation)
		lpenc.set("ip", request.getRemoteAddr());					//실적 발생 회원 IP(User IP)
	
		lpenc.submit();

	}
%>