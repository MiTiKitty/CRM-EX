package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.ContactsRemark;
import com.itCat.crmEX.workbench.mapper.ContactsRemarkMapper;
import com.itCat.crmEX.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("contactsRemarkService")
public class ContactsRemarkServiceImpl implements ContactsRemarkService {

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Override
    public int saveContactsRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.insertContactsRemark(contactsRemark);
    }
}
