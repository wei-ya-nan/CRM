package com.wyn.crm.web.controller;

import com.wyn.crm.entity.User;
import com.wyn.crm.service.api.UserService;
import com.wyn.crm.service.impl.UserServiceImpl;
import com.wyn.crm.utils.CrmConstant;
import com.wyn.crm.utils.ResultEntity;
import com.wyn.crm.web.exception.LoginException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/16
 */
@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/workbench/index.html")
    public String workbenchIndex(){
        return "workbench/index";
    }





    @RequestMapping("/index.html")
    public String index() {
        return "settings/qx/user/login";
    }


    @ResponseBody
    @RequestMapping("user/login.json")
    public ResultEntity<String> checkLogin(@RequestParam("loginAct") String loginAct,
                                           @RequestParam("password") String password,
                                           @RequestParam("isRemPwd") String isRemPwd,
                                           HttpSession session) {

        User users = userService.getAdminByLoginAcct(loginAct, password);
        System.out.println(isRemPwd);
        if(users == null){
            return ResultEntity.failed(CrmConstant.ACCOUNT_PASSWORD_INCORRECT);
        }
        if("true".equals(isRemPwd)){

            session.setAttribute("user", users);
        }
        return ResultEntity.successWithData();
    }



}
