<?php

error_reporting(E_ALL);
ini_set("display_errors", 1);

require_once 'Drivers/Sierra.php';
require_once 'sys/ConfigArray.php';
$configArray = readConfig();

echo "Prototype Sierra Driver<br /><br />";

$sierra = new SierraDriver();

$sierra->getCheckedOutItems();

?>