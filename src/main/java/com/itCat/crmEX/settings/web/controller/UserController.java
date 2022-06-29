package com.itCat.crmEX.settings.web.controller;

import com.alibaba.druid.util.Base64;
import com.github.pagehelper.PageHelper;
import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.commons.utils.CreateValidateCode;
import com.itCat.crmEX.commons.utils.DateUtils;
import com.itCat.crmEX.commons.utils.UUIDUtils;
import com.itCat.crmEX.settings.domain.User;
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

    @RequestMapping("/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }

    /**
     * 获取验证码
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
        }catch (IOException e){
            e.printStackTrace();
        }
    }

    /**
     * 用户根据用户名和密码进行登录操作
     * @param username
     * @param password
     * @param isRemPwd
     * @return
     */
    @RequestMapping("/login.do")
    @ResponseBody
    public Object login(String username, String password, String checkCode, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session){
        ResultObject resultObject = new ResultObject();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("username", username);
        map.put("password", password);
        String code = (String) session.getAttribute(CreateValidateCode.CHECK_CODE_SERVER);
        if (!checkCode.equals(code)){
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("验证码错误！");
        }else {
            try {
                User user = userService.queryUserByUsernameAndPassword(map);
                if (user != null){
                    String now = DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT);
                    if (user.getExpireTime() != null && now.compareTo(user.getExpireTime()) > 0){
                        resultObject.setCode(Constants.RESULT_FAIL_CODE);
                        resultObject.setMessage("账户已过期，请联系管理员");
                    }else if ("0".equals(user.getLockStatus())){
                        resultObject.setCode(Constants.RESULT_FAIL_CODE);
                        resultObject.setMessage("账户被锁定，请联系管理员");
                    }else if (user.getAllowIps() != null && !user.getAllowIps().contains(request.getRemoteAddr())){
                        resultObject.setCode(Constants.RESULT_FAIL_CODE);
                        resultObject.setMessage("账户ip受限，请联系管理员");
                    }else {
                        resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                        if ("true".equals(isRemPwd)){
                            setRemUsernameAndPassword(response, username, password, 24 * 60 * 60, 24 * 60 * 60);
                        }else {
                            setRemUsernameAndPassword(response, "", "", 0, 0);
                        }
                        session.setAttribute(Constants.SESSION_USER, user);
                    }
                }else {
                    resultObject.setCode(Constants.RESULT_FAIL_CODE);
                    resultObject.setMessage("用户名或密码错误");
                }
            }catch (Exception e) {
                e.printStackTrace();
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        }
        return resultObject;
    }

    /**
     * 实现记住密码功能
     * @param response
     * @param username
     * @param password
     * @param maxAgeUserName
     * @param maxAgePassword
     */
    private void setRemUsernameAndPassword(HttpServletResponse response, String username, String password, int maxAgeUserName, int maxAgePassword){
        Cookie usernameCookie = new Cookie("username", username);
        Cookie passwordCookie = new Cookie("password", password);
        usernameCookie.setMaxAge(maxAgeUserName);
        passwordCookie.setMaxAge(maxAgePassword);
        response.addCookie(usernameCookie);
        response.addCookie(passwordCookie);
    }

    /**
     * 根据当前用户的id修改密码
     * @param username
     * @param password
     * @param id
     * @param response
     * @return
     */
    @RequestMapping("/editUserPasswordById.do")
    @ResponseBody
    public Object editUserPasswordById(String username, String password, String id, HttpServletResponse response){
        ResultObject resultObject = new ResultObject();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("password", password);
        map.put("id", id);
        try {
            int result = userService.editUserPasswordById(map);
            if (result > 0){
                resultObject.setCode(Constants.RESULT_SUCCESS_CODE);
                setRemUsernameAndPassword(response, username, "", 24 * 60 * 60, 0);
            }else {
                resultObject.setCode(Constants.RESULT_FAIL_CODE);
                resultObject.setMessage("系统繁忙中，请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            resultObject.setCode(Constants.RESULT_FAIL_CODE);
            resultObject.setMessage("系统繁忙中，请稍后重试...");
        }
        return resultObject;
    }

    /**
     * 用户退出系统
     * @param response
     * @param session
     * @return
     */
    @RequestMapping("/exit.do")
    public String exit(HttpServletResponse response, HttpSession session){
        setRemUsernameAndPassword(response, "", "", 0, 0);
        session.invalidate();
        return "redirect:/";
    }

    @RequestMapping("/index.do")
    public String index(){
        return "settings/qx/user/index";
    }

    /**
     * 创建一个新用户
     * @param user
     * @param session
     * @return
     */
    @RequestMapping("/createNewUser.do")
    @ResponseBody
    public Object createNewUser(User user, HttpSession session){
        ResultObject resultObject = new ResultObject();
        User sessionUser = (User) session.getAttribute(Constants.SESSION_USER);
        user.setId(UUIDUtils.getUUID());
        user.setCreateBy(sessionUser.getId());
        user.setCreateTime(DateUtils.formatDate(new Date(), Constants.DATETIME_FORMAT));
        return resultObject;
    }

}
