package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    /**
     * 根据查询条件分页查询市场活动
     *
     * @param map: name:
     *             owner:
     *             startDate:
     *             endDate:
     *             pageBegin:
     *             pageSize:
     * @return
     */
    List<Activity> queryActivityByCondition(Map<String, Object> map);

    /**
     * 根据查询条件查询所有市场活动
     *
     * @param map
     * @return
     */
    List<Activity> queryAllActivityByCondition(Map<String, Object> map);

    /**
     * 根据查询条件查询所有市场活动
     *
     * @return
     */
    List<Activity> queryAllActivity();

    /**
     * 根据市场活动id集合查找市场活动信息
     *
     * @param ids
     * @return
     */
    List<Activity> queryActivityByIds(String[] ids);

    /**
     * 根据查询条件查询符合的市场活动总条数
     *
     * @param map name:
     *            owner:
     *            startDate:
     *            endDate:
     * @return
     */
    int queryActivityCountByCondition(Map<String, Object> map);

    /**
     * 根据市场活动id查找市场活动信息
     *
     * @param id
     * @return
     */
    Activity queryActivityById(String id);

    /**
     * 根据市场活动id查找市场活动明细信息
     *
     * @param id
     * @return
     */
    Activity queryActivityForDetailById(String id);

    /**
     * 批量导入市场活动
     *
     * @param activityList
     * @return
     */
    int importActivities(List<Activity> activityList);

    /**
     * 保存一条新的市场活动数据
     *
     * @param activity
     * @return
     */
    int saveActivity(Activity activity);

    /**
     * 根据市场活动id修改市场活动数据信息
     *
     * @param activity
     * @return
     */
    int editActivityById(Activity activity);

    /**
     * 根据市场活动id集合删除指定的市场活动信息
     *
     * @param ids
     */
    void removeActivityByIds(String[] ids);
}
