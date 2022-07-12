package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    /**
     * 根据市场活动id查找其下的所有备注信息
     * @param activityId
     * @return
     */
    List<ActivityRemark> queryAllActivityRemarkByActivityId(String activityId);

    /**
     * 插入一条市场活动备注信息
     * @param activityRemark
     * @return
     */
    int saveActivityRemark(ActivityRemark activityRemark);

    /**
     * 根据市场活动备注id修改该市场活动备注信息
     * @param activityRemark
     * @return
     */
    int editActivityRemarkById(ActivityRemark activityRemark);
    
    /**
     * 根据市场活动备注id删除该市场活动备注信息
     * @param id
     * @return
     */
    int removeActivityRemarkById(String id);

    /**
     * 根据市场活动id，删除该市场活动下的所有市场活动备注信息
     * @param activityId
     * @return
     */
    int removeActivityRemarkByActivityId(String activityId);

    /**
     * 根据市场活动id集合，删除这些市场活动下的所有市场活动备注信息
     * @param activityIds
     * @return
     */
    int removeActivityRemarkByActivityIds(String[] activityIds);
    
}
