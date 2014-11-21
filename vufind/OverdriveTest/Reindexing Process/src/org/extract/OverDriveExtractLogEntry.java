package org.extract;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;

import org.apache.log4j.Logger;
import org.extract.dbtools.DatabaseQueries;

public class OverDriveExtractLogEntry {
	private int id = 0;
	private String processName;
	private String  processOptions;
	private Long startTime = 0L;
	private Long endTime = 0L;
	private int recordsProcessed = 0;
	private int recordsAdded = 0;
	private int recordsUpdated = 0;
	private int recordsDeleted = 0;
	private int recordsErrors = 0;
	
	private Connection conn;
	private Logger logger;
	private static PreparedStatement insertLogEntry;
	private static PreparedStatement updateLogEntry;
	
	public OverDriveExtractLogEntry(Connection conn, Logger logger){
		this.logger = logger;
		this.conn = conn;
		startLog();
	}
	/*
	 * create new entry in the table, get the auto generated id from table
	 */
	public void startLog(){
		startTime = new Date().getTime();
		
	}
	/*
	 * update according table for specific id
	 */
	public boolean updateLog() {
		HashMap<String, Object> contents = new HashMap<String, Object>();
		contents.put("processName", processName);
		contents.put("processOptions", processOptions);
		contents.put("startTime", startTime);
		contents.put("endTime",endTime);
		contents.put("recordsProcessed",recordsProcessed);
		contents.put("recordsAdded",recordsAdded);
		contents.put("recordsUpdated",recordsUpdated);
		contents.put("recordsDeleted", recordsDeleted);
		contents.put("recordsErrors", recordsErrors);
		DatabaseQueries dbQueries = new DatabaseQueries(conn);
		dbQueries.insertIntoTable("reindexLog", contents);
		
		return true;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	public void setProcessOptions(String processOptions) {
		this.processOptions = processOptions;
	}

	public void setStartTime(Long startTime) {
		this.startTime = startTime;
	}

	public void setEndTime(Long endTime) {
		this.endTime = endTime;
	}

	public void incRecordsProcessed() {
		recordsProcessed++;
	}

	public void incRecordsAdded() {
		recordsAdded++;
	}
	
	public void incRecordsUpdated() {
		recordsUpdated++;
	}

	public void inctRecordsDeleted() {
		recordsDeleted++;
	}

	public void incRecordsErrors() {
		recordsErrors++;
	}
		
}
