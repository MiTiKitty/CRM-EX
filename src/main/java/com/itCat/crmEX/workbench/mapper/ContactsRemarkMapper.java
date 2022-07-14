package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkMapper {

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

}
