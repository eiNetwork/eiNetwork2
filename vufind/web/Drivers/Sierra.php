<?php
/**
 *
 * Written by Mark Duffy and June Rayner based on specific requirements for eiNetwork.
 *
 * @author Mark Duffy <markaduffy@gmail.com>
 */

require_once 'sys/postgresConnection.php';
require_once 'Action.php';
require_once 'CatalogConnection.php';

class SierraDriver extends Action
{

	function getCheckedOutItems(){

		$cn = new postgresConnection();
		$sierra_db = $cn->dbConnect();

		$query = "SELECT VERSION()"; 
		$rs = pg_query($sierra_db, $query) or die("Cannot execute query: $query\n"); 
		$row = pg_fetch_row($rs);

		if (isset($row)) echo "Sierra Test Datase Connection Open";

		pg_close($sierra_db); 

	}

}