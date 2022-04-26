package com.wyn.crm.utils;


/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/16
 */
public class ResultEntity<T> {

    public static final String SUCCESS = "SUCCESS";
    public static final String FAILED = "FAILED";

    // 用来封装处理的请求是失败的还是成功的
    private String result;

    // 用来处理请求的信息
    private String message;

    // 要返回的数据
    private T data;

    // 请求成功的不需要返回数据的
    public static <Type> ResultEntity<Type> successWithData() {
        return new ResultEntity<Type>(SUCCESS, null, null);

    }

    // 请求成功的需要返回数据的
    public static <Type> ResultEntity<Type> successWithData(Type data) {
        return new ResultEntity<Type>(SUCCESS, null, data);
    }

    // 请求处理失败的需要返回错误信息
    public static<Type> ResultEntity<Type> failed(String message){
        return new ResultEntity<Type>(FAILED,message, null);
    }

    public ResultEntity() {
    }

    public ResultEntity(String result, String message, T data) {
        this.result = result;
        this.message = message;
        this.data = data;
    }

    public static String getSUCCESS() {
        return SUCCESS;
    }

    public static String getFAILED() {
        return FAILED;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    @Override
    public String toString() {
        return "ResultEntity{" +
                "result='" + result + '\'' +
                ", message='" + message + '\'' +
                ", data=" + data +
                '}';
    }

}
