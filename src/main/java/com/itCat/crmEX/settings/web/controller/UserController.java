package com.itCat.crmEX.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/settings/qx/user")
public class UserController {

    @RequestMapping("/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }

}
