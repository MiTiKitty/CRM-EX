package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.Customer;
import com.itCat.crmEX.workbench.mapper.CustomerMapper;
import com.itCat.crmEX.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public int saveCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }
}
