package org.extract.dbtools;

import java.sql.Connection;
import java.util.HashMap;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.log4j.Logger;
import org.extract.Util;
import org.ini4j.Ini;
/**
 * Extract excel spreadsheet data and insert it to the table.
 * This version supports .xls fromat only, .xlsx has to be converted to .xls.
 * It dependent on DatabaseQueries.java to insert and
 * dependent on apachi poi api for xls extraction.  poi-3.10.1-20140818.jar. 
 * 
 * <br/>configuration in config.ini:
 * Can be turned on off from config.ini, under SpreadSheetTables - 
 * updateFileName = true to turn on
 * xlsFileName = file name and path for xls file
 * scanSheetNamesForTables = true to scan for sheet names
 * table? = manually provide spreadsheet name
 * @version 2014-11-19
 * @author Devesh
 */
public class TablesFromExcel {
	
	private static Logger logger = Logger.getLogger(TablesFromExcel.class);
	private HashMap<String, Object> tableContents = new HashMap<String, Object>();
	private DatabaseQueries dbQueries;
	
	/**
	 * insert data into tables according to configuration file
	 * @param configIni
	 * @param mySqlconn
	 * @return
	 */
	public boolean extactFromSpreadSheet(Ini configIni, Connection mySqlconn){
		dbQueries = new DatabaseQueries(mySqlconn);
		//populate table from xls file
		String xlsFileName;
		String updateTables = Util.cleanIniValue(configIni.get("SpreadSheetTables", "updateTables"));
		if(updateTables.contentEquals("true")){
			xlsFileName = Util.cleanIniValue(configIni.get("SpreadSheetTables", "xlsFileName"));
		
			String scanNames = Util.cleanIniValue(configIni.get("SpreadSheetTables", "scanSheetNamesForTables"));
			
			//insert according to worksheet name in xls file, all worksheets will be evaluated for individual table	
			if(scanNames.contentEquals("true")){
				logger.debug("Populating tables from xls shreadsheets scanning sheet names" );
				insertTablesAsWorkSheets(xlsFileName);
			}
			else{
				//insert according to table names in configuration file
				logger.debug("Populating tables from xls shreadsheets by configured name " );
				int index = 0;
				String tableIndex = "table"+index;
				while(! ( Util.cleanIniValue(configIni.get("SpreadSheetTables", tableIndex)) == null) ){
				
					String tableName = Util.cleanIniValue(configIni.get("SpreadSheetTables", tableIndex));
					logger.debug("table name : " + tableName);
					insertIntoTable(xlsFileName, tableName);
					tableIndex = "table"+ (++index);
				}
			}
		}
				
		return true;
	}

	/**
	 * extract worksheet names and use it to insert to corresponding table
	 * @param xlsFileName
	 * @return
	 */
	private boolean insertTablesAsWorkSheets(String xlsFileName){
		
		File configFile = new File(xlsFileName);
		if (!configFile.exists()) {
			logger.error("Could data source file " + xlsFileName);
			return false;
		}
		
		FileInputStream fileInputStream;
		HSSFWorkbook workbook = null;
		try {
			fileInputStream = new FileInputStream(xlsFileName);
			workbook = new HSSFWorkbook(fileInputStream);
		} catch (FileNotFoundException e) {
			logger.error(e);
			return false;
		} catch (IOException e) {
			logger.error(e);
			return false;
		}
		 
		String sheetName;
		for(int sheetIndex = 0; sheetIndex < workbook.getNumberOfSheets(); sheetIndex++){
			sheetName = workbook.getSheetName(sheetIndex);
			addRecords(workbook, sheetName);
			
		}
		return true;
	}
	
	/**
	 * extract from worksheet "tableName" and insert the content to "tableName" table
	 * @param xlsFileName
	 * @param tableName
	 * @return
	 */
	private boolean insertIntoTable(String xlsFileName, String tableName){
		
		File configFile = new File(xlsFileName);
		if (!configFile.exists()) {
			logger.error("Could data source file " + xlsFileName);
			return false;
		}
		
		try {
			
			String sheetName = tableName; //sheetName must be same as database table name
			
			FileInputStream fileInputStream = new FileInputStream(xlsFileName);
			HSSFWorkbook workbook = new HSSFWorkbook(fileInputStream);
			
			addRecords(workbook, sheetName);
			
		} catch (FileNotFoundException e) {
			logger.error("File Error while reading from xls file " + e);
		} catch (IOException e) {
			logger.error("I/O Error while reading from xls file " + e);
		}
		
		return true;
	}

	/**
	 * enter each row of worksheet to table
	 * @param workbook
	 * @param sheetName
	 * @return
	 */
	private boolean addRecords(HSSFWorkbook workbook, String sheetName ){
		logger.debug("adding records from : " + sheetName);
		HSSFSheet worksheet = workbook.getSheet(sheetName);
		HSSFRow firstRow = worksheet.getRow(0);
		int noofColumns = 0;
		
		
		while(firstRow.getCell( noofColumns++) != null)
		{
			//counting columns
		}
					
		int rowCount = 1;
		//rows
		while(worksheet.getRow(rowCount) != null)
		{
			firstRow = worksheet.getRow(0);
			HSSFRow row = worksheet.getRow(rowCount++);
			int columnCount = 0;
			//columns
			HashMap<String, Object> updateContents = new HashMap<String, Object>();
			for(int i = 0; i < noofColumns -1; i++)
			{
				HSSFCell nameCell = firstRow.getCell(columnCount);
				String cellName = nameCell.getStringCellValue();
				
				String cellVal;
				if(row.getCell( columnCount) != null){
					HSSFCell valCell = row.getCell( columnCount);
					valCell.setCellType(1);
					
					cellVal = valCell.getStringCellValue();
					cellVal = cellVal.replace("\"", "\\\"");
					tableContents.put(cellName, cellVal);
					
					//keeping primary key out of update columns to avoid error
					if(!cellName.contentEquals("id")){
						updateContents.put(cellName, cellVal);
					}
				}
				else 
				{
					cellVal = "";
				}
				columnCount++;
			}
			if(tableContents.containsKey("id")){
				
				HashMap<String, Object> condition = new HashMap<String, Object>();
				condition.put("id", tableContents.get("id"));
				if( dbQueries.exists(sheetName, condition , "=") )
				{
					condition.put("id", tableContents.get("id"));
					logger.debug("updating table " + sheetName);
					dbQueries.updateTable(sheetName, updateContents, condition, "=");
				}
				else{
					logger.debug("inserting into table " + sheetName);
					dbQueries.insertIntoTable(sheetName, tableContents);
					tableContents.clear();
				}
			}
			
		}
		return true;
	}

}
