# URI스킴 (android)

## 1. 스킴 값 등록

* androidmanifest.xml 파일에 등록
* android:scheme 값은 사용하고자 하는 스킴 값으로 수정

### 1-1. 스킴 값 등록 예시

![ex_screenshot](https://github.com/linkprice/MerchantSetup/blob/master/App/AppSetup/URI%EC%8A%A4%ED%82%B4.png?raw=true)

## 2. 파라미터 전송하기
> ‘URL?변수명=데이터’ 형식으로 URL 뒤에 붙여주어야 합니다.<br>
>   ex) adbrixrm://action?when=20221222&message=test
 
## 3. 스킴이 설정된 Activity 에서 파라미터 받는 법

```javaScript
public class MainActivity extends AppCompatActivity{

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Intent intent = getIntent();
        if (Intent.ACTION_VIEW.equals(intent.getAction())) {
            Uri uri = intent.getData();
            
            if(uri != null) {
                String when = uri.getQueryParameter("when");
                String message = uri.getQueryParameter("message");

                Log.d("MyTag","when : " + when + " , message : " + message);
            }
            
        }
    }
}
```
