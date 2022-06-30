package com.itCat.crmEX.settings.service;

import com.itCat.crmEX.settings.domain.DictionaryType;

import java.util.List;
import java.util.Map;

public interface DictionaryTypeService {

    List<DictionaryType> queryAllDictionaryType();

    DictionaryType queryDictionaryTypeByCode(String code);

    int saveNewDictionaryType(DictionaryType dictionaryType);

    int editDictionaryTypeByCode(Map<String, Object> map);

    void removeDictionaryTypeByCodes(String[] codes);
}
