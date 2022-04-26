package com.wyn.crm.mapper;


import com.wyn.crm.entity.Activity;
import com.wyn.crm.entity.ActivityExample;
import com.wyn.crm.entity.ClueRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ActivityMapper {
    int countByExample(ActivityExample example);

    int deleteByExample(ActivityExample example);

    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    List<Activity> selectByExample(ActivityExample example);

    Activity selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") Activity record, @Param("example") ActivityExample example);

    int updateByExample(@Param("record") Activity record, @Param("example") ActivityExample example);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);

    List<Activity> getActivityPageInfo(@Param("keyword")String keyword,@Param("owner")String owner,@Param(
            "startDate")String startDate,@Param("endDate")String endDate);

    int insertBatchActivity(@Param("list") List<Activity> list);

    Activity getActivityById(String id);

    List<Activity> getActivityByRelationClueId(String id);

    List<Activity> getActivityForBindPage();

    List<Activity> getActivityByLikeNameAndClueIdForPage(@Param("name")String name,
                                                         @Param("clueId") String clueId);

    List<Activity> getActivityByLikeName(String name);
}