## SUMMARY

### [1. Gateway Page(Create cookie called LPINFO)](#landing-page)

### [2. Send sales data on real time](#send-data)

*   Send action data when registration is completed (**Server to Server**)

### [3. Display action data](#daily-fix)

*   Compare to merchant action data and Linkprice data that merchant send to recover
    lost data in transfer process.

<br />
<br />
<br />



## <a name="landing-page"></a>1. Gateway Page

1.  Gateway page

    *   Gateway page creates cookie that include affiliate information then redirect to your
        web site.(See sample)

    *   Change REUTRN_DAYS(Cookie duration) value to cookie duration on contract. If it is
        different from contract, it should be a breach of contract so you may have
        disadvantage.

        ​

2.  Sample code

    *   [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/PHP/lpfront.php)
    *   [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/PHP/lpfront.jsp)
    *   [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/PHP/lpfront.asp)



## <a name="send-data"></a>2. Send action data on real time

1. Save action data on real time

    *   If there is Cookie(LPINFO) when member information is saved in your system, save
        action data 

    *   Add following fields to your user table

    *   Save networld_value, networld_name, remote_address and user_agent value when you
        save member information.

        |     FIELD      |                  VALUE                   |
        | :------------: | :--------------------------------------: |
        | network_value  |              LPINFO(cookie)              |
        |  network_name  | value that rocognize linkprice (EX - linkprice, lp, etc.) |
        | remote_address |               REMOTE_ADDR                |
        |   user_agent   |             HTTP_USER_AGENT              |

    ​

2. Time to send action data

    *   When registration is completed, action data should be sent.
    *   Action data should be sent in Server to Server way (**If you have to use script or image way to transfer sales data, please contact Linkprice**)

3. How to set up sending action data

    *   See sample code and modify it to your development environment.
    *   Action data should be transfer in json type.
    *   **Do not change name of KEY** and insert value of your sales data.
    *   Recommend to save value that classify sales_type(PC, MOBILE, IOS, AND, APP) in your order table. (If you cannot assort IOS and Android for sales_type, please insert "APP") 

```javascript
   [
     {
        lpinfo : "network_value",           // LPINFO cookie value
        merchant_id : "Your merchant ID",   // Merchant ID from Linkprice
        member_id : "User ID of who register",	        
        unique_id : "number of member",		        
        action : "member",                  // action code(max-length : 100)
        action_name : "회원가입",             // max-length : 300
        category_code : "member",           // type of action(ex - “member”, “apply”)
        user_agent : "User Agent",          // $_SERVER["HTTP_USER_AGENT"]
        remote_addr :  "User IP"            // $_SERVER["REMOTE_ADDR"]
        sales_type :  "PC"				// PC, MOBILE, IOS, AND, APP(choose 1)          
     }
   ]
```



4.  Sample
    *   [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/PHP/index.php)
    *   [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/JSP/index.jsp)
    *   [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/ASP/index.asp)

5. Error code

| error_message                                    |
| ------------------------------------------------ |
| lpinfo parameter is empty                        |
| merchant_id parameter is empty.                  |
| unique_id parameter is empty.                   |
| action parameter is empty.                 |
| category_code parameter is empty.                |
| user_agent parameter is empty.                   |
| remote_addr parameter is empty.                  |
| action_name parameter is empty.                 |
| lpinfo parameter does not conform to the format. |
| sales_type and user_agent parameter is empty.    |
| The order_code of each array must be the same.   |
| Order code is duplicated.                        |
| Required parameters are missing.                 |
| Network error during performance transmission.   |


## <a name="daily-fix"></a>3. Display action data(daily_fix)

1.  Display action data

    *   Compare to merchant action data and Linkprice data that merchant send to
        recover lost data in transfer process.
    *   Linkprice call your url to display action data once a day and recover lost data.
    *   Number of member(Unique_id) and action code(action) are used to compare data.

2. How to set up displaying sales data

    *   Display your action data to be made through Linkprice
    *   See sample code and modify it to your development environment.
    *   Sending action data to Linkprice and displaying action data should be the same.
    *   Linkprice call merchant url that display action data with „yyyymmdd‟ parameter.
        *   EX -  www.example.com/linkprice/daily_fix.php?yyyymmdd=20170701
    *   Action data should be displayed in json type.

    ```javascript
    [
      {
         lpinfo : "network_value",                  // LPINFO cookie value
         order_time : "132543",                     // ex) “130556”
         member_id : "User ID of who register",	        
         unique_id : "number of member",		
         action : "member",                         // action code(max-length : 100)
         action_name : "Registration",              // max-length : 300
         category_code : "member",                  // type of action(ex – “member”, “apply”)
         user_agent : "User Agent",                 // $_SERVER["HTTP_USER_AGENT"]
         remote_addr :  "User IP"                   // $_SERVER["REMOTE_ADDR"]
         sales_type :  "PC"				// PC, MOBILE, APP(choose 1)       
      }
    ]
    ```

    

3.  Sample

    *   [PHP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/PHP/daily_fix.php)
    *   [JSP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/JSP/daily_fix.jsp)
    *   [ASP](https://github.com/linkprice/MerchantSetup/blob/master/CPA/JSP/daily_fix.asp)

    ​

