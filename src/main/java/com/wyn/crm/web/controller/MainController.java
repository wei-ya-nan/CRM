package com.wyn.crm.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/17
 */
@Controller
public class MainController {

    @RequestMapping("main/index.html")
    public String mainIndex(){
        return "workbench/main/index";
    }


}
