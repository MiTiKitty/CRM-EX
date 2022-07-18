package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.workbench.domain.TransactionRemark;

import java.util.List;

public interface TransactionRemarkService {

    List<TransactionRemark> queryAllTransactionByTransactionId(String transactionId);

    int saveTransactionRemark(TransactionRemark transactionRemark);

    int editTransactionRemarkById(TransactionRemark transactionRemark);

    int removeTransactionRemarkById(String id);

}
