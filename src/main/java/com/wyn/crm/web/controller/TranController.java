package com.wyn.crm.web.controller;

import com.wyn.crm.entity.*;
import com.wyn.crm.mapper.ContactsMapper;
import com.wyn.crm.service.api.*;
import com.wyn.crm.utils.ResultEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/26
 */
@Controller
public class TranController {
    @Autowired
    private ActivityService activityService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private UserService userService;

    @Autowired
    private CustomerService customerService;



    @RequestMapping("/transaction/index.html")
    public String DivIndex(Model model) {
        //调用service层方法，查询动态数据
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        model.addAttribute("stageList", stageList);
        model.addAttribute("transactionTypeList", transactionTypeList);
        model.addAttribute("sourceList", sourceList);
        return "workbench/transaction/index";
    }

    @RequestMapping("/transaction/save.html")
    public String saveTran(Model model){
        List<User> users = userService.getAllUsers();

        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        model.addAttribute("stageList", stageList);
        model.addAttribute("transactionTypeList", transactionTypeList);
        model.addAttribute("sourceList", sourceList);
        model.addAttribute("users",users);
        return "workbench/transaction/save";
    }

    @ResponseBody
    @RequestMapping("/transaction/contacts/query.json")
    public ResultEntity<List<Contacts>> queryContacts(@RequestParam("fullname") String fullname){
        List<Contacts> contactsList = new ArrayList<Contacts>();
        if(fullname != ""|| fullname!=null){
             contactsList = contactsService.getContactsForLikeName(fullname);
        }
        return ResultEntity.successWithData(contactsList);
    }

    @ResponseBody
    @RequestMapping("/transaction/activity/query.json")
    public ResultEntity<List<Activity>> queryActivity(@RequestParam("name") String name){
        List<Activity> list = new ArrayList<Activity>();
        if(name!=""|| name!=null){
            list = activityService.getActivityByNameLike(name);
        }
        System.out.println(name);
        System.out.println(list.toString());
        return ResultEntity.successWithData(list);
    }

    @ResponseBody
    @RequestMapping("/transaction/queryCustomer/auto.json")
    public ResultEntity<List<String>> queryCustomerAutoName(String customerName){
        System.out.println(customerName);
        // 调用service方法通过模糊查询返回客户customer 的名字集合
        List<String> list = customerService.queryNameByLikeForAuto(customerName);
        System.out.println(list.toString());
        return ResultEntity.successWithData(list);
    }

    @ResponseBody
    @RequestMapping("/transaction/createTran/add.json")
    public ResultEntity<String> createTran(Tran tran){
        return ResultEntity.successWithData();

    }



}
