package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.ContactsActivityRelation;

import java.util.List;
import java.util.Map;

public interface ContactsActivityRelationMapper {

    /**
     * 批量插入多条联系人与市场活动关联关系
     * @param relationList
     * @return
     */
    int insertContactsActivityRelations(List<ContactsActivityRelation> relationList);

    /**
     * 根据市场活动与联系人关联关系id删除该关联关系
     * @param map
     * @return
     */
    int deleteContactsActivityRelation(Map<String, Object> map);

    /**
     * 根据联系人id集合，删除该所有联系人下的市场活动关联关系
     * @param contactsIds
     * @return
     */
    int deleteContactsActivityByContactsIds(String[] contactsIds);
}
