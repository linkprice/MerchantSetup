*   NPAY(API) 셋업 요약
    *   Npay 호출 시 lpinfo 정보 추가
    *   실시간 실적 전송
        *   결제 완료 후 광고주로 콜백 후 주문 정보 조회 시 lpinfo 정보 받기
        *   링크프라이스 실적 실시간 전송



* lpinfo 정보 추가

    * 유저가 Npay를 이용하여 결제 시 주문정보 내용에 사용 가능한 필드(ex: MALL_MANAGE_CODE 등 광고주 연동 환경에 맞는 필드 선택)를 사용하여 lpinfo를 추가 전달합니다.

        ```xml
        <ProductOrderID> string </ProductOrderID>
        <ProductOrderStatus> string </ProductOrderStatus>
        <ClaimType> code </ClaimType>
        <ClaimStatus> code </ClaimStatus>
        <ProductID> string </ProductID>
        <ProductName> string </ProductName>
        <ProductOption> string </ProductOption>
        <Quantity> int </Quantity>
        <UnitPrice> int </UnitPrice>
        <OptionCode> string </OptionCode>
        <TotalProductAmount> int </TotalProductAmount>
        <ProductDiscountAmount> int </ProductDiscountAmount>
        <TotalPaymentAmount> int </TotalPaymentAmount>
        <SellingCode> string </SellingCode>
        <MallManageCode> A100000131|25459244000000|0000|B|1 </MallManageCode>	// lpinfo 값
        ```

        

* 실시간 실적 전송

    * Npay 결제 완료 후 주문 정보 조회 시 주문정보와 함께 lpinfo 정보도 같이 받습니다.

    * 주문 정보 조회 후 실적을 주문 테이블에 저장 합니다. 

      ```php
      //NHNAPISCL 객체생성
      $scl = new NHNAPISCL();
      //타임스탬프를 포맷에 맞게 생성
      $timestamp = $scl->getTimestamp();
      //hmac-sha256서명생성
      $signature = $scl->generateSign($timestamp . $service . $operation, $key);
      
      //soap template에 생성한 값을 입력하여 요청메시지 완성
      $request_body="
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:mall=\"http://mall.checkout.platform.nhncorp.com/\" xmlns:base=\"http://base.checkout.platform.nhncorp.com/\">
         <soapenv:Header/>
         <soapenv:Body>
            <mall:GetProductOrderInfoListRequest>
               <base:AccessCredentials>
                  <base:AccessLicense>".$accessLicense."</base:AccessLicense>
                  <base:Timestamp>".$timestamp."</base:Timestamp>
                  <base:Signature>".$signature."</base:Signature>
               </base:AccessCredentials>
               <base:RequestID></base:RequestID>
               <base:DetailLevel>".$detailLevel."</base:DetailLevel>
               <base:Version>".$version."</base:Version>
               <base:ProductOrderIDList>".$orderIdList."</base:ProductOrderIDList>
            </mall:GetProductOrderInfoListRequest>
         </soapenv:Body>
      </soapenv:Envelope>";
      //요청메시지 확인
      echo "request=" . str_replace('<','&lt;', str_replace('>', '&gt;', $request_body)) . "\n\n";
      
      //http post방식으로 요청 전송
      $rq = new HTTP_Request($targetUrl);
      $rq->addHeader("Content-Type", "text/xml;charset=UTF-8");
      $rq->addHeader("SOAPAction", $service . "#" . $operation);
      $rq->setBody($request_body);
      $result = $rq->sendRequest();
      
      // 조회 후 주문 테이블에 lpinfo등 정보를 저장합니다.
      ```

    * 실적 저장 후 실시간으로 호출합니다.

      ```php
      // NPAY API를 이용하여 실적 호출 후 데이터베이스에 저장
      // 링크프라이스 실적을 호출하여 줍니다.
      
      $sql = "select	network_value	lpinfo,
      		'your merchant id'		merchant_id,
      		user_id 		member_id,
      		order_code 		order_code,
      		product_code 		product_code,
      		price 			sales,
      		product_name		product_name,
      		count 			item_count,
      		category 		category_code,
      		remote_address 		remote_addr,
      		u_agent 		user_agent,
      		sales_type		sales_type
      	from your_order_table
      	where order_code = ?
      	and network_name = ?";
      $stmt = mysqli_stmt_init($conn);
      if(mysqli_stmt_prepare($stmt,$sql)){
          mysqli_stmt_bind_param($stmt,"ss",$search_order_code,NWNAME);
          mysqli_stmt_execute($stmt);
          $result = mysqli_stmt_get_result($stmt);
       
          while ($row = mysqli_fetch_assoc($result)) {
              $send_data[] = $row;
          }	
      	
          mysqli_stmt_close($stmt);
      }
      //data send
      if (!empty($send_data)) {
          define("LP_URL","https://service.linkprice.com/lppurchase_cps_v3.php");
          $options = array(
              'http' => array(
                  'method'  => 'POST',
                  'content' => json_encode($send_data),
                  'header'=>  "Content-type: application/json\r\n"
              )
          );
          $context = stream_context_create($options);
          $result = file_get_contents(LP_URL, false, $context);
      }
      ```

      