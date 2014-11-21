package org.extract.dbtools;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;

import org.apache.log4j.Logger;
import org.extract.ReindexingMain;
import org.json.JSONException;
import org.json.JSONObject;
/**
 * 
 * convert json string to json object if the string has escape squence of null value
 */

public class JSONObjectFromExternalData {
	
	private static Logger logger = Logger.getLogger(ReindexingMain.class);
	/**
	 * convert to json object
	 * @param mySqlconn
	 * @param externalId
	 * @param sourcePrefix
	 * @return JSONObject
	 */
	public JSONObject getMetaDataFromDB(Connection mySqlconn, String externalId, String sourcePrefix){
		
		
		JSONObject metaDataJSON = null;
		String metaData = null;
		HashSet<String> columns = new HashSet<String>();
		columns.add("sourceMetaData");
		HashMap<String,Object> condition = new HashMap<String, Object>();
		condition.put("externalId",  externalId);
		condition.put("sourcePrefix", sourcePrefix);
		DatabaseQueries dbQueries = new DatabaseQueries(mySqlconn);
		ResultSet resultSet = dbQueries.select("externalData", columns, condition, "=");
		
		try {
			resultSet.first();
			metaData = resultSet.getString("sourceMetaData");
			
			metaData = metaData.replace("\"", "\"");		// don't know why it does not work with out this
			metaData = metaData.replace("\t", "\\t"); 
			metaData = metaData.replace("\n", "\\n"); 
			
			metaData = metaData.replace(":,", ":null,");	
			metaData = metaData.replace(":}", ":null}");
		
			
		} catch (SQLException e) {
			logger.error( e );
		}
		try {
			metaDataJSON = new JSONObject(metaData);
		} catch (JSONException e) {
			logger.debug("metaData : " + metaData);
			logger.error("Cound not convert string to JSON " +  e );
		}

		return metaDataJSON;
	}

}
