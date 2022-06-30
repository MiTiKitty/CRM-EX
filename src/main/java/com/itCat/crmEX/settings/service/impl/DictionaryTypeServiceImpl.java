package com.itCat.crmEX.settings.service.impl;

import com.itCat.crmEX.settings.domain.DictionaryType;
import com.itCat.crmEX.settings.mapper.DictionaryTypeMapper;
import com.itCat.crmEX.settings.service.DictionaryTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("dictionaryTypeService")
public class DictionaryTypeServiceImpl implements DictionaryTypeService {

    @Autowired
    private DictionaryTypeMapper dictionaryTypeMapper;

    @Override
    public List<DictionaryType> queryAllDictionaryType() {
        return dictionaryTypeMapper.selectAllDictionaryType();
    }

    @Override
    public DictionaryType queryDictionaryTypeByCode(String code) {
        return dictionaryTypeMapper.selectDictionaryTypeByCode(code);
    }

    @Override
    public int saveNewDictionaryType(DictionaryType dictionaryType) {
        return dictionaryTypeMapper.insertNewDictionaryType(dictionaryType);
    }

    @Override
    public int editDictionaryTypeByCode(Map<String, Object> map) {
        return dictionaryTypeMapper.updateDictionaryTypeByCode(map);
    }

    @Override
    public void removeDictionaryTypeByCodes(String[] codes) {
        dictionaryTypeMapper.deleteDictionaryTypeByCodes(codes);
    }
}
