package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.Transaction;

public interface TransactionMapper {

    /**
     * 插入一条新的交易信息
     * @param transaction
     * @return
     */
    int insertTransaction(Transaction transaction);

}
