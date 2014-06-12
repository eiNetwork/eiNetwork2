<?php

function curl_download($url){
 
    if (!function_exists('curl_init')){
        die('Sorry cURL is not installed!');
    }
 
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1944.0 Safari/537.36");
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true); 
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 0);
    $output = curl_exec($ch);
    echo "<pre>";
    print_r($output);
    echo "</pre>";
    curl_close($ch);
 
    return $output;
}

$id = "econtentRecord703964";
$title = urlencode("Ancient Egypt from prehistory to the Islamic Conquest /");

$url = "http://vufindplus.einetwork.net:8080/solr/econtent/select/?q=id:" . $id . " AND title:" . $title . "&version=2.2&start=0&rows=10&indent=on&wt=json";

echo "<pre>";
print_r($url);
echo "</pre>";

$response = curl_download($url);

$results = json_decode($response);

echo "<pre>";
print_r("Doc Count: " . count($results->response->docs));
echo "</pre>";

echo "<pre>";
print_r($results);
echo "</pre>";

?>