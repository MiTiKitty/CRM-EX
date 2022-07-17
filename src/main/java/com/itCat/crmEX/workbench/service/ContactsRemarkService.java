package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {

    /**
     * 根据联系人id查找联系人备注信息
     * @param contactsId
     * @return
     */
    List<ContactsRemark> queryContactsRemarkByContactsId(String contactsId);

    int saveContactsRemark(ContactsRemark contactsRemark);

    /**
     * 根据联系人备注信息id修改备注信息
     * @param contactsRemark
     * @return
     */
    int editContactsRemarkById(ContactsRemark contactsRemark);

    /**
     * 根据联系人备注信息id来删除该备注信息
     * @param id
     * @return
     */
    int removeContactsRemarkById(String id);

}
