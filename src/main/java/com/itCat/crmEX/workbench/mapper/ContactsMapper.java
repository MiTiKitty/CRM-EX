package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsMapper {

    /**
     * 条件分页查询联系人信息
     *
     * @param map
     * @return
     */
    List<Contacts> selectContactsByCondition(Map<String, Object> map);

    /**
     * 查询符合条件的联系人总条数
     *
     * @param map
     * @return
     */
    int selectContactsCountByCondition(Map<String, Object> map);

    /**
     * 根据联系人id查找联系人明细信息
     *
     * @param id
     * @return
     */
    Contacts selectContactsForDetailById(String id);

    /**
     * 根据联系人id查找联系人信息
     *
     * @param id
     * @return
     */
    Contacts selectContactsById(String id);

    /**
     * 根据客户id查找其下的所有联系人信息
     *
     * @param customerId
     * @return
     */
    List<Contacts> selectContactsForCustomerDetailByCustomerId(String customerId);

    /**
     * 插入一条新的联系人信息
     *
     * @param contacts
     * @return
     */
    int insertContacts(Contacts contacts);

    /**
     * 根据联系人id修改联系人信息
     *
     * @param contacts
     * @return
     */
    int updateContactsById(Contacts contacts);

    /**
     * 根据联系人id集合删除联系人信息
     *
     * @param ids
     * @return
     */
    int deleteContactsByIds(String[] ids);

}
