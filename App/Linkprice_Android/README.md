# APP Android 직접 셋업

## 1. 제휴 마케팅이란

> 제휴 마케팅이란 제품/ 서비스 등을 판매하는 인터넷 업체(Merchant)가 고객을 끌어들이고 진열, 판매하는 공간으로 자신의 사이트 뿐만 아니라 다른 관련 사이트(Affiliate)로 까지 공간을 확장하여 
> 이때 발생하는 수입을 제휴맺은 사이트(Affiliate)와 공유하는 새로운 형태의 마케팅 기법입니다.
>
> [제휴 마케팅 소개](https://helpdesk.linkprice.com/pages/merchant-faq-introduce)



#### 1.1. V2 웹 셋업 개요 

![ex_screenshot](../v2_web_setup_process_img.png)

1) 링크프라이스 배너 클릭

2) 링크프라이스에서 광고주 게이트웨이 페이지에 LPINFO (쿠키)생성에 필요한 값과 목적페이지 URL 전달

3) device_type에 따라서 PC웹 또는 모바일웹 목적페이지로 이동

4) 상품구매 

5) 상호 대조를 위해 광고주 DB에 실적 데이터 보관

6) 링크프라이스로 구매 실적 전송, 데일리픽스 및 자동취소 정보 제공 

- V2버전은 클라이언트에서 스크립트 형식으로 보내는 실시간 실적 전송방식을 사용합니다. ([V2버전 웹 셋업 가이드](https://github.com/linkprice/MerchantSetup/blob/v2/Merchant%20Setup%20Guide_Kor_ver2.5.pdf) 참조)



#### 1.2. V2 APP 셋업 개요 

![ex_screenshot](../v2_app_setup_process_img.png)

1) 링크프라이스 배너 클릭

2) 링크프라이스에서 광고주 게이트웨이 페이지에 LPINFO (쿠키)생성에 필요한 값과 목적페이지 URL 전달

- 배너 클릭시마다 변경되는 LPINFO의 last값을 저장합니다. ([4. 실행(배너 클릭시)할 때 마다 어필리에이트 변경](https://github.com/linkprice/MerchantSetup/tree/master/App/Linkprice_Android#4-%EC%8B%A4%ED%96%89%EB%B0%B0%EB%84%88-%ED%81%B4%EB%A6%AD%EC%8B%9C%ED%95%A0-%EB%95%8C-%EB%A7%88%EB%8B%A4-%EC%96%B4%ED%95%84%EB%A6%AC%EC%97%90%EC%9D%B4%ED%8A%B8-%EB%B3%80%EA%B2%BD) 참조)

3) device_type에 따라 웹 또는 앱 목적페이지로 이동 ([2. AndroidManifest.xml 설정](https://github.com/linkprice/MerchantSetup/tree/master/App/Linkprice_Android#2-androidmanifestxml-%EC%84%A4%EC%A0%95) 참조)


​	3-2) 앱 미설치자인 경우 

- 모바일 웹 목적페이지로 이동 해야 합니다. 

		3-3) 앱 설치자인 경우 

- 광고주 앱의 목적페이지로 앱이 오픈 되어야 합니다. 
- 목적페이지는 어필리에이트의 사용자 정의 링크 생성에 따라 메인페이지, 특정 상품페이지, 이벤트 페이지 등으로 변경됩니다. ([5.사용자 정의 링크](# 5. 사용자 정의 링크) 참조)
- 타사 앱(카카오톡 / 네이버 / 다음 / 밴드 / 페이스북 / 크롬 / 인터넷 / 사파리 / 매체사 앱 등…)에서 배너를 클릭 한 경우 광고주 앱의 목적페이지로 앱이 오픈 되어야 합니다. 
- 오류 페이지로 이동하지 않도록 주의해주세요.

4) 상품구매 

5) 상호 대조를 위해 광고주 DB에 실적 데이터 보관

6) 링크프라이스로 구매 실적 전송 ([3. 실적 전송](# 3. 실적 전송) 참조) , 데일리픽스, 자동 실적 취소 작업 ([V2버전 웹 셋업 가이드](https://github.com/linkprice/MerchantSetup/blob/v2/Merchant%20Setup%20Guide_Kor_ver2.5.pdf) 참조)



## 2. AndroidManifest.xml 설정

> URL  클릭 시 해당 앱이 설치되어 있으면 앱이 실행되고, 설치가 되어 있지 않으면 Google Play 스토어나 특정 페이지로 redirection 하기 위한 설정 및 앱 설치 시 refferer 값 전달을 위한 설정입니다.

### 2.1. scheme 및 host 설정

* 귀사의 앱의 AndroidManifest.xml파일에서 실행하고자 하는 Activity 아래에 intent-filter를 선언합니다.
* 예를 들어, 귀사의 게이트웨이 페이지의 URL이 "https://gw.linkprice.com/gateway/lpfront.php" 일때, 아래와 같이 선언합니다.
* V4버전을 이용중이시라면, 링크프라이스 담당자에게 알려주세요. ([APPLink 가이드](../AppLink/Readme.md) 참조)

```xml
<activity
	android:name=".MainActivity"
	android:label="@string/your_app_name" >
	<intent-filter>
		<action android:name="android.intent.action.MAIN" />
		<category android:name="android.intent.category.LAUNCHER" />
	</intent-filter>
    
    <!-- 이부분을 선언하여 줍니다 -->
	<intent-filter>
		<action android:name="android.intent.action.VIEW" />
		<category android:name="android.intent.category.DEFAULT" />
		<category android:name="android.intent.category.BROWSABLE" />
		<data android:host="your gateway host url" android:scheme="custom scheme"/>
	</intent-filter>
</activity>
```

* \<action 설명\>
  1. **android:name="android.intent.action.VIEW"**: 데이터를 사용자에게 보여주기 위하여 선언합니다.
* \<category\> 설명
  1. **android:name="android.intent.category.DEFAULT"**: 앱이 암시적 인텐트에도 응답 할 수 있게 선언합니다.
  2. **android:name="android.intent.category.BROWSABLE"**: intent-filter가 웹 브라우저에서 접근하기 위해 선언합니다.
* \<data\> 설명
  1. **android:host**: 게이트웨이 페이지의 host부분을 선언합니다.
  2. **android:scheme**: 게이트웨이 페이지의 scheme(custom scheme)을 선언합니다.

### 2.2. 권한 설정

* 인터넷 연결 및 네트워크 상태를 확인 할 수 있도록 AndroidManifest.xml에 권한을 추가해주세요.

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```

### 2.3. 리시버 등록

* Google Play 스토어를 통해서 앱을 다운로드 받아 설치하면 설치 이벤트 가 발생합니다.
* AndroidManifest.xml에 리시버를 등록해 주면 설치 이벤트 를 수신받을 수 있으며, 이 때 INSTALL_REFERRER 값이 전달됩니다.

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

### 2.4. 리시버 수정(InstallReceiver.java)
```java
@Override
public void onReceive(Context context, Intent intent) {
    	mContext = context;
    	mIntent = intent;
    	String log_tag = "your app debug log";
    
    	Bundle extras = mIntent.getExtras();

        if (null == extras) {
            Log.d(log_tag, "extra null");
            return false;
        }

        SharedPreferences.Editor prefEditor = mSharedPreferences.edit();
        String referrer = extras.getString("referrer");

        if (null == referrer) {
            Log.d(log_tag, "referrer null");
            return false;
        }

        try {
            Map<String, String> referrerParse = parseQuery(referrer);

            // LPINFO
            String lpinfo = referrerParse.get("LPINFO");

            if (setLpinfo(prefEditor, lpinfo)) {

                // 광고 인정 기간
                String rd = referrerParse.get("rd");
                setRD(prefEditor, rd);
                // 리퍼러
                setReferrer(prefEditor, referrer);
                // 등록 시간
                setCreateTime(prefEditor);

                prefEditor.apply();

                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
}
```



## 3. 실적 전송

### 3.1. 실적 전송이 클라이언트에서 스크립트로 셋업 되있는 경우

1. CPS 웹 실적을 서버가 아닌 클라이언트에서 스크립트 형식으로 보내시고 계신다면, 앱에서 반드시 실적 전송을 하여야 합니다.

#### 3.1.1. CPS 실적 전송 (상품 구매)

```java
SharedPreferences mSharedPreferences = context.getSharedPreferences("your preference",  Context.MODE_PRIVATE);
JSONArray mItems = new JSONArray();
JSONObject orderInfo = new JSONObject();
JSONObject linkprice = new JSONObject();

Map<String, Object> order = new HashMap<>();
orderInfo.put("order_id", "o111232-323234");            // order ID
orderInfo.put("final_paid_price", 70000);               // total price user paid
orderInfo.put("currency", "KRW");                       // currency
orderInfo.put("user_name", "tester");                   // user name

Map<String, Object> lp = new HashMap<>();
linkprice.put("user_agent", "user agent info");            // user agent
linkprice.put("remote_addr", "127.0.0.1");                 // remote address
linkprice.put("merchant_id", "clickbuy");                  // merchant ID that linkprice provide
linkprice.put("lpinfo", mSharedPreferences.getString("lpinfo", null));
linkprice.put("device_type", "app_android");


//Map<String, Object> item = new HashMap<>();
JSONObject item = new JSONObject();
item.put("product_id", "productCode");              // product code
item.put("product_name", "product name");           // product name
item.put("category_code", "category code");         // category code
item.put("category_name", "category name");         // category name
item.put("quantity", 1);                            // quantity
item.put("product_final_price", 59000);             // amount user paid
item.put("paid_at", "2019-02-12T11:13:44+00:00");   // time user paid
item.put("confirmed_at", "");
item.put("canceled_at", "");

mItems.put(item);

//Map<String, Object> item2 = new HashMap<>();
JSONObject item2 = new JSONObject();
item2.put("product_id", "productCode2");            // product code
item2.put("product_name", "product name2");         // product name
item2.put("category_code", "category code2");       // category code
item2.put("category_name", "category name2");       // category name
item2.put("quantity", 1);                           // quantity
item2.put("product_final_price", 11000);            // amount user paid
item2.put("paid_at", "2019-02-12T11:13:44+00:00");  // paid time
item2.put("confirmed_at", "");
item2.put("canceled_at", "");

mItems.put(item2);


```

* user agent이 없을 경우 null로 보내 주십시요.

* 쿠폰 및 마일리지 사용에 따른 "product_final_price"는 아래 링크를 확인 하여 주세요.

  [product_final_price 계산](https://github.com/linkprice/MerchantSetup/blob/master/CPS/README.md#4-%EC%8B%A4%EC%8B%9C%EA%B0%84-%EC%8B%A4%EC%A0%81-%EC%A0%84%EC%86%A1)

* 자세한 데이터에 대한 설명은 아래 링크를 확인 하여 주세요.

  [CPS 실적 데이터 설명](https://github.com/linkprice/MerchantSetup/tree/master/CPS#4-%EC%8B%A4%EC%8B%9C%EA%B0%84-%EC%8B%A4%EC%A0%81-%EC%A0%84%EC%86%A1)



## 4. 실행(배너 클릭시)할 때 마다 어필리에이트 변경

## MainActivity.java
```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    Intent mIntent = new Intent();
    Context mContext = new Context();

    LpMobileAT lpMobileAT = new LpMobileAT(this, getIntent());
    lpMobileAT.setTagValueActivity();
    String log_tag = "your app debug log";
    SharedPreferences mSharedPreferences = context.getSharedPreferences(log_tag,  Context.MODE_PRIVATE);
    mIntent = getIntent();
    mContext = this;
    
    Uri data = mIntent.getData();
    if (null == data) {
        Log.d(log_tag, "setTagValueActivity - uri null");
        return false;
    }

    SharedPreferences.Editor prefEditor = mSharedPreferences.edit();

    try {
        // LPINFO
        String lpinfo = data.getQueryParameter("LPINFO");

        if (lpinfo != null) {
			// lpinfo 
            prefEditor.putString("lpinfo", lpinfo);
          
            // 광고 인정 기간
            String rd = data.getQueryParameter("rd");
            int mRd;
            try {
                mRd = Integer.parseInt(rd);
            } catch (Exception e) {
                mRd = 0;
            }
            prefEditor.putInt("rd", mRd);
            
            // 리퍼러
            prefEditor.putString("referrer", data.toString());
            
            // 등록 시간
            setCreateTime(prefEditor);
			Calendar createCalendar = Calendar.getInstance();
            long create_time = createCalendar.getTimeInMillis();
        	prefEditor.putLong("create_time", create_time);
            
            prefEditor.apply();

            return true;
        }
    } catch(Exception e) {
        e.printStackTrace();
    }

    return false;
}
```



## 5. 사용자 정의 링크

* target_url 변수로 전달 됩니다.
* 사용자 정의 링크에 해당하는 Activity가 존재 하지 않을 경우, 절대 오류가 나오지 않아야 합니다.

~~~java
/*
예1) 상품 상세 페이지
PC target_url: www.linkprice.com/clickbuy/product-detail.php?pid=2342134&show=AHFSD 
Mobile target_url: m.linkprice.com/shop/product?pid=2342134

예2) 검색 페이지
PC target_url:  www.linkprice.com/clickbuy/search-result.php?keyword=%EA%B2%80%EC%83%89%EC%96%B4
Mobile target_url:  m.linkprice.com/search?keyword=%EA%B2%80%EC%83%89%EC%96%B4

*/

String deeplink = null;
Intent mIntent = getIntent();
Uri data = mIntent.getData();
if(data != null) {
	try{
        deeplink = data.getQueryParameter("target_url");
    } catch (Exception e){

    }    
} 

URL dl = new URL(deepLink);
Intent intent = new Intent(this, MainActivity.class);

if((dl.getHost() == "www.linkprice.com" && dl.getPath() == "/clickbuy/product-detail.php") || (dl.getHost() == "m.linkprice.com" && dl.getPath() =="/shop/product")) {
    // 상품 상세 Activity 로 이동
    intent = new Intent(this, productDetailActivity.class);
    String pid = getQuery(deepLink, 'pid');
    intent.putExtra('pid', pid);
} else if ((dl.getHost() == "www.linkprice.com" || dl.getPath() == "/clickbuy/search-result.php") || (dl.getHost() == "m.linkprice.com" && dl.getPath() = "/search")) {
    // 검색 Activity 로 이동
    intent = new Intent(this, seachActivity.class);
    String keyword = getQuery(deepLink, 'keyword');
    intent.putExtra('keyword', keyword) 
}

// 사용자 정의 링크에 해당하는 Activity가 없다면 MainActivity 실행
startActivity(intent);

/********************************* getQuery method *************************************/
public Map<String, String> getQuery(URL url) throws UnsupportedEncodingException {
    Map<String, String> query_pairs = new LinkedHashMap<String, String>();
    String query = url.getQuery();
    if(query.indexOf("&") > 0) {
        String[] pairs = query.split("&");
        for (String pair : pairs) {
            int idx = pair.indexOf("=");
            query_pairs.put(URLDecoder.decode(pair.substring(0, idx), "UTF-8"), URLDecoder.decode(pair.substring(idx + 1), "UTF-8"));
        }
    } else {
        String[] pairs = new String[1];
        pairs[0] = query;
        for (String pair : pairs) {

            int idx = pair.indexOf("=");
            query_pairs.put(URLDecoder.decode(pair.substring(0, idx), "UTF-8"), URLDecoder.decode(pair.substring(idx + 1), "UTF-8"));
        }
    }

    return query_pairs;
}

~~~