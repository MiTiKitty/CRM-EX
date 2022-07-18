package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.Transaction;
import com.itCat.crmEX.workbench.mapper.TransactionMapper;
import com.itCat.crmEX.workbench.mapper.TransactionRemarkMapper;
import com.itCat.crmEX.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("transactionService")
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TransactionMapper transactionMapper;

    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    @Override
    public List<Transaction> queryTransactionByCondition(Map<String, Object> map) {
        return transactionMapper.selectTransactionByCondition(map);
    }

    @Override
    public int queryTransactionCountByCondition(Map<String, Object> map) {
        return transactionMapper.selectTransactionCountByCondition(map);
    }

    @Override
    public Transaction queryTransactionById(String id) {
        return transactionMapper.selectTransactionById(id);
    }

    @Override
    public Transaction queryTransactionForDetailById(String id) {
        return transactionMapper.selectTransactionForDetailById(id);
    }

    @Override
    public List<Transaction> queryTransactionByCustomerId(String customerId) {
        return transactionMapper.selectTransactionByCustomerId(customerId);
    }

    @Override
    public List<Transaction> queryTransactionByContactsId(String contactsId) {
        return transactionMapper.selectTransactionByContactsId(contactsId);
    }

    @Override
    public int saveTransaction(Transaction transaction) {
        return transactionMapper.insertTransaction(transaction);
    }

    @Override
    public int editTransactionById(Transaction transaction) {
        return transactionMapper.updateTransactionById(transaction);
    }

    @Override
    public void removeTransactionByIds(String[] ids) {
        transactionRemarkMapper.deleteTransactionRemarkByTransactionIds(ids);
        transactionMapper.deleteTransactionByIds(ids);
    }
}
