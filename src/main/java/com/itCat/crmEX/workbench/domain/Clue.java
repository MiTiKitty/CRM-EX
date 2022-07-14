package com.itCat.crmEX.workbench.domain;

public class Clue {

    private String id;

    private String owner;

    private String company;

    private String phone;

    private String website;

    private String grade;

    private String industry;

    private String address;

    private String description;

    private String fullName;

    private String appellation;

    private String source;

    private String email;

    private String mphone;

    private String job;

    private String state;

    private String createBy       ;

    private String createTime     ;

    private String editBy         ;

    private String editTime       ;

    private String contactSummary ;

    private String nextContactTime;

    public Clue() {
    }

    public Clue(String id, String owner, String company, String phone, String website, String grade, String industry,
                String address, String description, String fullName, String appellation, String source, String email,
                String mphone, String job, String state, String createBy, String createTime, String editBy,
                String editTime, String contactSummary, String nextContactTime) {
        this.id = id;
        this.owner = owner;
        this.company = company;
        this.phone = phone;
        this.website = website;
        this.grade = grade;
        this.industry = industry;
        this.address = address;
        this.description = description;
        this.fullName = fullName;
        this.appellation = appellation;
        this.source = source;
        this.email = email;
        this.mphone = mphone;
        this.job = job;
        this.state = state;
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

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getIndustry() {
        return industry;
    }

    public void setIndustry(String industry) {
        this.industry = industry;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAppellation() {
        return appellation;
    }

    public void setAppellation(String appellation) {
        this.appellation = appellation;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMphone() {
        return mphone;
    }

    public void setMphone(String mphone) {
        this.mphone = mphone;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
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
        return "Clue{" +
                "id='" + id + '\'' +
                ", owner='" + owner + '\'' +
                ", company='" + company + '\'' +
                ", phone='" + phone + '\'' +
                ", website='" + website + '\'' +
                ", grade='" + grade + '\'' +
                ", industry='" + industry + '\'' +
                ", address='" + address + '\'' +
                ", description='" + description + '\'' +
                ", fullName='" + fullName + '\'' +
                ", appellation='" + appellation + '\'' +
                ", source='" + source + '\'' +
                ", email='" + email + '\'' +
                ", mphone='" + mphone + '\'' +
                ", job='" + job + '\'' +
                ", state='" + state + '\'' +
                ", createBy='" + createBy + '\'' +
                ", createTime='" + createTime + '\'' +
                ", editBy='" + editBy + '\'' +
                ", editTime='" + editTime + '\'' +
                ", contactSummary='" + contactSummary + '\'' +
                ", nextContactTime='" + nextContactTime + '\'' +
                '}';
    }
}
