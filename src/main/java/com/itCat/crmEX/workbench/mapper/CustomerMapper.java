package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {

    /**
     * 条件分页查询客户信息
     *
     * @param map
     * @return
     */
    List<Customer> selectCustomerByCondition(Map<String, Object> map);

    /**
     * 按条件查询符合条件的客户总条数
     *
     * @param map
     * @return
     */
    int selectCustomerCountByCondition(Map<String, Object> map);

    /**
     * 根据客户id查找客户信息
     *
     * @param id
     * @return
     */
    Customer selectCustomerById(String id);

    /**
     * 根据客户id查找该客户的明细信息
     *
     * @param id
     * @return
     */
    Customer selectCustomerForDetailById(String id);

    /**
     * 根据客户名称模糊查找客户
     *
     * @param name
     * @return
     */
    List<Customer> selectCustomerByName(String name);

    /**
     * 插入一条新的客户信息
     *
     * @param customer
     * @return
     */
    int insertCustomer(Customer customer);

    /**
     * 根据客户id修改客户信息
     *
     * @param customer
     * @return
     */
    int updateCustomerById(Customer customer);

    /**
     * 根据客户id集合删除对应的客户信息
     *
     * @param ids
     * @return
     */
    int deleteCustomerByIds(String[] ids);

}
