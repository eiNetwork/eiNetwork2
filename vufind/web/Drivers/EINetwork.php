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
require_once 'Drivers/Millennium.php';

// for connection to sierra.
require_once 'sys/postgresConnection.php';

/**
 * VuFind Connector for Marmot's Innovative catalog (millenium)
 *
 * This class uses screen scraping techniques to gather record holdings written
 * by Adam Bryn of the Tri-College consortium.
 *
 * @author Adam Brin <abrin@brynmawr.com>
 *
 * Extended by Mark Noble and CJ O'Hara based on specific requirements for
 * Marmot Library Network.
 *
 * @author Mark Noble <mnoble@turningleaftech.com>
 * @author CJ O'Hara <cj@marmot.org>
 */
class EINetwork extends MillenniumDriver{
	/**
	 * Login with barcode and pin
	 * 
	 * @see Drivers/Millennium::patronLogin()
	 */
	public function patronLogin($barcode, $pin)
	{
		global $configArray;
		global $timer;
		
		if (isset($_REQUEST['password2']) && strlen($_REQUEST['password2']) > 0){
			//User is setting a pin for the first time.  Need to do an actual login rather than just checking patron dump
			$header=array();
			$header[0] = "Accept: text/xml,application/xml,application/xhtml+xml,";
			$header[0] .= "text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5";
			$header[] = "Cache-Control: max-age=0";
			$header[] = "Connection: keep-alive";
			$header[] = "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7";
			$header[] = "Accept-Language: en-us,en;q=0.5";
			$cookie = tempnam ("/tmp", "CURLCOOKIE");
			
			$curl_connection = curl_init();
			curl_setopt($curl_connection, CURLOPT_CONNECTTIMEOUT, 30);
			curl_setopt($curl_connection, CURLOPT_HTTPHEADER, $header);
			curl_setopt($curl_connection, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
			curl_setopt($curl_connection, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($curl_connection, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt($curl_connection, CURLOPT_FOLLOWLOCATION, true);
			curl_setopt($curl_connection, CURLOPT_UNRESTRICTED_AUTH, true);
			curl_setopt($curl_connection, CURLOPT_COOKIEJAR, $cookie);
			curl_setopt($curl_connection, CURLOPT_COOKIESESSION, true);
			curl_setopt($curl_connection, CURLOPT_FORBID_REUSE, false);
			curl_setopt($curl_connection, CURLOPT_HEADER, false);
			
			//Go to the login page
			$curl_url = $configArray['Catalog']['url'] . "/patroninfo";
			curl_setopt($curl_connection, CURLOPT_URL, $curl_url);
			curl_setopt($curl_connection, CURLOPT_HTTPGET, true);
			$sresult = curl_exec($curl_connection);
			
			$curl_url = $configArray['Catalog']['url'] . "/patroninfo";
			curl_setopt($curl_connection, CURLOPT_URL, $curl_url);
			
			//First post without the pin number
			$post_data = array();
			$post_data['submit.x']="35";
			$post_data['submit.y']="21";
			$post_data['code']= $barcode;
			$post_data['pin']= "";
			curl_setopt($curl_connection, CURLOPT_POST, true);
			curl_setopt($curl_connection, CURLOPT_URL, $curl_url);
			foreach ($post_data as $key => $value) {
				$post_items[] = $key . '=' . $value;
			}
			$post_string = implode ('&', $post_items);
			curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $post_string);
			$sresult = curl_exec($curl_connection);
			if (!preg_match('/Please enter your PIN/i', $sresult)){
				PEAR::raiseError('Unable to register your new pin #.  Did not get to registration page.');
			}
			
			//Now post with both pins
			$post_data = array();
			$post_items = array();
			$post_data['code']= $barcode;
			$post_data['pin1']= $pin;
			$post_data['pin2']= $_REQUEST['password2'];
			$post_data['submit.x']="35";
			$post_data['submit.y']="15";
			curl_setopt($curl_connection, CURLOPT_POST, true);
			curl_setopt($curl_connection, CURLOPT_URL, $curl_url);
			foreach ($post_data as $key => $value) {
				$post_items[] = $key . '=' . $value;
			}
			$post_string = implode ('&', $post_items);
			curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $post_string);
			set_time_limit(15);
			$sresult = curl_exec($curl_connection);
			$post_data = array();
			
			unlink($cookie);
			if (preg_match('/the information you submitted was invalid/i', $sresult)){
				PEAR::raiseError('Unable to register your new pin #.  The pin was invalid or this account already has a pin set for it.');
			}else if (preg_match('/PIN insertion failed/i', $sresult)){
				PEAR::raiseError('Unable to register your new pin #.  PIN insertion failed.');
			}
		}

		//Load the raw information about the patron. 
		// @MD - removed force refresh for all calls to patrondump. Very bad parameter. Do not touch!
		$patronDump = $this->_getPatronDump($barcode, false);

		//Check the pin number that was entered
		$pin = urlencode($pin);
		$patronDumpBarcode = $barcode;
		if (strlen($patronDumpBarcode) < 14) { $patronDumpBarcode = ".p" . $patronDumpBarcode; }
		$host=$configArray['OPAC']['patron_host'];
		$apiurl = $host . "/PATRONAPI/$patronDumpBarcode/$pin/pintest";
		
		$api_contents = file_get_contents($apiurl);
		$api_contents = trim(strip_tags($api_contents));
	
		$api_array_lines = explode("\n", $api_contents);
		foreach ($api_array_lines as $api_line) {
			$api_line_arr = explode("=", $api_line);
			$api_data[trim($api_line_arr[0])] = trim($api_line_arr[1]);
		}
	
		if (!isset($api_data['RETCOD'])){
			$userValid = false;
		}else if ($api_data['RETCOD'] == 0){
			$userValid = true;
		}else{
			$userValid = false;
		}

		//Create a variety of possible name combinations for testing purposes.
		$Fullname = str_replace(","," ",$patronDump['PATRN_NAME']);
		$Fullname = str_replace(";"," ",$Fullname);
		$Fullname = str_replace(";","'",$Fullname);
		$allNameComponents = preg_split('^[\s-]^', strtolower($Fullname));
		//$allNameComponents = array_filter($allNameComponents);
		$nameParts = explode(' ',$Fullname);
		$nameParts = array_filter($nameParts);
		$lastname = strtolower($nameParts[0]);
		$middlename = isset($nameParts[2]) ? strtolower($nameParts[2]) : '';
		$firstname = isset($nameParts[1]) ? strtolower($nameParts[1]) : $middlename;
		if ($userValid){
			$user = array(
                'id'        => $barcode,
                'username'  => $patronDump['RECORD_#'],
                'firstname' => $firstname,
                'lastname'  => $lastname,
                'fullname'  => $Fullname,     //Added to array for possible display later. 
                'cat_username' => $barcode, //Should this be $Fullname or $patronDump['PATRN_NAME']
                'cat_password' => $pin,

                'email' => isset($patronDump['EMAIL_ADDR']) ? $patronDump['EMAIL_ADDR'] : '',
                'major' => null,
                'college' => null);		
			$timer->logTime("patron logged in successfully");
			return $user;

		} else {
			$timer->logTime("patron login failed");
			return null;
		}

	}
/**
	 * Reset pin
	 * 
	 * @see Drivers/Millennium::patronPinreset()
	 */
	public function patronPinreset()
	{
		global $configArray;
		global $timer;
		
		if (isset($_REQUEST['barcode']) && strlen($_REQUEST['barcode']) > 0){
			//User has entered a barcode and requested a pin reset
			$header=array();
			$header[0] = "Accept: text/xml,application/xml,application/xhtml+xml,";
			$header[0] .= "text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5";
			$header[] = "Cache-Control: max-age=0";
			$header[] = "Connection: keep-alive";
			$header[] = "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7";
			$header[] = "Accept-Language: en-us,en;q=0.5";
			$cookie = tempnam ("/tmp", "CURLCOOKIE");
			
			$curl_connection = curl_init();
			curl_setopt($curl_connection, CURLOPT_CONNECTTIMEOUT, 30);
			curl_setopt($curl_connection, CURLOPT_HTTPHEADER, $header);
			curl_setopt($curl_connection, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
			curl_setopt($curl_connection, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($curl_connection, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt($curl_connection, CURLOPT_FOLLOWLOCATION, true);
			curl_setopt($curl_connection, CURLOPT_UNRESTRICTED_AUTH, true);
			curl_setopt($curl_connection, CURLOPT_COOKIEJAR, $cookie);
			curl_setopt($curl_connection, CURLOPT_COOKIESESSION, true);
			curl_setopt($curl_connection, CURLOPT_FORBID_REUSE, false);
			curl_setopt($curl_connection, CURLOPT_HEADER, false);
			
			//Go to the pin reset page
			$curl_url = $configArray['Catalog']['url'] . "/pinreset";
			curl_setopt($curl_connection, CURLOPT_URL, $curl_url);
			curl_setopt($curl_connection, CURLOPT_HTTPGET, true);
			$sresult = curl_exec($curl_connection);
			
			$curl_url = $configArray['Catalog']['url'] . "/pinreset";
			curl_setopt($curl_connection, CURLOPT_URL, $curl_url);
			
			//Post the barcode to request a PIN reset email
			$barcode = $_REQUEST['barcode'];
			$post_data = array();
			$post_data['submit.x']="35";
			$post_data['submit.y']="21";
			$post_data['code']= $barcode;
			curl_setopt($curl_connection, CURLOPT_POST, true);
			curl_setopt($curl_connection, CURLOPT_URL, $curl_url);
			foreach ($post_data as $key => $value) {
				$post_items[] = $key . '=' . $value;
			}
			$post_string = implode ('&', $post_items);
			curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $post_string);
			$sresult = curl_exec($curl_connection);
			if (!preg_match('/A message has been sent./i', $sresult)){
				//PEAR::raiseError('Unable to request PIN reset for this barcode');
				return false;
			}
			else {return true;}
			unlink($cookie);
		}
	}
	
	protected function _getLoginFormValues($patronInfo, $admin = false){
		global $user;
		$loginData = array();
		if ($admin){
			global $configArray;
			$loginData['name'] = $configArray['Catalog']['ils_admin_user'];
			$loginData['code'] = $configArray['Catalog']['ils_admin_pwd'];
		}else{
			$loginData['pin'] = $user->cat_password;
			$loginData['code'] = $user->cat_username;
		}
		$loginData['submit'] = 'submit';
		return $loginData;
	}
	
	protected function _getBarcode(){
		global $user;
		return $user->cat_username;
	}
	
	/*protected function _getHoldResult($holdResultPage){
		$hold_result = array();
		//Get rid of header and footer information and just get the main content
		$matches = array();

		if (preg_match('/success/', $holdResultPage)){
			//Hold was successful
			$hold_result['result'] = true;
			if (!isset($reason) || strlen($reason) == 0){
				$hold_result['message'] = 'Your hold was placed successfully';
			}else{
				$hold_result['message'] = $reason;
			}
		}else if (preg_match('/<font color="red" size="\+2">(.*?)<\/font>/is', $holdResultPage, $reason)){
			//Got an error message back.
			$hold_result['result'] = false;
			$hold_result['message'] = $reason[1];
		}else{
			//Didn't get a reason back.  This really shouldn't happen.
			$hold_result['result'] = false;
			$hold_result['message'] = 'Did not receive a response from the circulation system.  Please try again in a few minutes.';
		}

		return $hold_result;
	}*/
	
	public function updatePatronInfo($patronId){
		global $user;
		global $configArray;
		global $logger;

		//Setup the call to Millennium
		$id2= $patronId;
		$patronDump = $this->_getPatronDump($this->_getBarcode());
		//$logger->log("Before updating patron info phone number = " . $patronDump['TELEPHONE'], PEAR_LOG_INFO);

		$this->_updateVuFindPatronInfo($patronId);
		
		//Update profile information
		$extraPostInfo = array();
		$extraPostInfo['tele1'] = $_REQUEST['phone'];
		$extraPostInfo['email'] = $_REQUEST['email'];
		if (isset($_REQUEST['notices'])){
			$extraPostInfo['notices'] = $_REQUEST['notices'];
		}

		//Login to the patron's account
		$cookieJar = tempnam ("/tmp", "CURLCOOKIE");
		$success = false;

		$curl_url = $configArray['Catalog']['url'] . "/patroninfo";

		$curl_connection = curl_init($curl_url);
		curl_setopt($curl_connection, CURLOPT_CONNECTTIMEOUT, 30);
		curl_setopt($curl_connection, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
		curl_setopt($curl_connection, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl_connection, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($curl_connection, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($curl_connection, CURLOPT_UNRESTRICTED_AUTH, true);
		curl_setopt($curl_connection, CURLOPT_COOKIEJAR, $cookieJar );
		curl_setopt($curl_connection, CURLOPT_COOKIESESSION, false);
		curl_setopt($curl_connection, CURLOPT_POST, true);
		$post_data = $this->_getLoginFormValues($patronDump);
		foreach ($post_data as $key => $value) {
			$post_items[] = $key . '=' . urlencode($value);
		}
		$post_string = implode ('&', $post_items);
		curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $post_string);
		$sresult = curl_exec($curl_connection);

		//Issue a post request to update the patron information
		$post_items = array();
		foreach ($extraPostInfo as $key => $value) {
			$post_items[] = $key . '=' . urlencode($value);
		}
		$patronUpdateParams = implode ('&', $post_items);
		curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $patronUpdateParams);
		$scope = isset($scope) ? $scope : null;
		$curl_url = $configArray['Catalog']['url'] . "/patroninfo~S{$scope}/" . $patronDump['RECORD_#'] ."/modpinfo";
		curl_setopt($curl_connection, CURLOPT_URL, $curl_url);
		$sresult = curl_exec($curl_connection);

		curl_close($curl_connection);
		unlink($cookieJar);
		
		//$logger->log("After updating phone number = " . $patronDump['TELEPHONE']);

		//Should get Patron Information Updated on success
		if (preg_match('/Patron information updated/', $sresult)){
			// clear this info out of the cache
			$this->cleanMyProfile(array('id' => $this->_getBarcode()));
			$patronDump = $this->_getPatronDump($this->_getBarcode());
			$user->phone = $_REQUEST['phone'];
			$user->email = $_REQUEST['email'];
			$user->update();
			//Update the serialized instance stored in the session
			$_SESSION['userinfo'] = serialize($user);
			return "Your information was updated successfully.  It may take a minute for changes to be reflected in the catalog.";
		}else{
			return "Your patron information could not be updated.";
		}

	}
	
	function updatePin(){
		global $user;
		global $configArray;
		if (!$user){
			return "You must be logged in to update your pin number.";
		}
		if (isset($_REQUEST['pin'])){
			$pin = $_REQUEST['pin'];
		}else{
			return "Please enter your current pin number";
		}
		if ($user->cat_password != $pin){
			return "The current pin number is incorrect";
		}
		if (isset($_REQUEST['pin1'])){
			$pin1 = $_REQUEST['pin1'];
		}else{
			return "Please enter the new pin number";
		}
		if (isset($_REQUEST['pin2'])){
			$pin2 = $_REQUEST['pin2'];
		}else{
			return "Please enter the new pin number again";
		}
		if ($pin1 != $pin2){
			return "The pin number does not match the confirmed number, please try again.";
		}
		
		//Login to the patron's account
		$cookieJar = tempnam ("/tmp", "CURLCOOKIE");
		$success = false;

		$barcode = $this->_getBarcode();
		$patronDump = $this->_getPatronDump($barcode);
		
		//Login to the site
		$curl_url = $configArray['Catalog']['url'] . "/patroninfo";
		
		$curl_connection = curl_init($curl_url);
		$header=array();
		$header[0] = "Accept: text/xml,application/xml,application/xhtml+xml,";
		$header[0] .= "text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5";
		$header[] = "Cache-Control: max-age=0";
		$header[] = "Connection: keep-alive";
		$header[] = "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7";
		$header[] = "Accept-Language: en-us,en;q=0.5";
		curl_setopt($curl_connection, CURLOPT_CONNECTTIMEOUT, 30);
		curl_setopt($curl_connection, CURLOPT_HTTPHEADER, $header);
		curl_setopt($curl_connection, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
		curl_setopt($curl_connection, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl_connection, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($curl_connection, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($curl_connection, CURLOPT_UNRESTRICTED_AUTH, true);
		curl_setopt($curl_connection, CURLOPT_COOKIEJAR, $cookieJar );
		curl_setopt($curl_connection, CURLOPT_COOKIESESSION, false);
		curl_setopt($curl_connection, CURLOPT_POST, true);
		$post_data = $this->_getLoginFormValues($patronDump);
		foreach ($post_data as $key => $value) {
			$post_items[] = $key . '=' . urlencode($value);
		}
		$post_string = implode ('&', $post_items);
		curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $post_string);
		$sresult = curl_exec($curl_connection);
		
		//Issue a post request to update the pin
		$post_data = array();
		$post_data['pin']= $pin;
		$post_data['pin1']= $pin1;
		$post_data['pin2']= $pin2;
		$post_data['submit.x']="35";
		$post_data['submit.y']="15";
		$post_items = array();
		foreach ($post_data as $key => $value) {
			$post_items[] = $key . '=' . urlencode($value);
		}
		$post_string = implode ('&', $post_items);
		curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $post_string);
		$curl_url = $configArray['Catalog']['url'] . "/patroninfo/" .$patronDump['RECORD_#'] . "/newpin";
		curl_setopt($curl_connection, CURLOPT_URL, $curl_url);
		$sresult = curl_exec($curl_connection);

		curl_close($curl_connection);
		unlink($cookieJar);
		
		if ($sresult){
			if (preg_match('/<font color=red.*?>.*?<em>(.*?)<\/em>.*?<\/font>/msi', $sresult, $matches)){
				return $matches[1];
			}else{
				$user->cat_password = $pin1;
				$user->password = $pin1;
				$user->update();
				UserAccount::updateSession($user);
				return $configArray['Constants']['PIN_MODIFICATION_SUCCESS']; 
			}
		}else{
			return "Sorry, we could not update your pin number. Please try again later.";
		}
	}
	
	function selfRegister(){
		global $logger;
		global $configArray;

		$firstName = $_REQUEST['firstName'];
		$middleInitial = $_REQUEST['middleInitial'];
		$lastName = $_REQUEST['lastName'];
		$address1 = $_REQUEST['address1'];
		$address2 = $_REQUEST['address2'];
		$address3 = $_REQUEST['address3'];
		$address4 = $_REQUEST['address4'];
		$email = $_REQUEST['email'];
		$gender = $_REQUEST['gender'];
		$birthDate = $_REQUEST['birthDate'];
		$phone = $_REQUEST['phone'];

		$cookie = tempnam ("/tmp", "CURLCOOKIE");
		$curl_url = $configArray['Catalog']['url'] . "/selfreg~S" . $this->getMillenniumScope();
		$logger->log('Loading page ' . $curl_url, PEAR_LOG_INFO);
		//echo "$curl_url";
		$curl_connection = curl_init($curl_url);
		curl_setopt($curl_connection, CURLOPT_CONNECTTIMEOUT, 30);
		curl_setopt($curl_connection, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
		curl_setopt($curl_connection, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl_connection, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($curl_connection, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($curl_connection, CURLOPT_UNRESTRICTED_AUTH, true);

		$post_data['nfirst'] = $firstName;
		$post_data['nmiddle'] = $middleInitial;
		$post_data['nlast'] = $lastName;
		$post_data['stre_aaddress'] = $address1;
		$post_data['city_aaddress'] = $address2;
		$post_data['stre_haddress2'] = $address3;
		$post_data['city_haddress2'] = $address4;
		$post_data['zemailaddr'] = $email;
		$post_data['F045pcode2'] = $gender;
		$post_data['F051birthdate'] = $birthDate;
		$post_data['tphone1'] = $phone;
		foreach ($post_data as $key => $value) {
			$post_items[] = $key . '=' . urlencode($value);
		}
		$post_string = implode ('&', $post_items);
		curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $post_string);
		$sresult = curl_exec($curl_connection);

		curl_close($curl_connection);

		//Parse the library card number from the response
		if (preg_match('/Your temporary library card number is :.*?(\\d+)<\/(b|strong|span)>/si', $sresult, $matches)) {
			$barcode = $matches[1];
			return array('success' => true, 'barcode' => $barcode);
		} else {
			global $logger;
			$logger->log("$sresult", PEAR_LOG_DEBUG);
			return array('success' => false, 'barcode' => null);
		}

	}
	/**
	 * 	Renamed this function from getMyFines to _getMyFines so the mobile catalog can work
	 * 	True fine integration wasn't finished.
	 *  Rename this when that work is ready to begin
	 *  also remember to check the mobile site andmake sure it works
	 */
	function _getMyFines(){
		global $user;
		
		$r = $this->iiiWebServiceRequest("searchPatrons", "b".$user->cat_username);	
		return $r->patronFines;
	}
	private function iiiWebServiceRequest($method, $patron){	
		$username = 'milwsp'; //no idea why
		$password = 'milwsp';
		$client = new SoapClient($this->getWSDL()); //switch to user dir one
		try{
			return $client->__soapCall($method, array($username, $password, $patron));
		}catch(exception $e){
			echo $e->getMessage();
			return null;
		}
	}
	function getWishLists(){
		global $user;
		global $configArray;
		//global $timer;
		if (substr($configArray['Catalog']['url'], -1) == '/') {
			$host = substr($configArray['Catalog']['url'], 0, -1);
		} else {
			$host = $configArray['Catalog']['url'];
		}
		$req =  $host . "/patroninfo~S{$this->getMillenniumScope()}/" . $user->username . "/mylists";
		$cookieJar = tempnam ("/tmp", "CURLCOOKIE");
		$success = false;
		
		$barcode = $this->_getBarcode();
		$patronDump = $this->_getPatronDump($barcode);
		
		//Login to the site
		$curl_url = $req;//$configArray['Catalog']['url'] . "/patroninfo";
		
		$curl_connection = curl_init($curl_url);
		$header=array();
		$header[0] = "Accept: text/xml,application/xml,application/xhtml+xml,";
		$header[0] .= "text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5";
		$header[] = "Cache-Control: max-age=0";
		$header[] = "Connection: keep-alive";
		$header[] = "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7";
		$header[] = "Accept-Language: en-us,en;q=0.5";
		curl_setopt($curl_connection, CURLOPT_CONNECTTIMEOUT, 30);
		curl_setopt($curl_connection, CURLOPT_HTTPHEADER, $header);
		curl_setopt($curl_connection, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
		curl_setopt($curl_connection, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl_connection, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($curl_connection, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($curl_connection, CURLOPT_UNRESTRICTED_AUTH, true);
		curl_setopt($curl_connection, CURLOPT_COOKIEJAR, $cookieJar );
		curl_setopt($curl_connection, CURLOPT_COOKIESESSION, false);
		curl_setopt($curl_connection, CURLOPT_POST, true);
		$post_data = $this->_getLoginFormValues($patronDump);
		foreach ($post_data as $key => $value) {
			$post_items[] = $key . '=' . urlencode($value);
		}
		$post_string = implode ('&', $post_items);
		curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $post_string);
		$sresult = curl_exec($curl_connection);
		$doc = new DOMDocument();
		@$doc->loadHTML($sresult);
		$finder = new DomXPath($doc);
		$classname="patFuncEntry";
		$items = $finder->query("//tr[contains(@class, '$classname')]");
		
		$return = array();
		foreach ($items as $node){
			$return[] = $this->tdrows($node->childNodes);
		}
		return $return;
	}
	private function tdrows($elements){
		$str = array();
		foreach ($elements as $element){
			if($element->hasChildNodes()){
				$r = $element->getElementsByTagName('a')->item(0);
				if(is_object($r)){
					$str['href'] = $r->getAttribute('href');
					$str['title'] = $r->nodeValue;
				}else{
					$str[] = $element->nodeValue;
				}
			}
		}
		return $str;
	}
	private function getWSDL(){
		global $servername;
		$filename = "wsdl.xml";
		if (file_exists("../../sites/$servername/conf/$filename")){
			return "../../sites/$servername/conf/$filename";
		}elseif (file_exists("../../sites/default/conf/$filename")){
			return "../../sites/default/conf/$filename";
		} else{
			return '../../sites/' . $filename;
		}	
	}
	public function getImportList($id){
		global $user;
		global $configArray;
		//global $timer;
		if (substr($configArray['Catalog']['url'], -1) == '/') {
			$host = substr($configArray['Catalog']['url'], 0, -1);
		} else {
			$host = $configArray['Catalog']['url'];
		}
		$req =  $host . "/patroninfo~S{$this->getMillenniumScope()}/" . $user->username . "/mylists?listNum=".$id;
		$cookieJar = tempnam ("/tmp", "CURLCOOKIE");
		$success = false;
		
		$barcode = $this->_getBarcode();
		$patronDump = $this->_getPatronDump($barcode);
		
		//Login to the site
		$curl_url = $req;//$configArray['Catalog']['url'] . "/patroninfo";
		
		$curl_connection = curl_init($curl_url);
		$header=array();
		$header[0] = "Accept: text/xml,application/xml,application/xhtml+xml,";
		$header[0] .= "text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5";
		$header[] = "Cache-Control: max-age=0";
		$header[] = "Connection: keep-alive";
		$header[] = "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7";
		$header[] = "Accept-Language: en-us,en;q=0.5";
		curl_setopt($curl_connection, CURLOPT_CONNECTTIMEOUT, 30);
		curl_setopt($curl_connection, CURLOPT_HTTPHEADER, $header);
		curl_setopt($curl_connection, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
		curl_setopt($curl_connection, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($curl_connection, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($curl_connection, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($curl_connection, CURLOPT_UNRESTRICTED_AUTH, true);
		curl_setopt($curl_connection, CURLOPT_COOKIEJAR, $cookieJar );
		curl_setopt($curl_connection, CURLOPT_COOKIESESSION, false);
		curl_setopt($curl_connection, CURLOPT_POST, true);
		$post_data = $this->_getLoginFormValues($patronDump);
		foreach ($post_data as $key => $value) {
			$post_items[] = $key . '=' . urlencode($value);
		}
		$post_string = implode ('&', $post_items);
		curl_setopt($curl_connection, CURLOPT_POSTFIELDS, $post_string);
		$sresult = curl_exec($curl_connection);
		$doc = new DOMDocument();
		@$doc->loadHTML($sresult);
		$finder = new DomXPath($doc);
		$classname="patFuncTitle";
		$items = $finder->query("//td[contains(@class, '$classname')]");
		
		$return = array();
		foreach ($items as $node){
			$return[] = $this->hrefRows($node->childNodes);
		}
		return $return;
	}

	private function hrefRows($elements){
		$str = array();
		foreach ($elements as $element){
			if($element->hasChildNodes()){
				$str[] = $element->getAttribute('href');
			}
		}
		return $str;
	}

	public function getMyMillItems($barcode, $forceReload = false){

		global $configArray;
		global $memcache;

		$mymill_items = $memcache->get("mymill_items_$barcode");

		if (!$mymill_items || $forceReload){

			require_once 'sys/MyMillenniumConnect.php';
			
			// Location of WSDL file
			$wsdl_url = $configArray['Site']['mymillennium'] . "/patroninfo.wsdl";

			// Instantiate new SoapClient object in WSDL mode
			$mymilconnect = new MyMillenniumConnect($wsdl_url);

			$patronInfoRequest = array("request" =>
				array(
					"index" => 'barcode',
					"query" => $barcode,
					"username" => $configArray['Site']['mymillennium_user'],
					"password" => $configArray['Site']['mymillennium_user']
				)
			);

			try {
				// Make SOAP request
				$patronInfoResponse = $mymilconnect->patronInfo($patronInfoRequest);
			} catch(SoapFault $exception) {
				// Catch any problems and display the error code
				$errorMessage = $exception->getMessage();
			}

			$mymill_items = $patronInfoResponse;

			$memcache->set("mymill_items_$barcode", $mymill_items, 0, $configArray['Caching']['mymill_items']);
		
		}

		return $mymill_items;

	}

	public function objectToArray($object){
	    if(!is_object($object) && !is_array($object)){
	        return $object;
	    }
	    return array_map(array($this, 'objectToArray'), (array) $object);
	}

	public function getCheckedOutItems($patron, $page = 1, $recordsPerPage = -1, $sortOption = 'dueDate', $expand_physical_items){

		global $memcache, $configArray;

		$mymill_items = $this->getMyMillItems($patron['cat_username']);

		$scount = 0;
		$numTransactions = 0;
		$update_cache = 0;

		$curTitle = array();
		$checkedOutTitles = array();

		if (isset($mymill_items->response->checkedOutItems)){

			require_once 'services/MyResearch/lib/Resource.php';

			// The MyMillennium API does not return an array of objects when there is only one checked out item. The following code, mimics an array of object
			// so upstream it doesnt break anything. This doest not effect patrons with zero checked out items.
			if (!is_array($mymill_items->response->checkedOutItems)){
				$mymill_items->response->checkedOutItems = $this->objectToArray($mymill_items->response->checkedOutItems);
				
				$checked_out_item = new stdClass();

				foreach ($mymill_items->response->checkedOutItems as $key => $value){
					$checked_out_item->$key = $value;
				}

				unset($mymill_items->response->checkedOutItems);

				$mymill_items->response->checkedOutItems[0] = $checked_out_item;
			}

			foreach($mymill_items->response->checkedOutItems as $key => $value){

				$now = time();
				$duedate = strtotime($value->dueDate);

				if ($duedate != ''){
					$daysUntilDue = ceil(($duedate - time()) / (24 * 60 * 60));
					$overdue = $daysUntilDue < 0;
					$curTitle['duedate'] = $duedate;
					$curTitle['overdue'] = $overdue;
					$curTitle['daysUntilDue'] = $daysUntilDue;
				}
				$curTitle['title'] = $value->titleProper;
				$curTitle['renewCount'] = $value->renewals;
				if ($daysUntilDue < 0){
					$curTitle['overdue'] = 1;
				} else {
					$curTitle['overdue'] = 0;
				}

				$item_id = $value->itemRecordNum; //TODO. NOT GETTING THE CHECK DIGIT FROM MYMILLAPI. WE WILL REMOVE THAT DURING REINDEX.

				$bibRecordNum = isset($value->bibRecordNum) ? $value->bibRecordNum : null;

				if (!isset($bibRecordNum)){
					//$bibRecordNum = $this->sierra_api_request($this->sierra_api_connect(), $item_id);
					$bibRecordNum = substr($this->get_bib_id($item_id),1,-1);
					$mymill_items->response->checkedOutItems[$scount]->bibRecordNum = $bibRecordNum;
					$update_cache = 1;
				}
				// change this from isseet to handle ILL items as checked out items
				if (!empty($bibRecordNum)){
					
					$curTitle['shortId'] = $bibRecordNum;
					$resource = new Resource();
					$resource->shortId = $curTitle['shortId'];
					$resource->find();
					if ($resource->N > 0){
						$resource->fetch();
						$curTitle['isbn'] = $resource->isbn;
						$curTitle['id'] = $resource->record_id;
						$curTitle['author'] = $resource->author;
						$curTitle['format'] = $resource->format;
					}				
                                // for ILL items not in index
				} else {
					$curTitle['shortId'] = null;
					$curTitle['title'] = $curTitle['title'].' '.$mymill_items->response->checkedOutItems[$scount]->callNumber;
					$curTitle['isbn'] = null;
					$curTitle['id'] = null;
					$curTitle['author'] = null;
					$curTitle['format'] = null;
				}
				

				$curTitle['itemid'] = $value->itemRecordNum;
				$curTitle['renewIndicator'] = $value->itemRecordNum . "|" . ($scount + 1);
				$curTitle['renewCount'] = $value->renewals;

				if ($sortOption == 'title'){
					$sort_title = $this->get_title_sort($curTitle['itemid']);
					$sort_title = isset($sort_title) ? $sort_title : strtolower($curTitle['title']);
					$sortKey =  $sort_title . '-' . $scount;
				} elseif ($sortOption == 'author'){
					$sortKey = $curTitle['author'] . '-' . $scount;
				} elseif ($sortOption == 'format'){
					$sortKey = $curTitle['format'] . '-' . $scount;
				} else {
					$sortKey = $duedate . '-' . $scount;
				}

				$checkedOutTitles[$sortKey]['duedate'] = $curTitle['duedate'];
				$checkedOutTitles[$sortKey]['overdue'] = $curTitle['overdue'];
				$checkedOutTitles[$sortKey]['daysUntilDue'] = $curTitle['daysUntilDue'];
				$checkedOutTitles[$sortKey]['title'] = $curTitle['title'];
				$checkedOutTitles[$sortKey]['renewCount'] = $curTitle['renewCount'];
				$checkedOutTitles[$sortKey]['overdue'] = $curTitle['overdue'];
				$checkedOutTitles[$sortKey]['shortId'] = isset($curTitle['shortId']) ? $curTitle['shortId'] : null;
				$checkedOutTitles[$sortKey]['isbn'] = isset($curTitle['isbn']) ? $curTitle['isbn'] : null;
				$checkedOutTitles[$sortKey]['id'] = isset($curTitle['id']) ? $curTitle['id'] : null;
				$checkedOutTitles[$sortKey]['author'] = isset($curTitle['author']) ? $curTitle['author'] : null;
				$checkedOutTitles[$sortKey]['format'] = isset($curTitle['format']) ? $curTitle['format'] : null;
				$checkedOutTitles[$sortKey]['itemid'] = $curTitle['itemid'];
				$checkedOutTitles[$sortKey]['renewIndicator'] = $curTitle['renewIndicator'];
				
				$scount++;

			}

			if ($update_cache){
				$barcode = $patron['cat_username'];
				$memcache->set("mymill_items_$barcode", $mymill_items, 0, $configArray['Caching']['mymill_items']);
			}

			ksort($checkedOutTitles); //TODO Bug with sort

			$numTransactions = count($checkedOutTitles);
			//Process pagination
			if ($recordsPerPage != -1){
				$startRecord = ($page - 1) * $recordsPerPage;
				if ($startRecord > $numTransactions){
					$page = 0;
					$startRecord = 0;
				}
				$checkedOutTitles = array_slice($checkedOutTitles, $startRecord, $recordsPerPage);
			}
		}
		
		//echo "<pre> Checked Out Titles";
		//print_r($checkedOutTitles);
		//echo "</pre>";		

		return array(
			'transactions' => $checkedOutTitles,
			'numTransactions' => $numTransactions
		);

	}

	private function sierra_api_connect($forceReload = true){

		global $configArray;
		global $memcache;

		$sierra_api_connect = $memcache->get("sierra_api_connect");

		if (!$sierra_api_connect || $forceReload){

			$ch = curl_init("https://iiisy1.einetwork.net/iii/sierra-api/v1/token");
			curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 15);
			curl_setopt($ch, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
			curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/x-www-form-urlencoded;charset=UTF-8'));
			curl_setopt($ch, CURLOPT_USERPWD, "J18khCmzE4cRf3tlGH+pDh5RfI+w:Qu3hepru");
			curl_setopt($ch, CURLOPT_TIMEOUT, 30);
			curl_setopt($ch, CURLOPT_POST, 1);
			curl_setopt($ch, CURLOPT_POSTFIELDS, "grant_type=client_credentials");
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
			$response = json_decode(curl_exec($ch));

			$sierra_api_connect['access_token'] = $response->access_token;
			$sierra_api_connect['token_type'] = $response->token_type;
			$sierra_api_connect['expires_in'] = $response->expires_in;

			$memcache->set("sierra_api_connect", $sierra_api_connect, 0, $sierra_api_connect['expires_in']);

		}

		return $sierra_api_connect;

	}

	private function sierra_api_request($sierra_api_connect, $item_id){

		$header = array();
		$header[] = 'Content-length: 0';
		$header[] = 'Content-type: application/json';
		$header[] = 'Accept: application/marc-in-json';
		$header[] = "Authorization: " . $sierra_api_connect['token_type'] . " " . $sierra_api_connect['access_token'];

		$ch = curl_init("https://iiisy1.einetwork.net/iii/sierra-api/v1/items?id=" . $item_id);
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 15);
		curl_setopt($ch, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($ch, CURLOPT_TIMEOUT, 30);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);

		$response = json_decode(curl_exec($ch));

		return $response->entries[0]->bibIds[0];

		// $ch = curl_init("https://iiisy1.einetwork.net/iii/sierra-api/v1/bibs?id=" . $bib_id);
		// curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 15);
		// curl_setopt($ch, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
		// curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
		// curl_setopt($ch, CURLOPT_TIMEOUT, 30);
		// curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
		// curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);

		// $response = json_decode(curl_exec($ch));

		// echo "<pre>";
		// print_r($response);
		// echo "</pre>";

	}

	function get_bib_id($item_id){

		$header = array();
		$header[] = 'Content-length: 0';
		$header[] = 'Content-type: application/json';
		$header[] = 'Accept: application/json';

		$ch = curl_init("http://localhost:8080/solr/biblio/select/?q=items:" . $item_id . "&fl=id,title_sort&wt=json");
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 15);
		curl_setopt($ch, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($ch, CURLOPT_TIMEOUT, 30);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);

		$response = json_decode(curl_exec($ch));

		if (isset($response->response->docs[0])){
			return $response->response->docs[0]->id;
		}

	}

	function get_title_sort($item_id){

		$header = array();
		$header[] = 'Content-length: 0';
		$header[] = 'Content-type: application/json';
		$header[] = 'Accept: application/json';

		$ch = curl_init("http://vufindplus.einetwork.net:8080/solr/biblio/select/?q=items:" . $item_id . "&fl=title_sort&wt=json");
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 15);
		curl_setopt($ch, CURLOPT_USERAGENT,"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
		curl_setopt($ch, CURLOPT_TIMEOUT, 30);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);

		$response = json_decode(curl_exec($ch));

		if (isset($response->response->docs[0])){
			return $response->response->docs[0]->title_sort;
		}

	}

}

?>
