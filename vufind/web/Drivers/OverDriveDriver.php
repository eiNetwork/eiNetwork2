<?php

require_once 'sys/eContent/EContentRecord.php';

/**
 * Loads information from OverDrive and provides updates to OverDrive by screen scraping
 * Will be updated to use APIs when APIs become available.
 *
 * Copyright (C) Douglas County Libraries 2011.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * @version 1.0
 * @author Mark Noble <mnoble@turningleaftech.com>
 * @copyright Copyright (C) Douglas County Libraries 2011.
 */
class OverDriveDriver {

	private $maxAccountCacheMin = 14400; //Allow caching of overdrive account information for 4 hours
	private $maxCheckedOutCacheMin = 3600; //Only cache the checked out page for an hour.
	/**
	 * Retrieves the URL for the cover of the record by screen scraping OverDrive.
	 * ..
	 * @param EContentRecord $record
	 */
	public function getCoverUrl($record){
		global $memcache;
		global $configArray;

		$overDriveId = $record->getOverDriveId();
		echo("OverDrive ID is $overDriveId");
		//Get metadata for the record
		$metadata= $this->getProductMetadata($overDriveId);
		if (isset($metadata->images) && isset($metadata->images->cover)){
			return $metadata->images->cover->href;
		}else{
			return "";
		}

	}

	private function _connectToAPI($forceNewConnection = false){
		global $memcache;
		$tokenData = $memcache->get('overdrive_token');
		if ($forceNewConnection || $tokenData == false){
			global $configArray;
			$ch = curl_init("https://oauth.overdrive.com/token");
			curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
			curl_setopt($ch, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
			curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/x-www-form-urlencoded;charset=UTF-8'));
			curl_setopt($ch, CURLOPT_USERPWD, $configArray['OverDrive']['clientKey'] . ":" . $configArray['OverDrive']['clientSecret']);
			curl_setopt($ch, CURLOPT_TIMEOUT, 30);
			curl_setopt($ch, CURLOPT_POST, 1);
			curl_setopt($ch, CURLOPT_POSTFIELDS, "grant_type=client_credentials");
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
			$return = curl_exec($ch);
			curl_close($ch);
			$tokenData = json_decode($return);
			if ($tokenData){
				$memcache->set('overdrive_token', $tokenData, 0, $tokenData->expires_in - 10);
			}
		}
		return $tokenData;
	}

	public function _callUrl($url){
		for ($i = 1; $i < 5; $i++){
			$tokenData = $this->_connectToAPI($i != 1);
			if ($tokenData){
				$ch = curl_init($url);
				curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
				curl_setopt($ch, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
				curl_setopt($ch, CURLOPT_HTTPHEADER, array("Authorization: {$tokenData->token_type} {$tokenData->access_token}"));
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
				curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
				curl_setopt($ch, CURLOPT_TIMEOUT, 30);
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
				$return = curl_exec($ch);
				curl_close($ch);
				$returnVal = json_decode($return);
				//print_r($returnVal);
				if ($returnVal != null){
					if (!isset($returnVal->message) || $returnVal->message != 'An unexpected error has occurred.'){
						return $returnVal;
					}
				}
			}	
			usleep(500);
		}
		return null;
	}

	public function getLibraryAccountInformation(){
		global $configArray;
		$libraryId = $configArray['OverDrive']['accountId'];
		return $this->_callUrl("http://api.overdrive.com/v1/libraries/$libraryId");
	}

	public function getAdvantageAccountInformation(){
		global $configArray;
		$libraryId = $configArray['OverDrive']['accountId'];
		return $this->_callUrl("http://api.overdrive.com/v1/libraries/$libraryId/advantageAccounts");
	}

	public function getProductsInAccount($productsUrl = null, $start = 0, $limit = 25){
		global $configArray;
		if ($productsUrl == null){
			$libraryId = $configArray['OverDrive']['accountId'];
			$productsUrl = "http://api.overdrive.com/v1/collections/$libraryId/products";
		}
		$productsUrl .= "?offeset=$start&limit=$limit";
		return $this->_callUrl($productsUrl);
	}

	public function getProductMetadata($overDriveId, $productsKey = null){
		global $configArray;
		if ($productsKey == null){
			$productsKey = $configArray['OverDrive']['productsKey'];
		}
		$overDriveId= strtoupper($overDriveId);
		$metadataUrl = "http://api.overdrive.com/v1/collections/$productsKey/products/$overDriveId/metadata";
		echo($metadataUrl);
		return $this->_callUrl($metadataUrl);
	}

	public function getProductAvailability($overDriveId, $productsKey = null){
		global $configArray;
		if ($productsKey == null){
			$productsKey = $configArray['OverDrive']['productsKey'];
		}
		$availabilityUrl = "http://api.overdrive.com/v1/collections/$productsKey/products/$overDriveId/availability";
		return $this->_callUrl($availabilityUrl);
	}

	public function _parseOverDriveCheckedOutItems($checkedOutSection, $overDriveInfo){
		$bookshelf = array();
		$bookshelf['items'] = array();
		global $logger;
		if (preg_match_all('/<li class="mobile-four bookshelf-title-li".*?data-transaction="(.*?)".*?>.*?<div class="is-enhanced" data-transaction=".*?" title="(.*?)".*?<img.*?class="lrgImg" src="(.*?)".*?data-crid="(.*?)".*?<div.*?class="dwnld-container".*?>(.*?)<div class="expiration-date".*?<noscript>(.*?)<\/noscript>.*?data-earlyreturn="(.*?)"/si', $checkedOutSection, $bookshelfInfo, PREG_SET_ORDER)) {
			//echo("\r\n");
			//print_r($bookshelfInfo);
			for ($i = 0; $i < count($bookshelfInfo); $i++){
				$bookshelfItem = array();
				$group = 1;
				$bookshelfItem['transactionId'] = $bookshelfInfo[$i][$group++];
				$bookshelfItem['title'] = $bookshelfInfo[$i][$group++];
				$bookshelfItem['imageUrl'] = $bookshelfInfo[$i][$group++];
				$bookshelfItem['overDriveId'] = $bookshelfInfo[$i][$group++];
				//Figure out which eContent record this is for.
				$eContentRecord = new EContentRecord();
				$eContentRecord->externalId = $bookshelfItem['overDriveId'];
				$eContentRecord->source = 'OverDrive';
				if ($eContentRecord->find(true)){
					$bookshelfItem['recordId'] = $eContentRecord->id;
				}else{
					$bookshelfItem['recordId'] = -1;
				}
				$formatSection = $bookshelfInfo[$i][$group++];
				//print_r("\r\nFormat Section $i\r\n$formatSection\r\n");
				$bookshelfItem['expiresOn'] = $bookshelfInfo[$i][$group++];
				$bookshelfItem['earlyReturn'] = $bookshelfInfo[$i][$group++];
				//Check to see if a format has been selected
				if (preg_match_all('/<li class="dwnld-litem.*?".*?data-fmt="(.*?)".*?data-lckd="(.*?)".*?data-enhanced="(.*?)".*?<a.*?>(.*?)<\/a>/si', $formatSection, $formatOptions, PREG_SET_ORDER)) {
					$bookshelfItem['lockedFormat'] = 0;
                                        $bookshelfItem['hasRead'] = false;
					$bookshelfItem['formats'] = array();
					for ($fmt = 0; $fmt < count($formatOptions); $fmt++){
						$format = array();
						$format['id'] = $formatOptions[$fmt][1];
						if( $format['id'] == 610){
							$bookshelfItem['hasRead'] = true;	
						}    
						$format['locked'] = $formatOptions[$fmt][2];
                                                if($format['locked'] == 1){//This means the format is selected
							$bookshelfItem['lockedFormat'] = $format['id'];	
						}
						$format['enhanced'] = $formatOptions[$fmt][3];
						$format['name'] = $formatOptions[$fmt][4];
						if ($format['locked'] == 1){

							$bookshelfItem['downloadUrl'] = $overDriveInfo['baseLoginUrl'] . 'BANGPurchase.dll?Action=Download&ReserveID=' . $bookshelfItem['overDriveId'] . '&FormatID=' . $format['id'] . '&url=MyAccount.htm';
						}
						$bookshelfItem['formats'][] = $format;
					}
				}

				$bookshelf['items'][] = $bookshelfItem;
			}
		}
		return $bookshelf;
	}
	
	private function _parseOverDriveHolds($holdsSection){
		$holds = array();
		$holds['available'] = array();
		$holds['unavailable'] = array();
		
		global $logger;
		//Match holds
		//Get the individual holds by splitting the section based on each <li class="mobile-four">
		//Trim to the first li
		$firstTitlePos = strpos($holdsSection, '<li class="mobile-four">');
		$holdsSection = substr($holdsSection, $firstTitlePos);
		$heldTitles = explode('<li class="mobile-four"', $holdsSection);
		$i = 0;
		foreach ($heldTitles as $titleHtml){
			//echo("\r\nSection " . $i++ . "\r\n$titleHtml");
			if (preg_match('/<div class="coverID">.*?<a href="ContentDetails\\.htm\\?id=(.*?)">.*?<img class="lrgImg" src="(.*?)".*?<div class="trunc-title-line".*?title="(.*?)".*?<div class="trunc-author-line".*?title="(.*?)".*?<div class="(?:holds-info)?".*?>(.*)/si', $titleHtml, $holdInfo)){

				$hold = array();
				$grpCtr = 1;
				$hold['overDriveId'] = $holdInfo[$grpCtr++];
				$hold['imageUrl'] = $holdInfo[$grpCtr++];
				$eContentRecord = new EContentRecord();
				$eContentRecord->externalId = $hold['overDriveId'];
				$eContentRecord->source = 'OverDrive';
				if ($eContentRecord->find(true)){
					$hold['recordId'] = $eContentRecord->id;
				}else{
					$hold['recordId'] = -1;
				}
				$hold['title'] = $holdInfo[$grpCtr++];
				$hold['author'] = $holdInfo[$grpCtr++];

				$holdDetails = $holdInfo[$grpCtr++];
				
				//$logger->log("parseoverdriveholds hold ".print_r($hold,true), PEAR_LOG_INFO);

				if (preg_match('/<h6 class="holds-wait-position" id="(.*?)">(.*?)<\/h6>.*?<h6 class="holds-wait-email" title="(.*?)">(.*?)<\/h6>/si', $holdDetails, $holdDetailInfo)) {
					
					$notificationInformation = $holdDetailInfo[2];
					if (preg_match('/You are (?:patron|user) <b>(\\d+)<\/b> out of <b>(\\d+)<\/b> on the waiting list/si', $notificationInformation, $notifyInfo)) {
						$hold['holdQueuePosition'] = $notifyInfo[1];
						$hold['holdQueueLength'] = $notifyInfo[2];
					}else{
						echo($notificationInformation);
					}
					$hold['notifyEmail'] = $holdDetailInfo[3];
					$holds['unavailable'][] = $hold;
					//$logger->log("parseoverdriveholds unavailable hold ".print_r($hold,true), PEAR_LOG_INFO);
				}elseif (strpos($holdDetails,"This title can be borrowed for") > 0) {
					$holdDetailInfoStart = strpos($holdDetails,"This title can be borrowed for");
					$notifyDateStart = strpos($holdDetails,"new Date (",$holdDetailInfoStart) + 11;
					$notifyDateEnd = strpos($holdDetails,");",$notifyDateStart);
					$hold['emailSent'] = substr($holdDetails,$notifyDateStart,$notifyDateEnd-$notifyDateStart-1);
					$hold['notificationDate'] = strtotime($hold['emailSent']);
					$hold['expirationDate'] = $hold['notificationDate'] + 3 * 24 * 60 * 60;
					//$logger->log("parseoverdriveholds available hold ".print_r($hold,true), PEAR_LOG_INFO);
					$holds['available'][] = $hold;
				}
			}
		}
		return $holds;
	}

	private function _parseLendingOptions($lendingPeriods){
		$lendingOptions = array();
		//print_r($lendingPeriods);
		if (preg_match('/<script>.*?var hazVariableLending.*?<\/script>.*?<noscript>(.*?)<\/noscript>/si', $lendingPeriods, $matches)){
			preg_match_all('/<li>\\s?\\d+\\s-\\s(.*?)<select name="(.*?)">(.*?)<\/select><\/li>/si', $matches[1], $lendingPeriodInfo, PREG_SET_ORDER);
			for ($i = 0; $i < count($lendingPeriodInfo); $i++){
				$lendingOption = array();
				$lendingOption['name'] = $lendingPeriodInfo[$i][1];
				//$lendingOptions[] = 'test';
				$lendingOption['id'] = $lendingPeriodInfo[$i][2];
				$options = $lendingPeriodInfo[$i][3];
				$lendingOption['options']= array();
				preg_match_all('/<option value="(.*?)".*?(selected="selected")?>(.*?)<\/option>/si', $options, $optionInfo, PREG_SET_ORDER);
				for ($j = 0; $j < count($optionInfo); $j++){
					$option = array();
					$option['value'] = $optionInfo[$j][1];
					$option['selected'] = strlen($optionInfo[$j][2]) > 0;
					$option['name'] = $optionInfo[$j][3];
					$lendingOption['options'][] = $option;
				}
				$lendingOptions[] = $lendingOption;
			}
		}
		//print_r($lendingOptions);
		return $lendingOptions;
	}
	
	/**
	 * Loads information about items that the user has checked out in OverDrive
	 *
	 * @param User $user
	 * @param array $overDriveInfo optional array of information loaded from _loginToOverDrive to improve performance.
	 *
	 * @return array
	 */
	public function getOverDriveCheckedOutItems1($user, $overDriveInfo = null){
		global $memcache;
		global $configArray;
		global $timer;
		global $logger;

		$logger->log("Getting overdrive checked out items ", PEAR_LOG_INFO);
		
		$bookshelf = $memcache->get('overdrive_checked_out_' . $user->id);
		
		if ($bookshelf == false){
			$bookshelf = array();
			$bookshelf['items'] = array();
			$closeSession = false;
			if ($overDriveInfo == null){
				$ch = curl_init();
				if (!$ch){
					//global $logger;
					$logger->log("Could not create curl handle", PEAR_LOG_INFO);
					$bookshelf['error'] = 'Sorry, we could not connect to OverDrive, please try again in a few minutes.';
					return $bookshelf;
				}
				$overDriveInfo = $this->_loginToOverDrive($ch, $user);
				if ($overDriveInfo == null){
					global $logger;
					$logger->log("Could not login to overdrive", PEAR_LOG_INFO);
					$bookshelf['error'] = 'Sorry, we could not login to OverDrive, please try again in a few minutes.';
					return $bookshelf;
				}
				$closeSession = true;
			}

			//Load the Bookshelf Page
			//$logger->log("Bookshelf URL ".$overDriveInfo['bookshelfUrl'], PEAR_LOG_INFO);
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['bookshelfUrl']);
			$bookshelfPage = curl_exec($overDriveInfo['ch']);
			
			if ($closeSession){
				curl_close($overDriveInfo['ch']);
			}

			//Extract information from the holds page
			 preg_match_all('/<div class="is\-enhanced" data-transaction="(.*?)" title="(.*?)" style="width:48%; float:left;">.*?<img class="lrgImg" src="(?:http:\/\/(.*?)|MissingThumbImage\.jpg)".*?data-crid="(.*?)".*?<div.*?class="dwnld-container".*?>(.*?)var myExpireDate = "(.*?)".*?<\/noscript>.*?data-earlyreturn="(.*?)"/si', $bookshelfPage, $bookshelfInfo, PREG_SET_ORDER);
			//preg_match_all('/<li class="mobile-four bookshelf-title-li".*?data-transaction="(.*?)".*? >.*?<div class="is-enhanced" data-transaction=".*?" title="(.*?)".*?<img.*?class="lrgImg" src="(.*?)".*?data-crid="(.*?)".*?<div.*?class="dwnld-container".*? >(.*?)<div class="expiration-date".*?<noscript>(.*?)<\/noscript>.*?data-earlyreturn="(.*?)"/si', $bookshelfPage, $bookshelfInfo, PREG_SET_ORDER);

			for ($matchi = 0; $matchi < count($bookshelfInfo); $matchi++) {
				$bookshelfItem = array();
				if ($bookshelfInfo[$matchi][3]){
					$bookshelfItem['imageUrl'] = "http://" . $bookshelfInfo[$matchi][3];
				}else{
					$bookshelfItem['imageUrl'] = "";
				}
				$bookshelfItem['transactionId'] = $bookshelfInfo[$matchi][1];
				$bookshelfItem['title'] = $bookshelfInfo[$matchi][2];
				$bookshelfItem['overDriveId'] = $bookshelfInfo[$matchi][4];
				$bookshelfItem['expiresOn'] = $bookshelfInfo[$matchi][6];
				$bookshelfItem['earlyReturn'] = $bookshelfInfo[$matchi][7];
				
				$formatSection = $bookshelfInfo[$matchi][5];
				$eContentRecord = new EContentRecord();
				$eContentRecord->externalId = $bookshelfItem['overDriveId'];
				$eContentRecord->source = 'OverDrive';
				if ($eContentRecord->find(true)){
					$bookshelfItem['recordId'] = $eContentRecord->id;
				}else{
					$bookshelfItem['recordId'] = -1;
				}
				//set locked format to zero which means none
				$bookshelfItem['lockedFormat'] = 0;
				$bookshelfItem['hasRead'] = false;
				
				//Check to see if a format has been selected
				if (preg_match_all('/<li class="dwnld-litem.*?".*?data-fmt="(.*?)".*?data-lckd="(.*?)".*?data-enhanced="(.*?)".*?<a.*?>(.*?)<\/a>/si', $formatSection, $formatOptions, PREG_SET_ORDER)) {
					$bookshelfItem['formatSelected'] = false;
					$bookshelfItem['formats'] = array();
					for ($fmt = 0; $fmt < count($formatOptions); $fmt++){
						$format = array();
						$format['id'] = $formatOptions[$fmt][1];
						if( $format['id'] == 610){
							$bookshelfItem['hasRead'] = true;	
						}
						$format['locked'] = $formatOptions[$fmt][2]; //This means the format is selected
						if($format['locked'] == 1){
							$bookshelfItem['lockedFormat'] = $format['id'];	
						}
						$format['enhanced'] = $formatOptions[$fmt][3];
						$format['name'] = $formatOptions[$fmt][4];
						if ($format['locked'] == 1){
							$bookshelfItem['formatSelected'] = true;
							$bookshelfItem['selectedFormat'] = $format;
							$bookshelfItem['downloadUrl'] = $overDriveInfo['downloadUrl'] . 'BANGPurchase.dll?Action=Download&ReserveID=' . $bookshelfItem['overDriveId'] . '&FormatID=' . $format['id'] . '&url=MyAccount.htm';
						}
						$bookshelfItem['formats'][] = $format;
					}
				}

				$bookshelf['items'][] = $bookshelfItem;
			}
			$timer->logTime("Finished loading titles from overdrive checked out titles");
			$memcache->set('overdrive_checked_out_' . $user->id, $bookshelf, 0, $configArray['Caching']['overdrive_checked_out']);
		}
		return $bookshelf;
	}

	public function getOverDriveHolds1($user, $overDriveInfo = null){
		global $memcache;
		global $configArray;
		global $timer;
		global $logger;
		$holds = $memcache->get('overdrive_holds_' . $user->id);

		if ($holds == false){
			$holds = array();
			$holds['holds'] = array();
			$holds['holds']['available'] = array();
			$holds['holds']['unavailable'] = array();
			
			$closeSession = false;
			if ($overDriveInfo == null){
				//Start a curl session
				$ch = curl_init();
				if (!$ch){
					//global $logger;
					$logger->log("Could not create curl handle", PEAR_LOG_INFO);
					$holds['error'] = 'Sorry, we could not connect to OverDrive, please try again in a few minutes.';
					return $holds;
				}
				//Login to overdrive
				$overDriveInfo = $this->_loginToOverDrive($ch, $user);
				if ($overDriveInfo == null){
					//global $logger;
					$logger->log("Could not login to overdrive", PEAR_LOG_INFO);
					$holds['error'] = 'Sorry, we could not connect to OverDrive, please try again in a few minutes.';
					return $holds;
				}
				$closeSession = true;
			}

			//Load the My Holds page
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['holdsUrl']);
			//$logger->log("holds URL ". $overDriveInfo['holdsUrl'], PEAR_LOG_INFO);
			$holdsPage = curl_exec($overDriveInfo['ch']);
			//$logger->log("holds page start ". $holdsPage." holds page end", PEAR_LOG_INFO);
			
			if ($closeSession){
				curl_close($overDriveInfo['ch']);
			}
			//get the holds
			if (preg_match('/<li .*?id="myAccount2Tab".*?>(.*?)<li [^>\/]*?id="myAccount3Tab".*?>/s', $holdsPage, $matches)) {
			$holdsSection = $matches[1];
			//print_r($holdsSection);
			//Get a list of titles that are on hold
			$holds = $this->_parseOverDriveHolds($holdsSection);
				//echo("<br>\r\n");
				//print_r($holds);
				//echo("<br>\r\n");
			}
			
			$timer->logTime("Finished loading titles from overdrive holds");
			$memcache->set('overdrive_holds_' . $user->id, $holds, 0, $configArray['Caching']['overdrive_holds']);
		}

		return $holds;
	}

        public function getOverDriveCheckedOutItems($user, $overDriveInfo = null){
		global $memcache;
		global $configArray;
		global $timer;

		$summary = $this->getOverDriveSummary($user);
		$checkedOutTitles = $summary['checkedOut'];
		return $checkedOutTitles;
	}

	public function getOverDriveHolds($user, $overDriveInfo = null){
		global $memcache;
		global $configArray;
		global $timer;

		$summary = $this->getOverDriveSummary($user);
		$holds = array();
		$holds = $summary['holds'];
		return $holds;
	}
	/**
	 * Returns a summary of information about the user's account in OverDrive.
	 *
	 * @param User $user
	 * @param array $overDriveInfo optional array of information loaded from _loginToOverDrive to improve performance.
	 *
	 * @return array
	 */
	public function getOverDriveSummary($user){
		global $memcache;
		global $configArray;
		global $timer;
		global $logger;

		$summary = $memcache->get('overdrive_summary_' . $user->id);
		if ($summary == false || isset($_REQUEST['reload'])){
			$summary = array();
			$ch = curl_init();

			$overDriveInfo = $this->_loginToOverDrive($ch, $user);
			//Navigate to the account page
			//Load the My Holds page
			//print_r("Account url: " . $overDriveInfo['accountUrl']);
			//$logger->log("Account url: " . $overDriveInfo['accountUrl'], PEAR_LOG_INFO);
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['accountUrl']);
			$accountPage = curl_exec($overDriveInfo['ch']);			
			//Get bookshelf information
			if (preg_match('/<li .*?id="myAccount1Tab".*?>(.*?)<li [^>\/]*?id="myAccount2Tab".*?>/s', $accountPage, $matches)) {
				$checkedOutSection = $matches[1];
				//print_r($checkedOutSection);
				//Get a list of titles that are checked out
				$checkedOut = $this->_parseOverDriveCheckedOutItems($checkedOutSection, $overDriveInfo);
				//print_r($checkedOut);
				$summary['numCheckedOut'] = count($checkedOut['items']);
				$summary['checkedOut'] = $checkedOut;
			}

			if (preg_match('/<li .*?id="myAccount2Tab".*?>(.*?)<li [^>\/]*?id="myAccount3Tab".*?>/s', $accountPage, $matches)) {
				$holdsSection = $matches[1];
				//print_r($holdsSection);
				//Get a list of titles that are checked out
				$holds = $this->_parseOverDriveHolds($holdsSection);
				//echo("<br>\r\n");
				//print_r($holds);
				//echo("<br>\r\n");
				$summary['numAvailableHolds'] = count($holds['available']);
				$summary['numUnavailableHolds'] = count($holds['unavailable']);
				$logger->log("number unavailable holds: " . $summary['numUnavailableHolds'], PEAR_LOG_INFO);				
				$summary['holds'] = $holds;
			}

			//Get lending options
			if (preg_match('/<li .*?id="myAccount4Tab".*?>(.*?)<!-- myAccountContent -->/s', $accountPage, $matches)) {
				$lendingOptionsSection = $matches[1];
				$lendingOptions = $this->_parseLendingOptions($lendingOptionsSection);
				$summary['lendingOptions'] = $lendingOptions;
				$logger->log("lending options 0: " . $lendingOptions[0], PEAR_LOG_INFO);	
			}

			curl_close($ch);

			$timer->logTime("Finished loading titles from overdrive summary");
			$memcache->set('overdrive_summary_' . $user->id, $summary, 0, $configArray['Caching']['overdrive_summary']);
		}
		return $summary;
	}

	/**
	 * Places a hold on an item within OverDrive
	 *
	 * @param string $overDriveId
	 * @param int $format
	 * @param User $user
	 */
	public function placeOverDriveHold($overDriveId, $user){
		global $memcache;
		global $configArray;
		global $logger;

		$format = "";
		$holdResult = array();
		$holdResult['result'] = false;
		$holdResult['message'] = '';

		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);

		if ($overDriveInfo == null){
			$holdResult['result'] = false;
			$holdResult['message'] = 'Sorry, we could not connect to OverDrive.  Please try again later.';
		}else{

			//Switch back to get method
			curl_setopt($overDriveInfo['ch'], CURLOPT_HTTPGET, true);

			//Open the record page
			$contentInfoPage = $overDriveInfo['contentInfoPage'] . "?ID=" . $overDriveId;
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $contentInfoPage);
			$recordPage = curl_exec($overDriveInfo['ch']);
			$recordPageInfo = curl_getinfo($overDriveInfo['ch']);
			
			//Navigate to place a hold page
			$waitingListUrl = $overDriveInfo['waitingListUrl'];

			if ($format == "" || $format == 'undefined'){
				$format = "";
				if (preg_match('/<a href="BANGAuthenticate\.dll\?Action=AuthCheck&ForceLoginFlag=0&URL=WaitingListForm.htm%3FID=(.*?)%26Format=(.*?)" class="radius large button details-title-button" data-checkedout="(.*?)" data-contentstatus="(.*?)">Place a Hold<\/a>/si', $recordPage, $formatInfo)){
					$format = $formatInfo[2];
				}else{
					$logger->log("Did not find hold button for this title to retrieve format", PEAR_LOG_INFO);
					$holdResult['result'] = false;
					$holdResult['message'] = "This title is available for checkout.";
					$holdResult['availableForCheckout'] = true;
					return $holdResult;
				}
			}
			$waitingListUrl .= '%3FID=' . $overDriveId . '%26Format=' . $format;
			//$logger->log("Wait list URL ". $waitingListUrl, PEAR_LOG_INFO);
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $waitingListUrl);
			//$logger->log("Click place a hold button " . $waitingListUrl, PEAR_LOG_DEBUG);			
			$setEmailPage = curl_exec($overDriveInfo['ch']);
			//$logger->log("set email page info " . $setEmailPage . " end set email page", PEAR_LOG_DEBUG);	
			$setEmailPageInfo = curl_getinfo($ch);
			if (preg_match('/already placed a hold or borrowed this title/', $setEmailPage)){
				$holdResult['result'] = false;
				$holdResult['message'] = "You are already on the waiting list for this title.";

			}else{

				$secureBaseUrl = preg_replace('~[^/.]+?.htm.*~', '', $setEmailPageInfo['url']);

				//Login (again)
				curl_setopt($overDriveInfo['ch'], CURLOPT_POST, true);
				$barcodeProperty = isset($configArray['Catalog']['barcodeProperty']) ? $configArray['Catalog']['barcodeProperty'] : 'cat_username';
				$barcode = $user->$barcodeProperty;
				$postParams = array(
					'LibraryCardNumber' => $barcode,
					'URL' => 'MyAccount.htm',
				);
				if (isset($configArray['OverDrive']['LibraryCardILS']) && strlen($configArray['OverDrive']['LibraryCardILS']) > 0){
					$postParams['LibraryCardILS'] = $configArray['OverDrive']['LibraryCardILS'];
				}
				foreach ($postParams as $key => $value) {
					$post_items[] = $key . '=' . urlencode($value);
				}
				$post_string = implode ('&', $post_items);
				curl_setopt($overDriveInfo['ch'], CURLOPT_POSTFIELDS, $post_string);
				curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $secureBaseUrl . 'BANGAuthenticate.dll');
				$waitingListPage = curl_exec($overDriveInfo['ch']);
				$waitingListPageInfo = curl_getinfo($overDriveInfo['ch']);
				if (preg_match('/already on/', $waitingListPage)){
					$holdResult['result'] = false;
					$holdResult['message'] = "You are already on the waiting list for the selected title or have it checked out.";
				}else{

					//Fill out the email address to use for notification
					$postParams = array(
						'ID' => $overDriveId,
						'Format' => $format,
						'URL' => 'WaitingListConfirm.htm',
						'Email' => $user->email,
						'Email2' => $user->email,
					);
					foreach ($postParams as $key => $value) {
						$post_items[] = $key . '=' . urlencode($value);
					}
					$post_string = implode ('&', $post_items);
					curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
					curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $secureBaseUrl . 'BANGAuthenticate.dll?Action=LibraryWaitingList');
					$waitingListConfirm = curl_exec($overDriveInfo['ch']);
					$logger->log("Submitting email for notification {$secureBaseUrl}BANGAuthenticate.dll?Action=LibraryWaitingList  $post_string"  , PEAR_LOG_INFO);
					//$logger->log("overdrive waiting list confirm {$waitingListConfirm}"  , PEAR_LOG_INFO);

					$waitingListConfirm = strip_tags($waitingListConfirm, "'<p><a><li><ul><div><em><b>'");
					
					if (strpos($waitingListConfirm,"You will receive an email from donotreply@overdrive.com when the title becomes available") > 0){
						$holdResult['result'] = true;
						$holdResult['message'] = 'Your hold was placed successfully.';
						$memcache->delete('overdrive_summary_' . $user->id);
						
					}elseif (strpos($waitingListConfirm, "Carnegie Library of Pittsburgh/Allegheny County Library Association Digital Media Catalog - Error page") > 0){
						//$logger->log("Found main content section", PEAR_LOG_INFO);
						$mainSectionStart = strpos($waitingListConfirm,'<div id="contentContainer"');
						$mainSection = substr($waitingListConfirm,$mainSectionStart);
						
						if (preg_match('/already on/si', $mainSection)){
							$holdResult['result'] = false;
							$holdResult['message'] = 'This title is already on hold or checked out to you.';
						}elseif (preg_match('/You have already placed a hold or borrowed this title/si', $mainSection)){
							$holdResult['result'] = false;
							$holdResult['message'] = 'This title is already on hold or checked out to you.';
						}elseif (preg_match('/did not complete all of the required fields/', $mainSection)){
							$holdResult['result'] = false;
							$holdResult['message'] = 'You must provide an e-mail address to request titles from OverDrive.  Please add an e-mail address to your profile.';
						}elseif (preg_match('/reached the Holds limit of \d+ titles./', $mainSection)){
							$holdResult['result'] = false;
							$holdResult['message'] = 'You have reached the maximum number of holds for your OverDrive account.';
						}elseif (preg_match('/Some of our digital titles are only available for a limited time\. This title may be available in the future\. Be sure to check back/', $waitingListConfirm)){
							$holdResult['result'] = false;
							$holdResult['message'] = 'This title is no longer available.  Some of our digital titles are only available for a limited time. This title may be available in the future. Be sure to check back.';
						}elseif(preg_match('/The email address entered was not valid\./', $mainSection)){
							$holdResult['result'] = false;
							$holdResult['message'] = "Please enter a valid email address on your profile.";
						}else{
							$holdResult['result'] = false;
							$holdResult['message'] = 'There was an error placing your hold.';
							global $logger;
							$logger->log("Error placing hold, OverDrive error page response ".$mainSection, PEAR_LOG_INFO);
							//$logger->log("Placing hold on OverDrive item. OverDriveId ". $overDriveId, PEAR_LOG_INFO);
							//$logger->log('URL: '.$secureBaseUrl . "BANGAuthenticate.dll?Action=LibraryWaitingList $post_string\r\n" . $mainSection ,PEAR_LOG_INFO);
						}
						
					}elseif (preg_match("/You did not complete all of the required fields on the 'Holds' page/", $waitingListConfirm)){
						$holdResult['result'] = false;
						$holdResult['message'] = 'Please enter a valid email address on your profile.';
					}else{
						$holdResult['result'] = false;
						$holdResult['message'] = 'There was an error placing your hold.';
						global $logger;
						$logger->log("Placing hold on OverDrive item. OverDriveId ". $overDriveId, PEAR_LOG_INFO);
						//$logger->log('URL: '.$secureBaseUrl . "BANGAuthenticate.dll?Action=LibraryWaitingList $post_string\r\n" . $waitingListConfirm ,PEAR_LOG_INFO);
						//$logger->log("Error placing overdrive hold waitingListConfirm result ".$waitingListConfirm." end overdrive hold result", PEAR_LOG_INFO);
					}
				}
			}
		}
		curl_close($ch);

		return $holdResult;
	}
	
	public function downloadOverDriveItem($overDriveId, $formatId, $user){
		global $logger;
		global $memcache;
		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);
		$closeSession = true;

		//Switch back to get method
		curl_setopt($overDriveInfo['ch'], CURLOPT_HTTPGET, true);

		$result = array(
			'result' => true,
			'downloadUrl' => $overDriveInfo['downloadUrl'] . 'BANGPurchase.dll?Action=Download&ReserveID=' . $overDriveId . '&FormatID=' . $formatId . '&url=MyAccount.htm'
		);
		$logger->log("DOWNLOAD---> ". $result["downloadUrl"], PEAR_LOG_INFO);
		$memcache->delete('overdrive_summary_' . $user->id);
		
		return $result;
		
	}
	
	public function editOverDriveEmail($email, $overDriveId, $user){
		global $memcache;
		global $logger;

		$editResult = array();
		$editResult['result'] = false;
		$editResult['message'] = '';

		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);
		curl_setopt($overDriveInfo['ch'], CURLOPT_HTTPGET, true);

		//Navigate to the holds page
		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['holdsUrl']);
		$holdsPage = curl_exec($overDriveInfo['ch']);
		//get the edit URL with the format id from the holds page
		//$logger->log("overdrive holdsPage---> ". $holdsPage." end overdrive holdsPage", PEAR_LOG_INFO);
		$waitingListEditUrlStart = strpos($holdsPage,"BANGAuthenticate.dll?Action=AuthCheck&amp;ForceLoginFlag=0&URL=WaitingListEdit.htm%3FID=".$overDriveId);
		$waitingListEditUrlEnd = strpos($holdsPage,"Format=",$waitingListEditUrlStart);
		$waitinglistEditFormat = substr($holdsPage,$waitingListEditUrlEnd+7,3);
		//$logger->log("overdrive waiting list edit format ---> ". $waitinglistEditFormat." end waiting list format", PEAR_LOG_INFO);
		
		//Navigate to edit email page
		//$editEmailUrl = $overDriveInfo['baseUrl'] . "WaitingListEdit.htm?ID=" . $overDriveId . "&Format=420";
		$editEmailUrl = $overDriveInfo['baseUrl'] . "WaitingListEdit.htm?ID=" . $overDriveId ."&Format=". $waitinglistEditFormat;
		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $editEmailUrl);
		$editPage = curl_exec($overDriveInfo['ch']);

		//$logger->log("overdrive info ---> ". print_r($overDriveInfo, true), PEAR_LOG_INFO);
		//$logger->log("editURLXXX---> ". $editEmailUrl, PEAR_LOG_INFO);
		//$logger->log("overdrive editPage---> ". $editPage." end overdrive editPage", PEAR_LOG_INFO);
		
		$postParams = array(
			'ID' => $overDriveId,
			'Format' => $waitinglistEditFormat,
			'URL' => 'WaitingListConfirm.htm',
			'Email' => $email,
			'Email2' => $email,
			);
		foreach ($postParams as $key => $value) {
			$post_items[] = $key . '=' . urlencode($value);
		}
		$post_string = implode ('&', $post_items);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);

		$submitUrl = $overDriveInfo['baseLoginUrl'] . '?Action=EditWaitingList';
		//$logger->log("waiting list URL QQQ---> ". $submitUrl, PEAR_LOG_INFO);
		//$logger->log("post string---> ". $post_string, PEAR_LOG_INFO);
		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $submitUrl);
		
		$waitingListConfirm = curl_exec($overDriveInfo['ch']);
		//$logger->log("waiting list ZZZ---> ". $waitingListConfirm, PEAR_LOG_INFO);
		
		if (preg_match('/The following system error occurred.../', $waitingListConfirm)) {
			$editResult['result'] = false;
			$editResult['message'] = 'There was an error updating your email address.  Your email was not changed.';
		} elseif (preg_match('/You will receive an email from donotreply@overdrive.com when the title becomes available/', $waitingListConfirm)){
			$editResult['result'] = true;
			$editResult['message'] = 'Your email was changed successfully.';
			global $memcache;
			$memcache->delete('overdrive_summary_' . $user->id);

		}else{
			$editResult['result'] = false;
			$editResult['message'] = 'Please enter a valid email address.';
		}

		curl_close($overDriveInfo['ch']);

		return $editResult;		
		
	}
	
	public function cancelOverDriveHold($overDriveId, $user){
		global $memcache;

		$cancelHoldResult = array();
		$cancelHoldResult['result'] = false;
		$cancelHoldResult['message'] = '';

		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);
		curl_setopt($overDriveInfo['ch'], CURLOPT_HTTPGET, true);

		//Navigate to the holds page
		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['holdsUrl']);
		$holdsPage = curl_exec($overDriveInfo['ch']);

		//Navigate to hold cancellation page
		$holdCancelUrl = $overDriveInfo['baseLoginUrl'] . "?Action=RemoveFromWaitingList&id={{$overDriveId}}&format=420&url=waitinglistremove.htm";
		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $holdCancelUrl);
		$cancellationResult = curl_exec($overDriveInfo['ch']);

		if (preg_match('/You have successfully cancelled your hold/', $cancellationResult)){
			$cancelHoldResult['result'] = true;
			$cancelHoldResult['message'] = 'Your hold was cancelled successfully.';

			//Check to see if the user has cached hold information and if so, clear it
			$memcache->delete('overdrive_summary_' . $user->id);

		}else{
			$cancelHoldResult['result'] = false;
			$cancelHoldResult['message'] = 'There was an error cancelling your hold.';
		}

		curl_close($overDriveInfo['ch']);

		return $cancelHoldResult;
	}

	/**
	 *
	 * .
	 *
	 * @param string $overDriveId
	 * @param int $format
	 * @param int $lendingPeriod  the number of days that the user would like to have the title chacked out. or -1 to use the default
	 * @param User $user
	 */
	public function checkoutOverDriveItem($overDriveId, $user){
		global $logger;
		$checkoutResult = array();
		$checkoutResult['result'] = false;
		$checkoutResult['message'] = '';
		
		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);
		$closeSession = true;
		
		

		if ($overDriveInfo){
			//Set up the URL
			$checkoutUrl = $overDriveInfo['checkoutUrl'];
			//Set up the required parameters
			$checkoutUrl = $checkoutUrl.'&ReserveID='.$overDriveId.'&URL=MyAccount.htm?PerPage=80';
			//$logger->log("Checkout URL ".$checkoutUrl, PEAR_LOG_INFO);
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $checkoutUrl);
			
			//Send the command and process the result
			$checkoutResultPage = curl_exec($ch);
			$logger->log("Checkout Result ".$checkoutResultPage." end OD checkout result", PEAR_LOG_INFO);
			if (strpos($checkoutResultPage,'Digital Media Catalog - Error page') == 0) {
				$checkoutResult['result'] = true;
				$checkoutResult['message'] = "Your title was checked out successfully. Please go to Checked Out Items to download the title from your Account.";
			}elseif (strpos($checkoutResultPage,'You have already checked out this title. To access it, return to your Bookshelf from the Account page') > 0) {
				$checkoutResult['result'] = false;
				$checkoutResult['message'] = "You have already checked this title out";
			}elseif (strpos($checkoutResultPage,"You've reached your checkout limit") > 0) {
				$checkoutResult['result'] = false;
				$checkoutResult['message'] = "Sorry, you have reached your checkout limit";				
			}else{
				$checkoutResult['result'] = false;
				$checkoutResult['message'] = "Sorry, your title could not be checked out";
			}
		}else{
			$checkoutResult['result'] = false;
			$checkoutResult['message'] = 'Sorry, we could not login to OverDrive now.  Please try again in a few minutes.';
		}

		if ($checkoutResult['result'] == true){
			//Delete the cache for the record
			global $memcache;

			$memcache->delete('overdrive_summary_' . $user->id);
                        $memcache->delete('overdrive_items_' . $overDriveId);
			
		//	//Record that the entry was checked out in strands
		//	global $configArray;
		//	$eContentRecord = new EContentRecord();
		//	$eContentRecord->whereAdd("sourceUrl like '%$overDriveId'");
		//	if ($eContentRecord->find(true)){
		//		if (isset($configArray['Strands']['APID']) && $user->disableRecommendations == 0){
		//			//Get the record for the item
		//			$orderId = $user->id . '_' . time() ;
		//			$strandsUrl = "http://bizsolutions.strands.com/api2/event/purchased.sbs?needresult=true&apid={$configArray['Strands']['APID']}&item=econtentRecord{$eContentRecord->id}::0.00::1&user={$user->id}&orderid={$orderId}";
		//			$ret = file_get_contents($strandsUrl);
		//			/*global $logger;
		//			$logger->log("Strands Checkout\r\n$ret", PEAR_LOG_INFO);*/
		//			}
		//		//Add the record to the reading history
		//		require_once 'Drivers/EContentDriver.php';
		//		$eContentDriver = new EContentDriver();
		//		$eContentDriver->addRecordToReadingHistory($eContentRecord, $user);
		//	}
			curl_close($ch);
			return $checkoutResult;
		}else{
			curl_close($ch);
			return $checkoutResult;
		}
	}
	/**
	 * Logs the user in to OverDrive and returns urls for the pages that can be accessed from the account as wel
	 * as the curl handle to use when accessing the
	 *
	 * @param mixed $ch An open curl connection to use when talking to OverDrive.  Will not be closed by this method.
	 * @param User $user The user to login.
	 *
	 * @return array
	 */
	private function _loginToOverDrive($ch, $user){
		global $configArray;
		global $logger;
		$overdriveUrl = $configArray['OverDrive']['url'];

		echo "<pre>";
		print_r($overdriveUrl);
		echo "</pre>";

		curl_setopt_array($ch, array(
			CURLOPT_FOLLOWLOCATION => true,
			CURLOPT_HTTPGET => true,
			CURLOPT_URL => $overdriveUrl,
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_USERAGENT => "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0.1) Gecko/20100101 Firefox/8.0.1",
			CURLOPT_AUTOREFERER => true,
			CURLOPT_SSL_VERIFYPEER => false,
			//CURLOPT_COOKIEJAR => $cookieJar
		));
		$initialPage = curl_exec($ch);
		$pageInfo = curl_getinfo($ch);

		$urlWithSession = $pageInfo['url'];
		//$logger->log("Session URL ".$urlWithSession, PEAR_LOG_INFO);
		$urlWithSessionSSL = str_replace('http://', 'https://pittsburgh.libraryreserve.com', $urlWithSession);
		//$logger->log("Session URL SSL ".$urlWithSessionSSL, PEAR_LOG_INFO);
		
		//Go to the login form
		$loginUrl = str_replace('Default.htm', 'SignIn.htm?URL=MyAccount.htm%3fPerPage%3d80',  $urlWithSessionSSL);
						
		curl_setopt($ch, CURLOPT_URL, $loginUrl);
		$loginPageContent = curl_exec($ch);
		$loginPageInfo = curl_getinfo($ch);
		$loginFormUrl = $loginPageInfo['url'];
		//$logger->log("Login Form URL ".$loginFormUrl, PEAR_LOG_INFO);

		echo "<pre>";
		print_r($loginPageInfo);
		echo "</pre>";

		//Post to the login form
		curl_setopt($ch, CURLOPT_POST, true);
		$barcodeProperty = isset($configArray['Catalog']['barcodeProperty']) ? $configArray['Catalog']['barcodeProperty'] : 'cat_username';
		$barcode = $user->$barcodeProperty;
		if (strlen($barcode) == 5){
			$user->cat_password = '41000000' . $barcode;
		}else if (strlen($barcode) == 6){
			$user->cat_password = '4100000' . $barcode;
		}
		$postParams = array(
			'LibraryCardNumber' => $barcode,
			'URL' => 'MyAccount.htm',
		);
		if (isset($configArray['OverDrive']['LibraryCardILS']) && strlen($configArray['OverDrive']['LibraryCardILS']) > 0){
			$postParams['LibraryCardILS'] = $configArray['OverDrive']['LibraryCardILS'];
		}
		foreach ($postParams as $key => $value) {
			$post_items[] = $key . '=' . urlencode($value);
		}
		$post_string = implode ('&', $post_items);
		//$logger->log("Post Items ".$post_string, PEAR_LOG_INFO);
		
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
		$loginUrl = str_replace('SignIn.htm?URL=MyAccount.htm%3fPerPage%3d80', 'BANGAuthenticate.dll',  $loginFormUrl);
		curl_setopt($ch, CURLOPT_URL, $loginUrl);
		$myAccountMenuContent = curl_exec($ch);
		$accountPageInfo = curl_getinfo($ch);
		$logger->log("My Account Info URL ".$accountPageInfo['url'], PEAR_LOG_INFO);
		
		$matchAccount = strpos($myAccountMenuContent, 'Checkouts remaining:');
		$matchSignOut = strpos($myAccountMenuContent, 'URL=SignOutConfirm.htm');
		if (($matchAccount > 0) && ($matchSignOut > 0)){
			//$logger->log("Logging in to OverDrive ($matchAccount, $matchCart), page results: \r\n" . $myAccountMenuContent, PEAR_LOG_INFO);
			$overDriveInfo = array(
				'accountUrl' => str_replace('BANGAuthenticate.dll', 'MyAccount.htm?PerPage=80', $loginUrl),
				'holdsUrl' => str_replace('Default.htm', 'MyAccount.htm?PerPage=80#myAccount2',  $urlWithSessionSSL),
				'bookshelfUrl' => str_replace('Default.htm', 'MyAccount.htm?PerPage=80&ForceLoginFlag=0',  $urlWithSessionSSL),
				'placeHoldUrl' => str_replace('Default.htm', 'BANGAuthenticate.dll?Action=AuthCheck&amp;ForceLoginFlag=0&amp;URL=WaitingListForm.htm',  $urlWithSessionSSL),
				'baseLoginUrl' => str_replace('Default.htm', 'BANGAuthenticate.dll',  $urlWithSessionSSL),
				'baseUrl' => str_replace('BANGAuthenticate.dll', '', $loginUrl),
				'downloadUrl' => str_replace('Default.htm', '',  $urlWithSessionSSL),
				'waitingListUrl' => str_replace('Default.htm', 'BANGAuthenticate.dll?Action=AuthCheck&ForceLoginFlag=0&URL=WaitingListForm.htm',  $urlWithSession),
				'contentInfoPage' => str_replace('Default.htm', 'ContentDetails.htm',  $urlWithSessionSSL),
				'returnUrl' => str_replace('Default.htm', 'BANGPurchase.dll?Action=EarlyReturn&URL=MyAccount.htm%3FPerPage=80',  $urlWithSession),
				'checkoutUrl' => str_replace('Default.htm', 'BANGPurchase.dll?Action=OneClickCheckout&ForceLoginFlag=0', $urlWithSessionSSL),
				'ch' => $ch
			);
		}else{
			//global $logger;
			//$logger->log("Could not login to OverDrive($matchAccount), page results: \r\n" . $myAccountMenuContent, PEAR_LOG_INFO);
			$logger->log("Could not login to OverDrive($matchAccount)", PEAR_LOG_INFO);
			$overDriveInfo = null;
		}

		return $overDriveInfo;
	}

	public function getOverdriveHoldings($overDriveId, $overdriveUrl){
		require_once('sys/eContent/OverdriveItem.php');
		//get the url for the page in overdrive
		global $memcache;
		global $configArray;
		global $timer;
		$timer->logTime('Starting _getOverdriveHoldings');

		if ($overDriveId == null || strlen($overDriveId) == 0 ){
			$items = array();
		}else{
			$items = $memcache->get('overdrive_items_' . $overDriveId, MEMCACHE_COMPRESSED);
			if ($items == false){
				$items = array();
				//Get base availability for the title
				$availability = $this->getProductAvailability($overDriveId);
				$availableCopies = $availability->copiesAvailable;
				$holdQueueLength = $availability->numberOfHolds;
				$totalCopies = $availability->copiesOwned;

				//Get base metadata for the title
				$metadata = $this->getProductMetadata($overDriveId);
				//print_r($metadata);
				foreach ($metadata->formats as $format){
					$overdriveItem = new OverdriveItem();
					$overdriveItem->overDriveId = $overDriveId;
					$overdriveItem->format = $format->name;
					if (strcasecmp($overdriveItem->format, "Adobe EPUB eBook") == 0){
						$overdriveItem->formatId = 410;
					}elseif (strcasecmp($overdriveItem->format, "Kindle Book") == 0){
						$overdriveItem->formatId = 420;
					}elseif (strcasecmp($overdriveItem->format, "Microsoft eBook") == 0){
						$overdriveItem->formatId = 1;
					}elseif (strcasecmp($overdriveItem->format, "OverDrive WMA Audiobook") == 0){
						$overdriveItem->formatId = 25;
					}elseif (strcasecmp($overdriveItem->format, "OverDrive MP3 Audiobook") == 0){
						$overdriveItem->formatId = 425;
					}elseif (strcasecmp($overdriveItem->format, "OverDrive Music") == 0){
						$overdriveItem->formatId = 30;
					}elseif (strcasecmp($overdriveItem->format, "OverDrive Video") == 0){
						$overdriveItem->formatId = 35;
					}elseif (strcasecmp($overdriveItem->format, "Adobe PDF eBook") == 0){
						$overdriveItem->formatId = 50;
					}elseif (strcasecmp($overdriveItem->format, "Palm") == 0){
						$overdriveItem->formatId = 150;
					}elseif (strcasecmp($overdriveItem->format, "Mobipocket eBook") == 0){
						$overdriveItem->formatId = 90;
					}elseif (strcasecmp($overdriveItem->format, "Disney Online Book") == 0){
						$overdriveItem->formatId = 302;
					}elseif (strcasecmp($overdriveItem->format, "Open PDF eBook") == 0){
						$overdriveItem->formatId = 450;
					}elseif (strcasecmp($overdriveItem->format, "OverDrive Read") == 0){
						$overdriveItem->formatId = 610;	
					}elseif (strcasecmp($overdriveItem->format, "Open EPUB eBook") == 0){
						$overdriveItem->formatId = 810;
					}
					if ($format->fileSize > 0){
						$overdriveItem->size = $format->fileSize;
					}else{
						$overdriveItem->size = 'unknown';
					}
					//For now treat all advantage titles as available until we can use the API to check better.
					$overdriveItem->available = ($availableCopies > 0);
					$overdriveItem->lastLoaded = time();

					$overdriveItem->availableCopies = isset($availableCopies) ? $availableCopies : null;
					$overdriveItem->totalCopies = isset($totalCopies) ? $totalCopies : null;
					$overdriveItem->numHolds = isset($holdQueueLength) ? $holdQueueLength : null;
					$items[] = $overdriveItem;
				}

				$memcache->set('overdrive_items_' . $overDriveId, $items, 0, $configArray['Caching']['overdrive_items']);
			}
			return $items;
		}
	}

	public function getLoanPeriodsForFormat($formatId){
		if ($formatId == 35){
			return array(3, 5, 7);
		}else{
			return array(7, 14, 21);
		}
	}
	
	public function returnOverDriveItem($overDriveId, $transactionId, $user){
		global $logger;
		global $memcache;
		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);
		$closeSession = true;

		//Switch back to get method
		curl_setopt($overDriveInfo['ch'], CURLOPT_HTTPGET, true);

		//Open the record page
		$contentInfoPage = $overDriveInfo['contentInfoPage'] . "?ID=" . $overDriveId;
		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $contentInfoPage);
		$recordPage = curl_exec($overDriveInfo['ch']);
		$recordPageInfo = curl_getinfo($overDriveInfo['ch']);

		//Do one click checkout
		$returnUrl = $overDriveInfo['returnUrl'] . '&ReserveID=' . $overDriveId . '&TransactionID=' . $transactionId;
		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $returnUrl);
		$returnPage = curl_exec($overDriveInfo['ch']);

		$result = array();
		//We just go back to the main account page, to see if the return succeeded, we need to make sure the
		//transaction is no longer listed
		if (!preg_match("/$transactionId/si", $returnPage)){
			$result['result'] = true;
			$result['message'] = "Your title was returned successfully.";
			$memcache->delete('overdrive_summary_' . $user->id);

		}else{
			$logger->log("OverDrive return failed", PEAR_LOG_ERR);
			//$logger->log($checkoutPage, PEAR_LOG_INFO);
			$result['result'] = false;
			$result['message'] = 'Sorry, we could not return this title for you.  Please try again later';
		}
		return $result;
	}	

	public function selectOverDriveDownloadFormat($overDriveId, $formatId, $user){
		global $logger;
		global $memcache;
		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);

		//Switch back to get method
		curl_setopt($overDriveInfo['ch'], CURLOPT_HTTPGET, true);

		$result = array(
			'result' => true,
			'downloadUrl' => $overDriveInfo['baseLoginUrl'] . 'BANGPurchase.dll?Action=Download&ReserveID=' . $overDriveId . '&FormatID=' . $formatId . '&url=MyAccount.htm'
		);
		$memcache->delete('overdrive_summary_' . $user->id);
		curl_close($ch);
		return $result;
	}

	public function updateLendingOptions(){
		global $memcache;
		global $user;
		global $logger;
		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);
		$closeSession = true;

		$updateSettingsUrl = $overDriveInfo['baseUrl']  . 'BANGAuthenticate.dll?Action=EditUserLendingPeriodsFormatClass';
		$postParams = array(
			'URL' => 'MyAccount.htm?PerPage=80#myAccount4',
		);

		//Load settings
		foreach ($_REQUEST as $key => $value){
			if (preg_match('/class_\d+_preflendingperiod/i', $key)){
				$postParams[$key] = $value;
			}
		}

		$post_items = array();
		foreach ($postParams as $key => $value) {
			$post_items[] = $key . '=' . urlencode($value);
		}
		$post_string = implode ('&', $post_items);
		curl_setopt($overDriveInfo['ch'], CURLOPT_POSTFIELDS, $post_string);
		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $updateSettingsUrl);

		$logger->log("Updating user lending options $updateSettingsUrl $post_string", PEAR_LOG_DEBUG);
		$lendingOptionsPage = curl_exec($overDriveInfo['ch']);
		//$logger->log($lendingOptionsPage, PEAR_LOG_DEBUG);

		$memcache->delete('overdrive_summary_' . $user->id);
		return true;
	}	
}
