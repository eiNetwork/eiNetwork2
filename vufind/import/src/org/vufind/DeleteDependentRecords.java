package org.vufind;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.IOException;
import java.sql.Connection;
import org.apache.log4j.Logger;

public class DeleteDependentRecords {
	
	PreparedStatement deleteEContentItemRecords; 
	PreparedStatement deleteEContentAvailabilityRecords; 
	
	PreparedStatement deleteResourceRecords;
	PreparedStatement deleteMarcImportRecords;
	PreparedStatement deleteUserResourceRecords; 
	
	Logger logger;
	Connection econtentConn;
	Connection vufindConn;
	
	public DeleteDependentRecords(Logger logger, Connection econtentConn, Connection vufindConn) {
		try {
			this.logger = logger;
			this.econtentConn = econtentConn;
			this.vufindConn = vufindConn;
			
			deleteEContentItemRecords = econtentConn.prepareStatement("delete from econtent_item where recordid not in (select id from econtent_record)");
			deleteEContentAvailabilityRecords = econtentConn.prepareStatement("delete from econtent_availability where recordid not in (select id from econtent_record)");
			
			deleteResourceRecords = vufindConn.prepareStatement("delete from resource where shortid is null and record_id not in (select id from econtent.econtent_record)");
			deleteMarcImportRecords = vufindConn.prepareStatement("delete from marc_import where id not in (select record_id from resource)");
			deleteUserResourceRecords = vufindConn.prepareStatement("delete from user_resource where resource_id not in (select id from resource)");
			
			
		} catch (Exception e) {
			logger.error("Error processing delete econtent record " , e);
			
		}
	}
	
	public void ExecuteDeletes() {
		int eContentItemRecordsDeleted = 0;
		int eContentAvailabilityRecordsDeleted = 0;
		int resourceRecordsDeleted = 0;
		int marcImportRecordsDeleted = 0;
		int userResourceRecordsDeleted = 0;
		
		try {
		
			eContentItemRecordsDeleted = deleteEContentItemRecords.executeUpdate();
			logger.info("Delete dependent econtent records " + eContentItemRecordsDeleted);
			eContentAvailabilityRecordsDeleted = deleteEContentAvailabilityRecords.executeUpdate();
			logger.info("Delete dependent econtent availability records " + eContentAvailabilityRecordsDeleted);
			
			resourceRecordsDeleted = deleteResourceRecords.executeUpdate();
			logger.info("Delete dependent  resource records " + resourceRecordsDeleted);
			marcImportRecordsDeleted = deleteMarcImportRecords.executeUpdate();
			logger.info("Delete dependent marc import records " + marcImportRecordsDeleted);
			userResourceRecordsDeleted = deleteUserResourceRecords.executeUpdate();
			logger.info("Delete dependent  user resource records " + userResourceRecordsDeleted);
			
		} catch (Exception e) {
			logger.error("Error processing delete dependent econtent records " , e);			
		}
		
		
	}
	
	
	};
	