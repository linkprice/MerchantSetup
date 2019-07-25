## 1. 할인코드 CPS 란?

- Affiliate use promotion code that provide from Linkprice to advertise and when customer uses promotion code to buy production, sales data will be send to Linkprice.

#### **※ Precautions**

1. Multiple promotion code cannot be used in the same order.
2. When promotion code is used by customer, sales data should be sent for promotion code sales data.
   (CPS sales should not be sent)



## 2. "lpinfo" table

1. The data below is required to track linkprice's sales data.
   1. event_code (string): Unique code that Linkprice provide
   2. promo_code(string) : Promotion code that user uses and please let Linkprice know list of promotion code.
   3. user_agent: USER_AGENT information
   4. ip: IP address of User
   5. device_type
      1. web-pc: All sales data through web but mobile
      2. web-mobile: Web sales data with mobile
      3. app-android: Sales data with Android app
      4. app-ios: Sales data with iOS app
2. Modify "lpinfo" table that store linprice's sales data. If there is no "lpinfo" table, please ask linkprice.

```mysql
alter table lpinfo add event_code varchar(20);
alter table lpinfo add promo_code varchar(50);
```

3. After user finished payment, **you should store only linkprice's data in "Lpinfo" table.**
4. In this table, you should store only linkpirce's data(When there is "lpinfo" cookie, linkprice's data should be stored)



## 3. 실시간 실적 전송

1. After user finish payment, send Request data below in json type

   1. There should be one order information in json data. 
   2. It cannot include multi orders.
   3. If there are multi products in one order, it should be in same json data.
   4. Request URL- ://service.linkprice.com/lppurchase_cps_v4.php

2. Request

   1. order

      1. order_id(string): Order ID. 
      2. final_paid_price(float): Amount that user pay
         1. If user pay delivery fee, final_paid_price should not include delivery fee.
         2. If delivery fee in free for user, final_paid_price is the same with How much user paid.
      3. user_name(string): User name. 
      4. currency(string): Currency
         1. ISO 4217
         2. EX) USD, KRW, CNY, EUR

   2. products

      1. product_id(string): Product ID

      2. product_name(string): Product Name

      3. category_code(string): Category Code

      4. category_name(string): Category Name

         1. Put all category names
         2. EX) Clothe > Men > Jacket > Rider jacket 일 경우 아래와 같이 작성하여 주세요.

         ```json
         "category_name": ["Clothe", "Men", "Jacket", "Rider Jacket"]
         ```

      5. quantity(unsigned int): Quantity

      6. product_final_price(float): Amount that user should pay for this product

      7. paid_at(string): payment time

         1. Date Format : ISO-8601 EX) 2018-07-27T10:13:44+00:00
   
   8. confirmed_at(string): confirmed time for order
   
      1. Confirmed order means order cannot be refunded or canceled anymore.
         2. If order is not confirmed yet, please fill in empty string
         3. Date Format : ISO-8601 EX) 2018-07-27T10:13:44+00:00
   
      9. caceled_at(string): canceled time for order
   
      1. canceled order means order is completely canceled by customer.  
         2. If order is not canceled, please fill in empty string.
      3. Date Format : ISO-8601 EX) 2018-07-27T10:13:44+00:00
   
   3. linkprice
   
      1. merchant_id(string): Merchant ID that Linkprice provides
   2. event_code (string): Unique code that Linkprice provide.
      
      3. promo_code(string) :  Promotion code that user uses and please let Linkprice know list of promotion code.
   4. user_agent(string): USER_AGENT information
      5. remote_addr(string): User IP. It is client IP not server IP.
      6. device_type(string): 
         1. web-pc: All sales data through web but mobile
         2. web-mobile: Web sales data with mobile
         3. app-android: Sales data with Android app
         4. app-ios: Sales data with iOS app
   
3. Request Sample

   1. When customer buy two HDMI cables which is 7000won and three instant noodles which is 6000won with free shipping 
      1. sum of each product_final_price is the same with final_paid_price: 14000 + 18000 = 32000 

```json
   {
       "order": {
           "order_id": "o190203-h78X3",
           "final_paid_price": 30200,
           "currency": "KRW",
           "user_name": "customer name"
       },
       "products": [
           {
               "product_id": "P87-234-anx87",
               "product_name": "UHD 4K 넥시 HDMI케이블",
               "category_code": "132782",
               "category_name": ["computer", "cable", "HDMI cable"],
               "quantity": 2,
               "product_final_price": 14000,
               "paid_at": "2019-02-12T11:13:44+00:00",
               "confirmed_at": "",
               "canceled_at": ""
           },
           {
               "product_id": "P23-983-Z3272",
               "product_name": "instant noodle(5ea)",
               "category_code": "237018",
               "category_name": ["food", "noodle", "instant noodle"],
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

   1. Response body is JSON.

      | KEY           | VALUE         |
      | ------------- | ------------- |
      | is_success    | true / false  |
      | error_message | Error message |
      | order_code    | Order code    |
      | product_code  | Product code  |

   2. Respons Sample

      1. Success to transfer data

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

      2. Fail to transfer data

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

      - CPS 할인코드 에러 메세지      

      | error_message                                                | 에러 상세 내용                                           |
      | ------------------------------------------------------------ | -------------------------------------------------------- |
      | This is not a valid JSON string.                             | Data type is not Json                                    |
      | order.order_id parameter is empty.                           | order.order_id is empty                                  |
      | order.final_paid_price parameter is empty.                   | order.final_paid_price is empty                          |
      | order.final_paid_price is not integer.                       | order.final_paid_price integer is not integer            |
      | order.currency parameter is empty.                           | order.currency is empty                                  |
      | order.user_name parameter is empty.                          | order.user_name is empty                                 |
      | products parameter is empty.                                 | products is empty                                        |
      | linkprice.promo_code parameter is empty.                     | linkprice.promo_code is empty                            |
      | linkprice.event_code parameter is empty.                     | linkprice.event_code is empty                            |
      | event is nothing.                                            | There is no event                                        |
      | linkprice.user_agent parameter is empty.                     | linkprice.user_agent is empty                            |
      | linkprice.remote_addr parameter is empty.                    | linkprice.remote_addr is empty                           |
      | linkprice.device_type parameter is empty.                    | linkprice.device_type is empty                           |
      | products[i].product_id parameter is empty.                   | product_id[i] is empty                                   |
      | products[i].product_name parameter is empty.                 | product_name[i] is empty                                 |
      | products[i].category_code parameter is empty.                | category_code[i] is empty                                |
      | products[i].product_final_price parameter is empty.          | product_final_price[i] is empty                          |
      | The amount of order.final_paid_price does not match the total amount of products.product_final_price. | Sum of products and order.final_paid_price are not equal |
      | There was a problem sending your performance.                | Transferring error                                       |



## 4. 실적 목록

1. Sales Data List?

   1. API to display sales data list of Linkprice.
   2. Compare to merchant sales data and linkprice data that merchant send to recover lost data in transfer process.
   3. **If you have sales data list for CPS, CPS promo sales data is also displayed.**

2. Display Sales Data List

   1. Merchant should make API and Linkprice will call Sales Data List API.
   2. Sending sales data to Linkprice and displaying sales data should be the same.
   3. Linkprice call API like below and three parameters, **paid_ymd, confirmed_ymd and canceled_ymd**  can be used.

   ```shell
   curl https://api.yourdomain.com/linkprice/order_list_v1?paid_ymd=20181220
   ```

   4. Parameter

   | 파라미터      | 값                                                           |
   | ------------- | ------------------------------------------------------------ |
   | paid_ymd      | Payment day. EX) 20181220 <BR />Display all Linkprice sales data on this payment day. |
   | confirmed_ymd | The day that order is confirmed 예) 20181220 <BR />Display all confirmed sales data on this day |
   | canceled_ymd  | The day that order is canceled 예) 20181220 <BR />Display all canceled sales data on this day |

   5. Data format is json

      ```json
[
          {"order":{"order_id":"ord-123-01",....},"products":[...],"linkprice":{...}},
          {"order":{"order_id":"ord-123-02",....},"products":[...],"linkprice":{...}},
          {"order":{"order_id":"ord-123-03",....},"products":[...],"linkprice":{...}},
          {"order":{"order_id":"ord-123-04",....},"products":[...],"linkprice":{...}}
      ]
      ```
