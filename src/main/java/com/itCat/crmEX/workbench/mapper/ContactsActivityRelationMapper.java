package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationMapper {

    /**
     * 批量插入多条联系人与市场活动关联关系
     * @param relationList
     * @return
     */
    int insertContactsActivityRelations(List<ContactsActivityRelation> relationList);
}
