/*
 * Puropse: Populate externalData table
 * notes: externalData contains product records from externalSource (currently OverDrive, OneClick will be added )
 * externalData are populate from externalSource table, OverDrive metaData api, and OverDrive availability api
 * Currently Overdrive does not provide entire id query, so the extracting has to be done in batch of 300 (max allowed).
 * the batch processing does not guaranty all overdrive ids, so the loop (max 5) to get all Overdrive IDs
 * the overdrive IDs are used to metadata, availability and foregin keys from externalSource table
 */
 package org.extract;
 

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map.Entry;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.Logger;
import org.extract.dbInfo.ExternalDataInfo;
import org.extract.dbtools.DatabaseQueries;
import org.ini4j.Ini;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONFormatter;
import org.json.JSONObject;
/**
 * This class is responsible for extracting overdrive metadata and availability data, 
 * In order for this to run smoothly, it needs externalSource table set for externalSource Id
 * 
 * @version 2014-11-19
 * @author Devesh - EI Network
 */
public class ExtractOverDriveInfo {
	private static Logger logger = Logger.getLogger(ExtractOverDriveInfo.class);
	private Connection mySqlconn;
	private DatabaseQueries databaseQuery ; 
	private OverDriveExtractLogEntry logEntry;
	
	//Overdrive API information
	private String clientSecret;
	private String clientKey;
	private String accountId;
	private String overDriveAPIToken;
	private String overDriveAPITokenType;
	private long overDriveAPIExpiration;
	private String overDriveProductsKey;
	private String extractType;
	
	private HashSet<Object> updatedIds = new HashSet<Object>();
	private HashSet<JSONObject> jsonHS = new HashSet<JSONObject>();
	private HashSet<String> tempColumnSet = new HashSet<String>();
	private HashMap<String, Object> tempContentMap = new HashMap<String, Object>();
	private HashMap<String, Object> tempConditionMap = new HashMap<String, Object>();
	private HashSet<String> overDriveIdSet = new HashSet<String>();
	private HashMap<String, Long> advantageCollectionToLibMap = new HashMap<String, Long>();
	private HashMap<String, ExternalDataInfo> externalDataMap = new HashMap<String, ExternalDataInfo>();
	private HashMap<String, String> externalIdandPrefixMap = new HashMap<String, String>();
	
	/**
	 * Set up OverDrvie Client info from configuration file for OverDrive API authentication
	 * @param configIni
	 * 			Ini - containing configurations
	 * @param mySqlconn
	 * 			Connection - database connection
	 * @return boolean
	 * 			true if client detail is found 
	 */
	private boolean OverdriveClientInfo(Ini configIni, Connection mySqlconn){
		this.mySqlconn = mySqlconn;
		databaseQuery = new DatabaseQueries(this.mySqlconn);
		
		//getting client info from configuration file
		clientSecret = configIni.get("OverDrive", "clientSecret");
		clientKey = configIni.get("OverDrive", "clientKey");
		accountId = configIni.get("OverDrive", "accountId");
		overDriveProductsKey = configIni.get("OverDrive", "productsKey");
		
		if (overDriveProductsKey == null){
			logger.warn("Warning no products key provided for OverDrive");
		}
		//String forceMetaDataUpdateStr = configIni.get("OverDrive", "forceMetaDataUpdate");
		//forceMetaDataUpdateStr != null && Boolean.parseBoolean(forceMetaDataUpdateStr);
		
		if (clientSecret == null || clientKey == null || accountId == null || clientSecret.length() == 0 || clientKey.length() == 0 || accountId.length() == 0){
			logger.error("Did not find correct configuration in config.ini, not loading overdrive titles");
			logEntry.incRecordsErrors();
			return false;
		}else{
			return true;
		}
	}
	
	/**
	 * function to initiate overdrive extract
	 * @param configIni
	 * 			Ini
	 * @param mySqlconn
	 * 			Connection
	 * @param logEntry
	 * 			OverDriveExtractLogEntry - to keep track of OverDrive process
	 */
	public HashSet<Object> extractOverDriveInfo(Ini configIni, Connection mySqlconn, OverDriveExtractLogEntry logEntry, String extractType) {
		this.logEntry = logEntry;
		this.logEntry.setStartTime(new Date().getTime());
		this.logEntry.setProcessName("Over Drive API");
		this.extractType = extractType;		
		if(OverdriveClientInfo(configIni, mySqlconn) ){
			//Load products from API
			if (!loadProductsFromAPI()){
				return null;
			}
			//remove records which are not provided by source (overdrive api)
			cleanupExternalData();
		}
		return updatedIds;
	}

	/**
	 * insert records into externalData table, get contents of externalDataInfoObj and 
	 * call preparedStatement Generator by to insert or update externalData table
	 * populate udpateIds set
	 * 
	 */
	private void updateExternalData() {
		
		String jsonString;
		
		tempContentMap.clear();
		//populating tableContents HashMap, with data from overdrive data stored in ExternalDataInfo object
		Iterator<Entry<String, ExternalDataInfo>> iter = externalDataMap.entrySet().iterator();
	    while (iter.hasNext()) {
	        Entry<String, ExternalDataInfo> pairs = iter.next();
	        //tableContents.put("id",  pairs.getValue().getId());
	        ExternalDataInfo externalDataInfoObj = pairs.getValue();
	        tempContentMap.put("sourceId", externalDataInfoObj.getSourceId());
	        //tableContents.put("resourceId ", externalDataInfo.getResourceId());
	        tempContentMap.put("record_Id", externalDataInfoObj.getRecord_Id());
	        tempContentMap.put("sourcePrefix", externalDataInfoObj.getSourcePrefix() );
	        tempContentMap.put("externalId", externalDataInfoObj.getExternalId());	
	        
	        jsonString = ( externalDataInfoObj.getSourceMetaData() ).toString();
	        jsonString = jsonString.replace("\"\"", "\"");
	        jsonString = jsonString.replace("\"", "\\\"");		// to avoid issues with " in mysql prepared Statement
	        jsonString = jsonString.replace("\\\\\"", "\\\\\\\"");  // replace \\" with \\\" to avoid issues with " in mysql prepared Statement
	        tempContentMap.put("sourceMetaData", jsonString );	  
	       
	        tempContentMap.put("indexedMetaData", externalDataInfoObj.getIndexedMetaData());
	        tempContentMap.put("limitedCopies", externalDataInfoObj.getLimitedCopies());
	        tempContentMap.put("totalCopies", externalDataInfoObj.getTotalCopies());
	        tempContentMap.put("availableCopies", externalDataInfoObj.getAvailableCopies());
	        tempContentMap.put("numberOfHolds", externalDataInfoObj.getNumberOfHolds());
	        tempContentMap.put("lastMetaDataCheck", externalDataInfoObj.getLastMetaDataCheck());
	        tempContentMap.put("lastMetaDataChange", externalDataInfoObj.getLastMetaDataChange());
	        tempContentMap.put("lastAvailabilityCheck", externalDataInfoObj.getLastAvailabilityCheck());
	        tempContentMap.put("lastAvailabilityChange", externalDataInfoObj.getLastAvailabilityChange());
	        iter.remove(); // avoids a ConcurrentModificationException  
	        
	        //condition to check if the record aready exists in overdrive;
	        tempConditionMap.clear();
	        tempConditionMap.put("externalId", externalDataInfoObj.getExternalId() );
	        tempConditionMap.put("sourcePrefix", externalDataInfoObj.getSourcePrefix() );
	       
    		
    		
	        boolean existingRecord = false;
	        //if exists update else insert
	        if(externalIdandPrefixMap.containsKey(pairs.getKey())){
	        	//check for existing id before checking prefix and avoid null pointer error
	        	if( (externalIdandPrefixMap.get(pairs.getKey())).contentEquals(externalDataInfoObj.getSourcePrefix()  )){
	        		logger.debug("Existing record.. Updating.. " + pairs.getKey() );
	        		
	        		databaseQuery.updateTable("externalData", tempContentMap, tempConditionMap, "=");

	        		//add id to updatedId set
	        		
	        		HashSet<String> columns = new HashSet<String>();
	        		columns.add("id");
	        		HashMap<String, Object> condition = new HashMap<String, Object>();
	        		condition.put("externalId", externalDataInfoObj.getExternalId() );
	    	        condition.put("sourcePrefix", externalDataInfoObj.getSourcePrefix() );
	        		ResultSet rs = databaseQuery.select("externalData", columns, condition, "=");
	        		try {
						rs.first();
						updatedIds.add(rs.getInt("id"));
					} catch (SQLException e) {
						logger.error(e);
					}
					
	        		
	        		existingRecord = true;
	        	}else{
	        		logger.debug("Contains key " + pairs.getKey());
	        	}
	        }if(!existingRecord){
	        	tempContentMap.put( "dateAdded", new Date().getTime() );
	        	logger.debug("Inserting data into externalData Table for " + pairs.getKey() + " - " + externalDataInfoObj.getExternalId());
	        	ResultSet rs = databaseQuery.insertIntoTable("externalData", tempContentMap);
	    
				if(rs != null ){
					logEntry.incRecordsAdded();
				}else{
					logEntry.incRecordsErrors();
				}
				
				//add id to updatedId set
				HashSet<String> columns = new HashSet<String>();
	        	columns.add("id");
	        	HashMap<String, Object> condition = new HashMap<String, Object>();
	        	condition.put("externalId", externalDataInfoObj.getExternalId() );
	    	    condition.put("sourcePrefix", externalDataInfoObj.getSourcePrefix() );
				rs = databaseQuery.select("externalData", columns, condition, "=");
        		try {
					rs.first();
					updatedIds.add(rs.getInt("id"));
				} catch (SQLException e) {
					logger.error(e);
				}
	        	
	        }
	        logEntry.incRecordsProcessed();
	        //databaseQuery.insertIntoTableIfNotExist("externalData", tempContentMap, tempConditionMap, "=");
	        externalDataInfoObj =  null;
	    }
	    
	    tempContentMap.clear();
	    tempConditionMap.clear();
	}
	/**
	 * Get externalId and sourcePrefix from externalData and store it in HashMap
	 * this HashMap can be use to check the existing record in the database, instead of running select query every time.
	 * 
	 */
	private void setExternalIDandPrefixMap(){
		
		logger.debug("Setting ID and prefix hashMap" );
		tempConditionMap.clear();
        tempConditionMap.put("id","0");
        
        tempColumnSet.clear();
        tempColumnSet.add("externalId");
        tempColumnSet.add(" sourcePrefix");
        ResultSet rs = databaseQuery.select("externalData", tempColumnSet, tempConditionMap, ">");
        tempColumnSet.clear();
        tempConditionMap.clear();
        
        externalIdandPrefixMap.clear();
        
        try {
			while(rs.next()){
				externalIdandPrefixMap.put(rs.getString("externalId"), rs.getString("sourcePrefix"));
			}
		} catch (SQLException e) {
			logger.error("Result Set error : " + e);
		}
        
	}

	/**
	 * Delete externalData records which are no longer provided by OverDrive
	 * 
	 */
	public void cleanupExternalData(){
		/*
		if(!OverdriveClientInfo(configIni, mySqlconn) ){

			return;
		}
		*/
		logger.debug("Starting Cleanup Process " );
		
		//if other other parts of code has not called Overdrive for IDs, get overdrive IDs
		if(overDriveIdSet.isEmpty()){
			
			logger.debug("get ids of overdrive products");
			JSONObject libraryInfo = callOverDriveURL("http://api.overdrive.com/v1/libraries/" + accountId);

			try {
				String libraryName = libraryInfo.getString("name");
				String mainProductUrl = libraryInfo.getJSONObject("links").getJSONObject("products").getString("href");
			
				getOverdriveIDs(libraryName, mainProductUrl);
			} catch (Exception e) {
				logger.error("Error loading overdrive titles", e);
			}
		}
			
		//get overdrive prefix from externalSource table
		//HashSet<String> col = new HashSet<String>();
		tempColumnSet.clear();
		tempColumnSet.add("externalIdPrefix");

		tempConditionMap.clear();
		tempConditionMap.put("source", "OverDrive");
		ResultSet rs = databaseQuery.select("externalSource", tempColumnSet, tempConditionMap, "=");
		tempColumnSet.clear();
		tempConditionMap.clear();
			
		String prefix = null;
		try {
			rs.next();
			prefix = rs.getString("externalIdPrefix");
		} catch (SQLException e) {
			logger.error( e );
		}
			
		//get externalId for all overdrive records
		tempColumnSet.clear();
		tempColumnSet.add("externalId");
		tempConditionMap.put("sourcePrefix", prefix);
		ResultSet resultSet = databaseQuery.select("externalData", tempColumnSet , tempConditionMap, "=");
		tempConditionMap.clear();
		tempColumnSet.clear();
		logger.debug("prcesssing table " + overDriveIdSet.size() );	
		try {
			while(resultSet.next()){
				//check if the record in table is still available in overdrive api
				if(! (overDriveIdSet.contains( resultSet.getString("externalId") ) ) ){
					tempConditionMap.clear();
					tempConditionMap.put("externalId", resultSet.getString("externalId") );
					//delete record if not available in overdrive api
					databaseQuery.deleteRow("externalData", tempConditionMap, "=");
					logger.debug("Deleting invalid record " + resultSet.getString("externalId") );
					tempConditionMap.clear();
					logEntry.inctRecordsDeleted();
					logEntry.updateLog();
				}
				else{
					logger.debug("valid overdrive record " + resultSet.getString("externalId"));
				}
			}
		} catch (SQLException e) {
			logger.error( e );
		}
		
	}
	
	/**
	 * get all OverDrive ID, runs in batch of 300 (max allowed by Overdrive API at this time)
	 * the id extraction might run up to 5 times until all the id are collected, 
	 * usually should collect all by first iteration.
	 * @param libraryName
	 * 		String	library name collected from OverDrive  
	 * @param mainProductUrl
	 * 		String  main OverDrive Url
	 */
	private void getOverdriveIDs(String libraryName, String mainProductUrl)  {
		
		JSONObject productInfo = callOverDriveURL(mainProductUrl);
		if (productInfo == null){
			return;
		}
		long numProducts = 0;
		try {
			numProducts = productInfo.getLong("totalItems");
		} catch (JSONException e) {
			logger.error( e );
		}
		Long libraryId = getLibraryIdForOverDriveAccount(libraryName);
		
		
		logger.info(libraryName + " collection has " + numProducts + " products in it.  The libraryId for the collection is " + libraryId);
	
		long batchSize = 300;
		
		jsonHS.clear();
		jsonHS = new HashSet<JSONObject>();
		
		int loopCount = 1;
		//loop to get a entire unique id from overdrive
		do{
			logger.debug("Starting batch processing to get all product IDs only, attempt no : " + loopCount );
			//get product id only from Overdrive Search API
			for (int i = 0; i < numProducts; i += batchSize){
				logger.debug("Processing " + libraryName + " batch from " + i + " to " + (i + batchSize));
				String batchUrl = mainProductUrl;
				if (mainProductUrl.contains("?")){
					batchUrl += "&";
				} else{
					batchUrl += "?";
				}
				//minimum=true gets only ID from Overdrive Search API
				//sort=deteadded:asc increases the efficiency of the API call
				batchUrl += "offset=" + i + "&limit=" + batchSize + "&minimum=true&sort=dateadded:asc";
				
				//returns JSONObject with ID in batch (300)
				JSONObject productBatchInfo = callOverDriveURL(batchUrl);
				jsonHS.add(productBatchInfo);
				//logger.debug("product Batch " + productBatchInfo);	
			}
			logger.debug("End of batch processing");
			
			//converting ID batch into individual ID
			Iterator<JSONObject> iter = jsonHS.iterator();
			while(iter.hasNext()){
				JSONObject productIDs = (JSONObject) iter.next();
				//logger.debug("JSON obj : " + productIDs);
		
				if (productIDs != null && productIDs.has("products")){
					JSONArray products;
					try {
						products = productIDs.getJSONArray("products");
						for(int j = 0; j < products.length(); j++){
							JSONObject productID = products.getJSONObject(j);
							String id = productID.getString("id");
							//adding id to Hashset
							overDriveIdSet.add(id);
							
						}
					} catch (JSONException e) {
						logger.error( e );
					}
				}
			}
			logger.debug("Number of unique ID received : " + overDriveIdSet.size() + ", num of overdrive product : " + numProducts);
		}while( numProducts != overDriveIdSet.size() && loopCount++ < 5);   //loopCount is for prevent infinite loops
		
		jsonHS.clear();
	}

	/**
	 * get OverDrive IDs that has been updated or new
	 * At present Overdrive does not provide updated id list, but if they do so
	 * the updated id list can be populated to overDriveIdSet through this function.
	 * @param libraryName
	 * @param mainProductUrl
	 */
	private void getUpdatedOverdriveIDs(String libraryName, String mainProductUrl){
		//populate overDriveIdSet with update overdrive Ids
		//overDriveIdSet.add(" " );
		
		//replace this call, the code should add updated overdrive ids to overDriveIdSet
		getOverdriveIDs(libraryName, mainProductUrl);
	}
	/**
	 * get library name and  main OverDrive Url for the library
	 * @return
	 * 		true if successful extraction
	 */
	private boolean loadProductsFromAPI() {
		JSONObject libraryInfo = callOverDriveURL("http://api.overdrive.com/v1/libraries/" + accountId);
		
		try {
			String libraryName = libraryInfo.getString("name");
			String mainProductUrl = libraryInfo.getJSONObject("links").getJSONObject("products").getString("href");
			
			loadProductsFromUrl(libraryName, mainProductUrl);

			return true;
		} catch (Exception e) {
			logger.error("Error loading overdrive titles", e);
			return false;
		}
	}

	
	private Long getLibraryIdForOverDriveAccount(String libraryName) {
		if (advantageCollectionToLibMap.containsKey(libraryName)){
			return advantageCollectionToLibMap.get(libraryName);
		}
		return -1L;
	}

	/**
	 * get all overdriveID from Search API 
	 * get metadata using overdrive ID
	 * @param libraryName
	 * @param mainProductUrl
	 */
	private void loadProductsFromUrl(String libraryName, String mainProductUrl){
		logger.debug("getting overdrive IDs");	
		if(extractType.contains("update"))
		{
			getUpdatedOverdriveIDs(libraryName, mainProductUrl);
		}
		else{
			getOverdriveIDs(libraryName, mainProductUrl);
		}
		
		//get ID and prefix from externalData table
		setExternalIDandPrefixMap();
		
		logger.debug("extracting data from api");
		
		setMetaDataFromOverdrive( mainProductUrl);
		setAvailabilityFromOverdrive(mainProductUrl);
		setExternalDataFromDB() ;
		
		updateExternalData();
		
		
		externalDataMap.clear();
		
		logger.debug("End of product Extraction from Overdrive");
		
	}
	/**
	 * set up external Data info - id, sourcePrefix, source from database
	 * and add to corresponding externalDataInfo item in hashmap
	 */
	private void setExternalDataFromDB() {
		
		ExternalDataInfo externalDataInfoObj;
		Iterator<String> idIterator = overDriveIdSet.iterator();
		while(idIterator.hasNext()){
			String overdriveId = idIterator.next();
			logger.debug("getting external Source info for : " + overdriveId);
			if(externalDataMap.containsKey(overdriveId)){
				externalDataInfoObj = externalDataMap.get(overdriveId);
			}else{
				externalDataInfoObj = new ExternalDataInfo();
			}
			
			tempColumnSet.clear();
			tempColumnSet.add("id"); //externalSource id
			tempColumnSet.add("externalIdPrefix");
			
			tempConditionMap.clear();
			tempConditionMap.put("source", "OverDrive");
			//getting exteranlSource info
			ResultSet rs = databaseQuery.select("externalSource", tempColumnSet, tempConditionMap,"=");
			tempColumnSet.clear();
			tempConditionMap.clear();
			
			try {
				rs.first();
				externalDataInfoObj.setSourceId( rs.getInt("id"));
				String sourcePrefix = rs.getString("externalIdPrefix");
				externalDataInfoObj.setRecord_Id(overdriveId + sourcePrefix);
				externalDataInfoObj.setSourcePrefix(sourcePrefix);
			} catch (SQLException e1) {
				logger.error("can not get overdrive info from table -- " + e1);
			}
			
			//externalDataObj.setResourceId( 1);   // need to work on resourceId cannot be determined during extraction from overdrive
			
			externalDataInfoObj.setExternalId(overdriveId);
			
			externalDataInfoObj.setLimitedCopies(1);
			
			Long date = new Date().getTime();
			externalDataInfoObj.setDateAdded(date);
			
			externalDataMap.put( overdriveId,  externalDataInfoObj);
		}
	}
	/**
	 * Extract metadata form overdrive api and add to corresponding externalDataInfo item in hashmap
	 * @param mainProductUrl
	 */
	private void setMetaDataFromOverdrive( String mainProductUrl) {
		int count = 0;
		ExternalDataInfo externalDataInfoObj;
		Iterator<String> idIterator = overDriveIdSet.iterator();
		while(idIterator.hasNext()){
			String overdriveId = idIterator.next();
			
			if(externalDataMap.containsKey(overdriveId)){
				externalDataInfoObj = externalDataMap.get(overdriveId);
			}
			else{
				externalDataInfoObj = new ExternalDataInfo();
			}
			
			logger.debug(count++ +" Extacting metadata for : " + overdriveId);
			String productMetaDataUrl = mainProductUrl + "/" + overdriveId + "/metadata";
			JSONObject productMetaDataInfo = callOverDriveURL(productMetaDataUrl);	
		
			externalDataInfoObj.setSourceMetaData(productMetaDataInfo);
			
			externalDataInfoObj.setIndexedMetaData(null);
			
			externalDataInfoObj.setExternalId(overdriveId);
			Long date = new Date().getTime();
			externalDataInfoObj.setLastMetaDataCheck( date);
			externalDataInfoObj.setLastMetaDataChange(date);
			
			externalDataMap.put( overdriveId,  externalDataInfoObj);

		}
	}
	/**
	 * extract availability form Overdrive and add to corresponding externalDataInfo item in hashmap
	 * @param mainProductUrl
	 */
	private void setAvailabilityFromOverdrive(String mainProductUrl) {
		int count = 0;
		ExternalDataInfo externalDataInfoObj;
		Iterator<String> idIterator = overDriveIdSet.iterator();
		while(idIterator.hasNext()){
			String overdriveId = idIterator.next();
			
			if(externalDataMap.containsKey(overdriveId)){
				externalDataInfoObj = externalDataMap.get(overdriveId);
			}
			else{
				externalDataInfoObj = new ExternalDataInfo();
			}
			logger.debug(count++ + " Extacting Availability for : " + overdriveId);
			String productAvailabilityUrl = mainProductUrl + "/" + overdriveId + "/availability";;

			JSONObject productAvailabilityInfo = callOverDriveURL(productAvailabilityUrl);	
			try {
				externalDataInfoObj.setTotalCopies(productAvailabilityInfo.getInt("copiesOwned"));
				externalDataInfoObj.setAvailableCopies(productAvailabilityInfo.getInt("copiesAvailable"));
				externalDataInfoObj.setNumberOfHolds(productAvailabilityInfo.getInt("numberOfHolds"));
			} catch (JSONException e) {
			
				logger.error("ERROR: setting External Data -- " + e );
			}
			
			Long date = new Date().getTime();
			externalDataInfoObj.setExternalId(overdriveId);
			externalDataInfoObj.setLastAvailabilityCheck(date);
			externalDataInfoObj.setLastAvailabilityChange(date);
			
			externalDataMap.put( overdriveId,  externalDataInfoObj);
		}
	}
	
	/**
	 * Call overdrive api to get library details, name and url
	 * @param overdriveUrl
	 * @return JSONObject
	 */
	private JSONObject callOverDriveURL(String overdriveUrl) {
		int maxConnectTries = 1; //OverDrive states that calling multiple times won't improve responses, but will take longer
		//logger.debug("Calling overdrive URL " + overdriveUrl);
		for (int connectTry = 0 ; connectTry < maxConnectTries; connectTry++){
			if (connectToOverDriveAPI(connectTry != 0)){
				if (connectTry != 0){
					logger.debug("Connecting to " + overdriveUrl + " try " + (connectTry + 1));
				}
				//Connect to the API to get our token
				HttpURLConnection conn;
				try {
					URL emptyIndexURL = new URL(overdriveUrl);
					conn = (HttpURLConnection) emptyIndexURL.openConnection();
					if (conn instanceof HttpsURLConnection){
						HttpsURLConnection sslConn = (HttpsURLConnection)conn;
						sslConn.setHostnameVerifier(new HostnameVerifier() {
							
							@Override
							public boolean verify(String hostname, SSLSession session) {
								//Do not verify host names
								return true;
							}
						});
					}
					conn.setRequestMethod("GET");
					conn.setRequestProperty("Authorization", overDriveAPITokenType + " " + overDriveAPIToken);
					
					StringBuilder response = new StringBuilder();
					if (conn.getResponseCode() == 200) {
						// Get the response
						BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
						String line;
						while ((line = rd.readLine()) != null) {
							response.append(line);
						}
						//logger.debug("  Finished reading response");
						rd.close();
						return new JSONObject(response.toString());
					} else {
						logger.error("Received error " + conn.getResponseCode() + " connecting to overdrive API try " + connectTry );
						// Get any errors
						BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
						String line;
						while ((line = rd.readLine()) != null) {
							response.append(line);
						}
						logger.debug("  Finished reading response");
						logger.debug(response.toString());
	
						rd.close();
					}
	
				} catch (Exception e) {
					logger.debug("Error loading data from overdrive API try " + connectTry, e );
				}
			}
			//Something went wrong, try to wait a second to see if the OverDrive API will catch up.
			/*try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				logger.debug("Could not pause between tries " + connectTry);
			}*/
		}
		logger.error("Failed to call overdrive url " +overdriveUrl + " in " + maxConnectTries + " calls");
		
		return null;
	}
	/**
	 * Authenticate overdrive call
	 * @param getNewToken
	 * @return
	 */
	private boolean connectToOverDriveAPI(boolean getNewToken){
		//Check to see if we already have a valid token
		if (overDriveAPIToken != null && !getNewToken){
			if (overDriveAPIExpiration - new Date().getTime() > 0){
				//logger.debug("token is still valid");
				return true;
			}else{
				logger.debug("Token has exipred");
			}
		}
		//Connect to the API to get our token
		HttpURLConnection conn;
		try {
			URL emptyIndexURL = new URL("https://oauth.overdrive.com/token");
			conn = (HttpURLConnection) emptyIndexURL.openConnection();
			if (conn instanceof HttpsURLConnection){
				HttpsURLConnection sslConn = (HttpsURLConnection)conn;
				sslConn.setHostnameVerifier(new HostnameVerifier() {
					
					@Override
					public boolean verify(String hostname, SSLSession session) {
						//Do not verify host names
						return true;
					}
				});
			}
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
			//logger.debug("Client Key is " + clientSecret);
			String encoded = Base64.encodeBase64String((clientKey + ":" + clientSecret).getBytes());
			conn.setRequestProperty("Authorization", "Basic "+encoded);
			conn.setDoOutput(true);
			OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream(), "UTF8");
			wr.write("grant_type=client_credentials");
			wr.flush();
			wr.close();
			
			StringBuilder response = new StringBuilder();
			if (conn.getResponseCode() == 200) {
				// Get the response { access_token, token_type, expires_in, scope }
				BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String line;
				while ((line = rd.readLine()) != null) {
					response.append(line);
				}
				rd.close();
				JSONObject parser = new JSONObject(response.toString());
				overDriveAPIToken = parser.getString("access_token");
				overDriveAPITokenType = parser.getString("token_type");
				//logger.debug("Token expires in " + parser.getLong("expires_in") + " seconds");
				overDriveAPIExpiration = new Date().getTime() + (parser.getLong("expires_in") * 1000) - 10000;
				//logger.debug("OverDrive token is " + overDriveAPIToken);
			} else {
				logger.error("Received error " + conn.getResponseCode() + " connecting to overdrive authentication service" );
				// Get any errors
				BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
				String line;
				while ((line = rd.readLine()) != null) {
					response.append(line);
				}
				logger.debug("  Finished reading response\r\n" + response);

				rd.close();
				return false;
			}

		} catch (Exception e) {
			logger.error("Error connecting to overdrive API", e );
			return false;
		}
		return true;
	}

}
