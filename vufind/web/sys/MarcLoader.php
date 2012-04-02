<?php
require_once ('File/MARC.php');
class MarcLoader{
	public static function loadMarcRecordFromRecord($record){
		global $memcache;
		global $configArray;
		$marcRecord = $memcache->get('marc_record_' . $record['id']);
		if ($marcRecord == false){
			if (isset($record['fullrecord'])){
				$marc = trim($record['fullrecord']);
				$marc = preg_replace('/#31;/', "\x1F", $marc);
				$marc = preg_replace('/#30;/', "\x1E", $marc);
				$marc = new File_MARC($marc, File_MARC::SOURCE_STRING);
				if (!($marcRecord = $marc->next())) {
					PEAR::raiseError(new PEAR_Error('Could not load marc record for record ' . $record['id']));
				}else{
					$memcache->set('marc_record_' . $record['id'], $marcRecord, 0, $configArray['Caching']['marc_record']);
				}
			}else{
				return null;
			}
		}
		return $marcRecord;
	} 
} 
?>