package com.itCat.crmEX.settings.web.controller;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.commons.utils.UUIDUtils;
import com.itCat.crmEX.settings.domain.DictionaryType;
import com.itCat.crmEX.settings.domain.DictionaryValue;
import com.itCat.crmEX.settings.service.DictionaryTypeService;
import com.itCat.crmEX.settings.service.DictionaryValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/settings/dictionary/value")
public class DictionaryValueController {

    @Autowired
    private DictionaryTypeService dictionaryTypeService;

    @Autowired
    private DictionaryValueService dictionaryValueService;

    @RequestMapping("/index.do")
    public String index(HttpServletRequest request){
        List<DictionaryValue> dictionaryValueList = dictionaryValueService.queryAllDictionaryValue();
        request.setAttribute("dictionaryValueList", dictionaryValueList);
        return "settings/dictionary/value/index";
    }

    @RequestMapping("/create.do")
    public String create(HttpServletRequest request){
        List<DictionaryType> dictionaryTypeList = dictionaryTypeService.queryAllDictionaryType();
        request.setAttribute("dictionaryTypeList", dictionaryTypeList);
        return "settings/dictionary/value/create";
    }

    @RequestMapping("/edit.do")
    public String edit(String id, HttpServletRequest request){
        DictionaryValue dictionaryValue = dictionaryValueService.queryDictionaryValueById(id);
        DictionaryType dictionaryType = dictionaryTypeService.queryDictionaryTypeByCode(dictionaryValue.getTypeCode());
        request.setAttribute("dictionaryValue", dictionaryValue);
        request.setAttribute("dictionaryType", dictionaryType);
        return "settings/dictionary/value/edit";
    }

    /**
     * 根据字典类型和字典值查找字典值
     * @param typeCode
     * @param value
     * @return
     */
    @RequestMapping(value = {"/checkDicValueByTypeCodeAndValue.do", "/queryDicValueByTypeCodeAndValue.do"})
    @ResponseBody
    public Object queryDictionaryValueByTypeCodeAndValue(String typeCode, String value){
        ResultObject resultObject = new ResultObject();
        Map<String, Object> map = new HashMap<>();
        map.put("typeCode", typeCode);
        map.put("value", value);
        DictionaryValue dictionaryValue = dictionaryValueService.queryDictionaryValueByTypeCodeAndValue(map);
        if (dictionaryValue == null){
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }else {
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            resultObject.setData(dictionaryValue);
        }
        return resultObject;
    }

    /**
     * 创建新的字典值
     * @param typeCode
     * @param value
     * @param text
     * @param orderNo
     * @return
     */
    @RequestMapping("/createDictionaryValue.do")
    @ResponseBody
    public Object createDictionaryValue(String typeCode, String value, String text, String orderNo){
        ResultObject resultObject = new ResultObject();
        DictionaryValue dictionaryValue = new DictionaryValue();
        dictionaryValue.setId(UUIDUtils.getUUID());
        dictionaryValue.setTypeCode(typeCode);
        dictionaryValue.setValue(value);
        dictionaryValue.setText(text);
        dictionaryValue.setOrderNo(Long.parseLong(orderNo));
        try {
            int result = dictionaryValueService.saveNewDictionaryValue(dictionaryValue);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            }else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据字典值id修改字典值
     * @param id
     * @param typeCode
     * @param value
     * @param text
     * @param orderNo
     * @return
     */
    @RequestMapping("/editDictionaryValue.do")
    @ResponseBody
    public Object editDictionaryValue(String id, String typeCode, String value, String text, String orderNo){
        ResultObject resultObject = new ResultObject();
        DictionaryValue dictionaryValue = new DictionaryValue();
        dictionaryValue.setId(id);
        dictionaryValue.setTypeCode(typeCode);
        dictionaryValue.setValue(value);
        dictionaryValue.setText(text);
        dictionaryValue.setOrderNo(Long.parseLong(orderNo));
        try {
            int result = dictionaryValueService.editDictionaryValue(dictionaryValue);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            }else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据指定id集合删除字典值
     * @param id
     * @return
     */
    @RequestMapping("/removeDictionaryValue.do")
    @ResponseBody
    public Object removeDictionaryValue(String[] id){
        ResultObject resultObject = new ResultObject();
        try {
            int result = dictionaryValueService.removeDictionaryValueByIds(id);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            }else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        } catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

}
