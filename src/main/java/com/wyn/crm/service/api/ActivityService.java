package com.wyn.crm.service.api;

import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.Activity;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/18
 */
public interface ActivityService {
    int addActivity(Activity activity);

    PageInfo<Activity> getActivityPage(String keyword, Integer pageNum, Integer pageSize,String owner,
                                       String startDate,String endDate);

    List<Activity> getActivityAll();

    void deleteActivity(List<String> ids);

    void updateActivity(Activity activity);

    Activity getActivityOne(String id);

    void addActivityList(List<Activity> list);

    List<Activity> getActivityMoreByIds(List<String> id);

    Activity getActivityOneById(String id);

    List<Activity> getActivityBindPage();

    List<Activity> getActivityClueIdAndNameLike(String name, String clueId);

    List<Activity> getActivityByNameLike(String name);
}
