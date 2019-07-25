## 1. Affiliate Marketing

> Affiliate Marketing is one of internet marketing method originated by Amazon.com in 1996, in which Merchant sites serving ecommerce increase traffic and revenue by gathering affiliates who wants to get money by advertising other sites. Especially, it is characterized that it pays advertisement fees only when real performances that merchants want occurred.



## 2. Import lpmat library 

1.  Add "maven { url ‘https://jitpack.io’ } " in build.hradle of project

```groovy
allprojects {
    repositories {
        google()
        jcenter()
        maven { url 'https://jitpack.io' }
    }
}
```

2. Add dependency in build.gradle of App

```groovy
dependencies {
    ...
	implementation 'com.github.linkprice:LPMobileAT_Android:1.0.7'
}
```

## 3. AndroidManifest.xml

> When customer clicks link, if there is App in coutomer's phone, it opens App. If not, it goes to Google Play store or specific page

### 3.1 scheme and host

- Declare "intent-filter" under Activity you want to run in AndroidManifest.xml 
- For example, if your gateway is "https://gw.linkprice.com/gateway/lpfront.php", set scheme and host like below.

```xml
<activity
	android:name=".MainActivity"
	android:label="@string/app_name" >
	<intent-filter>
		<action android:name="android.intent.action.MAIN" />
		<category android:name="android.intent.category.LAUNCHER" />
	</intent-filter>
    
    <!-- set host and scheme -->
	<intent-filter>
		<action android:name="android.intent.action.VIEW" />
		<category android:name="android.intent.category.DEFAULT" />
		<category android:name="android.intent.category.BROWSABLE" />
		<data
			android:host="gw.linkprice.com" android:scheme="https" />
	</intent-filter>
</activity>
```

- \<action>
  1. **android:name="android.intent.action.VIEW"**:  when you have some information that an activity can show to the user
- \<category\> 
  1. **android:name="android.intent.category.DEFAILT"**:  To receive implicit intents, you should include the this.
  2. **android:name="android.intent.category.BROWSABLE"**: The target activity allows itself to be started by a web browser to display data referenced by a link
- \<data\> 
  1. **android:host**: Set your gateway page host
  2. **android:scheme**:  Set your gateway page scheme(generally https or http)

### 3.2 Permission

- To check network status, add permission below in AndroidManifest.xml

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```

### 3.3 Receiver(In AndroidManifest.xml)

- When user install app through Google play store, Install event occur.
- If you set "receiver" in AndroidManifest.xml, you can get install event.

```xml
<receiver
	android:name=".InstallReceiver"
	android:enabled="true"
	android:exported="true" >
	<intent-filter>
		<action android:name="com.android.vending.INSTALL_REFERRER" />
	</intent-filter>
</receiver>
```

### 3.4 Modify onReceive(InstallReceiver.java)

```java
@Override
public void onReceive(Context context, Intent intent) {
    LpMobileAT lpMobileAT = new LpMobileAT(context, intent);
    lpMobileAT.setTagValueReceiver();
}
```

## 4. Send sales data

### 4.1 If you send sales data in S2S(Server to Server)

1.  If you already send sales data in S2S(Server to Server) for CPS, you should not send data.
2. If lpinfo(click information) is not in server, you can send lpinfo from app to server.

```java
// Get lpinfo(click info)
LpMobileAT lpMobileAT = new LpMobileAT(context, get
Intent());
String lpinfo = lpMobileAt.getTagValue();
```

### 4.2 If you send sales data in client side

1.  If you send sales data in client side for CPS, you should send it in App 

#### 4.2.1 Send saels data for CPS

```java
LpMobileAT lpMobileAT = new LpMobileAT(Context, getIntent());

Map<String, Object> order = new HashMap<>();
order.put("order_id", "o111232-323234");            // order ID
order.put("final_paid_price", 70000);               // total price user paid
order.put("currency", "KRW");                       // currency
order.put("user_name", "tester");                   // user name

Map<String, Object> lp = new HashMap<>();
lp.put("user_agent", "user agent info");            // user agent
lp.put("remote_addr", "127.0.0.1");                 // remote address
lp.put("merchant_id", "clickbuy");                  // merchant ID that linkprice provide

lpMobileAT.setOrder(order, lp);

Map<String, Object> item = new HashMap<>();
item.put("product_id", "productCode");              // product code
item.put("product_name", "product name");           // product name
item.put("category_code", "category code");         // category code
item.put("category_name", "category name");         // category name
item.put("quantity", 1);                            // quantity
item.put("product_final_price", 59000);             // amount user paid
item.put("paid_at", "2019-02-12T11:13:44+00:00");   // time user paid
item.put("confirmed_at", "");
item.put("canceled_at", "");

lpMobileAT.addItem(item);

Map<String, Object> item2 = new HashMap<>();
item2.put("product_id", "productCode2");            // product code
item2.put("product_name", "product name2");         // product name
item2.put("category_code", "category code2");       // category code
item2.put("category_name", "category name2");       // category name
item2.put("quantity", 1);                           // quantity
item2.put("product_final_price", 11000);            // amount user paid
item2.put("paid_at", "2019-02-12T11:13:44+00:00");  // paid time
item2.put("confirmed_at", "");
item2.put("canceled_at", "");

lpMobileAT.addItem(item2);

lpMobileAT.send();
```

- If there in no user agent, send null for user agent

- Check "product_final_price" in link below, if you use coupon.

  [product_final_price](<https://github.com/linkprice/MerchantSetup/blob/master/CPS/README.md#final_paid_price>)

- Check detail of CPS data in link below.

  [CPS data](https://github.com/linkprice/MerchantSetup/blob/master/CPS/README-en.md)

#### 4.2.2 Send saels data for CPA

```java
LpMobileAT lpMobileAT = new LpMobileAT(Context, getIntent());

Map<String, Object> order = new HashMap<>();
order.put("unique_id", "");
order.put("final_paid_price", 0);
order.put("currency", "KRW");
order.put("member_id", "member ID");
order.put("action_code", "register");
order.put("action_name", "membership");
order.put("category_code", "register");

Map<String, Object> lp = new HashMap<>();
lp.put("merchant_id", "merchant ID");       // merchant id
lp.put("user_agent", "user agent");         // order code
lp.put("remote_addr", "remote address");    // user Info

lpMobileAT.setOrder(order, lp);
lpMobileAT.send();
```

- There is daily limitaion for IP(3times) so if you do not send real IP for user, it can occur problem.

- Check detail of CPA data in link below.

  [CPA data](https://github.com/linkprice/MerchantSetup/blob/master/CPA/README-en.md)

#### 4.2.3 Send saels data for CPI(InstallReceiver.java)

```java
@Override
	public void onReceive(Context context, Intent intent) {

        // set tag_value at receiver
        LpMobileAT lpMobileAT = new LpMobileAT(context, intent);
        lpMobileAT.setTagValueReceiver();

        /* CPI sending data
         * param1: merchant ID 
         * param2: user agent information
         * param3: user remote address
         * param4: if you use CPI set true
        */ 
        lpMobileAT.autoCpi("clickbuy", "user_agent", "remote_addr",false);

    }
```

- There is daily limitaion for IP(3times) so if you do not send real IP for user, it can occur problem.



## 5. Renewal click info

## MainActivity.java

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    LpMobileAT lpMobileAT = new LpMobileAT(this, getIntent());
    lpMobileAT.setTagValueActivity();
}
```

## 6. DeepLink

- It is passed with "target_url" parameter.
- If there is no Activity for Deeplink page, it should not occur error.

```java
/*
EX1) product detail page
PC target_url: www.linkprice.com/clickbuy/product-detail.php?pid=2342134&show=AHFSD 
Mobile target_url: m.linkprice.com/shop/product?pid=2342134

EX2) search page
PC target_url:  www.linkprice.com/clickbuy/search-result.php?keyword=%EA%B2%80%EC%83%89%EC%96%B4
Mobile target_url:  m.linkprice.com/search?keyword=%EA%B2%80%EC%83%89%EC%96%B4

*/

LpMobileAT lpMobileAT = new LpMobileAT(this, getIntent());

String deepLink = lpMobileAT.getDl();
URL dl = new URL(deepLink);
Intent intent = new Intent(this, MainActivity.class);

if((dl.getHost() == "www.linkprice.com" && dl.getPath() == "/clickbuy/product-detail.php") || (dl.getHost() == "m.linkprice.com" && dl.getPath() =="/shop/product")) {
    // move to product detail Activity
    intent = new Intent(this, productDetailActivity.class);
    String pid = lpMobileAt.getQuery(deepLink, 'pid');
    intent.putExtra('pid', pid);
} else if ((dl.getHost() == "www.linkprice.com" || dl.getPath() == "/clickbuy/search-result.php") || (dl.getHost() == "m.linkprice.com" && dl.getPath() = "/search")) {
    // move to search Activity
    intent = new Intent(this, seachActivity.class);
    String keyword = lpMobileAt.getQuery(deepLink, 'keyword');
    intent.putExtra('keyword', keyword) 
}

// If there is no Activity for Deeplink, it goes to Main activity
startActivity(intent);
```
