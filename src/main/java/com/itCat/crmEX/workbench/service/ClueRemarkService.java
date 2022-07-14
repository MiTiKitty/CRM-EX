package com.itCat.crmEX.workbench.service;

import com.itCat.crmEX.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    /**
     * 根据线索id查找线索备注信息
     *
     * @param clueId
     * @return
     */
    List<ClueRemark> queryClueRemarkByClueId(String clueId);

    /**
     * 根据线索id查找详细的线索备注信息
     *
     * @param clueId
     * @return
     */
    List<ClueRemark> queryClueRemarkForConvertByClueId(String clueId);

    /**
     * 插入一条新的线索备注信息
     *
     * @param clueRemark
     * @return
     */
    int saveClueRemark(ClueRemark clueRemark);

    /**
     * 根据线索备注id修改该线索备注信息
     *
     * @param clueRemark
     * @return
     */
    int editClueRemarkById(ClueRemark clueRemark);

    /**
     * 根据线索备注id删除该条线索备注信息
     *
     * @param id
     * @return
     */
    int removeClueRemarkById(String id);

    /**
     * 根据提供的线索id集合删除线索备注信息
     *
     * @param clueIds
     * @return
     */
    int removeClueRemarkByClueIds(String[] clueIds);

}
