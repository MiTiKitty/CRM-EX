package com.itCat.crmEX.settings.service;

import com.itCat.crmEX.settings.domain.DictionaryValue;

import java.util.List;
import java.util.Map;

public interface DictionaryValueService {

    List<DictionaryValue> queryAllDictionaryValue();

    DictionaryValue queryDictionaryValueByTypeCodeAndValue(Map<String, Object> map);

    DictionaryValue queryDictionaryValueById(String id);

    List<DictionaryValue> queryDictionaryValueByTypeCode(String typeCode);

    int saveNewDictionaryValue(DictionaryValue dictionaryValue);

    int editDictionaryValue(DictionaryValue dictionaryValue);

    int removeDictionaryValueByIds(String[] ids);

    int removeDictionaryValueByTypeCodes(String[] typeCodes);
}
