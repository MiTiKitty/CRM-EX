package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    /**
     * 条件分页查询联系人信息
     * @param map
     * @return
     */
    List<Contacts> queryContactsByCondition(Map<String, Object> map);

    /**
     * 查询符合条件的联系人总条数
     * @param map
     * @return
     */
    int queryContactsCountByCondition(Map<String, Object> map);

    /**
     * 根据联系人id查找联系人明细信息
     * @param id
     * @return
     */
    Contacts queryContactsForDetailById(String id);

    /**
     * 根据客户id查找其下的所有联系人信息
     * @param customerId
     * @return
     */
    List<Contacts> queryContactsForCustomerDetailByCustomerId(String customerId);

    /**
     * 根据联系人id查找联系人信息
     *
     * @param id
     * @return
     */
    Contacts queryContactsById(String id);

    int saveContacts(Contacts contacts);

    /**
     * 根据联系人id修改联系人信息
     * @param contacts
     * @return
     */
    int editContactsById(Contacts contacts);

    void removeContactsByIds(String[] ids);

}
