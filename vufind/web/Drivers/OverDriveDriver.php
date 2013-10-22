<?php

require_once ROOT_DIR . '/sys/eContent/EContentRecord.php';

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
	public $version = 1;

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

	/**
	 * Loads information about items within the user's cart in OverDrive.
	 * No caching is done becase the cart page always changes during the checkout process.
	 *
	 * @param User $user
	 * @param array $overDriveInfo optional array of information loaded from _loginToOverDrive to improve performance.
	 *
	 * @return array
	 */
	public function getOverDriveCart($user, $overDriveInfo = null){
		$cart = array();
		$cart['items'] = array();

		$closeSession = false;
		if ($overDriveInfo['result'] == false){
			$ch = curl_init();
			if (!$ch){
				global $logger;
				$logger->log("Could not create curl handle ". $ch, PEAR_LOG_INFO);
				$cart['message'] = $overDriveInfo['message'];
				return $cart;
			}
			$overDriveInfo = $this->_loginToOverDrive($ch, $user);
			$closeSession = true;
		}

		if ($overDriveInfo['result'] == false){
			$cart['error'] = $overDriveInfo['message'];
			return $cart;
		}else{
			//Load the My Cart Page
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['cartUrl']);
			$cartPage = curl_exec($overDriveInfo['ch']);
		}

		if ($closeSession){
			curl_close($ch);
		}

		//Extract information from the holds page
		preg_match_all('/<a href="ContentDetails\\.htm\\?ID=(.*?)">(.*?)<\/a>.*?<small><b>(.*?)<\/b><\/small>.*?Lending period:\\s+(\\d+) days.*?<td.*?>(.*?)<\/td>/si', $cartPage, $cartInfo, PREG_SET_ORDER);

		for ($matchi = 0; $matchi < count($cartInfo); $matchi++) {
			$cartItem = array();
			$cartItem['overDriveId'] = $cartInfo[$matchi][1];
			$cartItem['title'] = $cartInfo[$matchi][2];
			$cartItem['subTitle'] = $cartInfo[$matchi][3];
			$cartItem['lendingPeriod'] = $cartInfo[$matchi][4];
			$cartItem['format'] = $cartInfo[$matchi][5];

			//For each item (load the record from VuFind) based on the id of the item.
			$eContentRecord = new EContentRecord();
			$eContentRecord->whereAdd("sourceUrl LIKE '%{$cartItem['overDriveId']}%'");
			if ($eContentRecord->find(true)){
				$cartItem['recordId'] = $eContentRecord->id;
			}else{
				$cartItem['recordId'] = -1;
			}

			$cart['items'][] = $cartItem;
		}

		return $cart;
	}

	/**
	 * Loads information about items within the user's wishlist in OverDrive
	 *
	 * @param User $user
	 * @param array $overDriveInfo optional array of information loaded from _loginToOverDrive to improve performance.
	 *
	 * @return array
	 */
	public function getOverDriveWishList($user, $overDriveInfo = null){
		global $memcache;
		global $configArray;
		global $timer;

		$wishlist = $memcache->get('overdrive_wishlist_' . $user->id);
		if ($wishlist == false){
			$wishlist = array();
			$wishlist['items'] = array();

			$closeSession = false;
			if ($overDriveInfo['result'] == false){
				$ch = curl_init();
				if (!$ch){
					global $logger;
					$logger->log("Could not create curl handle ". $ch, PEAR_LOG_INFO);
					$wishlist['error'] = $overDriveInfo['mesasage'];
					return $cart;
				}
				$overDriveInfo = $this->_loginToOverDrive($ch, $user);
				$closeSession = true;
			}

			if ($overDriveInfo['result'] == false){
				$wishlist['error'] = $overDriveInfo['message'];
				return $wishlist;
			}else{

				//Load the WishList Page
				curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['wishlistUrl']);
				$wishlistPage = curl_exec($overDriveInfo['ch']);
			}

			if ($closeSession){
				curl_close($ch);
			}

			//Extract information from the holds page
			preg_match_all('/<a href="ContentDetails\\.htm\\?ID=(.*?)"><img src="(.*?)".*?>.*?<\/a>.*?<a href="ContentDetails\\.htm\\?ID=.*?">(.*?)<\/a>.*?<small><strong>(.*?)<\/strong><\/small>.*?by\\s(.*?)<\/div>.*?Date added:\\s+(.*?)<!--.*?<\/tr>(.*?)<tr><td colspan="4"><hr size="1" width="100%" noshade>/si', $wishlistPage, $wishlistInfo, PREG_SET_ORDER);

			for ($matchi = 0; $matchi < count($wishlistInfo); $matchi++) {
				$wishlistItem = array();
				$wishlistItem['overDriveId'] = $wishlistInfo[$matchi][1];
				$wishlistItem['imageUrl'] = $wishlistInfo[$matchi][2];
				$wishlistItem['title'] = $wishlistInfo[$matchi][3];
				$wishlistItem['subTitle'] = $wishlistInfo[$matchi][4];
				$wishlistItem['author'] = $wishlistInfo[$matchi][5];
				$wishlistItem['dateAdded'] = $wishlistInfo[$matchi][6];
				$wishlistItem['formats'] = array();
				$formatInformation = $wishlistInfo[$matchi][7];
				preg_match_all('/<td colspan="2">(.*?)<\/td>.*?Action=(.*?)&.*?ID=(.*?)[&%].*?Format=(.*?)"/si', $formatInformation, $formatMatches, PREG_SET_ORDER);
				for ($matchj = 0; $matchj < count($formatMatches); $matchj++) {
					$format = array();
					$format['name'] = $formatMatches[$matchj][1];
					if ($formatMatches[$matchj][2] == 'Add'){
						$format['available'] = true;
					}else{
						$format['available'] = false;
					}
					$format['formatId'] = $formatMatches[$matchj][4];
					$wishlistItem['formats'][] = $format;
				}

				//For each item (load the record from VuFind) based on the id of the item.
				$eContentRecord = new EContentRecord();
				$eContentRecord->whereAdd("sourceUrl LIKE '%{$wishlistItem['overDriveId']}%'");
				if ($eContentRecord->find(true)){
					$wishlistItem['recordId'] = $eContentRecord->id;
				}else{
					$wishlistItem['recordId'] = -1;
				}

				$wishlist['items'][] = $wishlistItem;
			}
			$memcache->set('overdrive_wishlist_' . $user->id, $wishlist, 0, $configArray['Caching']['overdrive_wishlist']);
			$timer->logTime("Finished loading titles from overdrive wishlist");
		}

		return $wishlist;
	}

	/**
	 * Loads information about items that the user has checked out in OverDrive
	 *
	 * @param User $user
	 * @param array $overDriveInfo optional array of information loaded from _loginToOverDrive to improve performance.
	 *
	 * @return array
	 */
	public function getOverDriveCheckedOutItems($user, $overDriveInfo = null){
		global $memcache;
		global $configArray;
		global $timer;

		$bookshelf = $memcache->get('overdrive_checked_out_' . $user->id);
		if ($bookshelf == false){
			$bookshelf = array();
			$bookshelf['items'] = array();


			$closeSession = false;
			if ($overDriveInfo == null){
				$ch = curl_init();
				if (!$ch){
					global $logger;
					$logger->log("Could not create curl handle ". $ch, PEAR_LOG_INFO);
					$bookshelf['error'] = 'Sorry, we could not connect to OverDrive, please try again in a few minutes.';
					return $bookshelf;
				}
				$overDriveInfo = $this->_loginToOverDrive($ch, $user);
				if ($overDriveInfo['result'] == false){
					global $logger;
					$logger->log("Could not login to overdrive ". $ch, PEAR_LOG_INFO);
					$bookshelf['error'] = $overDriveInfo['message'];
					return $bookshelf;
				}
				$closeSession = true;
			}

			//Load the Bookshelf Page
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['bookshelfUrl']);
			$bookshelfPage = curl_exec($overDriveInfo['ch']);

			if ($closeSession){
				curl_close($overDriveInfo['ch']);
			}

			//Extract information from the holds page
			preg_match_all('/<img.*?src="(?:http:\/\/(.*?)|MissingThumbImage\.jpg)".*?>.*?<b>(.*?)<\/b>.*?DisplayEnhancedTitleLink.*?".*?", "(.*?)".*?<b><small>(.*?)<\/small><\/b>.*?<div style="padding-top:6px">(.*?)<script.*?<noscript>\\s*\\((.*?)\\)<\/noscript>.*?<div class="dlBtn">.*?<a href="(.*?)">.*?<div>(\\w{3} \\d{1,2}. \\d{4})<\/div>.*?<div>(\\w{3} \\d{1,2}. \\d{4})<\/div>/si', $bookshelfPage, $bookshelfInfo, PREG_SET_ORDER);

			for ($matchi = 0; $matchi < count($bookshelfInfo); $matchi++) {
				$bookshelfItem = array();
				if ($bookshelfInfo[$matchi][1]){
					$bookshelfItem['imageUrl'] = "http://" . $bookshelfInfo[$matchi][1];
				}else{
					$bookshelfItem['imageUrl'] = "";
				}
				$bookshelfItem['title'] = $bookshelfInfo[$matchi][2];
				$bookshelfItem['overDriveId'] = $bookshelfInfo[$matchi][3];
				$bookshelfItem['subTitle'] = $bookshelfInfo[$matchi][4];
				$bookshelfItem['format'] = $bookshelfInfo[$matchi][5];
				$bookshelfItem['downloadSize'] = $bookshelfInfo[$matchi][6];
				$bookshelfItem['downloadLink'] = $bookshelfInfo[$matchi][7];
				$bookshelfItem['checkedOutOn'] = $bookshelfInfo[$matchi][8];
				$bookshelfItem['checkoutdate'] = strtotime($bookshelfItem['checkedOutOn']);
				$bookshelfItem['expiresOn'] = $bookshelfInfo[$matchi][9];

				//For each item (load the record from VuFind) based on the id of the item.
				$eContentRecord = new EContentRecord();
				$eContentRecord->whereAdd("sourceUrl LIKE '%{$bookshelfItem['overDriveId']}%'");
				if ($eContentRecord->find(true)){
					$bookshelfItem['recordId'] = $eContentRecord->id;
				}else{
					$bookshelfItem['recordId'] = -1;
				}

				$bookshelf['items'][] = $bookshelfItem;
			}
			$timer->logTime("Finished loading titles from overdrive checked out titles");
			$memcache->set('overdrive_checked_out_' . $user->id, $bookshelf, 0, $configArray['Caching']['overdrive_checked_out']);
		}
		return $bookshelf;
	}

	public function getOverDriveHolds($user, $overDriveInfo = null){
		global $memcache;
		global $configArray;
		global $timer;

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
					global $logger;
					$logger->log("Could not create curl handle ". $ch, PEAR_LOG_INFO);
					$holds['error'] = 'Sorry, we could not connect to OverDrive, please try again in a few minutes.';
					return $holds;
				}
				//Login to overdrive
				$overDriveInfo = $this->_loginToOverDrive($ch, $user);
				if ($overDriveInfo['result'] == false){
					global $logger;
					$logger->log("Could not login to overdrive ". $ch, PEAR_LOG_INFO);
					$holds['error'] = $overDriveInfo['message'];
					return $holds;
				}
				$closeSession = true;
			}

			//Load the My Holds page
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['holdsUrl']);
			$holdsPage = curl_exec($overDriveInfo['ch']);

			if ($closeSession){
				curl_close($overDriveInfo['ch']);
			}

			//Extract unavailable hold information from the holds page
			preg_match_all('/<a href="ContentDetails\\.htm\\?ID=(.*?)"><img.*?src="(.*?)".*?<\/a>.*?<strong><a href="ContentDetails\\.htm\\?ID=(.*?)">(.*?)<\/a><\/strong>.*?<small><strong>(.*?)<\/strong><\/small>.*?<small>.*?<\/noscript>\\s*(.*?)<\/small>.*?<small>(.*?)<table.*?>(.*?)<\/table>/si', $holdsPage, $holdInfo, PREG_SET_ORDER);

			for ($matchi = 0; $matchi < count($holdInfo); $matchi++) {
				$hold = array();
				$hold['overDriveId'] = $holdInfo[$matchi][1];
				$hold['imageUrl'] = $holdInfo[$matchi][2];
				$hold['title'] = $holdInfo[$matchi][4];
				$hold['subTitle'] = $holdInfo[$matchi][5];
				$hold['author'] = $holdInfo[$matchi][6];
				$notificationInformation = $holdInfo[$matchi][7];
				$linkInformation = $holdInfo[$matchi][8];

				//For each item (load the record from VuFind) based on the id of the item.
				$eContentRecord = new EContentRecord();
				$eContentRecord->whereAdd("sourceUrl LIKE '%{$hold['overDriveId']}%'");
				if ($eContentRecord->find(true)){
					$hold['recordId'] = $eContentRecord->id;
				}else{
					$hold['recordId'] = -1;
				}

				//Check to see if the hold is available or unavailable
				if (preg_match('/RemoveFromWaitingList&id={?(.*?)}?&fo.*?rmat=(.*?)&/si', $linkInformation, $formatInfo)) {
					//Set the format
					$hold['formatId'] = $formatInfo[2];

					//Extract the hold position
					if (preg_match('/You are patron (\\d+) out of (\\d+) on the waiting list/si', $notificationInformation, $notifyInfo)) {
						$hold['holdQueuePosition'] = $notifyInfo[1];
						$hold['holdQueueLength'] = $notifyInfo[2];
					}

					$holds['holds']['unavailable'][] = $hold;
				} else {
					//Extract the notification date
					if (preg_match('/Email notification sent: (.*?)<\/small>/si', $notificationInformation, $notifyInfo)) {
						$hold['notificationDate'] = strtotime($notifyInfo[1]);
						$hold['expirationDate'] = $hold['notificationDate'] + 3 * 24 * 60 * 60;
					}
					//Extract the formats that can be checked out.
					preg_match_all('/<td width="100%">(.*?)<\/td>.*?<a href="BANGCart\\.dll\\?Action=Add&ID={?(.*?)}?&Format=(.*?)"/si', $linkInformation, $formatInfo, PREG_SET_ORDER);
					$hold['formats'] = array();
					for ($i = 0; $i < count($formatInfo); $i++) {
						$format = array();
						$format['name'] = strip_tags($formatInfo[$i][1]);
						$format['overDriveId'] = $formatInfo[$i][2];
						$format['formatId'] = $formatInfo[$i][3];
						// $result[0][$i];
						$hold['formats'][] = $format;
					}
					$holds['holds']['available'][] = $hold;
				}
			}
			$timer->logTime("Finished loading titles from overdrive holds");
			$memcache->set('overdrive_holds_' . $user->id, $holds, 0, $configArray['Caching']['overdrive_holds']);
		}

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

		$summary = $memcache->get('overdrive_summary_' . $user->id);
		if ($summary == false){
			$summary = array();
			$ch = curl_init();

			$overDriveInfo = $this->_loginToOverDrive($ch, $user);
			$holds = $this->getOverDriveHolds($user, $overDriveInfo);
			if (isset($holds['error'])){
				$summary['numAvailableHolds'] = "Err";
				$summary['numUnavailableHolds'] = "Err";
			}else{
				$summary['numAvailableHolds'] = count($holds['holds']['available']);
				$summary['numUnavailableHolds'] = count($holds['holds']['unavailable']);
			}


			$checkedOut = $this->getOverDriveCheckedOutItems($user, $overDriveInfo);
			if (isset($checkedOut['error'])){
				$summary['numCheckedOut'] = "Err";
			}else{
				$summary['numCheckedOut'] = count($checkedOut['items']);
			}

			$wishlist = $this->getOverDriveWishList($user, $overDriveInfo);
			if (isset($wishlist['error'])){
				$summary['numWishlistItems'] = "Err";
			}else{
				$summary['numWishlistItems'] = count($wishlist['items']);
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
	public function placeOverDriveHold($overDriveId, $format, $user){
		global $memcache;
		global $configArray;
		global $logger;

		$holdResult = array();
		$holdResult['result'] = false;
		$holdResult['message'] = '';

		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);
		if ($overDriveInfo['result'] == false){
			$holdResult = $overDriveInfo;
		}else{

			//Switch back to get method
			curl_setopt($overDriveInfo['ch'], CURLOPT_HTTPGET, true);

			//Open the record page
			$contentInfoPage = $overDriveInfo['contentInfoPage'] . "?ID=" . $overDriveId;
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $contentInfoPage);
			$recordPage = curl_exec($overDriveInfo['ch']);
			$recordPageInfo = curl_getinfo($overDriveInfo['ch']);

			//Navigate to waiting list page
			$waitingListUrl = $overDriveInfo['waitingListUrl'];
			$waitingListUrl .= '%3FID=' . $overDriveId . '%26Format=' . $format;
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $waitingListUrl);
			$setEmailPage = curl_exec($overDriveInfo['ch']);
			$setEmailPageInfo = curl_getinfo($ch);
			if (preg_match('/already on/', $setEmailPage)){
				$holdResult['result'] = false;
				$holdResult['message'] = "We're sorry, but you are already on the waiting list for the selected title or have it checked out.";
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
					$holdResult['message'] = "We're sorry, but you are already on the waiting list for the selected title or have it checked out.";
				}else{

					//Fill out the email address to use for notification
					$postParams = array(
						'ID' => $overDriveId,
						'Format' => $format,
						'URL' => 'WaitingListConfirm.htm',
						'Email' => $user->overdriveEmail,
						'Email2' => $user->overdriveEmail,
					);
					foreach ($postParams as $key => $value) {
						$post_items[] = $key . '=' . urlencode($value);
					}
					$post_string = implode ('&', $post_items);
					curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
					curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $secureBaseUrl . 'BANGAuthenticate.dll?Action=LibraryWaitingList');
					$waitingListConfirm = curl_exec($overDriveInfo['ch']);

					if (preg_match('/did not complete all of the required fields/', $waitingListConfirm)){
						$logger->log($waitingListConfirm, PEAR_LOG_INFO);
						$holdResult['result'] = false;
						$holdResult['message'] = 'You must provide an e-mail address to request titles from OverDrive.  Please add an e-mail address to your profile.';
					}elseif (preg_match('/reached the request \(hold\) limit of \d+ titles./', $waitingListConfirm)){
						$holdResult['result'] = false;
						$holdResult['message'] = 'You have reached the maximum number of holds for your account.';
					}elseif (preg_match('/You have successfully placed a hold on the selected title./', $waitingListConfirm)){
						$holdResult['result'] = true;
						$holdResult['message'] = 'Your hold was placed successfully.';

						$memcache->delete('overdrive_holds_' . $user->id);
						$memcache->delete('overdrive_summary_' . $user->id);

						//Record that the entry was checked out in strands
						global $configArray;
						if (isset($configArray['Strands']['APID']) && $user->disableRecommendations == 0){
							//Get the record for the item
							$eContentRecord = new EContentRecord();
							$eContentRecord->whereAdd("sourceUrl like '%$overDriveId'");
							if ($eContentRecord->find(true)){
								$orderId = $user->id . '_' . time() ;
								$strandsUrl = "http://bizsolutions.strands.com/api2/event/addshoppingcart.sbs?needresult=true&apid={$configArray['Strands']['APID']}&item=econtentRecord{$eContentRecord->id}::0.00::1&user={$user->id}&orderid={$orderId}";
								$ret = file_get_contents($strandsUrl);
								/*global $logger;
								$logger->log("Strands Hold\r\n$ret", PEAR_LOG_INFO);*/
							}
						}

						//Delete the cache for the record
						$memcache->delete('overdrive_record_' . $overDriveId);
					}else{
						$holdResult['result'] = false;
						$holdResult['message'] = 'There was an error placing your hold.';
						global $logger;
						$logger->log("Placing hold on OverDrive item. OverDriveId ". $overDriveId, PEAR_LOG_INFO);
						$logger->log('URL: '.$secureBaseUrl . "BANGAuthenticate.dll?Action=LibraryWaitingList $post_string\r\n" . $waitingListConfirm ,PEAR_LOG_INFO);
					}
				}
			}
		}
		curl_close($ch);

		return $holdResult;
	}

	public function cancelOverDriveHold($overDriveId, $format, $user){
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
		$holdCancelUrl = $overDriveInfo['baseLoginUrl'] . "?Action=RemoveFromWaitingList&id={{$overDriveId}}&format=$format&url=waitinglistremove.htm";
		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $holdCancelUrl);
		$cancellationResult = curl_exec($overDriveInfo['ch']);

		if (preg_match('/You have successfully cancelled your hold/', $cancellationResult)){
			$cancelHoldResult['result'] = true;
			$cancelHoldResult['message'] = 'Your hold was cancelled successfully.';

			//Check to see if the user has cached hold information and if so, clear it
			$memcache->delete('overdrive_holds_' . $user->id);
			$memcache->delete('overdrive_summary_' . $user->id);

			//Delete the cache for the record
			$memcache->delete('overdrive_record_' . $overDriveId);
		}else{
			$cancelHoldResult['result'] = false;
			$cancelHoldResult['message'] = 'There was an error cancelling your hold.';
		}

		curl_close($overDriveInfo['ch']);

		return $cancelHoldResult;
	}

	public function removeOverDriveItemFromWishlist($overDriveId, $user){
		global $memcache;

		global $logger;


		$cancelHoldResult = array();
		$cancelHoldResult['result'] = false;
		$cancelHoldResult['message'] = '';

		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);
		curl_setopt($overDriveInfo['ch'], CURLOPT_HTTPGET, true);

		//Navigate to hold cancellation page
		$wishlistCancelUrl = $overDriveInfo['baseLoginUrl'] . "?Action=AuthCheck&ForceLoginFlag=0&URL=BANGCart.dll%3FAction%3DWishListRemove%26ID%3D{$overDriveId}";

		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $wishlistCancelUrl);
		$cancellationResult = curl_exec($overDriveInfo['ch']);
		$logger->log("wishlistCancelUrlID--->". $overDriveId, PEAR_LOG_INFO);
		$logger->log("wishlistCancelUrl--->". $cancellationResult, PEAR_LOG_INFO);
		if (!preg_match("/$overDriveId/", $cancellationResult)){
			$cancelHoldResult['result'] = true;
			$cancelHoldResult['message'] = 'The title was successfully removed from your wishlist.';
			//Check to see if wishlist information has been closed and if so, clear it.
			$memcache->delete('overdrive_wishlist_' . $user->id);
			$memcache->delete('overdrive_summary_' . $user->id);
		}else{
			$cancelHoldResult['result'] = false;
			$cancelHoldResult['message'] = 'There was an error removing the item from your wishlist.';
		}

		curl_close($overDriveInfo['ch']);
		return $cancelHoldResult;
	}

	/**
	 *
	 * Add an item to the cart in overdrive for processing.
	 *
	 * @param string $overDriveId
	 * @param int $format
	 * @param User $user
	 */
	public function addItemToOverDriveCart($overDriveId, $format, $user, $overDriveInfo = null){
		$addToCartResult = array();
		$addToCartResult['result'] = false;
		$addToCartResult['message'] = '';

		$closeSession = false;
		if ($overDriveInfo == null){
			$ch = curl_init();
			if (!$ch){
				global $logger;
				$logger->log("Could not create curl handle ". $ch, PEAR_LOG_INFO);
				$addToCartResult['message'] = 'Sorry, we could not connect to OverDrive, please try again in a few minutes.';
				return $addToCartResult;
			}
			$overDriveInfo = $this->_loginToOverDrive($ch, $user);
			$closeSession = true;
		}
		if ($overDriveInfo['result'] == false){
			$addToCartResult['message'] = $overDriveInfo['message'];
			return $addToCartResult;
		}

		//Switch back to get method
		curl_setopt($overDriveInfo['ch'], CURLOPT_HTTPGET, true);

		//Open the record page
		$contentInfoPage = $overDriveInfo['contentInfoPage'] . "?ID=" . $overDriveId;
		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $contentInfoPage);
		$recordPage = curl_exec($overDriveInfo['ch']);
		$recordPageInfo = curl_getinfo($overDriveInfo['ch']);

		//Navigate to the Add To Cart page
		$addToCartUrl = $overDriveInfo['cartUrl'];
		$addToCartUrl .= "?Action=Add&ID={$overDriveId}&Format=$format";
		curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $addToCartUrl);
		$addCartConfirmation = curl_exec($overDriveInfo['ch']);
		$addCartConfirmationInfo = curl_getinfo($overDriveInfo['ch']);

		if (preg_match('/We\'re sorry, but there are currently no copies of the selected title available for check out./', $addCartConfirmation)){
			$addToCartResult['result'] = false;
			$addToCartResult['noCopies'] = true;
			$addToCartResult['message'] = 'There are no copies available for checkout, would you like to place a hold on the item instead?';
		}elseif (preg_match('/Titles added to your (?:cart|Book Bag|Digital Cart) will remain there for (\d+) minutes/i', $addCartConfirmation, $confirmationMatches)){
			$addToCartResult['result'] = true;
			$timePeriod = isset($confirmationMatches[1]) ? $confirmationMatches[1] : 30;
			$addToCartResult['message'] = "The title was added to your cart successfully.  You have $confirmationMatches[1] minutes to check out the title before it is returned to the library's collection.";
		}else{
			global $logger;
			$logger->log("Adding OverDrive Item to cart. OverDriveId ". $overDriveId, PEAR_LOG_INFO);
			$logger->log('URL: '.$addToCartUrl ."\r\n$addCartConfirmation",PEAR_LOG_INFO);
			$addToCartResult['result'] = false;
			$addToCartResult['message'] = 'There was an error adding the item to your cart.';
		}

		if ($closeSession){
			curl_close($ch);
		}

		return $addToCartResult;
	}


	/**
	 *
	 * Add an item to the wish list in overdrive for later use.
	 *
	 * @param string $overDriveId
	 * @param User $user
	 */
	public function addItemToOverDriveWishList($overDriveId, $user){
		global $memcache;

		$addToCartResult = array();
		$addToCartResult['result'] = false;
		$addToCartResult['message'] = '';

		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);

		if ($overDriveInfo['result'] != false){
			//Switch back to get method
			curl_setopt($overDriveInfo['ch'], CURLOPT_HTTPGET, true);

			//Open the record page
			$contentInfoPage = $overDriveInfo['contentInfoPage'] . "?ID=" . $overDriveId;
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $contentInfoPage);
			$recordPage = curl_exec($overDriveInfo['ch']);
			$recordPageInfo = curl_getinfo($overDriveInfo['ch']);

			//Navigate to the Add To Cart page
			$addToWishlistUrl = $overDriveInfo['addToWishlistUrl'];
			$addToWishlistUrl .= $overDriveId;
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $addToWishlistUrl);
			$addCartConfirmation = curl_exec($overDriveInfo['ch']);
			$addCartConfirmationInfo = curl_getinfo($ch);

			if (preg_match('/<td class="(?:pghead|colhead|collhead)">Wish List<\/td>./', $addCartConfirmation)
					|| preg_match('/<h1>Wish List<\/h1>/', $addCartConfirmation)){
				$addToCartResult['result'] = true;
				$addToCartResult['message'] = 'The title was added to your wishlist.';
				//Check to see if wishlist information has been closed and if so, clear it.
				$memcache->delete('overdrive_wishlist_' . $user->id);
				$memcache->delete('overdrive_summary_' . $user->id);

			}else{
				$addToCartResult['result'] = false;
				$addToCartResult['message'] = 'There was an error adding the item to your wishlist.';
				global $logger;
				$logger->log("Error adding item to wishlist ($addToWishlistUrl), page did not have wishlist\r\n$addCartConfirmation", PEAR_LOG_INFO);
			}

			curl_close($overDriveInfo['ch']);
		}else{
			$addToCartResult['result'] = false;
			$addToCartResult['message'] = $overDriveInfo['message'];
		}

		return $addToCartResult;
	}

	public function processOverDriveCart($user, $lendingPeriod, $overDriveInfo = null){
		global $logger;
		$processCartResult = array();
		$processCartResult['result'] = false;
		$processCartResult['message'] = '';

		$closeSession = false;
		if ($overDriveInfo == null){
			$ch = curl_init();
			$overDriveInfo = $this->_loginToOverDrive($ch, $user);
			$closeSession = true;
		}

		if ($overDriveInfo['result'] != false){
			//Switch back to get method
			curl_setopt($overDriveInfo['ch'], CURLOPT_HTTPGET, true);

			//Navigate to the Cart page
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['cartUrl']);
			$cartPage = curl_exec($overDriveInfo['ch']);
			$cartPageInfo = curl_getinfo($overDriveInfo['ch']);

			//Remove any duplicate titles
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['removeDupUrl']);
			$removeDupsPage = curl_exec($overDriveInfo['ch']);
			preg_match('/BEGIN PAGE CONTENT(.*?)END PAGE CONTENT/s', $removeDupsPage, $content);
			$removeDupsPage = $content[1];
			//$logger->log("Cleared duplicate titles", PEAR_LOG_INFO);
			//$logger->log($removeDupsPage, PEAR_LOG_INFO);

			if (preg_match('/your book (bag|cart) is currently empty/i', $removeDupsPage)){
				//$logger->log("Book bag is currently empty", PEAR_LOG_INFO);
				$processCartResult['result'] = false;
				$processCartResult['message'] = "This title is already checked out to you.";
				return $processCartResult;
			}

			//Navigate to Proceed to checkout page
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $overDriveInfo['checkoutUrl']);
			$checkoutPage = curl_exec($overDriveInfo['ch']);
			$checkoutPageInfo = curl_getinfo($overDriveInfo['ch']);
			if (preg_match('/exceeded your checkout limit/si', $checkoutPage)){
				$processCartResult['result'] = false;
				$processCartResult['message'] = "We're sorry, you have exceeded your checkout limit. Until one or more digital titles are removed from your account (i.e., a checkout expires so that you can check out another title, or you remove a title from your cart if you are not already at your checkout limit), you will be unable to check out additional titles.";
				return $processCartResult;
			}

			//Set the lending period and confirm the checkout
			$secureBaseUrl = preg_replace('/Checkout.htm.*/', '', $checkoutPageInfo['url']);
			curl_setopt($overDriveInfo['ch'], CURLOPT_POST, true);
			//Extract the lending periods for the items in the cart
			$postParams = array(
				'x' => 'y',
			);
			if ($lendingPeriod == -1){
				preg_match_all('/<select size="1" name="([^"]+)" class="lendingperiodcombo">.*?<option value="([^"]*)" selected>/si', $checkoutPage, $lendingPeriodInfo, PREG_SET_ORDER);
				for ($matchi = 0; $matchi < count($lendingPeriodInfo); $matchi++) {
					$postParams[$lendingPeriodInfo[$matchi][1]] = $lendingPeriodInfo[$matchi][2];
				}
			}else{
				preg_match_all('/<select size="1" name="([^"]+)" class="lendingperiodcombo">/si', $checkoutPage, $lendingPeriodInfo, PREG_SET_ORDER);
				for ($matchi = 0; $matchi < count($lendingPeriodInfo); $matchi++) {
					$postParams[$lendingPeriodInfo[$matchi][1]] = $lendingPeriod;
				}
			}
			//Get the submit url if any
			if (preg_match('/<input type="submit" value="(.*?)" label="(.*?)"><\/input>/i', $checkoutPage, $submitInfo)){
				$postParams['submit'] = $submitInfo[1];
			}

			foreach ($postParams as $key => $value) {
				$post_items[] = $key . '=' . urlencode($value);
			}
			$post_string = implode ('&', $post_items);
			curl_setopt($overDriveInfo['ch'], CURLOPT_POSTFIELDS, $post_string);
			curl_setopt($overDriveInfo['ch'], CURLOPT_URL, $secureBaseUrl . 'BANGPurchase.dll?Action=LibraryCheckout');
			$processCartConfirmation =  curl_exec($overDriveInfo['ch']);
			$processCartConfirmationInfo =  curl_getinfo($overDriveInfo['ch']);

			if (preg_match('/now available for download/si', $processCartConfirmation) || preg_match('/<td class="collhead">Download<\/td>/si', $processCartConfirmation) || preg_match('/<h1>Digital Media - Download<\/h1>/si', $processCartConfirmation)){
				$processCartResult['result'] = true;
				$processCartResult['message'] = "Your titles were checked out successfully. You may now download the titles from your Account.";
				//Remove all cached account information since th user can checkout from holds or wishlist page
				global $memcache;
				$memcache->delete('overdrive_checked_out_' . $user->id);
				$memcache->delete('overdrive_holds_' . $user->id);
				$memcache->delete('overdrive_wishlist_' . $user->id);
				$memcache->delete('overdrive_summary_' . $user->id);
			}else if (preg_match('/exceeded your checkout limit/si', $processCartConfirmation) ){
				$processCartResult['result'] = false;
				$processCartResult['message'] = "We're sorry, you have exceeded your checkout limit. Until one or more digital titles are removed from your account (i.e., a checkout expires so that you can check out another title, or you remove a title from your cart if you are not already at your checkout limit), you will be unable to check out additional titles.";
			}else if (preg_match('/You already have one or more titles currently in your Book Bag checked out/si', $processCartConfirmation)){
				$processCartResult['result'] = true;
				$processCartResult['message'] = "This title is already checked out to you.";
			}else if (preg_match('/You are barred from borrowing/si', $processCartConfirmation)){
				$processCartResult['result'] = true;
				$processCartResult['message'] = "We're sorry, your account is currently barred from borrowing OverDrive titles. Please see the circulation desk.";
			}else{
				$processCartResult['result'] = false;
				$processCartResult['message'] = 'There was an error processing your cart.';

				$logger->log("Error processing your cart {$secureBaseUrl}BANGPurchase.dll?Action=LibraryCheckout $post_string", PEAR_LOG_INFO);

				$logger->log("$processCartConfirmation", PEAR_LOG_INFO);
			}
		}else{
			$processCartResult['result'] = false;
			$processCartResult['message'] = $overDriveInfo['message'];
		}
		if ($closeSession){
			curl_close($ch);
		}

		return $processCartResult;
	}

	/**
	 *
	 * Add an item to the cart in overdrive and then process the cart so it is checked out.
	 *
	 * @param string $overDriveId
	 * @param int $format
	 * @param int $lendingPeriod  the number of days that the user would like to have the title chacked out. or -1 to use the default
	 * @param User $user
	 */
	public function checkoutOverDriveItem($overDriveId, $format, $lendingPeriod, $user){
		global $logger;
		$ch = curl_init();
		$overDriveInfo = $this->_loginToOverDrive($ch, $user);
		$closeSession = true;

		$addCartResult = $this->addItemToOverDriveCart($overDriveId, $format, $user, $overDriveInfo);
		if ($addCartResult['result'] == true){
			$processCartResult = $this->processOverDriveCart($user, $lendingPeriod, $overDriveInfo);

			if ($processCartResult['result'] == true){
				//Delete the cache for the record
				global $memcache;
				$memcache->delete('overdrive_record_' . $overDriveId);
				$memcache->delete('overdrive_items_' . $overDriveId);

				//Record that the entry was checked out in strands
				global $configArray;
				$eContentRecord = new EContentRecord();
				$eContentRecord->whereAdd("sourceUrl like '%$overDriveId'");
				if ($eContentRecord->find(true)){
					if (isset($configArray['Strands']['APID']) && $user->disableRecommendations == 0){
						//Get the record for the item

						$orderId = $user->id . '_' . time() ;
						$strandsUrl = "http://bizsolutions.strands.com/api2/event/purchased.sbs?needresult=true&apid={$configArray['Strands']['APID']}&item=econtentRecord{$eContentRecord->id}::0.00::1&user={$user->id}&orderid={$orderId}";
						$ret = file_get_contents($strandsUrl);
						/*global $logger;
						$logger->log("Strands Checkout\r\n$ret", PEAR_LOG_INFO);*/

					}
					//Add the record to the reading history
					require_once ROOT_DIR . '/Drivers/EContentDriver.php';
					$eContentDriver = new EContentDriver();
					$eContentDriver->addRecordToReadingHistory($eContentRecord, $user);
				}
			}

			curl_close($ch);
			return $processCartResult;
		}else{
			curl_close($ch);
			return $addCartResult;
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
		echo "<pre>";
		print_r($configArray['OverDrive']);
		echo "</pre>";
		$overdriveUrl = $configArray['OverDrive']['url'];
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


		if (isset($configArray['OverDrive']['uiLogin']) && isset($configArray['OverDrive']['uiPwd']) &&
				strlen($configArray['OverDrive']['uiLogin']) > 0  && strlen($configArray['OverDrive']['uiPwd']) > 0){

			global $logger;
			//Need to login to the overdrive site.
			//http://mydigitallibrary.lib.overdrive.com/E59371AB-BE51-40A1-800A-5FC62E634B4C/10/50/en/BANGAuthenticate.dll?Action=AuthTestMode
			$redirectUrl = $urlWithSession;
			$redirectUrl = str_replace($overdriveUrl, '', $redirectUrl);
			$postParams = array(
				'LoginID' => $configArray['OverDrive']['uiLogin'],
				'Password' => $configArray['OverDrive']['uiPwd'],
				'URL' => $redirectUrl
			);
			$testLoginUrl = str_replace('Default.htm', 'BANGAuthenticate.dll?Action=AuthTestMode',  $urlWithSession);
			//$logger->log("Calling login to test server $testLoginUrl", PEAR_LOG_DEBUG);
			//$logger->log(print_r($postParams, true), PEAR_LOG_DEBUG);
			curl_setopt($ch, CURLOPT_URL, $testLoginUrl);
			$post_items = array();
			foreach ($postParams as $key => $value) {
				$post_items[] = $key . '=' . urlencode($value);
			}
			$post_string = implode ('&', $post_items);
			curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
			$loginContent = curl_exec($ch);
			$logger->log("Logged in to test server: \r\n" . $loginContent, PEAR_LOG_DEBUG);
		}

		//Go to the login form
		$loginUrl = str_replace('Default.htm', 'BANGAuthenticate.dll?Action=AuthCheck&URL=MyAccount.htm&ForceLoginFlag=0',  $urlWithSession);
		curl_setopt($ch, CURLOPT_URL, $loginUrl);
		$loginPageContent = curl_exec($ch);
		$loginPageInfo = curl_getinfo($ch);
		$loginFormUrl = $loginPageInfo['url'];

		//Post to the login form
		curl_setopt($ch, CURLOPT_POST, true);
		$barcodeProperty = isset($configArray['Catalog']['barcodeProperty']) ? $configArray['Catalog']['barcodeProperty'] : 'cat_username';
		$barcode = $user->$barcodeProperty;
		if (strlen($barcode) == 5){
			$user->cat_password = '41000000' . $barcode;
		}else if (strlen($barcode) == 6){
			$user->cat_password = '4100000' . $barcode;
		}
		if (isset($configArray['OverDrive']['maxCardLength'])){
			$barcode = substr($barcode, -$configArray['OverDrive']['maxCardLength']);
		}
		$postParams = array(
			'LibraryCardNumber' => $barcode,
			'URL' => 'MyAccount.htm',
		);
		if ($configArray['OverDrive']['requirePin']){
			//TODO: for libraries that use pins in overdrive, provide the actual pin
			$postParams['LibraryCardPIN'] = $configArray['OverDrive']['testPin'];
		}
		if (isset($configArray['OverDrive']['LibraryCardILS']) && strlen($configArray['OverDrive']['LibraryCardILS']) > 0){
			$postParams['LibraryCardILS'] = $configArray['OverDrive']['LibraryCardILS'];
		}
		$post_items = array();
		foreach ($postParams as $key => $value) {
			$post_items[] = $key . '=' . urlencode($value);
		}
		$post_string = implode ('&', $post_items);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
		$loginUrl = str_replace('SignIn.htm?URL=MyAccount%2ehtm', 'BANGAuthenticate.dll',  $loginFormUrl);
		curl_setopt($ch, CURLOPT_URL, $loginUrl);
		$myAccountMenuContent = curl_exec($ch);
		$accountPageInfo = curl_getinfo($ch);

		$matchAccount = preg_match('/(?:<td class="(?:pghead|collhead)">|<h1>)(?:\sto\s)?My (?:OverDrive\s|Digital\sMedia\s|Digital\s)?Account(?:<\/td>|<\/h1>)/is', $myAccountMenuContent);
		$matchCart = preg_match('/One or more titles from a previous session have been added to your (cart|Book Cart|Book Bag|Digital Cart)/i', $myAccountMenuContent);
		if (($matchAccount > 0) || ($matchCart > 0)){

			$overDriveInfo = array(
				'result' => true,
				'holdsUrl' => str_replace('Default.htm', 'BANGAuthenticate.dll?Action=AuthCheck&URL=MyWaitingList.htm&ForceLoginFlag=0',  $urlWithSession),
				'cartUrl' => str_replace('Default.htm', 'BANGCart.dll',  $urlWithSession),
				'removeDupUrl' => str_replace('Default.htm', 'BANGCart.dll?Action=RemoveDup',  $urlWithSession),
				'lendingPeriodsUrl' => str_replace('Default.htm', 'EditLendingPeriod.htm',  $urlWithSession),
				'bookshelfUrl' => str_replace('Default.htm', 'BANGAuthenticate.dll?Action=AuthCheck&URL=MyBookshelf.htm&ForceLoginFlag=0',  $urlWithSession),
				'wishlistUrl' => str_replace('Default.htm', 'BANGAuthenticate.dll?Action=AuthCheck&URL=WishList.htm&ForceLoginFlag=0',  $urlWithSession),
				'waitingListUrl' => str_replace('Default.htm', 'BANGAuthenticate.dll?Action=AuthCheck&ForceLoginFlag=0&URL=WaitingListForm.htm',  $urlWithSession),
				'placeHoldUrl' => str_replace('Default.htm', 'BANGAuthenticate.dll?Action=LibraryWatingList',  $urlWithSession),
				'baseLoginUrl' => str_replace('Default.htm', 'BANGAuthenticate.dll',  $urlWithSession),
				'contentInfoPage' => str_replace('Default.htm', 'ContentDetails.htm',  $urlWithSession),
				'checkoutUrl' => str_replace('Default.htm', 'BANGAuthenticate.dll?Action=AuthCheck&URL=Checkout.htm&ForceLoginFlag=0', $urlWithSession),
				'addToWishlistUrl' => str_replace('Default.htm', 'BANGAuthenticate.dll?Action=AuthCheck&ForceLoginFlag=0&URL=BANGCart.dll%3FAction%3DWishListAdd%26ID%3D', $urlWithSession),
				'ch' => $ch,
			);
		}else if (preg_match('/You are barred from borrowing/si', $myAccountMenuContent)){
			$overDriveInfo = array();
			$overDriveInfo['result'] = false;
			$overDriveInfo['message'] = "We're sorry, your account is currently barred from borrowing OverDrive titles. Please see the circulation desk.";

		}else if (preg_match('/You are barred from borrowing/si', $myAccountMenuContent)){
			$overDriveInfo = array();
			$overDriveInfo['result'] = false;
			$overDriveInfo['message'] = "We're sorry, your account is currently barred from borrowing OverDrive titles. Please see the circulation desk.";

		}else if (preg_match('/Library card has expired/si', $myAccountMenuContent)){
			$overDriveInfo = array();
			$overDriveInfo['result'] = false;
			$overDriveInfo['message'] = "We're sorry, your library card has expired. Please contact your library to renew.";

		}else if (preg_match('/more than (.*?) in library fines are outstanding/si', $myAccountMenuContent)){
			$overDriveInfo = array();
			$overDriveInfo['result'] = false;
			$overDriveInfo['message'] = "We're sorry, your account cannot borrow from OverDrive because you have unpaid fines.";

		}else{
			global $logger;
			$logger->log("Could not login to OverDrive ($matchAccount, $matchCart), page results: \r\n" . $myAccountMenuContent, PEAR_LOG_INFO);
			$overDriveInfo = null;
			$overDriveInfo = array();
			$overDriveInfo['result'] = false;
			$overDriveInfo['message'] = "Unknown error logging in to OverDrive.";
		}
		global $logger;
		$logger->log(print_r($overDriveInfo, true) , PEAR_LOG_INFO);
		return $overDriveInfo;
	}

	public function getLoanPeriodsForFormat($formatId){
		if ($formatId == 35){
			return array(3, 5, 7);
		}else{
			return array(7, 14, 21);
		}
	}
}