package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.ClueRemark;
import com.itCat.crmEX.workbench.mapper.ClueRemarkMapper;
import com.itCat.crmEX.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("clueRemarkService")
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryClueRemarkByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkByClueId(clueId);
    }

    @Override
    public List<ClueRemark> queryClueRemarkForConvertByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkForConvertByClueId(clueId);
    }

    @Override
    public int saveClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertClueRemark(clueRemark);
    }

    @Override
    public int editClueRemarkById(ClueRemark clueRemark) {
        return clueRemarkMapper.updateClueRemarkById(clueRemark);
    }

    @Override
    public int removeClueRemarkById(String id) {
        return clueRemarkMapper.deleteClueRemarkById(id);
    }

    @Override
    public int removeClueRemarkByClueIds(String[] clueIds) {
        return clueRemarkMapper.deleteClueRemarkByClueIds(clueIds);
    }
}
