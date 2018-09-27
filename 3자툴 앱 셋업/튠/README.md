## TUNE 셋업 가이드

1. 파트너사 등록
   * Attribution Analytics -> PARTNERS -> Intergrated Partners 에서 'linkprice' 검색

![1536805653521](https://github.com/linkprice/MerchantSetup/blob/master/3%EC%9E%90%ED%88%B4%20%EC%95%B1%20%EC%85%8B%EC%97%85/%ED%8A%A0(TUNE)/tune1.png)



2. Measurement URLs 생성

   * Attribution Analytics -> PARTNERS -> Measurement URLs 생성

   ![1536805710808](https://github.com/linkprice/MerchantSetup/blob/master/3%EC%9E%90%ED%88%B4%20%EC%95%B1%20%EC%85%8B%EC%97%85/%ED%8A%A0(TUNE)/tune3.png)

   * Select your App 에서 연동 할 앱 선택
   * Select your Partner 에서 LinkPriceCo. ltd. 선택

   ![1536805792200](https://github.com/linkprice/MerchantSetup/blob/master/3%EC%9E%90%ED%88%B4%20%EC%95%B1%20%EC%85%8B%EC%97%85/%ED%8A%A0(TUNE)/tune5.png)

   * URL 확인 후 저장
   * 생성된 Measurement URL을 링크프라이스로 전다

   ![1536805829846](https://github.com/linkprice/MerchantSetup/blob/master/3%EC%9E%90%ED%88%B4%20%EC%95%B1%20%EC%85%8B%EC%97%85/%ED%8A%A0(TUNE)/tune7.png)



3. Postback 설정

   * Attribution Analytics -> PARTNERS -> Data Sharing -> Postbacks URLs -> Simplified 에서 Purchase 활성화

   ![1536805918578](https://github.com/linkprice/MerchantSetup/blob/master/3%EC%9E%90%ED%88%B4%20%EC%95%B1%20%EC%85%8B%EC%97%85/%ED%8A%A0(TUNE)/tune9.png)



4. TuneEvent 설정

   |  설정 데이터   |                 값                 |
   | :------------: | :--------------------------------: |
   | TuneEventItem  |               상품명               |
   |  withQuantity  |                수량                |
   | withUnitPrice  |              상품단가              |
   |  withRevenue   | 실구매액(수량*상품단가 - 할인금액) |
   | withAttribute1 |              상품코드              |
   | withAttribute2 |              주문코드              |
   | withAttribute3 |           카테고리 코드            |

   * 예

   ```java
   ArrayList<TuneEventItem> list = new ArrayList<TuneEventItem>
   list.add(new TuneEventItem(“product name”)
             .withQuantity(3)
             .withUnitPrice(1000)
             .withRevenue(3000)
             .withAttribute1(“product code”)
   		  .withAttribute2(“order code”)
   		  .withAttribute3(“category code”)
   
   ```
