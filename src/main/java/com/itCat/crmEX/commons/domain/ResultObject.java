package com.itCat.crmEX.commons.domain;

/**
 * 结果处理返回类
 */
public class ResultObject {

    /**
     * 处理结果状态码
     */
    private String code;

    /**
     * 处理结果信息
     */
    private String message;

    /**
     * 附带的其他处理信息
     */
    private Object data;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}
