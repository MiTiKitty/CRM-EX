package com.itCat.crmEX.workbench.web.controller;

import com.itCat.crmEX.settings.service.DictionaryValueService;
import com.itCat.crmEX.settings.service.UserService;
import com.itCat.crmEX.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/workbench/transaction")
public class TransactionController {

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private UserService userService;

    @Autowired
    private DictionaryValueService dictionaryValueService;

    @RequestMapping("/index.do")
    public String index(HttpServletRequest request){

        return "workbench/transaction/index";
    }

    @RequestMapping("/create.do")
    public String create(HttpServletRequest request){

        return "workbench/transaction/create";
    }

    @RequestMapping("/edit.do")
    public String edit(String id, HttpServletRequest request){

        return "workbench/transaction/edit";
    }

    @RequestMapping("/detail.do")
    public String detail(String id, HttpServletRequest request){

        return "workbench/transaction/detail";
    }

}
