package com.wyn.crm.web.controller;

import com.github.pagehelper.PageHelper;
import com.wyn.crm.entity.Contacts;
import com.wyn.crm.entity.ContactsRemark;
import com.wyn.crm.entity.DicValue;
import com.wyn.crm.entity.User;
import com.wyn.crm.mapper.ContactsRemarkMapper;
import com.wyn.crm.service.api.*;
import com.wyn.crm.utils.CrmConstant;
import com.wyn.crm.utils.DateUtils;
import com.wyn.crm.utils.ResultEntity;
import com.wyn.crm.utils.UUIDUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/5/1
 */
@Controller
public class ContactsController {
    @Autowired
    private ContactsService contactsService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private UserService userService;

    @Autowired
    private TranService tranService;

    @ResponseBody
    @RequestMapping("/contacts/remark/add.json")
    public ResultEntity<ContactsRemark> addContactsRemark(ContactsRemark contactsRemark, HttpSession session){
        User user = (User) session.getAttribute("user");
        contactsRemark.setCreateBy(user.getId());
        contactsRemark.setId(UUIDUtils.getUUID());
        contactsRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        contactsRemark.setEditFlag(CrmConstant.REMARK_EDIT_FLAG_NO);
        contactsService.addContactsRemark(contactsRemark);

        return ResultEntity.successWithData(contactsRemark);
    }

    @ResponseBody
    @RequestMapping("/contacts/remark/update.json")
    public ResultEntity<ContactsRemark> updateContactsRemark(ContactsRemark contactsRemark, HttpSession session){
        User user = (User) session.getAttribute("user");
        contactsRemark.setEditFlag(CrmConstant.REMARK_EDIT_FLAG_YES);
        contactsRemark.setEditBy(user.getId());
        contactsRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        contactsService.updateRemark(contactsRemark);
        return ResultEntity.successWithData(contactsRemark);
    }

    @ResponseBody
    @RequestMapping("/contacts/detail/remark/delete.json")
    public ResultEntity<String> deleteRemark(String id){
        contactsService.deleteContactsRemark(id);
        return ResultEntity.successWithData();
    }


    @RequestMapping("/contacts/save.html")
    public String saveTran(String customerId, Model model){
        List<User> users = userService.getAllUsers();
        System.out.println(customerId);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        model.addAttribute("stageList", stageList);
        model.addAttribute("transactionTypeList", transactionTypeList);
        model.addAttribute("sourceList", sourceList);
        model.addAttribute("users", users);
        model.addAttribute("customerId", customerId);
        return "workbench/contacts/save";
    }




}

