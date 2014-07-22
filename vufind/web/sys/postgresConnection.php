<?php
/**
 *
 * Written by Mark Duffy and June Rayner based on specific requirements for eiNetwork.
 *
 * @author Mark Duffy <markaduffy@gmail.com>
 */

class postgresConnection
{

	function __construct(){

		global $configArray;

		$this->db_host 		= $configArray['SierraPostgres']['db_host'];
		$this->db_port		= $configArray['SierraPostgres']['db_port'];
		$this->db_username 	= $configArray['SierraPostgres']['db_username'];
		$this->db_password 	= $configArray['SierraPostgres']['db_password'];
		$this->db_database 	= $configArray['SierraPostgres']['db_database'];

		$GLOBALS['sierra_db'] = $this->dbConnect();

	}

	private function dbConnect(){

		if (!isset($GLOBALS['sierra_db'])){
			$sierra_db = pg_connect("
				host=$this->db_host 
				port=$this->db_port 
				dbname=$this->db_database 
				user=$this->db_username 
				password=$this->db_password
			") or die ("Could not connect to server\n");

			return $sierra_db;
		} else {
			return $GLOBALS['sierra_db'];
		}

		

	}

	public function pgquery($sql, $conn){
	    // Prepend and append benchmarking queries
	    $bm = "SELECT extract(epoch FROM clock_timestamp())";
	    $query = "{$bm}; {$sql}; {$bm};";

	    // Execute the query, and time it (data transport included)
	    $ini = microtime(true);

	    pg_send_query($conn, $query);

	    while ($resource = pg_get_result($conn))
	    {
	        $resources[] = $resource;
	    }

	    $end = microtime(true);

	    // "Extract" the benchmarking results
	    $q_ini = pg_fetch_row(array_shift($resources));
	    $q_end = pg_fetch_row(array_pop($resources));

	    // Compute times
	    $time = round($end - $ini, 4);             # Total time (inc. transport)
	    $q_time = round($q_end[0] - $q_ini[0], 4); # Query time (Pg server only)

	    $resources[1]['total_time'] = $time;
	    $resources[1]['query_time'] = $q_time;

	    return $resources;
	}

}