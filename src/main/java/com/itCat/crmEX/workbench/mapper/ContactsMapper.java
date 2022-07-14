package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.Contacts;

public interface ContactsMapper {

    /**
     * 插入一条新的联系人信息
     * @param contacts
     * @return
     */
    int insertContacts(Contacts contacts);

}
