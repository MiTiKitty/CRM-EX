package com.itCat.crmEX.workbench.domain;

public class Transaction {

    private String id;

    private String owner;

    private Long amountOfMoney;

    private String name;

    private String expectedClosingDate;

    private String customerId;

    private String stage;

    private String type;

    private String source;

    private String activityId;

    private String contactsId;

    private String description;

    private String createBy;

    private String createTime;

    private String editBy;

    private String editTime;

    private String contactSummary;

    private String nextContactTime;

    public Transaction() {
    }

    public Transaction(String id, String owner, Long amountOfMoney, String name, String expectedClosingDate,
                       String customerId, String stage, String type, String source, String activityId, String contactsId,
                       String description, String createBy, String createTime, String editBy, String editTime,
                       String contactSummary, String nextContactTime) {
        this.id = id;
        this.owner = owner;
        this.amountOfMoney = amountOfMoney;
        this.name = name;
        this.expectedClosingDate = expectedClosingDate;
        this.customerId = customerId;
        this.stage = stage;
        this.type = type;
        this.source = source;
        this.activityId = activityId;
        this.contactsId = contactsId;
        this.description = description;
        this.createBy = createBy;
        this.createTime = createTime;
        this.editBy = editBy;
        this.editTime = editTime;
        this.contactSummary = contactSummary;
        this.nextContactTime = nextContactTime;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public Long getAmountOfMoney() {
        return amountOfMoney;
    }

    public void setAmountOfMoney(Long amountOfMoney) {
        this.amountOfMoney = amountOfMoney;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getExpectedClosingDate() {
        return expectedClosingDate;
    }

    public void setExpectedClosingDate(String expectedClosingDate) {
        this.expectedClosingDate = expectedClosingDate;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public String getStage() {
        return stage;
    }

    public void setStage(String stage) {
        this.stage = stage;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getContactsId() {
        return contactsId;
    }

    public void setContactsId(String contactsId) {
        this.contactsId = contactsId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getEditBy() {
        return editBy;
    }

    public void setEditBy(String editBy) {
        this.editBy = editBy;
    }

    public String getEditTime() {
        return editTime;
    }

    public void setEditTime(String editTime) {
        this.editTime = editTime;
    }

    public String getContactSummary() {
        return contactSummary;
    }

    public void setContactSummary(String contactSummary) {
        this.contactSummary = contactSummary;
    }

    public String getNextContactTime() {
        return nextContactTime;
    }

    public void setNextContactTime(String nextContactTime) {
        this.nextContactTime = nextContactTime;
    }

    @Override
    public String toString() {
        return "Transaction{" +
                "id='" + id + '\'' +
                ", owner='" + owner + '\'' +
                ", amountOfMoney=" + amountOfMoney +
                ", name='" + name + '\'' +
                ", expectedClosingDate='" + expectedClosingDate + '\'' +
                ", customerId='" + customerId + '\'' +
                ", stage='" + stage + '\'' +
                ", type='" + type + '\'' +
                ", source='" + source + '\'' +
                ", activityId='" + activityId + '\'' +
                ", contactsId='" + contactsId + '\'' +
                ", description='" + description + '\'' +
                ", createBy='" + createBy + '\'' +
                ", createTime='" + createTime + '\'' +
                ", editBy='" + editBy + '\'' +
                ", editTime='" + editTime + '\'' +
                ", contactSummary='" + contactSummary + '\'' +
                ", nextContactTime='" + nextContactTime + '\'' +
                '}';
    }
}
