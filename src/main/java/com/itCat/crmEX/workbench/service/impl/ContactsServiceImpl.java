package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.Contacts;
import com.itCat.crmEX.workbench.mapper.ContactsMapper;
import com.itCat.crmEX.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("contactsService")
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;

    @Override
    public int saveContacts(Contacts contacts) {
        return contactsMapper.insertContacts(contacts);
    }
}
