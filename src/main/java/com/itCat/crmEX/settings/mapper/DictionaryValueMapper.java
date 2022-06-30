package com.itCat.crmEX.settings.mapper;

import com.itCat.crmEX.settings.domain.DictionaryValue;

import java.util.List;
import java.util.Map;

public interface DictionaryValueMapper {

    /**
     * 查找所有的字典值
     * @return
     */
    List<DictionaryValue> selectAllDictionaryValue();

    /**
     * 根据字典类型和字典值查找字典值
     * @param map
     * @return
     */
    DictionaryValue selectDictionaryValueByTypeCodeAndValue(Map<String, Object> map);

    /**
     * 根据字典值id查找字典值
     * @param id
     * @return
     */
    DictionaryValue selectDictionaryValueById(String id);

    /**
     * 插入一个新的字典值
     * @param dictionaryValue
     * @return
     */
    int insertNewDictionaryValue(DictionaryValue dictionaryValue);

    /**
     * 根据字典值id修改字典值
     * @param dictionaryValue
     * @return
     */
    int updateDictionaryValue(DictionaryValue dictionaryValue);

    /**
     * 根据旧的字典类型编码所属划分到新的字典类型编码中
     * @param map
     * @return
     */
    int updateDictionaryValueTypeCodeByTypeCode(Map<String, Object> map);

    /**
     * 根据指定字典值id集合删除字典值
     * @param ids
     * @return
     */
    int deleteDictionaryValueByIds(String[] ids);

    /**
     * 根据指定的字典类型编码集合，删除所有属于此字典类型的字典值
     * @param codes
     * @return
     */
    int deleteDictionaryValueByTypeCodes(String[] codes);
}
