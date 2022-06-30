package com.itCat.crmEX.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/settings/dictionary")
public class DictionaryIndexController {

    @RequestMapping("/index.do")
    public String index(){
        return "settings/dictionary/index";
    }

}
