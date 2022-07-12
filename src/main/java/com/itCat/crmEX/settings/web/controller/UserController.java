package com.itCat.crmEX.settings.web.controller;

import com.alibaba.druid.util.Base64;
import com.github.pagehelper.PageHelper;
import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.commons.utils.CreateValidateCode;
import com.itCat.crmEX.commons.utils.DateUtils;
import com.itCat.crmEX.commons.utils.UUIDUtils;
import com.itCat.crmEX.settings.domain.Department;
import com.itCat.crmEX.settings.domain.Role;
import com.itCat.crmEX.settings.domain.User;
import com.itCat.crmEX.settings.domain.UserRoleRelation;
import com.itCat.crmEX.settings.service.PermissionService;
import com.itCat.crmEX.settings.service.RoleService;
import com.itCat.crmEX.settings.service.UserRoleRelationService;
import com.itCat.crmEX.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.imageio.ImageIO;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.*;

@Controller
@RequestMapping("/settings/qx/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private RoleService roleService;

    @Autowired
    private PermissionService permissionService;

    @Autowired
    private UserRoleRelationService userRoleRelationService;

    @RequestMapping("/toLogin.do")
    public String toLogin() {
        return "settings/qx/user/login";
    }

    /**
     * 获取验证码
     *
     * @return
     */
    @RequestMapping("/getCheckCode.do")
    public void getCheckCode(String timeTemp, HttpServletResponse response, HttpSession session) {
        try {
            CreateValidateCode createValidateCode = new CreateValidateCode();
            String code = createValidateCode.getCode();
            BufferedImage image = createValidateCode.getImage();
            session.setAttribute(CreateValidateCode.CHECK_CODE_SERVER, code);
            ImageIO.write(image, "png", response.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 用户根据用户名和密码进行登录操作
     *
     * @param username
     * @param password
     * @param isRemPwd
     * @return
     */
    @RequestMapping("/login.do")
    @ResponseBody
    public Object login(String username, String password, String checkCode, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("username", username);
        map.put("password", password);
        String code = (String) session.getAttribute(CreateValidateCode.CHECK_CODE_SERVER);
        if (!checkCode.equals(code)) {
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("验证码错误！");
        } else {
            try {
                User user = userService.queryUserByUsernameAndPassword(map);
                if (user != null) {
                    String now = DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT);
                    if (user.getExpireTime() != null && !user.getExpireTime().equals("") && now.compareTo(user.getExpireTime()) > 0) {
                        resultObject.setCode(Constants.RESULT_FAIL_CODE);
                        resultObject.setMessage("账户已过期，请联系管理员");
                    } else if ("0".equals(user.getLockStatus())) {
                        resultObject.setCode(Constants.RESULT_FAIL_CODE);
                        resultObject.setMessage("账户被锁定，请联系管理员");
                    } else if (user.getAllowIps() != null && !user.getAllowIps().equals("") && !user.getAllowIps().contains(request.getRemoteAddr())) {
                        resultObject.setCode(Constants.RESULT_FAIL_CODE);
                        resultObject.setMessage("账户ip受限，请联系管理员");
                    } else {
                        resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                        if ("true".equals(isRemPwd)) {
                            setRemUsernameAndPassword(response, username, password, 24 * 60 * 60, 24 * 60 * 60);
                        } else {
                            setRemUsernameAndPassword(response, "", "", 0, 0);
                        }
                        session.setAttribute(Constants.SESSION_USER, user);
                    }
                } else {
                    resultObject.setCode(Constants.RESULT_FAIL_CODE);
                    resultObject.setMessage("用户名或密码错误");
                }
            } catch (Exception e) {
                e.printStackTrace();
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        }
        return resultObject;
    }

    /**
     * 实现记住密码功能
     *
     * @param response
     * @param username
     * @param password
     * @param maxAgeUserName
     * @param maxAgePassword
     */
    private void setRemUsernameAndPassword(HttpServletResponse response, String username, String password, int maxAgeUserName, int maxAgePassword) {
        Cookie usernameCookie = new Cookie("username", username);
        Cookie passwordCookie = new Cookie("password", password);
        usernameCookie.setMaxAge(maxAgeUserName);
        passwordCookie.setMaxAge(maxAgePassword);
        response.addCookie(usernameCookie);
        response.addCookie(passwordCookie);
    }

    /**
     * 根据当前用户的id修改密码
     *
     * @param username
     * @param password
     * @param id
     * @param response
     * @return
     */
    @RequestMapping("/editUserPasswordById.do")
    @ResponseBody
    public Object editUserPasswordById(String username, String password, String id, HttpServletResponse response) {
        ResultObject resultObject = new ResultObject();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("password", password);
        map.put("id", id);
        try {
            int result = userService.editUserPasswordById(map);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                setRemUsernameAndPassword(response, username, "", 24 * 60 * 60, 0);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 用户退出系统
     *
     * @param response
     * @param session
     * @return
     */
    @RequestMapping("/exit.do")
    public String exit(HttpServletResponse response, HttpSession session) {
        setRemUsernameAndPassword(response, "", "", 0, 0);
        session.invalidate();
        return "redirect:/";
    }

    @RequestMapping("/index.do")
    public String index() {
        return "settings/qx/user/index";
    }

    @RequestMapping("/detail.do")
    public String detail(String id, HttpServletRequest request){
        request.setAttribute("userId", id);
        return "settings/qx/user/detail";
    }

    /**
     * 根据用户id查找用户具体信息
     * @param id
     * @return
     */
    @RequestMapping("/queryUserDetailById.do")
    @ResponseBody
    public Object queryUserDetailById(String id){
        return userService.queryUserForDetailById(id);
    }

    /**
     * 根据用户id查找用户未分配和已分配的角色信息列表
     * @param userId
     * @return
     */
    @RequestMapping("/queryUserRole.do")
    @ResponseBody
    public Object queryUserRole(String userId){
        Map<String, Object> map = new HashMap<>();
        List<Role> allotRoleList = roleService.queryAllAllotRoleForUserByUserId(userId);
        List<Role> annulRoleList = roleService.queryAllAnnulRoleForUserByUserId(userId);
        map.put("allotRoleList", allotRoleList);
        map.put("annulRoleList", annulRoleList);
        return map;
    }

    /**
     * 根据用户id查找用户许可信息
     * @param userId
     * @return
     */
    @RequestMapping("/queryUserPermission.do")
    @ResponseBody
    public Object queryUserPermission(String userId){
        return permissionService.queryPermissionForUserByUserId(userId);
    }

    /**
     * 创建一个新的用户
     * @param username
     * @param name
     * @param password
     * @param email
     * @param phone
     * @param expireTime
     * @param lockStatus
     * @param allowIps
     * @param departmentId
     * @param session
     * @return
     */
    @RequestMapping(value = {"/createUser.do", "/createNewUser.do"})
    @ResponseBody
    public Object createNewUser(String username, String name, String password, String email,
                                String phone, String expireTime, String lockStatus, String allowIps,
                                String departmentId, HttpSession session) {
        ResultObject resultObject = new ResultObject();
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        User user = new User();
        setUserField(user, username, name, password, email, phone, expireTime, lockStatus, allowIps, departmentId);
        user.setId(UUIDUtils.getUUID());
        user.setCreateBy(sessionUser.getId());
        user.setCreateTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = userService.saveNewUser(user);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 分页查询用户信息
     *
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/queryUsersByCondition.do")
    @ResponseBody
    public Object queryUsersByCondition(String userName, String departmentName,
                                        String lockStatus, String startTime, String endTime,
                                        String pageNo, String pageSize) {
        Map<String, Object> resultObject = new HashMap<>();
        Map<String, Object> map = new HashMap<>();
        int pageNum = Integer.parseInt(pageNo);
        int size = Integer.parseInt(pageSize);
        map.put("userName", userName);
        map.put("departmentName", departmentName);
        map.put("lockStatus", lockStatus);
        map.put("startTime", startTime);
        map.put("endTime", endTime);
        map.put("beginPage", (pageNum - 1) * size);
        map.put("pageSize", size);
        List<User> userList = userService.queryUsersByCondition(map);
        int totalRows = userService.queryAllUserCountByCondition(map);
        resultObject.put("userList", userList);
        resultObject.put("totalRows", totalRows);
        return resultObject;
    }

    /**
     * 修改用户账号状态
     * @param id
     * @param lockStatus
     * @return
     */
    @RequestMapping("/editUserLockStatusById.do")
    @ResponseBody
    public Object editUserLockStatusById(String id, String lockStatus){
        ResultObject resultObject = new ResultObject();
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("lockStatus", lockStatus);
        try {
            int result = userService.editUserLockStatusById(map);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        } catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 询问该用户名是否可以使用
     *
     * @param username
     * @return
     */
    @RequestMapping(value = {"/existUserByUsername.do", "/queryUserIsExistByUsername.do"})
    @ResponseBody
    public Object queryUserIsExistByUsername(String username) {
        int result = userService.queryUserCountByUsername(username);
        return result;
    }

    /**
     * 根据用户id修改用户信息
     * @param id
     * @param username
     * @param name
     * @param password
     * @param email
     * @param phone
     * @param expireTime
     * @param lockStatus
     * @param allowIps
     * @param departmentId
     * @param session
     * @return
     */
    @RequestMapping("/editUser.do")
    @ResponseBody
    public Object editUser(String id, String username, String name, String password, String email,
                           String phone, String expireTime, String lockStatus, String allowIps,
                           String departmentId, HttpSession session){
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        ResultObject resultObject = new ResultObject();
        User user = new User();
        setUserField(user, username, name, password, email, phone, expireTime, lockStatus, allowIps, departmentId);
        user.setId(id);
        user.setEditBy(sessionUser.getId());
        user.setEditTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        try {
            int result = userService.editUserById(user);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                resultObject.setData(user);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 给用户分配角色
     * @param userId
     * @param roleIds
     * @return
     */
    @RequestMapping("/allotRoleForUser.do")
    @ResponseBody
    public Object allotRoleForUser(String userId, String[] roleIds){
        ResultObject resultObject = new ResultObject();
        List<UserRoleRelation> userRoleRelationList = new LinkedList<>();
        UserRoleRelation userRoleRelation = null;
        for (String roleId : roleIds) {
            userRoleRelation = new UserRoleRelation();
            userRoleRelation.setId(UUIDUtils.getUUID());
            userRoleRelation.setUserId(userId);
            userRoleRelation.setRoleId(roleId);
            userRoleRelationList.add(userRoleRelation);
        }
        try {
            int result = userRoleRelationService.saveUserRoleRelation(userRoleRelationList);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 撤销该用户的角色
     * @param userId
     * @param roleIds
     * @return
     */
    @RequestMapping("/annulRoleForUser.do")
    @ResponseBody
    public Object annulRoleForUser(String userId, String[] roleIds){
        ResultObject resultObject = new ResultObject();
        Map<String, Object> map = new HashMap<>();
        map.put("userId", userId);
        map.put("roleIds", roleIds);
        try {
            int result = userRoleRelationService.removeUserRoleRelationByUserIdAndRoleIds(map);
            if (result > 0) {
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
            } else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 根据用户id集合删除用户信息
     * @param id
     * @return
     */
    @RequestMapping("/removeUsersById.do")
    @ResponseBody
    public Object removeUsersById(String[] id){
        ResultObject resultObject = new ResultObject();
        try {
            userService.removeUsersById(id);
            resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
        } catch (Exception e) {
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 设置user的属性，降低代码冗余度
     * @param user
     * @param username
     * @param name
     * @param password
     * @param email
     * @param phone
     * @param expireTime
     * @param lockStatus
     * @param allowIps
     * @param departmentId
     */
    private void setUserField(User user, String username, String name, String password, String email, String phone,
                              String expireTime, String lockStatus, String allowIps, String departmentId) {
        Department department = new Department();
        department.setId(departmentId);
        user.setUsername(username);
        user.setName(name);
        user.setPassword(password);
        user.setEmail(email);
        user.setPhone(phone);
        user.setExpireTime(expireTime);
        user.setLockStatus(lockStatus);
        user.setAllowIps(allowIps);
        user.setDepartment(department);
    }

}
