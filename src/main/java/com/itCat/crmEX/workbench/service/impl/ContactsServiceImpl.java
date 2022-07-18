package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.Contacts;
import com.itCat.crmEX.workbench.mapper.ContactsActivityRelationMapper;
import com.itCat.crmEX.workbench.mapper.ContactsMapper;
import com.itCat.crmEX.workbench.mapper.ContactsRemarkMapper;
import com.itCat.crmEX.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("contactsService")
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Override
    public List<Contacts> queryContactsByCondition(Map<String, Object> map) {
        return contactsMapper.selectContactsByCondition(map);
    }

    @Override
    public int queryContactsCountByCondition(Map<String, Object> map) {
        return contactsMapper.selectContactsCountByCondition(map);
    }

    @Override
    public Contacts queryContactsForDetailById(String id) {
        return contactsMapper.selectContactsForDetailById(id);
    }

    @Override
    public List<Contacts> queryContactsForCustomerDetailByCustomerId(String customerId) {
        return contactsMapper.selectContactsForCustomerDetailByCustomerId(customerId);
    }

    @Override
    public Contacts queryContactsById(String id) {
        return contactsMapper.selectContactsById(id);
    }

    @Override
    public List<Contacts> queryContactsByFullNameAndByCustomerId(Map<String, Object> map) {
        return contactsMapper.selectContactsByFullNameAndByCustomerId(map);
    }

    @Override
    public int saveContacts(Contacts contacts) {
        return contactsMapper.insertContacts(contacts);
    }

    @Override
    public int editContactsById(Contacts contacts) {
        return contactsMapper.updateContactsById(contacts);
    }

    @Override
    public void removeContactsByIds(String[] ids) {
        contactsActivityRelationMapper.deleteContactsActivityByContactsIds(ids);
        contactsRemarkMapper.deleteContactsRemarkByContactsIds(ids);
        contactsMapper.deleteContactsByIds(ids);
    }
}
