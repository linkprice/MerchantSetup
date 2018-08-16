## 셋업 요약

### [1. Gateway 페이지 작성 (LPINFO 쿠키생성)](https://github.com/linkprice/MerchantSetup/tree/master/CPS#랜딩-페이지-작성)

### [2. 실적 전송](https://github.com/linkprice/MerchantSetup/tree/master/CPS#실시간-실적-전송)
* 구매 완료시 링크프라이스로 실적 전송 (**Server to Server 방식**)

### [3. 실적 정보 출력](https://github.com/linkprice/MerchantSetup/tree/master/CPS#실적-정보-출력-daily_fix)
 * 머천트 주문 정보와 링크프라이스 실적을 대조하여 누락된 실적을 복구하기 위한 작업

### [4. 자동 실적 취소](https://github.com/linkprice/MerchantSetup/blob/master/CPS/README-Auto%20Cancel.md) / [월배치 정산](https://github.com/linkprice/MerchantSetup/blob/master/CPS/README-Monthly%20Merchant%20Calculate.md)
 * 머천트 주문 취소시 링크프라이스 실적 자동 취소

 * 월배치 정산

  <br />
  <br />
  <br />

## Gateway 페이지 작성

1. Gateway 페이지 작성

	* 랜딩 페이지는 쿠키 생성 후 머천트 웹사이트로 리다이렉트하는 역할을 합니다. (샘플코드 참조) 

	* RETURN_DAYS(광고 효과 인정 기간) 는 **계약서에 명시되어 있는 광고 효과 인정 기간**(일단위)으로 변경하시기 바랍니다. 
	
	* 광고 인정 기간을 계약서와 다르게 변경 시 계약위반으로 불이익을 받을 수 있습니다.

2. 샘플 코드

	* [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/lpfront.php)
	* [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/JSP/lpfront.jsp)
	* [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/ASP/lpfront.asp)


## 실시간 실적 전송

1. 실시간 주문 정보 저장

   * 구매 완료시 Cookie(**LPINFO**)가 존재하면 주문 정보를 저장합니다.

   * 머천트 주문 테이블에 아래 필드를 추가합니다.

   |     FIELD      |                VALUE                |
   | :------------: | :---------------------------------: |
   | network_value  |           LPINFO(cookie)            |
   | network_name  | 링크프라이스를 구분할 수 있는 값(예-linkprice, lp) |
   | remote_address |         사용자 IP(REMOTE_ADDR)         |
   | user_agent   |   사용자 user_agent(HTTP_USER_AGENT)   |

   * **구매 완료 시점**에 network_value, network_name, remote_address, user_agent 값을 주문 테이블에 저장하여 주십시오.

2. 실시간 실적 전송 시점

  * **구매 완료**시 실적을 전송하기 위해 실적전송 코드(샘플 참조)를 삽입해야 합니다.

  * 모든 실적은 Server to Server 방식으로 전송됩니다. (단, *스크립트(script) 및 이미지(image) 방식으로 전달 시 링크프라이스로 별도 문의 주셔야 합니다*)

3. 실시간 실적 전송 셋업

  * 샘플코드는 귀사의 개발 환경에 맞게 수정하시기 바랍니다.
  * JSON 형식으로 전송해 주시기 바랍니다.
  * 결제시 복수 상품 및 단일 상품 모두 **Array**로 보내 주시기 바랍니다.
  * KEY 이름은 **수정 할 수 없으며**, VALUE 값은 아래와 같이 입력해 주시기 바랍니다.
  * 실적 전송시 sales_type(PC, MOBILE, IOS, AND, APP) 을 구분하는 값이 주문테이블에 없을 시 저장 하시길 추천드립니다. (앱 실적시 IOS나 안드로이드 구분이 안될때에는 APP으로 설정하여주세요.)

  ```javascript
  [
      {
  	lpinfo : "network_value",				// LPINFO cookie 값
  	merchant_id : "Your merchant ID",			// 계약시 제공 받은 머천트 아이디
  	member_id : "User ID of who phurchase products",	// 회원 ID
  	order_code : "Order code of product",			// 주문번호
  	product_code : "Product code",				// 상품코드
  	product_name : "Product name",				// 상품명
  	item_count : "Item count",				// 개수
  	sales : "Total price",					// 총금액 (가격 * 개수)
  	category_code : "Category code of product",		// 카테고리 코드
  	user_agent : "User Agent",				// $_SERVER["HTTP_USER_AGENT"]
  	remote_addr:  "User IP"				        // $_SERVER["REMOTE_ADDR"]
          sales_type: "Sales type"				// PC, MOBILE, IOS, AND, APP(택1)    
      }
  ]
  ```

  * 예제(한번 결제에 복수 상품 결제시)
  ```javascript
  [
      {
  	lpinfo : "A100000131|24955642000000|0000|1|0",		// LPINFO cookie 값
  	merchant_id : "Merchant_id",				// 계약시 제공 받은 머천트 아이디
  	member_id : "member_id",				// 회원 ID
  	order_code : "1234567890",				// 주문번호
  	product_code : "example_1",				// 상품코드
  	product_name : "example",				// 상품명
  	item_count : "1",					// 개수
  	sales : "15000",					// 총금액 (가격 * 개수)
  	category_code : "example_category",			// 카테고리 코드
  	user_agent : "User Agent",				// $_SERVER["HTTP_USER_AGENT"]
  	remote_addr:  "User IP"				        // $_SERVER["REMOTE_ADDR"]
          sales_type: "MOBILE"					    
      },
      {
  	lpinfo : "A100000131|24955642000000|0000|1|0",		// LPINFO cookie 값
  	merchant_id : "Merchant_id",				// 계약시 제공 받은 머천트 아이디
  	member_id : "member_id",				// 회원 ID
  	order_code : "1234567890",				// 주문번호
  	product_code : "example_2",				// 상품코드
  	product_name : "example2",				// 상품명
  	item_count : "1",					// 개수
  	sales : "20000",					// 총금액 (가격 * 개수)
  	category_code : "example_category2",			// 카테고리 코드
  	user_agent : "User Agent",				// $_SERVER["HTTP_USER_AGENT"]
  	remote_addr:  "User IP"				        // $_SERVER["REMOTE_ADDR"]
          sales_type: "MOBILE"    
      }	    
  ]
  ```

  * 예제(한번 결제에 단일 상품 결제시)
  ```javascript
  [
      {
  	lpinfo : "A100000131|24955642000000|0000|1|0",		// LPINFO cookie 값
  	merchant_id : "Merchant_id",				// 계약시 제공 받은 머천트 아이디
  	member_id : "member_id",				// 회원 ID
  	order_code : "1234567890",				// 주문번호
  	product_code : "example_1",				// 상품코드
  	product_name : "example",				// 상품명
  	item_count : "1",					// 개수
  	sales : "15000",					// 총금액 (가격 * 개수)
  	category_code : "example_category",			// 카테고리 코드
  	user_agent : "User Agent",				// $_SERVER["HTTP_USER_AGENT"]
  	remote_addr:  "User IP"				        // $_SERVER["REMOTE_ADDR"]
          sales_type: "APP"    
      } 
  ]
  ```

  * 실적 중 위의 값으로 실적 구분이  경우 링크프라이스로 연락 주십시요.

4. 샘플 코드
  * [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/index.php)
  * [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/JSP/index.jsp)
  * [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/ASP/index.asp)


5. 에러 코드

| error_message                                    | 에러 상세 내용                                               |
| ------------------------------------------------ | ------------------------------------------------------------ |
| lpinfo parameter is empty                        | lpinfo 미입력                                                |
| merchant_id parameter is empty.                  | merchant_id 미입력                                           |
| order_code parameter is empty.                   | order_code(주문번호) 미입력                                  |
| product_code parameter is empty.                 | product_code(상품코드) 미입력                                |
| category_code parameter is empty.                | category_code 미입력                                         |
| user_agent parameter is empty.                   | user_agent 미입력                                            |
| remote_addr parameter is empty.                  | remote_addr (클라이언트 IP) 미입력                           |
| item_count parameter is empty.                   | item_count(상품수량) 미입력                                  |
| sales parameter is empty.                        | sales(상품금액) 미입력                                       |
| product_name parameter is empty.                 | product_name(상품명) 미입력                                  |
| lpinfo parameter does not conform to the format. | lpinfo 값이 형식에 맞지 않음                                 |
| sales_type and user_agent parameter is empty.    | sales_type (PC/MOBILE) 구분값 미입력<br />특정 머천트만 적용 대상 |
| The order_code of each array must be the same.   | 복수의 건일 경우 주문번호가 서로 일치하지 않음               |
| Order code is duplicated.                        | 예전에 링크프라이스로 인입된 주문번호가 재입력됨             |
| Required parameters are missing.                 | 필수파라미터가 누락되어 실적 인정이 안됨                     |
| Network error during performance transmission.   | 네트워크 장애로 실적 인정이 안됨                             |

## 실적 정보 출력 (daily_fix)

1. 실적 정보 출력

	* 머천트 주문 정보와 링크프라이스의 실적을 대조하여 누락된 실적을 복구하기 위한 작업입니다.

	* 머천트의 실적 정보 출력 URL를 링크프라이스에서 일별 호출하여 자동으로 복구합니다.
	
	* 주문번호(order_code)와 상품코드(product_code)로 실적을 대조합니다.

2. 실적 정보 출력 셋업

  * 머천트에 저장된 주문 정보 중 링크프라이스를 통해서 발생한 주문을 출력합니다.

  * 샘플코드는 머천트 개발 환경에 맞게 수정하시기 바랍니다.

  * 실적 전송된 데이터와 실적 정보 출력에서 확인되는 데이터 모두 동일해야 합니다.

  * 아래 예시와 같이 호출하면 해당 날짜의 실적 정보가 출력될 수 있도록 합니다. (yyyymmdd 파라미터로 호출)
  	* 예 - www.example.com/linkprice/daily_fix.php?yyyymmdd=20170701 실적 전송된 데이터와 실적 정보 출력에서 확인되는 데이터는 모두 동일해야 합니다.	

  * 실적 정보는 json 형식으로 출력하시기 바랍니다.

  ```javascript
  [
      {
  	lpinfo : "network_value",				// LPINFO cookie 값
  	order_time : "order time",				// 주문시간
  	member_id : "User ID of who phurchase products",	// 회원 ID
  	order_code : "Order code of product",			// 주문번호
  	product_code : "Product code",				// 상품코드
  	product_name : "Product name",				// 상품명
  	item_count : "Item count",				// 개수
  	sales : "Total price",					// 총금액 (가격 * 개수)
  	category_code : "Category code of product",		// 카테고리 코드
  	user_agent : "User Agent",				// $_SERVER["HTTP_USER_AGENT"]
  	remote_addr: "User IP"				        // $_SERVER["REMOTE_ADDR"]
  	sales_type: "Sales type"		       
      }
  ]
  ```

3. 샘플 코드

	* [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/daily_fix.php)
	* [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/JSP/daily_fix.jsp)
	* [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/ASP/daily_fix.asp)
