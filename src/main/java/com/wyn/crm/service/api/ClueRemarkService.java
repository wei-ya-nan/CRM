package com.wyn.crm.service.api;

import com.wyn.crm.entity.Activity;
import com.wyn.crm.entity.ClueActivityRelation;
import com.wyn.crm.entity.ClueRemark;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/23
 */
public interface ClueRemarkService {
    int saveClueRemark(ClueRemark clueRemark);

    List<ClueRemark> getAllClueRemark();

    List<ClueRemark> getClueRemarkById(String id);

    int updateClue(ClueRemark clueRemark);

    int deleteClueRemark(String id);

    List<Activity> getClueActivityRelationByClueId(String id);
}
