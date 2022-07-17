package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.workbench.domain.ContactsActivityRelation;

import java.util.List;
import java.util.Map;

public interface ContactsActivityRelationService {

    int saveContactsActivityRelation(List<ContactsActivityRelation> relationList);

    /**
     * 根据市场活动与联系人关联关系id删除该关联关系
     * @param map
     * @return
     */
    int removeContactsActivityRelation(Map<String, Object> map);

}
