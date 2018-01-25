## SUMMARY

### [](#Landing-Page)

### [1. Send sales data](#send-data)

*   Send sales data when purchase is completed.(Server to Server)

### [2. Display sales data](#daily-fix)

*   Compare to merchant sales data and Linkprice data that merchant send to recover
    lost data in transfer process.

<br />
<br />
<br />

## <a name="send-data"></a>Send sales data on real time

1.  Save sales data on real time

    *   Add following fields to your order table

    *   When payment is completed, save values below.

        |     FIELD      |      VALUE      |
        | :------------: | :-------------: |
        |   event_code   |   Event code    |
        |   promo_code   | promotion code  |
        | remote_address |   REMOTE_ADDR   |
        |   user_agent   | HTTP_USER_AGENT |

2.  Time to send sales data

    *   When **purchase is completed**, sales data should be sent. 
    *   Sales data should be sent in Server to Server way (**If you have to use script or image way to transfer sales data, please contact Linkprice**)

3.  How to set up sending sales data

    *   See sample code and modify it to your development environment.
    *   Sales data should be transfer in json type.
    *   **Do not change name of KEY** and insert value of your sales data.

    ```javascript
    [
        {
    	    event_code : "Event code",                      // Event code
                promo_code : "Promotion code",                  // Promotion code
    	    member_id : "User ID of who phurchase products",	
    	    order_code : "Order code of product",			
    	    product_code : "Product code",				
    	    product_name : "Product name",				
    	    item_count : "Item count",				
    	    sales : "Total price",                          // Price * Item count
    	    category_code : "Category code of product",		
    	    user_agent : "User Agent",                      // $_SERVER["HTTP_USER_AGENT"]
    	    remote_addr:  "User IP"                         // $_SERVER["REMOTE_ADDR"]
        }
    ]
    ```

    ​


1.  Sample
    * [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/PHP/index.php)
    * [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/JSP/index.jsp)
    * [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/ASP/index.asp)

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
    [
        {
    	    event_code : "Event code",                  // Event code
                promo_code : "Promotion code",              // Promotion code
    	    order_time : "order time",                  // ex) “130556”
    	    member_id : "User ID of who phurchase products",	
    	    order_code : "Order code of product",			
    	    product_code : "Product code",				
    	    product_name : "Product name",				
    	    item_count : "Item count",				
    	    sales : "Total price",                      // Price * Item count
    	    category_code : "Category code of product",
    	    user_agent : "User Agent",                  // $_SERVER["HTTP_USER_AGENT"]
    	    remote_addr:  "User IP"                     // $_SERVER["REMOTE_ADDR"]
        }
    ]
    ```

    ​

3.  Sample(daily_fix)

    * [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/PHP/daily_fix.php)
    * [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/JSP/daily_fix.jsp)
    * [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPS%20-%20Promo%20code/ASP/daily_fix.asp)

