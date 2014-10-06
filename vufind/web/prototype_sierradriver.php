<?php

define ('ROOT_DIR', __DIR__);

require_once 'sys/Logger.php';
require_once 'PEAR.php';
require_once 'Action.php';
require_once 'Drivers/Sierra.php';
require_once 'sys/ConfigArray.php';
$configArray = readConfig();
require_once 'sys/Timer.php';
global $timer;
$timer = new Timer($startTime);
$timer->logTime("Read Config");

if ($configArray['System']['debug']) {
	ini_set('display_errors', true);
	error_reporting(E_ALL & ~E_DEPRECATED);
}

// Setup Local Database Connection
define('DB_DATAOBJECT_NO_OVERLOAD', 0);
$options =& PEAR::getStaticProperty('DB_DataObject', 'options');
$options = $configArray['Database'];
$timer->logTime('Setup database connection');

function vufind_autoloader($class) {
	if (file_exists('sys/' . $class . '.php')){
		require_once 'sys/' . $class . '.php';
	}elseif (file_exists('services/MyResearch/lib/' . $class . '.php')){
		require_once 'services/MyResearch/lib/' . $class . '.php';
	}else{
		require_once str_replace('_', '/', $class) . '.php';
	}
}
spl_autoload_register('vufind_autoloader');

// Sets global error handler for PEAR errors
//PEAR::setErrorHandling(PEAR_ERROR_CALLBACK, 'handlePEARError');

// Require System Libraries
require_once 'sys/Interface.php';
require_once 'sys/User.php';
require_once 'sys/Translator.php';
require_once 'sys/SearchObject/Factory.php';
require_once 'sys/ConnectionManager.php';
require_once 'Drivers/marmot_inc/Library.php';
require_once 'Drivers/marmot_inc/Location.php';
require_once 'sys/UsageTracking.php';
require_once('Drivers/marmot_inc/SearchSources.php');

// Initiate Session State
$session_type = $configArray['Session']['type'];
$session_lifetime = $configArray['Session']['lifetime'];
$session_rememberMeLifetime = $configArray['Session']['rememberMeLifetime'];
register_shutdown_function('session_write_close');
if (isset($configArray['Site']['cookie_domain'])){
	session_set_cookie_params(0, '/', $configArray['Site']['cookie_domain']);
}
require_once 'sys/' . $session_type . '.php';
if (class_exists($session_type)) {
	$session = new $session_type();
	$session->init($session_lifetime, $session_rememberMeLifetime);
}

global $memcache;
// Set defaults if nothing set in config file.
$host = isset($configArray['Caching']['memcache_host']) ? $configArray['Caching']['memcache_host'] : 'localhost';
$port = isset($configArray['Caching']['memcache_port']) ? $configArray['Caching']['memcache_port'] : 11211;
$timeout = isset($configArray['Caching']['memcache_connection_timeout']) ? $configArray['Caching']['memcache_connection_timeout'] : 1;

// Connect to Memcache:
$memcache = new Memcache();
if (!$memcache->pconnect($host, $port, $timeout)) {
	PEAR::raiseError(new PEAR_Error("Could not connect to Memcache (host = {$host}, port = {$port})."));
}

$interface = new UInterface();

//Determine whether or not materials request functionality should be enabled
require_once 'sys/MaterialsRequest.php';
$interface->assign('enableMaterialsRequest', MaterialsRequest::enableMaterialsRequest());

global $user;

$user = UserAccount::isLoggedIn();
?>

<html>
<head>
	<title></title>

<style>

th {
	min-width:120px;
	padding:5px;
	background-color: #336699;
	color:#fff;
}

td {
	min-width:120px;
	padding:5px;
}

td.stats {
	background-color: #336699;
	color:#fff;
}

</style>

</head>
<body>

	<?php

echo "<h1>Prototype Sierra Driver</h1>";

// logged in. grab checkedout items
if ($user){

	$sierra = new SierraDriver();

	echo "<h2><b>Checked Out Items</b></h2>";

	$checkedout_items = $sierra->getCheckedOutItems($user->username);

	echo "<table><tr>";
	echo "<th>id</th>";
	echo "<th>shortid</th>";
	echo "<th>title</th>";
	echo "<th>item_record_id</th>";
	echo "<th>due_gmt</th>";
	echo "<th>checkout_gmt</th>";
	echo "<th>renewal_count</th>";
	echo "<th>overdue_count</th>";
	echo "</tr>";

	foreach($checkedout_items['results'] as $key => $value){

		echo "<tr>";
		echo "<td>" . $value['id'] . "</td>";
		echo "<td>" . $value['shortid'] . "</td>";
		echo "<td>" . $value['title'] . "</td>";
		echo "<td>" . $value['item_record_id'] . "</td>";
		echo "<td>" . $value['due_gmt'] . "</td>";
		echo "<td>" . $value['checkout_gmt'] . "</td>";
		echo "<td>" . $value['renewal_count'] . "</td>";
		echo "<td>" . $value['overdue_count'] . "</td>";
		echo "</tr>";

	}

	echo "<tr><td class='stats' colspan='8'>Total Time: " . $checkedout_items['stats']['total_time'] . " Query Time: " . $checkedout_items['stats']['query_time'] . "</td></tr></table>";

	echo "<h2><b>Holds</b></h2>";

	$hold_items = $sierra->getHoldItems($user->username);

	echo "<table><tr>";
	echo "<th>id</th>";
	echo "<th>record_id</th>";
	echo "<th>record_type_code</th>";
	echo "<th>record_num</th>";
	echo "<th>bibid</th>";
	echo "<th>shortid</th>";
	echo "<th>title</th>";
	echo "<th>is_frozen</th>";
	echo "<th>delay_days</th>";
	echo "<th>location_code</th>";
	echo "<th>expires_gmt</th>";
	echo "<th>status</th>";
	echo "<th>pickup_location_code</th>";
	echo "<th>note</th>";
	echo "<th>patron_records_display_order</th>";
	echo "<th>records_display_order</th>";
	echo "</tr>";

	foreach($hold_items['results'] as $key => $value){

		echo "<tr>";
		echo "<td>" . $value['id'] . "</td>";
		echo "<td>" . $value['record_id'] . "</td>";
		echo "<td>" . $value['record_type_code'] . "</td>";
		echo "<td>" . $value['record_num'] . "</td>";
		echo "<td>" . $value['bibid'] . "</td>";
		echo "<td>" . $value['shortid'] . "</td>";
		echo "<td>" . $value['title'] . "</td>";
		echo "<td>" . $value['is_frozen'] . "</td>";
		echo "<td>" . $value['delay_days'] . "</td>";
		echo "<td>" . $value['location_code'] . "</td>";
		echo "<td>" . $value['expires_gmt'] . "</td>";
		echo "<td>" . $value['status'] . "</td>";
		echo "<td>" . $value['pickup_location_code'] . "</td>";
		echo "<td>" . $value['note'] . "</td>";
		echo "<td>" . $value['patron_records_display_order'] . "</td>";
		echo "<td>" . $value['records_display_order'] . "</td>";
		echo "</tr>";

	}

	echo "<tr><td class='stats' colspan='16'>Total Time: " . $hold_items['stats']['total_time'] . " Query Time: " . $hold_items['stats']['query_time'] . "</td></tr></table>";

} else {

	echo "You must <a href='http://mark.vufindplus.einetwork.net/MyResearch/Home'>log in</a> to view your items. \n";

}
?>

</body>
</html>