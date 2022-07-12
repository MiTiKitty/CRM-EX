package com.itCat.crmEX.workbench.domain;

public class Activity {

    private String id;

    private String owner;

    private String source;

    private String name;

    private String state;

    private String startDate;

    private String endDate;

    private Long budgetCost;

    private Long actualCost;

    private String description;

    private String createBy;

    private String createTime;

    private String editBy;

    private String editTime;

    public Activity() {
    }

    public Activity(String id, String owner, String source, String name, String state, String startDate, String endDate,
                    Long budgetCost, Long actualCost, String description, String createBy, String createTime,
                    String editBy, String editTime) {
        this.id = id;
        this.owner = owner;
        this.source = source;
        this.name = name;
        this.state = state;
        this.startDate = startDate;
        this.endDate = endDate;
        this.budgetCost = budgetCost;
        this.actualCost = actualCost;
        this.description = description;
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

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public Long getBudgetCost() {
        return budgetCost;
    }

    public void setBudgetCost(Long budgetCost) {
        this.budgetCost = budgetCost;
    }

    public Long getActualCost() {
        return actualCost;
    }

    public void setActualCost(Long actualCost) {
        this.actualCost = actualCost;
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

    @Override
    public String toString() {
        return "Activity{" +
                "id='" + id + '\'' +
                ", owner='" + owner + '\'' +
                ", source='" + source + '\'' +
                ", name='" + name + '\'' +
                ", state='" + state + '\'' +
                ", startDate='" + startDate + '\'' +
                ", endDate='" + endDate + '\'' +
                ", budgetCost=" + budgetCost +
                ", actualCost=" + actualCost +
                ", description='" + description + '\'' +
                ", createBy='" + createBy + '\'' +
                ", createTime='" + createTime + '\'' +
                ", editBy='" + editBy + '\'' +
                ", editTime='" + editTime + '\'' +
                '}';
    }
}
