package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.Customer;

public interface CustomerMapper {

    /**
     * 插入一条新的客户信息
     * @param customer
     * @return
     */
    int insertCustomer(Customer customer);

}
