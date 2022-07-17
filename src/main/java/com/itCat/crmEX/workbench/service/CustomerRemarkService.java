package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {

    /**
     * 根据客户id查找所有的客户备注信息
     * @param customerId
     * @return
     */
    List<CustomerRemark> queryAllCustomerRemarkByCustomerId(String customerId);

    int saveCustomerRemark(CustomerRemark customerRemark);

    /**
     * 根据客户备注信息的id修改备注信息
     * @param customerRemark
     * @return
     */
    int editCustomerRemarkById(CustomerRemark customerRemark);

    /**
     * 根据备注id删除备注信息
     * @param id
     * @return
     */
    int removeCustomerRemarkById(String id);

}
