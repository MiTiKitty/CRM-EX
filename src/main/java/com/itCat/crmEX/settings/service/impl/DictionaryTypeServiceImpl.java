package com.itCat.crmEX.settings.service.impl;

import com.itCat.crmEX.settings.domain.DictionaryType;
import com.itCat.crmEX.settings.mapper.DictionaryTypeMapper;
import com.itCat.crmEX.settings.mapper.DictionaryValueMapper;
import com.itCat.crmEX.settings.service.DictionaryTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("dictionaryTypeService")
public class DictionaryTypeServiceImpl implements DictionaryTypeService {

    @Autowired
    private DictionaryTypeMapper dictionaryTypeMapper;

    @Autowired
    private DictionaryValueMapper dictionaryValueMapper;

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
    public void editDictionaryTypeByCode(Map<String, Object> map) {
        String oldCode = (String) map.get("oldCode");
        String newCode = (String) map.get("newCode");
        DictionaryType dictionaryType = dictionaryTypeMapper.selectDictionaryTypeByCode(oldCode);
        dictionaryType.setCode(newCode);
        dictionaryTypeMapper.insertNewDictionaryType(dictionaryType);
        dictionaryValueMapper.updateDictionaryValueTypeCodeByTypeCode(map);
        dictionaryTypeMapper.deleteDictionaryTypeByCodes(new String[]{oldCode});
    }

    @Override
    public void removeDictionaryTypeByCodes(String[] codes) {
        dictionaryValueMapper.deleteDictionaryValueByTypeCodes(codes);
        dictionaryTypeMapper.deleteDictionaryTypeByCodes(codes);
    }
}
