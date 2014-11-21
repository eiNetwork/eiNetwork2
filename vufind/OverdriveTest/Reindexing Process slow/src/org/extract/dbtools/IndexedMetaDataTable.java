package org.extract.dbtools;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
/**
 * Populate indexedMetaDataTable, 
 * 
 *
 */

public class IndexedMetaDataTable {
	private static Logger logger = Logger.getLogger(IndexedMetaDataTable.class);
	private Connection conn;
	
	
	public IndexedMetaDataTable(Connection conn){
		this.conn = conn;
	}
	public void setConnection(Connection conn){
		this.conn = conn;
	}
	/**
	 * populate indexedMetaData table
	 */
	public void setIndexMetaDataTable(){
		DatabaseQueries dbQueries = new DatabaseQueries(conn);
		HashSet<String> columns = new HashSet<String>();
		columns.add("id");
		columns.add("sourceMetaData");
		//columns.add("totalCopies");
		//columns.add("availabeCopies");
		//columns.add("numberOfHolds");
		ResultSet resultSet = dbQueries.selectAllRows("externalData", columns);
		String jsonString;
		try {
			while(resultSet.next()){
				JSONObject metaDataJSON = stringToJSONObject(resultSet.getString("sourceMetaData"));
				if(metaDataJSON == null){
					logger.debug("Skipping an entry");
				}else{
					try {
						HashMap<String, Object> contentMap = new HashMap<String, Object>();
						jsonString = metaDataJSON.getString("title").replace("\"", "\\\"");
						contentMap.put("title", metaDataJSON.getString("title").replace("\"", "\\\"") );
						contentMap.put("title_sort",metaDataJSON.getString("sortTitle").replace("\"", "\\\"") );
						contentMap.put("title_sub", metaDataJSON.getString("title").replace("\"", "\\\""));
						contentMap.put("title_short", metaDataJSON.getString("title").replace("\"", "\\\""));
						contentMap.put("title_full", metaDataJSON.getString("title").replace("\"", "\\\""));
						contentMap.put("title_auth", metaDataJSON.getString("title").replace("\"", "\\\""));
						contentMap.put("author", metaDataJSON.getJSONArray("creators").getJSONObject(0).getString("fileAs").replace("\"", "\\\"") );
						contentMap.put("language", metaDataJSON.getJSONArray("languages").toString().replace("\"", "\\\""));
						contentMap.put("publisher", metaDataJSON.getString("publisher").replace("\"", "\\\""));
						
						contentMap.put("publishDate", metaDataJSON.getString("publishDateText").replace("\"", "\\\""));
						
						/*
						contentMap.put("author2", metaDataJSON.getJSONArray("creators").getJSONObject(1).getString("fileAs"));
						contentMap.put("author2_role", "");
						contentMap.put("author_additional", "");
						contentMap.put("collection", "");
						contentMap.put("institution", "");
						contentMap.put("available_at", "");
						contentMap.put("description", "");
						contentMap.put("contents", "");
						contentMap.put("subject", "");
						contentMap.put("edition", metaDataJSON.getString("edition").replace("\"", "\\\""));
						
						contentMap.put("isbn", "");
						contentMap.put("issn", "");
						contentMap.put("upc", "");
						contentMap.put("lccn", "");
						contentMap.put("ctrlnum", "");
						contentMap.put("series", "");
						contentMap.put("series2", "");
						contentMap.put("target_audience", "");
						contentMap.put("mpaa_rating", "");
						
						contentMap.put("publishLocation", "");
						contentMap.put("topic", "");
						contentMap.put("genre", "");
						contentMap.put("region", "");
						contentMap.put("region", "");
						contentMap.put("notes", "");
						contentMap.put("url", "");
						 */
					
						
						HashMap<String, Object> condition = new HashMap<String, Object>();
						condition.put("id", resultSet.getInt("id"));
						if( dbQueries.exists("indexedMetaData",condition, "=") )
						{
							logger.debug(resultSet.getInt("id") + " Updating indexedMetaData");
							condition.put("id", resultSet.getInt("id"));
							dbQueries.updateTable("indexedMetaData", contentMap, condition, "=");
						}
						else
						{
							contentMap.put("id", resultSet.getInt("id"));
							logger.debug(resultSet.getInt("id") + " Inserting into indexedMetaData table ");
							dbQueries.insertIntoTable("indexedMetaData", contentMap);
						}
					} catch (JSONException e) {
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
			return null;
		}
		return metaDataJSON;
	}

}
