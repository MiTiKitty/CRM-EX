package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.workbench.domain.Contacts;
import com.itCat.crmEX.workbench.domain.ContactsRemark;
import com.itCat.crmEX.workbench.mapper.ContactsRemarkMapper;
import com.itCat.crmEX.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("contactsRemarkService")
public class ContactsRemarkServiceImpl implements ContactsRemarkService {

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Override
    public List<ContactsRemark> queryContactsRemarkByContactsId(String contactsId) {
        List<ContactsRemark> remarkList = contactsRemarkMapper.selectContactsRemarkByContactsId(contactsId);
        for (ContactsRemark remark : remarkList) {
            if (Constants.NOT_EDIT.equals(remark.getEditFlag())){
                remark.setShowPerson(remark.getNotePerson());
                remark.setShowTime(remark.getNoteTime());
            }else {
                remark.setShowPerson(remark.getEditPerson());
                remark.setShowTime(remark.getEditTime());
            }
        }
        return remarkList;
    }

    @Override
    public int saveContactsRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.insertContactsRemark(contactsRemark);
    }

    @Override
    public int editContactsRemarkById(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.updateContactsRemarkById(contactsRemark);
    }

    @Override
    public int removeContactsRemarkById(String id) {
        return contactsRemarkMapper.deleteContactsRemarkById(id);
    }
}
