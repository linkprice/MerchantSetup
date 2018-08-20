# CPA 간편 셋업 가이드 

* 아래와 같이 스크립트(script)를 추가하면 연동이 완료됩니다. 



## **스크립트(script) 추가 방법** 

```html
  <!-- Google Tag Manager -->
  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
  new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
  j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
  'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
  })(window,document,'script','dataLayer','GTM-P3HTV4');</script>
  <!-- End Google Tag Manager -->
```

* 위의 스크립트는 **예제**이며, 실제 스크립트는 링크프라이스에서 전달드립니다.
* 웹페이지 레이아웃 공통 header 부분. 즉, `<head>` 에서 가능한 한 높은 위치에 코드를 붙여 넣습니다.
* 공통 header 가 존재하지 않을시, index 페이지 및 회원가입 완료 페이지에 <head> 에서 가능한 한 높은 위치에 위의 코드를 붙여 넣습니다.

