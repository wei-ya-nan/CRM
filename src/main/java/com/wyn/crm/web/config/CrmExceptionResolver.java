package com.wyn.crm.web.config;

import com.google.gson.Gson;
import com.wyn.crm.utils.CrmUtil;
import com.wyn.crm.utils.ResultEntity;
import com.wyn.crm.web.exception.LoginException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/16
 */
@ControllerAdvice
public class CrmExceptionResolver {


    @ExceptionHandler(value = LoginException.class)
    public ModelAndView resolverLoginFailedException(LoginException exception, HttpServletRequest request,
                                                     HttpServletResponse response) throws IOException {
        String viewName = "settings/qx/user/login";
        return commonResolver(viewName, exception, request, response);

    }


    private ModelAndView commonResolver(String viewName, Exception exception, HttpServletRequest request,
                                        HttpServletResponse response) throws IOException {

        // 1.判断当前请求类型
        boolean judgeResult = CrmUtil.judgeRequestType(request);

        // 2.如果是Ajax请求
        if (judgeResult) {

            // 3.创建ResultEntity对象
            ResultEntity<Object> resultEntity = ResultEntity.failed(exception.getMessage());

            // 4.创建Gson对象
            Gson gson = new Gson();

            // 5.将ResultEntity对象转换为JSON字符串
            String json = gson.toJson(resultEntity);

            // 6.将JSON字符串作为响应体返回给浏览器
            response.getWriter().write(json);

            // 7.由于上面已经通过原生的response对象返回了响应，所以不提供ModelAndView对象
            return null;
        }

        // 8.如果不是Ajax请求则创建ModelAndView对象
        ModelAndView modelAndView = new ModelAndView();

        // 9.将Exception对象存入模型
        modelAndView.addObject("exception", exception);

        // 10.设置对应的视图名称
        modelAndView.setViewName(viewName);

        // 11.返回modelAndView对象
        return modelAndView;
    }
}
