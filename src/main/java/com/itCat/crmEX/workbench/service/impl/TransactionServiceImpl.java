package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.Transaction;
import com.itCat.crmEX.workbench.mapper.TransactionMapper;
import com.itCat.crmEX.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("transactionService")
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TransactionMapper transactionMapper;

    @Override
    public int saveTransaction(Transaction transaction) {
        return transactionMapper.insertTransaction(transaction);
    }
}
