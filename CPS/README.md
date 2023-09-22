# CPS (여행 광고주용) 셋업 가이드







# 1. 제휴 마케팅이란?

제휴 마케팅이란 제품/서비스 등을 판매하는 인터넷 업체(Merchant)가 고객을 끌어들이고 판매 촉진을 위해 다른 매체 사이트(Affiliate)와 제휴를 통해 홍보 활동을 진행합니다.
이 때 발생하는 수입을 홍보 활동을 진행했던 매체(Affiliate)와 공유하는 마케팅 기법입니다.

[제휴 마케팅에 대해 좀 더 자세히 알아보기](https://helpdesk.linkprice.com/pages/merchant-faq-introduce)



# 2. 링크프라이스-광고주 간 셋업

먼저 광고주로서 링크프라이스의 제휴마케팅 플랫폼을 이용하기 위해선 연동 작업을 필수적으로 해주셔야 합니다.
이러한 작업을 "셋업(Setup)"이라고 정의합니다.

셋업 작업을 위해선 크게 아래와 같이 필수적으로 작업 진행해주셔야 합니다.

![image-1](image1.png)

1. [광고주 사이트 내부에 게이트웨이 페이지 작업하기](#2-1. 게이트웨이 작업)

2. 실적 발생 시, 자체 별도 DB 테이블 생성 후 적재하기

3. 링크프라이스 실적 발생 시, 링크프라이스에게 실적 전송하기

4. 링크프라이스를 통해 발생된 실적에 대해 리스트를 제공하는 API 작업하기



## 2-1. 게이트웨이 작업

### 2-1-1. 작업이 필요한 이유

링크프라이스에 소속된 매체(Affiliate)들은 링크프라이스에서 제공하는 제휴링크를 통해 자신의 사이트 혹은 타 사이트에서 홍보활동을 진행합니다.

광고주 입장에서는 발생되는 실적이 링크프라이스의 실적인지를 판단할 수 있는 값(Tracking Code)이 필요한데요.

게이트웨이 페이지를 통해 클라이언트에 쿠키가 생성되고 이 생성된 쿠키를 가지고 실적을 트래킹하게 됩니다.



### 2-1-2. 개요

게이트웨이에서는 아래와 같은 동작을 합니다.

```
1. 파라미터 유효성 체크
2. 실적 트래킹을 위한 쿠키 생성
3. 광고주 사이트로 이동
```

링크프라이스의 제휴링크를 통해 광고주의 게이트웨이 페이지를 거쳐서 트래킹 코드가 생성된 이후, 광고주 사이트로 진입하게 됩니다.

![image-20210216180317429](image-20210216180317429.png)

### 2-1-3. 작업 방법

**Step1**. 링크프라이스에서 광고주에게 트래킹을 위한 자바스크립트 코드를 전달합니다.

**Step2**. 사이트 내부에 게이트웨이 페이지 URL를 생성 후, 링크프라이스에서 전달받은 자바스크립트 코드를 추가해주십시오.

> 내부적으로 트래킹을 위해서 링크프라이스에서는 Google Tag Manager 플랫폼을 사용 중입니다.
>
> 게이트웨이 구현의 경우 사용하시는 서버 환경에 따라 편하게 구현해주시면 됩니다.
>
> 예시)
>
> php 사용 시, https://[도메인]/linkprice/gateway.php
>
> jsp 사용 시, https://[도메인]/linkprice/gateway.jsp
>
> html 사용 시, https://[도메인]/linkprice/gateway.html

**Step3**. 구현한 게이트웨이 URL을 반드시 링크프라이스 담당자에게 전달바랍니다.

**Step4**. 링크프라이스에서는 광고주로부터 전달받은 URL을 내부 플랫폼에 반영한 이후, 제휴링크를 생성하여 전달드립니다.

> 최종적으로 아래 URL로 매체에서는 홍보활동을 진행합니다.
>
> 샘플 URL로 실제 URL과는 다릅니다.
>
> https://click.linkprice.com/click.php?m=clickbuy&a=A100000131&l=0000

**Step5**. 제휴링크로 진입하고 광고주 사이트로 이동 시, 브라우저 쿠키에 **LPINFO라는 트래킹 코드 쿠키**가 생성되었는지 확인합니다.



### 2-1-4. 샘플 코드

아래 샘플코드는 참고용으로 실제 코드와는 다릅니다.

반드시, **링크프라이스에서 제공하는 코드를 추가**바랍니다.

```javascript
<!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
     new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
     j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
     'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
   })(window,document,'script','dataLayer','GTM-P3HTV4');</script>
<!-- End Google Tag Manager -->
```



## 2-2. 실적 발생 시, 자체 별도 DB 테이블 생성 후 적재 작업

### 2-2-1. 작업이 필요한 이유

링크프라이스로 실시간으로 전송한 데이터가 네트워크 전송 지연 이슈나 프로그램 오류로 인해 전송되지 않을 수가 있습니다.

링크프라이스로 전송한 데이터와 광고주에 저장된 데이터를 대조하여 정산을 진행하고자 저장을 요청드리고 있습니다.

해당 테이블에 적재한 데이터는 실적목록 데이터 출력에 활용됩니다.



### 2-2-2. 작업 방법

**Step1**. 사용하시는 DB에 테이블을 생성합니다.

```sql
create table lpinfo(
  	id int(10) unsigned NOT NULL AUTO_INCREMENT,				 	# Unique Key
    order_id varchar(30),		 															# 링크프라이스에 전송할 주문번호
    product_id varchar(30),	 															# 링크프라이스에 전송할 상품코드
    lpinfo varchar(580),		 															# 링크프라이스 트래킹 코드 (쿠키명 LPINFO) 
    user_agent varchar(300), 															# 구매자의 User Agent 값
    ip varchar(50),					 															# 구매자의 IP
    device_type varchar(11)	 															# 구매자의 운영체제 환경
)
```

> 위 테이블 생성 쿼리는 Mysql 기준으로 드린 예시입니다.
>
> 데이터를 저장할 수 있다면 NoSql을 사용하셔도 됩니다.
>
> 컬럼 이름도 주어진 서버 환경에 맞춰 생성하시면 됩니다.

**Step2**. 실적 발생(=결제 완료) 시,  브라우저 쿠키에 저장된 LPINFO 쿠키가 존재 여부를 체크 후 DB 테이블에 적재해주십시오.



### 2-2-3. 샘플 코드

**JSP 예제**

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
  // 실적 발생!!
  
  String orderId = request.getParameter("order_id") != null ? request.getParameter("order_id") : "";
  String productId = request.getParameter("product_id") != null ? request.getParameter("product_id") : "";
  String lpinfo = request.getCookies() != null ? request.getCookies()[0].getValue() : "";
  String userAgent = request.getHeader("User-Agent") != null ? request.getHeader("User-Agent") : "";
  String ip = request.getRemoteAddr() != null ? request.getRemoteAddr() : "";
  
  /*
  web-pc : PC용 브라우저에서 발생된 실적
  web-mobile : 모바일 웹에서 발생된 실적
  app-android : 안드로이드 앱 환경에서 발생한 실적 (웹뷰 포함)
  app-ios : iOS 앱 환경에서 발생한 실적 (웹뷰 포함)
  */
  String deviceType = "web-pc";	

  Connection dbConnection = null;
  Statement statement = null;

  try {
    Class.forName("com.mysql.jdbc.Driver");
    dbConnection = DriverManager.getConnection("jdbc:mysql://localhost/DATABASE_NAME", "ID", "PASSWORD");
    
    if (lpinfo != null && !lpinfo.isEmpty()) {
      // 내부 DB에 실적 저장
      String query = "INSERT INTO lpinfo (order_id, product_id, lpinfo, user_agent, ip, device_type) VALUES (?, ?, ?, ?, ?, ?)";
      PreparedStatement preparedStatement = dbConnection.prepareStatement(query);
      preparedStatement.setString(1, orderId);
      preparedStatement.setString(2, productId);
      preparedStatement.setString(3, lpinfo);
      preparedStatement.setString(4, userAgent);
      preparedStatement.setString(5, ip);
      preparedStatement.setString(6, deviceType);
      
      preparedStatement.executeUpdate();
    }
  } catch (SQLException e) {
    e.printStackTrace();
  } catch (ClassNotFoundException e) {
    e.printStackTrace();
  } finally {
    if (statement != null) {
      try {
        statement.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
    if (dbConnection != null) {
      try {
        dbConnection.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  }
%>
```

**ASP 예제**

```asp
<%
' 실적 발생!!
Dim orderId
Dim productId
Dim lpinfo
Dim userAgent
Dim ip
Dim deviceType

orderId = Request("order_id")
productId = Request("product_id")
lpinfo = Request.Cookies("LPINFO")
userAgent = Request.ServerVariables("HTTP_USER_AGENT")
ip = Request.ServerVariables("REMOTE_ADDR")

' 디바이스 유형 설정
deviceType = "web-pc"

' MySQL 데이터베이스 연결
Dim dbConnection
Set dbConnection = Server.CreateObject("ADODB.Connection")
dbConnection.Open "Driver={MySQL ODBC 8.0 Unicode Driver};Server=localhost;Database=DATABASE_NAME;Uid=ID;Pwd=PASSWORD;"

If Not lpinfo = "" Then
    ' 내부 DB에 실적 저장
    Dim query
    query = "INSERT INTO lpinfo (order_id, product_id, lpinfo, user_agent, ip, device_type) VALUES (?, ?, ?, ?, ?, ?)"
    
    Dim cmd
    Set cmd = Server.CreateObject("ADODB.Command")
    cmd.ActiveConnection = dbConnection
    cmd.CommandText = query
    cmd.CommandType = 1 ' adCmdText
    
    cmd.Parameters.Append cmd.CreateParameter("@order_id", 200, 1, 50, orderId)
    cmd.Parameters.Append cmd.CreateParameter("@product_id", 200, 1, 50, productId)
    cmd.Parameters.Append cmd.CreateParameter("@lpinfo", 200, 1, 255, lpinfo)
    cmd.Parameters.Append cmd.CreateParameter("@user_agent", 200, 1, 255, userAgent)
    cmd.Parameters.Append cmd.CreateParameter("@ip", 200, 1, 50, ip)
    cmd.Parameters.Append cmd.CreateParameter("@device_type", 200, 1, 50, deviceType)
    
    cmd.Execute
End If

dbConnection.Close
Set dbConnection = Nothing
%>

```

**PHP 예제**

```php
<?php
  // 실적 발생!!
  
  $orderId 		= $_REQUEST['order_id'] ?? '';
	$productId 	= $_REQUEST['product_id'] ?? '';
	$lpinfo			= $_COOKIE['LPINFO'] ?? '';
	$userAgent	= $_SERVER['HTTP_USER_AGENT'] ?? '';
	$ip					= $_SERVER["REMOTE_ADDR"] ?? '';
	
	/*
	web-pc : PC용 브라우저에서 발생된 실적
	web-mobile : 모바일 웹에서 발생된 실적
	app-android : 안드로이드 앱 환경에서 발생한 실적 (웹뷰 포함)
	app-ios : iOS 앱 환경에서 발생한 실적 (웹뷰 포함)
	*/
	$deviceType	= 'web-pc';	

	$dbConnection = mysqli_connect("localhost", "ID", "PASSWORD", "DATABASE_NAME");
  
  if(isset($_COOKIE['LPINFO']) && !empty($_COOKIE['LPINFO'])) {
    //내부 DB에 실적 저장
    $query = "
    INSERT INTO `lpinfo` (
    	order_id, product_id, lpinfo, user_agent, ip, device_type
    ) VALUE (
    	'$orderId', '$productId', '$lpinfo', '$userAgent', '$ip', '$deviceType' 
    )";
    
    $result = mysqli_query($dbConnection, $query);
  }
```



## 2-3. 링크프라이스 실적 발생 시, 링크프라이스에게 실적 전송하기

### 2-3-1. 작업이 필요한 이유

링크프라이스의 제휴링크로 유입되어 발생된 실적에 대해서 링크프라이스가 요구하는 스펙에 맞춰 반드시 실시간으로 실적 전송을 해주셔야 합니다.

실시간으로 실적 전송이 어려우시다면 담당자에게 문의바랍니다.



### 2-3-2. 개요

```
1. 실적이 발생!
2. 게이트웨이에서 생성된 링크프라이스 트래킹 코드(LPINFO 쿠키) 존재하는지 여부 확인
3. 트래킹 코드가 있다면 링크프라이스의 실적 수집 프로그램으로 실적을 전송
```



### 2-3-3. 작업 방법

**Step1**. 링크프라이스 실적 수집 프로그램에 실적을 전송하기 위해 아래 요구 스펙을 참고합니다.



**2-3-2-1. 실적 수집 프로그램 개요**


|제목|내용|
|------|---|
|요청 URL|https://service.linkprice.com/lppurchase_cps_v4.php|
|프로토콜|https|
|HTTP 메서드|POST|
|요청 바디 타입|RAW Data|
|요청 파라미터 형식|JSON 문자열|
|응답 파라미터 형식|JSON 문자열|

**2-3-2-2. REQUEST 파라미터**

| KEY                                         | 값                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | 타입             |
|---------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|
| order               | 주문 데이터 정보                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | object         |
| order.order_id      | 상품 고유 주문번호 <br><span style="font-size:75%">링크프라이스에서는 매체에게 누락 문의를 전달받으면 이 주문번호를 기준으로 누락 여부를 조회</span>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | varchar(100)   |
| order.final_paid_price | 배송비를 제외한 구매자의 실결제한 전체 금액<br><span style="font-size:75%">무료 배송이 아닌 배송비를 구매자가 부담 시, 배송비를 제외한 전체 결제금액</span>                                                                                                                                                                                                                                                                                                                                                                                                          | float          |
| order.currency      | 상품 결제시 사용된 통화<br><span style="font-size:75%">ISO 4217 사용<br>예) 미국 : USD, 원화 : KRW, 위안화 : CNY, 유로화 : EUR</span>                                                                                                                                                                                                                                                                                                                                                                                                                                                   | varchar(3)     |
| order.user_name     | 구매자명<br><span style="font-size:75%">누락문의 시, 누구의 실적인지를 구분하기 위해 사용 할 <br>개인정보 이슈로 인해 마스킹 처리 권장<br>예시) 김\*\*, 이\*\*</span>                                                                                                                                                                                                                                                                                                                                                                                                                                         | varchar(100)   |
| products[]          | 상품 개별 데이터 리스트                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | array< object > |
| products[].product_id | 상품 ID                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | varchar(100)   |
| products[].product_name | 상품 이름                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | varchar(300)   |
| products[].category_code | 상품 카테고리 코드                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | varchar(200)   |
| products[].category_name | 상품 카테고리 이름 <br><span style="font-size:75%">가급적 해당 상품의 모든 카테고리 이름 기입<br>예를 들면 의류 > 남성의류 > 자켓 > 아우터 일 경우 아래와 같이 전송<br>  "category_name": ["의류", "남성의류", "자켓", "아우터"]</span>                                                                                                                                                                                                                                                                                                                                                                | varchar(100)   |
| products[].quantity | 구매 상품 갯수                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | int(11)        |
| products[].product_final_price | 상품 최종 금액                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | float          |
| products[].paid_at  | 주문 완료 시간<br><span style="font-size:75%">주문 완료 시간이란 결제가 성공한 시간을 의미. <br>Date Format : ISO-8601 (데이터 포맷은 예시와 동일해야 함) <br><br>예시1) 대한민국(UTC+09:00 시간대)에서 2021년 01월 10일 오후 3시 44분 52초에 완료된 주문 <br>paid_at : “2021-01-10T15:44:52+09:00”<br><br>예시2) 중국(UTC+08:00 시간대)에서 2021년 01월 12일 오전 08시 32분 11초에 완료된 주문<br>paid_at : “2021-01-12T08:32:11+08:00”<br><br>예시3) 미국(UTC-05:00 시간대)에서 2021년 01월 13일 오후 1시 11분 21초에 완료된 주문<br>paid_at : “2021-01-13T13:11:21-05:00”</span>                                                                                       | datetime       |
| products[].confirmed_at | 구매 확정 시간<br><span style="font-size:75%">* 구매 확정 시간이란 쇼핑몰에서 지정한 환불/취소 기간이 지나 더 이상 환불/취소가 불가능한 상태가 된 시간을 의미<br>* 구매 확정 되지 않았다면 공백 문자열("")을 전송<br>* Date Format : ISO-8601 (데이터 포맷은 예시와 동일해야합니다.)<br><br>- 예시) 대한민국(UTC+09:00 시간대)에서 2021년 01월 15일 오후 3시 44분 52초에 구매 확정된 주문<br>confirmed_at : “2021-01-15T15:44:52+09:00”<br><br>- 예시) 중국(UTC+08:00 시간대)에서 2021년 01월 17일 오전 08시 32분 11초에 구매 확정된 주문<br>confirmed_at : “2021-01-17T08:32:11+08:00”<br><br>- 예시) 미국(UTC-05:00 시간대)에서 2021년 01월 18일 오후 1시 11분 21초에 구매 확정된 주문<br>confirmed_at: “2021-01-18T13:11:21-05:00”</span> | datetime       |
| products[].canceled_at | 구매 취소 시간<br><span style="font-size:75%">구매 취소 시간이란 구매자의 요청으로 환불, 취소, 반품 등 처리가 완료된 시간을 의미<br>구매 취소 되지 않았다면 공백 문자열("")을 전송<br>Date Format : ISO-8601 (데이터 포맷은 예시와 동일해야합니다.)<br><br>- 예시1) 대한민국(UTC+09:00 시간대)에서 2021년 01월 20일 오전07시 11분 13초에 구매 취소된 주문<br>canceled_at : “2021-01-15T07:11:13+09:00”<br><br>- 예시2) 중국(UTC+08:00 시간대)에서 2021년 01월 22일 오후 05시 21분 09초에 구매 취소된 주문<br>canceled_at : “2021-01-22T17:21:09+08:00”<br><br>- 예시3) 미국(UTC-05:00 시간대)에서 2021년 01월 25일 오전 03시 20분 21초에 구매 취소된 주문<br>canceled_at: “2021-01-25T03:20:21-05:00”</span>             | datetime       |
| linkprice           | 링크프라이스에서 필요한 데이터                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | object         |
| linkprice.merchant_id | 링크프라이스로부터 발급받은 광고주 ID                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | varchar(10)    |
| linkprice.lpinfo    | 링크프라이스에서 유입된 트래킹 코드(=LPINFO 쿠키)                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | varchar(500)   |
| linkprice.user_agent | USER AGENT 정보                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | varchar(1000)  |
| linkprice.remote_addr | 구매자 IP주소<br><span style="font-size:75%">개인정보 이슈로 가급적 마스킹 처리 권장.<br>예시) 118.221.\*.\*</span>                                                                                                                                                                                                                                                                                                                                                                                                                                                             | varchar(100)   |
| linkprice.device_type | 사용자 장치 타입<br><span style="font-size:75%">- web-pc: PC 웹브라우저에서 발생한 실적<br>- web-mobile: 모바일웹 브라우저에서 발생한 실적<br>- app-ios: iOS 앱(혹은 웹뷰)에서 발생한 실적<br>- app-android: Android 앱(혹은 웹뷰)에서 발생한 실적</span>                                                                                                                                                                                                                                                                                                                | varchar(10)    |

**REQUEST 파라미터 예제**

```json
{
    "order": {
        "order_id": "o190203-h78X3",
        "final_paid_price": 29000,
        "currency": "KRW",
        "user_name": "김**"
    },
    "products": [
        {
            "product_id": "P87-234-anx87",
            "product_name": "UHD 4K 넥시 HDMI케이블",
            "category_code": "132782",
            "category_name": ["컴퓨터 주변기기", "케이블", "HDMI케이블"],
            "quantity": 2,
            "product_final_price": 12687,
            "paid_at": "2019-02-12T11:13:44+09:00",
            "confirmed_at": "",
            "canceled_at": ""
        },
        {
            "product_id": "P23-983-Z3272",
            "product_name": "농심 오징어짬뽕124g(5개)",
            "category_code": "237018",
            "category_name": ["가공식품", "라면", "봉지라면"],
            "quantity": 3,
            "product_final_price": 16312,
            "paid_at": "2019-02-12T11:13:44+09:00",
         	  "confirmed_at": "",
            "canceled_at": ""
     		}
    ],
    "linkprice": {
        "merchant_id": "sample",
        "lpinfo": "A123456789|9832|A|m|a8uakljfa",
     		"user_agent": "Mozilla/5.0...",
        "remote_addr": "118.221.*.*",
        "device_type": "web-pc"
    }
}
```



**Step2**. 서버 환경에 맞춰 링크프라이스 실적 수집 프로그램에 실적을 전송하는 프로그램을 작성 합니다.



**시나리오 가정)**

```
구매자가 링크프라이스 제휴링크를 타고 쇼핑몰로 인입하였다.
쇼핑몰에서 7,000원짜리 HDMI 케이블2개, 6,000원짜리 봉지라면 3개를 장바구니에 담았다.
해당 상품은 무료배송 상품이었고 결제 화면에서 할인쿠폰 3000원을 사용하고는 결제를 완료하였다.
```



**시나리오 플로우)**

```
각 상품 최종 금액에 대해 할인금액 적용 수식)
상품최종금액 - 할인금액 * 상품최종금액 / 주문최종금액 = 할인적용된 최종금액

할인쿠폰 적용전에 결제해야 할 금액은 32,000원 입니다.
3,000원짜리 할인쿠폰을 사용하였으니 최종적으로 구매자가 지불해야 할 금액은 29,000원입니다
할인쿠폰 사용전에는 HDMI 케이블의 상품 최종 금액(products[].product_final_price)은 14,000원이었지만 3,000원짜리 할인쿠폰을 사용하였으므로 14,000 - 3,000 * 14,000 / 32,000 = 12,687.5원 입니다.

할인쿠폰 적용전에 봉지라면의 상품 최종 금액(products[].product_final_price)은 18,000원 이었는데 3,000원 할인쿠폰을 사용하였으므로 18,000 - 3,000 * 18,000 / 32,000 = 16,312.5원 입니다.

상품 최종 금액(products[].product_final_price)의 합은 주문 최종 금액(order.final_paid_price)과 같아야 하지만, 소수점 버림으로 인한 절삭 금액으로 인해 한자리 수 금액이 차이가 발생될 수 있습니다.
링크프라이스 실적 수집 프로그램에서는 금액의 한자리 수 단위 차이는 허용하고 있습니다.

주문 최종 금액 계산 예시)
12687.5(products[].product_final_price) + 16312.5(products[].product_final_price) = 29000(order.final_paid_price)
```



### 2-3-4. 샘플 코드

JSP 예제

```jsp
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.json.*" %>

<%
// 주문 정보
JSONObject order = new JSONObject();
order.put("order_id", "ORDER1234");
order.put("final_paid_price", 60000);
order.put("currency", "KRW");
order.put("user_name", "김링크");

// 상품 정보 배열
JSONArray products = new JSONArray();

// 상품1
JSONObject product1 = new JSONObject();
product1.put("product_id", "product_id1");
product1.put("product_name", "상품 이름1");
product1.put("category_code", "상품 카테고리1");
product1.put("category_name", "상품 카테고리 이름1");
product1.put("quantity", 2);
product1.put("product_final_price", 10000);
product1.put("paid_at", "2023-09-22T11:13:44+09:00");
product1.put("confirmed_at", "");
product1.put("canceled_at", "");
products.put(product1);

// 상품2
JSONObject product2 = new JSONObject();
product2.put("product_id", "product_id2");
product2.put("product_name", "상품 이름2");
product2.put("category_code", "상품 카테고리2");
product2.put("category_name", "상품 카테고리 이름2");
product2.put("quantity", 3);
product2.put("product_final_price", 50000);
product2.put("paid_at", "2023-09-22T11:13:44+09:00");
product2.put("confirmed_at", "");
product2.put("canceled_at", "");
products.put(product2);

// 링크프라이스에서 필요한 데이터
JSONObject linkprice = new JSONObject();
linkprice.put("merchant_id", "clickbuy");
linkprice.put("lpinfo", ""); // lpinfo 값을 설정해야 합니다.
linkprice.put("user_agent", request.getHeader("User-Agent"));
linkprice.put("remote_addr", request.getRemoteAddr());
linkprice.put("device_type", "web-pc");

// 전체 데이터
JSONObject purchases = new JSONObject();
purchases.put("order", order);
purchases.put("products", products);
purchases.put("linkprice", linkprice);

// JSON 형식으로 변환
String postData = purchases.toString();

// HTTP POST 요청
String url = "https://service.linkprice.com/lppurchase_cps_v4.php";
URLConnection connection = new URL(url).openConnection();
connection.setDoOutput(true);
connection.setRequestProperty("Content-Type", "application/json");

try (OutputStream os = connection.getOutputStream()) {
    byte[] input = postData.getBytes("utf-8");
    os.write(input, 0, input.length);
}

try (BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "utf-8"))) {
    StringBuilder response = new StringBuilder();
    String responseLine = null;
    while ((responseLine = br.readLine()) != null) {
        response.append(responseLine.trim());
    }
    
    // 링크프라이스 실적 수집 프로그램으로부터 전달받은 응답 데이터
    out.println(response.toString());
}
%>
```



**ASP 예제**

```asp
<%
' 링크프라이스 실적 수집 프로그램으로 실적 전송 예제

' 주문 정보
Dim order
Set order = Server.CreateObject("Scripting.Dictionary")
order("order_id") = "ORDER1234"
order("final_paid_price") = 60000
order("currency") = "KRW"
order("user_name") = "김링크"

' 상품 정보
Dim products
Set products = Server.CreateObject("Scripting.Dictionary")

' 상품1
Dim product1
Set product1 = Server.CreateObject("Scripting.Dictionary")
product1("product_id") = "product_id1"
product1("product_name") = "상품 이름1"
product1("category_code") = "상품 카테고리1"
product1("category_name") = "상품 카테고리 이름1"
product1("quantity") = 2
product1("product_final_price") = 10000
product1("paid_at") = "2023-09-22T11:13:44+09:00"
product1("confirmed_at") = ""
product1("canceled_at") = ""
products.Add product1("product_id"), product1

' 상품2
Dim product2
Set product2 = Server.CreateObject("Scripting.Dictionary")
product2("product_id") = "product_id2"
product2("product_name") = "상품 이름2"
product2("category_code") = "상품 카테고리2"
product2("category_name") = "상품 카테고리 이름2"
product2("quantity") = 3
product2("product_final_price") = 50000
product2("paid_at") = "2023-09-22T11:13:44+09:00"
product2("confirmed_at") = ""
product2("canceled_at") = ""
products.Add product2("product_id"), product2

' 링크프라이스에서 필요한 데이터
Dim linkprice
Set linkprice = Server.CreateObject("Scripting.Dictionary")
linkprice("merchant_id") = "clickbuy"
linkprice("lpinfo") = ""
linkprice("user_agent") = Request.ServerVariables("HTTP_USER_AGENT")
linkprice("remote_addr") = Request.ServerVariables("REMOTE_ADDR")
linkprice("device_type") = "web-pc"

' 전체 데이터
Dim purchases
Set purchases = Server.CreateObject("Scripting.Dictionary")
purchases.Add "order", order
purchases.Add "products", products
purchases.Add "linkprice", linkprice

' JSON 형식으로 변환
Function ConvertToJson(obj)
    Dim jsonObj, key
    Set jsonObj = Server.CreateObject("Scripting.Dictionary")
    For Each key In obj.Keys
        jsonObj.Add key, obj(key)
    Next
    ConvertToJson = Join(obj.Keys, ", ")
End Function

Dim postData
postData = ConvertToJson(purchases)

' HTTP POST 요청
Dim objXMLHTTP
Set objXMLHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP")
objXMLHTTP.Open "POST", "https://service.linkprice.com/lppurchase_cps_v4.php", False
objXMLHTTP.setRequestHeader "Content-Type", "application/json"
objXMLHTTP.send postData

' 링크프라이스 실적 수집 프로그램으로부터 전달받은 응답 데이터
Response.Write objXMLHTTP.responseText

Set objXMLHTTP = Nothing
%>
```



**PHP 예제**

```php
<?php
/**
 * 링크프라이스 실적 수집 프로그램으로 실적 전송 예제
 */

$purchases = [];

//주문 정보
$purchases['order'] = [
    'order_id'          => 'ORDER1234',
    'final_paid_price'  => 60000,
    'currency'          => 'KRW',
    'user_name'         => '김링크' 
];

//상품 정보
$purchases['products'] = [];

//상품1
$purchases['products'][] = [
    'product_id'            => 'product_id1',
    'product_name'          => '상품 이름1',
    'category_code'         => '상품 카테고리1',
    'category_name'         => '상품 카테고리 이름1',
    'quantity'              => 2,
    'product_final_price'   => 10000,
    'paid_at'               => '2023-09-22T11:13:44+09:00',
    'confirmed_at'          => '',
    'canceled_at'           => ''
];

//상품2
$purchases['products'][] = [
    'product_id'            => 'product_id2',
    'product_name'          => '상품 이름2',
    'category_code'         => '상품 카테고리2',
    'category_name'         => '상품 카테고리 이름2',
    'quantity'              => 3,
    'product_final_price'   => 50000,
    'paid_at'               => '2023-09-22T11:13:44+09:00',
    'confirmed_at'          => '',
    'canceled_at'           => ''
];

// 링크프라이스에서 필요한 데이터
$purchases['linkprice'] = [
    'merchant_id'   => 'clickbuy',
    'lpinfo'        => $lpinfo,
    'user_agent'    => $_SERVER['HTTP_USER_AGENT'] ?? '',
    'remote_addr'   => $_SERVER['REMOTE_ADDR'] ?? '',
    'device_type'   => 'web-pc'
];

$postData = json_encode($purchases);

$curl = curl_init();

curl_setopt_array($curl, [
  CURLOPT_URL               => 'https://service.linkprice.com/lppurchase_cps_v4.php',
  CURLOPT_RETURNTRANSFER    => true,
  CURLOPT_HTTP_VERSION      => CURL_HTTP_VERSION_1_1,
  CURLOPT_CUSTOMREQUEST     => 'POST',
  CURLOPT_POSTFIELDS        => $p
]);

$response = curl_exec($curl);
curl_close($curl);

//링크프라이스 실적 수집 프로그램으로부터 전달받은 응답 데이터
echo $response;
```



## 2-4. 링크프라이스를 통해 발생된 실적에 대해 리스트를 제공하는 API 작업하기

### 2-4-1. 작업이 필요한 이유

