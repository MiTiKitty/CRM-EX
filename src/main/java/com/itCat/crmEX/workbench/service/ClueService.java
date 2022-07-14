package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.workbench.domain.*;

import java.util.List;
import java.util.Map;

public interface ClueService {

    /**
     * 根据查询条件分页查询线索
     * @param map
     * @return
     */
    List<Clue> queryClueByCondition(Map<String, Object> map);

    /**
     * 根据查询条件查询符合线索总条数
     * @param map
     * @return
     */
    int queryAllClueCountByCondition(Map<String, Object> map);

    /**
     * 根据线索id查找该线索信息
     * @param id
     * @return
     */
    Clue queryClueById(String id);

    /**
     * 根据线索id查找线索明细信息
     * @param id
     * @return
     */
    Clue queryClueForDetailById(String id);

    /**
     * 根据线索id为转换页面查找线索信息
     *
     * @param id
     * @return
     */
    Clue queryClueForConvertById(String id);

    /**
     * 插入一条新的线索信息
     * @param clue
     * @return
     */
    int saveClue(Clue clue);

    /**
     * 根据线索id更新该线索信息
     * @param clue
     * @return
     */
    int editClueById(Clue clue);

    /**
     * 根据线索id删除线索信息
     *
     * @param id
     * @return
     */
    int removeClueById(String id);

    /**
     * 根据线索id集合删除线索信息
     *
     * @param ids
     */
    void removeClueByIds(String[] ids);

    /**
     * 数据转换：
     *                 把线索中有关公司的信息转换到客户表中
     *                 把线索中有关个人的信息转换到联系人表中
     *                 把线索的备注信息转换到客户备注表中一份
     *                 把线索的备注信息转换到联系人备注表中一份
     *                 把线索和市场活动的关联关系转换到联系人和市场活动的关联关系表中
     *                 如果需要创建交易，还要往交易表中添加一条记录
     *                 如果需要创建交易，还要把线索的备注信息转换到交易备注表中一份
     *                 删除线索的备注
     *                 删除线索和市场活动的关联关系
     *                 删除线索
     *
     * @param customer              客户
     * @param contacts              联系人
     * @param customerRemarkList    客户备注信息列表
     * @param contactsRemarkList    联系人备注信息列表
     * @param relationList          联系人与市场活动的关联关系列表
     * @param isCreateTransaction   是否创建交易的标识
     * @param transaction           交易
     * @param transactionRemarkList 交易备注信息列表
     * @param clueId                线索id
     */
    void saveConvert(Customer customer, Contacts contacts, List<CustomerRemark> customerRemarkList,
                     List<ContactsRemark> contactsRemarkList, List<ContactsActivityRelation> relationList,
                     boolean isCreateTransaction, Transaction transaction,
                     List<TransactionRemark> transactionRemarkList, String clueId);

}
