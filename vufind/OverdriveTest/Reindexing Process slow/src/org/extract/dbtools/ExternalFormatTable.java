/*
 * 
 */
package org.extract.dbtools;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;

import org.apache.log4j.Logger;
import org.extract.dbInfo.ExternalFormatsInfo;
import org.json.JSONException;
import org.json.JSONObject;
/**
 * This sets up externalFormat table using externalData and format table, 
 * 
 * @version 2014-11-19
 * @author Devesh
 */
public class ExternalFormatTable {
	private Connection mySqlconn;
	private Logger logger = Logger.getLogger(ExternalFormatTable.class);
	
	ResultSet externalDataResultSet;
	HashMap<String, Object> formatMap = new HashMap<String, Object>();
	
	/**
	 * Extract metaData String from externalData table, extract formats from meta data, 
	 * get formatId from format table, 
	 * insert or update externalFormatTable
	 * @param mySqlconn
	 */
	public void setTable(Connection mySqlconn, HashSet<Object> updatedExternalDataIds){
		this.mySqlconn = mySqlconn;
		DatabaseQueries dbQueries = new DatabaseQueries(mySqlconn);
		
		//extract from externalData table and store in resultSet
		HashSet<String> columns = new HashSet<String>();
		columns.add("id");
		columns.add("externalId");
		columns.add("sourcePrefix");
		columns.add("sourceMetaData");
		logger.debug("extracting from externalData");
		externalDataResultSet = dbQueries.selectAllRows("externalData", columns);
		columns.clear();
		
		//extract from format table convert it to HashMap
		columns.add("id");
		columns.add("externalFormatId");
		logger.debug("extracting from format");
		ResultSet formatDataResultSet = dbQueries.selectAllRows("format", columns);
		try {
			while(formatDataResultSet.next()){
				formatMap.put(formatDataResultSet.getString("externalFormatId"), formatDataResultSet.getInt("id"));
			}
		} catch (SQLException e1) {
			logger.error(e1);
		}
				
		ExternalFormatsInfo externalFormats = new ExternalFormatsInfo();
		int count = 0; //just counting number for debug
		
		try {
			while(externalDataResultSet.next()){
				count++;
				
				//check if the record need to be updated
				while(! (updatedExternalDataIds.contains(externalDataResultSet.getInt("id"))) ){
					//return if resultSet is empty or at end
					if(!externalDataResultSet.next()){
						return;
					}
				}
				
				//convert to JSONObject
				JSONObject overDriveMetaDataJSON = stringToJSONObject(externalDataResultSet.getString("sourceMetaData"));
				
				if(overDriveMetaDataJSON != null){
						
					try {
						//index to traverse through formats array
						int index = 0;	
						//updating table according to format
						while(! (overDriveMetaDataJSON.getJSONArray("formats").isNull(index))){
							HashMap<String, Object> tableContents = new HashMap<String, Object>();
							try {
								tableContents.put("externalDataId",externalDataResultSet.getInt("id"));
							} catch (SQLException e) {
								logger.error(e);
							}
							String format = overDriveMetaDataJSON.getJSONArray("formats").getJSONObject(index++).getString("id");
							logger.debug((index -1) + " Format " + format);
							int formatId = (Integer) formatMap.get(format);
							tableContents.put("formatId",formatId);
							tableContents.put("formatLink","link");
							
							HashSet<String> column = new HashSet<String>();
							HashMap<String, Object> condition = new HashMap<String, Object>();

							column.add("id");
							condition.put("externalDataId", externalFormats.getExternalDataId());
							condition.put("formatId", externalFormats.getFormatId());
							ResultSet rs = dbQueries.select("externalFormats", column, condition, "=");
							condition.clear();
							
							//check for existing record by exteranlDataId and formatId. Get id if exist for update
							if(rs.first()){
								tableContents.put("dateUpdated",new Date().getTime());
								
								condition.put("id", rs.getInt("id"));
								
								dbQueries.updateTable("externalFormats", tableContents, condition, "=");
								logger.debug(count + " updated into externalformats");
							}else{	
								tableContents.put("dateAdded",  new Date().getTime() );
								tableContents.put("dateUpdated", 0);
								dbQueries.insertIntoTable("externalFormats", tableContents);
								logger.debug(count + " inserted into externalformats");
							}
							tableContents.clear();	
						}
							
					} catch (JSONException e) {
							//logger.debug(overDriveMetaDataJSON);
							logger.error("JSON error " + e);
							
					}
				}
			}
		} catch (SQLException e) {
			logger.error(e);
		}
		
	}
	/**
	 * Convert JSONString to JSONObject, handle some of the string object not handled by JSONObject. 
	 * This currently uses modified JSONObject class which ignore escape characters, so if the JSONObject
	 * class is changed the escape sequence has to be uncommented
	 * @param metaData
	 * @return
	 */
	private JSONObject stringToJSONObject( String metaData){
		
		JSONObject metaDataJSON = null;
		
		
		metaData = metaData.replace("\"", "\"");		// don't know why it does not work with out this
			
		//metaData = metaData.replace("\t", "\\t"); 
		//metaData = metaData.replace("\n", "\\n"); 
		
		metaData = metaData.replace(":,", ":null,");	
		metaData = metaData.replace(":}", ":null}");
		
		try {
			metaDataJSON = new JSONObject(metaData);
		} catch (JSONException e) {
			logger.debug("metaData : " + metaData);
			logger.error("Cound not convert string to JSON " +  e );
		}

		

		return metaDataJSON;
	}

}
