##  메뉴얼에 대해

* 해당 메뉴얼은 2018년 01월 07일에 작성된 문서입니다.

* 최신화된 문서는 아래 URL 링크를 통해서 일람하실 수 있습니다.

  https://github.com/linkprice/MerchantSetup/tree/master/CPS%20-%20Promo%20code 



##                                                                                                                               할인코드 CPS 란?

* 할인 코드를 이용해 매체가 홍보를 진행하여, 구매자가 해당 할인 코드를 사용해  

  구매나 예약 등의 실적이 발생되면 할인과 동시에 링크프라이스 측에 실적을 전송하는 것을 의미합니다.

  ![캡처1](image2.png)

* 간략한 흐름도는 다음과 같습니다.

![캡처2](image1.png)





﻿## 할인코드 셋업 요약

* 광고주 측과 링크프라이스끼리 주고 받는 통신들은  Server to Server 방식이 권장됩니다.
* 해당 셋업은 총 3가지 파트로 구분되어 작업이 요구됩니다.



### 1. 실시간 실적 전송

* 할인코드를 사용하여 광고주 측 웹사이트에서 구매와 동시에 링크프라이스로 실적 전송을 해주는 작업입니다.

* 이러한 작업들을 저희 측에서는 통칭 "실시간 실적 전송" 이라고 합니다.



### 2. 실적 정보 출력 (Daily_fix)

 * 광고주의 주문 정보와 링크프라이스 실적을 대조하여 실시간 실적 전송 중 누락된 실적을 복구하기 위한 작업

 * 이러한 작업들을 저희 측에서는 통칭 "Daily Fix" 라고 합니다.

 * 기존에 "일반 CPS용 Daily Fix" 를 작업했던 광고주라도 할인코드 셋업을 위해선

    "할인코드용 Daily Fix" 작업이 필요합니다.



### 3. 자동 실적 취소(auto_cancel)
- 일반 CPS 프로그램에서 자동 실적 취소를 사용하고 있는 광고주는 

  사용 중인 자동 실적 취소 URL 호출 시 할인코드 CPS 실적의 주문 상태 값도 일반 CPS와 동일하게 출력되도록 작업해주시면 됩니다. 

  (확인이 어려우시면 링크프라이스 담당자님께 문의하시면 됩니다.)



<u>**연동 작업을 모두 완료하시면 테스트를 위해 작업하신 URL을 링크프라이스 담당자에게 전달 주시면 됩니다.**</u> 





## 1. 실시간 실적 전송

### 1) 실시간 주문 정보 저장

* 링크프라이스 전용 **할인코드**를 사용하여 구매한 경우 Daily_Fix를 위하여 주문 데이터를 저장해야 합니다.
* 주문 테이블에 아래의 필드를 저장하시길 추천드립니다.
* 필수값 전송이 어려운 경우 링크프라이스 담당자에게 연락바랍니다.

|    필드명    | 타입(Byte)  | 필수유무 |                          설명                          |
| :----------: | :---------: | :------: | :----------------------------------------------------: |
|  event_code  | string(20)  |   필수   |      링크프라이스에서 발급한 고유 이벤트 코드<sup id="sub1">[1](#link1)</sup>      |
|  promo_code  | string(50)  |   필수   |             매체에서 홍보하는 할인코드<sup id="sub2">[2](#link2)</sup>             |
|  member_id   | string(10)  |   필수   |         구매자<br>  Ex) 구매자ID, 구매자 이름          |
|  order_code  | string(100) |   필수   |                 해당 주문건의 주문번호                 |
| product_code | string(100) |   필수   |               해당 주문건의 상품고유번호               |
| product_name | string(300) |   필수   |                  해당 주문건의 상품명                  |
|  item_count  |   Integer   |   필수   |                     상품 구매 수량                     |
|    sales     |   Integer   |   필수   |                 금액 (단가*구매수량 )                  |
|  user_agent  | String(200) |   필수   |               구매자의 User Agent 값<sup id="sub3">[3](#link3)</sup>               |
| remote_addr  | String(20)  |   필수   |                   구매자의 REMOTE IP                   |
| device_type  | String(10)  |   옵션   | 실적이 발생한 디바이스 타입<br>Ex) PC, MOBILE, APP<sup id="sub4">[4](#link4)</sup> |

<b name="link1">[1]</b>: 이벤트 코드(event_code) - 링크프라이스와 광고주가 협의 하여 생성하는 고유코드 이며, 고정값 입니다.  <br>Ex) merchant_promocode,   merchant_sale [↩](#sub1)<br>
<b name="link2">[2]</b>: 할인 코드(promo_code) - 실제 구매자가 사용하는 할인코드로, 광고주가 발급후 링크프라이스에 전달해야 하는 코드 입니다.   Ex) LPpromo_code01, LPpromo_code02, LPpromo_code03, LPpromo_code04, LPpromo_code05 [↩](#sub2)<br>
<b name="link3">[3]</b>: User Agent 예시 : Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36" [↩](#sub3)<br>
<b name="link4">[4]</b>: PC웹 실적 - "PC"   /   모바일 웹 실적 - "MOBILE"    /   모바일 앱 실적 - "APP" [↩](#sub3)<br>



### 2) 실적 전송 셋업 작업

* 실적 전송은 구매가 완료됨과 동시에 전송해 주시면 됩니다. 

* **구매 완료**시 실적을 전송하기 위해 실적전송 코드를 삽입해야 합니다. (샘플 코드 참조)

* 샘플 코드는 각 광고주의 개발 환경에 맞게 수정하시기 바랍니다. 

* 모든 실적은 Server to Server 방식으로 전송됩니다. 

  **스크립트 및 이미지 방식**<sup id="sub5">[5](#link5)</sup>으로 전달 시 링크프라이스 담당자에게 별도 문의 바랍니다.

<b name="link5">[5]</b>: 스크립트 방식은 〈script src='lppurchase.php'〉〈/script〉 이런 형식으로 전송하는 방식을 의미하며<br> 이미지 or 픽셀 방식은 〈img src='lppurchase.php'/〉 이런 형식으로 전송하는 방식을 의미합니다. [↩](#sub5)<br>



### 3) 작업시 유의사항

* 실적 정보는 **JSON 형식**으로 전송해 주시기 바랍니다.

* 결제 시, 복수 상품 및 단일 상품 모두 **2차원 배열**<sup id="sub6">[6](#link6)</sup>로 전송해주시기 바랍니다.

* 디바이스구분값(device_type)은 옵션값이나, 원활한 실적 확인을 위하여 전송 하시길 추천드립니다. <sup id="sub4">[4](#link4)</sup>

* KEY 이름은 **수정 불가하며**, VALUE 값은 아래 예제를 참고 하시어 입력해 주시기 바랍니다.

* 할인코드의 유효성 체크 이후 실적 전송이 되도록 주의 바랍니다.

<b name="link6">[6]</b>: 단수주문건 JSON : [{data1}],  복수주문건 JSON : [{data1}, {data2}] [↩](#sub6)<br>



* **광고주 → 링크프라이스 실적 전송 예제1. (단일주문건)**

  ```javascript
  [
    {
  	    event_code : "LINKPRICE_EVENT_CODE",                          
          promo_code : "PROMO_CODE01",                     
  	    member_id : "member_id",	
  	    order_code : "ORDER123456789",
  	    product_code : "00000001",                     
  	    product_name : "사과",                 
  	    item_count : 1,                      
  	    sales : 1000,                              
  	    user_agent : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",                          
  	    remote_addr:  "211.211.211.211",                            
  	    device_type: "PC"                             
    }
  ]
  ```

* **광고주 → 링크프라이스 실적 전송 예제2. (복수주문건)**

  ```json
  [
    {
  	    event_code : "LINKPRICE_EVENT_CODE",                          
          promo_code : "PROMO_CODE01",                     
  	    member_id : "member_id",	
  	    order_code : "ORDER123456789",
  	    product_code : "00000001",                     
  	    product_name : "사과",                 
  	    item_count : 1,                      
  	    sales : 1000,                              
  	    user_agent : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",                          
  	    remote_addr:  "211.211.211.211",                            
  	    device_type: "PC"                             
    },
    {
  	    event_code : "LINKPRICE_EVENT_CODE",                          
          promo_code : "PROMO_CODE01",                     
  	    member_id : "member_id",	
  	    order_code : "ORDER123456789",              
  	    product_code : "00000002",                     
  	    product_name : "딸기",                      
  	    item_count : 2,                         
  	    sales : 4000,                           
  	    user_agent : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",                         
  	    remote_addr:  "211.211.211.211",                            
  	    device_type: "PC"                         
    },
  ]
  ```



### 4) 실적 전송 응답 코드

* **링크프라이스 →  광고주 응답 (정상일 경우)**

  ```json
  [
      {
          "is_success": true,
          "error_message": "",
          "order_code": "주문번호",
          "product_code": "상품코드"
      }
  ]
  ```

* **링크프라이스 → 광고주 응답  (실패할 경우)**

  실적 전송이 정상적으로 이루어지지 않은 경우 하기 에러 메세지를 참고하시어 수정해주시면 됩니다. 

  ```json
  [
      {
          "is_success": false,
          "error_message": "에러 상세 내용",
          "order_code": "주문번호",
          "product_code": "상품코드"
      }
  ]
  ```
* 에러 메세지

|                 error_message                  |                        에러 상세 내용                        |
| :--------------------------------------------: | :----------------------------------------------------------: |
|         event_code parameter is empty.         |                event_code(이벤트코드) 미입력                 |
|         promo_code parameter is empty.         |                 promo_code(할인코드) 미입력                  |
|         order_code parameter is empty.         |                 order_code(주문번호) 미입력                  |
|        product_code parameter is empty.        |                product_code(상품코드) 미입력                 |
|         user_agent parameter is empty.         |           user_agent(브라우저 사용자 정보) 미입력            |
|        remote_addr parameter is empty.         |              remote_addr (클라이언트 IP) 미입력              |
|         item_count parameter is empty.         |                 item_count(상품수량) 미입력                  |
|           sales parameter is empty.            |                    sales(상품금액) 미입력                    |
|        product_name parameter is empty.        |                 product_name(상품명) 미입력                  |
|               event is nothing.                |   이벤트가 존재하지 않음.<br>링크프라이스 담당자에게 문의    |
| The order_code of each array must be the same. | 복수의 건일 경우 주문번호가 서로 불일치<br/>링크프라이스 담당자에게 문의 |
|           Order code is duplicated.            | 예전에 링크프라이스로 인입된 주문번호가 재호출<br/>링크프라이스 담당자에게 문의 |
|        Required parameters are missing.        | 필수파라미터가 누락되어 실적 미인정 상태<br/>링크프라이스 담당자에게 문의 |
| Network error during performance transmission. | 네트워크 장애로 실적 미인정 상태<br/>링크프라이스 담당자에게 문의 |



### 5) 실적 전송 샘플 코드

   * [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/PHP/index.php)

   * [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/JSP/index.jsp)

   * [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/ASP/index.asp)





## 2. 실적 정보 출력 (daily_fix)

### 1) 실적 정보 출력 셋업 작업

* 광고주의 실적 정보 출력 URL을 **링크프라이스에서 일별 호출**하여 자동으로 복구합니다.

  이때, 주문번호(order_code)와 상품코드(product_code)를 기준으로 실적의 복구 유무를 판단합니다.

* 광고주에 저장된 주문 정보 중 링크프라이스를 통해서 발생한 실적을  **JSON형식**으로 출력해주셔야 합니다.

* 아래 예시와 같이 호출하면 해당 날짜의 실적 정보가 출력될 수 있도록 합니다. **(yyyymmdd 파라미터로 호출)**

  링크프라이스는 URL Query String으로 실적 호출합니다. 

  호출 URL 예시 - www.example.com/linkprice/promo_code/daily_fix.php?yyyymmdd=20170701 



### 2) 작업시 유의사항

* 샘플 코드는 머천트 개발 환경에 맞게 수정하시기 바랍니다. 

* **KEY 이름은 임의로 수정 불가**하며, VALUE 값은 아래 예제를 참고하여 출력바랍니다.

* 실적 전송된 데이터와 실적 정보 출력에서 확인되는 VALUE 값은 모두 동일해야 합니다.



|  출력필드명  | 출력타입(Byte) | 필수유무 |                          설명                          |
| :----------: | :---------: | :------: | :----------------------------------------------------: |
|  event_code  | string(20)  |   필수   |      링크프라이스에서 발급한 고유 이벤트 코드<sup id="sub1">[1](#link1)</sup>      |
|  promo_code  | string(50)  |   필수   |             매체에서 홍보하는 할인코드<sup id="sub2">[2](#link2)</sup>             |
|  order_time   | string(10)  |   필수   |         실적의 시,분,초<sup id="sub7">[7](#link7)</sup>         |
|  member_id   | string(10)  |   필수   | 구매자<br/>  Ex) 구매자ID, 구매자 이름 |
|  order_code  | string(100) |   필수   |                 해당 주문건의 주문번호                 |
| product_code | string(100) |   필수   |               해당 주문건의 상품고유번호               |
| product_name | string(300) |   필수   |                  해당 주문건의 상품명                  |
|  item_count  |   Integer   |   필수   |                     상품 구매 수량                     |
|    sales     |   Integer   |   필수   |                 금액 (단가*구매수량 )                  |
|  user_agent  | String(200) |   필수   |               구매자의 User Agent 값<sup id="sub3">[3](#link3)</sup>               |
| remote_addr  | String(20)  |   필수   |                   구매자의 REMOTE IP                   |
| device_type  | String(10)  |   옵션   | 실적이 발생한 디바이스 타입<br>Ex) PC, MOBILE, APP<sup id="sub4">[4](#link4)</sup> |

<b name="link7">[7]</b>: **hhmmss 형식**으로 실적 발생 시간만 출력되도록 작업. ex) 2018년 01월 01일 오후 01시 20분 13초 → “132013”

* **실적 정보 출력 예제 1. (단일주문건)**

  ```javascript
  [
    {
          event_code : "LINKPRICE_EVENT_CODE",                          
          promo_code : "PROMO_CODE01",    
          order_time : "170524"
          member_id : "member_id",	
          order_code : "ORDER123456789",
          product_code : "00000001",                     
          product_name : "사과",                 
          item_count : 1,                      
          sales : 1000,                              
          user_agent : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",                          
          remote_addr:  "211.211.211.211",                            
          device_type: "PC"                             
      }
  ]
  ```



* **실적 정보 출력 예제 2. (복수주문건)**

  ```json
  [
      {
          event_code : "LINKPRICE_EVENT_CODE",                          
          promo_code : "PROMO_CODE01",    
          order_time : "170524"
          member_id : "member_id",	
          order_code : "ORDER123456789",
          product_code : "00000001",                     
          product_name : "사과",                 
          item_count : 1,                      
          sales : 1000,                              
          user_agent : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",                          
          remote_addr:  "211.211.211.211",                            
          device_type: "PC"                             
      },
      {
          event_code : "LINKPRICE_EVENT_CODE",                          
          promo_code : "PROMO_CODE01",
          order_time : "170524"
          member_id : "member_id",	
          order_code : "ORDER123456789",              
          product_code : "00000002",                     
          product_name : "딸기",                      
          item_count : 2,                         
          sales : 4000,                           
          user_agent : "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36",                         
          remote_addr:  "211.211.211.211",                            
          device_type: "PC"                         
      }
  ]
  ```




### 3) 실적 정보 출력 샘플 코드

* [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/PHP/daily_fix.php)
* [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/JSP/daily_fix.jsp)
* [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/ASP/daily_fix.asp)


