package com.wyn.crm.utils;

import javax.servlet.http.HttpServletRequest;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import java.util.Date;
import java.util.UUID;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/16
 */
public class CrmUtil {




    public static String getUUId(){
        return UUID.randomUUID().toString().replace("-", "");
    }

    public static String md5(String source) {

        if (source == null || source.length() == 0) {
            throw new RuntimeException("密码不能为空");
        }
        String algorithm = "md5";

        try {
            MessageDigest instance = MessageDigest.getInstance(algorithm);
            // 获取明文字符串的字节数组
            byte[] bytes = source.getBytes();
            // 指定加密
            byte[] digest = instance.digest(bytes);
            int signum = 1;
            BigInteger bigInteger = new BigInteger(signum, digest);

            // 按照十六进制将bigInteger 转为字符串
            int radix = 16;
            String encode = bigInteger.toString(radix);
            return encode;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static boolean judgeRequestType(HttpServletRequest request) {

        // 1.获取请求消息头
        String acceptHeader = request.getHeader("Accept");
        String xRequestHeader = request.getHeader("X-Requested-With");

        // 2.判断
        return (acceptHeader != null && acceptHeader.contains("application/json"))
                ||
                (xRequestHeader != null && xRequestHeader.equals("XMLHttpRequest"));
    }
}
