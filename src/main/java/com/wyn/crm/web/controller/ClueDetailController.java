package com.wyn.crm.web.controller;

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
import java.util.*;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/23
 */
@Controller
public class ClueDetailController {
    @Autowired
    private ClueService clueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ClueActivityRelationService relationService;

    @Autowired
    private DicValueService dicValueService;


    @RequestMapping("/clue/detail.html")
    public String ClueDetailIndex(String id, Model model) {
        model.addAttribute("clue", clueService.getClue(id));
        /*   根据clue的id来获得clue的id 在根据这个id通过clue_activity_clue_relation的表
         * 来获得activity的属性，就是市场的关联
         * */
        List<ClueRemark> clueRemarkList = clueRemarkService.getClueRemarkById(id);
        List<Activity> clueActivityRelationList =
                clueRemarkService.getClueActivityRelationByClueId(id);

        System.out.println(clueService.getClue(id).toString());
        model.addAttribute("clueRemarkList", clueRemarkList);
        model.addAttribute("relationList", clueActivityRelationList);

        return "workbench/clue/detail";
    }

    @ResponseBody
    @RequestMapping("/clue/detail/clueRemark/save.json")
    public ResultEntity<ClueRemark> ClueSave(HttpSession session, ClueRemark clueRemark) {
        try {
            User user = (User) session.getAttribute("user");
            clueRemark.setId(UUIDUtils.getUUID());
            clueRemark.setCreateBy(user.getId());
            clueRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
            clueRemark.setEditFlag(CrmConstant.REMARK_EDIT_FLAG_NO);

            int i = clueRemarkService.saveClueRemark(clueRemark);
            if (i <= 0) {
                return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }

        return ResultEntity.successWithData(clueRemark);
    }

    @ResponseBody
    @RequestMapping("/clue/remark/update.json")
    public ResultEntity<ClueRemark> ClueUpdate(ClueRemark clueRemark, HttpSession session) {
        try {
            clueRemark.setEditFlag(CrmConstant.REMARK_EDIT_FLAG_YES);
            clueRemark.setEditTime(DateUtils.formateDateTime(new Date()));
            User user = (User) session.getAttribute("user");

            clueRemark.setEditBy(user.getId());
            int i = clueRemarkService.updateClue(clueRemark);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }

        return ResultEntity.successWithData(clueRemark);
    }

    @ResponseBody
    @RequestMapping("/clue/detail/remark/delete.json")
    public ResultEntity<String> deleteClueRemark(String id) {
//        System.out.println(id);
        int i = clueRemarkService.deleteClueRemark(id);
        if (i <= 0) {
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }
        return ResultEntity.successWithData();

    }

    @ResponseBody
    @RequestMapping("/clue/remark/activity/bind/page.json")
    public ResultEntity<List<Activity>> bindPage() {
        List<Activity> list = activityService.getActivityBindPage();
        return ResultEntity.successWithData();
    }

    @ResponseBody
    @RequestMapping("/clue/query/relation/page/like.json")
    public ResultEntity<List<Activity>> pageLike(String name, String clueId) {

        List<Activity> list = null;
        if (!"".equals(name)) {
            list = activityService.getActivityClueIdAndNameLike(name, clueId);
        }

        return ResultEntity.successWithData(list);
    }
    @ResponseBody
    @RequestMapping("/clue/query/convert.json")
    public ResultEntity<List<Activity>> convertActivityPage(String activityName,String clueId){
        List<Activity> list = null;
        if (!"".equals(activityName)) {
            list = activityService.getActivityClueIdAndNameLike(activityName, clueId);
        }
        return ResultEntity.successWithData(list);
    }


    @ResponseBody
    @RequestMapping("/clue/activity/relation/bind.json")
    public ResultEntity<List<Activity>> bindRelation(@RequestParam("id") List<String> id,
                                                     @RequestParam("clueId") String clueId) {
        // 特别注意的是ajax的id是一个数组，当前端用List接受需要加一个RequestParam

        List<ClueActivityRelation> list = new ArrayList<ClueActivityRelation>();
        List<Activity> relationList = new ArrayList<Activity>();
        try {
            ClueActivityRelation relation = null;

            for (int i = 0; i < id.size(); i++) {
                relation = new ClueActivityRelation();
                relation.setId(UUIDUtils.getUUID());
                relation.setActivityId(id.get(i));
                relation.setClueId(clueId);
                list.add(relation);
            }

            int i = relationService.saveRelation(list);
            relationList =
                    clueRemarkService.getClueActivityRelationByClueId(clueId);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }
        return ResultEntity.successWithData(relationList);
    }

    @ResponseBody
    @RequestMapping("/clue/relation/delete.json")
    public ResultEntity<String> deleteRelation(ClueActivityRelation  relation){
        int i = relationService.deleteRelation(relation);
        if(i<=0){
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }
        return ResultEntity.successWithData();
    }

    @RequestMapping("/convert.html")
    public String convertIndex(@RequestParam("id") String id,Model model){
        System.out.println(id);
        Clue clue = clueService.getClue(id);
        List<DicValue> stages = dicValueService.queryDicValueByTypeCode("stage");
        model.addAttribute("stages",stages);
        model.addAttribute("clue",clue);
        return "workbench/clue/convert";

    }

    @ResponseBody
    @RequestMapping("/clue/convert.json")
    public ResultEntity<String> convert(String clueId,String activityId,String money,String name,
                                        String expectDate,String stage,HttpSession session,String isCreateTransaction){
        User user = (User)session.getAttribute("user");
        Map map = new HashMap<String, Object>();
        map.put("clueId", clueId);
        map.put("money", clueId);
        map.put("name", clueId);
        map.put("expectDate", clueId);
        map.put("stage", clueId);
        map.put("isCreateTransaction",isCreateTransaction);
        map.put("user",session.getAttribute("user"));
        try {
            clueService.addClueConvert(map);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }

        return ResultEntity.successWithData();
    }



}
