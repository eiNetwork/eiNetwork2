<?php
/**
 *
 * Written by Mark Duffy and June Rayner based on specific requirements for eiNetwork.
 *
 * @author Mark Duffy <markaduffy@gmail.com>
 */

require_once 'sys/postgresConnection.php';
require_once 'CatalogConnection.php';

class SierraDriver extends Action
{

	function getCheckedOutItems($patron_id){

		$cn = new postgresConnection();
		$sierra_db = $cn->dbConnect();

		$sql = "SELECT c.id, b.record_type_code || b.record_num as shortid, b.title, c.item_record_id, c.due_gmt, c.checkout_gmt, c.renewal_count, c.overdue_count
					from sierra_view.patron_view as p
					join sierra_view.checkout c on c.patron_record_id = p.id
					join sierra_view.bib_record_item_record_link l on l.item_record_id = c.item_record_id
					join sierra_view.bib_view b on b.id = l.bib_record_id
					where p.record_num = $patron_id and p.record_type_code = 'p';
					";
		
		$rs = $this->pgquery($sql, $sierra_db);

		pg_close($sierra_db);

		return array("results" => pg_fetch_all($rs[0]), "stats" => $rs[1]);

	}

	function getHoldItems($patron_id){

		$cn = new postgresConnection();
		$sierra_db = $cn->dbConnect();

		$sql = "SELECT h.id, h.record_id, m.record_type_code, m.record_num, coalesce(l.bib_record_id, h.record_id) as bibId, b.record_type_code || b.record_num as shortId, b.title,
					h.is_frozen, h.delay_days, h.location_code, h.expires_gmt, h.status, h.pickup_location_code, h.note, h.patron_records_display_order, h.records_display_order
					from sierra_view.record_metadata as p join sierra_view.hold h on p.id = h.patron_record_id
					join sierra_view.record_metadata m on m.id = h.record_id
					left outer join sierra_view.bib_record_item_record_link l on l.item_record_id = h.record_id
					join sierra_view.bib_view b on b.id = coalesce(l.bib_record_id, h.record_id)
					where p.record_num = $patron_id and p.record_type_code = 'p';
					";

		$rs = $this->pgquery($sql, $sierra_db);

		pg_close($sierra_db);

		return array("results" => pg_fetch_all($rs[0]), "stats" => $rs[1]);

	}

	function pgquery($sql, $conn){
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