package com.itCat.crmEX.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/settings/qx")
public class QXIndexController {

    @RequestMapping("/index.do")
    public String index(){
        return "settings/qx/index";
    }

}
