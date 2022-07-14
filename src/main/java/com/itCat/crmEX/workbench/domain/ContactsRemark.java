package com.itCat.crmEX.workbench.domain;

public class ContactsRemark {

    private String id;

    private String notePerson;

    private String noteContent;

    private String noteTime;

    private String editPerson;

    private String editTime;

    private String editFlag;

    private String contactsId;

    private String showPerson;

    private String showTime;

    public ContactsRemark() {
    }

    public ContactsRemark(String id, String notePerson, String noteContent, String noteTime, String editPerson,
                          String editTime, String editFlag, String contactsId, String showPerson, String showTime) {
        this.id = id;
        this.notePerson = notePerson;
        this.noteContent = noteContent;
        this.noteTime = noteTime;
        this.editPerson = editPerson;
        this.editTime = editTime;
        this.editFlag = editFlag;
        this.contactsId = contactsId;
        this.showPerson = showPerson;
        this.showTime = showTime;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNotePerson() {
        return notePerson;
    }

    public void setNotePerson(String notePerson) {
        this.notePerson = notePerson;
    }

    public String getNoteContent() {
        return noteContent;
    }

    public void setNoteContent(String noteContent) {
        this.noteContent = noteContent;
    }

    public String getNoteTime() {
        return noteTime;
    }

    public void setNoteTime(String noteTime) {
        this.noteTime = noteTime;
    }

    public String getEditPerson() {
        return editPerson;
    }

    public void setEditPerson(String editPerson) {
        this.editPerson = editPerson;
    }

    public String getEditTime() {
        return editTime;
    }

    public void setEditTime(String editTime) {
        this.editTime = editTime;
    }

    public String getEditFlag() {
        return editFlag;
    }

    public void setEditFlag(String editFlag) {
        this.editFlag = editFlag;
    }

    public String getContactsId() {
        return contactsId;
    }

    public void setContactsId(String contactsId) {
        this.contactsId = contactsId;
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
        return "ContactsRemark{" +
                "id='" + id + '\'' +
                ", notePerson='" + notePerson + '\'' +
                ", noteContent='" + noteContent + '\'' +
                ", noteTime='" + noteTime + '\'' +
                ", editPerson='" + editPerson + '\'' +
                ", editTime='" + editTime + '\'' +
                ", editFlag='" + editFlag + '\'' +
                ", customerId='" + contactsId + '\'' +
                ", showPerson='" + showPerson + '\'' +
                ", showTime='" + showTime + '\'' +
                '}';
    }
}
