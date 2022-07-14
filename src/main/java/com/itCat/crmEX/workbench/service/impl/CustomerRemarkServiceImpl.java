package com.itCat.crmEX.workbench.service.impl;

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
    public int saveCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.insertCustomerRemark(customerRemark);
    }
}
