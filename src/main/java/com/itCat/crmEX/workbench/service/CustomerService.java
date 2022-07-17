package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    /**
     * 条件分页查询客户信息
     *
     * @param map
     * @return
     */
    List<Customer> queryCustomerByCondition(Map<String, Object> map);

    /**
     * 按条件查询符合条件的客户总条数
     *
     * @param map
     * @return
     */
    int queryCustomerCountByCondition(Map<String, Object> map);

    /**
     * 根据客户id查找客户信息
     *
     * @param id
     * @return
     */
    Customer queryCustomerById(String id);

    /**
     * 根据客户id查找该客户的明细信息
     *
     * @param id
     * @return
     */
    Customer queryCustomerForDetailById(String id);

    /**
     * 根据客户名称模糊查找客户
     *
     * @param name
     * @return
     */
    List<Customer> queryCustomerByName(String name);

    /**
     * 插入一条新的客户信息
     *
     * @param customer
     * @return
     */
    int saveCustomer(Customer customer);

    /**
     * 根据客户id修改客户信息
     *
     * @param customer
     * @return
     */
    int editCustomerById(Customer customer);

    /**
     * 根据客户id集合删除对应的客户信息
     *
     * @param ids
     */
    void removeCustomerByIds(String[] ids);

}
