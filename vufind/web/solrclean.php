<?php

function get_duplicates(){


    echo "Searching for Duplicates\n\n";

    $link = mysql_connect('localhost', 'vufind', 'vufind');
    if (!$link) {
        die('Could not connect: ' . mysql_error());
    }

    mysql_select_db('econtent', $link) or die('Could not select database.');

    $query = "SELECT 
            ec.id, 
            ec.ilsid, 
            FROM_UNIXTIME(date_added) as DateAdded, 
            dup.LastAddDate
        FROM econtent_record ec
        JOIN duplicateilsid dup on dup.ilsid = ec.ilsid
        WHERE FROM_UNIXTIME(ec.date_added) <> dup.LastAddDate";

    $result = mysql_query($query);

    while ($row = mysql_fetch_assoc($result)) {
        $db_records[] = $row;
    }

    if (count($db_records) > 1){
        echo "Found " . count($db_records) . " Duplicates\n\n";
    } else {
        echo "Found 0 Duplicates\n\n";
        die();
    }

    mysql_close($link);

    return $db_records;

}

function solr_clean($db_records){

    $delete_core_1_count = 0;
    $delete_core_2_count = 0;

    echo "Removing Records from SOLR cores\n\n";

    foreach($db_records as $key => $value){

        $id = $value['id'];

        $cmd = "curl -H 'Content-Type: text/xml' http://localhost:8080/solr/econtent/update?commit=true --data-binary '<delete><id>econtentRecord" . $id . "</id></delete>'";
        exec($cmd);
        $delete_core_1_count++;

        echo "\n\nDeleted econtentRecord" . $id . " from core 1\n\n";

        $cmd = "curl -H 'Content-Type: text/xml' http://localhost:8080/solr/econtent2/update?commit=true --data-binary '<delete><id>econtentRecord" . $id . "</id></delete>'";
        exec($cmd);
        $delete_core_2_count++;

        echo "\n\nDeleted econtentRecord" . $id . " from core 2\n\n";

    }

    echo "Deleted " . $delete_core_1_count . " records from Solr Core 1\n";
    echo "Deleted " . $delete_core_2_count . " records from Solr Core 2\n";

}

function remove_records($db_records){

    echo "Removing Records from econtent database\n\n";

    $link = mysql_connect('localhost', 'vufind', 'vufind');

    mysql_select_db('econtent', $link) or die('Could not select database.');

    $deleted_econtent_records = 0;
    $deleted_econtent_items = 0;

    foreach($db_records as $key => $value){

        $id = $value['id'];

        $query = "DELETE FROM econtent_record WHERE id = " . $id;
        mysql_query($query) or die(mysql_error());

        $deleted_econtent_records++;

        $query = "DELETE FROM econtent_item WHERE recordId = " . $id;
        mysql_query($query) or die(mysql_error());

        $deleted_econtent_items++;

    }

    echo "Deleted " . $deleted_econtent_records . " records from econtent_record\n\n";
    echo "Deleted " . $deleted_econtent_items . " records from econtent_item\n\n";

    mysql_close($link);

}

$db_records = get_duplicates();
solr_clean($db_records);
remove_records($db_records);

?>