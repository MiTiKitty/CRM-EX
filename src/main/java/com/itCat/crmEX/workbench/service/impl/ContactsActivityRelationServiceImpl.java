package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.ContactsActivityRelation;
import com.itCat.crmEX.workbench.mapper.ContactsActivityRelationMapper;
import com.itCat.crmEX.workbench.service.ContactsActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("contactsActivityRelationService")
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Override
    public int saveContactsActivityRelation(List<ContactsActivityRelation> relationList) {
        return contactsActivityRelationMapper.insertContactsActivityRelations(relationList);
    }

    @Override
    public int removeContactsActivityRelation(Map<String, Object> map) {
        return contactsActivityRelationMapper.deleteContactsActivityRelation(map);
    }
}
