# 유니버셜 링크 (ios)


## 1. 웹 사이트에 연결 된 도메인 파일 추가
> 참고 링크 : https://developer.apple.com/documentation/Xcode/supporting-associated-domains?language=objc

* 연결 된 도메인 파일을 웹 사이트에 추가하려면 apple-app-site-association 확장명 없이 이름이 지정된 파일을 만듭니다.
* 도메인에서 지원하는 서비스에 대한 파일의 JSON 코드를 업데이트 합니다.

```json
{
  "applinks": {
      "details": [
           {
             "appIDs": [ "ABCDE12345.com.example.app", "ABCDE12345.com.example.app2" ],
             "components": [
               {
                  "#": "no_universal_links",
                  "exclude": true,
                  "comment": "Matches any URL with a fragment that equals no_universal_links and instructs the system not to open it as a universal link."
               },
               {
                  "/": "/buy/*",
                  "comment": "Matches any URL with a path that starts with /buy/."
               },
               {
                  "/": "/help/website/*",
                  "exclude": true,
                  "comment": "Matches any URL with a path that starts with /help/website/ and instructs the system not to open it as a universal link."
               },
               {
                  "/": "/help/*",
                  "?": { "articleNumber": "????" },
                  "comment": "Matches any URL with a path that starts with /help/ and that has a query item with name 'articleNumber' and a value of exactly four characters."
               }
             ]
           }
       ]
   },
   "webcredentials": {
      "apps": [ "ABCDE12345.com.example.app" ]
   },

    "appclips": {
        "apps": ["ABCED12345.com.example.MyApp.Clip"]
    }
}
```


### 1-1. 앱에 연결된 도메인 권한 추가

* 자격에 도메인을 추가하려면 도메인 테이블 하단에 있는 추가(+)를 클릭하여 자리표시자 도메인을 추가합니다.
* 자리 표시자를 앱이 지원하는 서비스 및 사이트 도메인에 대한 적절한 접두사로 바꿉니다. 원하는 하위 도메인과 최상위 도메인만 포함해야 합니다.

![ex_screenshot](https://github.com/linkprice/MerchantSetup/blob/master/App/AppSetup/Untitled_1.png?raw=true)

* 지정하는 각 도메인은 다음 형식을 사용
```xml
<service>:<fully qualified domain>
```
* 앱을 개발하는 동안 공용 인터넷에서 웹 서버에 연결할 수 없는 경우 대체 모드 기능을 사용하여 CDN을 우회하고 개인 도메인에 직접 연결할 수 있습니다.
* 다음과 같이 연결된 도메인의 자격에 쿼리 문자열을 추가하여 대체 모드를 활성화합니다.
```xml
<service>:<fully qualified domain>?mode=<alternate mode>
```




## 2. 스킴 등록
> 참고 링크 : https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app?language=objc

![ex_screenshot](https://github.com/linkprice/MerchantSetup/blob/master/App/AppSetup/Untitled_2.png?raw=true)

* 프로젝트 설정의 정보 탭에서 Xcode에 체계를 등록
  1. URL 구성표 상자에서 URL에 사용할 접두사 지정
  2. 앱의 역할 선택, 정의한 URL 체계에 대한 편집자 역할 또는 정의하지 않은 체계에 대한 뷰의 역학
  3. 앱의 식별자 지정
  



## 3. 범용 링크에 응답하도록 앱 위임 업데이트
> 참고 링크 : https://developer.apple.com/documentation/xcode/supporting-universal-links-in-your-app?language=objc

```swift
// macOS에서 범용 링크를 처리하는 방법 예제 코드
func application(_ application: NSApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool
{
    // Get URL components from the incoming user activity.
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
        let incomingURL = userActivity.webpageURL,
        let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
        return false
    }

    // Check for specific URL components that you need.
    guard let path = components.path,
    let params = components.queryItems else {
        return false
    }    
    print("path = \(path)")

    if let albumName = params.first(where: { $0.name == "albumname" } )?.value,
        let photoIndex = params.first(where: { $0.name == "index" })?.value {            
        print("album = \(albumName)")
        print("photoIndex = \(photoIndex)")
        return true  

    } else {
        print("Either album name or photo index missing")
        return false
    }
}

// ios에서 범용 링크를 처리하는 방법 에제코드
func application(_ application: UIApplication,
                 continue userActivity: NSUserActivity,
                 restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
{
    // Get URL components from the incoming user activity.
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
        let incomingURL = userActivity.webpageURL,
        let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true) else {
        return false
    }

    // Check for specific URL components that you need.
    guard let path = components.path,
    let params = components.queryItems else {
        return false
    }    
    print("path = \(path)")

    if let albumName = params.first(where: { $0.name == "albumname" } )?.value,
        let photoIndex = params.first(where: { $0.name == "index" })?.value {

        print("album = \(albumName)")
        print("photoIndex = \(photoIndex)")
        return true

    } else {
        print("Either album name or photo index missing")
        return false
    }
}
```




## 4. 다른 앱과의 통신
> 참고 링크 : https://developer.apple.com/documentation/xcode/allowing-apps-and-websites-to-link-to-your-content?language=objc

* 범용 링크를 사용하면 사용자가 Safari 및 에서 웹사이트 링크를 클릭 할 때, 그리고 다음에 대한 호출로 이어지는 링크를 클릭할 때 앱이 열립니다 .
* URL 쿼리 문자열 내에서 앱이 처리하는 매개변수를 정의합니다.
* 도메인, 경로 및 매개변수를 기반으로 URL을 만들고 앱에서 다음을 호출하여 URL을 열도록 요청합니다.


### 4-1. 사진 라이브러리 앱에 대한 예제 코드

* 앨범이름과 표시할 사진 색인을 포함하는 매개변수 지정

```
https://myphotoapp.example.com/albums?albumname=vacation&index=1
https://myphotoapp.example.com/albums?albumname=wedding&index=17
```


### 4-2. 범용링크 호출 예제 코드

```swift
// macOS 에서 범용링크 호출 예제코드
if let appURL = URL(string: "https://myphotoapp.example.com/albums?albumname=vacation&index=1") {
    let configuration = NSWorkspace.OpenConfiguration()
    NSWorkspace.shared.open(appURL, configuration: configuration) { (app, error) in
        guard error == nil else {
            print("The URL failed to open.")
            return
        }
        print("The URL was delivered successfully.")
    }
} else {
    print("Invalid URL specified.")
}

// ios에서 범용링크 호출 예제코드
if let appURL = URL(string: "https://myphotoapp.example.com/albums?albumname=vacation&index=1") {
    UIApplication.shared.open(appURL) { success in
        if success {
            print("The URL was delivered successfully.")
        } else {
            print("The URL failed to open.")
        }
    }
} else {
    print("Invalid URL specified.")
}
```
