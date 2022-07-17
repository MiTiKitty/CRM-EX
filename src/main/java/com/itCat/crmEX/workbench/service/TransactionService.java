package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.workbench.domain.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionService {

    /**
     * 条件分页查询交易信息
     *
     * @param map
     * @return
     */
    List<Transaction> queryTransactionByCondition(Map<String, Object> map);

    /**
     * 查询符合条件的交易总条数
     *
     * @param map
     * @return
     */
    int queryTransactionCountByCondition(Map<String, Object> map);

    /**
     * 根据交易id查询交易信息
     *
     * @param id
     * @return
     */
    Transaction queryTransactionById(String id);

    /**
     * 根据交易id查找交易明细信息
     *
     * @param id
     * @return
     */
    Transaction queryTransactionForDetailById(String id);

    /**
     * 根据客户id查找交易信息
     *
     * @param customerId
     * @return
     */
    List<Transaction> queryTransactionByCustomerId(String customerId);

    /**
     * 根据联系人id查找交易信息
     *
     * @param contactsId
     * @return
     */
    List<Transaction> queryTransactionByContactsId(String contactsId);

    /**
     * 插入一条新的交易信息
     *
     * @param transaction
     * @return
     */
    int saveTransaction(Transaction transaction);

    /**
     * 根据交易id修改交易信息
     *
     * @param transaction
     * @return
     */
    int editTransactionById(Transaction transaction);

    /**
     * 根据交易id集合删除交易信息
     *
     * @param ids
     */
    void removeTransactionByIds(String[] ids);

}
