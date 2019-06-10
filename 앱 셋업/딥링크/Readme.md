# DeepLink Setup

> URL 클릭시 앱이 설치 되어 있는 경우 앱으로 열리고, 앱이 설치 되어 있지 않은 경우 특정 페이지로 redirection 시키는 방법에 대해 설명합니다.



## 1. Mainfest

```xml
<intent-filter android:autoVerify="true">
   <action android:name="android.intent.action.VIEW"/>
   <category android:name="android.intent.category.DEFAULT"/>
   <category android:name="android.intent.category.BROWSABLE"/>
   <data android:host="gw.linkprice.com" android:scheme="https"/>
</intent-filter>
```





## 2. 게이트웨이 페이지 수정

* user-agent의 값으로부터 계산하여 android일 경우, 아래의 형식으로 url을 생성하여, 이 url로 redirect 한다, sample url

```html
intent://gw.linkprice.com?lpinfo=A100000131%7C2600239200004E%7C0000%7CB%7C1 #Intent;scheme=https;package=com.linkprice.test- app;S.browser_fallback_url=https://www.linkprice.com/your_path/?param=values;end
```

* 각 변수 설명

  1 **https** 게이트웨이 페이지의 scheme: 일반적으로 http나 https 입니다

  2 **gw.linkprice.com**  게이트웨이 페이지의 host: 게이트웨이 페이지의 host 부분만 추출합니다

  3 **lpinfo=A100000131%7C2600239200004E%7C0000%7CB%7C1** 링크프라이스가 게이트웨이 페이지로 넘긴 lpinfo의 값

  4 **com.linkprice.test-app** 귀사의 Android APP의 package name

  5 **https://www.linkprice.com/your_path/?param=values** 만일 앱이 설치 되어 있지 않을 경우 redirection할 URL
  
  

![](C:\Users\LG\Documents\카카오톡 받은 파일\deeplink-explain.png)