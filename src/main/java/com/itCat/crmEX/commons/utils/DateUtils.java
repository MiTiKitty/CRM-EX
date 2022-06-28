package com.itCat.crmEX.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 处理时间格式的工具类
 */
public class DateUtils {

    /**
     * 根据日期，处理时间格式，返回相对应的字符串
     * @param date
     * @param format
     * @return
     */
    public static String formatDate(Date date, String format){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
        String dateStr = simpleDateFormat.format(date);
        return dateStr;
    }

    /**
     * 根据时间戳，处理时间格式，返回相对应的字符串
     * @param time
     * @param format
     * @return
     */
    public static String formatDate(long time, String format){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
        String dateStr = simpleDateFormat.format(new Date(time));
        return dateStr;
    }

}
