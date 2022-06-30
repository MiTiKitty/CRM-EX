package com.itCat.crmEX.settings.mapper;

import com.itCat.crmEX.settings.domain.DictionaryType;

import java.util.List;
import java.util.Map;

public interface DictionaryTypeMapper {

    /**
     * 查找出所有的字典类型
     * @return
     */
    List<DictionaryType> selectAllDictionaryType();

    /**
     * 根据字典类型编码查找字典类型
     * @param code
     * @return
     */
    DictionaryType selectDictionaryTypeByCode(String code);

    /**
     * 插入一个新的字典类型数据
     * @param dictionaryType
     * @return
     */
    int insertNewDictionaryType(DictionaryType dictionaryType);

    /**
     * 根据旧的code修改字典类型
     * @param map
     * @return
     */
    int updateDictionaryTypeByCode(Map<String, Object> map);

    /**
     * 根据指定的code集合删除字典类型
     * @param codes
     * @return
     */
    int deleteDictionaryTypeByCodes(String[] codes);

}
