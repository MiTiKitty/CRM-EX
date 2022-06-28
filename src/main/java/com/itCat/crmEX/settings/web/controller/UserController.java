package com.itCat.crmEX.settings.web.controller;

import com.alibaba.druid.util.Base64;
import com.github.pagehelper.PageHelper;
import com.itCat.crmEX.commons.constants.Constants;
import com.itCat.crmEX.commons.domain.ResultObject;
import com.itCat.crmEX.commons.utils.CreateValidateCode;
import com.itCat.crmEX.commons.utils.DateUtils;
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
import java.io.OutputStream;
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
                        resultObject.setCode(Constants.RESULT_FAIL_CODE);
                        if ("true".equals(isRemPwd)){
                            setRemUsernameAndPassword(response, username, password, 24 * 60 * 60);
                        }else {
                            setRemUsernameAndPassword(response, "", "", 0);
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
     * @param maxAge
     */
    private void setRemUsernameAndPassword(HttpServletResponse response, String username, String password, int maxAge){
        Cookie usernameCookie = new Cookie("username", username);
        Cookie passwordCookie = new Cookie("password", password);
        usernameCookie.setMaxAge(maxAge);
        passwordCookie.setMaxAge(maxAge);
        response.addCookie(usernameCookie);
        response.addCookie(passwordCookie);
    }

}
