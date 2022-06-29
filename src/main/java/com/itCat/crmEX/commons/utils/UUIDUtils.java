package com.itCat.crmEX.commons.utils;

import java.util.UUID;

/**
 * UUID工具类
 */
public class UUIDUtils {

    /**
     * 获得一个UUID
     * @return
     */
    public static String getUUID(){
        return UUID.randomUUID().toString().replaceAll("-", "");
    }

}
