package com.itCat.crmEX.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/settings")
@Controller
public class SettingsIndexController {

    @RequestMapping("/index.do")
    public String index(){
        return "settings/index";
    }

}
