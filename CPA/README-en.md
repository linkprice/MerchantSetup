## 1. Create "lpinfo" table

1. The data below is required to track linkprice's sales data.

    1. lpinfo: cookie value named "lpinfo"
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
          unique_id varchar(30),
          member_id varchar(30),
          lpinfo varchar(580),
          user_agent varchar(300),
          ip varchar(50),
          device_type varchar(10)
      )
    ```

3. After user finished register, **you should store only linkprice's data in "Lpinfo" table.**

4. In this table, you should store only linkpirce's data(When there is "lpinfo" cookie, linkprice's data should be stored)



## 2. Gateway page

1. What is Gateway?

    1. When user clicks banner or link, it goes to linkprice then will be redirect to merchant page.
    2. When user redirect to merchant, the first page in merchant side is Gateway page.
    3. Gateway checks validation, sets cookie and redirects to final destination in merchant site.

2. The main function of Gateway is to set "lpinfo" cookie which is information of linkprice's click.

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

1. After registration, send Request data below in json type

    1. There should be one order information in json data. 
    2. It cannot include multi registration information.

2. Request

    1. action
        1. unique_id(string): Registration Number
            1. This is not member ID but assigned number for registration.
            2. It should be unique.
        2. final_paid_price(number): Amount that user pay
            1. If it is free registration or service, the value is 0.
            2. If it is paid registration or service, the value should be how much user pay.
        3. action_name(string): Service name
            1. EX) "Free registration", "Survey"
        4. action_code(string): Service code
        5. currency(string): Curreyncy that user pay
            1. ISO 4217
            2. EX) USD, KRW, CNY, EUR
        6. member_id: Member ID
        7. category_code: Category code
            1. EX) "register", "apply"
    2. linkprice
        1. lpinfo(string): "lpinfo" cookie value
        2. merchant_id(string): Merchant ID that Linkprice provides
        3. user_agent(string): USER_AGENT information
        4. remote_addr(string): User IP. It is client IP not server IP.
        5. device_type(string):
            1. web-pc: All data through web but mobile
            2. web-mobile: Web data with mobile
            3. app-ios: Data with Android app
            4. app-android: Data with iOS app

3. Request Sample

    1. Free registration

    ```json
    {
        "action": {
            "unique_id": "10002356",
            "final_paid_price": 0,
            "currency": "KRW",
            "member_id": "exampleId",
            "action_code": "free_101",
            "action_name": "free registration",
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

    2. Customer apply paid service.

    ```json
    {
        "action": {
            "unique_id": "10002334",
            "final_paid_price": 10000,
            "currency": "KRW",
            "member_id": "exampleId",
            "action_code": "paid_law1223",
            "action_name": "paid law service",
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
            }
        ]
        
        ```

        * CPA error message

        | error_message                                              | Detail                                      |
        | ---------------------------------------------------------- | ------------------------------------------- |
        | This is not a valid JSON string.                           | REQUEST data is not Json                    |
        | action.unique_id parameter is empty.                       | action.unique_id is empty                   |
        | action.final_paid_price parameter is empty.                | action.final_paid_price is empty            |
        | action.final_paid_price is not integer.                    | action.final_paid_price is not integer type |
        | action.currency parameter is empty.                        | action.currency is empty                    |
        | action.member_id parameter is empty.                       | action.member_id is empty                   |
        | action.action_name parameter is empty.                     | action.action_name is empty                 |
        | action.category_code parameter is empty.                   | action.category_code is empty               |
        | linkprice.lpinfo parameter is empty.                       | linkprice.lpinfo is empty                   |
        | linkprice.lpinfo parameter does not conform to the format. | linkprice.lpinfo is not right format        |
        | linkprice.user_agent parameter is empty.                   | linkprice.user_agent is empty               |
        | linkprice.remote_addr parameter is empty.                  | linkprice.remote_addr is empty              |
        | linkprice.device_type parameter is empty.                  | linkprice.device_type is empty              |
        | There was a problem sending your performance.              | Transferring error                          |

    

## 4. Sales Data List

1. Sales Data List?

    1. API to display action data list of Linkprice.
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
    | paid_ymd      | Registration day or payment day for paid service. EX) 20181220 <BR />Display all Linkprice sales data on this registration day or payment day. |
    | confirmed_ymd | The day that registration is confirmed EX) 20181220 <BR />Display all confirmed sales data on this day |
    | canceled_ymd  | Thd day that registration is canceled EX) 20181220 <BR />Display all canceled registration or service on this day |

    5. Data format is chunked.
        (https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/Transfer-Encoding)

        1. The Content-Length header is omitted.
        2. At the beginning of each chunk you need to add the length of the current chunk in hexadecimal format, followed by '\r\n'.
        3. The terminating chunk is a regular chunk, with the exception that its length is zero.
        4. Response(ndjosn) sample

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

        