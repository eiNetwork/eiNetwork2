
package org.extract.dbtools;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map.Entry;

import org.apache.log4j.Logger;
/**
 * This class generates basic prepared statement for insert, delete, select, selectAll, update, deleteAndReset and exist.
 * All of the functions take in String table name, HasMaps for items to be inserted and HashMap for items conditions, 
 * and String condition operator.
 * The HashMaps are set as <String, Object> String being place holder for column names and Objects as Values 
 * 
 * <br/>It is also designed to execute the preparedStatement. 
 * In order to construct an object of this class, the constructor with Connection must be used for the prepared statement to execute
 * @version 2014-11-19
 * @author Devesh
 */
public class DatabaseQueries {
	private static Logger logger = Logger.getLogger(DatabaseQueries.class);
	private static Connection conn = null;
	private static String sqlQuery;
	private PreparedStatement preparedStatement;
	/**
	 * Parameterized constructor: set up database connection
	 * @param conn
	 */
	public DatabaseQueries(Connection conn){
		DatabaseQueries.conn = conn;
	}
	/**
	 * If the object is made with default constructor, the connection has to be set through this function
	 * @param conn
	 */
	public void setConnection(Connection conn){
		DatabaseQueries.conn = conn;
	}
	
	/**
	 * generates insert sql query, eg: INSERT INTO tableName set columnName1 = val1, columnName2 = val2; 
	 * <br/>column names and corresponding value must be passed through HashMap<String, String> 
	 * @param tableName
	 * @param tableContents
	 * 			HashMap with column names and column values
	 * @return
	 * 		prepared Statement generated key
	 */
	public ResultSet insertIntoTable(String tableName, HashMap<String, Object> tableContents){
		
		sqlQuery = "INSERT INTO " + tableName + " SET ";
		
		Iterator<Entry<String, Object>> iter = tableContents.entrySet().iterator();
		boolean comma = false; 	
	    while (iter.hasNext()) {
	    	if(comma) {
	    		 sqlQuery += ",";
	    	}
	        Entry<String, Object> pairs = iter.next();
	        sqlQuery += pairs.getKey() + " = \"" + pairs.getValue() + "\"";
	        comma = true;
	    }
	    
	    //logger.debug("Prep Stat : " + sqlQuery);
	    try {
			preparedStatement = conn.prepareStatement(sqlQuery,PreparedStatement.RETURN_GENERATED_KEYS);
			preparedStatement.executeUpdate();
			
		} catch (SQLException e) {
			logger.debug(sqlQuery);
			logger.error( "insert prepared Statement error : " + e) ;
			
			return null;
		}
	    try {
			return preparedStatement.getGeneratedKeys();
		} catch (SQLException e) {
			
			logger.error("error: could not get GeneratedKeys(), " + e );
			
		}
	    return null;
	}
	/**
	 * insert if record does not exists
	 * <br/>column names and corresponding value must be passed through HashMap<String, String> 
	 * @param tableName
	 * @param tableContents
	 * 			HashMap with column names and column values
	 * @param condition
	 * 			HashMap with column names and column values
	 * @param operator
	 * 			condition operator like = < > 
	 * @return
	 */
	public ResultSet insertIntoTableIfNotExist(String tableName, HashMap<String, Object> tableContents, HashMap<String, Object> condition, String operator){
	
		HashSet<String> columns = new HashSet<String>();
		ResultSet resultSet = null;
		Iterator<Entry<String, Object>> iter = tableContents.entrySet().iterator();
	    while (iter.hasNext()) {
	    	
	        Entry<String, Object> pairs = iter.next();
	        columns.add( pairs.getKey() );
	    }
		
		ResultSet rs = select(tableName, columns, condition, operator);
		try {
			if(rs.isBeforeFirst() ){
				logger.debug(tableName + " Entry already exist...");
			}
			else
			{
				insertIntoTable(tableName, tableContents);
				logger.debug("Entering new record in " +  tableName);
			}
			
		} catch (SQLException e) {
			logger.error(e);
		}
		
		return resultSet;
		
	}
	/**
	 * generate delete sql query, ex: DELETE FROM tableName WHERE columnName1 = val1 and columnName2 = value2;
	 * <br/>delete condition must be passed in HashMap<String, String> format
	 * @param tableName
	 * @param condition
	 * 			HashMap with column names and column values
	 * @param operator
	 * 			condition operator like = < > 
	 * @return
	 */
	public boolean deleteRow(String tableName, HashMap<String, Object> condition, String operator){
		sqlQuery = "DELETE FROM " + tableName + " WHERE ";
		
		Iterator<Entry<String, Object>> iter = condition.entrySet().iterator();
		boolean and = false;
	    while (iter.hasNext()) {
	    	if(and) {
	    		 sqlQuery += " and ";
	    	}
	        Entry<String, Object> pairs = iter.next();
	        sqlQuery += pairs.getKey() + " " + operator + " \"" + pairs.getValue() + "\"";
	        and = true;
	    }
	    
	    try {
			preparedStatement = conn.prepareStatement(sqlQuery);
			preparedStatement.executeUpdate();
		} catch (SQLException e) {
			logger.error( "error generating prepared Statement, " + e) ;
			return false;
		}
	    return true;
	}
	
	/**
	 * Deletes all the contents of the table and resets any auto_increment number to 1, 
	 * should not be used if auto_increment no is foreign key to other tables.
	 * @param tableName
	 * @return
	 */
	public boolean deleteAndReset(String tableName){
		sqlQuery = "DELETE FROM " + tableName;
		String sqlAlter = "alter table " + tableName +" AUTO_INCREMENT = 1";
		
	    try {
			preparedStatement = conn.prepareStatement(sqlQuery);
			preparedStatement.executeUpdate();
			preparedStatement = conn.prepareStatement(sqlAlter);
			preparedStatement.executeUpdate();
			
		} catch (SQLException e) {
			logger.error( "error generating prepared Statement, " + e) ;
			return false;
		}
	    return true;
	}
	/**
	 * generate update sql query, ex: UPDATE tableName SET columnName1 = yval1, columnName2 = val2 where columnxx = valxx and columnyy = valy;
	 * <br/>The updates must be passed through HashMap<String, String> as second argument and condition as third argument

	 * @param tableName
	 * @param changes
	 * 			HashMap with column names and column values
	 * @param condition
	 * 			HashMap with column names and column values
	 * @param operator
	 * 			condition operator like = < > 
	 * @return
	 */
	public boolean updateTable(String tableName, HashMap<String, Object> changes, HashMap<String, Object> condition, String operator){
		
		sqlQuery = "UPDATE " + tableName + " SET ";
		
		Iterator<Entry<String, Object>> iter = changes.entrySet().iterator();
		boolean comma = false;
	    while (iter.hasNext()) {
	    	if(comma) {
	    		 sqlQuery += ",";
	    	}
	        Entry<String, Object> pairs = iter.next();
	        sqlQuery += pairs.getKey() + " = \"" + pairs.getValue() + "\"";
	        comma = true;
	    }
	    
	    sqlQuery += " WHERE ";
	   
	    iter = condition.entrySet().iterator();
		boolean and = false;
	    while (iter.hasNext()) {
	    	if(and) {
	    		 sqlQuery += " AND ";
	    	}
	        Entry<String, Object> pairs = iter.next();
	        sqlQuery += pairs.getKey() + " " + operator + " \"" + pairs.getValue() + "\"";
	        and = true;
	        //logger.debug(sqlQuery);
	        iter.remove();
	    }
	    
	    try {
	    	
			preparedStatement = conn.prepareStatement(sqlQuery);
			preparedStatement.executeUpdate();
		} catch (SQLException e) {
			logger.debug( sqlQuery);
			logger.error( "update prepared Statement error : " + e) ;
			return false;
		}
	   
		return true;
	}
	/**
	 * generate select sql query, eg: SELECT column1, columne2 FROM tableName WHERE columnxx = valxx and columnyy = valyy;
	 * <br/>select should in HashSet<String> format as second arg and condition in HashMap<String, String> as third args
	 * @param tableName
	 * @param columns
	 * 			HashSet with column names
	 * @param condition
	 * 			HashMap with column names and column values
	 * @param operator
	 * 			condition operator like = < > 
	 * @return
	 */
	public ResultSet select(String tableName, HashSet<String> columns, HashMap<String, Object> condition, String operator){
		
		sqlQuery = "SELECT ";
		
		ResultSet resultSet = null;
		Iterator<String> iter = columns.iterator();
		boolean comma = false;
	    while (iter.hasNext()) {
	    	if(comma) {
	    		 sqlQuery += ",";
	    	}
	        sqlQuery += iter.next();
	        comma = true;
	    }
	    
	    sqlQuery += " FROM " + tableName + " WHERE ";
	    
	    Iterator<Entry<String, Object>> setIter = condition.entrySet().iterator();
		boolean and = false;
	    while (setIter.hasNext()) {
	    	if(and) {
	    		 sqlQuery += " AND ";
	    	}
	        Entry<String, Object> pairs = setIter.next();
	        sqlQuery += pairs.getKey() + " " + operator + " \"" + pairs.getValue() + "\"";
	        and = true;
	    }
	    //logger.debug("Prep Stat : " + sqlQuery);
	    try {
			preparedStatement = conn.prepareStatement(sqlQuery);
			resultSet = preparedStatement.executeQuery();
		} catch (SQLException e) {
			logger.debug(sqlQuery);
			logger.error( "select prepared Statement error : " + e) ;
		}
		return resultSet;
	}

	/**
	 * select all row 
	 * @param tableName
	 * @param columns
	 * 			HashMap with column names
	 * @return
	 */
	public ResultSet selectAllRows(String tableName, HashSet<String> columns){
		
		sqlQuery = "SELECT ";
		
		ResultSet resultSet = null;
		Iterator<String> iter = columns.iterator();
		boolean comma = false;
	    while (iter.hasNext()) {
	    	if(comma) {
	    		 sqlQuery += ",";
	    	}
	        sqlQuery += iter.next();
	        comma = true;
	    }
	    
	    sqlQuery += " FROM " + tableName;
	    
	    try {
			preparedStatement = conn.prepareStatement(sqlQuery);
			resultSet = preparedStatement.executeQuery();
		} catch (SQLException e) {
			logger.error( "select prepared Statement error : " + e) ;
		}
	   
		return resultSet;
	}
	
	/**
	 * Check for existing record
	 * @param tableName
	 * @param condition
	 * 			HashMap with column names and column values
	 * @param operator
	 * 			condition operator like = < > 
	 * @return
	 */
	public boolean exists(String tableName, HashMap<String, Object> condition, String operator){
		
		sqlQuery = "SELECT * FROM " + tableName + " WHERE ";
		ResultSet resultSet;
		Iterator<Entry<String, Object>> setIter = condition.entrySet().iterator();
		boolean and = false;
	    while (setIter.hasNext()) {
	    	if(and) {
	    		 sqlQuery += " AND ";
	    	}
	        Entry<String, Object> pairs = setIter.next();
	        sqlQuery += pairs.getKey() + " " + operator + " \"" + pairs.getValue() + "\"";
	        and = true;
	    }
	    
	    try {
	    	//logger.debug(sqlQuery);
			preparedStatement = conn.prepareStatement(sqlQuery);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.first()){
				return true;
			}
		} catch (SQLException e) {
			
			logger.error( "select prepared Statement error : " + e) ;
		}
	    
		
		return false;	
	}

}
