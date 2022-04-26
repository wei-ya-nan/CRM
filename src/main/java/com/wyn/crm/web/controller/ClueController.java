package com.wyn.crm.web.controller;

import com.github.pagehelper.PageInfo;
import com.sun.javadoc.SeeTag;
import com.wyn.crm.entity.Clue;
import com.wyn.crm.entity.User;
import com.wyn.crm.service.api.ClueService;
import com.wyn.crm.service.api.UserService;
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
 * @date 2022/4/22
 */
@Controller
public class ClueController {

    @Autowired
    private UserService userService;

    @Autowired
    private ClueService clueService;


    @RequestMapping("/clue/index.html")
    public String clueIndex(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("userList", users);
        return "workbench/clue/index";
    }

    @ResponseBody
    @RequestMapping("/clue/condition/page.json")
    public ResultEntity<PageInfo<Clue>> page(Clue clue, Integer pageNo, Integer pageSize) {
        PageInfo<Clue> page = clueService.getClueConditionPage(clue, pageNo, pageSize);
        return ResultEntity.successWithData(page);
    }

    @ResponseBody
    @RequestMapping("/clue/add.json")
    public ResultEntity<String> addClue(Clue clue, HttpSession session) {
        User user =(User)session.getAttribute("user");
        clue.setCreateBy(user.getId());
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateTime(DateUtils.formateDateTime(new Date()));
        System.out.println(clue);
        int i = clueService.addClue(clue);
        if (i <= 0) {
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }

        return ResultEntity.successWithData();
    }

    @ResponseBody
    @RequestMapping("/clue/get/id/queryOne.json")
    public ResultEntity<Clue> updateClueForQueryById(String id){
        System.out.println(id);
        Clue clue = clueService.getClue(id);
        return ResultEntity.successWithData(clue);
    }

    @ResponseBody
    @RequestMapping("/clue/update/commit/updateSave.json")
    public ResultEntity<String> updateClue(Clue clue,HttpSession session){

        try {
            User user = (User) session.getAttribute("user");
            clue.setEditBy(user.getId());
            clue.setEditTime(DateUtils.formateDateTime(new Date()));
            clueService.updateClue(clue);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }
        return ResultEntity.successWithData();
    }

    @ResponseBody
    @RequestMapping("/clue/more/delete.json")
    public ResultEntity<String> deleteClue(@RequestParam("id") List<String> id){
        System.out.println(id.toString());
        clueService.deleteClueInIdList(id);
        return ResultEntity.successWithData();
    }



}
