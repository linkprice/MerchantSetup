## 셋업 요약

1. 랜딩 페이지 셋업 (LPINFO 쿠키생성)
2. 실적 전송
   * 회원가입 테이블에 network_name, network_value, user_agent, remote_address 필드 추가
   * 실적이 발생하여 완료되는 페이지에 실적전송 코드(샘플제공) 삽입(Server to Server 방식으로 전송)
3. 실적 정보 출력 셋업 (daily_fix)
   * 머천트 DB에 저장되어진 링크프라이스 데이터 출력 테스트



## 랜딩 페이지 셋업

1. 랜딩 페이지 셋업

   - 해당 파일의 기능은 쿠키 생성 후 귀사의 웹사이트로 리다이렉트하는 역할을 합니다. (샘플코드 참조) 

   - RETURN_DAYS(광고 인정 기간) 값은 **계약서에 명시되어 있는 광고 인정 기간**(일단위)으로 변경바랍니다.

     광고 인정 기간을 계약서와 다르게 변경 시 계약위반으로 불이익을 받으실 수 있습니다.

     ​

2. 샘플 코드

   - [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/PHP/lpfront.php)
   - [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/JSP/lpfront.jsp)
   - [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/ASP/lpfront.asp)

   ​

## CPA - 실시간 실적전송

1. 실시간 실적 정보 저장

   - Cookie(**LPINFO**)가 존재하고 실적이 발생하면 실적을 전송합니다.

   - 귀사 데이터베이스의 회원 테이블에 network_name, network_value, remote_address, user_agent 필드를 추가합니다.

   - **회원 정보 저장시**  아래의 값을 같이 저장하여 주십시요. 

     |     FIELD      |                VALUE                |
     | :------------: | :---------------------------------: |
     | network_value  |           LPINFO(cookie)            |
     |  network_name  | 링크프라이스를 구분할 수 있는 값(예-linkprice, lp) |
     | remote_address |         사용자 IP(REMOTE_ADDR)         |
     |   user_agent   |   사용자 user_agent(HTTP_USER_AGENT)   |

2. 실시간 실적 전송 시점

   - **회원 가입 완료** 시 실적을 전송하기 위해 실적전송 코드(샘플 참조)를 삽입해야 합니다.

   - 모든 실적은 Server to Server 방식으로 전송됩니다.

     (**스크립트(script) 및 이미지(image) 방식으로 전달 시 링크프라이스로 별도 문의 주셔야 합니다**)

3. 실시간 실적 전송 셋업

   - 샘플코드는 각 머천트 개발 환경에 맞게 수정합니다.
   - JSON 형식으로 링크프라이스에 실적 전송해주시면 됩니다.
   - KEY 이름은 **임의로 수정 불가 이며** VALUE 값은 아래와 같이 입력해주시면 됩니다.

```javascript
{
	affiliate_id : network_value,				//LPINFO cookie 값
	merchant_id : "Your merchant ID",			//링크프라이스 머천트 ID(링크프라이스에서 지정, 셋업시 전달 드림)
  	member_id : "User ID of who phurchase products",	// 실적 발생 사용자 ID
  	unique_id : "number of member",			// 회원번호(Unique 값)
  	action : "Registration",				// 
  	category_code : "FREE",		// 회원가입 종류
  	action_name : "무료 회원 가입",				// 회원가입 종류명
  	user_agent : HTTP_USER_AGENT,				// 사용자 IP
  	remote_addr  REMOTE_ADDR				// 사용자 user_agent
}
```



4. 샘플 코드
   * [PHP](https://github.com/linkprice/MerchantSetup/blob/master/sample/CPA/PHP/index.php)
   * [JSP](https://github.com/linkprice/MerchantSetup/blob/master/sample/CPA/JSP/index.jsp)
   * [ASP](https://github.com/linkprice/MerchantSetup/blob/master/sample/CPA/ASP/index.asp)



## CPA - 실적 정보 출력 (daily_fix)

1. 실적 정보 출력(daily_fix)

   - 링크프라이스와 귀사의 실적을 대조하여 누락된 실적을 복구하기 위한 작업입니다.
   - 특정 시점마다 귀사의 실적 정보 출력 URL를 링크프라이스에서 호출하여 자동으로 복구합니다.

2. 실적출력 셋업

   - 귀사의 데이터베이스에 링크프라이스를 통해 발생한 실적을 출력합니다.

   - 샘플코드는 귀사의 개발 환경에 맞게 수정하여 사용바랍니다.

   - 링크프라이스에서는 귀사의 실적 정보를 "yyyymmdd"로 일별 실적을 호출합니다.

     아래 예시와 같이 해당 날짜가 입력되면 해당 날짜의 실적들이 출력될 수 있도록 합니다.

     - 예 - www.example.com/linkprice/daily_fix.php?yyyymmdd=20170701

   - 실적은 json 형식으로 출력하여 주십시요.

   ```javascript
   {
       affiliate_id : network_value,			//LPINFO cookie 값
      order_time : "132543",				// 주문시간(hhmmss)
      member_id : "User ID of who phurchase products",	// 실적 발생 사용자 ID
      unique_id : "number of member",		// 주문번호(Unique 값)
      action : "Registration",			// 
      category_code : "FREE",		// 회원가입 종류
      action_name : "무료 회원 가입",			// 회원가입 종류명
      user_agent : HTTP_USER_AGENT,			// 유저 IP
      remote_addr  REMOTE_ADDR				// 유저 user_agent
   }
   ```

   ​

3. 샘플 코드

   - [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/PHP/daily_fix.php)
   - [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/JSP/daily_fix.jsp)
   - [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/ASP/daily_fix.asp)

   ​

