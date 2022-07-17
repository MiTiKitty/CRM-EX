package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.Customer;
import com.itCat.crmEX.workbench.mapper.CustomerMapper;
import com.itCat.crmEX.workbench.mapper.CustomerRemarkMapper;
import com.itCat.crmEX.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Override
    public List<Customer> queryCustomerByCondition(Map<String, Object> map) {
        return customerMapper.selectCustomerByCondition(map);
    }

    @Override
    public int queryCustomerCountByCondition(Map<String, Object> map) {
        return customerMapper.selectCustomerCountByCondition(map);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public Customer queryCustomerForDetailById(String id) {
        return customerMapper.selectCustomerForDetailById(id);
    }

    @Override
    public List<Customer> queryCustomerByName(String name) {
        return customerMapper.selectCustomerByName(name);
    }

    @Override
    public int saveCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    @Override
    public int editCustomerById(Customer customer) {
        return customerMapper.updateCustomerById(customer);
    }

    @Override
    public void removeCustomerByIds(String[] ids) {
        customerRemarkMapper.deleteCustomerByCustomerIds(ids);
        customerMapper.deleteCustomerByIds(ids);
    }
}
