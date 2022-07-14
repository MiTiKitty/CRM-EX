package com.itCat.crmEX.workbench.domain;

public class Customer {

    private String id;

    private String owner;

    private String name;

    private String grade;

    private String phone;

    private String website;

    private String industry;

    private String description;

    private String address;

    private String createBy;

    private String createTime;

    private String editBy;

    private String editTime;

    public Customer() {
    }

    public Customer(String id, String owner, String name, String grade, String phone, String website, String industry,
                    String description, String address, String createBy, String createTime, String editBy, String editTime) {
        this.id = id;
        this.owner = owner;
        this.name = name;
        this.grade = grade;
        this.phone = phone;
        this.website = website;
        this.industry = industry;
        this.description = description;
        this.address = address;
        this.createBy = createBy;
        this.createTime = createTime;
        this.editBy = editBy;
        this.editTime = editTime;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
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

    public String getIndustry() {
        return industry;
    }

    public void setIndustry(String industry) {
        this.industry = industry;
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

    @Override
    public String toString() {
        return "Customer{" +
                "id='" + id + '\'' +
                ", owner='" + owner + '\'' +
                ", name='" + name + '\'' +
                ", grade='" + grade + '\'' +
                ", phone='" + phone + '\'' +
                ", website='" + website + '\'' +
                ", industry='" + industry + '\'' +
                ", description='" + description + '\'' +
                ", address='" + address + '\'' +
                ", createBy='" + createBy + '\'' +
                ", createTime='" + createTime + '\'' +
                ", editBy='" + editBy + '\'' +
                ", editTime='" + editTime + '\'' +
                '}';
    }
}
