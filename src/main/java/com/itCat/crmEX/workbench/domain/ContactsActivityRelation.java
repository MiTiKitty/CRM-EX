package com.itCat.crmEX.workbench.domain;

public class ContactsActivityRelation {

    private String id;

    private String contactsId;

    private String activityId;

    public ContactsActivityRelation() {
    }

    public ContactsActivityRelation(String id, String contactsId, String activityId) {
        this.id = id;
        this.contactsId = contactsId;
        this.activityId = activityId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getContactsId() {
        return contactsId;
    }

    public void setContactsId(String contactsId) {
        this.contactsId = contactsId;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    @Override
    public String toString() {
        return "ContactsActivityRelation{" +
                "id='" + id + '\'' +
                ", contactsId='" + contactsId + '\'' +
                ", activityId='" + activityId + '\'' +
                '}';
    }
}
