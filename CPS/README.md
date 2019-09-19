## 1. 제휴 마케팅이란

> 제휴 마케팅이란 제품/ 서비스 등을 판매하는 인터넷 업체(Merchant)가 고객을 끌어들이고 진열, 판매하는 공간으로 자신의 사이트 뿐만 아니라 다른 관련 사이트(Affiliate)로 까지 공간을 확장하여 
> 이때 발생하는 수입을 제휴맺은 사이트(Affiliate)와 공유하는 새로운 형태의 마케팅 기법입니다. 

1. [제휴 마케팅 소개](https://helpdesk.linkprice.com/pages/merchant-faq-introduce)

## 2. lpinfo 테이블 생성

1. 링크프라이스는 실적 추적을 위하여 다음의 데이터가(이하 **링크프라이스 데이터**) 반드시 필요합니다.

    1. lpinfo: "lpinfo"라는 쿠키에 저장된 값
    2. user_agent: USER_AGENT정보
    3. ip: 사용자의 IP주소
    4. device_type: 장치 구분 값
        1. web-pc: 모바일이 아닌 장치에서 발생한 웹 실적
        2. web-mobile: 모바일 장치에서 발생한 웹 실적
        3. app-android: Android App을 통해 발생한 실적
        4. app-ios: iOS App을 통해 발생한 실적 

2. **링크프라이스 데이터**를 저장 할 테이블(Lpinfo)을 아래처럼 새로이 생성합니다.

  ```mysql
    create table lpinfo(
    	id int not null,
        order_id varchar(30),
        product_id varchar(30),
        lpinfo varchar(580),
        user_agent varchar(300),
        ip varchar(50),
        device_type varchar(10)
    )
  ```

3. **결제 완료 후**, 위에서 생성한 테이블에 **링크프라이스 데이터를 반드시 저장해야 합니다**.

4. 링크프라이스를 통해 발생한 실적만 저장 하여 주십시요(lpinfo라는 쿠키가 존재하는 경우에만 위의 테이블에 저장하십시요)



## 3. 게이트웨이 페이지

1. 게이트웨이 페이지란?

    1. 사용자가 배너를 클릭 하면, 링크프라이스를 거쳐, 머천트로 리다이렉션 합니다.
    2. 머천트로 리다이렉션 할 때, 처음으로 거치는 웹페이지를 게이트웨이 페이지라고 합니다.
    3. 이 게이트웨이 페이지는 유효성 체크, 쿠키 생성, 목적 페이지로 리다이렉션 등의 작업을 합니다.

2. 게이트웨이 페이지의 가장 중요한 목적은 **"lpinfo"로 쿠키를 생성**하는 것입니다.

3. 게이트웨이 페이지를 생성 한 후, 링크프라이스에서 전달받은 자바스크립를 추가하여 주십시요.

    1. 게이트웨이 페이지 생성은 사용하시는 서버 환경에 따라 달라 질 수 있습니다.
    2. **이 게이트웨이 페이지는 아무나 접근 가능한 웹페이지이며 https로 접속 가능해야 합니다**. https가 불가한 경우 링크프라이스에 연락 주세요.
    3. 예를 들어  https://www.yourdomain.com/linkprice/gateway 처럼, 게이트웨이 페이지를 생성 해 주세요.

4. 게이트웨이 페이지 생성 후 **링크프라이스에서 제공하는 자바스크립트(javascript)를 추가하여 주십시요**. 아래의 스크립트는 샘플코드로 실제코드와는 다릅니다. 반드시 링크프라이스에서 제공하는 자바스크립트를 게이트웨이 페이지에 추가 해 주세요.

    ```javascript
     <!-- Google Tag Manager -->
      <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
      new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
      j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
      'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
      })(window,document,'script','dataLayer','GTM-P3HTV4');</script>
      <!-- End Google Tag Manager -->
    ```

5. **게이트웨이 페이지 URL을 링크프라이스에 알려 주세요**.



## 4. 실시간 실적 전송

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
            2. Date Format : ISO-8601 ex. 2018-07-27T10:13:44+09:00

        8. confirmed_at(string): 구매 확정 시간

            1. 구매 확정이란 상품이 배송되어 쇼핑몰에서 지정한 환불/취소 기간이 지나 더 이상 환불/취소 불가능한 상태를 뜻합니다.
            2. 구매 확정 시간이란 구매 확정 상태가 된 시간을 뜻합니다.
            3. 구매 확정이 되지 않았다면 공백 문자열을 전송 해 주세요.
            4. 구매 확정이 되었다면 구매 확정 시간을 ISO-8601 포맷으로 전송 해 주세요.
            5. 예) 2018-07-27T10:13:44+09:00

        9. caceled_at(string): 구매 취소 확정 시간

            1. 구매 취소 확정이란 구매자의 요청으로 환불/취소가 처리 완료된 시간을 뜻합니다.
            2. 취소 확정이 되지 않았다면 공백 문자열을 전송 해 주세요.
            3. 취소 확정이 되었다면 취소 확정 시간을 ISO-8601 포맷으로 전송 해 주세요.
            4. 예) 2018-07-27T10:13:44+09:00
    3. linkprice
        1. lpinfo(string): "lpinfo"라는 쿠키에 저장된 값
        2. merchant_id(string): 링크프라이스로부터 받은 머천트 ID
        3. user_agent(string): USER_AGENT정보
        4. remote_addr(string): 구매자의 IP주소. 서버 주소가 아닌 실 구매자의 IP주소를 전송 해 주세요.
        5. <a name="device_type"></a>device_type(string): 장치 구분 값
            1. web-pc: 모바일이이 아닌 장치에서 발생한 웹 실적
            2. web-mobile: 모바일 장치에서 발생한 웹 실적
            3. app-ios: iOS App을 통해 발생한 실적 
            4. app-android: Android App을 통해 발생한 실적


3. Request Sample

   1. 구매자가 7000원짜리 HDMI 케이블2개, 6000원짜리 봉지라면 3개를 구매하였고, 무료배송인 경우
        1. 각 상품의 product_final_price의 합은 final_paid_price와 같아야 합니다: 14000 + 18000 = 32000
        2. 아래의 샘플은 

   ```json
   {
       "order": {
           "order_id": "o190203-h78X3",
           "final_paid_price": 32000,
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
               "product_final_price": 18000,
               "paid_at": "2019-02-12T11:13:44+09:00",
               "confirmed_at": "",
               "canceled_at": ""
           }
       ],
       "linkprice": {
           "merchant_id": "sample",
           "lpinfo": "A123456789|9832|A|m|a8uakljfa",
           "user_agent": "Mozilla/5.0...",
           "remote_addr": "127.0.0.1",
           "device_type": "web-pc"
       }
   }
   ```

   2. 구매자가  7000원짜리 HDMI 케이블2개, 6000원짜리 봉지라면 3개를 구매하였고, 배송비 3000원은 구매자가 추가로 지불한 경우

     1. 실결제 금액은 배송비 3000원을 포함한 35000원입니다.
     2. final_paid_price는 실결제 금액 35000원에서 배송비 3000원을 뺀 **32000**원입니다
     3. 각 상품의 product_final_price의 합은 final_paid_price와 같아야 합니다: 14000 + 18000 = 32000

   ```json
   {
       "order": {
           "order_id": "o190203-h78X3",
           "final_paid_price": 32000,
           ...
    	},
    	"products": [
        	{
                "product_name": "UHD 4K 넥시 HDMI케이블",
                "product_final_price": 14000,
               ...
        	},
        	{
                "product_name": "농심 오징어짬뽕124g(5개)",
                "product_final_price": 18000,
               ...
       	}
    	],
    	"linkprice": {
            "merchant_id": "sample",
            "lpinfo": "A123456789|9832|A|m|a8uakljfa",
            ...
    	}
   }
   ```

   3. 구매자가  7000원짜리 HDMI 케이블2개, 6000원짜리 봉지라면 3개를 구매하였고, 무료배송이고,  최종적으로 전체 상품에 대해 10%할인 쿠폰을 사용한 경우
       1. 쿠폰 적용전에 결제해야 할 금액은 32000원입니다. 10% 쿠폰을 사용하였으므로 최종적으로 구매자가 지불해야 할 금액은 **28800**원입니다
       2. 10% 쿠폰 적용전에 hdmi 케이블의 product_final_price은 14000원이었는데, 10% 쿠폰을 적용하면 12600원이므로 hdmi 케이블의 product_final_price은 **12600**원입니다.
       3. 10% 쿠폰 적용전에 봉지라면의 product_final_price은 18000원이었는데, 10% 쿠폰을 적용하면 16200 원이므로 봉지라면의 product_final_price은 **16200**원입니다.
       4. 28800(final_paid_price) = 12600(product_final_price은) + 16200(product_final_price)

   ```json
   {
       "order": {
           "order_id": "o190203-h78X3",
           "final_paid_price": 28800,
           ...
    	},
    	"products": [
        	{
                "product_name": "UHD 4K 넥시 HDMI케이블",
                "product_final_price": 12600,
               ...
        	},
        	{
                "product_name": "농심 오징어짬뽕124g(5개)",
                "product_final_price": 16200,
               ...
       	}
    	],
    	"linkprice": {
            "merchant_id": "sample",
            "lpinfo": "A123456789|9832|A|m|a8uakljfa",
            ...
    	}
   }
   ```


   4. 구매자가  7000원짜리 HDMI 케이블2개, 6000원짜리 봉지라면 3개를 구매하였고, 무료배송이고, 최종적으로 식품 카테고리에 대해 5000원 할인 쿠폰을 사용한 경우
         1. 쿠폰 적용전에 결제해야 할 금액은 32000원입니다. 5000원 쿠폰을 사용하였으므로 최종적으로 구매자가 지불해야 할 금액은 **27000**원입니다
         2. hdmi 케이블은 쿠폰 적용을 받지 않으므로 product_final_price은 **14000**원입니다.
         3. 봉지라면의 경우 18000원에서 5000원을 뺀 **13000**원이 product_final_price입니다
         4. 27000(final_paid_price) = 14000(product_final_price은) + 13000(product_final_price)

   ```json
   {
       "order": {
           "order_id": "o190203-h78X3",
           "final_paid_price": 27000,
           ...
    	},
    	"products": [
        	{
                "product_name": "UHD 4K 넥시 HDMI케이블",
                "product_final_price": 14000,
               ...
        	},
        	{
                "product_name": "농심 오징어짬뽕124g(5개)",
                "product_final_price": 13000,
               ...
       	}
    	],
    	"linkprice": {
            "merchant_id": "sample",
            "lpinfo": "A123456789|9832|A|m|a8uakljfa",
            ...
    	}
   }
   ```

   5. <a name="final_paid_price"></a>구매자가  7000원짜리 HDMI 케이블2개, 6000원짜리 봉지라면 3개를 구매하였고, 무료배송이고, 최종적으로 마일리지 3000원을 사용한 경우
       1. 쿠폰 적용전에 결제해야 할 금액은 32000원입니다. 3000원 마일리지를 사용하였으므로 최종적으로 구매자가 지불해야 할 금액은 **29000**원입니다
       2. 마일리지 적용전 hdmi 케이블의 product_final_price은 14000원 이었는데 3000원 마일리지를 사용하였으므로 14000 - 3000 * 14000 / 32000 = **12688**원 입니다
       3. 마일리지 적용전 봉지라면의 product_final_price은 18000원 이었는데 3000원 마일리지를 사용하였으므로 18000 - 3000 * 18000 / 32000 = **16313**원 입니다
       4. 29000(final_paid_price) = 12688(product_final_price은) + 16313(product_final_price)

   ```json
   {
       "order": {
           "order_id": "o190203-h78X3",
           "final_paid_price": 29000,
           ...
       },
       "products": [
           {
               "product_name": "UHD 4K 넥시 HDMI케이블",
               "product_final_price": 12688,
               ...
           },
           {
               "product_name": "농심 오징어짬뽕124g(5개)",
               "product_final_price": 16313,
               ...
           }
       ],
       "linkprice": {
           "merchant_id": "sample",
           "lpinfo": "A123456789|9832|A|m|a8uakljfa",
           ...
       }
   }
   ```

   

4. Response

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

       

       * CPS 에러 메세지

       | error_message                                                | 에러 상세 내용                                               |
       | ------------------------------------------------------------ | ------------------------------------------------------------ |
       | This is not a valid JSON string.                             | REQUEST 가 JSON 형식이 아님                                  |
       | order.order_id parameter is empty.                           | order.order_id 미입력                                      |
       | order.final_paid_price parameter is empty.                   | order.final_paid_price 미입력                               |
       | order.final_paid_price is not integer.                       | order.final_paid_price integer형이 아님                     |
       | order.currency parameter is empty.                           | order.currency 미입력                                        |
       | order.user_name parameter is empty.                          | order.user_name 미입력                                      |
       | products parameter is empty.                                 | products 미입력                                    |
       | linkprice.lpinfo parameter is empty.                         | linkprice.lpinfo 미입력                                  |
       | linkprice.lpinfo parameter does not conform to the format.   | linkprice.lpinfo 미입력                                      |
       | linkprice.user_agent parameter is empty.                     | linkprice.user_agent 미입력                                  |
       | linkprice.remote_addr parameter is empty.                    | linkprice.remote_addr 미입력                                 |
       | linkprice.device_type parameter is empty.                    | linkprice.device_type 미입력                                 |
       | products[i].product_id parameter is empty.                   | products i번째 product_id 미입력                             |
       | products[i].product_name parameter is empty.                 | products i번째 product_name 미입력                           |
       | products[i].category_code parameter is empty.                | products i번째 category_code 미입력                          |
       | products[i].product_final_price parameter is empty.          | products i번째 product_final_price 미입력                    |
       | The amount of order.final_paid_price does not match the total amount of products.product_final_price. | products의 합산 금액과 order.final_paid_price 금액이 일치하지 않음. |
       | There was a problem sending your performance.                | 실적 전송 오류                                               |

       


## 5. 실적 목록

1. 실적 목록이란?

    1. 정확하고 빠른 정산을 위하여 링크프라이스 실적 데이터를 제공하는 API입니다.
    2. 머천트 주문 정보와 링크프라이스의 실적을 대조하여 누락된 실적을 복구합니다.

2. 실적 목록 출력

   1. 링크프라이스가 머천트 API를 호출하여 실적목록을 확인 하며, 실적 목록 API는 머천트가 직접 작성 해 주셔야 합니다.
   2. 실시간 실적 전송된 데이터와 실적 목록 API에서 확인되는 데이터는 모두 동일해야 합니다.
   3. 아래와 같이 링크프라이스에서 머천트 API를 호출하게 되며, **paid_ymd, confirmed_ymd, canceled_ymd**세가지 파라미터를 사용 하여 조회 할 수 있어야 합니다.

   ```shell
   curl https://api.yourdomain.com/linkprice/order_list_v1?paid_ymd=20181220
   ```

   4. 파라미터 설명

   | 파라미터      | 값                                    |
   | ------------- | ------------------------------------- |
   | paid_ymd      | 결제 완료 조회 날짜. 예) 20181220 <BR />해당날짜에 결제가 완료된 모든 링크프라이스 실적을 보여줍니다. |
   | confirmed_ymd | 구매 확정 조회 날짜. 예) 20181220 <BR />해당날짜에 구매가 확정된 모든 링크프라이스 실적을 보여줍니다. |
   | canceled_ymd  | 취소 확정 조회 날짜. 예) 20181220 <BR />해당날짜에 구매 취소가 확정된 모든 링크프라이스 실적을 보여줍니다. |

   5. 실적 목록은 json 형식으로 출력하시기 바랍니다.
        1. 예

        ```json
        [
            {"order":{"order_id":"ord-123-01",....},"products":[...],"linkprice":{...}},
            {"order":{"order_id":"ord-123-02",....},"products":[...],"linkprice":{...}},
            {"order":{"order_id":"ord-123-03",....},"products":[...],"linkprice":{...}},
            {"order":{"order_id":"ord-123-04",....},"products":[...],"linkprice":{...}}
       ]

        ```




## 6. FAQ


* Q: 이미 CPS 셋업이 되어 있는 경우에는 어떻게 하나요?

  * A: 이미 CPS 셋업이 되어 있다면, 구 버전으로 셋업이 되어 있을 확률이 높습니다. 데이터 처리 방식이나 내용이 많이 바뀌었으므로, 현재 버전으로 재 셋업 해 주세요.
* Q: Npay 사용 시 어떻게 실시간 실적을 전송해야 하나요?
    * A: [Npay 셋업 메뉴얼](https://github.com/linkprice/MerchantSetup/blob/master/CPS/README-Npay.md)
* Q: lpinfo란 무엇인가요?
    * A: 링크프라이스에서 전달한 광고 유입 정보

* Q: 게이트웨이 페이지란 무엇인가요?
    * A: 사용자가 광고 클릭 시 머천트 사이트로 이동 시, 처음으로 거치는 페이지로 유효성 체크, 쿠키 생성, 목적 페이지로 리다이렉션 하는 페이지입니다.

* Q: deep link, target_url란 무엇인가요? 
    * A: 매체사에 광고 주소 생성시에 머천트 홈으로 가지 않고 홍보하려는 특정 상품의 상세 페이지로 배너를 생성 할 수도 있습니다. 이러한 링크를 deep link라고 하며, 이 때의 특정 상품 상세 페이지의 url을 target url 이라고 합니다.
