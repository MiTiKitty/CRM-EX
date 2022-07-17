package com.itCat.crmEX.commons.constants;

/**
 * 常量类
 */
public class Constants {

    /**
     * 存储在session域中当前登录的用户的键值
     */
    public static final String SESSION_USER = "sessionUser";

    /**
     * 返回处理结果状态码——表示处理请求失败
     */
    public static final String RESULT_FAIL_CODE = "0";

    /**
     * 返回处理结果状态码——表示处理请求成功
     */
    public static final String RESULT_SUCCESS_CODE = "1";

    /**
     * 日期格式，年-月-日
     */
    public static final String DATE_FORMAT = "yyyy-MM-dd";

    /**
     * 具体时间格式，年-月-日 时:分:秒
     */
    public static final String DATETIME_FORMAT = "yyyy-MM-dd hh:mm:ss";

    /**
     * 未修改过代码：0
     */
    public static final String NOT_EDIT = "0";

    /**
     * 已修改过代码：1
     */
    public static final String HAVE_EDIT = "1";

    /**
     * 字典类型code常量类
     */
    public static class DictionaryCode {

        /**
         * 交易类型
         */
        public static final String TRANSACTION_TYPE = "transactionType";

        /**
         * 阶段
         */
        public static final String STAGE = "stage";

        /**
         * 来源
         */
        public static final String SOURCE = "source";

        /**
         * 性别
         */
        public static final String SEX = "sex";

        /**
         * 回访状态
         */
        public static final String RETURN_STATE = "returnState";

        /**
         * 回访优先级
         */
        public static final String RETURN_PRIORITY = "returnPriority";

        /**
         * 市场活动类型
         */
        public static final String MARKET_ACTIVITY_TYPE = "marketActivityType";

        /**
         * 市场活动状态
         */
        public static final String MARKET_ACTIVITY_STATUS = "marketActivityStatus";

        /**
         * 行业
         */
        public static final String INDUSTRY = "industry";

        /**
         * 等级
         */
        public static final String GRADE = "grade";

        /**
         * 线索状态
         */
        public static final String CLUE_STATE = "clueState";

        /**
         * 称呼
         */
        public static final String APPELLATION = "appellation";
    }
}
