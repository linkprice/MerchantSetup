# Singular APP Setup

Use Singular, measure performance in mobile apps.

LinkPrice is currently registered as a network company from Singular, and please set up a partner according to the [English Guide] (https://support.singular.net/hc/en-us/articles/360053018851-How-to-Configure-Partner-Settings-and-Postbacks) ).

The linkPrice ID registered with the Singular is [linkprice.staff@gmail.com ] (mailto:linkprice.staff@gmail.com ).

## Process

App inflow and performance transfer are possible through our Link Price affiliate link through Singular.

1. Please create a tracking link including a custom variable for the iOS and Android OS links, respectively.

Example custom variables are as follows.

- pcid={campaign_id}&pcn={campaign_name}&mid={m_id}&lpinfo={lpinfo}
- The values that will be included in the actual custom variable are passed as follows.
  - pcid=linkprice
  - pcn=linkprice
  - mid=clickbuy
  - lpinfo=A100000131abcd|276282763XXGfv|0000|B|1
- mid is the merchant ID used by the linkPrice.
- lpinfo is the value for tracking linkPrice earnings.

### example
```
pcid=linkprice&pcn=linkprice&mid=clickbuy&lpinfo=A100000131abcd|276282763XXGfv|0000|B|1
```


### Android OS Tracking link example
https://singularassist.sng.link/D59c0/9ypq?pcid={campaign_id}&pcn={campaign_name}&mid={m_id}&lpinfo={lpinfo}

### iOS Tracking link example
https://singularassist.sng.link/D59c0/ywl4?_smtype=3&pcid={campaign_id}&pcn={campaign_name}&mid={m_id}&lpinfo={lpinfo}

> Example of linkPrice partner link status)
> ![02.png](02.png)

2. After Setting with a singular, sigular send the performance to the linkPrice in the event of a performance.
3. For Attribution Settings, you can set the advertising period that the customer company wants.


> 1day Attribution Settings
![1day Attribution Settings](01.png)

4. After setting it up, please deliver the tracking link to the person in charge of linkPrice, and we will check the iOS/AOS entry and performance transfer.


### Reference

- [Integrating with Singular: A Guide for Partners](https://support.singular.net/hc/en-us/articles/360032246232-Integrating-with-Singular-A-Guide-for-Partners)
- [Integrating with Singular Attribution FAQ (Partners)](https://support.singular.net/hc/en-us/articles/115002742751-Integrating-with-Singular-Attribution-FAQ-Partners-)
- [Integrating with Singular Analytics FAQ (Partners)](https://support.singular.net/hc/en-us/articles/360032597931?support=true)
- [How to Configure Partner Settings and Postbacks](https://support.singular.net/hc/en-us/articles/360053018851-How-to-Configure-Partner-Settings-and-Postbacks)