# 실시간 실적 전송 예시

### 1. 장바구니에 다수의 상품을 담아 구매 - 무료배송

​	**예) 구매자가 7000원짜리 HDMI 케이블2개, 6000원짜리 봉지라면 3개를 구매하였고, 무료배송이다.**

* 각 상품의 product_final_price의 합은 final_paid_price와 같아야 합니다

  14000(product_final_price) + 18000(product_final_price) = 32000 (final_paid_price)

```json
{
    "order": {
        "order_id": "o190203-h78X3",
        "final_paid_price": 32000,
        "currency": "KRW",
        "user_name": "구매자"
    },
    "products": [
        {
            "product_id": "P87-234-anx87",
            "product_name": "UHD 4K 넥시 HDMI케이블",
            "category_code": "132782",
            "category_name": ["컴퓨터 주변기기", "케이블", "HDMI케이블"],
            "quantity": 2,
            "product_final_price": 14000,
            "paid_at": "2019-02-12T11:13:44+09:00",
            "confirmed_at": "",
            "canceled_at": ""
        },
        {
            "product_id": "P23-983-Z3272",
            "product_name": "농심 오징어짬뽕124g(5개)",
            "category_code": "237018",
            "category_name": ["가공식품", "라면", "봉지라면"],
            "quantity": 3,
            "product_final_price": 18000,
            "paid_at": "2019-02-12T11:13:44+09:00",
            "confirmed_at": "",
            "canceled_at": ""
        }
    ],
    "linkprice": {
        "merchant_id": "sample",
        "lpinfo": "A123456789|9832|A|m|a8uakljfa",
        "user_agent": "Mozilla/5.0...",
        "remote_addr": "127.0.0.1",
        "device_type": "web-pc"
    }
}
```



### 2.  장바구니에 다수의 상품을 담아 구매 - 배송비포함

​	**예) 구매자가  7000원짜리 HDMI 케이블2개, 6000원짜리 봉지라면 3개를 구매하였고, 배송비 3000원은 구매자가 추가로 지불했다.**

* 실결제 금액은 배송비 3000원을 포함한 35000원입니다.

* final_paid_price는 실결제 금액 35000원에서 배송비 3000원을 뺀 **32000**원입니다.

* 각 상품의 product_final_price의 합은 final_paid_price와 같아야 합니다.

  14000(product_final_price) + 18000(product_final_price) = 32000 (final_paid_price)

```json
{
    "order": {
        "order_id": "o190203-h78X3",
        "final_paid_price": 32000,
        "currency": "KRW",
        "user_name": "구매자"
    },
    "products": [
        {
            "product_id": "P87-234-anx87",
            "product_name": "UHD 4K 넥시 HDMI케이블",
            "category_code": "132782",
            "category_name": ["컴퓨터 주변기기", "케이블", "HDMI케이블"],
            "quantity": 2,
            "product_final_price": 14000,
            "paid_at": "2019-02-12T11:13:44+09:00",
            "confirmed_at": "",
            "canceled_at": ""
        },
        {
            "product_id": "P23-983-Z3272",
            "product_name": "농심 오징어짬뽕124g(5개)",
            "category_code": "237018",
            "category_name": ["가공식품", "라면", "봉지라면"],
            "quantity": 3,
            "product_final_price": 18000,
            "paid_at": "2019-02-12T11:13:44+09:00",
            "confirmed_at": "",
            "canceled_at": ""
        }
    ],
    "linkprice": {
        "merchant_id": "sample",
        "lpinfo": "A123456789|9832|A|m|a8uakljfa",
        "user_agent": "Mozilla/5.0...",
        "remote_addr": "127.0.0.1",
        "device_type": "web-pc"
    }
}
```



### 3. 정률쿠폰 사용

**예) 구매자가  7000원짜리 HDMI 케이블2개, 6000원짜리 봉지라면 3개를 구매하였고, 최종적으로 전체 상품에 대해 10%할인 쿠폰을 사용했다. (무료배송)**

* 쿠폰 적용전에 결제해야 할 금액은 32000원입니다. 10% 쿠폰을 사용하였으므로 최종적으로 구매자가 지불해야 할 금액은 **28800**원입니다

* 10% 쿠폰을 적용하면 hdmi 케이블의 product_final_price은12600원이므로 product_final_price은 **12600**원입니다.

* 10% 쿠폰을 적용하면 봉지라면의 product_final_price은 16200원이므로 product_final_price은 **16200**원입니다.

* 각 상품의 product_final_price의 합은 final_paid_price와 같아야 합니다.

  12600(product_final_price) + 16200(product_final_price) = 28800(final_paid_price) 

```json
{
    "order": {
        "order_id": "o190203-h78X3",
        "final_paid_price": 28800,
        "currency": "KRW",
        "user_name": "구매자"
    },
    "products": [
        {
            "product_id": "P87-234-anx87",
            "product_name": "UHD 4K 넥시 HDMI케이블",
            "category_code": "132782",
            "category_name": ["컴퓨터 주변기기", "케이블", "HDMI케이블"],
            "quantity": 2,
            "product_final_price": 12600,
            "paid_at": "2019-02-12T11:13:44+09:00",
            "confirmed_at": "",
            "canceled_at": ""
        },
        {
            "product_id": "P23-983-Z3272",
            "product_name": "농심 오징어짬뽕124g(5개)",
            "category_code": "237018",
            "category_name": ["가공식품", "라면", "봉지라면"],
            "quantity": 3,
            "product_final_price": 16200,
            "paid_at": "2019-02-12T11:13:44+09:00",
            "confirmed_at": "",
            "canceled_at": ""
        }
    ],
    "linkprice": {
        "merchant_id": "sample",
        "lpinfo": "A123456789|9832|A|m|a8uakljfa",
        "user_agent": "Mozilla/5.0...",
        "remote_addr": "127.0.0.1",
        "device_type": "web-pc"
    }
}
```


### 4. 정액쿠폰 사용 

​	**예) 구매자가  7000원짜리 HDMI 케이블2개, 6000원짜리 봉지라면 3개를 구매하였고, 식품 카테고리 상품에 대해 5000원 할인 쿠폰을 사용했다. (배송비 3000원) **

* 쿠폰 적용전에 결제해야 할 금액은 35000원입니다.

* 5000원 쿠폰을 사용했고, 배송비는 제외해야 함으로 final_paid_price는 35000원에서 쿠폰사용 금액(5000원)과 배송비(3000원)을 뺀 **27000**원입니다.

* hdmi 케이블은 쿠폰 적용 대상이 아니며, product_final_price는 **14000**원 입니다.

* 봉지라면은 쿠폰 적용 대상이며, product_final_price는 18000원에서 5000원을 뺀 **13000**원 입니다.

* 각 상품의 product_final_price의 합은 final_paid_price와 같아야 합니다.

  14000(product_final_price) + 13000(product_final_price) = 27000(final_paid_price) 

```json
{
    "order": {
        "order_id": "o190203-h78X3",
        "final_paid_price": 27000,
        "currency": "KRW",
        "user_name": "구매자"
    },
    "products": [
        {
            "product_id": "P87-234-anx87",
            "product_name": "UHD 4K 넥시 HDMI케이블",
            "category_code": "132782",
            "category_name": ["컴퓨터 주변기기", "케이블", "HDMI케이블"],
            "quantity": 2,
            "product_final_price": 14000,
            "paid_at": "2019-02-12T11:13:44+09:00",
            "confirmed_at": "",
            "canceled_at": ""
        },
        {
            "product_id": "P23-983-Z3272",
            "product_name": "농심 오징어짬뽕124g(5개)",
            "category_code": "237018",
            "category_name": ["가공식품", "라면", "봉지라면"],
            "quantity": 3,
            "product_final_price": 13000,
            "paid_at": "2019-02-12T11:13:44+09:00",
            "confirmed_at": "",
            "canceled_at": ""
        }
    ],
    "linkprice": {
        "merchant_id": "sample",
        "lpinfo": "A123456789|9832|A|m|a8uakljfa",
        "user_agent": "Mozilla/5.0...",
        "remote_addr": "127.0.0.1",
        "device_type": "web-pc"
    }
}
```
