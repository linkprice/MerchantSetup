# CPA 셋업 가이드

# 1. 제휴 마케팅이란?

제휴 마케팅이란 제품/서비스 등을 판매하는 인터넷 업체인 광고주(Merchant)[^1]가 고객을 끌어들이고 판매 촉진을 위해 다른 매체 사이트(Affiliate)[^2]와 제휴를 통해 홍보 활동을 진행합니다.
이 때 발생하는 수입을 홍보 활동을 진행했던 매체(Affiliate)와 공유하는 마케팅 기법입니다.

[제휴 마케팅에 대해 좀 더 자세히 알아보기](https://helpdesk.linkprice.com/pages/merchant-faq-introduce)

# 2. 링크프라이스-광고주 간 셋업

먼저 광고주로서 링크프라이스의 제휴마케팅 플랫폼을 이용하기 위해선 연동 작업을 필수적으로 해주셔야 합니다.
이러한 작업을 저희는 **"머천트 셋업(Merchant Setup)"이라고 정의**합니다.

셋업 작업을 위해선 아래 작업들을 진행해주셔야 합니다.

## 2-1. 연동 흐름과 광고주 작업 내역

![image-1](../CPS/image1.png)

(1) 광고주 게이트웨이

[광고주 사이트 내부에 게이트웨이 페이지 작업하기](#2-2-광고주-게이트웨이-작업)

(2) 실적 데이터 DB 적재

[실적 발생 시, 자체 별도 DB 테이블 생성 후 적재하기](#2-3-실적-발생-시-자체-별도-db-테이블-생성-후-적재-작업)

(3) 실적 전송

[링크프라이스 실적 발생 시, 링크프라이스에게 실적 전송하기](#2-4-링크프라이스-실적-발생-시-링크프라이스에게-실적-전송하기)

(4) 실적 리스트 API

[링크프라이스의 실적으로 실적 리스트 API 작업하기](#2-5-링크프라이스의-실적으로-실적-리스트-api-작업하기)


## 2-2. 광고주 게이트웨이 작업

### 2-2-1. 작업이 필요한 이유

링크프라이스에 소속된 매체(Affiliate)[^2]들은 링크프라이스에서 제공하는 제휴 링크[^3]를 통해 자신의 사이트 혹은 타 사이트에서 홍보활동을 진행합니다.

광고주 입장에서는 발생되는 실적이 링크프라이스의 실적인지를 판단할 수 있는 값(Tracking Code)이 필요합니다.

이 트래킹 코드를 링크프라이스에서는 **"LPINFO" 라고 정의**[^5]합니다.

광고주 게이트웨이[^4]를 통해 클라이언트에 쿠키가 생성되고 이 생성된 쿠키를 가지고 실적을 트래킹하게 됩니다.



### 2-2-2. 개요

광고주 게이트웨이[^4]에서는 아래와 같은 동작을 합니다.

```
1. 파라미터 유효성 체크
2. 실적 트래킹을 위한 쿠키 생성
3. 광고주 사이트로 이동
```

링크프라이스의 제휴링크를 통해 광고주 게이트웨이 페이지를 거쳐서 트래킹 코드가 생성된 이후, 광고주 사이트로 진입하게 됩니다.

![image-20210216180317429](../CPS/image-20210216180317429.png)

### 2-2-3. 작업 방법

**Step1**. 링크프라이스에서 광고주에게 실적 트래킹을 위한 자바스크립트 코드를 전달합니다.

> 해당 자바스크립트 코드는 광고주 사이트 내에 실적 트래킹을 위한 쿠키 생성 후 광고주 사이트로 리다이렉션하는 코드가 내장되어 있습니다.
>
> 다만 광고주 사이트의 환경에 따라 해당 코드는 다르게 셋팅될 수 있습니다.

**Step2**. 사이트 내부에 게이트웨이 페이지 URL를 생성 후, 링크프라이스에서 전달받은 자바스크립트 코드를 추가해주십시오.

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

**Step5**. 제휴링크로 진입하고 광고주 사이트로 이동 시, 브라우저 쿠키에 **\"LPINFO\"이라는 이름의 트래킹 코드 쿠키**가 생성되었는지 확인합니다.



### 2-2-4. 샘플 코드

링크프라이스에서는 셋팅 작업 시, 광고주에게 생성된 자바스크립트 코드를 전달해 드립니다.

게이트웨이 페이지에 **전달받으신 자바스크립트 코드만 수정없이 삽입**바랍니다.

다른 코드가 혼재되어 있을 경우 페이지 랜딩과 LPINFO 쿠키 생성이 작동되지 않을 수 있습니다.

해당 코드를 전달받지 못했을 시, 링크프라이스 담당자에게 연락바랍니다.
아래 샘플코드는 참고용으로 실제 코드와는 다릅니다.

```javascript
<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-P3HTV4');</script>
<!-- End Google Tag Manager -->
```



## 2-3. 실적 발생 시, 자체 별도 DB 테이블 생성 후 적재 작업

### 2-3-1. 작업이 필요한 이유

링크프라이스로 실시간으로 전송한 데이터가 네트워크 전송 지연 이슈나 프로그램 오류로 인해 전송되지 않을 수가 있습니다.

링크프라이스로 전송한 데이터와 광고주에 저장된 데이터를 대조하여 정산을 진행하고자 저장을 요청드리고 있습니다.

적재하신 데이터는 [2-5. 실적 리스트 API 작업](#2-5-링크프라이스의-실적으로-실적-리스트-api-작업하기)에 활용됩니다.



### 2-3-2. 작업 방법

**Step1**. 사용하시는 DB에 테이블을 생성합니다.

```sql
create table lpinfo(
    id int(10) unsigned NOT NULL AUTO_INCREMENT,	# Unique Key
    unique_id varchar(30),		 				    # 링크프라이스에 전송할 회원번호
    member_id varchar(30),	 					    # 링크프라이스에 전송할 회원ID
    lpinfo varchar(580),		 				    # 링크프라이스 트래킹 코드 (쿠키명 LPINFO) 
    user_agent varchar(300), 					    # 구매자의 User Agent 값
    ip varchar(50),					 			    # 구매자의 IP
    device_type varchar(11)	 					    # 구매자의 운영체제 환경
)
```

> 위 테이블 생성 쿼리는 Mysql 기준으로 드린 예시입니다.
>
> 데이터를 저장할 수 있다면 NoSql을 사용하셔도 됩니다.
>
> 컬럼 이름도 주어진 서버 환경에 맞춰 생성하시면 됩니다.

**Step2**. 실적 발생(=회원 가입 완료) 시,  브라우저 쿠키에 저장된 LPINFO 쿠키가 존재 여부를 체크 후 DB 테이블에 적재해주십시오.



### 2-3-3. 샘플 코드

**※ 주의**

샘플 코드는 PHP 코드를 기준으로 작성하여 Chat GPT를 통해 JSP, ASP 코드를 생성한 예제입니다.

반드시 예제 코드로 구현을 해야 할 필요는 없으며 예제로만 참고 부탁드립니다.

광고주 서버 환경에 맞춰 구현 바랍니다.



**JSP 예제**

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
  // 실적 발생!!
  
  String uniqueId = request.getParameter("unique_id") != null ? request.getParameter("unique_id") : "";
  String memberId = request.getParameter("member_id") != null ? request.getParameter("member_id") : "";
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
      String query = "INSERT INTO lpinfo (unique_id, member_id, lpinfo, user_agent, ip, device_type) VALUES (?, ?, ?, ?, ?, ?)";
      PreparedStatement preparedStatement = dbConnection.prepareStatement(query);
      preparedStatement.setString(1, uniqueId);
      preparedStatement.setString(2, memberId);
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
Dim uniqueId
Dim memberId
Dim lpinfo
Dim userAgent
Dim ip
Dim deviceType

uniqueId = Request("unique_id")
memberId = Request("member_id")
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
    query = "INSERT INTO lpinfo (unique_id, member_id, lpinfo, user_agent, ip, device_type) VALUES (?, ?, ?, ?, ?, ?)"
    
    Dim cmd
    Set cmd = Server.CreateObject("ADODB.Command")
    cmd.ActiveConnection = dbConnection
    cmd.CommandText = query
    cmd.CommandType = 1 ' adCmdText
    
    cmd.Parameters.Append cmd.CreateParameter("@unique_id", 200, 1, 50, uniqueId)
    cmd.Parameters.Append cmd.CreateParameter("@member_id", 200, 1, 50, memberId)
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
  
    $uniqueId   = $_REQUEST['unique_id'] ?? '';
	$memberId 	= $_REQUEST['member_id'] ?? '';
	$lpinfo		= $_COOKIE['LPINFO'] ?? '';
	$userAgent	= $_SERVER['HTTP_USER_AGENT'] ?? '';
	$ip			= $_SERVER["REMOTE_ADDR"] ?? '';
	
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
    	unique_id, member_id, lpinfo, user_agent, ip, device_type
    ) VALUE (
    	'$uniqueId', '$memberId', '$lpinfo', '$userAgent', '$ip', '$deviceType' 
    )";
    
    $result = mysqli_query($dbConnection, $query);
  }
```

## 2-4. 링크프라이스 실적 발생 시, 링크프라이스에게 실적 전송하기

### 2-4-1. 작업이 필요한 이유

링크프라이스의 제휴링크로 유입되어 발생된 실적에 대해서 링크프라이스가 요구하는 스펙에 맞춰 반드시 실시간으로 실적 전송을 해주셔야 합니다.

실시간으로 실적 전송이 어려우시다면 담당자에게 문의바랍니다.

### 2-4-2. 개요

```
1. 실적 발생!
2. 게이트웨이에서 생성된 링크프라이스 트래킹 코드(LPINFO 쿠키) 존재하는지 여부 확인
3. 트래킹 코드가 있다면 링크프라이스의 실적 수집 프로그램으로 실적을 전송
```

### 2-4-3. 작업 방법

**Step1**. 링크프라이스 실적 수집 프로그램에 실적을 전송하기 위해 아래 요구 스펙을 참고합니다.

**2-4-3-1. REQUEST 개요**

| 제목         | 내용                                                  |
|------------|:----------------------------------------------------|
| 요청 URL     | https://service.linkprice.com/lppurchase_cpa_v4.php |
| 프로토콜       | https                                               |
| HTTP 메서드   | POST                                                |
| 요청 바디 타입   | RAW Data                                            |
| 요청 파라미터 형식 | JSON 문자열                                            |
| 응답 파라미터 형식 | JSON 문자열                                            |

**2-4-3-2. REQUEST 파라미터**

| KEY                     | 값                                                                                                                                                                                               | 타입            |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|
| action                  | 실적 데이터 정보                                                                                                                                                                                       | object        |
| action.unique_id        | 회원 고유 주문번호 <br><span style="font-size:75%">회원 ID가 아닌 회원 기준으로 고유하게 부여되는 번호</span>                                                                                                                | varchar(100)  |
| action.member_id        | 사용자 ID                                                                                                                                                                                          | varchar(100)  |
| action.final_paid_price | 구매자가 실결제한 전체 금액<br><span style="font-size:75%"> 무료 회원가입 및 무료 서비스일 경우 0으로 보냅니다. </span> <br><span style="font-size:75%"> 유료 회원가입 및 유료 서비스 결제시 결제 금액을 전달 합니다. </span>                             | float         |
| action.category_code    | 액션에 해당하는 카테고리 코드 <br><span style="font-size:75%">예) "register", "apply"</span>                                                                                                                  | varchar(100)  |
| action.action_code      | 위의 category_code 값과 똑같이 전송                                                                                                                                                                      | varchar(100)  |
| action.currency         | 상품 결제시 사용된 통화<br><span style="font-size:75%">ISO 4217 사용<br>예) 미국 : USD, 원화 : KRW, 위안화 : CNY, 유로화 : EUR</span>                                                                                  | varchar(3)    |
| action.action_name      | 서비스 이름<br><span style="font-size:75%">예) "무료 회원가입", "신청서 작성"</span>                                                                                                                             | varchar(100)  |
| linkprice               | 링크프라이스에서 필요한 데이터                                                                                                                                                                                | object        |
| linkprice.merchant_id   | 링크프라이스로부터 발급받은 광고주 ID                                                                                                                                                                           | varchar(10)   |
| linkprice.lpinfo        | 링크프라이스에서 유입된 트래킹 코드(=LPINFO 쿠키)                                                                                                                                                                 | varchar(500)  |
| linkprice.user_agent    | USER AGENT 정보                                                                                                                                                                                   | varchar(1000) |
| linkprice.remote_addr   | 구매자 IP주소<br><span style="font-size:75%">개인정보 이슈로 가급적 마스킹 처리 혹은 공백("") 권장.<br>예시) 118.221.\*.\* , ""</span>                                                                                      | varchar(100)  |
| linkprice.device_type   | 사용자 장치 타입<br><span style="font-size:75%">- web-pc: PC 웹브라우저에서 발생한 실적<br>- web-mobile: 모바일웹 브라우저에서 발생한 실적<br>- app-ios: iOS 앱(혹은 웹뷰)에서 발생한 실적<br>- app-android: Android 앱(혹은 웹뷰)에서 발생한 실적</span> | varchar(10)   |

**REQUEST 파라미터 예제**

```json
{
    "action": {
        "unique_id": "10002356",
        "final_paid_price": 0,
        "currency": "KRW",
        "member_id": "exampleId",
        "action_name": "무료 회원 가입",
        "category_code": "register",
        "action_code": "register"
    },
    "linkprice": {
        "merchant_id": "sample",
        "lpinfo": "A123456789|9832|A|m|a8uakljfa",
        "user_agent": "Mozilla/5.0...",
        "remote_addr": "127.0.0.1",
        "device_type": "web-pc"
    }
}
```

**2-4-3-4. Response 개요**

| 키 이름          | 값           | 타입      |
|---------------|-------------|---------|
| is_success    | 실적 전송 성공 여부 | boolean |
| error_message | 에러 상세 메세지   | string  |
| order_code    | 주문번호        | string  |
| product_code  | 상품번호        | string  |

>응답값은 JSON 문자열 형식으로 전송됩니다.
>
>응답은 2차원 배열로 구매한 상품 숫자만큼 응답이 전송됩니다.



**2-4-3-5. Response 샘플**

* 2개 상품 구매 후, 전송 성공 시

```json
[
    {
        "is_success": true,
        "error_message": "",
        "order_code": "order_115",
        "product_code": "product1"
    }
]
```

* 2개 상품 구매 후, 전송 실패 시

```json
[
    {
        "is_success": false,
        "error_message": "lpinfo parameter is empty.",
        "order_code": "order_115",
        "product_code": "product1"
    }
]

```

**2-4-3-6. Response 상세 사유**

* 아래 목록에 존재하지 않는 응답일 경우, 링크프라이스 담당자에게 호출했던 요청값과 응답값을 전달주시면 확인 가능합니다.

| 에러 메세지                                                                                                | 에러 상세 내용                                             |
|-------------------------------------------------------------------------------------------------------|------------------------------------------------------|
| This is not a valid JSON string.                                                                      | REQUEST 가 JSON 형식이 아님                                |
| action.unique_id parameter is empty.                                                                  | action.unique_id 미입력                                 |
| action.final_paid_price parameter is empty.                                                           | action.final_paid_price 미입력                          |
| action.final_paid_price is not integer.                                                               | action.final_paid_price integer형이 아님                 |
| action.currency parameter is empty.                                                                   | action.currency 미입력                                  |
| action.member_id parameter is empty.                                                                  | action.member_id 미입력                                 | 
| action.action_name parameter is empty.                                                                | action.action_name 미입력                               |
| action.category_code parameter is empty.                                                              | action.category_code 미입력                             |
| action.user_name parameter is empty.                                                                  | action.user_name 미입력                                 |
| products parameter is empty.                                                                          | action.action_name 미입력                               |
| linkprice.merchant_id parameter is empty.                                                             | linkprice.merchant_id 미입력                             |
| linkprice.lpinfo parameter does not conform to the format.                                            | linkprice.lpinfo 미입력                                 |
| linkprice.user_agent parameter is empty.                                                              | linkprice.user_agent 미입력                             |
| linkprice.remote_addr parameter is empty.                                                             | linkprice.remote_addr 미입력                            |
| linkprice.device_type parameter is empty.                                                             | linkprice.device_type 미입력                            |
| There was a problem sending your performance.                                                         | 실적 전송 오류                                             |

**Step2**. 서버 환경에 맞춰 링크프라이스 실적 수집 프로그램에 실적을 전송하는 프로그램을 작성 합니다.

**Step3**. 링크프라이스의 실적 전송 URL 호출 후 응답값이 정상적으로 출력되는지 확인합니다.

### 2-4-4. 샘플 코드

**※ 주의**

샘플 코드는 PHP 코드를 기준으로 작성하여 Chat GPT를 통해 JSP, ASP 코드를 생성한 예제입니다.

반드시 예제 코드로 구현을 해야 할 필요는 없으며 예제로만 참고 부탁드립니다.

광고주 서버 환경에 맞춰 구현 바랍니다.



**JSP 예제**

```jsp
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.json.*" %>

<%
// 주문 정보
JSONObject action = new JSONObject();
action.put("unique_id", "ORDER1234");
action.put("final_paid_price", 60000);
action.put("currency", "KRW");

action.put("member_id", "김**");
action.put("action_name", "유료 상담 신청");
action.put("category_code", "paid_register");
action.put("action_code", "paid_register");

// 링크프라이스에서 필요한 데이터
JSONObject linkprice = new JSONObject();
linkprice.put("merchant_id", "clickbuy");
linkprice.put("lpinfo", ""); // lpinfo 값을 설정해야 합니다.
linkprice.put("user_agent", request.getHeader("User-Agent"));
linkprice.put("remote_addr", request.getRemoteAddr()); // "" 공백 혹은 마스킹 처리를 권장합니다. 
linkprice.put("device_type", "web-pc"); // user-Agent에 맞게 처리

// 전체 데이터
JSONObject purchases = new JSONObject();
purchases.put("action", action);
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
Dim action
Set action = Server.CreateObject("Scripting.Dictionary")
action("unique_id") = "ORDER1234"
action("final_paid_price") = 60000
action("currency") = "KRW"

action("member_id") = "김링크"
action("action_name") = "유료 상담 신청"
action("category_code") = "paid_register"
action("action_code") = "paid_register"


' 링크프라이스에서 필요한 데이터
Dim linkprice
Set linkprice = Server.CreateObject("Scripting.Dictionary")
linkprice("merchant_id") = "clickbuy"
linkprice("lpinfo") = ""
linkprice("user_agent") = Request.ServerVariables("HTTP_USER_AGENT")
linkprice("remote_addr") = Request.ServerVariables("REMOTE_ADDR") // "" 공백 혹은 마스킹 처리를 권장합니다. 
linkprice("device_type") = "web-pc" // user-Agent에 맞게 처리

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
    'unique_id'         => 'ORDER1234',
    'final_paid_price'  => 60000,
    'currency'          => 'KRW',
    'member_id'         => '김링크',
    'action_name'       => '상담 신청',
    'category_code'     => 'paid_register',
    'action_code'       => 'paid_register',

];

// 링크프라이스에서 필요한 데이터
$purchases['linkprice'] = [
    'merchant_id'   => 'clickbuy',
    'lpinfo'        => $lpinfo,
    'user_agent'    => $_SERVER['HTTP_USER_AGENT'] ?? '',
    'remote_addr'   => $_SERVER['REMOTE_ADDR'] ?? '', // "" 공백 혹은 마스킹 처리를 권장합니다. 
    'device_type'   => 'web-pc' // user-Agent에 맞게 처리
];

$postData = json_encode($purchases);

$curl = curl_init();

curl_setopt_array($curl, [
  CURLOPT_URL               => 'https://service.linkprice.com/lppurchase_cps_v4.php',
  CURLOPT_RETURNTRANSFER    => true,
  CURLOPT_HTTP_VERSION      => CURL_HTTP_VERSION_1_1,
  CURLOPT_CUSTOMREQUEST     => 'POST',
  CURLOPT_POSTFIELDS        => $postData
]);

$response = curl_exec($curl);
curl_close($curl);

//링크프라이스 실적 수집 프로그램으로부터 전달받은 응답 데이터
echo $response;
```



## 2-5. 링크프라이스의 실적으로 실적 리스트 API 작업하기

### 2-5-1. 작업이 필요한 이유

광고주가 실적 수집 프로그램을 통해 전송한 실적 데이터는 링크프라이스 데이터베이스에 적재합니다.

기본적으로 링크프라이스의 실적 데이터와 광고주에서 가지고 있는 실적 데이터가 동일해야 합니다.

하지만 전송하였음에도 불구하고 여러 장애로 인하여 실적은 발생되었지만 링크프라이스에게 전송하지 못하고 누락되는 경우가 종종 발생합니다.

그래서 링크프라이스에서는 매일 광고주의 API를 호출하여 전일 실적 데이터를 가져와 링크프라이스의 실적과 대조하여 없는 경우 실적을 복구처리를 진행하고 있습니다.

아울러 이 API를 통해 매월 20일마다 주문 최소되거나 환불된 실적에 대해 자동으로 취소처리를 진행하고 있습니다.

링크프라이스에서 실적을 확인할 수 있도록 링크프라이스가 정해드린 스펙에 맞춰 링크프라이스 서버에서 접근 가능한 실적 조회 API를 제작해주셔야 합니다.
### 2-5-2. 개요

이 API의 명칭은 실적목록 API 입니다.

링크프라이스는 해당 API 활용해 아래와 같이 처리를 진행하고 있습니다.

```
1. 매일 새벽에 광고주 실적조회API를 호출하여 전일 실적에 대해 수집하여 실적 복구 처리 진행
2. 매월 20일마다 광고주로부터 전월 취소 실적들을 수집해 자동 취소 처리 진행
```

> 전월 확정 및 취소 실적 수집은 광고주 측에서 확정 및 취소 실적을 재전송해 주시는 것이 아닙니다.
>
> 실적 목록 API에서 보이는 실적(products[])의 confirmed_at과 canceled_at에 각각 확정과 취소 일자를 적용하여 API에 나타내주시면 됩니다.
>
> 링크프라이스에서 상태 여부만 확인하기 때문에 해당 confirmed_at과 canceled_at 값만 업데이트해 주시면 됩니다.




링크프라이스에서는 광고주 API를 호출 할 시, 아래와 같이 하루에 3번 호출합니다.



1. 실적 복구하기 위해 주문 완료일을 기준으로 모든 데이터 호출

```
# 쿼리 스트링 paid_ymd 파라미터로 조회할 날짜를 호출
https://api.yourdomain.com/linkprice/order_list_v1?paid_ymd=yyyymmdd
```

2. 실적 확정하기 위해 구매 확정일을 기준으로 호출

```
# 쿼리 스트링 confirmed_ymd 파라미터로 조회할 날짜를 호출
https://api.yourdomain.com/linkprice/order_list_v1?confirmed_ymd=yyyymmdd
```

3. 실적 취소하기 위해 구매 취소일을 기준으로 호출

```
# 쿼리 스트링 canceled_ymd 파라미터로 조회할 날짜를 호출
https://api.yourdomain.com/linkprice/order_list_v1?canceled_ymd=yyyymmdd
```



반드시 링크프라이스에게 전송해주셨던 데이터와 실적목록으로 표현되는 데이터는 동일해야 합니다.

> 실적 전송으로 상품명을 "상품A" 라는 이름으로 보내줬는데 실적목록API에서는 "상품B"라고 전송하는 경우 (x)



### 2-5-3. 작업 방법

**Step1**. 실적목록 API를 작성하기 위해 아래 요구 출력 스펙을 참고합니다.

2-3-3 Step1 참조



**Step2**. 실적 목록 페이지를 생성하고 주문 완료일(paid_ymd), 구매 확정일(comfirmed_ymd), 구매 취소일(canceled_ymd)를 기준으로 아래 예시대로 링크프라이스가 JSON 문자열을 받아 갈 수 있도록 작업합니다.



실적목록 API 출력 예시

```json
[
    {
        "action": {
            "unique_id": "o190203-h78X3",
            "final_paid_price": 29000,
            "currency": "KRW",
            "member_id": "ID",
            "action_name": "상담 신청",
            "category_code": "paid_register",
            "action_code": "paid_register",
        }
        "linkprice": {
            "merchant_id": "sample",
            "lpinfo": "A123456789|9832|A|m|a8uakljfa",
            "user_agent": "Mozilla/5.0...",
            "remote_addr": "13.156.*.*",
            "device_type": "web-pc"
        }
    },
    {"action":{"unique_id":"ord-123-01",...},"linkprice":{...}},
    {"action":{"unique_id":"ord-123-03",...},"linkprice":{...}},
    {"action":{"unique_id":"ord-123-04",...},"linkprice":{...}}
]
```

**Step3**. 운영 중이신 서버의 방화벽 정책이 인바운드가 차단되어 있는 경우, 링크프라이스 크롤러가 접근 가능하도록 아래 IP를 허용해주셔야 합니다.

```
# 링크프라이스 서버 IP
13.125.179.218/32
13.124.188.166/32
```

**Step4**. 완성된 API URL을 링크프라이스 담당자에게 전달합니다.



### 2-5-4. 샘플 코드

**※ 주의**

샘플 코드는 PHP 코드를 기준으로 작성하여 Chat GPT를 통해 JSP, ASP 코드를 생성한 예제입니다.

반드시 예제 코드로 구현을 해야 할 필요는 없으며 예제로만 참고 부탁드립니다.

광고주님의 환경에 맞춰 구현 바랍니다.



* lpinfo 테이블은 연동 가이드 2-3-2. Step1 예제에서 생성하는 테이블 구조를 기준으로 작성되었습니다.

* purchase 테이블은 구매한 상품 리스트 데이터를 의미합니다.



**JSP 예제**

```jsp
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
// 링크프라이스 실적 목록 API
String paidYmd = request.getParameter("paid_ymd");
String confirmYmd = request.getParameter("confirmed_ymd");
String cancelYmd = request.getParameter("canceled_ymd");

String query = null;

if (paidYmd != null && !paidYmd.isEmpty()) {
    // 구매일자 기준으로 데이터 조회
    query = "SELECT a.unique_id, a.member_id, a.final_paid_price, "
            + "a.action_name, a.category_code, a.action_code, a.category_name, "
            + "l.lpinfo, l.device_type, l.user_agent, l.ip "
            + "FROM action a "
            + "JOIN lpinfo l "
            + "ON a.unique_id = l.unique_id "
            + "AND a.member_id = l.member_id "
            + "WHERE DATE_FORMAT(a.paided_at, '%Y%m%d') = ?";
} else if (confirmYmd != null && !confirmYmd.isEmpty()) {
    // 확정일자 기준으로 데이터 조회
    query = "SELECT a.unique_id, a.member_id, a.final_paid_price, "
            + "a.action_name, a.category_code, a.action_code, a.category_name, "
            + "l.lpinfo, l.device_type, l.user_agent, l.ip "
            + "FROM action a "
            + "JOIN lpinfo l "
            + "ON a.unique_id = l.unique_id "
            + "AND a.member_id = l.member_id "
            + "WHERE a.confirmed_ymd = ?";
} else if (cancelYmd != null && !cancelYmd.isEmpty()) {
    // 취소일자 기준으로 데이터 조회
    query = "SELECT a.unique_id, a.member_id, a.final_paid_price, "
            + "a.action_name, a.category_code, a.action_code, a.category_name, "
            + "l.lpinfo, l.device_type, l.user_agent, l.ip "
            + "FROM action a "
            + "JOIN lpinfo l "
            + "ON a.unique_id = l.unique_id "
            + "AND a.member_id = l.member_id "
            + "WHERE a.canceled_ymd = ?";
}

// 데이터베이스 연결 설정
String jdbcUrl = "jdbc:mysql://localhost/DATABASE_NAME";
String dbUser = "ID";
String dbPassword = "PASSWORD";

List<Map<String, Object>> products = new ArrayList<>();

try {
    Class.forName("com.mysql.jdbc.Driver");
    Connection dbConnection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
    PreparedStatement statement = dbConnection.prepareStatement(query);

    if (paidYmd != null && !paidYmd.isEmpty()) {
        statement.setString(1, paidYmd);
    } else if (confirmYmd != null && !confirmYmd.isEmpty()) {
        statement.setString(1, confirmYmd);
    } else if (cancelYmd != null && !cancelYmd.isEmpty()) {
        statement.setString(1, cancelYmd);
    }

    ResultSet result = statement.executeQuery();

    while (result.next()) {
        // 주문번호 별로 상품을 묶는다.
        Map<String, Object> row = new HashMap<>();
        row.put("unique_id", result.getString("unique_id"));
        row.put("final_paid_price", result.getString("final_paid_price"));
        row.put("currency", result.getString("currency"));
        row.put("member_id", result.getString("member_id"));
        row.put("action_name", result.getString("action_name"));
        row.put("category_name", result.getString("category_name"));
        row.put("category_code", result.getInt("category_code"));
        row.put("action_code", result.getDouble("action_code"));
        row.put("lpinfo", result.getString("lpinfo"));
        row.put("device_type", result.getString("device_type"));
        row.put("user_agent", result.getString("user_agent"));
        row.put("remote_addr", result.getString("remote_addr"));
        products.add(row);
    }

    result.close();
    statement.close();
    dbConnection.close();
} catch (Exception e) {
    e.printStackTrace();
}

List<Map<String, Object>> data = new ArrayList<>();
for (Map<String, Object> product : products) {
    // 주문 정보
    Map<String, Object> purchase = new HashMap<>();
    String uniqueId = (String) product.get("unique_id");
    purchase.put("order", Map.of(
            "unique_id", uniqueId,
            "final_paid_price", finalPaudPrice,
            "currency", "KRW",
            "member_id", product.get("member_id"),
            "action_name", product.get("action_name"),
            "category_name", product.get("category_name"),
            "category_code", product.get("category_code"),
    ));

    // 링크프라이스 데이터
    purchase.put("linkprice", Map.of(
            "merchant_id", "clickbuy",
            "lpinfo", product.get("lpinfo"),
            "user_agent", product.get("user_agent"),
            "remote_addr", product.get("ip"),
            "device_type", product.get("device_type")
    ));

    data.add(purchase);
}

// 실적 데이터 출력
String jsonData = new Gson().toJson(data);
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
response.getWriter().write(jsonData);
```



**ASP 예제**

```asp
<%
' 링크프라이스 실적 목록 API

Dim paidYmd, confirmYmd, cancelYmd
paidYmd = Request.QueryString("paid_ymd")
confirmYmd = Request.QueryString("comfirmed_ymd")
cancelYmd = Request.QueryString("canceled_ymd")

Dim query
query = ""

If Not IsEmpty(paidYmd) Then
    ' 구매일자 기준으로 데이터 조회
    query = "
        SELECT a.unique_id, a.member_id, a.final_paid_price,
            a.action_name, a.category_code, a.action_code, a.category_name,
            l.lpinfo, l.device_type, l.user_agent, l.ip
            FROM action a
            JOIN lpinfo l
            ON a.unique_id = l.unique_id
            AND a.member_id = l.member_id
        WHERE Format(p.paided_at, 'yyyymmdd') = '" & paidYmd & "'"
ElseIf Not IsEmpty(confirmYmd) Then
    ' 확정일자 기준으로 데이터 조회
    query = "
        SELECT a.unique_id, a.member_id, a.final_paid_price,
            a.action_name, a.category_code, a.action_code, a.category_name,
            l.lpinfo, l.device_type, l.user_agent, l.ip
            FROM action a
            JOIN lpinfo l
            ON a.unique_id = l.unique_id
            AND a.member_id = l.member_id
        WHERE p.confirmed_ymd = '" & confirmYmd & "'"
ElseIf Not IsEmpty(cancelYmd) Then
    ' 취소일자 기준으로 데이터 조회
    query = "
        SELECT a.unique_id, a.member_id, a.final_paid_price,
            a.action_name, a.category_code, a.action_code, a.category_name,
            l.lpinfo, l.device_type, l.user_agent, l.ip
            FROM action a
            JOIN lpinfo l
            ON a.unique_id = l.unique_id
            AND a.member_id = l.member_id
        WHERE p.canceled_ymd = '" & cancelYmd & "'"
End If

' 데이터베이스 연결 설정
Dim dbConnection
Set dbConnection = Server.CreateObject("ADODB.Connection")
dbConnection.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\your\database\path\DATABASE_NAME.mdb;" ' Access Database

Dim products
Set products = Server.CreateObject("ADODB.Recordset")
products.Open query, dbConnection

Dim data
Set data = Server.CreateObject("Scripting.Dictionary")

Do Until products.EOF
    ' 주문번호 별로 묶음
    Dim uniqueId
    uniqueId = products("unique_id")

    If Not data.Exists(uniqueId) Then
        Set data(uniqueId) = Server.CreateObject("Scripting.Dictionary")
        data(uniqueId)("unique_id") = uniqueId
        data(uniqueId)("final_paid_price") = 0
        data(uniqueId)("currency") = "KRW"
        data(uniqueId)("member_id") = products("member_id")
        data(uniqueId)("action_name") = products("action_name")
        data(uniqueId)("category_code") = products("category_code")
        data(uniqueId)("action_code") = products("action_code")

    End If

    products.MoveNext
Loop

products.Close
Set products = Nothing

dbConnection.Close
Set dbConnection = Nothing

' 실적 데이터 출력
Response.ContentType = "application/json"
Dim jsonData
jsonData = JSONStringify(data.Items)
Response.Write(jsonData)

Function JSONStringify(obj)
    Dim objString
    Set objString = Server.CreateObject("Scripting.Dictionary")
    For Each key In obj.Keys
        If IsObject(obj(key)) Then
            objString.Add key, JSONStringify(obj(key))
        Else
            objString.Add key, obj(key)
        End If
    Next
    JSONStringify = Join(objString.Items, ",")
    JSONStringify = "{" & JSONStringify & "}"
    Set objString = Nothing
End Function
%>
```



**PHP 예제**

```php
<?php
/*
 * 링크프라이스 실적 목록 API
 */

$paidYmd      = $_GET['paid_ymd'] ?? '';
$comfirmYmd   = $_GET['comfirmed_ymd'] ?? '';
$cancelYmd    = $_GET['canceled_ymd'] ?? '';

if(!empty($paidYmd)) {
  // 구매일자 기준으로 데이터 조회
 	$query        = "
        SELECT a.unique_id, a.member_id, a.final_paid_price,
            a.action_name, a.category_code, a.action_code, a.category_name,
            l.lpinfo, l.device_type, l.user_agent, l.ip
            FROM action a
            JOIN lpinfo l
            ON a.unique_id = l.unique_id
            AND a.member_id = l.member_id
            WHERE		date_format(p.paided_at, '%Y%m%d') = $paidYmd"; 
} else if(!empty($confirmYmd)) {
  // 확정일자 기준으로 데이터 조회
 	$query        = "
        SELECT a.unique_id, a.member_id, a.final_paid_price,
            a.action_name, a.category_code, a.action_code, a.category_name,
            l.lpinfo, l.device_type, l.user_agent, l.ip
            FROM action a
            JOIN lpinfo l
            ON a.unique_id = l.unique_id
            AND a.member_id = l.member_id
            WHERE		date_format(p.paided_at, '%Y%m%d') = $confrimedYmd"; 
} else if(!empty($cancelYmd)) {
  // 취소일자 기준으로 데이터 조회
  $query        = "
        SELECT a.unique_id, a.member_id, a.final_paid_price,
        a.action_name, a.category_code, a.action_code, a.category_name,
        l.lpinfo, l.device_type, l.user_agent, l.ip
        FROM action a
        JOIN lpinfo l
        ON a.unique_id = l.unique_id
        AND a.member_id = l.member_id
        WHERE		date_format(p.paided_at, '%Y%m%d') = $canceledYmd"; 
}

$dbConnection = mysqli_connect("localhost", "ID", "PASSWORD", "DATABASE_NAME");

$products	= [];

$result	= mysqli_query($dbConnection, $query);

while($row = mysqli_fetch_Array($result)) {
 		//주문번호 별로 상품을 묶는다.
    $products[$row['unique_id']][] = $row;
}

$data = [];
foreach($products as $uniqueId => $product) {
  // 주문 정보
  $purchase = [];
	$purchase['order'] = [
  	'unique_id'					=> $uniqueId,
  	'final_paid_price'	        => $product_final_price,
    'currency'					=> 'KRW',
    'member_id'					=> $product['member_id'],
    'action_name'				=> $product['action_name'],
    'category_code'				=> $product['category_code'],
    'action_code'				=> $product['action_code']
  ];

  
  //링크프라이스 데이터
  $purchase['linkprice']	= [
    'merchant_id'		=> 'clickbuy',
    'lpinfo'			=> $product['lpinfo'],
    'user_agent'		=> $product['user_agent'],
    'remote_addr'		=> $product['ip'],
    'device_type'		=> $product['device_type']
  ];
    
  $data[] = $purchase;
}

//실적 데이터 출력
echo json_encode($data);
```

---
[^1]: 홍보가 필요한 기업의 제품 또는 서비스를 보유한 주체
[^2]: 블로그, 카페, 각종 SNS을 운영하며 머천트의 광고를 유치
[^3]: 링크프라이스에 매체에게 제공하는 홍보 URL. 주로 AC센터에 홍보 URL을 가져다가 블로그, 카페, 각종 SNS에서 홍보 활동을 진행
[^4]: 트래킹 코드를 심고 광고주 사이트로 리다이렉션하는 페이지
[^5]: 발생되는 실적이 링크프라이스의 실적인지를 판단할 수 있는 트래킹 코드
