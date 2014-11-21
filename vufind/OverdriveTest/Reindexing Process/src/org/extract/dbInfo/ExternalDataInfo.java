package org.extract.dbInfo;

import org.json.JSONObject;

public class ExternalDataInfo {
	
	private String sourcePrefix;
	private int id;
	private int sourceId;
	private int resourceId;
	private String record_Id;
	private String externalId;
	private JSONObject sourceMetaData;
	private String indexedMetaData;
	private int limitedCopies;
	private int totalCopies;
	private int availableCopies;
	private int numberOfHolds;
	private Long dateAdded;
	private Long lastMetaDataCheck;
	private Long lastMetaDataChange;
	private Long lastAvailabilityCheck;
	private Long lastAvailabilityChange;
	public String getSourcePrefix() {
		return sourcePrefix;
	}
	public void setSourcePrefix(String sourcePrefix) {
		this.sourcePrefix = sourcePrefix;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getSourceId() {
		return sourceId;
	}
	public void setSourceId(int sourceId) {
		this.sourceId = sourceId;
	}
	public int getResourceId() {
		return resourceId;
	}
	public void setResourceId(int resourceId) {
		this.resourceId = resourceId;
	}
	public String getRecord_Id() {
		return record_Id;
	}
	public void setRecord_Id(String record_Id) {
		this.record_Id = record_Id;
	}
	public String getExternalId() {
		return externalId;
	}
	public void setExternalId(String externalId) {
		this.externalId = externalId;
	}
	public JSONObject getSourceMetaData() {
		return sourceMetaData;
	}
	public void setSourceMetaData(JSONObject sourceMetaData) {
		this.sourceMetaData = sourceMetaData;
	}
	public String getIndexedMetaData() {
		return indexedMetaData;
	}
	public void setIndexedMetaData(String indexedMetaData) {
		this.indexedMetaData = indexedMetaData;
	}
	public int getLimitedCopies() {
		return limitedCopies;
	}
	public void setLimitedCopies(int limitedCopies) {
		this.limitedCopies = limitedCopies;
	}
	public int getTotalCopies() {
		return totalCopies;
	}
	public void setTotalCopies(int totalCopies) {
		this.totalCopies = totalCopies;
	}
	public int getAvailableCopies() {
		return availableCopies;
	}
	public void setAvailableCopies(int availableCopies) {
		this.availableCopies = availableCopies;
	}
	public int getNumberOfHolds() {
		return numberOfHolds;
	}
	public void setNumberOfHolds(int numberOfHolds) {
		this.numberOfHolds = numberOfHolds;
	}
	public Long getDateAdded() {
		return dateAdded;
	}
	public void setDateAdded(Long dateAdded) {
		this.dateAdded = dateAdded;
	}
	public Long getLastMetaDataCheck() {
		return lastMetaDataCheck;
	}
	public void setLastMetaDataCheck(Long lastMetaDataCheck) {
		this.lastMetaDataCheck = lastMetaDataCheck;
	}
	public Long getLastMetaDataChange() {
		return lastMetaDataChange;
	}
	public void setLastMetaDataChange(Long lastMetaDataChange) {
		this.lastMetaDataChange = lastMetaDataChange;
	}
	public Long getLastAvailabilityCheck() {
		return lastAvailabilityCheck;
	}
	public void setLastAvailabilityCheck(Long lastAvailabilityCheck) {
		this.lastAvailabilityCheck = lastAvailabilityCheck;
	}
	public Long getLastAvailabilityChange() {
		return lastAvailabilityChange;
	}
	public void setLastAvailabilityChange(Long lastAvailabilityChange) {
		this.lastAvailabilityChange = lastAvailabilityChange;
	}
}
