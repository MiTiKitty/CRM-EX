package com.itCat.crmEX.workbench.mapper;

import com.itCat.crmEX.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {

    /**
     * 根据线索id查找线索备注信息
     *
     * @param clueId
     * @return
     */
    List<ClueRemark> selectClueRemarkByClueId(String clueId);

    /**
     * 根据线索id查找详细的线索备注信息
     *
     * @param clueId
     * @return
     */
    List<ClueRemark> selectClueRemarkForConvertByClueId(String clueId);

    /**
     * 插入一条新的线索备注信息
     *
     * @param clueRemark
     * @return
     */
    int insertClueRemark(ClueRemark clueRemark);

    /**
     * 根据线索备注id修改该线索备注信息
     *
     * @param clueRemark
     * @return
     */
    int updateClueRemarkById(ClueRemark clueRemark);

    /**
     * 根据线索备注id删除该条线索备注信息
     *
     * @param id
     * @return
     */
    int deleteClueRemarkById(String id);

    /**
     * 根据提供的线索id删除线索备注信息
     *
     * @param clueId
     * @return
     */
    int deleteClueRemarkByClueId(String clueId);

    /**
     * 根据提供的线索id集合删除线索备注信息
     *
     * @param clueIds
     * @return
     */
    int deleteClueRemarkByClueIds(String[] clueIds);

}
