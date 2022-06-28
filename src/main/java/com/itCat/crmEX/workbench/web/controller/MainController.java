package com.itCat.crmEX.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/workbench/main")
@Controller
public class MainController {

    @RequestMapping("/index.do")
    public String index(){
        return "workbench/main/index";
    }

}
