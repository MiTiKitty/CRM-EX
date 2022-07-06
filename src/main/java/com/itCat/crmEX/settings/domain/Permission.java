package com.itCat.crmEX.settings.domain;

public class Permission {

    private String id;

    private String pid;

    private String name;

    private String moduleUrl;

    private String operUrl;

    private Long orderNo;

    public Permission() {
    }

    public Permission(String id, String pid, String name, String moduleUrl, String operUrl, Long orderNo) {
        this.id = id;
        this.pid = pid;
        this.name = name;
        this.moduleUrl = moduleUrl;
        this.operUrl = operUrl;
        this.orderNo = orderNo;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getModuleUrl() {
        return moduleUrl;
    }

    public void setModuleUrl(String moduleUrl) {
        this.moduleUrl = moduleUrl;
    }

    public String getOperUrl() {
        return operUrl;
    }

    public void setOperUrl(String operUrl) {
        this.operUrl = operUrl;
    }

    public Long getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(Long orderNo) {
        this.orderNo = orderNo;
    }
}
