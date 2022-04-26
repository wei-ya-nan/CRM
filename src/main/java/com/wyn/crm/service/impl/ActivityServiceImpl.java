package com.wyn.crm.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.Activity;
import com.wyn.crm.entity.ActivityExample;
import com.wyn.crm.mapper.ActivityMapper;
import com.wyn.crm.service.api.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/18
 */
@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    public int addActivity(Activity activity) {
        return activityMapper.insert(activity);
    }


    public PageInfo<Activity> getActivityPage(String keyword, Integer pageNum, Integer pageSize, String owner,
                                              String startDate, String endDate) {
        PageHelper.startPage(pageNum, pageSize);
        List<Activity> pages = activityMapper.getActivityPageInfo(keyword, owner, startDate, endDate);

        return new PageInfo<Activity>(pages, 5);
    }

    public List<Activity> getActivityAll() {
        return activityMapper.selectByExample(null);
    }

    public void deleteActivity(List<String> ids) {
        ActivityExample activityExample = new ActivityExample();
        ActivityExample.Criteria criteria = activityExample.createCriteria();
        criteria.andIdIn(ids);
        activityMapper.deleteByExample(activityExample);


    }

    public void updateActivity(Activity activity) {
        int i = activityMapper.updateByPrimaryKeySelective(activity);
        System.out.println(i);
    }

    public Activity getActivityOne(String id) {
        /*ActivityExample activityExample = new ActivityExample();
        ActivityExample.Criteria criteria = activityExample.createCriteria();
        criteria.andIdEqualTo(id);*/
        Activity activity = activityMapper.selectByPrimaryKey(id);

        return activity;
    }

    public void addActivityList(List<Activity> list) {
        activityMapper.insertBatchActivity(list);
    }

    public List<Activity> getActivityMoreByIds(List<String> id) {
        ActivityExample activityExample = new ActivityExample();
        ActivityExample.Criteria criteria = activityExample.createCriteria();
        criteria.andIdIn(id);
        List<Activity> list = activityMapper.selectByExample(activityExample);

        return list;
    }

    public Activity getActivityOneById(String id) {
        Activity activity = activityMapper.getActivityById(id);
        return activity;
    }

    public List<Activity> getActivityBindPage() {
        List<Activity> list = activityMapper.getActivityForBindPage();

        return null;
    }

    public List<Activity> getActivityClueIdAndNameLike(String name, String clueId) {
//        ActivityExample activityExample = new ActivityExample();
//        ActivityExample.Criteria criteria = activityExample.createCriteria();
//        criteria.andNameLike(name);
//        List<Activity> list = activityMapper.selectByExample(activityExample);

        List<Activity> list = activityMapper.getActivityByLikeNameAndClueIdForPage(name,clueId);
        return list;
    }

    public List<Activity> getActivityByNameLike(String name) {
      List<Activity> list = activityMapper.getActivityByLikeName(name);
        return list;
    }


}
