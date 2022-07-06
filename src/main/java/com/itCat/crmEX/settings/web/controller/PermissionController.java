package com.itCat.crmEX.settings.web.controller;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.commons.utils.UUIDUtils;
import com.itCat.crmEX.settings.domain.Permission;
import com.itCat.crmEX.settings.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/settings/qx/permission")
public class PermissionController {

    @Autowired
    private PermissionService permissionService;

    @RequestMapping("/index.do")
    public String index(){
        return "settings/qx/permission/index";
    }

    /**
     * 查询所有的许可信息
     * @return
     */
    @RequestMapping("/queryAllPermission.do")
    @ResponseBody
    public Object queryAllPermission(){
        ResultObject resultObject = new ResultObject();
        List<Permission> permissionList = permissionService.queryAllPermission();
        resultObject.setData(permissionList);
        return resultObject;
    }

    /**
     * 根据许可id查找许可的详细信息
     * @param id
     * @return
     */
    @RequestMapping(value = {"/queryPerDetailById.do", "/queryPermissionForDetailById.do"})
    @ResponseBody
    public Object queryPermissionForDetailById(String id){
        ResultObject resultObject = new ResultObject();
        Permission permission = permissionService.queryPermissionForDetailById(id);
        resultObject.setData(permission);
        return resultObject;
    }

    /**
     * 保存新创建的许可信息
     * @param pid
     * @param name
     * @param moduleUrl
     * @param operUrl
     * @param orderNo
     * @return
     */
    @RequestMapping("/createPermission.do")
    @ResponseBody
    public Object createPermission(String pid, String name, String moduleUrl, String operUrl, String orderNo){
        ResultObject resultObject = new ResultObject();
        Permission permission = new Permission(UUIDUtils.getUUID(), pid, name, moduleUrl, operUrl, Long.parseLong(orderNo));
        try {
            int result = permissionService.savePermission(permission);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                resultObject.setData(permission);
            }else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 修改许可
     * @param id
     * @param name
     * @param moduleUrl
     * @param operUrl
     * @param orderNo
     * @return
     */
    @RequestMapping(value = {"/editPerById.do", "/editPermissionById.do"})
    @ResponseBody
    public Object editPermissionById(String id, String name, String moduleUrl, String operUrl, String orderNo){
        ResultObject resultObject = new ResultObject();
        Permission permission = new Permission(id, null, name, moduleUrl, operUrl, Long.parseLong(orderNo));
        try {
            int result = permissionService.editPermissionById(permission);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                resultObject.setData(permission);
            }else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据许可id删除许可信息
     * @param id
     * @return
     */
    @RequestMapping(value = {"/removePerById.do", "/removePermissionById.do"})
    @ResponseBody
    public Object removePermissionById(String id){
        ResultObject resultObject = new ResultObject();
        try {
            permissionService.removePermissionById(id);
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
        }catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

}
