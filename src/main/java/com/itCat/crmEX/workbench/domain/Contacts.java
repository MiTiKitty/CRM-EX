package com.itCat.crmEX.workbench.domain;

public class Contacts {

    private String id;

    private String owner;

    private String source;

    private String appellation;

    private String fullName;

    private String email;

    private String job;

    private String mphone;

    private String description;

    private String address;

    private String birth;

    private String customerId;

    private String createBy;

    private String createTime;

    private String editBy;

    private String editTime;

    private String contactSummary;

    private String nextContactTime;

    private String customerName;

    private String showPerson;

    private String showTime;

    public Contacts() {
    }

    public Contacts(String id, String owner, String source, String appellation, String fullName, String email,
                    String job, String mphone, String description, String address, String birth, String customerId,
                    String createBy, String createTime, String editBy, String editTime, String contactSummary,
                    String nextContactTime, String customerName, String showPerson, String showTime) {
        this.id = id;
        this.owner = owner;
        this.source = source;
        this.appellation = appellation;
        this.fullName = fullName;
        this.email = email;
        this.job = job;
        this.mphone = mphone;
        this.description = description;
        this.address = address;
        this.birth = birth;
        this.customerId = customerId;
        this.createBy = createBy;
        this.createTime = createTime;
        this.editBy = editBy;
        this.editTime = editTime;
        this.contactSummary = contactSummary;
        this.nextContactTime = nextContactTime;
        this.customerName = customerName;
        this.showPerson = showPerson;
        this.showTime = showTime;
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

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getAppellation() {
        return appellation;
    }

    public void setAppellation(String appellation) {
        this.appellation = appellation;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public String getMphone() {
        return mphone;
    }

    public void setMphone(String mphone) {
        this.mphone = mphone;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getBirth() {
        return birth;
    }

    public void setBirth(String birth) {
        this.birth = birth;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
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

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getShowPerson() {
        return showPerson;
    }

    public void setShowPerson(String showPerson) {
        this.showPerson = showPerson;
    }

    public String getShowTime() {
        return showTime;
    }

    public void setShowTime(String showTime) {
        this.showTime = showTime;
    }

    @Override
    public String toString() {
        return "Contacts{" +
                "id='" + id + '\'' +
                ", owner='" + owner + '\'' +
                ", source='" + source + '\'' +
                ", appellation='" + appellation + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", job='" + job + '\'' +
                ", mphone='" + mphone + '\'' +
                ", description='" + description + '\'' +
                ", address='" + address + '\'' +
                ", birth='" + birth + '\'' +
                ", customerId='" + customerId + '\'' +
                ", createBy='" + createBy + '\'' +
                ", createTime='" + createTime + '\'' +
                ", editBy='" + editBy + '\'' +
                ", editTime='" + editTime + '\'' +
                ", contactSummary='" + contactSummary + '\'' +
                ", nextContactTime='" + nextContactTime + '\'' +
                ", customerName='" + customerName + '\'' +
                ", showPerson='" + showPerson + '\'' +
                ", showTime='" + showTime + '\'' +
                '}';
    }
}
