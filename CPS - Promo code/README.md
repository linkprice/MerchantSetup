## 셋업 요약

### [1. 실적 전송](https://github.com/linkprice/MerchantSetup/tree/master/CPS#실시간-실적-전송)
* 구매 완료시 링크프라이스로 실적 전송 (**Server to Server 방식**)

### [2. 실적 정보 출력](https://github.com/linkprice/MerchantSetup/tree/master/CPS#실적-정보-출력-daily_fix)
 * 머천트 주문 정보와 링크프라이스 실적을 대조하여 누락된 실적을 복구하기 위한 작업

<br />
  <br />
  <br />

## 실시간 실적 전송

1. 실시간 주문 정보 저장

   * 머천트 주문 테이블에 아래 필드를 추가합니다.

   |     FIELD      |              VALUE              |
   | :------------: | :-----------------------------: |
   |   event_code   |             이벤트 코드              |
   |   promo_code   |              할인 코드              |
   | remote_address |       사용자 IP(REMOTE_ADDR)       |
   |   user_agent   | 사용자 user_agent(HTTP_USER_AGENT) |

   * **결제 완료 시점**에 event_code, promo_code, remote_address, user_agent 값을 주문 테이블에 저장하여 주십시오.

2. 실시간 실적 전송 시점

  * **구매 완료**시 실적을 전송하기 위해 실적전송 코드(샘플 참조)를 삽입해야 합니다.

  * 모든 실적은 Server to Server 방식으로 전송됩니다. (단, *스크립트(script) 및 이미지(image) 방식으로 전달 시 링크프라이스로 별도 문의 주셔야 합니다*)

3. 실시간 실적 전송 셋업

  * 샘플코드는 귀사의 개발 환경에 맞게 수정하시기 바랍니다.
  * JSON 형식으로 전송해 주시기 바랍니다.
  * KEY 이름은 **수정 할 수 없으며**, VALUE 값은 아래와 같이 입력해 주시기 바랍니다.
  * 실적 중 위의 값으로 실적 구분이  경우 링크프라이스로 연락 주십시요.

  ```javascript
  [
    {
  	    event_code : "Event code",                          // 이벤트 코드
              promo_code : "Promotion code",                      // 할인 코드
  	    member_id : "User ID of who phurchase products",	// 회원 ID
  	    order_code : "Order code of product",               // 주문번호
  	    product_code : "Product code",                      // 상품코드
  	    product_name : "Product name",                      // 상품명
  	    item_count : "Item count",                          // 개수
  	    sales : "Total price",                              // 총금액 (가격 * 개수)
  	    user_agent : "User Agent",                          // $_SERVER["HTTP_USER_AGENT"]
  	    remote_addr:  "User IP",                             // $_SERVER["REMOTE_ADDR"],
  	    sales_type: "Sales Type"                             // PC, MOBILE, IOS, AND, APP(택1, 옵션) 
    }
  ]
  ```
  
  * 이벤트 코드(event_code) 는 링크프라이스에서 등록되어야 하는 고유코드입니다.
  
  * 할인 코드(promo_code) 는 머천트 측에서 발급한 후 링크프라이스에 알려줘야 하는 코드입니다.
  
  * **발급 관련해서는 링크프라이스 측에 연락 바랍니다.**

4. 샘플 코드
  * [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/PHP/index.php)
  * [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/JSP/index.jsp)
  * [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/ASP/index.asp)


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
  	    event_code : "Event code",                          // 이벤트 코드
              promo_code : "Promotion code",                      // 할인 코드
  	    order_time : "order time",                          // 주문시간 (EX: 오후 6시면 "180000" 으로 출력)
  	    member_id : "User ID of who phurchase products",    // 회원 ID
  	    order_code : "Order code of product",               // 주문번호
  	    product_code : "Product code",                      // 상품코드
  	    product_name : "Product name",                      // 상품명
  	    item_count : "Item count",                          // 개수
  	    sales : "Total price",                              // 총금액 (가격 * 개수)
  	    user_agent : "User Agent",                          // $_SERVER["HTTP_USER_AGENT"]
  	    remote_addr:  "User IP",                             // $_SERVER["REMOTE_ADDR"]
  	    sales_type: "Sales Type"                          // PC, MOBILE, IOS, AND, APP(택1, 옵션) 
    }
]
  ```

3. 샘플 코드

  * [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/PHP/daily_fix.php)
  * [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/JSP/daily_fix.jsp)
  * [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/ASP/daily_fix.asp)


