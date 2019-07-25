## 1. Affiliate Marketing

> Affiliate Marketing is one of internet marketing method originated by Amazon.com in 1996, in which Merchant sites serving ecommerce increase traffic and revenue by gathering affiliates who wants to get money by advertising other sites. Especially, it is characterized that it pays advertisement fees only when real performances that merchants want occurred.



## 2. Import Linkprice library

### 2.1 CocoaPod

Add 'LPMobileAT' in Podfile then install pod

```
pod 'LPMobileAT'
```

### 2.2 Add bridge header file

- LPMobileAT.framework is Objective-C so you should make bridege header file. 
- Make <projectName-Bridging-Header.h> file then add below.

```swift
#import <LPMobileAT/LPMobileAT.h>
```

## 3. Universal Link

> When customer clicks link, if there is App in coutomer's phone, it opens App. If not, it goes to Google Play store or specific page



### 3.1 Associated Link 

- If you want to open app with URL or use deep link in iOS, you should set below. 
- Universal Link works with only **https**

1. Turn on Associated link and register domain.

![Universal Link setting](https://github.com/linkprice/MerchantSetup/blob/master/App/Lpmat_iOS/01.png)

2. Check domain in entitlements file

![Check domain](https://github.com/linkprice/MerchantSetup/blob/master/App/Lpmat_iOS/02.png)

3. Add AASA(apple-app-site-association) file

- AASA should be in root of website or ./well-known directory.
  - EX
    - https://example.com/app-app-site-association
  - https://example.com/.well-known/app-app-site-association

```json
{
  "applinks": {
    "apps": [],
    "details": [
    {
      "appID": "{team ID}.{bundle ID}",
      "paths": ["*"]
    }
    ]
  }
}
```

- appID: Format is {team ID}.{Bundle ID}
  - You can check your team ID in [Apple developer center](https://developer.apple.com/membercenter) 

### 3.2 AppDeletegate.swift

```swift
/*
EX1) product detail page
PC target_url: www.linkprice.com/clickbuy/product-detail.php?pid=2342134&show=AHFSD 
Mobile target_url: m.linkprice.com/shop/product?pid=2342134

EX2) search page
PC target_url:  www.linkprice.com/clickbuy/search-result.php?keyword=%EA%B2%80%EC%83%89%EC%96%B4
Mobile target_url:  m.linkprice.com/search?keyword=%EA%B2%80%EC%83%89%EC%96%B4

*/


//for iOS >= 9.2 (Universal Link)
func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

  if(userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
  	return self.handleDeepLink(url: userActivity.webpageURL! as NSURL)
  }

	return true
}

private func handleDeepLink(url: NSURL) -> Bool {
  //track deep link
  LPMobileAT.applicationDidOpen(url as URL!)
    
  // implement deeplink here
  guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
        let incomingURL = userActivity.webpageURL
        let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true)
        let path = components.path
    	let host = components.host
        let params = components?.queryItems
        
    if ((host == "www.linkprice.com" && path == "/clickbuy/product-detail.php") || (host == "m.linkprice.com" && path =="/shop/product")) {
  
         let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let productDetail = mainStoryboard.instantiateViewController(withIdentifier: "productDetailViewController") as! productDetailViewController
        let navigationController = self.window?.rootViewController as! UINavigationController
        
        productDetail.pid = params.first(where: { $0.name == "pid" } )
        navigationController.pushViewController(productDetail, animated: false)
    
        return true
        
    } else if((host == "www.linkprice.com" || path == "/clickbuy/search-result.php") || (host == "m.linkprice.com" && path = "/search")) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let searchResult = mainStoryboard.instantiateViewController(withIdentifier: "searchResultViewController") as! productDetailViewController
        let navigationController = self.window?.rootViewController as! UINavigationController
        
        productDetail.keyword = params.first(where: { $0.name == "keyword" } )
        navigationController.pushViewController(searchResult, animated: false)
        
        return  true
    }  
   
  return true
}
```

### 3.3 Initialize SDK

Add code that call API in AppDelegate.swift

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    LPMobileAT.initialize
    
    return true
}
```



## 4. Send sales data

### 4.1 If you send sales data in S2S(Server to Server)

1.  If you already send sales data in S2S(Server to Server) for CPS, you should not send data.
2. If lpinfo(click information) is not in server, you can send lpinfo from app to server.

```Swift
// Get lpinfo(click info)
LpMobileAT.getLpinfo
```

### 4.2 If you send sales data in client side

1. If you send sales data in client side for CPS, you should send it in App 

#### 4.2.1 Send saels data for CPS

```swift
LPMobileAT.trackEvent(LPEventType.CPS,
          withValues: [
              "order": [
                "order_id": "o190203-2323213",
                "final_paid_price": 32000,
                "currency": "KRW",
                "user_name": "user"
            ],
            "products": [
                [
                    "product_id": "P87-234-anx87",
                    "product_name": "test",
                    "category_code": "132782",
                    "category_name": ["test1", "test2", "test3"],
                    "quantity": 2,
                    "product_final_price": 14000,
                    "paid_at": "2019-02-12T11:13:44+00:00",
                    "confirmed_at": "",
                    "canceled_at": ""
                ],
                [
                    "product_id": "P23-983-Z3272",
                    "product_name": "test product",
                    "category_code": "237018",
                    "category_name": ["test4", "test5", "test6"],
                    "quantity": 3,
                    "product_final_price": 18000,
                    "paid_at": "2019-02-12T11:13:44+00:00",
                    "confirmed_at": "",
                    "canceled_at": ""
                ]
            ],
            "linkprice": [
                "merchant_id": "clickbuy",
                "user_agent": "Mozilla/5.0...",
                "remote_addr": "127.0.0.1"
            ]
        ])
           
```

- If there in no user agent, send null for user agent

- Check "product_final_price" in link below, if you use coupon.

  [product_final_price](<https://github.com/linkprice/MerchantSetup/blob/master/CPS/README.md#final_paid_price>)

- Check detail of CPS data in link below.

  [CPS data](https://github.com/linkprice/MerchantSetup/blob/master/CPS/README-en.md)

#### 4.2.2 Send saels data for CPA

```swift
LPMobileAT.trackEvent(LPEventType.CPA,
          withValues: [
              "action": [
                    "unique_id": "10002356",
                    "final_paid_price": 0,
                    "currency": "KRW",
                    "member_id": "exampleId",
                    "action_code": "free_101",
                    "action_name": "free join",
                    "category_code": "register"
                ],
                "linkprice": [
                    "merchant_id": "clickbuy",
                    "user_agent": "Mozilla/5.0...",
                    "remote_addr": "127.0.0.1",
                ]
        ])
           
```

- There is daily limitaion for IP(3times) so if you do not send real IP for user, it can occur problem.

- Check detail of CPA data in link below.

  [CPA data](https://github.com/linkprice/MerchantSetup/blob/master/CPA/README-en.md)

#### 4.2.3 Send saels data for CPI

```swift
 /* CPI sending data
  * param1: merchant ID 
  * ua: user agent information
  * remoteAddr: user remote address
 */ 
LPMobileAT.autoCpi("clickbuy", ua: "User Agent", remoteAddr: "127.0.0.1")
```

* There is daily limitaion for IP(3times) so if you do not send real IP for user, it can occur problem.

