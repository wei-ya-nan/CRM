package com.wyn.crm.web.controller;

import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.*;
import com.wyn.crm.service.api.*;
import com.wyn.crm.utils.CrmConstant;
import com.wyn.crm.utils.DateUtils;
import com.wyn.crm.utils.ResultEntity;
import com.wyn.crm.utils.UUIDUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/28
 */
@Controller
public class CustomerController {
    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ClueActivityRelationService clueActivityRelationService;
    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private UserService userService;

    @Autowired
    private TranService tranService;

    @Autowired
    private ContactsService contactsService;


    @RequestMapping("/customer/index.html")
    public String index(Model model) {
        List<Customer> list = customerService.getAll();
        List<User> users = userService.getAllUsers();
        model.addAttribute("customers", list);
        model.addAttribute("users", users);
        return "workbench/customer/index";
    }

    @ResponseBody
    @RequestMapping("/customer/queryCondition/page.json")
    public ResultEntity<PageInfo<Customer>> page(@RequestParam(value = "name", defaultValue = "") String name,
                                                 @RequestParam(value = "owner", defaultValue = "") String owner,
                                                 @RequestParam(value = "phone", defaultValue = "") String phone,
                                                 @RequestParam(value = "website", defaultValue = "") String website,
                                                 @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
                                                 @RequestParam(value = "pageSize", defaultValue = "5") Integer pageSize) {

        PageInfo<Customer> pageInfo = customerService.queryPage(name, owner, phone, website, pageNum, pageSize);
        return ResultEntity.successWithData(pageInfo);
    }

    @ResponseBody
    @RequestMapping("/customer/add.json")
    public ResultEntity<String> addCut(Customer customer, HttpSession session) {
        User user = (User) session.getAttribute("user");
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        customer.setId(UUIDUtils.getUUID());
        customerService.saveCust(customer);

        return ResultEntity.successWithData();
    }

    @ResponseBody
    @RequestMapping("/customer/id/queryOne.json")
    public ResultEntity<Customer> queryOne(String id) {
        Customer customer = customerService.getOne(id);

        return ResultEntity.successWithData(customer);
    }


    @ResponseBody
    @RequestMapping("/customer/id/update.json")
    public ResultEntity<String> updateId(Customer customer, HttpSession session) {
        try {
            User user = (User) session.getAttribute("user");
            customer.setEditBy(user.getId());
            customer.setEditTime(DateUtils.formateDateTime(new Date()));
            customerService.updateCust(customer);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }
        return ResultEntity.successWithData();
    }


    @RequestMapping("/customer/detail.html")
    public String detailCut(String id, Model model) {
        Customer one = customerService.getConditionOne(id);
        List<CustomerRemark> remarkList = customerService.getCustomerRemark(id);
        List<Tran> tranList = tranService.getTranByCustomerId(id);
        List<User> allUsers = userService.getAllUsers();
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellation = dicValueService.queryDicValueByTypeCode("appellation");
        List<Contacts> contactsList = contactsService.getContactsByConId(id);
        model.addAttribute("appellation", appellation);
        model.addAttribute("source", source);
        model.addAttribute("users", allUsers);
        model.addAttribute("remarkList", remarkList);
        model.addAttribute("customer", one);
        model.addAttribute("tranList", tranList);
        model.addAttribute("contactsList", contactsList);
        return "workbench/customer/detail";
    }

    @ResponseBody
    @RequestMapping("/customer/remark/detail/add.json")
    public ResultEntity<CustomerRemark> addRemark(CustomerRemark customerRemark, HttpSession session) {
        User user = (User) session.getAttribute("user");
        customerRemark.setCreateBy(user.getId());
        customerRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        customerRemark.setId(UUIDUtils.getUUID());
        customerService.saveRemark(customerRemark);

        return ResultEntity.successWithData(customerRemark);
    }


    @ResponseBody
    @RequestMapping("/customer/remark/update.json")
    public ResultEntity<CustomerRemark> updateRemark(CustomerRemark customerRemark, HttpSession session) {

        User user = (User) session.getAttribute("user");
        customerRemark.setEditBy(user.getId());
        customerRemark.setEditTime(DateUtils.formateDateTime(new Date()));
        customerRemark.setEditFlag(CrmConstant.REMARK_EDIT_FLAG_YES);
        customerService.updateRemark(customerRemark);
        return ResultEntity.successWithData(customerRemark);
    }

    @ResponseBody
    @RequestMapping("/customer/detail/remark/delete.json")
    public ResultEntity<String> deleteRemark(String id) {
        customerService.deleteRemark(id);
        return ResultEntity.successWithData();
    }


    @RequestMapping("/customer/save.html")
    public String saveTran(Model model, String customerId) {
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
        return "workbench/customer/save";
    }

    @ResponseBody
    @RequestMapping("/customer/detail/concat/add.json")
    public ResultEntity<Contacts> addContacts(Contacts contacts, HttpSession session) {
        try {
            User user = (User) session.getAttribute("user");
            contacts.setId(UUIDUtils.getUUID());
            contacts.setCreateBy(user.getId());
            contacts.setCreateTime(DateUtils.formateDateTime(new Date()));
            contactsService.saveContacts(contacts);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }

        return ResultEntity.successWithData(contacts);
    }

    @ResponseBody
    @RequestMapping("/customer/contacts/id/delete.json")
    public ResultEntity<String> deleteContacts(String id) {
        contactsService.deleteContacts(id);
        return ResultEntity.successWithData();
    }

    @RequestMapping("/contacts/detail.html")
    public String contactsDetail(String id, Model model) {
        Contacts contacts = contactsService.getContactsByKeyId(id);
        List<ContactsRemark> remarkList = contactsService.getContactsRemark(id);
        List<Tran> tranList = tranService.getTranByContactsId(id);
        Contacts contacts2 = contactsService.getContactsRealy(id);
        List<ClueRemark> clueRemarkList = clueRemarkService.getClueRemarkById(id);
        List<Activity> clueActivityRelationList =
                clueRemarkService.getClueActivityRelationByClueId(id);

        model.addAttribute("clue", clueService.getClue(id));
        model.addAttribute("clueRemarkList", clueRemarkList);
        model.addAttribute("relationList", clueActivityRelationList);
        model.addAttribute("contacts", contacts);
        model.addAttribute("remarkList", remarkList);
        model.addAttribute("tranList",tranList);
        model.addAttribute("contacts2",contacts2);
        return "workbench/contacts/detail";
    }

}
