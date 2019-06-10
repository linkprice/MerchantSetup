# DeepLink Setup

> URL 클릭시 앱이 설치 되어 있는 경우 앱으로 열리고, 앱이 설치 되어 있지 않은 경우 특정 페이지로 redirection 시키는 방법에 대해 설명합니다.



## 1. AndroidManifest.xml

* 귀사의 앱의 AndroidManifest.xml 파일에서 실행하고자 하는 Activity 아래에 intent-filter를 선언합니다. 
* 예를 들어, 귀사의 게이트웨이 페이지의 URL이 "https://gw.linkprice.com/gateway/lpfront.php" 일때,
    아래와 같이 선언 하여 줍니다.

```xml
<activity android:name="SampleActionActivity">
	<intent-filter android:autoVerify="true">
		<action android:name="android.intent.action.VIEW"/>
		<category android:name="android.intent.category.DEFAULT"/>
		<category android:name="android.intent.category.BROWSABLE"/>
		<data android:host="gw.linkprice.com" android:scheme="https"/>
	</intent-filter>
</activity>
```

* \<data\> 설명
    1. **android:host**: 게이트웨이 페이지의 host 부분을 선언합니다.
    2. **android:scheme**: 게이트웨이 페이지의 scheme(일반적으로 http나 https) 을 선언합니다.



## 2. 게이트웨이 페이지 수정

* user-agent의 값으로부터 계산하여 android일 경우, 아래의 형식으로 url을 생성하여, 이 url로 redirect 한다, sample url

```
intent://gw.linkprice.com?lpinfo=A100000131|2600239200004E|0000|B|1&target_url=https://www.linkprice.com/path/page?pid=17234#Intent;scheme=https;package=com.linkprice.test-app;S.browser_fallback_url=https://www.linkprice.com/your_path/?param=values;end
```

* 각 변수 설명

  1. **https** 게이트웨이 페이지의 scheme: 일반적으로 http나 https 입니다

  2.  **gw.linkprice.com**  게이트웨이 페이지의 host: 게이트웨이 페이지의 host 부분만 추출합니다

  3. **lpinfo=A100000131|2600239200004E|0000|B|1 ** 링크프라이스가 게이트웨이 페이지로 넘길 때 같이 넘긴 lpinfo의 값

  4. **target_url=https://www.linkprice.com/path/page?pid=17234**  링크프라이스가 게이트웨이 페이지로 넘길 때 같이 넘긴 target_url의 값

  5.  **com.linkprice.test-app** 귀사의 Android APP의 package name
  
  6. **https://www.linkprice.com/your_path/?param=values** 만일 앱이 설치 되어 있지 않을 경우 redirection할 URL


![](https://github.com/linkprice/MerchantSetup/blob/master/%EC%95%B1%20%EC%85%8B%EC%97%85/%EB%94%A5%EB%A7%81%ED%81%AC/deeplink.png)
