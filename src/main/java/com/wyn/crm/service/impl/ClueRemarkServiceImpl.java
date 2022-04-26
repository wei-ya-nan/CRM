package com.wyn.crm.service.impl;

import com.wyn.crm.entity.Activity;
import com.wyn.crm.entity.ClueActivityRelation;
import com.wyn.crm.entity.ClueActivityRelationExample;
import com.wyn.crm.entity.ClueRemark;
import com.wyn.crm.mapper.ActivityMapper;
import com.wyn.crm.mapper.ClueActivityRelationMapper;
import com.wyn.crm.mapper.ClueRemarkMapper;
import com.wyn.crm.service.api.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/23
 */
@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private ActivityMapper activityMapper;

    public int saveClueRemark(ClueRemark clueRemark) {
        int i = clueRemarkMapper.insertSelective(clueRemark);
        return i;
    }

    public List<ClueRemark> getAllClueRemark() {
        List<ClueRemark> clueRemarks = clueRemarkMapper.selectByExample(null);
        return clueRemarks;
    }

    public List<ClueRemark> getClueRemarkById(String id) {
        List<ClueRemark> clueRemarkList =  clueRemarkMapper.getClueRemarkList(id);
        return clueRemarkList;
    }

    public int updateClue(ClueRemark clueRemark) {
        int i = clueRemarkMapper.updateByPrimaryKeySelective(clueRemark);
        return i;
    }

    public int deleteClueRemark(String id) {
        int i = clueRemarkMapper.deleteByPrimaryKey(id);
        return i;
    }

    public List<Activity> getClueActivityRelationByClueId(String id) {
        List<Activity> list = activityMapper.getActivityByRelationClueId(id);
        return list;
    }
}
