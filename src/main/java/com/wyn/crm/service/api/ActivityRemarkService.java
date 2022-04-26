package com.wyn.crm.service.api;

import com.wyn.crm.entity.ActivityRemark;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/21
 */
public interface ActivityRemarkService {


    Integer addActivityRemarkById(ActivityRemark activityRemark);

    List<ActivityRemark> getOneById(String id);

    Integer deleteActivityRemarkById(String ids);

    int updateActivityRemarkById(ActivityRemark activityRemark);

}
