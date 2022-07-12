package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {

    /**
     * 根据市场活动id查找其下的所有备注信息
     * @param activityId
     * @return
     */
    List<ActivityRemark> selectAllActivityRemarkByActivityId(String activityId);

    /**
     * 插入一条市场活动备注信息
     * @param activityRemark
     * @return
     */
    int insertActivityRemark(ActivityRemark activityRemark);

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
    int deleteActivityRemarkById(String id);

    /**
     * 根据市场活动id，删除该市场活动下的所有市场活动备注信息
     * @param activityId
     * @return
     */
    int deleteActivityRemarkByActivityId(String activityId);

    /**
     * 根据市场活动id集合，删除这些市场活动下的所有市场活动备注信息
     * @param activityIds
     * @return
     */
    int deleteActivityRemarkByActivityIds(String[] activityIds);

}
