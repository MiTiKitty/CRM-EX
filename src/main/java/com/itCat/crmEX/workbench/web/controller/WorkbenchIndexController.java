package com.itCat.crmEX.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/workbench")
@Controller
public class WorkbenchIndexController {

    @RequestMapping("/index.do")
    public String index(){
        return "workbench/index";
    }

}
