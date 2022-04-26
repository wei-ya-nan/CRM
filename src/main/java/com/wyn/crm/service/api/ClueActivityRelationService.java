package com.wyn.crm.service.api;

import com.wyn.crm.entity.ClueActivityRelation;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/24
 */
public interface ClueActivityRelationService {
    int saveRelation(List<ClueActivityRelation> list);

    int deleteRelation(ClueActivityRelation relation);
}
