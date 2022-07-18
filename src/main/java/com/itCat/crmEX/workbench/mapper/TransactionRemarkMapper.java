package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.TransactionRemark;

import java.util.List;

public interface TransactionRemarkMapper {

    /**
     * 查找致电给交易的所有备注信息
     *
     * @param transactionId
     * @return
     */
    List<TransactionRemark> selectAllTransactionByTransactionId(String transactionId);

    int insertTransactionRemark(TransactionRemark transactionRemark);

    int insertTransactionRemarks(List<TransactionRemark> remarkList);

    int updateTransactionRemarkById(TransactionRemark transactionRemark);

    int deleteTransactionRemarkById(String id);

    int deleteTransactionRemarkByTransactionIds(String[] transactionIds);

}
