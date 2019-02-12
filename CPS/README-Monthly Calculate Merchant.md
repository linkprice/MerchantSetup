## 월배치 정산

* 정확하고 빠른 정산을 위하여 실적 데이터를 api로 제공 합니다.
* 데이터는 보안을 위해 RSA 암호화 하여 제공합니다.
  * Private key 와 Public key는 링크프라이스에서 생성하여 Private key를 전달드립니다.
  * 전달받은 Private key를 사용 실적 데이터를 RSA 암호화 합니다. 
* API 호출 시 아래 와 같은 형태(NDJSON)로 링크프라이스 월 실적을 제공 부탁드립니다. 


```javascript
{
    "lpinfo" : "network_value",				// LPINFO cookie 값
    "member_id" : "User ID of who phurchase products",	// 회원 ID
    "order_code" : "Order code of product",			// 주문번호
    "product_code" : "Product code",				// 상품코드
    "product_name" : "Product name",				// 상품명
    "item_count" : "Item count",				// 개수
    "sales" : "Total price",					// 총금액 (가격 * 개수)
    "category_code" : "Category code of product",		// 카테고리 코드
    "user_agent" : "User Agent",				// $_SERVER["HTTP_USER_AGENT"]
    "remote_addr" : "User IP"				        // $_SERVER["REMOTE_ADDR"]
    "device_type" : "Device type"		       
    "payed_yyyymmdd" : "실적 결제 날짜"		       
    "confirmed_yyyymmdd" : "실적 확정 날짜"		       
    "canceled_yyyymmdd" : "실적 취소 날짜"		       
}\n
```
* 예제 

```javascript
{
    "lpinfo" : "A100000131|25357121000000|0000|B|1",        
    "member_id" : "{member_id}",	       
    "order_code" : "A123339902-23222",        
    "product_code" : "m1000923",        
    "product_name" : "Samsung TV 57",        
    "item_count" : "1",        
    "sales" : "1500",        
    "category_code" : "elec1000-23323",        
    "user_agent" : "{User agent}",	       
    "remote_addr" : "127.0.0.1",
    "device_type" : "AND",	       
    "payed_yyyymmdd" : "2018-07-01T11:13:44+00:00", 		       
    "confirmed_yyyymmdd" : "2018-10-10T11:13:10+00:00", 		       
    "canceled_yyyymmdd" : "2018-12-03T15:13:30+00:00"		       
}\n
{
    "lpinfo" : "A100000131|25365432000000|0000|B|1",        
    "member_id" : "{member_id}",	       
    "order_code" : "B123339902-23111",        
    "product_code" : "p1000856",        
    "product_name" : "LG TV 23",        
    "item_count" : "1",        
    "sales" : "500",        
    "category_code" : "elec1000-23123",        
    "user_agent" : "{User agent}",	       
    "remote_addr" : "127.0.0.1",
    "device_type" : "PC"	       
    "payed_yyyymmdd" : "2018-07-27T10:13:44+00:00", 		       
    "confirmed_yyyymmdd" : "2018-09-10T12:13:10+00:00", 		       
    "canceled_yyyymmdd" : "2018-11-03T16:13:30+00:00"		       
}\n

```

* orderlist 실적개체  (볼드체: 필수값)


|        KEY        | DATA TYPE | VALUE                                                        |
| ----------------- | :-------: | :----------------------------------------------------------- |
|    **lpinfo**     |  String   | 실적 발생 시 사용된 lpinfo 쿠키 값<br />링크프라이스 광고를 타고 들어왔을때  게이트 페이지에서 생성되는 <br />어필리에트 정보를 담고있는 쿠키이며 실시간 실적 전송시 사용되는 값입니다. |
|     member_id     |  String   | 실적 발생 회원 ID<br />실적을 발생시킨 유저의 유니크한 값    |
|  **order_code**   |  String   | 주문코드                                                     |
| **product_code**  |  String   | 상품코드                                                     |
|   product_name    |  String   | 상품명                                                       |
|    item_count     |  Number   | 수량                                                         |
|     **sales**     |  Number   | 구매 가격<br />실시간  실적 전송시 보내주신 구매가격과 동일한 값이여야 합니다. |
|     currency      |  String   | 통화(ISO code)<br />기본 값은 KRW 이며 통화가 KRW 일시생략가능합니다.<br />KRW 이외의 통화시 반드시 전달 부탁드립니다. |
| **category_code** |  String   | 상품의 카테고리 코드                                         |
|    user_agent     |  String   | $_SERVER["HTTP_USER_AGENT"]                                  |
|    remote_addr    |  String   | 구매자 IP                                                    |
|    device_type     |  String   | 구매자 디바이스 정보 (PC, MOBILE, AND, IOS)<br />PC : PC 웹<br />MOBILE : 모바일 웹<br />AND : 안드로이드 앱 구매<br />IOS : IOS 앱 구매 |
|   **payed_yyyymmdd**    |  Date | 실적 결제 날짜 <br />(Date Format : ISO-8601 ex.  2018-07-27T10:13:44+00:00) |
|   **confirmed_yyyymmdd**    | Date | 실적 확정 날짜<br />(Date Format : ISO-8601 ex.  2018-09-10T12:13:10+00:00) |
|   **canceled_yyyymmdd**    | Date | 실적 취소 날짜<br />(Date Format: ISO-8601, ex.  2018-11-03T16:13:30+00:00) |

