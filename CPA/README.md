## 1. lpinfo 테이블 생성

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
          unique_id varchar(30),
          member_id varchar(30),
          lpinfo varchar(580),
          user_agent varchar(300),
          ip varchar(50),
          device_type varchar(10)
      )
    ```

3. **회원 가입 완료 후**, 위에서 생성한 테이블에 **링크프라이스 데이터를 반드시 저장해야 합니다**.

4. 링크프라이스를 통해 발생한 실적만 저장 하여 주십시요(lpinfo라는 쿠키가 존재하는 경우에만 위의 테이블에 저장하십시요)



## 2. 게이트웨이 페이지

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



## 3. 실시간 실적 전송

1. 회원 가입 완료 시, 링크프라이스에 아래의 Request 데이터를 json 으로 전송합니다. 
    1. 이 json에는 하나의 회원가입 정보만 있어야 합니다. 
    2. 여러 개의 다른 회원가입 정보 포함 되어서는 안됩니다.
    3. Request URL- ://service.linkprice.com/lppurchase_cpa_v4.php

2. Request
    1. action
        1. unique_id(string): 회원번호
            1. 회원 ID가 아닌 회원에게 부여되는 번호.
            2. unique한 값이여야 합니다.
        2. final_paid_price(number): 사용자가 결제한 실결제 금액
            1. 무료 회원가입 및 무료 서비스일 경우 0으로 보냅니다.
            2. 유료 회원가입 및 유료 서비스 결제시 결제 금액을 전달 합니다.
        3. action_name(string): 서비스 이름
            1. 예) "무료 회원가입", "신청서 작성"
        4. action_code(string): 서비스 코드
        5. currency(string): 상품 결제시 사용된 통화
            1. ISO 4217 사용
            2. 예) USD, KRW, CNY, EUR
        6. member_id: 사용자 ID
        7. category_code: 액션에 해당하는 카테고리 코드
            1. 예) "register", "apply"
    2. linkprice
        1. lpinfo(string): "lpinfo"라는 쿠키에 저장된 값
        2. merchant_id(string): 링크프라이스로부터 받은 머천트 ID
        3. user_agent(string): USER_AGENT정보
        4. remote_addr(string): 사용자의 IP주소. 서버 주소가 아닌 실 사용자의 IP주소를 전송 해 주세요.
        5. device_type(string): 장치 구분 값
            1. web-pc: 모바일이이 아닌 장치에서 발생한 웹 실적
            2. web-mobile: 모바일 장치에서 발생한 웹 실적
            3. app-ios: iOS App을 통해 발생한 실적 
            4. app-android: Android App을 통해 발생한 실적

3. Request Sample

    1. 사용자가 무료 회원 가입을 하였을 경우

    ```json
    {
        "action": {
            "unique_id": "10002356",
            "final_paid_price": 0,
            "currency": "KRW",
            "member_id": "exampleId",
            "action_code": "free_101",
            "action_name": "무료 회원 가입",
            "category_code": "register"
        },
        "linkprice": {
            "merchant_id": "sample",
            "lpinfo": "A123456789|9832|A|m|a8uakljfa",
            "user_agent": "Mozilla/5.0...",
            "remote_addr": "127.0.0.1",
            "device_type": "web-pc"
        }
    }
    ```

    2. 사용자가 10000원짜리 유료 프로그램에 등록 하였을 경우

    ```json
    {
        "action": {
            "unique_id": "10002334",
            "final_paid_price": 10000,
            "currency": "KRW",
            "member_id": "exampleId",
            "action_code": "paid_law1223",
            "action_name": "유료 법률 상담 신청",
            "category_code": "request3002"
        },
        "linkprice": {
            "merchant_id": "sample",
            "lpinfo": "A123456789|9832|A|m|a8uakljfa",
            "user_agent": "Mozilla/5.0...",
            "remote_addr": "127.0.0.1",
            "device_type": "web-pc"
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
        | product_cde   | 상품 코드                             |

    2. Respons Sample

        1. 전송 성공시

        ```json
        [
            {
                "is_success": true,
                "error_message": "",
                "order_code": "order_115",
                "product_code": "product1"
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
            }
        ]
        
        ```

        * CPA 에러 메세지

       | error_message                                              | 에러 상세 내용                           |
       | ---------------------------------------------------------- | ---------------------------------------- |
       | This is not a valid JSON string.                           | REQUEST 가 JSON 형식이 아님              |
       | action.unique_id parameter is empty.                       | action.unique_id 미입력                  |
       | action.final_paid_price parameter is empty.                | action.final_paid_price 미입력           |
       | action.final_paid_price is not integer.                    | action.final_paid_price integer형이 아님 |
       | action.currency parameter is empty.                        | action.currency미입력                    |
       | action.member_id parameter is empty.                       | action.member_id 미입력                  |
       | action.action_name parameter is empty.                     | action.action_name 미입력                |
       | action.category_code parameter is empty.                   | action.category_code 미입력              |
       | linkprice.lpinfo parameter is empty.                       | linkprice.lpinfo 미입력                  |
       | linkprice.lpinfo parameter does not conform to the format. | linkprice.lpinfo이 올바른 형식이 아님    |
       | linkprice.user_agent parameter is empty.                   | linkprice.user_agent 미입력              |
       | linkprice.remote_addr parameter is empty.                  | linkprice.remote_addr 미입력             |
       | linkprice.device_type parameter is empty.                  | linkprice.device_type 미입력             |
       | There was a problem sending your performance.              | 실적 전송 오류                           |

    

## 4. 실적 목록

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

    | 파라미터      | 값                                                           |
    | ------------- | ------------------------------------------------------------ |
    | paid_ymd      | 회원 가입, 상담 신청 완료 조회 날짜. 예) 20181220 <BR />해당날짜에 회원 가입 상담 신청이 완료된 모든 링크프라이스 실적을 보여줍니다. |


    5. 데이터 포맷은 chunked입니다.
         (https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/Transfer-Encoding)

        1. Content-Lengh 헤더는 생략됩니다.
        2. 각 청크 앞부분에 청크의 길이가 16진수 형태로 오게되며 그 뒤에 \r\n이 나옵니다
        3. 종료 청크는 길이가 0이며 그뒤에 \r\n이 나온 후 마지막줄에 \r\n으로 끝납니다.
        4. 응답(chunked) 예제

        ```
        HTTP/1.1 200 OK 
        Content-Type: text/plain 
        Transfer-Encoding: chunked
        
        1a4\r\n
        {"action":{"unique_id":"ord-123-01",....},"linkprice":{...}}\r\n
        1b1\r\n
        {"order":{"unique_id":"ord-123-02",.....},"linkprice":{...}}\r\n
        1ab\r\n
        {"order":{"unique_id":"ord-123-03",.....},"linkprice":{...}}\r\n
        1a9\r\n
        {"order":{"unique_id":"ord-123-04",.....},"linkprice":{...}}\r\n
        0\r\n
        \r\n
        ```

        
