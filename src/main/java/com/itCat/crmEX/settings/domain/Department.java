package com.itCat.crmEX.settings.domain;

public class Department {

    private String id;

    private String number;

    private String name;

    private User manager;

    private String description;

    private String phone;

    public Department() {
    }

    public Department(String id, String number, String name, User manager, String description, String phone) {
        this.id = id;
        this.number = number;
        this.name = name;
        this.manager = manager;
        this.description = description;
        this.phone = phone;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public User getManager() {
        return manager;
    }

    public void setManager(User manager) {
        this.manager = manager;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
