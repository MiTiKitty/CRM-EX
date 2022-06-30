package com.itCat.crmEX.settings.web.controller;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.settings.domain.DictionaryType;
import com.itCat.crmEX.settings.service.DictionaryTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/settings/dictionary/type")
public class DictionaryTypeController {

    @Autowired
    private DictionaryTypeService dictionaryTypeService;

    @RequestMapping("/index.do")
    public String index(HttpServletRequest request){
        List<DictionaryType> dictionaryTypeList = dictionaryTypeService.queryAllDictionaryType();
        request.setAttribute("dictionaryTypeList", dictionaryTypeList);
        return "settings/dictionary/type/index";
    }

    @RequestMapping("/create.do")
    public String create(){
        return "settings/dictionary/type/create";
    }

    @RequestMapping("/edit.do")
    public String edit(String code, HttpServletRequest request){
        DictionaryType type = dictionaryTypeService.queryDictionaryTypeByCode(code);
        request.setAttribute("type", type);
        return "settings/dictionary/type/edit";
    }

    /**
     * 根据字典类型编码查找字典类型
     * @param code
     * @return
     */
    @RequestMapping(value = {"checkDictionaryTypeByCode.do", "queryDictionaryTypeByCode.do"})
    @ResponseBody
    public Object queryDictionaryTypeByCode(String code){
        ResultObject resultObject = new ResultObject();
        DictionaryType dictionaryType = dictionaryTypeService.queryDictionaryTypeByCode(code);
        if (dictionaryType != null){
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            resultObject.setData(dictionaryType);
        }else {
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 创建新的字典类型
     * @param dictionaryType
     * @param request
     * @return
     */
    @RequestMapping("/createNewDictionaryType.do")
    @ResponseBody
    public Object createNewDictionary(DictionaryType dictionaryType, HttpServletRequest request){
        ResultObject resultObject = new ResultObject();
        try {
            int result = dictionaryTypeService.saveNewDictionaryType(dictionaryType);
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
     * 根据旧的code修改字典类型
     * @param oldCode
     * @param newCode
     * @param name
     * @param description
     * @return
     */
    @RequestMapping("/editDictionaryType.do")
    @ResponseBody
    public Object editDictionaryTypeByCode(String oldCode, String newCode, String name, String description){
        ResultObject resultObject = new ResultObject();
        Map<String, Object> map = new HashMap<>();
        map.put("oldCode", oldCode);
        map.put("newCode", newCode);
        map.put("name", name);
        map.put("description", description);
        try {
            dictionaryTypeService.editDictionaryTypeByCode(map);
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
        } catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据指定的code集合删除字典类型
     * @param code
     * @return
     */
    @RequestMapping("/removeDictionaryType.do")
    @ResponseBody
    public Object removeDictionaryByCodes(String[] code){
        ResultObject resultObject = new ResultObject();
        try {
            dictionaryTypeService.removeDictionaryTypeByCodes(code);
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
        } catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

}
