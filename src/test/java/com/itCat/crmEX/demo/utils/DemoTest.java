package com.itCat.crmEX.demo.utils;

import org.junit.Test;

public class DemoTest {

    @Test
    public void test(){
        String name = "张三";
        name = name.replace("", "%");
        System.out.println(name);
    }

}
