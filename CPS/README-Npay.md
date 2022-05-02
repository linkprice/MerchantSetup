# 네이버페이 주문형 타입 셋업 가이드

네이버페이로 결제한 경우도 링크프라이스 실적 처리되어야 합니다. 사용중인 네이버페이 서비스타입에 맞게 가이드 선택하여 추가 셋업 해주시면 됩니다.  

>  네이버페이 서비스타입을 모르는 경우 [네이버페이](https://developer.pay.naver.com/introduce/naverpay)에서 확인해주세요.



## 1. LPINFO 정보 추가

구매자가 네이버페이를 이용하여 결제시 주문정보 내용중 사용 가능한 필드(ex: MALL_MANAGE_CODE 등 광고주 연동 환경에 맞는 필드 선택)를 사용하여 실적 전송에 필요한 정보(LPINFO 등)를 추가 전달합니다.

> Sample
>
> ```xml
> <ProductOrderID> string </ProductOrderID>
> <ProductOrderStatus> string </ProductOrderStatus>
> <ClaimType> code </ClaimType>
> <ClaimStatus> code </ClaimStatus>
> <ProductID> string </ProductID>
> <ProductName> string </ProductName>
> <ProductOption> string </ProductOption>
> <Quantity> int </Quantity>
> <UnitPrice> int </UnitPrice>
> <OptionCode> string </OptionCode>
> <TotalProductAmount> int </TotalProductAmount>
> <ProductDiscountAmount> int </ProductDiscountAmount>
> <TotalPaymentAmount> int </TotalPaymentAmount>
> <SellingCode> string </SellingCode>
> <MallManageCode> A100000131|25459244000000|0000|B|1 </MallManageCode>	// lpinfo 값
> ```




## 2.LPINFO 정보 받기

네이버페이 결제 완료 후 주문 정보 조회 시 주문정보와 함께 실적 전송에 필요한 정보(LPINFO 등)도 함께 전달받습니다. 



## 3.네이버페이 실적 정보 저장

주문정보를 조회 후 전달 받은 주문정보와 실적 전송에 필요한 정보(LPINFO등)를 링크프라이스 실적 테이블(lpinfo 테이블)에 저장합니다.  

> Sample
>
> ```php
> //NHNAPISCL 객체생성
> $scl = new NHNAPISCL();
> //타임스탬프를 포맷에 맞게 생성
> $timestamp = $scl->getTimestamp();
> //hmac-sha256서명생성
> $signature = $scl->generateSign($timestamp . $service . $operation, $key);
> 
> //soap template에 생성한 값을 입력하여 요청메시지 완성
> $request_body="
> <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:mall=\"http://mall.checkout.platform.nhncorp.com/\" xmlns:base=\"http://base.checkout.platform.nhncorp.com/\">
>  <soapenv:Header/>
>  <soapenv:Body>
>     <mall:GetProductOrderInfoListRequest>
>        <base:AccessCredentials>
>           <base:AccessLicense>".$accessLicense."</base:AccessLicense>
>           <base:Timestamp>".$timestamp."</base:Timestamp>
>           <base:Signature>".$signature."</base:Signature>
>        </base:AccessCredentials>
>        <base:RequestID></base:RequestID>
>        <base:DetailLevel>".$detailLevel."</base:DetailLevel>
>        <base:Version>".$version."</base:Version>
>        <base:ProductOrderIDList>".$orderIdList."</base:ProductOrderIDList>
>     </mall:GetProductOrderInfoListRequest>
>  </soapenv:Body>
> </soapenv:Envelope>";
> 
> //요청메시지 확인
> echo "request=" . str_replace('<','&lt;', str_replace('>', '&gt;', $request_body)) . "\n\n";
> 
> //http post방식으로 요청 전송
> $rq = new HTTP_Request($targetUrl);
> $rq->addHeader("Content-Type", "text/xml;charset=UTF-8");
> $rq->addHeader("SOAPAction", $service . "#" . $operation);
> $rq->setBody($request_body);
> $result = $rq->sendRequest();
> 
> // 조회 후 주문 테이블에 lpinfo등 정보를 저장합니다.
> 
> ```



## 4. 네이버페이 구매 실적처리

  링크프라이스 실적 테이블에 저장된 주문정보을 사용중인 셋업 버전에 맞게 실적처리 해주시면 됩니다.


* 실적 처리 방법은 셋업 버전별로 연동가이드를 참고해주세요.

  - [V2 버전](https://github.com/linkprice/MerchantSetup/blob/v2/Merchant%20Setup%20Guide_Kor_ver2.5.pdf) 


  작업내용: 실적 전송, 데일리픽스, 자동실적 취소

  - [V3 버전](https://github.com/linkprice/MerchantSetup/tree/v3/CPS) 

    작업내용: 실적 전송, 데일리픽스, 자동실적 취소 

  - [V4 버전](https://github.com/linkprice/MerchantSetup/tree/v4/CPS) 

    작업내용: 실적 전송, 실적 목록

- 셋업 버전을 모르는 경우 링크프라이스 담당자에게 연락주시면 됩니다. 