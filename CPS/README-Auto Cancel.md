## 자동 실적 취소 (auto_cancel)

1. 자동 실적 취소

   * 머천트 실적이 취소(반품, 미입금 등)됐을 경우 링크프라이스에서 해당 실적을 취소합니다.
   * 머천트 자동 실적 취소 URL을 호출하여 링크프라이스에 있는 실적 취소를 진행합니다. (매월 20일)
   * 주문번호(order_code)와 상품코드(product_code)로 실적을 대조합니다.

2. 자동 실적 취소 셋업

   * 샘플코드는 머천트 개발 환경에 맞게 수정하시기 바랍니다.
   * 자동 실적 취소 URL 호출 시 json 형식으로 출력하여 주시기 바랍니다.

   ```javascript
   {
   	order_status : "1",		//결과코드(결과 코드표 참조)
   	reason : "주문 확정"		// 이유
   }
   ```

   * 결과 코드표

   | 결과코드 |          의미          |              링크프라이스 처리지침              |
   | :------: | :--------------------: | :---------------------------------------------: |
   |    0     |     미입금, 미결제     | 결제 익월 20일까지 미입금 또는 미결제 경우 취소 |
   |    1     |     주문 최종 확정     |                    주문 확정                    |
   |    2     |     주문 취소/환불     |                      취소                       |
   |    3     | 주문번호의 주문이 없음 |                      취소                       |
   |    9     |   확인요망(예외상황)   |        링크프라이스 담당자 확인 후 처리         |

3. 샘플 코드

   * [PHP](https://github.com/linkprice/MerchantSetup/blob/v3/CPS/PHP/auto_cancel.php)
   * [JSP](https://github.com/linkprice/MerchantSetup/blob/v3/CPS/JSP/auto_cancel.jsp)
   * [ASP](https://github.com/linkprice/MerchantSetup/blob/v3/CPS/ASP/auto_cancel.asp)
