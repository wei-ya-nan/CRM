package com.wyn.crm.service.impl;

import com.wyn.crm.entity.ClueActivityRelation;
import com.wyn.crm.entity.ClueActivityRelationExample;
import com.wyn.crm.mapper.ClueActivityRelationMapper;
import com.wyn.crm.service.api.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/24
 */
@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationMapper relationMapper;


    public int saveRelation(List<ClueActivityRelation> list) {

        int i = relationMapper.saveRelationByTwoId(list);
        return i;
    }

    public int deleteRelation(ClueActivityRelation relation) {
        ClueActivityRelationExample example = new ClueActivityRelationExample();
        ClueActivityRelationExample.Criteria criteria = example.createCriteria();
        criteria.andClueIdEqualTo(relation.getClueId());
        criteria.andActivityIdEqualTo(relation.getActivityId());
        return relationMapper.deleteByExample(example);

    }
}
