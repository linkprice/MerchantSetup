## 셋업 요약

### [1. 랜딩 페이지 작성 (LPINFO 쿠키생성)](https://github.com/linkprice/MerchantSetup/tree/master/CPS#랜딩-페이지-작성)

### [2. 실적 전송](https://github.com/linkprice/MerchantSetup/tree/master/CPS#실시간-실적-전송)
	구매 완료시 링크프라이스로 실적 전송 (**Server to Server 방식**)

### [3. 실적 정보 출력](https://github.com/linkprice/MerchantSetup/tree/master/CPS#실적-정보-출력-daily_fix)
	머천트 주문 정보와 링크프라이스 실적을 대조하여 누락된 실적을 복구하기 위한 작업

### [4. 자동 실적 취소](https://github.com/linkprice/MerchantSetup/tree/master/CPS#자동-실적-취소-auto_cancel)
	머천트 주문 취소시 링크프라이스 실적 자동 취소
<br />
<br />
<br />

## 랜딩 페이지 작성

1. 랜딩 페이지 작성

	* 랜딩 페이지는 쿠키 생성 후 머천트 웹사이트로 리다이렉트하는 역할을 합니다. (샘플코드 참조) 

	* RETURN_DAYS(광고 효과 인정 기간) 는 **계약서에 명시되어 있는 광고 효과 인정 기간**(일단위)으로 변경바랍니다. 
	
	* 광고 인정 기간을 계약서와 다르게 변경 시 계약위반으로 불이익을 받으실 수 있습니다.

2. 샘플 코드

	* [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/lpfront.php)
	* [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/JSP/lpfront.jsp)
	* [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/ASP/lpfront.asp)


## 실시간 실적 전송

1. 실시간 주문 정보 저장

 	* 구매 완료시 Cookie(**LPINFO**)가 존재하면 구매 정보를 저장합니다.
	
	* 머천트 주문 테이블에 아래 필드를 추가합니다.

	|     FIELD      |                VALUE                |
	| :------------: | :---------------------------------: |
	| network_value  |           LPINFO(cookie)            |
	| network_name  | 링크프라이스를 구분할 수 있는 값(예-linkprice, lp) |
	| remote_address |         사용자 IP(REMOTE_ADDR)         |
	| user_agent   |   사용자 user_agent(HTTP_USER_AGENT)   |

	* **구매 완료 시점**에 network_value, network_name, remote_address, user_agent 값을 주문 테이블에 저장하여 주십시요.

2. 실시간 실적 전송 시점

	* **구매 완료**시 실적을 전송하기 위해 실적전송 코드(샘플 참조)를 삽입해야 합니다.

	* 모든 실적은 Server to Server 방식으로 전송됩니다. (단, *스크립트(script) 및 이미지(image) 방식으로 전달 시 링크프라이스로 별도 문의 주셔야 합니다*)

3. 실시간 실적 전송 셋업

	* 샘플코드는 귀사의 개발 환경에 맞게 수정하시기 바랍니다.
	
	* JSON 형식으로 전송해 주시기 바랍니다.
	
	* KEY 이름은 **수정 할 수 없으며**, VALUE 값은 아래와 같이 입력해 주시기 바랍니다.
	
	```javascript
	[{
		affiliate_id : network_value,				// LPINFO cookie 값
		merchant_id : "Your merchant ID",			// 계약시 제공 받은 머천트 아이디
		member_id : "User ID of who phurchase products",	// 유저 ID (없으면 공백 처리)
		order_code : "Order code of product",			// 주문번호 (Unique 값)
		product_code : "Product code",				// 상품코드
		product_name : "Product name",				// 상품명
		item_count : "Item count",				// 개수
		sales : "Total price",					// 총금액 (가격 * 개수)
		category_code : "Category code of product",		// 카테고리 코드 (없으면 공백 처리)
		user_agent : "User Agent",				// $_SERVER["HTTP_USER_AGENT"]
		remote_addr:  "User IP"				        // $_SERVER["REMOTE_ADDR"]
	}]
	```

4. 샘플 코드
	* [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/index.php)
	* [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/JSP/index.jsp)
	* [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/ASP/index.asp)


## 실적 정보 출력 (daily_fix)

1. 실적 정보 출력

	* 머천트 주문 정보와 링크프라이스 실적을 대조하여 누락된 실적을 복구하기 위한 작업입니다.

	* 머천트의 실적 정보 출력 URL를 특정 시점마다 링크프라이스에서 호출하여 자동으로 복구합니다.

2. 실적 정보 출력 셋업

	* 머천트에 저장된 주문 정보 중 링크프라이스를 통해서 발생한 주문을 출력합니다.
	
	* 샘플코드는 머천트 개발 환경에 맞게 수정하시기 바랍니다.
	
	* 링크프라이스에서는 머천트의 주문 정보를 일별 호출합니다. (yyyymmdd 파라미터로 호출)
	
	* 아래 예시와 같이 호출하면 해당 날짜의 실적이 출력될 수 있도록 합니다.
		* 예 - www.example.com/linkprice/daily_fix.php?yyyymmdd=20170701
	
	* 실적은 json 형식으로 출력하시기 바랍니다.
	
	```javascript
	[{
		affiliate_id : network_value,				// LPINFO cookie 값
		merchant_id : "Your merchant ID",			// 계약시 제공 받은 머천트 아이디
		member_id : "User ID of who phurchase products",	// 유저 ID (없으면 공백 처리)
		order_code : "Order code of product",			// 주문번호 (Unique 값)
		product_code : "Product code",				// 상품코드
		product_name : "Product name",				// 상품명
		item_count : "Item count",				// 개수
		sales : "Total price",					// 총금액 (가격 * 개수)
		category_code : "Category code of product",		// 카테고리 코드 (없으면 공백 처리)
		user_agent : "User Agent",				// $_SERVER["HTTP_USER_AGENT"]
		remote_addr:  "User IP"				        // $_SERVER["REMOTE_ADDR"]
	}]
	```

3. 샘플 코드

	* [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/daily_fix.php)
	* [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/JSP/daily_fix.jsp)
	* [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/ASP/daily_fix.asp)


## 자동 실적 취소 (auto_cancel)

1. 자동 실적 취소
	* 머천트에서 주문 취소가 발생한 경우 (반품, 미입금, 취소 등) 링크프라이스에서 해당 실적을 취소합니다.
	
	* 링크프라이스 실적에서 주문번호(order_code)와 상품코드(product_code)를 머천트에 GET방식으로 전송합니다.

2. 자동 실적 취소 셋업
	* 샘플코드는 머천트 개발 환경에 맞게 수정하시기 바랍니다.
	
	* 머천트 자동 실적 취소 URL을 호출하여 링크프라이스에 있는 실적 취소를 진행합니다. (매월 20일)
	
	* 자동취소 페이지 호출 시 json 형식으로 출력하여 주시기 바랍니다.

	```javascript
	[{
		order_status : "1",		//결과코드(결과 코드표 참조)
		reason : "주문 확정"		// 이유
	}]
	```
	* 결과 코드표
	
	| 결과코드 |      의미      |         링크프라이스 처리지침          |
	| :--: | :----------: | :--------------------------: |
   	|  0   |   미입금, 미결제   | 결제 익월 20일까지 미입금 또는 미결제 경우 취소 |
   	|  1   |   주문 최종 확정   |            주문 확정             |
   	|  2   |   주문 취소/환불   |              취소              |
   	|  3   | 주문번호의 주문이 없음 |              취소              |
   	|  9   |  확인요망(예외상황)  |      링크프라이스 담당자 확인 후 처리      |

3. 샘플 코드

	* [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/auto_cancel.php)
	* [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/JSP/auto_cancel.jsp)
	* [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/ASP/auto_cancel.asp)


