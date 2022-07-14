package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {

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

}
