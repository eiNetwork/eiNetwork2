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

	}

	public function dbConnect(){

		$sierra_db = pg_connect("
			host=$this->db_host 
			port=$this->db_port 
			dbname=$this->db_database 
			user=$this->db_username 
			password=$this->db_password
		") or die ("Could not connect to server\n");

		return $sierra_db;

	}

}