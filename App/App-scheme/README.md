# 앱 스킴 방식을 활용한 앱 연동 게이트웨이 페이지 예시

광고주 앱 연동 작업시 Google Tag Manager(GTM)를 사용할 경우 앱 랜딩이 원활하게 진행이 되지 않을 수 있습니다.

다음과 같은 예시를 참고하여 게이트웨이를 작성해주시면 되겠습니다.

> 게이트웨이(페이지)란 트래킹 코드를 심고 광고주 앱 혹은 웹으로 리다이렉션하는 페이지를 의미합니다.

## 앱 스킴 방식을 활용한 앱 연동

1. 사용자가 제휴링크(배너)를 클릭하면 링크프라이스를 거쳐 광고주 게이트웨이 페이지로 리다이렉션 됩니다.

   > 이 때 게이트웨이 페이지에 LPINFO값과 URL값을 전달합니다.
   > 
   > 예) https://gateway.com/linkprice.html?lpinfo=A100000131%7C281221243qvx7d%7C0000%7CB%7C1&url=https%3A%2F%2Fmerchantsite.com%2F 

2. 광고주 웹으로 리다이렉션 하기전 앱으로 이동하기 위한 앱 스킴을 실행합니다.

3. 앱 스킴 실행 이후 일정 시간이 지나면, 해당 게이트웨이 페이지에서 웹 페이지로 랜딩 및 쿠키 생성이 되도록 처리합니다.

   > **앱 미설치자**
   > * 앱 스킴 호출이 실패하였으므로 기존에 전달된 LPINFO와 URL을 활용하여 LPINFO 쿠키 생성과 URL 랜딩을 진행하면 됩니다.
   >
   > **앱 설치자**
   > * 앱 스킴 호출을 하여 앱을 실행합니다. 이때 앱 내에 LPINFO 쿠키의 광고효과 인정기간 만큼 앱에 유지하도록 설정해주셔야합니다.
   >
   > **앱 스킴 호출 방식 단점**
   > * 앱 설치 여부를 판단하지 못하는 단점이 있습니다. 따라서 호출 이후 일정 시간이 지나면 웹 페이지로 진행하게끔 처리 합니다.

4. 링크프라이스에서는 전달받은 게이트웨이 URL을 내부 플랫폼에 반영한 이후, 제휴 링크를 생성하여 전달드립니다.

   > 최종적으로 다음 URL로 매체에서는 홍보 활동을 진행합니다.
   > 
   > 샘플 URL로 실제 URL과는 다릅니다.
   > 
   > https://click.linkprice.com/click.php?m=clickbuy&a=A100000131&l=0000

5. 제휴 링크로 진입하고 설치된 기기가 광고주 앱으로 이동 후 실적 전송 테스트시 정상적으로 되는지 확인합니다.

## 게이트웨이 페이지 예시 1

앱 스킴을 통해 앱 내부에서 게이트웨이로 랜딩되어 최종적으로 LPINFO 쿠키 생성과 URL 랜딩을 처리합니다.

```html
<script>
    // example: https://gateway.com/linkprice.html?lpinfo=A100000131%7C281221243qvx7d%7C0000%7CB%7C1&url=https%3A%2F%2Fmerchantsite.com%2F
   
    // 파라미터 LPINFO 값과 URL 값을 가져옵니다.
    var params = new URLSearchParams(window.location.search);
    var lpinfo = params.get('lpinfo');
    var url = params.get('url');
    
    /**
     * 모바일 URL과 앱 스킴 URL을 선언합니다.
     * 앱 스킴 URl은 광고주 앱스킴 URL을 적용하시면 됩니다.
     */    
    var mobileDomainUrl = "https://m.merchantsite.com";
    var AppSchemeUrl = "app://open?url=";

    /**
     * 모바일 도메인과 앱스킴 URL에 LPINFO값과 URL값을 전달합니다.
     * 앱을 실행할 경우 모바일 도메인 페이지와 LPINFO URL을 활용하여 쿠키 생성을 합니다. 
     */
    var rtnUrl = AppSchemeUrl + encodeURIComponent(mobileDomainUrl + "/advertisement/linkPriceBridge?lpinfo=" + encodeURIComponent(lpinfo) + "&url=" + encodeURIComponent(url));
    var rtnUrl2 = mobileDomainUrl + "/advertisement/linkPriceBridge?lpinfo=" + encodeURIComponent(lpinfo) + "&url=" + encodeURIComponent(url );
    
    if (lpinfo && url) {
        if (isMobile()) {
            var ua = navigator.userAgent.toLowerCase();
            var isIos = /iphone|ipad/.test(ua);
            var isAndroid = /android/.test(ua);
            var isChrome = /chrome/.test(ua);
            var isCrios = /crios/.test(ua);
            var appCheckTimer;

            function preventPopup() {
                clearTimeout(appCheckTimer);
                appCheckTimer = null;
                window.removeEventListener('pagehide', preventPopup);
            }

          /**
           * setTimeout 함수로 앱스킴 URL을 먼저 실행 후
           * 일정 시간이 지나면 모바일 도메인 URL을 처리합니다.
           */
            function runApp() {
                var clickedAt = +new Date;
                appCheckTimer = setTimeout(function () {
                    if (+new Date - clickedAt < 3000) {
                        if (isIos && isCrios) {
                            window.location.replace(rtnUrl2);
                        } else {
                            window.location.replace(rtnUrl2);
                        }
                    } else {
                        window.close();
                    }
                }, 1500);
                window.location.href = rtnUrl;
                window.addEventListener('pagehide', preventPopup);
            }
            runApp();
        } else {
            // LPINFO 쿠키값은 광고효과인정 기간만큼 적용해주시면 됩니다.
            setCookie("LPINFO", lpinfo, 20);
            window.location.replace(url);
        }
    }

    /**
     * (LPINFO) 쿠키 생성 함수
     * 모바일 페이지가 따로 있을 경우 도메인값을 적용해주시면 됩니다 ex) domain=.domain.com
     */
    function setCookie(name, value, exp) {
        var date = new Date();
        date.setTime(date.getTime() + exp * 24 * 60 * 60 * 1000);
        document.cookie = name + '=' + value + ';expires=' + date.toUTCString() + ';path=/';
    }
</script>
```

모바일 웹 및 앱에서 LPINFO 쿠키 생성과 URL 랜딩을 위한 페이지 `/advertisement/linkPriceBridge`

```html
<script>
    var params = new URLSearchParams(window.location.search);
    var lpinfo = params.get('lpinfo');
    var url = params.get('url');

    var mobileDomainUrl = "https://m.merchantsite.com";

    if (lpinfo && url) {
        setCookie("LPINFO", lpinfo, 20);
        location.replace(url);
    }

    function setCookie(name, value, exp) {
        var date = new Date();
        date.setTime(date.getTime() + exp * 24 * 60 * 60 * 1000);
        document.cookie = name + '=' + value + ';expires=' + date.toUTCString() + ';path=/';
    }
</script>
```

### 게이트웨이 페이지 예시 2
첫번째 예시와 동일하게 앱 내부에서 게이트웨이 페이지를 실행하여 LPINFO 쿠키 생성과 URL 랜딩을 처리합니다.

다른 점은 iOS와 AOS를 구분하여 앱 스킴을 실행합니다.

```html
<script>
   // example: https://gateway.com/linkprice.html?lpinfo=A100000131%7C281221243qvx7d%7C0000%7CB%7C1&url=https%3A%2F%2Fmerchantsite.com%2F

   /*
    * 앱 스킴 이름, 안드로이드 패키지 네임, 딥링크, 앱링크를 선언합니다.
    * 앱 스킴 이름과 안드로이드 패키지 네임은 광고주 앱에 맞게 설정해주시면 됩니다.
    */

   var scheme = window.location.hostname === 'appscheme' ? 'appscheme' : 'appscheme';
   var android_package_name =
           window.location.hostname === 'package.name' ? 'package.name' : 'package.name';

   var deep_link = 'open/page?url=' + encodeURIComponent(window.location.href);
   var app_link = scheme + '://' + deep_link;

   /*
    * 앱 내부 여부를 판단하기 위해 선언합니다.
    * 내부 유저에이전트 값은 광고주 앱에 따라 설정하시면 됩니다.
    */
   var in_app = /App\/([0-9.]*)/.test(navigator.userAgent);

   // 인앱, 웹뷰의 경우 저희가 의도하지 않은 설치페이지로 이동하는 경우가 있어 예외처리 해야할 수 있습니다.
   var in_third_app = navigator.userAgent.match(
           /inapp|NAVER|KAKAOTALK|Snapchat|Line|WirtschaftsWoche|Thunderbird|Instagram|everytimeApp|WhatsApp|Electron|wadiz|AliApp|zumapp|iPhone(.*)Whale|Android(.*)Whale|kakaostory|band|twitter|DaumApps|DaumDevice\/mobile|FB_IAB|FB4A|FBAN|FBIOS|FBSS|SamsungBrowser\/[^1]/i,
   );

   // iOS, AOS를 판단하기위한 값입니다.
   var iOS =
           (!window.MSStream && /iPad|iPhone|iPod/.test(navigator.userAgent)) ||
           (navigator.userAgent.includes('Mac') && 'ontouchend' in document);
   var android = /android/i.test(navigator.userAgent);

   var fallback_run = false;
   function fallback() {
      if (fallback_run) {
         return;
      }
      fallback_run = true;
      var params = new URLSearchParams(window.location.search);
      var param_lpinfo = params.get('lpinfo');
      var param_url = params.get('url');
      setCookie("LPINFO", param_lpinfo, 20);
      location.replace(param_url);
   }

   // 앱 내부, 인앱(혹은 웹뷰) 일 경우 LPINFO 쿠키와 URL 랜딩을 바로 처리
   if (in_app || in_third_app) {
      fallback();
   } else if (android) {
      setTimeout(() => fallback(), 1000);
      try {
         // android intent의 경우 S.browser_fallback_url을 작업 중인 게이트웨이 URL로 설정해주시기 바랍니다.
         window.location.href =
                 'intent://' + deep_link + '#Intent;scheme=' + scheme + ';package=' + android_package_name + ';end';
      } catch (e) {
         fallback();
      }
   } else if (iOS) {
      setTimeout(() => fallback(), 300);
      try {
         window.location.href = app_link;
      } catch (e) {
         fallback();
      }
   } else {
      fallback();
   }

   /**
    * (LPINFO) 쿠키 생성 함수
    * 모바일 페이지가 따로 있을 경우 도메인값을 적용해주시면 됩니다 ex) domain=.domain.com
    */
   function setCookie(name, value, exp) {
      var date = new Date();
      date.setTime(date.getTime() + exp * 24 * 60 * 60 * 1000);
      document.cookie = name + '=' + value + ';expires=' + date.toUTCString() + ';path=/';
   }
</script>
```