## Adbrix 셋업 가이드

* 애드브릭스 제공 가이드: [광고성과 측정 : 트래킹 링크 등록(1) - 기본](http://help.igaworks.com/hc/ko/3_3/Content/Article/add_trackinglink)

* 애드브릭스에서 제공하는 가이드에 따라 진행을 하되 1, 3 단계를 아래와 같이 설정합니다.



1. 채널 선택

   * 채널명을 링크프라이스로 검색한 후 선택합니다.

   ![1536812627740](https://github.com/linkprice/MerchantSetup/blob/master/App/Adbix/adbrix1.png)



3. 고급 설정
   * 회원가입일 경우
     * 이벤트 타입 : 커스텀 이벤트 (Retention)
     * 이벤트 이름 : member
     * 애드브릭스 API 연동 시 포스트백으로 activity_param 매크로 파라미터에 회원 아이디를 입력합니다.
   * 주문결제일 경우
     * 이벤트 타입 : Purchase



* 위와 같이 설정하여 발급한 트래킹 링크를 링크프라이스에 전달합니다

![adbrix](https://github.com/linkprice/MerchantSetup/blob/master/App/Adbix/adbrix3.png)
