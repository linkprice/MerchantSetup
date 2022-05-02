# CPS 셋업 가이드



## 1. 제휴 마케팅이란?

> 제휴 마케팅이란 제품/ 서비스 등을 판매하는 인터넷 업체(Merchant)가 고객을 끌어들이고 진열, 판매하는 공간으로 자신의 사이트 뿐만 아니라 다른 관련 사이트(Affiliate)로 까지 공간을 확장하여 이때 발생하는 수입을 제휴맺은 사이트(Affiliate)와 공유하는 새로운 형태의 마케팅 기법입니다. 

* [제휴 마케팅 소개](https://helpdesk.linkprice.com/pages/merchant-faq-introduce)




## 2. 게이트웨이 페이지

### 1. 게이트웨이 페이지란?

* 사용자가 배너를 클릭하면, 링크프라이스를 거쳐, 광고주(머천트) 사이트로 리다이렉션 하게됩니다. 

* 광고주(머천트) 사이트로 리다이렉션 하기 전, 처음으로 거치는 광고주(머천트) 페이지를 게이트웨이 페이지라고 합니다.

* 게이트웨이 페이지는 유효성 체크, 쿠키 생성, 목적 페이지로 리다이렉션 등의 작업을 합니다.

![image-20210216180317429](image-20210216180317429.png)

### 2. 게이트웨이 페이지를 생성하는 목적

게이트웨이 페이지 생성에 가장 중요한 목적은 **"LPINFO" 쿠키를 생성**하는 것입니다.



### 3. 작업내용 

1. 게이트웨이 페이지를 생성 한 후, **링크프라이스에서 전달받은 자바스크립트(javascript)를 추가**해주세요.
2. 예를 들어  https://www.yourdomain.com/linkprice/gateway 처럼, 게이트웨이 페이지를 생성해 주시고 링크프라이스에서 제공하는 자바스크립트를 추가해주세요.
3. 게이트웨이 페이지 생성은 사용하시는 서버 환경에 따라 달라질 수 있습니다.
4. **게이트웨이 페이지는 아무나 접근 가능한 웹페이지이며 https로 접속 가능해야 합니다**.

   <u>https가 불가한 경우 링크프라이스에 연락주세요.</u>

5. 생성한 **게이트웨이 페이지에 URL을 링크프라이스 담당자에게 알려주세요.**
6. 링크프라이스 내부에 적용 후 LPINFO 쿠키를 확인할 수 있는 Click URL을 생성해서 전달드립니다.

> **[Sample Code]**
>
>  샘플코드로 실제코드와는 다릅니다. 반드시 링크프라이스에서 제공하는 자바스크립트를 게이트웨이 페이지에 추가해주세요.
>
>```javascript
><!-- Google Tag Manager -->
>     <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
>      new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
>      j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
>      'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
>    })(window,document,'script','dataLayer','GTM-P3HTV4');</script>
><!-- End Google Tag Manager -->
>```
>



### 4. FAQ


> **Q: 게이트웨이 페이지란 무엇인가요?**
>
> * A: 사용자가 광고 클릭 후 광고주(머천트) 사이트로 이동 시, 처음으로 거치는 페이지로 유효성 체크, 쿠키 생성, 목적 페이지로 리다이렉션하는 페이지입니다.
>
> **Q: LPINFO란 무엇인가요?**
>
> * A: LPINFO(쿠키)는 매체사의 실적 추적을 위해 사용되는 값으로, 링크프라이스에서 전달한 광고 유입 정보입니다. 
>
> **Q: 스크립트는 어디서 제공받을 수 있나요?**
>
>   * A: 링크프라이스 담당자에게 문의하시면 전달 드립니다. 



## 3. LPINFO 테이블 생성

### 1. 작업내용 

1. 링크프라이스는 실적 추적을 위하여 다음의 데이터가(이하 **링크프라이스 데이터**) 반드시 필요합니다.

    * lpinfo: "LPINFO"라는 쿠키에 저장된 값

    * user_agent: USER_AGENT정보

    * ip: 사용자의 IP주소

    * device_type: 장치 구분 값
      * web-pc: 모바일이 아닌 장치에서 발생한 웹 실적

      * web-mobile: 모바일 장치에서 발생한 웹 실적

      * app-android: Android App을 통해 발생한 실적

      * app-ios: iOS App을 통해 발생한 실적 

2. **링크프라이스 데이터**를 저장 할 테이블을 아래처럼 생성합니다.

  ```mysql
    create table lpinfo(
    	id int not null,
        order_id varchar(30),
        product_id varchar(30),
        lpinfo varchar(580),
        user_agent varchar(300),
        ip varchar(50),
        device_type varchar(11)
    )
  ```

3. **주문완료된 링크프라이스 실적 데이터**를 **반드시 저장해야 합니다**.

4. 테이블에는 링크프라이스를 통해 발생한 실적만 저장해주세요.(LPINFO라는 쿠키가 존재하는 경우에만 테이블에 저장)

5. LPINFO 테이블에 저장된 주문은 **5.실적목록** 작업에 사용해주시면 됩니다. 

   

###  2.  FAQ

> **Q: 데이터를 LPINFO테이블에 저장하는 이유가 궁금합니다.**
>
> * A: 대부분의 경우, 링크프라이스에 전송된 데이터와 광고주(머천트)의 데이터가 100% 일치하지 않습니다. 
>
>    ​	누락 실적이 발생하거나,  문의가 있는 실적을 링크프라이스에 전송된 데이터와 광고주(머천트)에 저장된 데이터를 
>
>    ​    대조하기 위해 저장을 요청 드립니다. 테이블에 저장된 데이터는 실적목록 데이터 출력에 사용해주시면 됩니다. 
>    



## 4. 실시간 실적 전송

### 1. 작업내용 

1. 사용자가 주문완료시, 링크프라이스에 아래의 Request 데이터를 **json** 으로 전송합니다. 

    * **Request URL- http(s):://service.linkprice.com/lppurchase_cps_v4.php **

2. 이 json에는 하나의 주문(order)만 있어야 합니다. (여러 개의 다른 주문(order)이 포함 되어서는 안됩니다.)

3. 하나의 주문(order)에 여러 가지의 상품을 샀다면, **하나의 json에 여러개의 상품이 모두 포함**되어야 합니다.

    > 링크프라이스 이외의 CPS 광고 네트워크와 동시에 운영하는 경우, 마지막 클릭한 네트워크의 실적만 전송해야 합니다. 
    >
    > 이와 다르게 셋업 해야하는 경우 링크프라이스 담당자에게 연락하여 협의해주세요.



### 2. FAQ

> **Q: 전송해야 하는 실결제 금액이란 무엇인가요??**
>
> * A: 배송비를 제외하고 판매가에서 할인가를 적용한 최종 금액
> * 판매 촉진을 위해 제공한 할인 쿠폰, 할인 코드는 할인가로 포함되어 실결제 금액에서 차감되도록 적용됩니다.
> * 마일리지, 자사/타사 적립금 등 현금성 캐시는 할인가에 차감되도록 적용이 되어선 안됩니다.
>
> **Q: Npay 결제가 가능합니다. 어떻게 실시간 실적을 전송해야 하나요?**
>
> * A: 네이버페이 주문형: [셋업 가이드](https://github.com/linkprice/MerchantSetup/blob/master/CPS/README-Npay.md)
> * A: 네이버페이 결제형: [셋업 가이드](https://github.com/linkprice/MerchantSetup/blob/master/CPS/README-Npay2.md)
>
> **Q: 무통장입금(가상계좌) 결제가 가능합니다. 실적은 언제 전송해야 하나요?**
>
> * A: 주문완료와 동시에 실적을 전송해주시면 됩니다. 만약, 미입금 상태로 주문이 취소된 경우 실적목록에 취소데이터를 보여주시면 실적 취소됩니다. 
>
> **Q: 실시간 실적 전송을 한 뒤 추후에 취소 또는 환불 처리된 경우 실적 취소 처리를 어떻게 진행하나요?**
>
>   * A: 실적 취소처리는 실적목록을 통해 진행됩니다. 취소 또는 환불된 실적은 실적목록에 취소데이터를 보여주세요.  
>
>     실적 취소는 실적이 발생한 익월 20일에 진행되며, 이후에 변경된 상태는 반영이 불가능합니다.  

​    

### 3. Request 

1. order
    1. order_id(string): 구매자가 인지 가능한 주문번호로, 매체의 누락문의시 이 주문번호로 누락 여부를 조회할 수 있습니다.
    2. final_paid_price(float):  배송비를 제외 한 구매자의 실결제 금액
       * 배송비를 구매자가 부담시 실결제금액에서 배송비를 제외한 금액입니다.
       * 무료배송인 경우엔 실결제 금액 전체입니다.
    3. user_name(string): 누락문의시 누구의 실적인지를 알기 위해 사용 할 구매자 이름, 가급적 마스킹 처리해 주세요. 예) 김**, 이**
    4. currency(string): 상품 결제시 사용된 통화
       * ISO 4217 사용
       * 예) USD, KRW, CNY, EUR
    
2. products
   1. product_id(string): 상품 ID
   2. product_name(string): 상품 이름
   3. category_code(string): 상품 카테고리 코드
   4. category_name(string): 상품 카테고리 이름
      * 해당 상품의 모든 카테고리 이름을 넣어주세요.
      * 의류 > 남성의류 > 자켓 > 아우터 일 경우 아래와 같이 작성하여 주세요.
       ```json
          "category_name": ["의류", "남성의류", "자켓", "아우터"]
       ```
    5. quantity(unsigned int): 구매 갯수
    6. product_final_price(float): 구매자가 이 상품을 구매하기 위하여 결제해야 할 금액
    7. paid_at(string): 주문 완료 시간
       * 주문 완료 시간이란 결제가 성공한 시간을 뜻합니다.

       * Date Format : ISO-8601 (데이터 포맷은 예시와 동일해야합니다.)

         > 예시)  대한민국(UTC+09:00 시간대)에서 2021년 01월 10일 오후 3시 44분 52초에 완료된 주문
         >
         > **paid_at : “2021-01-10T15:44:52+09:00”** 
         >
         > 예시) 중국(UTC+08:00 시간대)에서 2021년 01월 12일 오전 08시 32분 11초에 완료된 주문
         >
         > **paid_at : “2021-01-12T08:32:11+08:00”** 
         >
         > 예시) 미국(UTC-05:00 시간대)에서 2021년 01월 13일 오후 1시 11분 21초에 완료된 주문
         >
         > **paid_at : “2021-01-13T13:11:21-05:00”** 
    8. confirmed_at(string): 구매 확정 시간
       * 구매 확정 시간이란 상품이 배송되어 쇼핑몰에서 지정한 환불/취소 기간이 지나 더 이상 환불/취소가 불가능한 상태가 된 시간을 뜻합니다.

       * 구매 확정 되지 않았다면 공백 문자열을 전송해주세요.

       * Date Format : ISO-8601 (데이터 포맷은 예시와 동일해야합니다.)

         > 예시)  대한민국(UTC+09:00 시간대)에서 2021년 01월 15일 오후 3시 44분 52초에 구매 확정된 주문
         >
         > **confirmed_at : “2021-01-15T15:44:52+09:00”** 
         >
         > 예시) 중국(UTC+08:00 시간대)에서 2021년 01월 17일 오전 08시 32분 11초에 구매 확정된 주문
         >
         > **confirmed_at : “2021-01-17T08:32:11+08:00”** 
         >
         > 예시) 미국(UTC-05:00 시간대)에서 2021년 01월 18일 오후 1시 11분 21초에 구매 확정된 주문
         >
         > **confirmed_at: “2021-01-18T13:11:21-05:00”** 
    9. canceled_at(string): 구매 취소 시간
       * 구매 취소 시간이란 구매자의 요청으로 환불, 취소, 반품 등 처리가 완료된 시간을 뜻합니다.
       
       * 구매 취소 되지 않았다면 공백 문자열을 전송해주세요.
       
       * Date Format : ISO-8601 (데이터 포맷은 예시와 동일해야합니다.)
       
         > 예시)  대한민국(UTC+09:00 시간대)에서 2021년 01월 20일 오전07시 11분 13초에 구매 취소된 주문
         >
         > **canceled_at : “2021-01-15T07:11:13+09:00”** 
         >
         > 예시) 중국(UTC+08:00 시간대)에서 2021년 01월 22일 오후 05시 21분 09초에 구매 취소된 주문
         >
         > **canceled_at : “2021-01-22T17:21:09+08:00”** 
         >
         > 예시) 미국(UTC-05:00 시간대)에서 2021년 01월 25일 오전 03시 20분 21초에 구매 취소된 주문
         >
         > **canceled_at: “2021-01-25T03:20:21-05:00”** 

3. linkprice
    1. lpinfo(string): "LPINFO"라는 쿠키에 저장된 값
    2. merchant_id(string): 링크프라이스로부터 받은 광고주(머천트) ID
    3. user_agent(string): USER_AGENT정보
    4. remote_addr(string): 구매자의 IP주소, 가급적 마스킹 처리해 주세요. 예) 118.221.\*.\*
    5. <a name="device_type"></a>device_type(string): 장치 구분 값
       
        * web-pc: 모바일이이 아닌 장치에서 발생한 웹 실적
        
        * web-mobile: 모바일 장치에서 발생한 웹 실적
        
        * app-ios: iOS App을 통해 발생한 실적 
        
        * app-android: Android App을 통해 발생한 실적
          
          


### 3. Request Sample

* **실시간 실적 전송에 대한 보다 자세한 예시는 [실시간 실적 전송 예시](./Example.md)에서 확인 가능합니다.**

  **예시) 구매자가  7000원짜리 HDMI 케이블2개, 6000원짜리 봉지라면 3개를 구매하였고, 최종적으로 할인쿠폰 3000원을 사용했다. (무료배송)**

	* 할인쿠폰 적용전에 결제해야 할 금액은 32000원입니다. 3000원 할인쿠폰으로 사용하였으므로 최종적으로 구매자가 지불해야 할 금액은 **29000**원입니다

	* 할인 적용전 hdmi 케이블의 product_final_price은 14000원 이었는데 3000원 할인 쿠폰를 사용하였으므로 14000 - 3000 * 14000 / 32000 = **12687.5**원 입니다.

	* 할인 적용전 봉지라면의 product_final_price은 18000원 이었는데 3000원 할인 쿠폰를 사용하였으므로 18000 - 3000 * 18000 / 32000 = **16312.5**원 입니다.

	* 각 상품의 product_final_price의 합은 final_paid_price와 같아야 하나, 부득이한 경우 원단위 차이는 허용됩니다. 12687.5(product_final_price) + 16312.5(product_final_price) = 29000(final_paid_price) 

```json
{
    "order": {
        "order_id": "o190203-h78X3",
        "final_paid_price": 29000,
        "currency": "KRW",
        "user_name": "김**"
    },
    "products": [
        {
            "product_id": "P87-234-anx87",
            "product_name": "UHD 4K 넥시 HDMI케이블",
            "category_code": "132782",
            "category_name": ["컴퓨터 주변기기", "케이블", "HDMI케이블"],
            "quantity": 2,
            "product_final_price": 12687,
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
            "product_final_price": 16312,
             "paid_at": "2019-02-12T11:13:44+09:00",
         	"confirmed_at": "",
             "canceled_at": ""
     }
    ],
    "linkprice": {
        "merchant_id": "sample",
        "lpinfo": "A123456789|9832|A|m|a8uakljfa",
     	"user_agent": "Mozilla/5.0...",
        "remote_addr": "118.221.*.*",
        "device_type": "web-pc"
    }
}
```

   

### 4. Response

   1. 응답 바디는 JSON객체입니다.

       | KEY           | VALUE                                |
       | ------------- | ------------------------------------ |
       | is_success    | true / false<br/>실적 전송 성공 여부 |
       | error_message | 에러 메세지                          |
       | order_code    | 주문 코드                            |
       | product_code  | 상품 코드                            |

       

### 5. Respons Sample
* 전송 성공
  ```json
       [
           {
               "is_success": true,
               "error_message": "",
               "order_code": "o190203-h78X3",
               "product_code": "P87-234-anx87"
           },
           {
               "is_success": true,
               "error_message": "",
               "order_code": "o190203-h78X3",
               "product_code": "P23-983-Z3272"
           }
       ]
  ```
  
* 전송 실패
   ```json
       [
           {
               "is_success": false,
               "error_message": "lpinfo parameter is empty.",
               "order_code": "o190203-h78X3",
               "product_code": "P87-234-anx87"
           },
           {
               "is_success": false,
               "error_message": "lpinfo parameter is empty.",
               "order_code": "o190203-h78X3",
               "product_code": "P23-983-Z3272"
           }
       ]
       
   ```

* error_message
   목록에 없는 메세지가 확인되는 경우, 링크프라이스 담당자에게 **호출한 Request 와 Respons**를 전달해주시면 확인해드리겠습니다. 
	
	| error_message                                                | 에러 상세 내용                                               |
	| ------------------------------------------------------------ | ------------------------------------------------------------ |
	| This is not a valid JSON string.                             | REQUEST 가 JSON 형식이 아님                                  |
	| order.order_id parameter is empty.                           | action.unique_id 미입력                                      |
	| order.final_paid_price parameter is empty.                   | action.final_paid_price 미입력                               |
	| order.final_paid_price is not integer.                       | action.final_paid_price integer형이 아님                     |
	| order.currency parameter is empty.                           | action.currency미입력                                        |
	| order.user_name parameter is empty.                          | action.member_id 미입력                                      |
	| products parameter is empty.                                 | action.action_name 미입력                                    |
	| linkprice.lpinfo parameter is empty.                         | action.category_code 미입력                                  |
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





## 5. 실적목록

### 1. 실적목록이란?

* 정확하고 빠른 정산을 위하여 링크프라이스 실적 데이터를 제공하는 API입니다.

* 실적목록을 통해 광고주(머천트) 주문 정보와 링크프라이스의 실적을 대조하여 누락된 실적을 복구합니다.

* 실적이 발생한 익월 20일에 주문 취소 또는 환불된 실적에 대한 실적 취소처리를 진행합니다. 

  


### 2. 작업내용

* **실적목록 API는 광고주(머천트)가 직접 작성**해 주셔야 합니다.
1. 예를 들어  https://api.yourdomain.com/linkprice/order_list_v1처럼, 실적목록 페이지를 생성해 주시고 **paid_ymd, confirmed_ymd, canceled_ymd**세가지 파라미터를 사용하여 조회 할 수 있어야 합니다. 
   * 링크프라이스에서는 아래와 같이 광고주(머천트) API를 호출하여 실적목록을 확인하게 됩니다.

	```shell
	curl 
	https://api.yourdomain.com/linkprice/order_list_v1?paid_ymd=yyyymmdd
	https://api.yourdomain.com/linkprice/order_list_v1?confirmed_ymd=yyyymmdd
	https://api.yourdomain.com/linkprice/order_list_v1?canceled_ymd=yyyymmdd
	```
	
	* 파라미터 설명

	| 파라미터      | 값                                                           |
	| ------------- | ------------------------------------------------------------ |
	| paid_ymd      | 주문 완료 조회 날짜. 예) 20181220 <BR />해당날짜에 주문 완료된 모든 링크프라이스 실적을 보여줍니다. |
	| confirmed_ymd | 구매 확정 조회 날짜. 예) 20181220 <BR />해당날짜에 구매 확정된 모든 링크프라이스 실적을 보여줍니다. |
	| canceled_ymd  | 구매 취소 조회 날짜. 예) 20181220 <BR />해당날짜에 구매 취소된 모든 링크프라이스 실적을 보여줍니다. |

2. 실시간 실적 전송된 데이터와 실적목록 API에서 확인되는 데이터는 모두 동일해야 합니다.

3. 실적목록은 json 형식으로 출력 되어야 합니다. 

4. **작성한 실적목록 페이지를 링크프라이스 담당자에게 알려주세요. **



### 3. 실적목록 출력 Sample

```json
[
    {
    "order": {
        "order_id": "o190203-h78X3",
        "final_paid_price": 29000,
        "currency": "KRW",
        "user_name": "구**"
    },
    "products": [
        {
            "product_id": "P87-234-anx87",
            "product_name": "UHD 4K 넥시 HDMI케이블",
            "category_code": "132782",
            "category_name": ["컴퓨터 주변기기", "케이블", "HDMI케이블"],
            "quantity": 2,
            "product_final_price": 12687,
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
            "product_final_price": 16312,
            "paid_at": "2019-02-12T11:13:44+09:00",
            "confirmed_at": "",
            "canceled_at": ""
        }
    ],
    "linkprice": {
        "merchant_id": "sample",
        "lpinfo": "A123456789|9832|A|m|a8uakljfa",
        "user_agent": "Mozilla/5.0...",
        "remote_addr": "13.156.*.*",
        "device_type": "web-pc"
    }
},
    {"order":{"order_id":"ord-123-01",...},"products":[...],"linkprice":{...}},
    {"order":{"order_id":"ord-123-03",...},"products":[...],"linkprice":{...}},
    {"order":{"order_id":"ord-123-04",...},"products":[...],"linkprice":{...}}
]
```



## 6. 기타 FAQ

>**Q: 이미 CPS 셋업이 되어 있는 경우에는 어떻게 하나요?**
>
>* A: 이미 CPS 셋업이 되어 있다면, 구 버전으로 셋업이 되어 있을 확률이 높습니다. 데이터 처리 방식이나 내용이 많이 바뀌었으므로, 현재 버전으로 재셋업 해 주세요.
>
> **Q: deep link, target_url란 무엇인가요? **
>
>* A: 매체사에 광고 주소 생성시에 광고주(머천트) 홈으로 가지 않고 홍보하려는 특정 상품의 상세 페이지로 배너를 생성 할 수도 있습니다. 이러한 링크를 deep link라고 하며, 이 때의 특정 상품 상세 페이지의 url을 target url 이라고 합니다.

