## 월배치 정산

* 정확하고 빠른 정산을 위하여 실적 데이터를 api로 제공 합니다.
* 데이터는 보안을 위해 RSA 암호화 하여 제공합니다.
  * Private key 와 Public key는 링크프라이스에서 생성하여 Private key를 전달드립니다.
  * 전달받은 Private key를 사용 실적 데이터를 RSA 암호화 합니다. 
* API 호출 시 아래 와 같은 형태로 링크프라이스 월 실적을 제공 부탁드립니다.


```json
{
    lists: [
        {
            lpinfo : "A100000131|25357121000000|0000|B|1",
            yyyymmdd : "20180701",
            member_id : "member_id",
            order_code : "A123339902-23222",
            product_code : "m1000923",
            product_name : "Samsung TV 57",
            item_count : 1,
            sales : 1500,
            currency : "USD",
            category_code : "elec1000-23323",
            user_agent : "User agent",
            remote_addr : "127.0.0.1",
            sales_type : "IOS",
            status : "APR"
        }
    ]
    
}
```

|  KEY   |         VALUE          |
| :----: | :--------------------: |
| lists  |     실적 개체 배열     |

* lists 실적개체
  (볼드체: 필수값)

|        KEY        | DATA TYPE | VALUE                                                        |
| :---------------: | :-------: | :----------------------------------------------------------- |
|    **lpinfo**     |  String   | 실적 발생 시 사용된 lpinfo 쿠키 값<br />링크프라이스 광고를 타고 들어왔을때  게이트 페이지에서 생성되는 <br />어필리에트 정보를 담고있는 쿠키이며 실시간 실적 전송시 사용되는 값입니다. |
|   **yyyymmdd**    |  String   | 실적 발생 날짜                                               |
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
|    sales_type     |  String   | 구매자 디바이스 정보 (PC, MOBILE, IOS, AND, APP)<br />PC : PC 웹<br />MOBILE : 모바일 웹<br />iOS : iOS 앱<br />AND : 안드로이드 앱<br />APP : 모바일 앱으로 구매하였으나 iOS, Android 구분 안될때 |
|      status       |  String   | 실적 상태값(APR,CAN)<br />APR : 확정 실적<br />CAN : 취소 확정<br />상태값은 실적 상태가 더이상 변하지 않는 상태값을 보내주셔야 합니다.<br />확정 실적은 더이상 취쇠되지 않습니다. |



