## 제휴 마케팅이란

> 제휴 마케팅이란 제품/ 서비스 등을 판매하는 인터넷 업체(Merchant)가 고객을 끌어들이고 진열, 판매하는 공간으로 자신의 사이트 뿐만 아니라 다른 관련 사이트(Affiliate)로 까지 공간을 확장하여 
> 이때 발생하는 수입을 제휴맺은 사이트(Affiliate)와 공유하는 새로운 형태의 마케팅 기법입니다.
>
> [제휴 마케팅 소개](https://helpdest.linkprice.com/pages/merchant-faq-introduce)



### 1. 웹 셋업 개요 

![ex_screenshot](https://github.com/linkprice/MerchantSetup/blob/master/App/v2_web_setup_process_img.png?raw=true)

1) 링크프라이스 배너 클릭

2) 링크프라이스에서 광고주 게이트웨이 페이지에 LPINFO (쿠키)생성에 필요한 값과 목적페이지 URL 전달

3) device_type에 따라서 PC웹 또는 모바일웹 목적페이지로 이동

4) 상품구매 

5) 상호 대조를 위해 광고주 DB에 실적 데이터 보관

6) 링크프라이스로 구매 실적 전송, 데일리픽스 및 자동취소 정보 제공 
([V4버전 웹 셋업 가이드](https://github.com/linkprice/MerchantSetup/tree/master/CPS) 참조)



### 1. APP 셋업 개요 

![ex_screenshot](https://github.com/linkprice/MerchantSetup/blob/master/App/v2_app_setup_process_img.png?raw=true)

1) 링크프라이스 배너 클릭

2) 링크프라이스에서 광고주 게이트웨이 페이지에 LPINFO (쿠키)생성에 필요한 값과 목적페이지 URL 전달

- 배너 클릭시마다 변경되는 LPINFO의 last값을 저장합니다. 

3) device_type에 따라 웹 또는 앱 목적페이지로 이동

​	3-2) 앱 미설자인 경우 

- 모바일 웹 목적페이지로 이동 해야 합니다. 

		3-3) 앱 설치자인 경우 

- 광고주 앱의 목적페이지로 앱이 오픈 되어야 합니다. 
- 목적페이지는 어필리에이트의 사용자 정의 링크(deep link)생성에 따라 메인페이지, 특정 상품페이지, 이벤트 페이지 등으로 변경됩니다. 
- 타사 앱(카카오톡 / 네이버 / 다음 / 밴드 / 페이스북 / 크롬 / 인터넷 / 사파리 / 매체사 앱 등…)에서 배너를 클릭 한 경우 광고주 앱의 목적페이지로 앱이 오픈 되어야 합니다. 
- 오류 페이지로 이동하지 않도록 주의해주세요.

4) 상품구매 

5) 상호 대조를 위해 광고주 DB에 실적 데이터 보관

6) 링크프라이스로 구매 실적 전송 , 데일리픽스, 자동 실적 취소 작업 ([V4버전 웹 셋업 가이드](https://github.com/linkprice/MerchantSetup/tree/master/CPS) 참조)
