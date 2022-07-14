package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationMapper {

    /**
     * 根据线索id查找已跟市场活动关联的关联关系列表
     *
     * @param clueId
     * @return
     */
    List<ClueActivityRelation> selectClueActivityRelationByClueId(String clueId);

    /**
     * 批量插入线索与市场活动的关联关系信息
     *
     * @param list
     * @return
     */
    int insertClueActivityRelation(List<ClueActivityRelation> list);

    /**
     * 根据线索id和市场活动id删除两者关联关系
     *
     * @param map
     * @return
     */
    int deleteClueActivityRelationByClueIdAndActivityId(Map<String, Object> map);

    /**
     * 根据线索id，删除该线索与市场活动的关联关系
     *
     * @param clueId
     * @return
     */
    int deleteClueActivityRelationByClueId(String clueId);

    /**
     * 根据线索id集合，删除这些线索与市场活动的关联关系
     *
     * @param clueIds
     * @return
     */
    int deleteClueActivityRelationByClueIds(String[] clueIds);

    /**
     * 根据市场活动id集合，删除这些线索与市场活动的关联关系
     *
     * @param activityIds
     * @return
     */
    int deleteClueActivityRelationByActivityIds(String[] activityIds);

}
