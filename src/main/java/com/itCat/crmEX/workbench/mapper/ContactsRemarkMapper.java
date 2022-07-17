package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkMapper {

    /**
     * 根据联系人id查找联系人备注信息
     * @param contactsId
     * @return
     */
    List<ContactsRemark> selectContactsRemarkByContactsId(String contactsId);

    /**
     * 插入一条新的客户备注信息
     * @param contactsRemark
     * @return
     */
    int insertContactsRemark(ContactsRemark contactsRemark);

    /**
     * 批量插入多条客户备注信息
     * @param remarkList
     * @return
     */
    int insertContactsRemarks(List<ContactsRemark> remarkList);

    /**
     * 根据联系人备注信息id修改备注信息
     * @param contactsRemark
     * @return
     */
    int updateContactsRemarkById(ContactsRemark contactsRemark);

    /**
     * 根据联系人备注信息id来删除该备注信息
     * @param id
     * @return
     */
    int deleteContactsRemarkById(String id);

    /**
     * 根据联系人id集合，删除这些联系人下的所有备注信息
     * @param contactsIds
     * @return
     */
    int deleteContactsRemarkByContactsIds(String[] contactsIds);

}
