package com.wyn.crm.web.controller;

import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.*;
import com.wyn.crm.service.api.*;
import com.wyn.crm.utils.CrmConstant;
import com.wyn.crm.utils.DateUtils;
import com.wyn.crm.utils.ResultEntity;
import com.wyn.crm.utils.UUIDUtils;
import org.apache.logging.log4j.core.util.UuidUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/26
 */
@Controller
public class TranController {
    @Autowired
    private TranHistoryService tranHistoryService;

    @Autowired
    private TranService tranService;

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

    @Autowired
    private TranRemarkService tranRemarkService;


    @RequestMapping("/transaction/index.html")
    public String DivIndex(Model model) {
        //调用service层方法，查询动态数据
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<Tran> list = tranService.getAllTran();
        model.addAttribute("stageList", stageList);
        model.addAttribute("transactionTypeList", transactionTypeList);
        model.addAttribute("sourceList", sourceList);
        model.addAttribute("tranList", list);
        return "workbench/transaction/index";
    }

    @RequestMapping("/transaction/save.html")
    public String saveTran(Model model,String customerId) {
        List<User> users = userService.getAllUsers();
        System.out.println(customerId);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        model.addAttribute("stageList", stageList);
        model.addAttribute("transactionTypeList", transactionTypeList);
        model.addAttribute("sourceList", sourceList);
        model.addAttribute("users", users);
        model.addAttribute("customerId",customerId);
        return "workbench/transaction/save";
    }

    @ResponseBody
    @RequestMapping("/transaction/contacts/query.json")
    public ResultEntity<List<Contacts>> queryContacts(@RequestParam("fullname") String fullname) {
        List<Contacts> contactsList = new ArrayList<Contacts>();
        if (fullname != "" || fullname != null) {
            contactsList = contactsService.getContactsForLikeName(fullname);
        }
        return ResultEntity.successWithData(contactsList);
    }

    @ResponseBody
    @RequestMapping("/transaction/activity/query.json")
    public ResultEntity<List<Activity>> queryActivity(@RequestParam("name") String name) {
        List<Activity> list = new ArrayList<Activity>();
        if (name != "" || name != null) {
            list = activityService.getActivityByNameLike(name);
        }
        return ResultEntity.successWithData(list);
    }

    @ResponseBody
    @RequestMapping("/transaction/queryCustomer/auto.json")
    public ResultEntity<List<String>> queryCustomerAutoName(String customerName) {
//        System.out.println(customerName);
        // 调用service方法通过模糊查询返回客户customer 的名字集合
        List<String> list = customerService.queryNameByLikeForAuto(customerName);
        return ResultEntity.successWithData(list);
    }

    @ResponseBody
    @RequestMapping("/transaction/createTran/add.json")
    public ResultEntity<String> createTran(Tran tran, HttpSession session, String customerName) {
        User user = (User) session.getAttribute("user");
        tran.setCreateBy(user.getId());
        tran.setId(UUIDUtils.getUUID());
        tran.setCreateTime(DateUtils.formateDateTime(new Date()));
        tranService.addTran(tran, user, customerName);
        return ResultEntity.successWithData();
    }

    @ResponseBody
    @RequestMapping("/transaction/index/page.json")
    public ResultEntity<PageInfo<Tran>> indexPage(@RequestParam Map<String, Object> map) {

        PageInfo<Tran> page = tranService.getTranPageByCondition(map);
        return ResultEntity.successWithData(page);
    }


    @RequestMapping("/transaction/detail.html")
    public String detail(String id, Model model) {
        Tran tran = tranService.getTranById(id);
        //根据tran所处阶段名称查询可能性
        ResourceBundle bundle=ResourceBundle.getBundle("possibility",new Locale("zh","CN"));
        String possibility=bundle.getString(tran.getStage());
        tran.setPossibility(possibility);

        List<TranHistory> list = tranHistoryService.getAll();
        List<TranRemark> remarkList = tranRemarkService.getAll();


        model.addAttribute("history",list);
        model.addAttribute("tran", tran);
        model.addAttribute("remark",remarkList);


        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        model.addAttribute("stageList",stage);
        return "workbench/transaction/detail";

    }

    @ResponseBody
    @RequestMapping("/transaction/detail/add.json")
    public ResultEntity<TranRemark> addRemark(TranRemark tranRemark,HttpSession session){
        try {
            User user = (User) session.getAttribute("user");
            tranRemark.setCreateBy(user.getId());
            tranRemark.setId(UUIDUtils.getUUID());
            tranRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
            tranRemark.setEditFlag(CrmConstant.REMARK_EDIT_FLAG_NO);
            tranRemarkService.addRemark(tranRemark);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }

        return ResultEntity.successWithData(tranRemark);
    }
    @ResponseBody
    @RequestMapping("/transaction/remark/update.json")
    public ResultEntity<TranRemark> updateRemark(TranRemark tranRemark,HttpSession session){
        try {
            User user = (User) session.getAttribute("user");
            tranRemark.setEditBy(user.getId());
            tranRemark.setEditTime(DateUtils.formateDateTime(new Date()));
            tranRemark.setEditFlag(CrmConstant.REMARK_EDIT_FLAG_YES);
            tranRemarkService.updateRemark(tranRemark);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }
        return ResultEntity.successWithData(tranRemark);
    }

    @ResponseBody
    @RequestMapping("/transaction/detail/remark/delete.json")
    public ResultEntity<String> deleteRemark(String id){
        tranRemarkService.deleteRemark(id);
        return ResultEntity.successWithData();
    }


    @RequestMapping("/transaction/edit.html")
    public String toEdit(String id,Model model){
        List<User> users = userService.getAllUsers();
        Tran tran = tranService.getTranById(id);
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("stage");
        model.addAttribute("tran",tran);
        model.addAttribute("users",users);
        model.addAttribute("stages",stage);
        return "workbench/transaction/edit";
    }
    @ResponseBody
    @RequestMapping("/transaction/updateTran/update.json")
    public ResultEntity<String> updateTran(Tran tran){
        System.out.println(tran.toString());
        tranService.updateTran(tran);
        return ResultEntity.successWithData();
    }

    @ResponseBody
    @RequestMapping("/transaction/more/delete.json")
    public ResultEntity<String> deleteTran(@RequestParam("id")List<String> id){
        System.out.println(id.toString());
        tranService.deleteTran(id);
        return ResultEntity.successWithData();
    }



}
