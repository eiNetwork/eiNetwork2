/*
 * Purpose:Populate mySql tables with external Data form OverDrive API
 * table populated: externalData, externalSource, format, marcMap, externalFormats, and reindexLog
 * externalSource, format, marcMap: contains are provide in excel file, and the contents are not suppose to change often.
 * the excel files (.xls format) can be read and its contents can be inserted into table using TablesFormExcel class.
 */
package org.extract;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Date;
import java.util.HashSet;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.extract.dbtools.ExternalFormatTable;
import org.extract.dbtools.IndexedMetaDataTable;
import org.extract.dbtools.TablesFromExcel;
import org.ini4j.Ini;
import org.ini4j.InvalidFileFormatException;
import org.ini4j.Profile.Section;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Initiate external Source data extraction for reindexing process. This reindexing process runs
 * independent of the reindexer. The main purpose of this process is to extract data form source
 * like Overdrive API and OneClick API. However this version only extracts data from Overdive API.
 * Along with Overdrive metadata and availability API extraction this also reads from spreadsheet
 * files, for this version it only reads .xls files. It would be upgarded to .xls files by upgrading
 * apache poi jar file. 
 * In order to run this code, it requires site name, which is could also be replaced with normal 
 * folder name. this site name or folder name is should contain config.ini file and log config file.
 * 
 * eg:java -jar reindexingProcess.jar vufindplusdev.einetwork.net
 * 
 * eg:java -jar reindexingProcess.jar vufindplusdev.einetwork.net update
 * if you add update to as second parameter it will update changed records or new records
 * but for this version it update option does not matter because the update function is
 * just a dummy function to be filled up when Overdrive provides list or update items. But 
 * for now its would be faster to update each record with out checking if the metadata has changed.
 * 
 * eg:java -jar reindexingProcess.jar vufindplusdev.einetwork.net non
 * to only extract excel data.
 * 
 * config files will be in site/vufindplusdev.einetwork.net/conf/config.ini , 
 * site/vufindplusdev.einetwork.net/conf/log4j.overdrive_extract.properties
 * 
 * @version 2014-11-19
 * @author Devesh - EI Network 
 */
public class ReindexingMain {
	private static Logger logger;
	private static String serverName;
	private static Connection mySqlconn;
	private static OverDriveExtractLogEntry logEntry;
	/**
	 * main function to start the reindexing process, it sets triggers ini configuration, excel file
	 * data extraction, overdrive extraction. 
	 * 
	 * @param args
	 * 		args[0] must contain site name
	 * @exception SQLException
	 * 				if could not connect / disconnect to database
	 */
	public static void main(String[] args){
		if (args.length == 0){
			System.out.println("The name of the server to extract OverDrive data for must be provided as the first parameter.");
			System.exit(1);
		}else{
			serverName = args[0];
		}
		
		Date currentTime = new Date();
		
		//logger setup
		File log4jFile = new File("sites/" + serverName + "/conf/log4j.overdrive_extract.properties");
		if (log4jFile.exists()){
			PropertyConfigurator.configure(log4jFile.getAbsolutePath());
		}else{
			System.out.println("Could not find log4j configuration " + log4jFile.toString());
		}
		logger = Logger.getLogger(ReindexingMain.class);
		logger.info(currentTime.toString() + ": Starting OverDrive Extract");
		
		// Read the base INI file to get information about the server 
		Ini configIni = loadConfigFile("config.ini");
		
		
		// Setup the MySQL driver
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			logger.debug("Loaded driver for MySQL");
		} catch (Exception ex) {
			logger.info("Could not load driver for MySQL, exiting.", ex);
			return;
		}
		
		String databaseConnectionInfo = Util.cleanIniValue(configIni.get("Database", "database_vufind_jdbc"));
		if (databaseConnectionInfo == null || databaseConnectionInfo.length() == 0) {
			logger.error("Database connection information not found in Database Section.  Please specify connection information in database_vufind_jdbc.");
			System.exit(1);
		}
		try {	
			mySqlconn = DriverManager.getConnection(databaseConnectionInfo);
		} catch (SQLException e) {
			logger.error("Could not connect to database", e);
			System.exit(1);
		}
		
		
		//Extracting tables from excel file for static data
		logger.debug("Calling Excel extract");
		TablesFromExcel excelTables = new TablesFromExcel();
		excelTables.extactFromSpreadSheet(configIni, mySqlconn);
		
		String extractType;
		if(args.length > 1){
			extractType = args[1];
		}
		else{
			extractType = "full";
		}
		
		if(!extractType.contains("non")){
		
			HashSet<Object> updatedExternalDataIds = new HashSet<Object>();
			//extracting from overdrive
			logger.debug("Calling Overdrive Extract");
			ExtractOverDriveInfo extractor = new ExtractOverDriveInfo();
			//object for log table
			logEntry = new OverDriveExtractLogEntry(mySqlconn, logger);
			logger.debug("Starting " + extractType + " extract from overdrive ");
			updatedExternalDataIds = extractor.extractOverDriveInfo(configIni, mySqlconn, logEntry, extractType);
		
			//populate externalFormats table
			logger.debug("Starting externalFormat update");
			new ExternalFormatTable().setTable(mySqlconn, updatedExternalDataIds);
		
			//populateExternalFormatsTable
			logger.debug("Starting indexedMetaData update");
			new IndexedMetaDataTable(mySqlconn).setIndexMetaDataTable();
		
			currentTime = new Date();
			logEntry.setEndTime(currentTime.getTime());
			logEntry.updateLog();
			logger.info("OverDrive Extraction and database updata DONE....");
		}
		try {
			mySqlconn.close();
		} catch (SQLException e) {
			logger.error("Cannot close connection " + e);
		}
	}
	/**
	 * load configurations for config.ini files, first it load from default location, 
	 * then load from site specific location.
	 * @param filename
	 * 			configuration file
	 * @return Ini
	 * @exception InvalidFileFormatException
	 * 				if the configuration file is not valid
	 * @exception FileNotFoundException
	 * 				if file path is invalid
	 * @exception IOException
	 * 				if can not read from file
	 */
	private static Ini loadConfigFile(String filename){
		//First load the default config file 
		String configName = "sites/default/conf/" + filename;
		logger.debug("Loading configuration from " + configName);
		File configFile = new File(configName);
		if (!configFile.exists()) {
			logger.error("Could not find configuration file " + configName);
			System.exit(1);
		}
		
		// Parse the configuration file
		Ini ini = new Ini();
		try {
			ini.load(new FileReader(configFile));
		} catch (InvalidFileFormatException e) {
			logger.error("Configuration file is not valid.  Please check the syntax of the file.", e);
		} catch (FileNotFoundException e) {
			logger.error("Configuration file could not be found.  You must supply a configuration file in conf called config.ini.", e);
		} catch (IOException e) {
			logger.error("Configuration file could not be read.", e);
		}
		
		//Now override with the site specific configuration
		String siteSpecificFilename = "sites/" + serverName + "/conf/" + filename;
		logger.debug("Loading site specific config from " + siteSpecificFilename);
		File siteSpecificFile = new File(siteSpecificFilename);
		if (!siteSpecificFile.exists()) {
			logger.error("Could not find server specific config file");
			System.exit(1);
		}
		try {
			Ini siteSpecificIni = new Ini();
			siteSpecificIni.load(new FileReader(siteSpecificFile));
			for (Section curSection : siteSpecificIni.values()){
				for (String curKey : curSection.keySet()){
					//logger.debug("Overriding " + curSection.getName() + " " + curKey + " " + curSection.get(curKey));
					ini.put(curSection.getName(), curKey, curSection.get(curKey));
				}
			}
		} catch (InvalidFileFormatException e) {
			logger.error("Site Specific config file is not valid.  Please check the syntax of the file.", e);
		} catch (IOException e) {
			logger.error("Site Specific config file could not be read.", e);
		}
		//Also load password files if they exist
		String siteSpecificPassword = "sites/" + serverName + "/conf/config.pwd.ini";
		logger.debug("Loading password config from " + siteSpecificPassword);
		File siteSpecificPasswordFile = new File(siteSpecificPassword);
		if (siteSpecificPasswordFile.exists()) {
			try {
				Ini siteSpecificPwdIni = new Ini();
				siteSpecificPwdIni.load(new FileReader(siteSpecificPasswordFile));
				for (Section curSection : siteSpecificPwdIni.values()){
					for (String curKey : curSection.keySet()){
						ini.put(curSection.getName(), curKey, curSection.get(curKey));
					}
				}
			} catch (InvalidFileFormatException e) {
				logger.error("Site Specific password config file is not valid.  Please check the syntax of the file.", e);
			} catch (IOException e) {
				logger.error("Site Specific password config file could not be read.", e);
			}
		}
		return ini;
	}
}
