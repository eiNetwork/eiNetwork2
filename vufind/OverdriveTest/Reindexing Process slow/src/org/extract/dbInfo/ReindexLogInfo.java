package org.extract.dbInfo;

public class ReindexLogInfo {
	
	private int id;
	private String ProcessName;
	private String processOptions;
	private int startTime;
	private int endTime;
	private int recordsProcessed;
	private int recordsAdded;
	private int recordsUpdated;
	private int recordsDeleted;
	private int recordsErrors;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getProcessName() {
		return ProcessName;
	}
	public void setProcessName(String processName) {
		ProcessName = processName;
	}
	public String getProcessOptions() {
		return processOptions;
	}
	public void setProcessOptions(String processOptions) {
		this.processOptions = processOptions;
	}
	public int getStartTime() {
		return startTime;
	}
	public void setStartTime(int startTime) {
		this.startTime = startTime;
	}
	public int getEndTime() {
		return endTime;
	}
	public void setEndTime(int endTime) {
		this.endTime = endTime;
	}
	public int getRecordsProcessed() {
		return recordsProcessed;
	}
	public void setRecordsProcessed(int recordsProcessed) {
		this.recordsProcessed = recordsProcessed;
	}
	public int getRecordsAdded() {
		return recordsAdded;
	}
	public void setRecordsAdded(int recordsAdded) {
		this.recordsAdded = recordsAdded;
	}
	public int getRecordsUpdated() {
		return recordsUpdated;
	}
	public void setRecordsUpdated(int recordsUpdated) {
		this.recordsUpdated = recordsUpdated;
	}
	public int getRecordsDeleted() {
		return recordsDeleted;
	}
	public void setRecordsDeleted(int recordsDeleted) {
		this.recordsDeleted = recordsDeleted;
	}
	public int getRecordsErrors() {
		return recordsErrors;
	}
	public void setRecordsErrors(int recordsErrors) {
		this.recordsErrors = recordsErrors;
	}

}
