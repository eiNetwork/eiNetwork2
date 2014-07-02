<?php

	$tokenData = connectToAPI();

	function microtime_float(){
	    list($usec, $sec) = explode(" ", microtime());
	    return ((float)$usec + (float)$sec);
	}

	function getOverDriveRecord(){

		$link = mysql_connect('localhost', 'vufind', 'vufind');
        if (!$link) {
            die('Could not connect: ' . mysql_error());
        }

        mysql_select_db('econtent', $link) or die('Could not select database.');

        // JOINS econtent_record with duplicateilsid view.
        $query = "SELECT externalId FROM econtent.econtent_record WHERE source = 'OverDrive'";

        $result = mysql_query($query);

        $overdrive_ids = array();

        while ($row = mysql_fetch_assoc($result)) {
            $overdrive_ids[] = $row;
        }

        return $overdrive_ids;


	}

	function connectToAPI(){

		$ch = curl_init("https://oauth.overdrive.com/token");
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 15);
		curl_setopt($ch, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/x-www-form-urlencoded;charset=UTF-8'));
		curl_setopt($ch, CURLOPT_USERPWD,  "eiNetworkPA:MhlONJeedGHRprgZBkWo_pJBeSPghT2c");
		curl_setopt($ch, CURLOPT_TIMEOUT, 30);
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, "grant_type=client_credentials");
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
		$return = curl_exec($ch);
		curl_close($ch);
		$tokenData = json_decode($return);

		return $tokenData;
	}

	function callUrl($url){

		global $tokenData;

		$ch = curl_init($url);
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 15);
		curl_setopt($ch, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
		curl_setopt($ch, CURLOPT_HTTPHEADER, array("Authorization: {$tokenData->token_type} {$tokenData->access_token}", "User-Agent: VuFind-Plus"));
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($ch, CURLOPT_TIMEOUT, 30);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
		$return = curl_exec($ch);
		$curlInfo = curl_getinfo($ch);
		curl_close($ch);
		$returnVal = json_decode($return);

		if ($returnVal != null){

			if (isset($returnVal->message) && $returnVal->message == 'An unexpected error has occurred.'){
				 $error_message = array(
					'subject' => 'Error connecting to OverDrive APIs', 
					'message' => 
						"An unexpected error has occurred - url: " . $curlInfo['url'] . 
						" http code: " . $curlInfo['http_code'] .
						" line number: " . __LINE__
				);
			}

			if (!isset($returnVal->message) || $returnVal->message != 'An unexpected error has occurred.'){
				return $returnVal;
			}
		}
		return null;
	}
		
	function getAvail($overdrive_id){
		$productsUrl = "http://api.overdrive.com/v1/collections/L1BXAIAAA22/products/" . $overdrive_id . "/availability";
		return callUrl($productsUrl);
	}

	$time_start = microtime_float();

	$od_notowned = 0;

	foreach(getOverDriveRecord() as $key => $value){

		$time_now = microtime_float();
		$time = $time_now - $time_start;

		echo "[" . gmdate('H:i:s', $time) . "] OverDriveID = " . $value['externalId'] . " - ";

		$overdrive_check = getAvail($value['externalId']);

		if (!isset($overdrive_check->collections)){

			$od_notowned++;
			echo "Not Found\n";

		} else {

			foreach($overdrive_check->collections as $key => $value){

			if ($value->copiesOwned == 0){
					$od_notowned++;
					echo "Not Found\n";
				} else {
					echo "Found\n";
				}

			}

		}

		usleep(250000);

	}

	echo "\n\nTotal Stale OverDrive Records = " . $od_notowned;

?>