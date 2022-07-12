package com.itCat.crmEX.settings.service.impl;

import com.itCat.crmEX.settings.domain.DictionaryValue;
import com.itCat.crmEX.settings.mapper.DictionaryValueMapper;
import com.itCat.crmEX.settings.service.DictionaryValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("dictionaryValueService")
public class DictionaryValueServiceImpl implements DictionaryValueService {

    @Autowired
    private DictionaryValueMapper dictionaryValueMapper;

    @Override
    public List<DictionaryValue> queryAllDictionaryValue() {
        return dictionaryValueMapper.selectAllDictionaryValue();
    }

    @Override
    public DictionaryValue queryDictionaryValueByTypeCodeAndValue(Map<String, Object> map) {
        return dictionaryValueMapper.selectDictionaryValueByTypeCodeAndValue(map);
    }

    @Override
    public DictionaryValue queryDictionaryValueById(String id) {
        return dictionaryValueMapper.selectDictionaryValueById(id);
    }

    @Override
    public List<DictionaryValue> queryDictionaryValueByTypeCode(String typeCode) {
        return dictionaryValueMapper.selectDictionaryValueByTypeCode(typeCode);
    }

    @Override
    public int saveNewDictionaryValue(DictionaryValue dictionaryValue) {
        return dictionaryValueMapper.insertNewDictionaryValue(dictionaryValue);
    }

    @Override
    public int editDictionaryValue(DictionaryValue dictionaryValue) {
        return dictionaryValueMapper.updateDictionaryValue(dictionaryValue);
    }

    @Override
    public int removeDictionaryValueByIds(String[] ids) {
        return dictionaryValueMapper.deleteDictionaryValueByIds(ids);
    }

    @Override
    public int removeDictionaryValueByTypeCodes(String[] typeCodes) {
        return dictionaryValueMapper.deleteDictionaryValueByTypeCodes(typeCodes);
    }
}
