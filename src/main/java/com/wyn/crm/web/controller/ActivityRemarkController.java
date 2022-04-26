package com.wyn.crm.web.controller;

import com.sun.org.apache.regexp.internal.RE;
import com.wyn.crm.entity.ActivityRemark;
import com.wyn.crm.entity.User;
import com.wyn.crm.service.api.ActivityRemarkService;
import com.wyn.crm.utils.CrmConstant;
import com.wyn.crm.utils.DateUtils;
import com.wyn.crm.utils.ResultEntity;
import com.wyn.crm.utils.UUIDUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/21
 */
@Controller
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;


    @ResponseBody
    @RequestMapping("/activity/detail/add.json")
    public ResultEntity<ActivityRemark> addActivityRemark(ActivityRemark activityRemark, HttpSession session){

        try {
        User user = (User) session.getAttribute("user");
        activityRemark.setCreateTime(DateUtils.formateDateTime(new Date()));
        activityRemark.setId(UUIDUtils.getUUID());
        activityRemark.setCreateBy(user.getId());
        activityRemark.setEditFlag(CrmConstant.REMARK_EDIT_FLAG_NO);

            activityRemarkService.addActivityRemarkById(activityRemark);

        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }

        System.out.println(activityRemark.toString());
        return ResultEntity.successWithData(activityRemark);
    }


    @ResponseBody
    @RequestMapping("/activity/detail/remark/delete.json")
    public ResultEntity<String> deleteRemark(@RequestParam("id") String id){
        /*System.out.println(id);*/
        try {
            activityRemarkService.deleteActivityRemarkById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }
        return ResultEntity.successWithData();
    }


    @ResponseBody
    @RequestMapping("/activity/remark/update.json")
    public ResultEntity<ActivityRemark> updateRemark(ActivityRemark activityRemark,HttpSession session){
        try {
            User user = (User) session.getAttribute("user");
            activityRemark.setEditBy(user.getId());
            activityRemark.setEditTime(DateUtils.formateDateTime(new Date()));
            activityRemark.setEditFlag(CrmConstant.REMARK_EDIT_FLAG_YES);

            int i = activityRemarkService.updateActivityRemarkById(activityRemark);

        } catch (Exception e) {
            e.printStackTrace();
            return ResultEntity.failed(CrmConstant.SYSTEM_IS_BUSY);
        }

        return ResultEntity.successWithData(activityRemark);
    }



}
