## 머천트 셋업작업 이란

제휴마케팅에서 광고주가 돈을 지불하는 성과는 Affiliate(어필리에이트) 사이트 (또는 페이지) 방문자가 광고 배너 또는 링크를 Click하여 머천트 사이트로 이동, 약속된 행위 (회원가입, 이벤트 참여, 상품구매등)을 하는 것입니다.성과를 정확히 측정하기 위해서는 Affiliate(어필리에이트) 사이트 방문자의 이동경로와 머천트 사이트에서의 Action에 대해 추적이 가능해야 하며, 이를 위해 필요한 것이 Setup 작업입니다.



## 셋업 요약

1. **Lpfornt파일 설치**

   -Lpfront 파일 다운로드 후 root 폴더 아래 linkprice폴더 생성 후 그 안에 위치


2. **실적전송**

   -실적이 발생하는 페이지에 실적전송 코드(샘플제공) 삽입

   -링크프라이스를 통한 실적을 머천트 DB에 저장(누락복구 용)


3. **실적출력 테스트(daily_fix)**

   -실적출력 개발(샘플 제공) 후 웹에서 접근가능 한 곳에 위치

   -머천트 DB에 저장되어진 링크프라이스 데이터 출력


4. **자동 실적 취소(auto_cancel)**

   -자동취소 개발 후 주문 상태 출력

   ​

### 1. Lpfront 파일

​	**1-1 Lpfront**

​		-사용자가 Affiliate의 광고를 통하여 머천트 사이트에 방문시 Affiliate의 정보를 기억하기 위한
​		  Cookie(**LPINFO**) 생성파일

​	**1-2 Lpfront 설치 경로**

​		-localhost 의 root경로 바로 하위 단계에 linkprice 폴더 생성 후 그안에 위치시킵니다.

​		예) URL -http://www.yoursite.com					localhost의 root경로 - c:/yoursite
​		      c:/yoursite 밑에 linkprice 폴더 생성 후 그 안에 Lpfront 파일을 만듭니다.
​		      c:/yoursite/linkprice/Lpfront.[php, jsp, asp]

​	**1-3 Lpfront 코드**

​		-[PHP](https://github.com/linkprice/MerchantSetup/blob/master/sample/PHP/lpfront.php)			-[JSP](https://github.com/linkprice/MerchantSetup/blob/master/sample/JSP/lpfront.jsp)				-[ASP](https://github.com/linkprice/MerchantSetup/blob/master/sample/ASP/lpfront.asp)



### 2. 실시간 실적전송

​	**2-1 실시간 실적 전송 **

​		-LPINFO 쿠키가 있고 실적이 이루어졌을 때 링크프라이스로 실적이 전송되어야 합니다.
​		-실적전송은 실적정보가 암호화 되어 링크프라이스로 전달 됩니다.

​	**2-2 실시간 실적 전송 시점**

​		-실시간 실적 전송은 실적이 발생하는 시점(CPA : 회원가입등, CPS : 구매완료)에 이루어 져야 합니다. 
​		 즉 실적이 발생하는 페이지에 실적전송 코드(샘플 참조)를 삽입하여 주십시요.

​	**2-3 설치**

​		-샘플코드는 각 머천트 환경에 맞게 수정하여 사용하여 주십시요
​		-public.pem 및 LpEncrypt 파일은 암호화를 위한 파일이며, 실적이 발생하는 상품판매(CPS), 
​		 회원가입(CPA) 완료페이지가 있는 폴더에 위치시켜 줍니다.
​		 (public.pem 및 lpEncrypt파일 절대  **수정 불가**)
​		-실적은 JSON 형식으로 보내지게 되며 KEY 이름은 **수정 불가** 이며, VALUE 값을 머천트 실적에 맞게 
​		 넣어 주시면 됩니다. (아래 KEY 설명 참고)

|  KEY   |      VALUE      |    KEY     |       VALUE       |
| :----: | :-------------: | :--------: | :---------------: |
|  a_id  | LPINFO cookie 값 |    m_id    |   링크프라이스 머처트 ID   |
| mbr_id |   실적 발생 회원이름    |    o_cd    | 주문번호(**Unique**값) |
|  p_cd  |   실적 발생 상품코드    |   it_cnt   |        갯수         |
| sales  | 실적 총금액(가겨 * 갯수) |    c_cd    |      카테고리 코드      |
|  p_nm  |   실적 발생 상품이름    | user_agent |  HTTP_USER_AGENT  |
|   ip   |   REMOTE_ADDR   |            |                   |



​	**※주의사항**

​		-**o_cd**(주문번호) 값은 중복될 수 없으며 **Unique**한 값이 어야 합니다.
​		-장바구니를 통한 여러상품을 구매시, Array를 통해 한번에 보내줍니다.
​		-여러 상품 구매시 Array를 사용하는 Value : 상품코드(p_cd), 개수(it_cnt), 가격(sales),
​											   상품이름(p_nm), 카테고리 코드(c_cd)

​		예) 장바구니를 이용 여러상품 구매시
​		      상품코드 A101 인 "컴퓨터" 1대 - 20만원
​		      상품코드 B201 인 "모니터" 1대 - 10만원

|       KEY        |  c_cd   |   p_cd    |  P_nm   | it_cnt |     sales     |
| :--------------: | :-----: | :-------: | :-----: | :----: | :-----------: |
| **VALUE(Array)** | com,mon | A101,B201 | 컴퓨터,모니터 |  1,1   | 200000,100000 |

​	

​	**2-4 샘플코드**

​		-[PHP](https://github.com/linkprice/MerchantSetup/blob/master/sample/PHP/index.php)			-[JSP](https://github.com/linkprice/MerchantSetup/blob/master/sample/JSP/index.jsp)				-[ASP](https://github.com/linkprice/MerchantSetup/blob/master/sample/ASP/index.aspx.vb)



### 3. 실적 출력 스크립트 

​	**3-1 실적출력(daily_fix)**

​		-daily_fix는 머천트의 DB에 저장된 링크프라이스 실적을 출력하는 샘플입니다.
​		-각 머천트 환경에 맞게 수정 후 lpfront파일이 있는 linkprice 폴더에 daily_fix라는 이름의 파일로 
​		 넣어 주십시요.
​		-필드 구분자는 탭문자(\t), 레코드 구분자는 (\n)으로 출력합니다.
​		-실적을 발생시킨 회원의 IP(REMOTE_ADDR)를 같이 출력해 주십시요.
​		-yyyymmdd 파라미터에 날짜를 넣어서 해당 날짜의 실적을 출력해 줍니다.
​	 	 예) 날짜 : 2017 07월 01일 경우 yyyymmdd=20170701
​	       	       http://www.yoursite.com/linkprice/daily_fix?yyyymmdd=2017071

​	**3-2 샘플코드**

​		-[PHP](https://github.com/linkprice/MerchantSetup/blob/master/sample/PHP/daily_fix.php)			-[JSP](https://github.com/linkprice/MerchantSetup/blob/master/sample/JSP/daily_fix.jsp)				-[ASP](https://github.com/linkprice/MerchantSetup/blob/master/sample/ASP/daily_fix.asp)



### 4. 자동 실적 취소

​	**4-1 실적취소(auto_cancel)**

​		-머천트에서는 발생한 실적에 대하여 취소된 경우(반품, 미입금, 취소 등 기타 적합하지 않은 경우) 
​		 링크프라이스 실적을 취소할수 있습니다.
​		-자동 취소 프로세스를 이용하기 위해서는 머천트에서 직접 셋업 작업을 해주셔야 합니다.

​	**4-2 실적취소 셋업**

​		-링크프라이스의 DB에 있는 머천트 실적에서 주문번호(o_cd)와 상품코드(p_cd)를 머천트에
​		  GET방식으로 전송합니다.
​		-머천트는 주문번호(o_cd)와 상품코드(p_cd)를 전달받을 페이지를 lpfront 파일이 있는 linkprice 폴더에 
​		 auto_cancel이라는 이름의 파일로 만들어 줍니다.
​		-자동취소 페이지 호출시 HTML 테그없이 결과코드와 취소사유만 출력해 주시면 됩니다.
​		-결과코드와 취소사유 사이에 탭문자(\t)를 사용하여 주십시요.

| 결과코드 |      의미      |    링크프라이스 처리지침     |
| :--: | :----------: | :----------------: |
|  0   |  미정(예, 미입금)  |   20일 이전일 경우 취소    |
|  1   |    주문 완료     |        정상확인        |
|  2   |    주문 최소     |         취소         |
|  3   | 주문번호의 주문이 없음 |         취소         |
|  9   |  확인요망(예외상황)  | 링크프라이스 담당자 확인 후 처리 |


