## 1. Create "lpinfo" table

1. The data below is required to track linkprice's sales data.

    1. lpinfo: cookie value named "LPINFO"
    2. user_agent: USER_AGENT information
    3. ip: IP address of User
    4. device_type
        1. web-pc: All sales data through web but mobile
        2. web-mobile: Web sales data with mobile
        3. app-android: Sales data with Android app
        4. app-ios: Sales data with iOS app

2. Create table(Lpinfo) in your DB to store linkprice's data

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

3. After user finished payment, **you should store only linkprice's data in "Lpinfo" table.**

4. In this table, you should store only linkpirce's data(When there is "LPINFO" cookie, linkprice's data should be stored)



## 2. Gateway page

1. What is Gateway?

    1. When user clicks banner or link, it goes to linkprice then will be redirect to merchant page.
    2. When user redirect to merchant, the first page in merchant side is Gateway page.
    3. Gateway checks validation, sets cookie and redirects to final destination in merchant site.

2. The most important purpose for Gateway is to set "LPINFO" cookie which is information of linkprice's click.

3. Please insert script(javascript) from linkprice after make gateway page.

    1. Please make suitable Gateway for your server environment. 
    2. **Gateway should be open for any user and available for https protocol**. If https is unavailable, please contact Linkprice.
    3. EX)  https://www.yourdomain.com/linkprice/gateway 

4. Script below is sample so please contact if you do not have script(javascript) from Linkprice.

    ```javascript
     <!-- Google Tag Manager -->
      <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
      new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
      j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
      'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
      })(window,document,'script','dataLayer','GTM-P3HTV4');</script>
      <!-- End Google Tag Manager -->
    ```

5. **You should let Linkprice know your Gateway URL**.



## 3. Realtime sending sales data

1. After user finish payment, send Request data below in json type

    1. There should be one order information in json data. 
    2. It cannot include multi orders.
    3. If there are multi products in one order, it should be in same json data.
    4. If you are operating at the same time as a CPS advertising network other than LinkPrice, you should only send the performance of the last clicked network. If you need to different setup, please contact LinkPrice for consultation.
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

        1. lpinfo(string): "LPINFO" cookie value
        2. merchant_id(string): Merchant ID that Linkprice provides
        3. user_agent(string): USER_AGENT information
        4. remote_addr(string): User IP. It is client IP not server IP.
        5. device_type(string): 
            1. web-pc: All sales data through web but mobile
            2. web-mobile: Web sales data with mobile
            3. app-android: Sales data with Android app
            4. app-ios: Sales data with iOS app

    <br>
#### Request json 데이터 타입

| KEY               | VALUE                    | TYPE          |
|-------------------|--------------------------|---------------|
| order_id          | Order ID                 | varchar(100)  |
| final_paid_price  | Amount that user pay     | float         |
| currency          | Currency                 | varchar(3)    |
| user_name         | User name                | varchar(100)  |
| product_id        | Product ID               | varchar(100)  |
| product_name      | Product Name             | varchar(300)  |
| category_code     | Category Code            | varchar(200)  |
| category_name     | Category Name            | varchar(100)  |
| quantity          | Quantity                 | int(11)       |
| product_final_price | product price            | float         |
| paid_at           | payment time             | datetime      |
| confirmed_at      | confirmed time for order | datetime      |
| canceled_at       | canceled time for order  | datetime      |
| merchant_id       | Merchant ID              | varchar(10)   |
| lpinfo            | lpinfo cookie value      | varchar(500)  |
| user_agent        | user_agent information   | varchar(1000) |
| remote_addr       | User IP                  | varchar(100)  |
| device_type       | item division value      | varchar(10)   |


3. Request Sample

    1. When customer buy two HDMI cables which is 7000won and three instant noodles which is 6000won with free shipping 
        1. sum of each product_final_price is the same with final_paid_price: 14000 + 18000 = 32000 

    ```json
    {
        "order": {
            "order_id": "o190203-h78X3",
            "final_paid_price": 32000,
            "currency": "KRW",
            "user_name": "customer name"
        },
        "products": [
            {
                "product_id": "P87-234-anx87",
                "product_name": "UHD 4K HDMI cable",
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
                "product_final_price": 18000,
                "paid_at": "2019-02-12T11:13:44+00:00",
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

    2. When customer buy two HDMI cables which is 7000won and three instant noodles which is 6000won with 3000won shipping fee
        1. Payment total is 35000won with shipping fee
        2. final_paid_price is 32000 without shipping fee
        3. sum of each product_final_price is the same with final_paid_price: 14000 + 18000 = 32000

    ```json
    {
        "order": {
            "order_id": "o190203-h78X3",
            "final_paid_price": 32000,
            ...
     	},
     	"products": [
         	{
                 "product_name": "UHD 4K HDMI cable",
                 "product_final_price": 14000,
                ...
         	},
         	{
                 "product_name": "instant noodle(5ea)",
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

    

4. Response

    1. Response body is JSON.

        | KEY           | VALUE         |
        | ------------- | ------------- |
        | is_success    | true / false  |
        | error_message | Error message |
        | order_code    | Order code    |
        | product_cde   | Product code  |

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

       * CPS 에러 메세지

       | error_message                                                | Explaining                                               |
       | ------------------------------------------------------------ | -------------------------------------------------------- |
       | This is not a valid JSON string.                             | Data type is not Json                                    |
       | order.order_id parameter is empty.                           | action.unique_id is empty                                |
       | order.final_paid_price parameter is empty.                   | action.final_paid_price is empty                         |
       | order.final_paid_price is not integer.                       | Data type of action.final_paid_price is not integer      |
       | order.currency parameter is empty.                           | action.currency is empty                                 |
       | order.user_name parameter is empty.                          | action.member_id is empty                                |
       | products parameter is empty.                                 | action.action_name is empty                              |
       | linkprice.lpinfo parameter is empty.                         | action.category_code is empty                            |
       | linkprice.lpinfo parameter does not conform to the format.   | linkprice.lpinfo is empty                                |
       | linkprice.user_agent parameter is empty.                     | linkprice.user_agent is empty                            |
       | linkprice.remote_addr parameter is empty.                    | linkprice.remote_addr is empty                           |
       | linkprice.device_type parameter is empty.                    | linkprice.device_type is empty                           |
       | products[i].product_id parameter is empty.                   | product_id is empty                                      |
       | products[i].product_name parameter is empty.                 | product_name is empty                                    |
       | products[i].category_code parameter is empty.                | category_code is empty                                   |
       | products[i].product_final_price parameter is empty.          | product_final_price is empty                             |
       | The amount of order.final_paid_price does not match the total amount of products.product_final_price. | Sum of products and order.final_paid_price are not equal |
       | There was a problem sending your performance.                | Transferring error                                       |

    

## 4. Sales Data List

1. Sales Data List?

    1. API to display sales data list of Linkprice.
    2. Compare to merchant sales data and linkprice data that merchant send to recover lost data in transfer process.

2. Display Sales Data List

    1. Merchant should make API and Linkprice will call Sales Data List API.
    2. Sending sales data to Linkprice and displaying sales data should be the same.
    3. Linkprice call API like below and three parameters, **paid_ymd, confirmed_ymd and canceled_ymd**  can be used.

    ```shell
    curl https://api.yourdomain.com/linkprice/order_list_v1?paid_ymd=20181220
    ```

    4. Parameter

    | Parameter     | Value                                                        |
    | ------------- | ------------------------------------------------------------ |
    | paid_ymd      | Payment day. EX) 20181220 <BR />Display all Linkprice sales data on this payment day. |
    | confirmed_ymd | The day that order is confirmed 예) 20181220 <BR />Display all confirmed sales data on this day |
    | canceled_ymd  | The day that order is canceled 예) 20181220 <BR />Display all canceled sales data on this day |

    5. Data format is json

        ```
        [
            {"order":{"order_id":"ord-123-01",....},"products":[...],"linkprice":{...}},
            {"order":{"order_id":"ord-123-02",....},"products":[...],"linkprice":{...}},
            {"order":{"order_id":"ord-123-03",....},"products":[...],"linkprice":{...}},
            {"order":{"order_id":"ord-123-04",....},"products":[...],"linkprice":{...}}
        ]
        ```


