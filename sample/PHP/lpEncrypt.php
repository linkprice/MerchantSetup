<?php
/**
 * Created by PhpStorm.
 * User: 김진섭
 * Date: 2017-05-31
 * Time: 오후 2:01
 */


define("LP_URL", "http://service.linkprice.com/lppurchase_new.php");
define("LP_LIMIT_BYTE", 64);

/**
 * Class lpEncrypt
 * 암호화 클래스
 * 매체에게 배포하는 클래스
 */
class lpEncrypt {
    private $fpKey;
    private $dataArray;

    public function __construct($filePath) {
        $this->fpKey = $filePath;
    }

    public function set($key, $value) {
        $this->dataArray[$key] = $value;
    }

    public function encrypt() {
        $dataArray = json_encode($this->dataArray);

        //개인키로 암호화
        try {
            $pubKey = file_get_contents($this->fpKey);
            $res = openssl_get_publickey($pubKey);

            $cnt = ceil(strlen($dataArray) / LP_LIMIT_BYTE);

            $resStr = "";

            for($i=0;$i<$cnt;$i++) {
                $cutData = substr($dataArray, LP_LIMIT_BYTE*$i,LP_LIMIT_BYTE);

                if (openssl_public_encrypt($cutData, $crypttext, $res)) {
                    $resStr .= base64_encode($crypttext)."*|LINKPRICE|*";
                } else {
                    echo openssl_error_string();
                    return false;
                }
            }

            if($resStr != '') {
                $data = urlencode(base64_encode($resStr));
            }
        } catch (Exception $err) {
            return false;
        }

        return $data;
    }

    //실적 전송
    public function submit() {
        $ev = $this->encrypt();

        $url = LP_URL."?ev=".$ev;

        $curl = curl_init();
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_HEADER, false);
        curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 120);
        curl_setopt($curl, CURLOPT_URL, $url);

        $result =  curl_exec($curl);
        echo $result;
        if (curl_error($curl)) {
            echo curl_error($curl);
            return false;
        }

        curl_close($curl);

        return json_decode($result, true);
    }
}