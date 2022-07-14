package com.itCat.crmEX.workbench.service.impl;

import com.itCat.crmEX.workbench.domain.ClueActivityRelation;
import com.itCat.crmEX.workbench.mapper.ClueActivityRelationMapper;
import com.itCat.crmEX.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("clueActivityRelationService")
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Override
    public List<ClueActivityRelation> queryClueActivityRelationByClueId(String clueId) {
        return clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);
    }

    @Override
    public int saveClueActivityRelation(List<ClueActivityRelation> list) {
        return clueActivityRelationMapper.insertClueActivityRelation(list);
    }

    @Override
    public int removeClueActivityRelationByClueIdAndActivityId(Map<String, Object> map) {
        return clueActivityRelationMapper.deleteClueActivityRelationByClueIdAndActivityId(map);
    }
}
