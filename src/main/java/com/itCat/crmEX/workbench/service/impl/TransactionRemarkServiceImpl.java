package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.workbench.domain.TransactionRemark;
import com.itCat.crmEX.workbench.mapper.TransactionRemarkMapper;
import com.itCat.crmEX.workbench.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("transactionRemarkService")
public class TransactionRemarkServiceImpl implements TransactionRemarkService {

    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    @Override
    public List<TransactionRemark> queryAllTransactionByTransactionId(String transactionId) {
        List<TransactionRemark> remarkList = transactionRemarkMapper.selectAllTransactionByTransactionId(transactionId);
        for (TransactionRemark remark : remarkList) {
            if (Constants.NOT_EDIT.equals(remark.getEditFlag())){
                remark.setShowPerson(remark.getNotePerson());
                remark.setShowTime(remark.getNoteTime());
            }else {
                remark.setShowPerson(remark.getEditPerson());
                remark.setShowTime(remark.getEditTime());
            }
        }
        return remarkList;
    }

    @Override
    public int saveTransactionRemark(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.insertTransactionRemark(transactionRemark);
    }

    @Override
    public int editTransactionRemarkById(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.updateTransactionRemarkById(transactionRemark);
    }

    @Override
    public int removeTransactionRemarkById(String id) {
        return transactionRemarkMapper.deleteTransactionRemarkById(id);
    }

}
