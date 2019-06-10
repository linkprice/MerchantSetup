# Android DeepLink Setup

> This is how to set when user clicks link, open App if app is installed without setting default app through deeplink.



## 1. AndroidManifest.xml

* Set intent-filter under Activity you want run in AndroidManifest.xml
* For example, If your gateway URL is "https://gw.linkprice.com/gateway/lpfront.php" ,
    set intent-filter blow.

```xml
<activity android:name="SampleActionActivity">
	<intent-filter ...>
		<action android:name="android.intent.action.VIEW"/>
		<category android:name="android.intent.category.DEFAULT"/>
		<category android:name="android.intent.category.BROWSABLE"/>
		<data android:host="gw.linkprice.com" android:scheme="https"/>
	</intent-filter>
</activity>
```

* \<data\> Explain
    1. **android:host**: Set gateway host part.
    2. **android:scheme**: Set scheme of gateway.(Generally http or https) 



## 2. Modify Gateway

* Detect Android with user-agent then make redirection URL with format below and redirect.
* Sample URL

```
intent://gw.linkprice.com?lpinfo=A100000131|2600239200004E|0000|B|1&target_url=https://www.linkprice.com/path/page?pid=17234#Intent;scheme=https;package=com.linkprice.test-app;S.browser_fallback_url=https://www.linkprice.com/your_path/?param=values;end
```

* Prameters

  1. **https** is scheme of gateway: Generally scheme is https or http.

  2.  **gw.linkprice.com**  is host of gateway: Need only host part of gateway

  3. **lpinfo=A100000131|2600239200004E|0000|B|1** is "lpinfo" value from linkprice.

  4. **target_url=https://www.linkprice.com/path/page?pid=17234**  is "target_url " value from linkprice.

  5.  **com.linkprice.test-app** is your package name of Android APP
  
  6. **https://www.linkprice.com/your_path/?param=values** is redirection URL to redirect if your app is not installed in user phone


![](https://github.com/linkprice/MerchantSetup/blob/master/App/DeepLink/deeplink-en.png)

