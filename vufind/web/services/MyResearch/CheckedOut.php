<?php
/**
 *
 * Copyright (C) Villanova University 2007.
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
 */

require_once 'services/MyResearch/MyResearch.php';
require_once 'sys/Pager.php';


//BEGIN for holds
require_once 'CatalogConnection.php';
require_once("PHPExcel.php");
//END for holds

class CheckedOut extends MyResearch{
	function launch(){
		
		global $configArray;
		global $interface;
		global $user;
		global $timer;
		
		$logger = new Logger();

		$renew_message = array();

		if (isset($_GET['selected'])){
			
			$patron = $this->catalog->patronLogin($user->cat_username, $user->cat_password);
			$profile = $this->catalog->getMyProfile($patron);
			$finesBeforeRenewal = $profile['fines'];
			$checkFinesAgain = false;

			//Call the Millennium Driver method to renew the item
			if (method_exists($this->catalog->driver, 'renewItem')) {
				
				$selectedItems = $_GET['selected'];
				$renewMessages = array();
				
				$renew_message['Total'] = 0;
				$renew_message['Unrenewed'] = 0;
				$renew_message['Renewed'] = 0;
				
				$i = 0;
				foreach ($selectedItems as $itemInfo => $selectedState){

					$i++;
					list($itemId, $itemIndex) = explode('|', $itemInfo);
					
					$data[$i]['itemId'] = $itemId;
					$data[$i]['itemIndex'] = $itemIndex;

				}
				
				// see which items are currently overdue
				$items = $this->catalog->getCheckedOutItems($patron);
				$overdueItems = array();
				foreach($items["transactions"] as $transaction)
				{
					if($transaction["overdue"])
					{
						$overdueItems[$transaction["itemid"]] = "true";
					}
				}
				
				if ($renewResult = $this->catalog->driver->renewItem($user->password, $data)){
					foreach($renewResult['items'] as $key => $value){
						if ($this->checkItem($value['id'], $data)){

							if ($value['renew_success']){
								$renew_message['Renewed']++;
							} else {
								$renew_message['Unrenewed']++;
							}
							
							if( isset($overdueItems[$value['id']]) && $value['renew_success'] )
							{
								$value['renew_message'] = "Overdue item renewed with fine applied";
								$checkFinesAgain = true;
							}

							$renew_message[$value['id']] = array(
			                    'itemId' => $value['id'],
			                    'result'  => $value['renew_success'],
			                    'message' => $value['renew_message']
			                );

							$renew_message['Total']++;

						}

					}

				}


			}

			// see if we need to double check their fines.
			if( $checkFinesAgain )
			{
				$this->catalog->cleanMyProfile($patron);
				$patron = $this->catalog->patronLogin($user->cat_username, $user->cat_password);
				$profile = $this->catalog->getMyProfile($patron);
				$finesAfterRenewal = $profile['fines'];
				if( (floatval(substr($finesAfterRenewal,1)) - floatval(substr($finesBeforeRenewal, 1))) > 0 )
				{
					// update the notifications
					$this->LoadNotifications();
					
					// flash the notification center
					$interface->assign('notificationCenterAlert',true);
				}
			}
		}
		
		// if they're coming from a Nook periodical download, return the title and tell them it worked
		if( isset($_GET["nookDownloadID"]) ) {
			require_once 'Drivers/OverDriveDriverFactory.php';
			$odriver = OverDriveDriverFactory::getDriver();
			$downloadMessage = $odriver->returnOverDriveItem($_GET["nookDownloadID"], null, $user);
			$interface->assign('showNookAlert', true);
		}
						
		// Get My Transactions
		$oneOrMoreRenewableItems = false;
		if ($this->catalog->status) {
			if ($user->cat_username) {
				$patron = $this->catalog->patronLogin($user->cat_username, $user->cat_password);
				$timer->logTime("Logged in patron to get checked out items.");
				if (PEAR::isError($patron))
				PEAR::raiseError($patron);

				$patronResult = $this->catalog->getMyProfile($patron);
				$profile = $this->catalog->getMyProfile($user);
				$sumOfCheckoutItems = $profile["numCheckedOut"];
				if (!PEAR::isError($patronResult)) {
					$interface->assign('profile', $patronResult);
				}
				$timer->logTime("Got patron profile to get checked out items.");
				
				$libraryHoursMessage = Location::getLibraryHoursMessage($patronResult['homeLocationId']);
				$interface->assign('libraryHoursMessage', $libraryHoursMessage);

				// Define sorting options
				$sortOptions = array(
						'dueDate' => 'Due Date',
						'title'   => 'Title',
						'author'  => 'Author',
						'format'  => 'Format'
				);
				$interface->assign('sortOptions', $sortOptions);
				$selectedSortOption = isset($_REQUEST['accountSort']) ? $_REQUEST['accountSort'] : 'dueDate';
				$interface->assign('defaultSortOption', $selectedSortOption);
				$page = isset($_REQUEST['page']) ? $_REQUEST['page'] : 1;

				$recordsPerPage = isset($_REQUEST['pagesize']) && (is_numeric($_REQUEST['pagesize'])) ? $_REQUEST['pagesize'] : $sumOfCheckoutItems;
				$interface->assign('recordsPerPage', $recordsPerPage);
				if (isset($_GET['exportToExcel'])) {
					$recordsPerPage = -1;
					$page = 1;
				}

				$expand_physical_items = isset($_REQUEST['expand_physical_items']) ? $_REQUEST['expand_physical_items'] : null;

				$result = $this->catalog->getCheckedOutItems($patron, $page, $recordsPerPage, $selectedSortOption, $expand_physical_items);
				//$result = $this->catalog->getMyTransactions($patron, $page, $recordsPerPage, $selectedSortOption);
				
				$timer->logTime("Loaded transactions from catalog.");
				if (!PEAR::isError($result)) {

					$link = $_SERVER['REQUEST_URI'];
					if (preg_match('/[&?]page=/', $link)){
						$link = preg_replace("/page=\\d+/", "page=%d", $link);
					}else if (strpos($link, "?") > 0){
						$link .= "&page=%d";
					}else{
						$link .= "?page=%d";
					}
					if ($recordsPerPage != '-1'){
						$options = array('totalItems' => $result['numTransactions'],
					                 'fileName'   => $link,
					                 'perPage'    => $recordsPerPage,
					                 'append'    => false,
						);
						$pager = new VuFindPager($options);
						$interface->assign('pageLinks', $pager->getLinks());
					}

					$transList = array();
					// Check expiration date, ptype, and mblock fields to determine if the patron can renew items
					// ptypes 6 (business) and 8 (ILL) do not block renewals even if the card is expired or blocked
					$patronCanRenew = true;
					$renewalBlockReason = null;
					if (($profile["expireclose"] == -1) && ($profile["ptype"] != '6') && ($profile["ptype"] != '8')) {
						$patronCanRenew = false;
						$renewalBlockReason = "your card is expired";
					}else if (($profile["mblock"] != "-") && ($profile["ptype"] != '6') && ($profile["ptype"] != '8')) {
						$patronCanRenew = false;
						$renewalBlockReason = "your account is blocked";
					}else{
						$patronCanRenew = true;
						$renewalBlockReason = null;
					}
					$interface->assign('patronCanRenew', $patronCanRenew);
					$interface->assign('renewalBlockReason', $renewalBlockReason);
					//$interface->assign('expireclose', $profile["expireclose"]);
					
					foreach ($result['transactions'] as $i => $data) {
						$itemBarcode = isset($data['barcode']) ? $data['barcode'] : null;
						$itemId = isset($data['itemid']) ? $data['itemid'] : null;

						if ($itemId != null && isset($renew_message[$itemId])){
							$renewMessage = $renew_message[$itemId]['message'];
							$renewResult = $renew_message[$itemId]['result'];
							$data['renewMessage'] = $renewMessage;
							$data['renewResult']  = $renewResult;
							$result['transactions'][$i] = $data;
							unset($renew_message[$itemId]);
							$logger->log("Found renewal message in session for $itemBarcode", PEAR_LOG_INFO);
						}else if ($itemId != null && isset($_SESSION['renew_message'][$itemId])){
							$renewMessage = $renew_message[$itemId]['message'];
							$renewResult = $renew_message[$itemId]['result'];
							$data['renewMessage'] = $renewMessage;
							$data['renewResult']  = $renewResult;
							$result['transactions'][$i] = $data;
							unset($renew_message[$itemId]);
							$logger->log("Found renewal message in session for $itemBarcode", PEAR_LOG_INFO);
						}else{
							$renewMessage = null;
							$renewResult = null;
						}
					
					}
					$interface->assign('transList', $result['transactions']);
				}
			}
		}
		
		//Determine which columns to show 
		$ils = $configArray['Catalog']['ils'];
		$showOut = ($ils == 'Horizon');
		$showRenewed = ($ils == 'Horizon' || $ils == 'Millennium');
		$showWaitList = ($ils == 'Horizon');
		
		$interface->assign('showOut', $showOut);
		$interface->assign('showRenewed', $showRenewed);
		$interface->assign('showWaitList', $showWaitList);

		if (isset($_GET['exportToExcel'])) {
			$this->exportToExcel($result['transactions'], $showOut, $showRenewed, $showWaitList);
		}
		
		
		//*BEGIN for holds
		if (isset($_REQUEST['multiAction'])){
			$multiAction = $_REQUEST['multiAction'];
			$waitingHoldSelected = $_REQUEST['waitingHoldSelected'];
			$availableHoldSelected = $_REQUEST['availableHoldSelected'];
			$locationId = $_REQUEST['location'];
			$i = 0;
			$xnum = array();
			$cancelId = array();
			$requestId = array();
			$freeze = '';
			if ($multiAction == 'cancelSelected'){
				$type = 'cancel';
				$freeze = '';
			}elseif ($multiAction == 'freezeSelected'){
				$type = 'update';
				$freeze = 'on';

			}elseif ($multiAction == 'thawSelected'){
				$type = 'update';
				$freeze = 'off';

			}elseif ($multiAction == 'updateSelected'){
				$type = 'update';
				$freeze = '';
			}
			$result = $this->catalog->driver->updateHoldDetailed($requestId, $user->password, $type, $title, null, $cancelId, $locationId, $freeze);

			//Redirect back here without the extra parameters.
			header("Location: " . $configArray['Site']['url'] . '/MyResearch/Holds?accountSort=' . ($selectedSortOption = isset($_REQUEST['accountSort']) ? $_REQUEST['accountSort'] : 'title'));
			die();
		}

		global $librarySingleton;
		$interface->assign('allowFreezeHolds', true);

		// Define sorting options
		$sortOptions = array(
				'dueDate' => 'Due Date',
				'title' => 'Title',
				'author' => 'Author',
				'format' => 'Format'
				);
		$interface->assign('sortOptions', $sortOptions);
		$selectedSortOption = isset($_REQUEST['accountSort']) ? $_REQUEST['accountSort'] : 'dueDate';
		$interface->assign('defaultSortOption', $selectedSortOption);

		$profile = $this->catalog->getMyProfile($user);

		$libraryHoursMessage = Location::getLibraryHoursMessage($profile['homeLocationId']);
		$interface->assign('libraryHoursMessage', $libraryHoursMessage);

		$ils = $configArray['Catalog']['ils'];
		$allowChangeLocation = ($ils == 'Millennium');
		$interface->assign('allowChangeLocation', $allowChangeLocation);
		$showPlacedColumn = ($ils == 'Horizon');
		$interface->assign('showPlacedColumn', $showPlacedColumn);
		$showDateWhenSuspending = ($ils == 'Horizon');
		$interface->assign('showDateWhenSuspending', $showDateWhenSuspending);
		$showPosition = ($ils == 'Horizon');
		$interface->assign('showPosition', $showPosition);
		
		/**BEGIN for Overdrive Checkout Items**/

		//if (isset($expand_physical_items)){

			$interface->assign('expand_physical_items', $expand_physical_items);

			require_once 'Drivers/OverDriveDriverFactory.php';
			require_once 'sys/eContent/EContentRecord.php';

			$overDriveDriver = OverDriveDriverFactory::getDriver();
			$overDriveCheckedOutItems = $overDriveDriver->getOverDriveCheckedOutItems($user);
			//Load the full record for each item in the wishlist
			foreach ($overDriveCheckedOutItems['items'] as $key => $item){

				if ($item['recordId'] != -1){
					$econtentRecord = new EContentRecord();
					$econtentRecord->id = $item['recordId'];
					$econtentRecord->find(true);
					$item['record'] = clone($econtentRecord);
				} else{
					$item['record'] = null;
				}
				$overDriveCheckedOutItems['items'][$key] = $item;
			}

			$interface->assign('overDriveCheckedOutItems', $overDriveCheckedOutItems['items']);
			$interface->assign('ButtonBack',true);
			$interface->assign('ButtonHome',true);
			$interface->assign('MobileTitle','OverDrive Checked Out Items');

		//}

		
		
		$sortOptions = array(
				'dueDate' => 'Due Date',
				'title'   => 'Title',
				'author'  => 'Author',
				'format'  => 'Format'
				);
		$interface->assign('sortOptions', $sortOptions);
		/**END for Overdrive Checkout Items**/
		
		$interface->assign('patron',$patron);
		$interface->setTemplate('checkedout.tpl');
		$interface->setPageTitle('My Holds');
		$interface->display('layout.tpl');
		unset($_SESSION['renew_message']);
		
		//END for holds
	}

	
	public function exportToExcel($checkedOutItems, $showOut, $showRenewed, $showWaitList) {
		//PHPEXCEL
		// Create new PHPExcel object
		$objPHPExcel = new PHPExcel();

		// Set properties
		$objPHPExcel->getProperties()->setCreator("VuFind Plus")
		->setLastModifiedBy("VuFind Plus")
		->setTitle("Office 2007 XLSX Document")
		->setSubject("Office 2007 XLSX Document")
		->setDescription("Office 2007 XLSX, generated using PHP.")
		->setKeywords("office 2007 openxml php")
		->setCategory("Checked Out Items");

		$activeSheet = $objPHPExcel->setActiveSheetIndex(0);
		$curRow = 1;
		$curCol = 0;
		$activeSheet->setCellValueByColumnAndRow($curCol, $curRow, 'Checked Out Items');
		$curRow = 3;
		$curCol = 0;
		$activeSheet->setCellValueByColumnAndRow($curCol++, $curRow, 'Title');
		$activeSheet->setCellValueByColumnAndRow($curCol++, $curRow, 'Author');
		$activeSheet->setCellValueByColumnAndRow($curCol++, $curRow, 'Format');
		if ($showOut){
			$activeSheet->setCellValueByColumnAndRow($curCol++, $curRow, 'Out');
		}
		$activeSheet->setCellValueByColumnAndRow($curCol++, $curRow, 'Due');
		if ($showRenewed){
			$activeSheet->setCellValueByColumnAndRow($curCol++, $curRow, 'Renewed');
		}
		if ($showWaitList){
			$activeSheet->setCellValueByColumnAndRow($curCol++, $curRow, 'Wait List');
		}


		$a=4;
		//Loop Through The Report Data
		foreach ($checkedOutItems as $row) {
			$titleCell = preg_replace("/(\/|:)$/", "", $row['title']);
			if (isset ($row['title2'])){
				$titleCell .= preg_replace("/(\/|:)$/", "", $row['title2']);
			}

			if (isset ($row['author'])){
				if (is_array($row['author'])){
					$authorCell = implode(', ', $row['author']);
				}else{
					$authorCell = $row['author'];
				}
				$authorCell = str_replace('&nbsp;', ' ', $authorCell);
			}else{
				$authorCell = '';
			}
			if (isset($row['format'])){
				if (is_array($row['format'])){
					$formatString = implode(', ', $row['format']);
				}else{
					$formatString = $row['format'];
				}
			}else{
				$formatString ='';
			}
			$activeSheet = $objPHPExcel->setActiveSheetIndex(0);
			$curCol = 0;
			$activeSheet->setCellValueByColumnAndRow($curCol++, $a, $titleCell);
			$activeSheet->setCellValueByColumnAndRow($curCol++, $a, $authorCell);
			$activeSheet->setCellValueByColumnAndRow($curCol++, $a, $formatString);
			if ($showOut){
				$activeSheet->setCellValueByColumnAndRow($curCol++, $a, date('M d, Y', $row['checkoutdate']));
			}
			$activeSheet->setCellValueByColumnAndRow($curCol++, $a, date('M d, Y', $row['duedate']));
			if ($showRenewed){
				$activeSheet->setCellValueByColumnAndRow($curCol++, $a, $row['renewCount']);
			}
			if ($showWaitList){
				$activeSheet->setCellValueByColumnAndRow($curCol++, $a, $row['holdQueueLength']);
			}

			$a++;
		}
		$objPHPExcel->getActiveSheet()->getColumnDimension('A')->setAutoSize(true);
		$objPHPExcel->getActiveSheet()->getColumnDimension('B')->setAutoSize(true);
		$objPHPExcel->getActiveSheet()->getColumnDimension('C')->setAutoSize(true);
		$objPHPExcel->getActiveSheet()->getColumnDimension('D')->setAutoSize(true);
		$objPHPExcel->getActiveSheet()->getColumnDimension('E')->setAutoSize(true);
		$objPHPExcel->getActiveSheet()->getColumnDimension('F')->setAutoSize(true);
		$objPHPExcel->getActiveSheet()->getColumnDimension('G')->setAutoSize(true);

		// Rename sheet
		$objPHPExcel->getActiveSheet()->setTitle('Checked Out');

		// Redirect output to a client’s web browser (Excel5)
		header('Content-Type: application/vnd.ms-excel');
		header('Content-Disposition: attachment;filename="CheckedOutItems.xls"');
		header('Cache-Control: max-age=0');

		$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
		$objWriter->save('php://output');
		exit;

	}

	private function checkItem($id, $data){

		foreach($data as $key => $value){

			if ($id == $value['itemId']) return true;

		}

		return false;

	}

}
