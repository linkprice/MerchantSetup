## SUMMARY

### [1. Landing Page(Create cookie called LPINFO)](#Landing-Page)

### [2. Send sales data](#send-data)

*   Send sales data when purchase is completed.(Server to Server)

### [3. Display sales data](#daily-fix)

*   Compare to merchant sales data and Linkprice data that merchant send to recover
    lost data in transfer process.

### [4. Cancel sales data automatically](#auto-cancel)

*   Cancel Linkprice sales data automatically when your sales are canceled.
    <br />
    <br />
    <br />



## <a name="Landing-Page"></a>Landing Page

1.  Landing page

    *   Landing page creates cookie that include affiliate information then redirect to your
        web site.(See sample)

    *   Change REUTRN_DAYS(Cookie duration) value to cookie duration on contract. If it is
        different from contract, it should be a breach of contract so you may have
        disadvantage.

        ​

2.  Sample code

    *   [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/lpfront.php)
    *   [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/lpfront.jsp)
    *   [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/lpfront.asp)

    ​

## <a name="send-data"></a>Send sales data on real time

1.  Save sales data on real time

    *   If there is Cookie(**LPINFO**) when purchase is completed, save sales data 

    *   Add following fields to your order table

        |     FIELD      |                  VALUE                   |
        | :------------: | :--------------------------------------: |
        | network_value  |              LPINFO(cookie)              |
        |  network_name  | value that rocognize linkprice (EX - linkprice, lp, etc.) |
        | remote_address |               REMOTE_ADDR                |
        |   user_agent   |             HTTP_USER_AGENT              |

2.  Time to send sales data

    *   When **purchase is completed**, sales data should be sent. 
    *   Sales data should be sent in Server to Server way (**If you have to use script or image way to transfer sales data, please contact Linkprice**)

3.  How to set up sending sales data

    *   See sample code and modify it to your development environment.
    *   Sales data should be transfer in json type.
    *   **Do not change name of KEY** and insert value of your sales data.

    ```javascript
    [{
    	lpinfo : "network_value",					// LPINFO cookie value
    	merchant_id : "Your merchant ID",			// Merchant ID from Linkprice
    	member_id : "User ID of who phurchase products",	
    	order_code : "Order code of product",			
    	product_code : "Product code",				
    	product_name : "Product name",				
    	item_count : "Item count",				
    	sales : "Total price",					// Price * Item count
    	category_code : "Category code of product",		
    	user_agent : "User Agent",				// $_SERVER["HTTP_USER_AGENT"]
    	remote_addr:  "User IP"				        // $_SERVER["REMOTE_ADDR"]
    }]
    ```

    ​


1.  Sample
    *   [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/index.php)
    *   [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/index.jsp)
    *   [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/index.asp)

## <a name="daily-fix"></a>Display sales data(daily_fix)

1.  Display sales data

    *   Compare to merchant sales data and linkprice data that merchant send to recover lost data in transfer process.
    *   Linkprice call your url to display sales data once a day and recover lost data.
    *   Order code(order_code) and product code(product_code) are used to compare data.

    ​

2.  How to set up displaying sales data

    *   Display your sales data to be made through Linkprice.
    *   See sample code and modify it to your development environment.
    *   Sending sales data to Linkprice and displaying sales data should be the same.
    *   Linkprice call merchant url that display saels data with „yyyymmdd‟ parameter.
        *   EX -  www.example.com/linkprice/daily_fix.php?yyyymmdd=20170701
    *   Sales data should be displayed in json type.

    ```javascript
    [{
    	lpinfo : "network_value",					// LPINFO cookie value
    	order_time : "order time",				// ex) “130556”
    	member_id : "User ID of who phurchase products",	
    	order_code : "Order code of product",			
    	product_code : "Product code",				
    	product_name : "Product name",				
    	item_count : "Item count",				
    	sales : "Total price",					// Price * Item count
    	category_code : "Category code of product",
    	user_agent : "User Agent",				// $_SERVER["HTTP_USER_AGENT"]
    	remote_addr:  "User IP"				        // $_SERVER["REMOTE_ADDR"]
    }]
    ```

    ​

3.  Sample(daily_fix)

    *   [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/daily_fix.php)
    *   [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/daily_fix.jsp)
    *   [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/daily_fix.asp)

    ​

## <a name="auto-cancel"></a>Cancel sales data automatically(auto_cancel)

1.  Cancel sales data automatically

    *   Merchant can cancel sales data of Linkprice automatically when sales data is
        canceled by unpaid, cancel order, return and etc on your system.
    *   Linkprice call your url that cancel sales data and cancel your sales data in
        Linkprice.(20th of every month)
    *   Order code(order_code) and product code(product_code) are used to check status of
        sales data.

2.  How to set up automatic canceling sales data

    *   See sample code and modify it to your development environment.
    *   When your url that cancel sales data is called, status of sales data should be
        displayed in json type.

    ```javascript
    {
    	order_status : "1",		// result code(See result code chart)
    	reason : "order confirmed"		// reason
    }
    ```

    ​

    *   Chart of result code

    | CODE | MEANING                  | HOW LINKPRICE HANDLE CODE                |
    | :--: | :----------------------- | :--------------------------------------- |
    |  0   | Unpaid                   | Cancel sales data when it is unpaid until 20th of the following month |
    |  1   | Order confirmed          | Order confirmation                       |
    |  2   | Canceled order           | Cancel                                   |
    |  3   | There is no order number | Cancel                                   |
    |  9   | Exception                | Linkprice will check this order          |

    ​


1.  Sample(auto_cancel)
    *   [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/auto_cancel.php)
    *   [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/auto_cancel.jsp)
    *   [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS/PHP/auto_cancel.asp)
