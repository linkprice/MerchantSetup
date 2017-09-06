## 셋업 요약

### [1. 랜딩 페이지 작성 (LPINFO 쿠키생성)](https://github.com/linkprice/MerchantSetup/tree/master/CPA#랜딩-페이지-작성)

### [2. 실적 전송](https://github.com/linkprice/MerchantSetup/tree/master/CPA#실시간-실적-전송)

* 회원 가입 완료시 링크프라이스로 실적 전송 (**Server to Server 방식**)

### [3. 실적 정보 출력](https://github.com/linkprice/MerchantSetup/tree/master/CPA#실적-정보-출력-daily_fix)

* 머천트 회원가입 정보와 링크프라이스 실적을 대조하여 누락된 실적을 복구하기 위한 작업


<br />
<br />
<br />

## 랜딩 페이지 작성

1. 랜딩 페이지 작성
    * 랜딩 페이지는 쿠키 생성 후 머천트 웹사이트로 리다이렉트하는 역할을 합니다. (샘플코드 참조) 
   
    * RETURN_DAYS(광고 효과 인정 기간) 는 **계약서에 명시되어 있는 광고 효과 인정 기간**(일단위)으로 변경하시기 바랍니다. 
   
    * 광고 인정 기간을 계약서와 다르게 변경 시 계약위반으로 불이익을 받을 수 있습니다.
   
2. 샘플 코드
   - [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/PHP/lpfront.php)
   - [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/JSP/lpfront.jsp)
   - [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/ASP/lpfront.asp)

## 실시간 실적 전송

1. 실시간 회원 정보 저장

    * 회원 정보 저장시 Cookie(**LPINFO**)가 존재하면 회원정보를 저장합니다.
   
    * 머천트 회원가입 테이블에 아래 필드를 추가합니다.

   |     FIELD      |                VALUE                |
   | :------------: | :---------------------------------: |
   | network_value  |           LPINFO(cookie)            |
   |  network_name  | 링크프라이스를 구분할 수 있는 값(예-linkprice, lp) |
   | remote_address |         사용자 IP(REMOTE_ADDR)         |
   |   user_agent   |   사용자 user_agent(HTTP_USER_AGENT)   |

    * **회원 정보 저장시** network_value, network_name, remote_address, user_agent 값을 회원가입 테이블에 저장하여 주십시요.

2. 실시간 실적 전송 시점

    * **회원 가입 완료**시 실적을 전송하기 위해 실적전송 코드(샘플 참조)를 삽입해야 합니다.
    * 모든 실적은 Server to Server 방식으로 전송됩니다. (단, *스크립트(script) 및 이미지(image) 방식으로 전달 시 링크프라이스로 별도 문의 주셔야 합니다*)

3. 실시간 실적 전송 셋업

    * 샘플코드는 귀사의 개발 환경에 맞게 수정하시기 바랍니다.
   
    * JSON 형식으로 전송해 주시기 바랍니다.
   
    * KEY 이름은 **수정 할 수 없으며**, VALUE 값은 아래와 같이 입력해 주시기 바랍니다.

  ```javascript
   [{
      lpinfo : network_value,				//LPINFO cookie 값
      merchant_id : "Your merchant ID",			//계약시 제공 받은 머천트 아이디
      member_id : "User ID of who phurchase products",	// 회원가입 ID
      unique_id : "number of member",		        // 회원번호(Unique 값)
      action : "Registration",			        // 액션 종류(예 - "Registration", "Poll")
      category_code : "FREE",		                // 회원가입 종류(예-"FREE","PAID")
      action_name : "무료 회원 가입",                      // 회원가입 종류명
      user_agent : HTTP_USER_AGENT,			// $_SERVER["HTTP_USER_AGENT"]
      remote_addr  REMOTE_ADDR				// $_SERVER["REMOTE_ADDR"]
   }]
   ```

4. 샘플 코드

   - [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/PHP/index.php)
   - [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/JSP/index.jsp)
   - [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/ASP/index.asp)

## 실적 정보 출력 (daily_fix)

1. 실적 정보 출력

    * 머천트의 회원가입 정보와 링크프라이스의 실적을 대조하여 누락된 실적을 복구하기 위한 작업입니다.
    
    * 머천트의 실적 정보 출력 URL를 링크프라이스에서 일별 호출하여 자동으로 복구합니다.
    
    * 주문번호(order_code)와 상품코드(product_code)로 실적을 대조합니다.

2. 실적 정보 출력 셋업

    * 머천트에 저장된 회원가입 정보 중 링크프라이스를 통해서 발생한 회원가입 정보를 출력합니다.
   
    * 샘플코드는 머천트 개발 환경에 맞게 수정하시기 바랍니다.
   
    * 실직 전송된 데이터와 실적 정보 출력에서 확인되는 데이터 모두 동일해야 합니다.
   
    * 아래 예시와 같이 호출하면 해당 날짜의 실적이 출력될 수 있도록 합니다.(yyyymmdd 파라미터로 호출)
      - 예 - www.example.com/linkprice/daily_fix.php?yyyymmdd=20170701
    
    * 실적 정보는 json 형식으로 출력하시기 바랍니다.

```javascript
[{
   lpinfo : network_value,				//LPINFO cookie 값
   order_time : "132543",				// 가입시간(hhmmss)
   member_id : "User ID of who phurchase products",	// 회원가입 ID
   unique_id : "number of member",			// 회원번호(Unique 값)
   action : "Registration",				// 액션 종류(예 - "Registration", "Poll")
   category_code : "FREE",				// 회원가입 종류(예-"FREE","PAID")
   action_name : "무료 회원 가입",			// 회원가입 종류명
   user_agent : HTTP_USER_AGENT,			// $_SERVER["HTTP_USER_AGENT"]
   remote_addr  REMOTE_ADDR				// $_SERVER["REMOTE_ADDR"]
}]
```

3. 샘플 코드

   - [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/PHP/daily_fix.php)
   - [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/JSP/daily_fix.jsp)
   - [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/ASP/daily_fix.asp)
