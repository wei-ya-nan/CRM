package com.wyn.crm.service.impl;


import com.wyn.crm.entity.ActivityRemark;
import com.wyn.crm.entity.ActivityRemarkExample;
import com.wyn.crm.mapper.ActivityRemarkMapper;
import com.wyn.crm.service.api.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/21
 */
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {


    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;

    public Integer addActivityRemarkById(ActivityRemark activityRemark) {
        int i = activityRemarkMapper.insert(activityRemark);
        return i;
    }

    public List<ActivityRemark> getOneById(String id) {
        List<ActivityRemark> remark = activityRemarkMapper.getActivityRemarkById(id);
        return remark;
    }

    public Integer deleteActivityRemarkById(String id) {
        /*ActivityRemarkExample activityRemarkExample = new ActivityRemarkExample();
        ActivityRemarkExample.Criteria criteria = activityRemarkExample.createCriteria();
        criteria.andIdIn(ids);*/
        int i = activityRemarkMapper.deleteByPrimaryKey(id);
        return i;
    }

    public int updateActivityRemarkById(ActivityRemark activityRemark) {
        int i = activityRemarkMapper.updateByPrimaryKeySelective(activityRemark);
        return i;
    }


}
