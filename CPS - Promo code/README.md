## 1. 할인코드 CPS 란?

* 링크프라이스 전용 할인 코드를 이용해 매체가 홍보를 진행하고, 구매자가 해당 할인 코드를 사용해  

    구매나 예약 등의 실적이 발생되면 할인과 동시에 링크프라이스 측에 실적을 전송하는 것을 의미합니다.

    ![캡처1](C:/Users/LG/Downloads/Telegram%20Desktop/image2.png)

* 간략한 흐름도는 다음과 같습니다.

![캡처2](C:/Users/LG/Downloads/Telegram%20Desktop/image1.png)



#### **※ 할인코드 주의사항**

1. 동일한 주문에 **다수의 링크프라이스 할인코드 사용이 불가능** 합니다.
    전송된 할인코드(promo_code)에 따라 매체의 실적이 구분됩니다. (ex : A할인코드 - a매체 실적 / B할인코드 - b매체 실적) 때문에, 동일한 주문에 다수의 할인코드가 전송되면 실적 구분이 불가능합니다. 
     다만,  **링크프라이스 할인코드와 광고주 자체적으로 제공하는 할인코드(쿠폰등..)은 동시에 사용 가능**합니다.  
2. 링크프라이스 배너를 통해 유입되어 LPINFO가 존재한 상태로 링크프라이스 할인코드를 사용하는 경우 **할인코드 실적으로만 전송** 되도록 작업 되어야 합니다. 



## 2. 테이블 생성

1. 링크프라이스는 실적 추적을 위하여 다음의 데이터가(이하 **링크프라이스 데이터**) 반드시 필요합니다.
    1. event_code (string): 링크프라이스에서 생성하는 고유코드로 고정값 입니다. 
    2. promo_code(string) : 실제 구매자가 사용하는 할인코드로(매체 홍보시 사용), 링크프라이스용 할인코드를 발급후 해당 코드를 알려주세요.
    3. user_agent: USER_AGENT정보
    4. ip: 사용자의 IP주소
    5. device_type: 장치 구분 값
        1. web-pc: 모바일이 아닌 장치에서 발생한 웹 실적
        2. web-mobile: 모바일 장치에서 발생한 웹 실적
        3. app-android: Android App을 통해 발생한 실적
        4. app-ios: iOS App을 통해 발생한 실적 
2. **링크프라이스 데이터**를 저장 할 테이블(Lpinfo)을 아래처럼 변경합니다. 만약 lpinfo 테이블이 존재하지 않는다면, 담당자에게 문의 해 주세요.

```mysql
alter table lpinfo add event_code varchar(20);
alter table lpinfo add promo_code varchar(50);
```

1. **결제 완료 후**, 위에서 생성한 테이블에 **링크프라이스 데이터를 반드시 저장해야 합니다**.
2. 링크프라이스 전용 할인코드를 사용하여 발생한 실적만 저장 하여 주십시요.



## 3. 실시간 실적 전송

1. 결제 성공시, 링크프라이스에 아래의 Request 데이터를 json 으로 전송합니다. 

    1. 이 json에는 하나의 주문(order)만 있어야 합니다. 
    2. 여러 개의 다른 주문(order)이 포함 되어서는 안됩니다.
    3. 하나의 주문(order)에 여러 가지의 상품을 샀다면, 하나의 json에 그 여러개의 상품이 모두 포함되어야 합니다.
    4. Request URL- ://service.linkprice.com/lppurchase_cps_v4.php

2. Request

    1. order

        1. order_id(string): 주문번호, 구매자가 인지 가능한 주문번호이어야 누락신고시 이 주문번호로 누락 여부를 조회할 수 있습니다.
        2. final_paid_price(float):  배송비를 제외 한 실결제 금액
            1. 배송비를 구매자가 부담시 실결제금액에서 배송비를 제외한 금액입니다.
            2. 무료배송인 경우엔 실결제 금액 전체입니다.
        3. user_name(string): 누락신고시 누구의 실적인지를 알기 위해 사용 할 구매자 이름
        4. currency(string): 상품 결제시 사용된 통화
            1. ISO 4217 사용
            2. 예) USD, KRW, CNY, EUR

    2. products

        1. product_id(string): 상품 ID

        2. product_name(string): 상품 이름

        3. category_code(string): 상품 카테고리 코드

        4. category_name(string): 상품 카테고리 이름

            1. 해당 상품의 모든 카테고리 이름을 넣어주세요.
            2. 의류 > 남성의류 > 자켓 > 아우터 일 경우 아래와 같이 작성하여 주세요.

            ```json
            "category_name": ["의류", "남성의류", "자켓", "아우터"]
            ```

        5. quantity(unsigned int): 구매 갯수

        6. product_final_price(float): 구매자가 이 상품을 구매하기 위하여 결제해야 할 금액

        7. paid_at(string): 결제 완료 시간

            1. 결제 완료 시간이란 결제가 성공한 시간을 뜻합니다.
            2. Date Format : ISO-8601 ex. 2018-07-27T10:13:44+00:00

        8. confirmed_at(string): 구매 확정 시간

            1. 구매 확정이란 상품이 배송되어 쇼핑몰에서 지정한 환불/취소 기간이 지나 더 이상 환불/취소 불가능한 상태를 뜻합니다.
            2. 구매 확정 시간이란 구매 확정 상태가 된 시간을 뜻합니다.
            3. 구매 확정이 되지 않았다면 공백 문자열을 전송 해 주세요.
            4. 구매 확정이 되었다면 구매 확정 시간을 ISO-8601 포맷으로 전송 해 주세요.
            5. 예) 2018-07-27T10:13:44+00:00

        9. caceled_at(string): 구매 취소 확정 시간

            1. 구매 취소 확정이란 구매자의 요청으로 환불/취소가 처리 완료된 시간을 뜻합니다.
            2. 취소 확정이 되지 않았다면 공백 문자열을 전송 해 주세요.
            3. 취소 확정이 되었다면 취소 확정 시간을 ISO-8601 포맷으로 전송 해 주세요.
            4. 예) 2018-07-27T10:13:44+00:00

    3. linkprice

        1. merchant_id(string): 링크프라이스로부터 받은 머천트 ID
        2. event_code (string): 링크프라이스에서 생성하는 고유코드로 고정값 입니다.
        3. promo_code(string) : 실제 구매자가 사용하는 할인코드로(매체 홍보시 사용), 링크프라이스용 할인코드를 발급후 해당 코드를 알려주세요.
        4. user_agent(string): USER_AGENT정보
        5. remote_addr(string): 구매자의 IP주소. 서버 주소가 아닌 실 구매자의 IP주소를 전송 해 주세요.
        6. device_type(string): 장치 구분 값
            1. web-pc: 모바일이이 아닌 장치에서 발생한 웹 실적
            2. web-mobile: 모바일 장치에서 발생한 웹 실적
            3. app-ios: iOS App을 통해 발생한 실적 
            4. app-android: Android App을 통해 발생한 실적

3. Request Sample

    1. 구매자가  7000원짜리 HDMI 케이블2개, 6000원짜리 봉지라면 3개를 구매하였고, 무료배송이고, 식품 카테고리에만 10% 할인 가능한 링크프라이스 할인코드를 사용하여 구매한 경우 
        * event_code : LINKPRICE_EVENT_CODE
        * promo_code : PROMO_CODE01(식품 카테고리만 할인가능)
        * 링크프라이스 할인코드가 사용된 주문에 포함된 상품은 모두 전송되야 합니다.  ( HDMI 케이블 / 봉지라면 모두 전송)
        * Sample
            1. 할인코드 적용전에 결제해야 할 금액은 32000원입니다. 식품 카테고리에만 10% 할인코드를 사용하였으므로 최종적으로 구매자가 지불해야 할 금액은 **30200**원입니다
            2. HDMI 케이블은 할인 카테고리에 해당하지 않기 때문에  HDMI 케이블의 product_final_price은 **14000**원입니다.
            3. 쿠폰 적용전에 봉지라면의 product_final_price은 18000원이었는데,  10% 할인코드를 적용하면 16200 원이므로 봉지라면의 product_final_price은 **16200**원입니다.
            4. 30200(final_paid_price) = 14000(product_final_price은) + 16200(product_final_price)

```json
   {
       "order": {
           "order_id": "o190203-h78X3",
           "final_paid_price": 30200,
           "currency": "KRW",
           "user_name": "구매자"
       },
       "products": [
           {
               "product_id": "P87-234-anx87",
               "product_name": "UHD 4K 넥시 HDMI케이블",
               "category_code": "132782",
               "category_name": ["컴퓨터 주변기기", "케이블", "HDMI케이블"],
               "quantity": 2,
               "product_final_price": 14000,
               "paid_at": "2019-02-12T11:13:44+00:00",
               "confirmed_at": "",
               "canceled_at": ""
           },
           {
               "product_id": "P23-983-Z3272",
               "product_name": "농심 오징어짬뽕124g(5개)",
               "category_code": "237018",
               "category_name": ["가공식품", "라면", "봉지라면"],
               "quantity": 3,
               "product_final_price": 16200,
               "paid_at": "2019-02-12T11:13:44+00:00",
               "confirmed_at": "",
               "canceled_at": ""
           }
       ],
       "linkprice": {
           "merchant_id": "sample",
           "event_code" : "LINKPRICE_EVENT_CODE", 
           "promo_code" : "PROMO_CODE01",             
           "user_agent": "Mozilla/5.0...",
           "remote_addr": "127.0.0.1",
           "device_type": "web-pc"
       }
   }
```

1. Response

    1. 응답 바디는 JSON객체입니다.

        | KEY           | VALUE                                 |
        | ------------- | ------------------------------------- |
        | is_success    | true / false<br />실적 전송 성공 여부 |
        | error_message | 에러 메세지                           |
        | order_code    | 주문 코드                             |
        | product_code  | 상품 코드                             |

    2. Respons Sample

        1. 전송 성공시

        ```json
        [
            {
                "is_success": true,
                "error_message": "",
                "order_code": "order_115",
                "product_code": "product1"
            },
            {
                "is_success": true,
                "error_message": "",
                "order_code": "order_115",
                "product_code": "product2"
            }
        ]
        ```

        2. 전송 실패시

        ```json
        [
            {
                "is_success": false,
                "error_message": "lpinfo parameter is empty.",
                "order_code": "order_115",
                "product_code": "product1"
            },
            {
                "is_success": false,
                "error_message": "lpinfo parameter is empty.",
                "order_code": "order_115",
                "product_code": "product2"
            }
        ]
        ```

        * CPS 할인코드 에러 메세지      

        | error_message                                                | 에러 상세 내용                                               |
        | ------------------------------------------------------------ | ------------------------------------------------------------ |
        | This is not a valid JSON string.                             | REQUEST 가 JSON 형식이 아님                                  |
        | order.order_id parameter is empty.                           | order.order_id 미입력                                        |
        | order.final_paid_price parameter is empty.                   | order.final_paid_price 미입력                                |
        | order.final_paid_price is not integer.                       | order.final_paid_price integer형이 아님                      |
        | order.currency parameter is empty.                           | order.currency 미입력                                        |
        | order.user_name parameter is empty.                          | order.user_name 미입력                                       |
        | products parameter is empty.                                 | products 미입력                                              |
        | linkprice.promo_code parameter is empty.                     | linkprice.promo_code 미입력                                  |
        | linkprice.event_code parameter is empty.                     | linkprice.event_code 미입력                                  |
        | event is nothing.                                            | 진행 중인 event 미존재                                       |
        | linkprice.user_agent parameter is empty.                     | linkprice.user_agent 미입력                                  |
        | linkprice.remote_addr parameter is empty.                    | linkprice.remote_addr 미입력                                 |
        | linkprice.device_type parameter is empty.                    | linkprice.device_type 미입력                                 |
        | products[i].product_id parameter is empty.                   | products i번째 product_id 미입력                             |
        | products[i].product_name parameter is empty.                 | products i번째 product_name 미입력                           |
        | products[i].category_code parameter is empty.                | products i번째 category_code 미입력                          |
        | products[i].product_final_price parameter is empty.          | products i번째 product_final_price 미입력                    |
        | The amount of order.final_paid_price does not match the total amount of products.product_final_price. | products의 합산 금액과 order.final_paid_price 금액이 일치하지 않음. |
        | There was a problem sending your performance.                | 실적 전송 오류                                               |



## 4. 실적 목록

1. 실적 목록이란?

    1. 정확하고 빠른 정산을 위하여 링크프라이스 실적 데이터를 제공하는 API입니다.
    2. 머천트 주문 정보와 링크프라이스의 실적을 대조하여 누락된 실적을 복구합니다.
    3. **일반 CPS 프로그램에서 실적목록을 사용하고 있는 머천트는 사용중인 실적목록 호출 시 할인코드 CPS 실적의 주문도 함께 출력되도록 작업해주시면 됩니다.**

2. 실적 목록 출력

    1. 링크프라이스가 머천트 API를 호출하여 실적목록을 확인 하며, 실적 목록 API는 머천트가 직접 작성 해 주셔야 합니다.
    2. 실시간 실적 전송된 데이터와 실적 목록 API에서 확인되는 데이터는 모두 동일해야 합니다.
    3. 아래와 같이 링크프라이스에서 머천트 API를 호출하게 되며, **paid_ymd, confirmed_ymd, canceled_ymd**세가지 파라미터를 사용 하여 조회 할 수 있어야 합니다.

    ```shell
    curl https://api.yourdomain.com/linkprice/order_list_v1?paid_ymd=20181220
    ```

    1. 파라미터 설명

    | 파라미터      | 값                                                           |
    | ------------- | ------------------------------------------------------------ |
    | paid_ymd      | 결제 완료 조회 날짜. 예) 20181220 <BR />해당날짜에 결제가 완료된 모든 링크프라이스 실적을 보여줍니다. |
    | confirmed_ymd | 구매 확정 조회 날짜. 예) 20181220 <BR />해당날짜에 구매가 확정된 모든 링크프라이스 실적을 보여줍니다. |
    | canceled_ymd  | 취소 확정 조회 날짜. 예) 20181220 <BR />해당날짜에 구매 취소가 확정된 모든 링크프라이스 실적을 보여줍니다. |

    1. 실적 목록은 json 형식으로 출력하시기 바랍니다.

        1. 예

        ```json
        [
            {"order":{"order_id":"ord-123-01",....},"products":[...],"linkprice":{...}},
            {"order":{"order_id":"ord-123-02",....},"products":[...],"linkprice":{...}},
            {"order":{"order_id":"ord-123-03",....},"products":[...],"linkprice":{...}},
            {"order":{"order_id":"ord-123-04",....},"products":[...],"linkprice":{...}}
        ]
        ```

## 5. FAQ

* Q: 이벤트 코드(event_code) 란 무엇인가요?
    * A: 링크프라이스에서 생성하는 고유코드이며, 생성된 이벤트 코드는 담당자에게 문의하시며 됩니다. 
* Q: 할인 코드(promo_code)란 무엇인가요?
    * A:  매체에서 홍보시 사용하고, 실제 구매자가 귀사의 사이트에서 사용하게될 할인코드로 링크프라이스 전용 할인코드를 생성하시면 담당자에게 알려주셔야 합니다. 
* Q: 할인코드 실적의 금액 처리방법을 알려주세요. 
    * A:  Request Sample을 참고하시고 각 상품의 배송비를 제외한 구매자의 실 결제금액이 전송되도록 해주시면 됩니다. 