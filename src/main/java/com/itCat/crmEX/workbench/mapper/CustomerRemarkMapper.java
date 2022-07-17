package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {

    /**
     * 根据客户id查找所有的客户备注信息
     * @param customerId
     * @return
     */
    List<CustomerRemark> selectAllCustomerRemarkByCustomerId(String customerId);

    /**
     * 插入一条新的客户备注信息
     * @param customerRemark
     * @return
     */
    int insertCustomerRemark(CustomerRemark customerRemark);

    /**
     * 批量插入多条客户备注信息
     * @param remarkList
     * @return
     */
    int insertCustomerRemarks(List<CustomerRemark> remarkList);

    /**
     * 根据客户备注信息的id修改备注信息
     * @param customerRemark
     * @return
     */
    int updateCustomerRemarkById(CustomerRemark customerRemark);

    /**
     * 根据备注id删除备注信息
     * @param id
     * @return
     */
    int deleteCustomerRemarkById(String id);

    /**
     * 根据客户id集合删除该id集合上所有客户的备注信息
     * @param customerIds
     * @return
     */
    int deleteCustomerByCustomerIds(String[] customerIds);

}
