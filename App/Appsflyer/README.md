## Appsflyer 셋업 가이드

1. 앱 설치 시 클릭주소 생성: 파트너(매체)에 전달 정보

   *  Media Source Configuration 메뉴에서 기본으로 사용하는 Integration Parameters를 그대로 사용함
   * 참조: [Integrated-Media-Source-Partner-Configuration]([Integrated-Media-Source-Partner-Configuration](https://support.appsflyer.com/hc/en-us/articles/207033816-Integrated-Media-Source-Partner-Configuration))

   ![1536811824140](https://github.com/linkprice/MerchantSetup/blob/master/App/Appsflyer/appsflyer1.png)

2. 앱 In-App 이벤트 클릭주소 생성: 예-회원가입, 문의하기, 상품 구매 등

   * 광고주 관리화면에서 인앱 이벤트 시 다음과 같은 정보가 링크프라이스에 전달되도록 설정합니다. (설치 이외의 다른 이벤트에 대해서 앱이 전달이 가능할 경우)
   * 설정방법: SDK Event 이름 그대로 LinkPrice Event Tag에 기입하고, Send Value에 체크표시 합니다.
   * 참조
     * [In-App-Events-Overview](https://support.appsflyer.com/hc/en-us/articles/207031986-In-App-Events-Overview)(인앱 이벤트 개요)
     * [Available-Macros-on-AppsFlyer-s-Postbacks](https://support.appsflyer.com/hc/en-us/articles/207273946-Available-Macros-on-AppsFlyer-s-Postbacks)(인앱 이벤트 발생 시 전달하는 값)

   ![1536812060663](https://github.com/linkprice/MerchantSetup/blob/master/App/Appsflyer/appsflyer3.png)

   * 회원가입일 경우

     | 파라미터  |     설명     |
     | :-------: | :----------: |
     | af_mbr_id | 회원 아이디  |
     |  af_o_cd  | 가입고유번호 |

   * 주문결제일 경우

     | 파라미터  |            설명            |
     | :-------: | :------------------------: |
     | af_mbr_id |        회원 아이디         |
     |  af_o_cd  |       주문 고유번호        |
     |  af_p_cd  |          상품코드          |
     | af_it_cnt |       상품 구매 개수       |
     |  af_c_cd  | 카테고리 코드(없으면 빈칸) |
     |  af_p_nm  |         상품 이름          |

     ※ 위와 다른 파라미터를 사용하신다면, 해당 파라미터 정보를 링크프라이스에 전달 바랍니다.
     위의 내용이 없으시면 위와 같은 파라미터 이름으로 추가 작업 해주시면 됩니다.
   
3. 딥링크

   * 딥링크 사용 및 설정을 위하여 아래의 링크를 확인 해 주세요.

       [딥링크]([https://support.appsflyer.com/hc/ko/articles/207032126-AppsFlyer-SDK-%EC%97%B0%EB%8F%99-%EC%95%88%EB%93%9C%EB%A1%9C%EC%9D%B4%EB%93%9C#5-%EB%94%A5-%EB%A7%81%ED%82%B9-%ED%8A%B8%EB%9E%98%ED%82%B9](https://support.appsflyer.com/hc/ko/articles/207032126-AppsFlyer-SDK-연동-안드로이드#5-딥-링킹-트래킹)) 
