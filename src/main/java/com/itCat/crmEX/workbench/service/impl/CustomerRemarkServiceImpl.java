package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.workbench.domain.CustomerRemark;
import com.itCat.crmEX.workbench.mapper.CustomerRemarkMapper;
import com.itCat.crmEX.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("customerRemarkService")
public class CustomerRemarkServiceImpl implements CustomerRemarkService {

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Override
    public List<CustomerRemark> queryAllCustomerRemarkByCustomerId(String customerId) {
        List<CustomerRemark> customerRemarkList = customerRemarkMapper.selectAllCustomerRemarkByCustomerId(customerId);
        for (CustomerRemark remark : customerRemarkList) {
            if (Constants.NOT_EDIT.equals(remark.getEditFlag())){
                remark.setShowPerson(remark.getNotePerson());
                remark.setShowTime(remark.getNoteTime());
            }else {
                remark.setShowPerson(remark.getEditPerson());
                remark.setShowTime(remark.getEditTime());
            }
        }
        return customerRemarkList;
    }

    @Override
    public int saveCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.insertCustomerRemark(customerRemark);
    }

    @Override
    public int editCustomerRemarkById(CustomerRemark customerRemark) {
        return customerRemarkMapper.updateCustomerRemarkById(customerRemark);
    }

    @Override
    public int removeCustomerRemarkById(String id) {
        return customerRemarkMapper.deleteCustomerRemarkById(id);
    }
}
