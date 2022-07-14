package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {

    /**
     * 根据查询条件分页查询市场活动
     *
     * @param map
     * @return
     */
    List<Activity> selectActivityByCondition(Map<String, Object> map);

    /**
     * 根据查询条件查询所有市场活动
     *
     * @param map
     * @return
     */
    List<Activity> selectAllActivityByCondition(Map<String, Object> map);

    /**
     * 根据查询条件查询所有市场活动
     *
     * @return
     */
    List<Activity> selectAllActivity();

    /**
     * 根据市场活动id集合查找市场活动信息
     *
     * @param ids
     * @return
     */
    List<Activity> selectActivityByIds(String[] ids);

    /**
     * 根据市场活动id查找市场活动信息
     *
     * @param id
     * @return
     */
    Activity selectActivityById(String id);

    /**
     * 根据市场活动id查找市场活动明细信息
     *
     * @param id
     * @return
     */
    Activity selectActivityForDetailById(String id);

    /**
     * 根据线索id查找该线索所关联的市场活动信息
     *
     * @param clueId
     * @return
     */
    List<Activity> selectActivityForClueRelationByClueId(String clueId);

    /**
     * 根据市场活动名称模糊查询还未与线索相关联的市场活动信息
     *
     * @param map
     * @return
     */
    List<Activity> selectActivityForClueByName(Map<String, Object> map);

    /**
     * 根据市场活动名称模糊查询已与线索相关联的市场活动信息
     *
     * @param map
     * @return
     */
    List<Activity> selectActivityForClueConvertByName(Map<String, Object> map);

    /**
     * 根据查询条件查询符合的市场活动总条数
     *
     * @param map
     * @return
     */
    int selectActivityCountByCondition(Map<String, Object> map);

    /**
     * 批量插入多条市场活动
     *
     * @param activityList
     * @return
     */
    int insertActivities(List<Activity> activityList);

    /**
     * 插入一条市场活动数据
     *
     * @param activity
     * @return
     */
    int insertActivity(Activity activity);

    /**
     * 根据市场活动id修改市场活动数据信息
     *
     * @param activity
     * @return
     */
    int updateActivityById(Activity activity);

    /**
     * 根据市场活动id集合删除指定的市场活动信息
     *
     * @param ids
     * @return
     */
    int deleteActivityByIds(String[] ids);

}
