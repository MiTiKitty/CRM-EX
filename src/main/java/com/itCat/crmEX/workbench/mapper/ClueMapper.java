package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {

    /**
     * 根据查询条件分页查询线索
     *
     * @param map
     * @return
     */
    List<Clue> selectClueByCondition(Map<String, Object> map);

    /**
     * 根据查询条件查询符合线索总条数
     *
     * @param map
     * @return
     */
    int selectAllClueCountByCondition(Map<String, Object> map);

    /**
     * 根据线索id查找该线索信息
     *
     * @param id
     * @return
     */
    Clue selectClueById(String id);

    /**
     * 根据线索id查找线索明细信息
     *
     * @param id
     * @return
     */
    Clue selectClueForDetailById(String id);

    /**
     * 根据线索id为转换页面查找线索信息
     *
     * @param id
     * @return
     */
    Clue selectClueForConvertById(String id);

    /**
     * 插入一条新的线索信息
     *
     * @param clue
     * @return
     */
    int insertClue(Clue clue);

    /**
     * 根据线索id更新该线索信息
     *
     * @param clue
     * @return
     */
    int updateClueById(Clue clue);

    /**
     * 根据线索id删除线索信息
     *
     * @param id
     * @return
     */
    int deleteClueById(String id);

    /**
     * 根据线索id集合删除线索信息
     *
     * @param ids
     * @return
     */
    int deleteClueByIds(String[] ids);

}
