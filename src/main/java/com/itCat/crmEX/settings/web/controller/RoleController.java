package com.itCat.crmEX.settings.web.controller;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.commons.utils.UUIDUtils;
import com.itCat.crmEX.settings.domain.Permission;
import com.itCat.crmEX.settings.domain.Role;
import com.itCat.crmEX.settings.domain.RolePermissionRelation;
import com.itCat.crmEX.settings.service.RolePermissionRelationService;
import com.itCat.crmEX.settings.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/settings/qx/role")
public class RoleController {

    @Autowired
    private RoleService roleService;

    @Autowired
    private RolePermissionRelationService rolePermissionRelationService;

    @RequestMapping("/index.do")
    public String index(){
        return "settings/qx/role/index";
    }

    @RequestMapping("/detail.do")
    public String detail(String id, HttpServletRequest request){
        Role role = roleService.queryRoleById(id);
        request.setAttribute("role", role);
        return "settings/qx/role/detail";
    }

    /**
     * 分页查询所有角色信息
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/queryAllRoleByPage.do")
    @ResponseBody
    public Object queryAllRoleByPage(int pageNo, int pageSize){
        Map<String, Object> map = new HashMap<>();
        Map<String, Object> result = new HashMap<>();
        map.put("beginPage", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        List<Role> roleList = roleService.queryAllRoleByPage(map);
        int totalRows = roleService.queryAllRoleCount();
        result.put("roleList", roleList);
        result.put("totalRows", totalRows);
        return result;
    }

    /**
     * 根据角色id查找角色信息
     * @param id
     * @return
     */
    @RequestMapping("/queryRoleById.do")
    @ResponseBody
    public Object queryRoleById(String id){
        ResultObject resultObject = new ResultObject();
        Role role = roleService.queryRoleById(id);
        if (role != null){
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            resultObject.setData(role);
        }else {
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据角色code查找角色信息
     * @param code
     * @return
     */
    @RequestMapping("/queryRoleByCode.do")
    @ResponseBody
    public Object queryRoleByCode(String code){
        ResultObject resultObject = new ResultObject();
        Role role = roleService.queryRoleByCode(code);
        if (role != null){
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            resultObject.setData(role);
        }else {
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 创建一个新的角色
     * @param code
     * @param name
     * @param description
     * @return
     */
    @RequestMapping("/createRole.do")
    @ResponseBody
    public Object createRole(String code, String name, String description){
        ResultObject resultObject = new ResultObject();
        Role role = new Role(UUIDUtils.getUUID(), code, name, description);
        try{
            int result = roleService.saveRole(role);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
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
     * 根据指定的角色id集合删除角色
     * @param id
     * @return
     */
    @RequestMapping("/removeRoleByIds.do")
    @ResponseBody
    public Object removeRoleByIds(String[] id){
        ResultObject resultObject = new ResultObject();
        try{
            roleService.removeRoleByIds(id);
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
        }catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据角色id修改角色信息
     * @param id
     * @param code
     * @param name
     * @param description
     * @return
     */
    @RequestMapping("/editRole.do")
    @ResponseBody
    public Object editRole(String id, String code, String name, String description){
        ResultObject resultObject = new ResultObject();
        Role role = new Role(id, code, name, description);
        try{
            int result = roleService.editRole(role);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
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
     * 根据角色id查找相对应的权限
     * @param id
     * @return
     */
    @RequestMapping("/queryPermissionByRoleId.do")
    @ResponseBody
    public Object queryPermissionByRoleId(String id){
        List<Permission> permissionList = rolePermissionRelationService.queryPermissionByRoleId(id);
        return permissionList;
    }

    /**
     * 分配许可
     * @param roleId
     * @param permissionIds
     * @return
     */
    @RequestMapping("/assignPermission.do")
    @ResponseBody
    public Object assignPermission(String roleId, String[] permissionIds){
        ResultObject resultObject = new ResultObject();
        List<RolePermissionRelation> rolePermissionRelationList = new LinkedList<>();
        RolePermissionRelation rolePermissionRelation = null;
        for (String permissionId : permissionIds) {
            rolePermissionRelation = new RolePermissionRelation(UUIDUtils.getUUID(), roleId, permissionId);
            rolePermissionRelationList.add(rolePermissionRelation);
        }
        Map<String, Object> map = new HashMap<>();
        map.put("roleId", roleId);
        map.put("rolePermissionRelationList", rolePermissionRelationList);
        try{
            rolePermissionRelationService.saveRolePermissionRelation(map);
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            List<Permission> permissionList = rolePermissionRelationService.queryPermissionByRoleId(roleId);
            resultObject.setData(permissionList);
        }catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

}
