package com.wyn.crm.mapper;


import com.wyn.crm.entity.ActivityRemark;
import com.wyn.crm.entity.ActivityRemarkExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ActivityRemarkMapper {
    int countByExample(ActivityRemarkExample example);

    int deleteByExample(ActivityRemarkExample example);

    int deleteByPrimaryKey(String id);

    int insert(ActivityRemark record);

    int insertSelective(ActivityRemark record);

    List<ActivityRemark> selectByExample(ActivityRemarkExample example);

    ActivityRemark selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") ActivityRemark record,
                                 @Param("example") ActivityRemarkExample example);

    int updateByExample(@Param("record") ActivityRemark record, @Param("example") ActivityRemarkExample example);

    int updateByPrimaryKeySelective(ActivityRemark record);

    int updateByPrimaryKey(ActivityRemark record);

    List<ActivityRemark> getActivityRemarkById(String id);
}