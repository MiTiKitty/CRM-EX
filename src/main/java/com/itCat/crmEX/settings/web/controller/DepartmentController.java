package com.itCat.crmEX.settings.web.controller;

import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.commons.utils.UUIDUtils;
import com.itCat.crmEX.settings.domain.Department;
import com.itCat.crmEX.settings.domain.User;
import com.itCat.crmEX.settings.service.DepartmentService;
import com.itCat.crmEX.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/settings/department")
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @Autowired
    private UserService userService;

    @RequestMapping("/index.do")
    public String index(HttpServletRequest request){
        List<Department> departmentList = departmentService.queryAllDepartment();
        List<User> userList = userService.queryAllUserForOption();
        request.setAttribute("departmentList", departmentList);
        request.setAttribute("userList", userList);
        return "settings/department/index";
    }

    @RequestMapping("/detail.do")
    public String detail(String id, HttpServletRequest request){
        Department department = departmentService.queryDepartmentById(id);
        List<User> userList = userService.queryAllUserForOption();
        request.setAttribute("userList", userList);
        request.setAttribute("department", department);
        return "settings/department/detail";
    }

    /**
     * 创建一个新的部门
     * @param number
     * @param name
     * @param managerId
     * @param phone
     * @param description
     * @return
     */
    @RequestMapping(value = {"/createDept.do", "/createDepartment.do"})
    @ResponseBody
    public Object createDepartment(String number, String name, String managerId, String phone, String description){
        ResultObject resultObject = new ResultObject();
        User manager = new User();
        manager.setId(managerId);
        Department department = new Department(UUIDUtils.getUUID(), number, name, manager, description, phone);
        try {
            int result = departmentService.saveDepartment(department);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                resultObject.setData(department);
            }else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        }catch (Exception e){
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据部门编号查找部门
     * @param number
     * @return
     */
    @RequestMapping(value = {"/queryDeptByNumber.do", "/queryDepartmentByNumber.do"})
    @ResponseBody
    public Object queryDepartmentByNumber(String number){
        ResultObject resultObject = new ResultObject();
        Department department = departmentService.queryDepartmentByNumber(number);
        if (department == null){
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }else {
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            resultObject.setData(department);
        }
        return resultObject;
    }

    /**
     * 根据部门id修改部门信息
     * @param id
     * @param number
     * @param name
     * @param managerId
     * @param phone
     * @param description
     * @return
     */
    @RequestMapping(value = {"editDeptById.do", "editDepartmentById.do"})
    @ResponseBody
    public Object editDepartmentById(String id, String number, String name, String managerId, String phone, String description){
        ResultObject resultObject = new ResultObject();
        User manager = new User();
        manager.setId(managerId);
        Department department = new Department(id, number, name, manager, description, phone);
        try {
            int result = departmentService.editDepartmentById(department);
            if (result > 0){
                department = departmentService.queryDepartmentById(id);
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                resultObject.setData(department);
            }else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙，请稍后重试...");
            }
        }catch (Exception e){
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据指定部门id集合删除部门信息
     * @param id
     * @return
     */
    @RequestMapping(value = {"/removeDeptByIds.do", "/removeDepartmentByIds.do"})
    @ResponseBody
    public Object removeDepartmentByIds(String[] id){
        ResultObject resultObject = new ResultObject();
        try {
            departmentService.removeDepartmentByIds(id);
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
        }catch (Exception e){
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙，请稍后重试...");
        }
        return resultObject;
    }

}
