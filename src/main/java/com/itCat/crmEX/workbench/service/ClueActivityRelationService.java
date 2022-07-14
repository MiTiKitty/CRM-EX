package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationService {

    /**
     * 根据线索id查找已跟市场活动关联的关联关系列表
     *
     * @param clueId
     * @return
     */
    List<ClueActivityRelation> queryClueActivityRelationByClueId(String clueId);

    /**
     * 批量插入线索与市场活动的关联关系信息
     *
     * @param list
     * @return
     */
    int saveClueActivityRelation(List<ClueActivityRelation> list);

    /**
     * 根据线索id和市场活动id删除两者关联关系
     *
     * @param map
     * @return
     */
    int removeClueActivityRelationByClueIdAndActivityId(Map<String, Object> map);

}
